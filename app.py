from flask import Flask, render_template, request, redirect, url_for, jsonify
import mysql.connector

app = Flask(__name__)

# --- Database Connection ---
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="YOUR_DB_PASSWORD_HERE",
    database="CT_DBS"
)

# --- Image Assets ---
TEAM_FLAGS = {
    "IND": "https://upload.wikimedia.org/wikipedia/en/4/41/Flag_of_India.svg",
    "AUS": "https://upload.wikimedia.org/wikipedia/commons/b/b9/Flag_of_Australia.svg",
    "ENG": "https://upload.wikimedia.org/wikipedia/en/b/be/Flag_of_England.svg",
    "SA": "https://upload.wikimedia.org/wikipedia/commons/a/af/Flag_of_South_Africa.svg",
    "NZ": "https://upload.wikimedia.org/wikipedia/commons/3/3e/Flag_of_New_Zealand.svg",
    "PAK": "https://upload.wikimedia.org/wikipedia/commons/3/32/Flag_of_Pakistan.svg",
    "SL": "https://upload.wikimedia.org/wikipedia/commons/1/11/Flag_of_Sri_Lanka.svg",
    "AFG": "https://upload.wikimedia.org/wikipedia/commons/c/cd/Flag_of_Afghanistan_%282013%E2%80%932021%29.svg",
}

# Map Stadium IDs to their Host Country's Team ID
STADIUM_COUNTRIES = {
    "ST001": "IND", # Wankhede -> India
    "ST002": "IND", # Chinnaswamy -> India
    "ST003": "AUS", # MCG -> Australia
    "ST004": "ENG", # Lords -> England
    "ST005": "SA",  # Newlands -> South Africa
    "ST006": "NZ",  # Eden Park -> New Zealand
    "ST007": "PAK", # Gaddafi -> Pakistan
    "ST008": "SL",  # Premadasa -> Sri Lanka
}

GENERIC_CRICKET_BG = "https://upload.wikimedia.org/wikipedia/commons/9/9b/Cricket_ball_on_pitch.jpg"

@app.context_processor
def utility_processor():
    def get_card_background(category, entity_id):
        if category == 'player' or category == 'team':
            # For players and teams, return the flag based on Team ID
            return TEAM_FLAGS.get(entity_id, GENERIC_CRICKET_BG)
        elif category == 'stadium':
            # For stadiums, return the host country's flag
            country_id = STADIUM_COUNTRIES.get(entity_id)
            if country_id:
                return TEAM_FLAGS.get(country_id, GENERIC_CRICKET_BG)
        
        return GENERIC_CRICKET_BG
    return dict(get_card_background=get_card_background)

# =====================================================================
# PUBLIC-FACING ROUTES
# =====================================================================

@app.route("/")
def index():
    cursor = mydb.cursor(dictionary=True)
    cursor.execute("SELECT * FROM player")
    players = cursor.fetchall()
    cursor.execute("SELECT * FROM team")
    teams = cursor.fetchall()
    cursor.execute("SELECT * FROM matches")
    matches = cursor.fetchall()
    cursor.execute("SELECT * FROM Stadium")
    stadiums = cursor.fetchall()
    cursor.close()
    return render_template("index.html", players=players, teams=teams, matches=matches, stadiums=stadiums)

@app.route('/player/<player_id>')
def player(player_id):
    cursor = mydb.cursor(dictionary=True)
    query = "SELECT p.*, t.team_name FROM Player p LEFT JOIN Team t ON p.team_id = t.team_id WHERE p.player_id = %s"
    cursor.execute(query, (player_id,))
    player_data = cursor.fetchone()
    cursor.close()
    return render_template('player.html', player=player_data)

@app.route('/team/<team_id>')
def team(team_id):
    cursor = mydb.cursor(dictionary=True)
    query = """
        SELECT t.team_id, t.team_name AS country_name, t.team_ranking, t.team_group, c.coach_name, p.player_name AS captain_name
        FROM Team t
        LEFT JOIN Coach c ON t.team_id = c.team_id
        LEFT JOIN Captain cap ON t.team_id = cap.team_id
        LEFT JOIN Player p ON cap.captain_id = p.player_id
        WHERE t.team_id = %s
    """
    cursor.execute(query, (team_id,))
    team_data = cursor.fetchone()
    cursor.close()
    return render_template('team.html', team=team_data)

