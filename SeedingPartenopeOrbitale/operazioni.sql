--lista di operazioni presenti nel progetto (query, view, trigger e stored procedure)

--query
--Membri più presenti in missione
SELECT M.ID, M.Nome, M.Cognome, COUNT(*) AS NumeroMissioni
FROM MEMBRI_EQUIPAGGIO M
JOIN PARTECIPAZIONI P ON M.ID = P.MembroID
GROUP BY M.ID, M.Nome, M.Cognome
ORDER BY NumeroMissioni DESC;

--Missioni con sole anomalie critiche
SELECT M.ID, M.Obiettivo, M.Stato
FROM MISSIONI M
WHERE NOT EXISTS (
    SELECT 1
    FROM UTILIZZO_SENSORI US
    JOIN ANOMALIE A ON A.SensoreID = US.SensoreID
    WHERE US.MissioneID = M.ID
    AND A.Livello != 'critica');

--Robot più utilizzati
SELECT R.ID, COUNT(*) AS MissioniTotali
FROM ROBOT R
JOIN UTILIZZO_ROBOT UR ON R.ID = UR.RobotID
GROUP BY R.ID
ORDER BY MissioniTotali DESC;

--Interventi su sensori malfunzionanti
SELECT DISTINCT M.ID, M.Nome, M.Cognome
FROM MEMBRI_EQUIPAGGIO M
JOIN COINVOLGIMENTI C ON M.ID = C.MembroID
JOIN INTERVENTI I ON C.InterventoID = I.ID
JOIN RISOLUZIONI R ON I.ID = R.InterventoID
JOIN ANOMALIE A ON R.AnomaliaID = A.ID
JOIN SENSORI S ON A.SensoreID = S.ID
WHERE S.Stato = 'malfunzionante';

--Massimi valori rilevati per tipo di sensore
SELECT S.Tipo, MAX(R.Valore) AS ValoreMassimo
FROM SENSORI S
JOIN RILEVAZIONI R ON S.ID = R.SensoreID
GROUP BY S.Tipo;

--Sensori dormienti da oltre 30 giorni
SELECT S.ID, S.Tipo, S.Stato
FROM SENSORI S
WHERE NOT EXISTS (
    SELECT 1
    FROM RILEVAZIONI R
    WHERE R.SensoreID = S.ID
    AND R.Timestamp >= DATE '2103-12-01');

--Sensori con media di rilevazioni superiore alla soglia
SELECT R.SensoreID, S.Tipo, AVG(R.Valore) AS Media_Valori
FROM RILEVAZIONI R
JOIN SENSORI S ON R.SensoreID = S.ID
GROUP BY R.SensoreID, S.Tipo
HAVING AVG(R.Valore) > 60
ORDER BY Media_Valori DESC;

--view
--Andamento missioni
CREATE VIEW ANDAMENTO_MISSIONI AS
SELECT M.ID AS IDMissione, M.Obiettivo, M.Stato, COUNT(A.ID) AS TotaleAnomalie
FROM MISSIONI M
LEFT JOIN ANOMALIE A ON M.ID = A.SensoreID
GROUP BY M.ID, M.Obiettivo, M.Stato
ORDER BY TotaleAnomalie DESC;

--eroi della luna (membri che hanno preso parte a missioni ed interventi)
CREATE VIEW EROI_DELLA_LUNA AS
SELECT 
    M.ID AS ID_Membro,
    M.Nome,
    M.Cognome,
    COUNT(DISTINCT P.MissioneID) AS MissioniPartecipate,
    COUNT(DISTINCT C.InterventoID) AS InterventiEffettuati
FROM MEMBRI_EQUIPAGGIO M
LEFT JOIN PARTECIPAZIONI P ON M.ID = P.MembroID
LEFT JOIN COINVOLGIMENTI C ON M.ID = C.MembroID
GROUP BY M.ID, M.Nome, M.Cognome
ORDER BY InterventiEffettuati DESC;

--Sensori sotto pressione (sensori con più anomalie)
CREATE VIEW SENSORI_SOTTO_PRESSIONE AS
SELECT S.ID AS SensoreID, S.Tipo, COUNT(A.ID) AS NumeroAnomalie
FROM SENSORI S
LEFT JOIN ANOMALIE A ON S.ID = A.SensoreID
GROUP BY S.ID, S.Tipo
ORDER BY NumeroAnomalie DESC;

