.mode columns
.headers on
.nullvalue NULL



select pe.name, count(s.idSubstitution) as nr_substitutions
FROM coach co 
join person pe on pe.idPerson = co.idCoach
join club cl on cl.idcoach = co.idcoach
join match m on cl.idclub in (m.idvisited, m.idvisitor)
join event e on e.idMatch = m.idMatch
join player pl on e.idPlayer = pl.idPlayer
join substitution s on s.idSubstitution = e.idEvent and pl.idClub = cl.idClub
group by co.idCoach