@app.route("/match/<int:match_id>")
def match(match_id):
    cursor = mydb.cursor(dictionary=True)
    query = """
        SELECT m.match_id, m.match_date, t1.team_name AS team_1_name, t2.team_name AS team_2_name, w.team_name AS winner,
               u.umpire_name, s.stadium_name AS venue
        FROM Matches m
        LEFT JOIN Team t1 ON m.team_1_id = t1.team_id
        LEFT JOIN Team t2 ON m.team_2_id = t2.team_id
        LEFT JOIN Team w ON m.winner = w.team_id
        LEFT JOIN Umpire u ON m.ump_id = u.umpire_id
        LEFT JOIN Plays p ON m.match_id = p.match_id
        LEFT JOIN Stadium s ON p.stadium_id = s.stadium_id
        WHERE m.match_id = %s LIMIT 1
    """
    cursor.execute(query, (match_id,))
    match_details = cursor.fetchone()
    cursor.close()
    return render_template("match.html", match=match_details)

@app.route('/stadium/<stadium_id>')
def stadium(stadium_id):
    cursor = mydb.cursor(dictionary=True)
    query = "SELECT DISTINCT m.match_id, m.match_date FROM Matches m JOIN Plays p ON m.match_id = p.match_id WHERE p.stadium_id = %s"
    cursor.execute(query, (stadium_id,))
    matches_data = cursor.fetchall()
    cursor.close()
    return render_template('stadium.html', stadium_id=stadium_id, matches=matches_data)

# =====================================================================
# ADMIN AUTHENTICATION & DASHBOARD
# =====================================================================

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username, password = request.form["username"], request.form["password"]
        cursor = mydb.cursor(dictionary=True)
        cursor.execute("SELECT * FROM admin WHERE user_id = %s AND password = %s", (username, password))
        if cursor.fetchone():
            return redirect(url_for("admin"))
        return render_template("login.html", error="Invalid username or password")
    return render_template("login.html")

@app.route("/admin")
def admin():
    cursor = mydb.cursor(dictionary=True)
    cursor.execute("SELECT team_id, team_name FROM team")
    teams = cursor.fetchall()
    cursor.execute("SELECT umpire_id, umpire_name FROM umpire")
    umpires = cursor.fetchall()
    cursor.execute("SELECT stadium_id, stadium_name FROM stadium")
    stadiums = cursor.fetchall()
    cursor.close()
    preloaded_data = {"teams": teams, "umpires": umpires, "stadiums": stadiums}
    return render_template("admin.html", preloaded_data=preloaded_data)

# =====================================================================
# API ENDPOINTS FOR DYNAMIC ADMIN DASHBOARD
# =====================================================================

# --- Players API ---
@app.route('/api/players', methods=['GET'])
def get_players():
    cursor = mydb.cursor(dictionary=True)
    cursor.execute("SELECT * FROM player ORDER BY player_name")
    return jsonify(cursor.fetchall())

