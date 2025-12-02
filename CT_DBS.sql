
CREATE TABLE admin (
  user_id varchar(12) NOT NULL,
  password varchar(30) NOT NULL,
  PRIMARY KEY (user_id)

);
--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('user1','user1password'),('user2','user2password');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;



CREATE TABLE Player (
    player_id VARCHAR(5) PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    team_id VARCHAR(3),
    player_role VARCHAR(50),
    bat VARCHAR(10),
    bowl VARCHAR(10)
);

CREATE TABLE Captain (
    captain_id VARCHAR(5) PRIMARY KEY,
    team_id VARCHAR(3) UNIQUE,
    wins INT
);

CREATE TABLE Coach (
    coach_id varchar(5)  PRIMARY KEY,
    coach_name VARCHAR(100) NOT NULL,
    team_id VARCHAR(3) UNIQUE,
    support_staff_count INT
);

CREATE TABLE Team (
    team_id VARCHAR(3) PRIMARY KEY,
    team_name VARCHAR(20) NOT NULL,
    team_ranking INT,
    team_group CHAR(1)
);

CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    team_1_id VARCHAR(3),
    team_2_id VARCHAR(3),
    ump_id VARCHAR(5),
    match_date DATE,
    match_group CHAR(1),
    winner VARCHAR(3),
    FOREIGN KEY (winner) REFERENCES Team(team_id)
);

CREATE TABLE Stadium (
    stadium_id VARCHAR(5) PRIMARY KEY,
    stadium_name VARCHAR(100) NOT NULL,
    city VARCHAR(100)
);

CREATE TABLE Plays (
    team_id VARCHAR(3),
    match_id INT,
    stadium_id VARCHAR(5),
    PRIMARY KEY (team_id, match_id, stadium_id)
);

CREATE TABLE Umpire (
    umpire_id VARCHAR(5) PRIMARY KEY,
    umpire_name VARCHAR(100) NOT NULL,
    country VARCHAR(100)
);

-- Add Foreign Key Constraints
ALTER TABLE Player ADD CONSTRAINT fk_player_team FOREIGN KEY (team_id) REFERENCES Team(team_id);
ALTER TABLE Captain ADD CONSTRAINT fk_captain_player FOREIGN KEY (captain_id) REFERENCES Player(player_id);
ALTER TABLE Captain ADD CONSTRAINT fk_captain_team FOREIGN KEY (team_id) REFERENCES Team(team_id);
ALTER TABLE Coach ADD CONSTRAINT fk_coach_team FOREIGN KEY (team_id) REFERENCES Team(team_id);
ALTER TABLE Matches ADD CONSTRAINT fk_matches_team1 FOREIGN KEY (team_1_id) REFERENCES Team(team_id);
ALTER TABLE Matches ADD CONSTRAINT fk_matches_team2 FOREIGN KEY (team_2_id) REFERENCES Team(team_id);
ALTER TABLE Matches ADD CONSTRAINT fk_matches_umpire FOREIGN KEY (ump_id) REFERENCES Umpire(umpire_id);
ALTER TABLE Plays ADD CONSTRAINT fk_plays_team FOREIGN KEY (team_id) REFERENCES Team(team_id);
ALTER TABLE Plays ADD CONSTRAINT fk_plays_match FOREIGN KEY (match_id) REFERENCES Matches(match_id);
ALTER TABLE Plays ADD CONSTRAINT fk_plays_stadium FOREIGN KEY (stadium_id) REFERENCES Stadium(stadium_id);

-- Insert Data into Team Table
INSERT INTO Team VALUES ('IND', 'India', 1, 'B');
INSERT INTO Team VALUES ('AUS', 'Australia', 2, 'A');
INSERT INTO Team VALUES ('ENG', 'England', 5, 'A');
INSERT INTO Team VALUES ('SA', 'South Africa', 3, 'A');
INSERT INTO Team VALUES ('NZ', 'New Zealand', 4, 'B');
INSERT INTO Team VALUES ('PAK', 'Pakistan', 6, 'B');
INSERT INTO Team VALUES ('SL', 'Sri Lanka', 7, 'B');
INSERT INTO Team VALUES ('AFG', 'Afghanistan', 8, 'B');

