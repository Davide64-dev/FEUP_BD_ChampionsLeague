.mode columns
.headers on
.nullvalue NULL




DROP VIEW IF EXISTS IND_RESULTS;
drop view if exists results;
DROP VIEW IF EXISTS MATCHES_AND_TEAMS;

create view results
	AS
    select mclubs.idmatch as mid,
        idClub as cid,
        count(score.cid) as goals

    from 
        (select m.idMatch as mid,
            CASE
                when g.self = 0
                    then p.idclub
                else 
                    (select idclub
                     from club
                     where idclub in (m.idvisited, m.idvisitor) and idclub!=p.idclub) 
            end as cid

        from match m
        join MatchType mt on m.idMatchType = mt.idType and mt.type = "Group Stage"
        join event e on e.idmatch = m.idmatch
        join goal g on g.idGoal = e.idEvent
        join player p on p.idplayer = e.idPlayer
        ) as score

    right join
        (select *
         from club c
         join match m on c.idClub in (m.idvisited, m.idvisitor)
        ) as mclubs
    on mclubs.idmatch = score.mid and mclubs.idclub = score.cid

    group by mclubs.idmatch, score.cid;


create view ind_results
as
select 	rc.cid as cid,
    rc.mid as mid,
    case 
    	when rc.goals = mx and rc.goals = mn then "D"
        when rc.goals = mx then "W"
        when rc.goals = mn then "L"
    end as score
    
from 
	(select rm.mid,
     	max(rm.goals) as mx,
     	min(rm.goals) as mn
	from results rm
	group by rm.mid
    ) as rm
    
    
join results rc on rc.mid = rm.mid
join club c on c.idClub = rc.cid
group by c."group", c.name, rc.mid;


CREATE VIEW MATCHES_AND_TEAMS AS

SELECT I.CID, I.MID, I.SCORE, MI.IDMATCHTYPE, 

CASE WHEN SCORE = 'W' THEN WINner_PRIZE
	 WHEN SCORE = 'L' THEN LOSE_PRIZE
	 WHEN SCORE = 'D' THEN DRAW_PRIZE END AS RECEIVED
	
FROM ind_results I 
JOIN MATCH MI ON MI.idMatch = I.MID JOIN MATCHTYPE T ON T.IDTYPE = MI.IDMATCHTYPE;

SELECT CL.NAME AS "Club",SUM(RECEIVED) AS "Total Earnings" 
FROM MATCHES_AND_TEAMS MA 
JOIN CLUB CL ON CL.IDCLUB = MA.CID 
GROUP BY CID order by Sum(received) desc;