@app.route('/api/player/add', methods=['POST'])
def add_player():
    try:
        form = request.form
        cursor = mydb.cursor()
        cursor.execute("INSERT INTO player (player_id, player_name, team_id, player_role, bat, bowl) VALUES (%s, %s, %s, %s, %s, %s)",
                       (form['player_id'], form['player_name'], form['team_id'], form['player_role'], form['bat'], form['bowl']))
        mydb.commit()
        return jsonify({"success": True, "message": "Player added."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

@app.route('/api/player/update', methods=['POST'])
def update_player():
    try:
        form = request.form
        cursor = mydb.cursor()
        cursor.execute("UPDATE player SET player_name=%s, team_id=%s, player_role=%s, bat=%s, bowl=%s WHERE player_id=%s",
                       (form['player_name'], form['team_id'], form['player_role'], form['bat'], form['bowl'], form['player_id']))
        mydb.commit()
        return jsonify({"success": True, "message": "Player updated."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

@app.route('/api/player/delete', methods=['POST'])
def delete_player():
    try:
        cursor = mydb.cursor()
        cursor.execute("DELETE FROM captain WHERE captain_id = %s", (request.form['player_id'],))
        cursor.execute("DELETE FROM player WHERE player_id = %s", (request.form['player_id'],))
        mydb.commit()
        return jsonify({"success": True, "message": "Player deleted."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

# --- Teams API ---
@app.route('/api/teams', methods=['GET'])
def get_teams():
    cursor = mydb.cursor(dictionary=True)
    cursor.execute("SELECT * FROM team ORDER BY team_name")
    return jsonify(cursor.fetchall())

@app.route('/api/team/add', methods=['POST'])
def add_team():
    try:
        form = request.form
        cursor = mydb.cursor()
        cursor.execute("INSERT INTO team (team_id, team_name, team_ranking, team_group) VALUES (%s, %s, %s, %s)",
                       (form['team_id'], form['team_name'], form['team_ranking'], form['team_group']))
        mydb.commit()
        return jsonify({"success": True, "message": "Team added."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

@app.route('/api/team/update', methods=['POST'])
def update_team():
    try:
        form = request.form
        cursor = mydb.cursor()
        cursor.execute("UPDATE team SET team_name=%s, team_ranking=%s, team_group=%s WHERE team_id=%s",
                       (form['team_name'], form['team_ranking'], form['team_group'], form['team_id']))
        mydb.commit()
        return jsonify({"success": True, "message": "Team updated."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

@app.route('/api/team/delete', methods=['POST'])
def delete_team():
    try:
        cursor = mydb.cursor()
        cursor.execute("DELETE FROM team WHERE team_id = %s", (request.form['team_id'],))
        mydb.commit()
        return jsonify({"success": True, "message": "Team deleted."})
    except mysql.connector.Error as err:
        mydb.rollback()
        if err.errno == 1451:
            return jsonify({"success": False, "message": "Cannot delete: Team is referenced by other records."}), 400
        return jsonify({"success": False, "message": str(err)}), 500

# --- Coaches API ---
@app.route('/api/coaches', methods=['GET'])
def get_coaches():
    cursor = mydb.cursor(dictionary=True)
    cursor.execute("SELECT * FROM coach ORDER BY coach_name")
    return jsonify(cursor.fetchall())

@app.route('/api/coach/add', methods=['POST'])
def add_coach():
    try:
        form = request.form
        cursor = mydb.cursor()
        cursor.execute("INSERT INTO coach (coach_id, coach_name, team_id, support_staff_count) VALUES (%s, %s, %s, %s)",
                       (form['coach_id'], form['coach_name'], form['team_id'], form.get('support_staff_count', 0)))
        mydb.commit()
        return jsonify({"success": True, "message": "Coach added."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

@app.route('/api/coach/update', methods=['POST'])
def update_coach():
    try:
        form = request.form
        cursor = mydb.cursor()
        cursor.execute("UPDATE coach SET coach_name=%s, team_id=%s, support_staff_count=%s WHERE coach_id=%s",
                       (form['coach_name'], form['team_id'], form.get('support_staff_count', 0), form['coach_id']))
        mydb.commit()
        return jsonify({"success": True, "message": "Coach updated."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

@app.route('/api/coach/delete', methods=['POST'])
def delete_coach():
    try:
        cursor = mydb.cursor()
        cursor.execute("DELETE FROM coach WHERE coach_id = %s", (request.form['coach_id'],))
        mydb.commit()
        return jsonify({"success": True, "message": "Coach deleted."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

# --- Umpires API ---
@app.route('/api/umpires', methods=['GET'])
def get_umpires():
    cursor = mydb.cursor(dictionary=True)
    cursor.execute("SELECT * FROM umpire ORDER BY umpire_name")
    return jsonify(cursor.fetchall())

@app.route('/api/umpire/add', methods=['POST'])
def add_umpire():
    try:
        form = request.form
        cursor = mydb.cursor()
        cursor.execute("INSERT INTO umpire (umpire_id, umpire_name, country) VALUES (%s, %s, %s)",
                       (form['umpire_id'], form['umpire_name'], form['country']))
        mydb.commit()
        return jsonify({"success": True, "message": "Umpire added."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

@app.route('/api/umpire/update', methods=['POST'])
def update_umpire():
    try:
        form = request.form
        cursor = mydb.cursor()
        cursor.execute("UPDATE umpire SET umpire_name=%s, country=%s WHERE umpire_id=%s",
                       (form['umpire_name'], form['country'], form['umpire_id']))
        mydb.commit()
        return jsonify({"success": True, "message": "Umpire updated."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

@app.route('/api/umpire/delete', methods=['POST'])
def delete_umpire():
    try:
        cursor = mydb.cursor()
        cursor.execute("DELETE FROM umpire WHERE umpire_id = %s", (request.form['umpire_id'],))
        mydb.commit()
        return jsonify({"success": True, "message": "Umpire deleted."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

# --- Matches API ---
@app.route('/api/matches', methods=['GET'])
def get_matches():
    cursor = mydb.cursor(dictionary=True)
    query = """
        SELECT m.*, u.umpire_name, s.stadium_name
        FROM matches m
        LEFT JOIN umpire u ON m.ump_id = u.umpire_id
        LEFT JOIN plays p ON m.match_id = p.match_id
        LEFT JOIN stadium s ON p.stadium_id = s.stadium_id
        ORDER BY m.match_date DESC
    """
    cursor.execute(query)
    return jsonify(cursor.fetchall())

@app.route('/api/match/add', methods=['POST'])
def add_match():
    try:
        form = request.form
        cursor = mydb.cursor()
        cursor.execute("INSERT INTO matches (match_id, team_1_id, team_2_id, ump_id, match_date, match_group, winner) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                       (form['match_id'], form['team_1_id'], form['team_2_id'], form['ump_id'], form['match_date'], form.get('match_group'), form['winner']))
        # Also add to plays table
        cursor.execute("INSERT INTO plays (team_id, match_id, stadium_id) VALUES (%s, %s, %s)", (form['team_1_id'], form['match_id'], form['stadium_id']))
        cursor.execute("INSERT INTO plays (team_id, match_id, stadium_id) VALUES (%s, %s, %s)", (form['team_2_id'], form['match_id'], form['stadium_id']))
        mydb.commit()
        return jsonify({"success": True, "message": "Match added."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

@app.route('/api/match/update', methods=['POST'])
def update_match():
    try:
        form = request.form
        cursor = mydb.cursor()
        cursor.execute("UPDATE matches SET team_1_id=%s, team_2_id=%s, ump_id=%s, match_date=%s, match_group=%s, winner=%s WHERE match_id=%s",
                       (form['team_1_id'], form['team_2_id'], form['ump_id'], form['match_date'], form.get('match_group'), form['winner'], form['match_id']))
        # Also update plays table
        cursor.execute("DELETE FROM plays WHERE match_id = %s", (form['match_id'],))
        cursor.execute("INSERT INTO plays (team_id, match_id, stadium_id) VALUES (%s, %s, %s)", (form['team_1_id'], form['match_id'], form['stadium_id']))
        cursor.execute("INSERT INTO plays (team_id, match_id, stadium_id) VALUES (%s, %s, %s)", (form['team_2_id'], form['match_id'], form['stadium_id']))
        mydb.commit()
        return jsonify({"success": True, "message": "Match updated."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

@app.route('/api/match/delete', methods=['POST'])
def delete_match():
    try:
        cursor = mydb.cursor()
        # Must delete from child table 'plays' first due to foreign key constraint
        cursor.execute("DELETE FROM plays WHERE match_id = %s", (request.form['match_id'],))
        cursor.execute("DELETE FROM matches WHERE match_id = %s", (request.form['match_id'],))
        mydb.commit()
        return jsonify({"success": True, "message": "Match deleted."})
    except mysql.connector.Error as err:
        mydb.rollback()
        return jsonify({"success": False, "message": str(err)}), 500

# =====================================================================
# MAIN EXECUTION
# =====================================================================

if __name__ == "__main__":
    app.run(debug=True, port=3230)