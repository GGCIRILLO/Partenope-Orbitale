CREATE TABLE MISSIONI (
    ID INTEGER NOT NULL,
    Obiettivo VARCHAR2(100) NOT NULL,
    DataInizio DATE NOT NULL,
    DataFine DATE,
    Stato VARCHAR2(20) CHECK (Stato IN ('pianificata', 'in_corso', 'completata', 'annullata')) NOT NULL
);

CREATE TABLE MEMBRI_EQUIPAGGIO (
    ID INTEGER NOT NULL,
    Nome VARCHAR2(50) NOT NULL,
    Cognome VARCHAR2(50) NOT NULL,
    Ruolo VARCHAR2(30) NOT NULL
);

CREATE TABLE SENSORI (
    ID INTEGER NOT NULL,
    Tipo VARCHAR2(30) CHECK (Tipo IN ('temperatura', 'pressione', 'gas', 'radiazioni', 'geologia')) NOT NULL,
    Latitudine FLOAT NOT NULL,
    Longitudine FLOAT NOT NULL,
    Altitudine FLOAT NOT NULL,
    DataInstallazione DATE NOT NULL,
    DataUltimoControllo DATE,
    Stato VARCHAR2(20) CHECK (Stato IN ('attivo', 'standby', 'manutenzione', 'malfunzionante')) NOT NULL
);

CREATE TABLE ROBOT (
    ID INTEGER NOT NULL,
    Tipo VARCHAR2(30) CHECK (Tipo IN ('esplorazione', 'manutenzione', 'raccolta_risorse')) NOT NULL
);

CREATE TABLE RILEVAZIONI (
    ID INTEGER NOT NULL,
    Timestamp TIMESTAMP NOT NULL,
    Valore FLOAT NOT NULL,
    SensoreID INTEGER NOT NULL
);

CREATE TABLE ANOMALIE (
    ID INTEGER NOT NULL,
    Timestamp TIMESTAMP NOT NULL,
    Livello VARCHAR2(20) CHECK (Livello IN ('bassa', 'media', 'alta', 'critica')) NOT NULL,
    Causa VARCHAR2(100) NOT NULL,
    SensoreID INTEGER NOT NULL
);

CREATE TABLE INTERVENTI (
    ID INTEGER NOT NULL,
    Descrizione VARCHAR2(100) NOT NULL,
    DataEsecuzione TIMESTAMP NOT NULL,
    Esito VARCHAR2(30)
);

CREATE TABLE REPORT (
    ID INTEGER NOT NULL,
    Valutazione VARCHAR2(100)
);

CREATE TABLE UTILIZZO_SENSORI (
    MissioneID INTEGER NOT NULL,
    SensoreID INTEGER NOT NULL
);

CREATE TABLE UTILIZZO_ROBOT (
    MissioneID INTEGER NOT NULL,
    RobotID INTEGER NOT NULL
);

CREATE TABLE PARTECIPAZIONI (
    MissioneID INTEGER NOT NULL,
    MembroID INTEGER NOT NULL
);

CREATE TABLE COINVOLGIMENTI (
    InterventoID INTEGER NOT NULL,
    MembroID INTEGER NOT NULL
);

CREATE TABLE INTERAZIONI_TECNICHE (
    MembroID INTEGER NOT NULL,
    SensoreID INTEGER NOT NULL,
    Timestamp TIMESTAMP NOT NULL,
    Tipo VARCHAR2(20) CHECK (Tipo IN ('manutenzione', 'riparazione', 'verifica')) NOT NULL
);

CREATE TABLE RISOLUZIONI (
    InterventoID INTEGER NOT NULL,
    AnomaliaID INTEGER NOT NULL,
    Esito VARCHAR2(20),
    DataEsecuzione DATE NOT NULL
);

CREATE TABLE REDAZIONE (
    MembroID INTEGER NOT NULL,
    MissioneID INTEGER NOT NULL,
    ReportID INTEGER NOT NULL,
    Data TIMESTAMP NOT NULL
);

ALTER TABLE MISSIONI ADD CONSTRAINT PK_MISSIONI PRIMARY KEY (ID);
ALTER TABLE MEMBRI_EQUIPAGGIO ADD CONSTRAINT PK_MEMBRI_EQUIPAGGIO PRIMARY KEY (ID);
ALTER TABLE SENSORI ADD CONSTRAINT PK_SENSORI PRIMARY KEY (ID);
ALTER TABLE ROBOT ADD CONSTRAINT PK_ROBOT PRIMARY KEY (ID);
ALTER TABLE REPORT ADD CONSTRAINT PK_REPORT PRIMARY KEY (ID);
ALTER TABLE RILEVAZIONI ADD CONSTRAINT PK_RILEVAZIONI PRIMARY KEY (ID);
ALTER TABLE ANOMALIE ADD CONSTRAINT PK_ANOMALIE PRIMARY KEY (ID);
ALTER TABLE INTERVENTI ADD CONSTRAINT PK_INTERVENTI PRIMARY KEY (ID);

-- Chiavi primarie per le associazioni (composite)
ALTER TABLE UTILIZZO_SENSORI ADD CONSTRAINT PK_UTILIZZO_SENSORI 
    PRIMARY KEY (MISSIONEID, SENSOREID);

ALTER TABLE UTILIZZO_ROBOT ADD CONSTRAINT PK_UTILIZZO_ROBOT 
    PRIMARY KEY (MISSIONEID, ROBOTID);

ALTER TABLE PARTECIPAZIONI ADD CONSTRAINT PK_PARTECIPAZIONI 
    PRIMARY KEY (MISSIONEID, MEMBROID);