-- Insert Data into Player Table for Team India
INSERT INTO Player VALUES ('IND01', 'Virat Kohli', 'IND', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('IND02', 'Rohit Sharma', 'IND', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('IND03', 'Shubman Gill', 'IND', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('IND04', 'Shreyas Iyer', 'IND', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('IND05', 'Hardik Pandya', 'IND', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('IND06', 'Ravindra Jadeja', 'IND', 'All-Rounder', 'Left', 'Left');
INSERT INTO Player VALUES ('IND07', 'KL Rahul', 'IND', 'Wicketkeeper-Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('IND08', 'Jasprit Bumrah', 'IND', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('IND09', 'Mohammed Shami', 'IND', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('IND10', 'Kuldeep Yadav', 'IND', 'Bowler', 'Left', 'Left');
INSERT INTO Player VALUES ('IND11', 'Mohammed Siraj', 'IND', 'Bowler', 'Right', 'Right');

-- Insert Data into Player Table for Team Australia
INSERT INTO Player VALUES ('AUS01', 'David Warner', 'AUS', 'Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('AUS02', 'Steve Smith', 'AUS', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('AUS03', 'Marnus Labuschagne', 'AUS', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('AUS04', 'Pat Cummins', 'AUS', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('AUS05', 'Josh Hazlewood', 'AUS', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('AUS06', 'Mitchell Starc', 'AUS', 'Bowler', 'Left', 'Left');
INSERT INTO Player VALUES ('AUS07', 'Glenn Maxwell', 'AUS', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('AUS08', 'Alex Carey', 'AUS', 'Wicketkeeper-Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('AUS09', 'Marcus Stoinis', 'AUS', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('AUS10', 'Travis Head', 'AUS', 'Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('AUS11', 'Adam Zampa', 'AUS', 'Bowler', 'Right', 'Right');

-- Insert Data into Player Table for Team England
INSERT INTO Player VALUES ('ENG01', 'Joe Root', 'ENG', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('ENG02', 'Ben Stokes', 'ENG', 'All-Rounder', 'Left', 'Right');
INSERT INTO Player VALUES ('ENG03', 'Jos Buttler', 'ENG', 'Wicketkeeper-Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('ENG04', 'Jonny Bairstow', 'ENG', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('ENG05', 'Jofra Archer', 'ENG', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('ENG06', 'Mark Wood', 'ENG', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('ENG07', 'Chris Woakes', 'ENG', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('ENG08', 'Moeen Ali', 'ENG', 'All-Rounder', 'Left', 'Right');
INSERT INTO Player VALUES ('ENG09', 'Adil Rashid', 'ENG', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('ENG10', 'Dawid Malan', 'ENG', 'Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('ENG11', 'Liam Livingstone', 'ENG', 'All-Rounder', 'Right', 'Right');


-- Insert Data into Player Table for Team South Africa
INSERT INTO Player VALUES ('SA01', 'Quinton de Kock', 'SA', 'Wicketkeeper-Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('SA02', 'Temba Bavuma', 'SA', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('SA03', 'Aiden Markram', 'SA', 'Batsman', 'Right', 'Right');
INSERT INTO Player VALUES ('SA04', 'Rassie van der Dussen', 'SA', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('SA05', 'David Miller', 'SA', 'Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('SA06', 'Kagiso Rabada', 'SA', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('SA07', 'Anrich Nortje', 'SA', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('SA08', 'Lungi Ngidi', 'SA', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('SA09', 'Keshav Maharaj', 'SA', 'Bowler', 'Left', 'Left');
INSERT INTO Player VALUES ('SA10', 'Marco Jansen', 'SA', 'All-Rounder', 'Left', 'Left');
INSERT INTO Player VALUES ('SA11', 'Heinrich Klaasen', 'SA', 'Wicketkeeper-Batsman', 'Right', 'No');

-- Insert Data into Player Table for Team New Zealand
INSERT INTO Player VALUES ('NZ01', 'Kane Williamson', 'NZ', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('NZ02', 'Devon Conway', 'NZ', 'Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('NZ03', 'Tom Latham', 'NZ', 'Wicketkeeper-Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('NZ04', 'Daryl Mitchell', 'NZ', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('NZ05', 'Glenn Phillips', 'NZ', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('NZ06', 'Mitchell Santner', 'NZ', 'All-Rounder', 'Left', 'Left');
INSERT INTO Player VALUES ('NZ07', 'Trent Boult', 'NZ', 'Bowler', 'Left', 'Left');
INSERT INTO Player VALUES ('NZ08', 'Tim Southee', 'NZ', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('NZ09', 'Lockie Ferguson', 'NZ', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('NZ10', 'Ish Sodhi', 'NZ', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('NZ11', 'Mark Chapman', 'NZ', 'Batsman', 'Left', 'No');


-- Insert Data into Player Table for Team Pakistan
INSERT INTO Player VALUES ('PAK01', 'Babar Azam', 'PAK', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('PAK02', 'Mohammad Rizwan', 'PAK', 'Wicketkeeper-Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('PAK03', 'Fakhar Zaman', 'PAK', 'Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('PAK04', 'Imam-ul-Haq', 'PAK', 'Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('PAK05', 'Shadab Khan', 'PAK', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('PAK06', 'Shaheen Afridi', 'PAK', 'Bowler', 'Left', 'Left');
INSERT INTO Player VALUES ('PAK07', 'Haris Rauf', 'PAK', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('PAK08', 'Hasan Ali', 'PAK', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('PAK09', 'Naseem Shah', 'PAK', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('PAK10', 'Mohammad Nawaz', 'PAK', 'All-Rounder', 'Left', 'Left');
INSERT INTO Player VALUES ('PAK11', 'Iftikhar Ahmed', 'PAK', 'All-Rounder', 'Right', 'Right');


-- Insert Data into Player Table for Team Sri Lanka
INSERT INTO Player VALUES ('SL01', 'Dasun Shanaka', 'SL', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('SL02', 'Kusal Perera', 'SL', 'Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('SL03', 'Pathum Nissanka', 'SL', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('SL04', 'Dhananjaya de Silva', 'SL', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('SL05', 'Charith Asalanka', 'SL', 'All-Rounder', 'Left', 'Right');
INSERT INTO Player VALUES ('SL06', 'Wanindu Hasaranga', 'SL', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('SL07', 'Maheesh Theekshana', 'SL', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('SL08', 'Kasun Rajitha', 'SL', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('SL09', 'Dushmantha Chameera', 'SL', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('SL10', 'Lahiru Kumara', 'SL', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('SL11', 'Kusal Mendis', 'SL', 'Wicketkeeper-Batsman', 'Right', 'No');

-- Insert Data into Player Table for Team Afghanistan
INSERT INTO Player VALUES ('AFG01', 'Rashid Khan', 'AFG', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('AFG02', 'Mohammad Nabi', 'AFG', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('AFG03', 'Rahmanullah Gurbaz', 'AFG', 'Wicketkeeper-Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('AFG04', 'Ibrahim Zadran', 'AFG', 'Batsman', 'Right', 'No');
INSERT INTO Player VALUES ('AFG05', 'Najibullah Zadran', 'AFG', 'Batsman', 'Left', 'No');
INSERT INTO Player VALUES ('AFG06', 'Mujeeb Ur Rahman', 'AFG', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('AFG07', 'Fazalhaq Farooqi', 'AFG', 'Bowler', 'Left', 'Left');
INSERT INTO Player VALUES ('AFG08', 'Naveen-ul-Haq', 'AFG', 'Bowler', 'Right', 'Right');
INSERT INTO Player VALUES ('AFG09', 'Azmatullah Omarzai', 'AFG', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('AFG10', 'Gulbadin Naib', 'AFG', 'All-Rounder', 'Right', 'Right');
INSERT INTO Player VALUES ('AFG11', 'Hashmatullah Shahidi', 'AFG', 'Batsman', 'Left', 'No');

-- Insert Data into Coach Table
INSERT INTO Coach VALUES ('INDC1', 'Ravi Shastri', 'IND', 10);
INSERT INTO Coach VALUES ('AUSC2', 'Andrew McDonald', 'AUS', 9);
INSERT INTO Coach VALUES ('ENGC3', 'Brendon McCullum', 'ENG', 8);
INSERT INTO Coach VALUES ('SAC4', 'Mark Boucher', 'SA', 7);
INSERT INTO Coach VALUES ('NZC5', 'Gary Stead', 'NZ', 6);
INSERT INTO Coach VALUES ('PAKC6', 'Grant Bradburn', 'PAK', 7);
INSERT INTO Coach VALUES ('SLC7', 'Chris Silverwood', 'SL', 6);
INSERT INTO Coach VALUES ('AFGC8', 'Jonathan Trott', 'AFG', 5);


-- Insert Data into Captain Table
INSERT INTO Captain VALUES ('IND01', 'IND', 50);
INSERT INTO Captain VALUES ('AUS01', 'AUS', 45);
INSERT INTO Captain VALUES ('ENG01', 'ENG', 40);
INSERT INTO Captain VALUES ('SA01', 'SA', 35);
INSERT INTO Captain VALUES ('NZ01', 'NZ', 30);
INSERT INTO Captain VALUES ('PAK01', 'PAK', 28);
INSERT INTO Captain VALUES ('SL01', 'SL', 25);
INSERT INTO Captain VALUES ('AFG01', 'AFG', 20);

-- Insert Data into Stadium Table
INSERT INTO Stadium VALUES ('ST001', 'Wankhede Stadium', 'Mumbai');
INSERT INTO Stadium VALUES ('ST002', 'M Chinnaswamy ', 'Bangalore');
INSERT INTO Stadium VALUES ('ST003', 'Melbourne Cricket Ground', 'Melbourne');
INSERT INTO Stadium VALUES ('ST004', 'Lords', 'London');
INSERT INTO Stadium VALUES ('ST005', 'Newlands', 'Cape Town');
INSERT INTO Stadium VALUES ('ST006', 'Eden Park', 'Auckland');
INSERT INTO Stadium VALUES ('ST007', 'Gaddafi Stadium', 'Lahore');
INSERT INTO Stadium VALUES ('ST008', 'R. Premadasa Stadium', 'Colombo');

-- Insert Data into Umpire Table
INSERT INTO Umpire VALUES ('UMP01', 'Aleem Dar', 'Pakistan');
INSERT INTO Umpire VALUES ('UMP02', 'Marais Erasmus', 'South Africa');
INSERT INTO Umpire VALUES ('UMP03', 'Richard Illingworth', 'England');
INSERT INTO Umpire VALUES ('UMP04', 'Kumar Dharmasena', 'Sri Lanka');
INSERT INTO Umpire VALUES ('UMP05', 'Chris Gaffaney', 'New Zealand');
INSERT INTO Umpire VALUES ('UMP06', 'Rod Tucker', 'Australia');
INSERT INTO Umpire VALUES ('UMP07', 'Paul Reiffel', 'Australia');
INSERT INTO Umpire VALUES ('UMP08', 'Michael Gough', 'England');


-- Group A Matches
INSERT INTO Matches VALUES (1, 'AUS', 'SA', 'UMP01', '2025-06-01', 'A', 'AUS');
INSERT INTO Matches VALUES (2, 'AUS', 'PAK', 'UMP02', '2025-06-02', 'A', 'AUS');
INSERT INTO Matches VALUES (3, 'AUS', 'SL', 'UMP03', '2025-06-03', 'A', 'SL');
INSERT INTO Matches VALUES (4, 'SA', 'PAK', 'UMP04', '2025-06-04', 'A', 'SA');
INSERT INTO Matches VALUES (5, 'SA', 'SL', 'UMP05', '2025-06-05', 'A', 'SA');
INSERT INTO Matches VALUES (6, 'PAK', 'SL', 'UMP06', '2025-06-06', 'A', 'PAK');

-- Group B Matches
INSERT INTO Matches VALUES (7, 'IND', 'ENG', 'UMP07', '2025-06-07', 'B', 'IND');
INSERT INTO Matches VALUES (8, 'IND', 'NZ', 'UMP08', '2025-06-08', 'B', 'IND');
INSERT INTO Matches VALUES (9, 'IND', 'AFG', 'UMP01', '2025-06-09', 'B', 'AFG');
INSERT INTO Matches VALUES (10, 'ENG', 'NZ', 'UMP02', '2025-06-10', 'B', 'ENG');
INSERT INTO Matches VALUES (11, 'ENG', 'AFG', 'UMP03', '2025-06-11', 'B', 'ENG');
INSERT INTO Matches VALUES (12, 'NZ', 'AFG', 'UMP04', '2025-06-12', 'B', 'NZ');

-- Insert Data into Plays Table (Linking teams, matches, and stadiums)

-- Group A Plays
INSERT INTO Plays VALUES ('AUS', 1, 'ST001');
INSERT INTO Plays VALUES ('SA', 1, 'ST001');
INSERT INTO Plays VALUES ('AUS', 2, 'ST002');
INSERT INTO Plays VALUES ('PAK', 2, 'ST002');
INSERT INTO Plays VALUES ('AUS', 3, 'ST003');
INSERT INTO Plays VALUES ('SL', 3, 'ST003');
INSERT INTO Plays VALUES ('SA', 4, 'ST004');
INSERT INTO Plays VALUES ('PAK', 4, 'ST004');
INSERT INTO Plays VALUES ('SA', 5, 'ST005');
INSERT INTO Plays VALUES ('SL', 5, 'ST005');
INSERT INTO Plays VALUES ('PAK', 6, 'ST006');
INSERT INTO Plays VALUES ('SL', 6, 'ST006');

-- Group B Plays
INSERT INTO Plays VALUES ('IND', 7, 'ST007');
INSERT INTO Plays VALUES ('ENG', 7, 'ST007');
INSERT INTO Plays VALUES ('IND', 8, 'ST008');
INSERT INTO Plays VALUES ('NZ', 8, 'ST008');
INSERT INTO Plays VALUES ('IND', 9, 'ST001');
INSERT INTO Plays VALUES ('AFG', 9, 'ST001');
INSERT INTO Plays VALUES ('ENG', 10, 'ST002');
INSERT INTO Plays VALUES ('NZ', 10, 'ST002');
INSERT INTO Plays VALUES ('ENG', 11, 'ST003');
INSERT INTO Plays VALUES ('AFG', 11, 'ST003');
INSERT INTO Plays VALUES ('NZ', 12, 'ST004');
INSERT INTO Plays VALUES ('AFG', 12, 'ST004');