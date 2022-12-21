DROP TRIGGER IF EXISTS refereeCountry;

CREATE TRIGGER refereeCountry

AFTER INSERT ON MATCH

WHEN(

    (SELECT idcountry FROM PERSON WHERE idperson = new.idreferee) = 

    (
        SELECT B.IDCOUNTRY FROM MATCH M JOIN CLUB B ON (B.IDCLUB = M.IDVISITED or b.idclub = m.idvisitor)
        WHERE B.IDCLUB = NEW.IDVISITED or b.idclub = new.idvisitor
    )

)

BEGIN
    Select Raise(Abort, 'Referee has the same nationality as one of the teams');
END;
