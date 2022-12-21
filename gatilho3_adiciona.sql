DROP TRIGGER IF EXISTS groupMatch;

CREATE TRIGGER groupMatch

AFTER INSERT ON MATCH

WHEN(

    ((SELECT C."GROUP" FROM CLUB C WHERE NEW.IDVISITED = C.IDCLUB) <>
    (SELECT C."GROUP" FROM CLUB C WHERE NEW.IDVISITOR = C.IDCLUB))
    
    AND

    (
    NEW.IDMATCHTYPE = (SELECT idType FROM MATCHTYPE where type = "Group Stage")
    )
)

BEGIN
    Select Raise(Abort, 'In Group Stage, both teams must belong to the same team');
END;