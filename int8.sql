.mode columns
.headers on
.nullvalue NULL





select c.name as "Team", goals as "Result"
from (select CASE
      when g.self = 0 then p.idclub
      else (select idclub from club where idclub in (m.idvisited, m.idvisitor) and idclub!=p.idclub)
      end as id,
      count(
      CASE
      when g.self = 0 then p.idclub
      else (select idclub from club where idclub in (m.idvisited, m.idvisitor) and idclub!=p.idclub)
      end) as goals
  from match m
  join event e on e.idmatch = m.idmatch
  join goal g on g.idGoal = e.idEvent
  join player p on p.idplayer = e.idPlayer
  where m.idMatch = 5
  group by CASE
      when g.self = 0 then p.idclub
      else (select idclub from club where idclub in (m.idvisited, m.idvisitor) and idclub!=p.idclub)
      end)
join club c on c.idclub = id