--Statistiche rilevazioni (media, massimo e minimo per ogni sensore)
CREATE OR REPLACE VIEW STATISTICHE_RILEVAZIONI AS
SELECT 
    S.ID AS SensoreID,
    S.Tipo,
    ROUND(AVG(R.Valore), 2) AS MediaValore,
    MAX(R.Valore) AS ValoreMassimo,
    MIN(R.Valore) AS ValoreMinimo
FROM SENSORI S
JOIN RILEVAZIONI R ON S.ID = R.SensoreID
GROUP BY S.ID, S.Tipo
ORDER BY S.Tipo, MediaValore DESC;

--Calendario interventi (interventi programmati e anomalie associate)
CREATE VIEW CALENDARIO_INTERVENTI AS
SELECT 
    I.ID AS InterventoID,
    I.Descrizione,
    I.DataEsecuzione,
    A.ID AS AnomaliaID,
    A.Livello,
    A.SensoreID
FROM INTERVENTI I
LEFT JOIN RISOLUZIONI R ON I.ID = R.InterventoID
LEFT JOIN ANOMALIE A ON R.AnomaliaID = A.ID
ORDER BY I.DataEsecuzione ASC;

--Redazione recente (ultimi 10 report redatti)
CREATE OR REPLACE VIEW REDAZIONE_RECENTE AS
SELECT 
    R.ID AS ReportID,
    R.Valutazione,
    D.Data,
    M.Obiettivo AS Missione,
    E.Nome || ' ' || E.Cognome AS Autore
FROM REPORT R
    JOIN REDAZIONE D ON R.ID = D.ReportID
    JOIN MISSIONI M ON D.MissioneID = M.ID
    JOIN MEMBRI_EQUIPAGGIO E ON D.MembroID = E.ID
ORDER BY D.Data DESC
FETCH FIRST 10 ROWS ONLY;

