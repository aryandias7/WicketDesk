function showTab(tabName) {
    const tabs = document.getElementsByClassName("tab-content");
    for (let tab of tabs) {
        tab.style.display = "none";
    }
    document.getElementById(tabName).style.display = "block";
}

// Autofill Player form
function editPlayer(playerId, playerName, teamId, playerRole, bat, bowl) {
    document.getElementById('edit-player-id').value = playerId;
    document.getElementById('edit-player-name').value = playerName;
    document.getElementById('edit-team-id').value = teamId;
    document.getElementById('edit-player-role').value = playerRole;
    document.getElementById('edit-bat').value = bat;
    document.getElementById('edit-bowl').value = bowl;
}

// Autofill Team form
function editTeam(teamId, teamName, teamRanking, teamGroup) {
    const form = document.querySelector('form[action="/adminteams/update"]');
    if (form) {
        form.elements['team_id'].value = teamId;
        form.elements['team_name'].value = teamName;
        form.elements['team_ranking'].value = teamRanking;
        form.elements['team_group'].value = teamGroup;
    }
}

function editCoach(coachId, coachName, teamId, staffCount) {
    document.getElementById('edit-coach-id').value = coachId;
    document.getElementById('edit-coach-name').value = coachName;
    document.getElementById('edit-team-id').value = teamId;
    document.getElementById('edit-support-staff-count').value = staffCount;
}


// Autofill Match form
function editMatch(matchId, team1Id, team2Id, matchDate, winnerId, umpireId, stadiumId) {
    const form = document.getElementById("edit-match-form");
    form.elements["match_id"].value = matchId;
    form.elements["team_1_id"].value = team1Id;
    form.elements["team_2_id"].value = team2Id;
    form.elements["match_date"].value = matchDate;
    form.elements["winner"].value = winnerId;
    form.elements["umpire_id"].value = umpireId;
    form.elements["stadium_id"].value = stadiumId;
}


// Autofill Umpire form
function editUmpire(id, name, country) {
    document.getElementById('edit-umpire-id').value = id;
    document.getElementById('edit-umpire-name').value = name;
    document.getElementById('edit-umpire-country').value = country;
}



// Filter type column index
function getIndexByFilterType(filterType) {
    switch (filterType) {
        case 'country': return 1;
        case 'batsmen': return 2;
        case 'bowlers': return 3;
        case 'team1': return 1;
        case 'team2': return 2;
        case 'result': return 3;
        case 'name': return 1;
        case 'matches': return 2;
        default: return 1;
    }
}

// Generic table search
function searchTable(inputId, filterTypeId, tableIndex) {
    const input = document.getElementById(inputId);
    const filterType = document.getElementById(filterTypeId).value;
    const filter = input.value.toUpperCase();
    const table = document.getElementsByTagName("table")[tableIndex];
    const tr = table.getElementsByTagName("tr");
    const index = getIndexByFilterType(filterType);

    for (let i = 1; i < tr.length; i++) {
        const td = tr[i].getElementsByTagName("td")[index];
        if (td) {
            const txtValue = td.textContent || td.innerText;
            tr[i].style.display = txtValue.toUpperCase().includes(filter) ? "" : "none";
        }
    }
}

// Specific search handlers
function searchPlayers() { searchTable("playerSearch", "playerFilter", 0); }
function searchTeams()   { searchTable("teamSearch", "teamFilter", 1); }
function searchMatches() { searchTable("matchSearch", "matchFilter", 2); }
function searchUmpires() { searchTable("umpireSearch", "umpireFilter", 3); }

// Open correct tab from URL hash
document.addEventListener("DOMContentLoaded", function () {
    const hash = window.location.hash.substring(1); // get part after #
    if (hash) {
        showTab(hash);
    } else {
        showTab("players-tab"); // fallback default tab
    }
});

