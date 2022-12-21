.headers on
.mode columns


--Part
DROP TABLE IF EXISTS Part;
CREATE TABLE Part(
    idPart INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);


--Country (idCountry, name);
DROP TABLE IF EXISTS Country;
CREATE TABLE Country(
    idCountry INTEGER PRIMARY KEY,
    name VARCHAR NOT NULL
);

--Club (idClub, name, address, foundationYear, idStadium->Stadium, idCity->City, idCoach->Coach);
DROP TABLE IF EXISTS Club;
CREATE TABLE Club(
    idClub INTEGER PRIMARY KEY,
    name VARCHAR NOT NULL,
    year NUMERIC CHECK (year <= 2022),
    "group" CHAR(1),
    idStadium INTEGER REFERENCES Stadium(idStadium),
    idCountry INTEGER REFERENCES Country(idCountry),
    idCoach INTEGER REFERENCES Coach(idCoach)
);

--MatchType(idType, type, winPrize, drawprize, loseprize)
DROP TABLE IF EXISTS MatchType;
CREATE TABLE MatchType(
    idType INTEGER,
    type VARCHAR NOT NULL,
    winner_prize INTEGER NOT NULL check(winner_prize > 0),
    draw_prize INTEGER check(draw_prize >= 0),
    lose_prize INTEGER check(lose_prize >= 0),
    CONSTRAINT MATCHTYPE_KEY PRIMARY KEY (idType)
);


--Person (idPerson, name, age, idCountry->Country);
DROP TABLE IF EXISTS Person;
CREATE TABLE Person(
    idPerson INTEGER PRIMARY KEY,
    name VARCHAR NOT NULL,
    birthdate DATE,
    idCountry INTEGER,
    FOREIGN KEY(idCountry) REFERENCES Country(idCountry)
);

--Position(idPosition, positionname);
DROP TABLE IF EXISTS POSITION;
CREATE TABLE POSITION(
    idPosition INTEGER PRIMARY KEY,
    position VARCHAR NOT NULL
);

--Player (idPlayer->Person, number, position, idClub ->Club);
DROP TABLE IF EXISTS Player;
CREATE TABLE Player(
    idPlayer INTEGER PRIMARY KEY,
    number INTEGER CHECK(0<number<100),
    idPosition INTEGER,
    idClub INTEGER,
    FOREIGN KEY(idPlayer) REFERENCES Person(idPerson),
    FOREIGN KEY(idPosition) REFERENCES POSITION(idPosition),
    FOREIGN KEY(idClub) REFERENCES Club(idClub)
);


--Referee (idReferee->Person);
DROP TABLE IF EXISTS Referee;
CREATE TABLE Referee(
    idReferee INTEGER PRIMARY KEY,
    FOREIGN KEY(idReferee) REFERENCES Person(idPerson)
);


--Coach (idCoach->Person)
DROP TABLE IF EXISTS Coach;
CREATE TABLE Coach(
    idCoach INTEGER PRIMARY KEY,
    FOREIGN KEY(idCoach) REFERENCES Person(idPerson)
);



--Match (idMatch, datetime, idVisited->Club, idVisitor->Club, idStadium->Stadium, idMatchType->MatchType)
DROP TABLE IF EXISTS Match;
CREATE TABLE Match(
    idMatch INTEGER PRIMARY KEY,
    datetime DATETIME NOT NULL,
    idVisited INTEGER REFERENCES Club(idClub),
    idVisitor INTEGER REFERENCES Club(idClub),
    idStadium INTEGER REFERENCES Stadium(idStadium),
    idMatchType INTEGER REFERENCES MatchType(idType),
    idReferee INTEGER REFERENCES Referee(idReferee)
);


--MATCHPLAYER(idMatch, idPlayer, From_start);
DROP TABLE IF EXISTS MatchPlayer;
CREATE TABLE MatchPlayer(
    idMatch INTEGER,
    idPlayer INTEGER,
    from_start INTEGER,
    PRIMARY KEY(idMatch, idPlayer),
    CONSTRAINT MATCH_KEY FOREIGN KEY (idMatch) REFERENCES Match(idMatch),
    CONSTRAINT PLAYER_KEY FOREIGN KEY (idPlayer) REFERENCES Player(idPlayer)
);

--Stadium (idStadium, name);
DROP TABLE IF EXISTS Stadium;
CREATE TABLE Stadium(
    idStadium INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);


--Event(idEvent, idMatch, idPlayer,Minute, idpart);
DROP TABLE IF EXISTS Event;
CREATE TABLE Event(
    idEvent INTEGER PRIMARY KEY,
    idMatch INTEGER,
    idPlayer INTEGER,
    time INTEGER NOT NULL CHECK(time > 0),
    idPart INTEGER,
    CONSTRAINT PART_KEY FOREIGN KEY (idPart) REFERENCES Part(idPart),
    CONSTRAINT PART_KEY FOREIGN KEY(idMatch, idPlayer) REFERENCES MatchPlayer(idMatch, idPlayer)
);


--Card(idCard->Event, color, idPlayer->Player);
DROP TABLE IF EXISTS Card;
CREATE TABLE Card(
    idCard INTEGER PRIMARY KEY,
    is_red BOOLEAN NOT NULL,
    FOREIGN KEY(idCard) REFERENCES Event(idEvent)
);


--Substitution(idSubstitution->Event, idPlayerLeave->Player, idPlayerEnter->Player);
DROP TABLE IF EXISTS Substitution;
CREATE TABLE Substitution(
    idSubstitution INTEGER PRIMARY KEY,
    idMatch INTEGER,
    idPlayer INTEGER,
    FOREIGN KEY(idSubstitution) REFERENCES Event(idEvent),
    FOREIGN KEY(idMatch, idPlayer) REFERENCES MatchPlayer(idMatch, idPlayer)
);


--Goal (idGoal->Event, type);
DROP TABLE IF EXISTS Goal;
CREATE TABLE Goal(
    idGoal INTEGER PRIMARY KEY,
    self BOOLEAN DEFAULT FALSE,
    FOREIGN KEY(idGoal) REFERENCES Event(idEvent)
);


--Penalty (idPenalty->Event, idPlayer->Player);
DROP TABLE IF EXISTS Penalty;
CREATE TABLE Penalty(
    idPenalty INTEGER PRIMARY KEY,
    FOREIGN KEY(idPenalty) REFERENCES Event(idEvent)
);

--Ball Possesion
Drop Table IF Exists BALLPOSSESSION;
CREATE TABLE BALLPOSSESSION(
    idMatch INTEGER REFERENCES Match(idMatch),
    idClub INTEGER REFERENCES Club(idClub),
    percentage INTEGER CHECK (percentage <= 100),
    PRIMARY KEY(idMatch, idClub)
);