
DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS teams CASCADE;
DROP TABLE IF EXISTS matches CASCADE;

CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    ranking INT NOT NULL
);

CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    role VARCHAR(50) NOT NULL,
    team_id INT REFERENCES teams(id) ON DELETE CASCADE
);

CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    team1_id INT REFERENCES teams(id) ON DELETE CASCADE,
    team2_id INT REFERENCES teams(id) ON DELETE CASCADE,
    team1_score INT NOT NULL,
    team2_score INT NOT NULL
);

INSERT INTO teams (name, country, ranking) VALUES
('Team Vitality', 'France', 1),
('G2 Esports', 'International', 2),
('FaZe Clan', 'International', 3),
('Heroic', 'Denmark', 4),
('NAVI', 'Ukraine', 5),
('Cloud9', 'USA', 6),
('Astralis', 'Denmark', 7),
('ENCE', 'Finland', 8),
('MOUZ', 'Germany', 9),
('FURIA', 'Brazil', 10),
('Team Liquid', 'USA', 11),
('Complexity', 'USA', 12),
('BIG', 'Germany', 13),
('OG', 'Europe', 14),
('Fnatic', 'Sweden', 15);

INSERT INTO players (name, age, role, team_id) VALUES
-- Team Vitality
('ZywOo', 23, 'AWPer', 1),
('apEX', 30, 'IGL', 1),
('Magisk', 25, 'Rifler', 1),
('Spinx', 23, 'Rifler', 1),
('dupreeh', 29, 'Rifler', 1),

-- G2 Esports
('NiKo', 26, 'Rifler', 2),
('huNter-', 27, 'Rifler', 2),
('m0NESY', 18, 'AWPer', 2),
('jks', 27, 'Support', 2),
('HooXi', 27, 'IGL', 2),

-- FaZe Clan
('ropz', 23, 'Rifler', 3),
('Twistzz', 23, 'Rifler', 3),
('broky', 22, 'AWPer', 3),
('rain', 28, 'Rifler', 3),
('karrigan', 33, 'IGL', 3),

-- Heroic
('cadiaN', 28, 'AWPer', 4),
('stavn', 21, 'Rifler', 4),
('TeSeS', 24, 'Rifler', 4),
('sjuush', 23, 'Support', 4),
('jabbi', 20, 'Rifler', 4),

-- NAVI
('s1mple', 26, 'AWPer', 5),
('b1t', 20, 'Rifler', 5),
('electroNic', 24, 'IGL', 5),
('Perfecto', 22, 'Support', 5),
('npl', 19, 'Rifler', 5);


INSERT INTO matches (date, team1_id, team2_id, team1_score, team2_score) VALUES
('2025-01-01', 1, 2, 16, 12),
('2025-01-02', 3, 4, 14, 16),
('2025-01-03', 5, 6, 16, 8),
('2025-01-04', 7, 8, 11, 16),
('2025-01-05', 9, 10, 13, 16),
('2025-01-06', 11, 12, 16, 14),
('2025-01-07', 13, 14, 9, 16),
('2025-01-08', 15, 1, 7, 16),
('2025-01-09', 2, 3, 16, 14),
('2025-01-10', 4, 5, 12, 16);


SELECT * FROM teams ORDER BY ranking;

-- Kaikki pelaajat ja heidän joukkueensa
SELECT players.name AS player_name, players.role, teams.name AS team_name
FROM players
JOIN teams ON players.team_id = teams.id
ORDER BY teams.ranking, players.name;

-- Otteluiden voittajat ja häviäjät
SELECT 
    m.date,
    t1.name AS winner,
    t2.name AS loser,
    CASE 
        WHEN m.team1_score > m.team2_score THEN t1.name
        ELSE t2.name
    END AS winning_team
FROM matches m
JOIN teams t1 ON m.team1_id = t1.id
JOIN teams t2 ON m.team2_id = t2.id
WHERE m.team1_score != m.team2_score;


-- Teamin voitot ja tappiot
SELECT 
    t.name AS team_name,
    SUM(CASE WHEN (t.id = m.team1_id AND m.team1_score > m.team2_score) OR 
                 (t.id = m.team2_id AND m.team2_score > m.team1_score) THEN 1 ELSE 0 END) AS wins,
    SUM(CASE WHEN (t.id = m.team1_id AND m.team1_score < m.team2_score) OR 
                 (t.id = m.team2_id AND m.team2_score < m.team1_score) THEN 1 ELSE 0 END) AS losses
FROM teams t
LEFT JOIN matches m ON t.id = m.team1_id OR t.id = m.team2_id
GROUP BY t.id
ORDER BY wins DESC, losses ASC;