.mode columns
.headers on
.nullvalue NULL

SELECT s.name AS stadium_name, COUNT(mp.idPlayer) AS player_count
FROM Stadium s
JOIN Match m ON s.idStadium = m.idStadium
JOIN MatchPlayer mp ON m.idMatch = mp.idMatch
GROUP BY s.name