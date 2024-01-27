--PRAGMA FOREIGN_KEYS = ON;


DROP TRIGGER IF EXISTS stadiumIfFinal;

CREATE TRIGGER stadiumIfFinal
AFTER INSERT ON MATCH



WHEN(
    NEW.IDSTADIUM IS NULL and NEW.IdMatchType <> (

        SELECT idtype FROM MATCHTYPE WHERE TYPE = "Final"
    
    )
)



BEGIN
	
    UPDATE MATCH 
    SET IDSTADIUM = (
        SELECT B.IDSTADIUM FROM MATCH M JOIN
        CLUB B ON (B.idClub = M.IDVISITED) WHERE B.IDCLUB = NEW.IDVISITED
    ) where idmatch = new.idmatch;


END;


DROP TRIGGER IF EXISTS stadiumIfNotFinal;

CREATE TRIGGER stadiumIfNotFinal
AFTER INSERT ON MATCH

WHEN(
    NEW.IDSTADIUM IS NULL and NEW.IdMatchType = (

        SELECT idtype FROM MATCHTYPE WHERE TYPE = "Final"
    
    )
)

BEGIN
    Select Raise(Abort, 'Final - Need a Stadium');
END;