ALTER TABLE COINVOLGIMENTI ADD CONSTRAINT PK_COINVOLGIMENTI 
    PRIMARY KEY (INTERVENTOID, MEMBROID);

ALTER TABLE INTERAZIONI_TECNICHE ADD CONSTRAINT PK_INTERAZIONI_TECNICHE 
    PRIMARY KEY (MEMBROID, SENSOREID, TIMESTAMP);

ALTER TABLE RISOLUZIONI ADD CONSTRAINT PK_RISOLUZIONI 
    PRIMARY KEY (INTERVENTOID);

ALTER TABLE REDAZIONE ADD CONSTRAINT PK_REDAZIONE 
    PRIMARY KEY (MEMBROID, MISSIONEID);

-- RILEVAZIONI e ANOMALIE: legate al sensore
ALTER TABLE RILEVAZIONI 
    ADD CONSTRAINT FK_RILEVAZIONI_SENSORE 
    FOREIGN KEY (SENSOREID) REFERENCES SENSORI(ID)
    ON DELETE CASCADE;

ALTER TABLE ANOMALIE 
    ADD CONSTRAINT FK_ANOMALIE_SENSORE 
    FOREIGN KEY (SENSOREID) REFERENCES SENSORI(ID)
    ON DELETE CASCADE;

-- RISOLUZIONI: intervento e anomalia
ALTER TABLE RISOLUZIONI 
    ADD CONSTRAINT FK_RISOLUZIONI_INTERVENTO 
    FOREIGN KEY (INTERVENTOID) REFERENCES INTERVENTI(ID)
    ON DELETE CASCADE;

ALTER TABLE RISOLUZIONI 
    ADD CONSTRAINT FK_RISOLUZIONI_ANOMALIA 
    FOREIGN KEY (ANOMALIAID) REFERENCES ANOMALIE(ID)
    ON DELETE CASCADE;

-- Relazioni N:N
ALTER TABLE UTILIZZO_SENSORI 
    ADD CONSTRAINT FK_UTILIZZO_SENSORI_MISSIONE 
    FOREIGN KEY (MISSIONEID) REFERENCES MISSIONI(ID)
    ON DELETE CASCADE;

ALTER TABLE UTILIZZO_SENSORI 
    ADD CONSTRAINT FK_UTILIZZO_SENSORI_SENSORE 
    FOREIGN KEY (SENSOREID) REFERENCES SENSORI(ID)
    ON DELETE CASCADE;

ALTER TABLE UTILIZZO_ROBOT 
    ADD CONSTRAINT FK_UTILIZZO_ROBOT_MISSIONE 
    FOREIGN KEY (MISSIONEID) REFERENCES MISSIONI(ID)
    ON DELETE CASCADE;

ALTER TABLE UTILIZZO_ROBOT 
    ADD CONSTRAINT FK_UTILIZZO_ROBOT_ROBOT 
    FOREIGN KEY (ROBOTID) REFERENCES ROBOT(ID)
    ON DELETE CASCADE;

ALTER TABLE PARTECIPAZIONI 
    ADD CONSTRAINT FK_PARTECIPAZIONI_MISSIONE 
    FOREIGN KEY (MISSIONEID) REFERENCES MISSIONI(ID)
    ON DELETE CASCADE;

ALTER TABLE PARTECIPAZIONI 
    ADD CONSTRAINT FK_PARTECIPAZIONI_MEMBRO 
    FOREIGN KEY (MEMBROID) REFERENCES MEMBRI_EQUIPAGGIO(ID)
    ON DELETE CASCADE;

ALTER TABLE COINVOLGIMENTI 
    ADD CONSTRAINT FK_COINVOLGIMENTI_INTERVENTO 
    FOREIGN KEY (INTERVENTOID) REFERENCES INTERVENTI(ID)
    ON DELETE CASCADE;

ALTER TABLE COINVOLGIMENTI 
    ADD CONSTRAINT FK_COINVOLGIMENTI_MEMBRO 
    FOREIGN KEY (MEMBROID) REFERENCES MEMBRI_EQUIPAGGIO(ID)
    ON DELETE CASCADE;

ALTER TABLE INTERAZIONI_TECNICHE 
    ADD CONSTRAINT FK_INTERAZIONI_TECNICHE_MEMBRO 
    FOREIGN KEY (MEMBROID) REFERENCES MEMBRI_EQUIPAGGIO(ID)
    ON DELETE CASCADE;

ALTER TABLE INTERAZIONI_TECNICHE 
    ADD CONSTRAINT FK_INTERAZIONI_TECNICHE_SENSORE 
    FOREIGN KEY (SENSOREID) REFERENCES SENSORI(ID)
    ON DELETE CASCADE;

-- REDAZIONE
ALTER TABLE REDAZIONE 
    ADD CONSTRAINT FK_REDAZIONE_MEMBRO 
    FOREIGN KEY (MEMBROID) REFERENCES MEMBRI_EQUIPAGGIO(ID)
    ON DELETE CASCADE;

ALTER TABLE REDAZIONE 
    ADD CONSTRAINT FK_REDAZIONE_MISSIONE 
    FOREIGN KEY (MISSIONEID) REFERENCES MISSIONI(ID)
    ON DELETE CASCADE;

ALTER TABLE REDAZIONE 
    ADD CONSTRAINT FK_REDAZIONE_REPORT 
    FOREIGN KEY (REPORTID) REFERENCES REPORT(ID)
    ON DELETE CASCADE;
