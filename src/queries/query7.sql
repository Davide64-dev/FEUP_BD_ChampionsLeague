.mode columns
.headers on
.nullvalue NULL



DROP VIEW IF EXISTS MAX1;
DROP VIEW IF EXISTS MIN1;

CREATE VIEW MAX1 AS

SELECT c.IDCLUB,C.NAME, p.name AS "PLAYER",MAX(cast(strftime('%Y.%m%d', 'now') - strftime('%Y.%m%d', p.birthdate) as int)) AS "MAX" FROM PERSON P JOIN
player l on l.idplayer = p.idperson join 
CLUB C ON C.IDCLUB = l.IDCLUB GROUP BY C.IDCLUB;



CREATE VIEW MIN1 AS 
SELECT c.IDCLUB,C.NAME, p.name AS "PLAYER",MIN(cast(strftime('%Y.%m%d', 'now') - strftime('%Y.%m%d', p.birthdate) as int)) AS "MIN" FROM PERSON P JOIN
player l on l.idplayer = p.idperson join 
CLUB C ON C.IDCLUB = l.IDCLUB GROUP BY C.IDCLUB;

SELECT MAX1.IDCLUB AS "ID_Club", MAX1.NAME as "Club", MAX1.PLAYER as "Oldest Player", 
MAX1.MAX as "Age" , MIN1.PLAYER as "Youngest Player", MIN1.MIN as "Age"
FROM MAX1 JOIN MIN1 ON MAX1.IDCLUB = MIN1.IDCLUB;