--Trigger
--Sensore sotto stress (se un sensore rileva un'anomalia viene aggiornato il suo stato a "malfunzionante")
CREATE OR REPLACE TRIGGER trg_set_sensore_malfunzionante
AFTER INSERT ON ANOMALIE
FOR EACH ROW
BEGIN
UPDATE SENSORI
SET Stato = 'malfunzionante'
WHERE ID = :NEW.SensoreID;
END;

--Pulizia spogliatoio (eliminazione redazione comporta eliminazione report associato)
CREATE OR REPLACE TRIGGER trg_delete_report_orfano
AFTER DELETE ON REDAZIONE
FOR EACH ROW
BEGIN
DELETE FROM REPORT
WHERE ID = :OLD.ReportID;
END;

--Controllo VAR automatico (ogni nuova rilevazione aggiorna la data dell'ultimo controllo del sensore)
CREATE OR REPLACE TRIGGER trg_aggiorna_controllo
AFTER INSERT ON RILEVAZIONI
FOR EACH ROW
BEGIN
UPDATE SENSORI
SET DataUltimoControllo = :NEW.Timestamp
WHERE ID = :NEW.SensoreID;
END;

--Triplice fischio (se una missione viene completata, viene aggiornato il campo DataFine)
CREATE OR REPLACE TRIGGER trg_missione_completata
BEFORE UPDATE ON MISSIONI
FOR EACH ROW
WHEN (NEW.Stato = 'completata' AND OLD.Stato != 'completata')
BEGIN
:NEW.DataFine := SYSDATE;
END;

--Stored Procedure
--Calcolo percentuale di sensori malfunzionanti
CREATE OR REPLACE PROCEDURE CalcolaPercentualeMalfunzionanti(
    p_MissioneID IN INTEGER DEFAULT NULL
)
IS
    v_Totale INTEGER := 0;
    v_Malfunzionanti INTEGER := 0;
    v_Percentuale NUMBER;
BEGIN
    IF p_MissioneID IS NULL THEN
        SELECT COUNT(*) INTO v_Totale FROM SENSORI;
        SELECT COUNT(*) INTO v_Malfunzionanti 
        FROM SENSORI WHERE Stato = 'malfunzionante';
    ELSE
        SELECT COUNT(*) INTO v_Totale
        FROM UTILIZZO_SENSORI
        WHERE MissioneID = p_MissioneID;

        SELECT COUNT(*) INTO v_Malfunzionanti
        FROM UTILIZZO_SENSORI US
        JOIN SENSORI S ON US.SensoreID = S.ID
        WHERE US.MissioneID = p_MissioneID
        AND S.Stato = 'malfunzionante';
    END IF;

    IF v_Totale = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nessun sensore trovato.');
    ELSE
        v_Percentuale := (v_Malfunzionanti / v_Totale) * 100;
        DBMS_OUTPUT.PUT_LINE('Percentuale sensori malfunzionanti: ' || ROUND(v_Percentuale, 2) || '%');
    END IF;
END;

--Assegnazione sensore a missione
CREATE OR REPLACE PROCEDURE AssegnaSensoreAMissione(
    p_SensoreID IN INTEGER,
    p_MissioneID IN INTEGER
)
IS
    v_Conta INTEGER := 0;
BEGIN
    -- Verifica che il sensore esista
    SELECT COUNT(*) INTO v_Conta FROM SENSORI WHERE ID = p_SensoreID;
    IF v_Conta = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Sensore inesistente.');
    END IF;

    -- Verifica che la missione esista
    SELECT COUNT(*) INTO v_Conta FROM MISSIONI WHERE ID = p_MissioneID;
    IF v_Conta = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Missione inesistente.');
    END IF;

    -- Verifica che non sia già assegnato
    SELECT COUNT(*) INTO v_Conta 
    FROM UTILIZZO_SENSORI 
    WHERE SensoreID = p_SensoreID AND MissioneID = p_MissioneID;

    IF v_Conta > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Sensore già assegnato a questa missione.');
    END IF;

    -- Inserimento effettivo
    INSERT INTO UTILIZZO_SENSORI(MissioneID, SensoreID)
    VALUES (p_MissioneID, p_SensoreID);

    DBMS_OUTPUT.PUT_LINE('Sensore assegnato correttamente.');
END;

--Aggiornamento stato sensore
CREATE OR REPLACE PROCEDURE AggiornaStatoSensore(
    p_SensoreID IN INTEGER,
    p_NuovoStato IN VARCHAR2
)
IS
    v_Conta INTEGER := 0;
BEGIN
    -- Verifica esistenza sensore
    SELECT COUNT(*) INTO v_Conta FROM SENSORI WHERE ID = p_SensoreID;
    IF v_Conta = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Sensore inesistente.');
    END IF;

    -- Verifica stato valido
    IF p_NuovoStato NOT IN ('attivo', 'standby', 'manutenzione', 'malfunzionante') THEN
        RAISE_APPLICATION_ERROR(-20011, 'Stato non valido.');
    END IF;

    -- Esegui aggiornamento
    UPDATE SENSORI
    SET Stato = p_NuovoStato
    WHERE ID = p_SensoreID;

    DBMS_OUTPUT.PUT_LINE('Stato aggiornato correttamente.');
END;

--Elenco membri attivi (membri che partecipano a missioni in corso)
CREATE OR REPLACE PROCEDURE ElencoMembriAttivi
IS
BEGIN
    FOR r IN (
        SELECT DISTINCT M.ID, M.Nome, M.Cognome, M.Ruolo
        FROM MEMBRI_EQUIPAGGIO M
        JOIN PARTECIPAZIONI P ON M.ID = P.MembroID
        JOIN MISSIONI MI ON P.MissioneID = MI.ID
        WHERE MI.Stato = 'in_corso'
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || r.ID || ' - ' || r.Nome || ' ' || r.Cognome || ' (' || r.Ruolo || ')');
    END LOOP;
END;

--Statistiche interventi per membro dell'equipaggio
CREATE OR REPLACE PROCEDURE StatisticheInterventiMembro
IS
BEGIN
    FOR r IN (
        SELECT 
            M.ID,
            M.Nome,
            M.Cognome,
            COUNT(C.InterventoID) AS NumeroInterventi
        FROM MEMBRI_EQUIPAGGIO M
        LEFT JOIN COINVOLGIMENTI C ON M.ID = C.MembroID
        GROUP BY M.ID, M.Nome, M.Cognome
        ORDER BY NumeroInterventi DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Membro: ' || r.Nome || ' ' || r.Cognome || ' | Interventi: ' || r.NumeroInterventi);
    END LOOP;
END;
