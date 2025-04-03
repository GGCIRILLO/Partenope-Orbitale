import random
from datetime import datetime, timedelta
from faker import Faker
from const import *

# Inizializzazione Faker
fake = Faker("it_IT")


# Funzioni di supporto
def random_timestamp(start_year=2100, end_year=2105):
    """Genera un timestamp casuale tra gli anni specificati"""
    start = datetime(start_year, 1, 1)
    end = datetime(end_year, 12, 31)
    delta = end - start
    return (start + timedelta(seconds=random.randint(0, int(delta.total_seconds())))).strftime('%Y-%m-%d %H:%M:%S')

def random_string(prefix, length=5):
    """Genera una stringa casuale con prefisso"""
    return f"{prefix}_{''.join(random.choices('ABCDEFGHIJKLMNOPQRSTUVWXYZ', k=length))}"

# Funzioni di generazione dati per entità principali
def genera_missioni(num_records=NUM_MISSIONI):
    """Genera INSERT per la tabella MISSIONI"""
    records = []
    for i in range(1, num_records + 1):
        obbiettivo = random.choice(OBBIETTIVI_MISSIONI)
        data_inizio = random_timestamp().split(" ")[0]
        start_year = int(data_inizio.split("-")[0])
        stato = random.choice(STATI_MISSIONE)
        if stato == "pianificata":
            records.append(f"INSERT INTO MISSIONI (ID, DataInizio, DataFine, Stato, Obiettivo) VALUES ({i}, DATE '{data_inizio}', NULL, '{stato}', '{obbiettivo}');")
        else:
            data_fine = random_timestamp(start_year=start_year).split(" ")[0]
            records.append(f"INSERT INTO MISSIONI (ID, DataInizio, DataFine, Stato, Obiettivo) VALUES ({i}, DATE '{data_inizio}', DATE '{data_fine}', '{stato}', '{obbiettivo}');")
    
    return records

def genera_membri(num_records=NUM_MEMBRI):
    """Genera INSERT per la tabella MEMBRI_EQUIPAGGIO"""
    records = []
    for i in range(1, num_records + 1):
        nome = fake.first_name()
        cognome = fake.last_name()
        ruolo = random.choice(RUOLI_EQUIPAGGIO)
        records.append(f"INSERT INTO MEMBRI_EQUIPAGGIO VALUES ({i}, '{nome}', '{cognome}', '{ruolo}');")
    return records

def genera_sensori(num_records=NUM_SENSORI):
    """Genera INSERT per la tabella SENSORI"""
    records = []
    for i in range(1, num_records + 1):
        tipo = random.choice(TIPI_SENSORE)
        latitudine = fake.latitude()
        longitudine = fake.longitude()
        profondita = round(random.uniform(0, 5000), 2)
        installazione = random_timestamp().split(" ")[0]
        start_year = int(installazione.split("-")[0])
        ultima_manutenzione = random_timestamp(start_year=start_year).split(" ")[0]
        stato = random.choice(STATI_SENSORE)
        records.append(f"INSERT INTO SENSORI VALUES ({i}, '{tipo}', {latitudine}, {longitudine}, {profondita}, DATE '{installazione}', DATE '{ultima_manutenzione}', '{stato}');")
    return records

def genera_robot(num_records=NUM_ROBOT):
    """Genera INSERT per la tabella ROBOT"""
    records = []
    for i in range(1, num_records + 1):
        tipo = random.choice(TIPI_ROBOT)
        records.append(f"INSERT INTO ROBOT VALUES ({i}, '{tipo}');")
    return records

def genera_rilevazioni(num_records=NUM_RILEVAZIONI):
    """Genera INSERT per la tabella RILEVAZIONI"""
    records = []
    for i in range(1, num_records + 1):
        timestamp = random_timestamp()
        valore = round(random.uniform(0.0, 100.0), 2)
        sensore_id = random.randint(1, NUM_SENSORI)
        records.append(f"INSERT INTO RILEVAZIONI (ID, Timestamp, Valore, SensoreID) VALUES ({i}, TO_TIMESTAMP('{timestamp}', 'YYYY-MM-DD HH24:MI:SS'), {valore}, {sensore_id});")
    return records

def genera_anomalie(num_records=NUM_ANOMALIE):
    """Genera INSERT per la tabella ANOMALIE"""
    records = []
    for i in range(1, num_records + 1):
        timestamp = random_timestamp()
        livello = random.choice(LIVELLI_ANOMALIA)
        causa = random.choice(CAUSE_ANOMALIE)
        sensore_id = random.randint(1, NUM_SENSORI)
        records.append(f"INSERT INTO ANOMALIE (ID, Timestamp, Livello, Causa, SensoreID) VALUES ({i}, TO_TIMESTAMP('{timestamp}', 'YYYY-MM-DD HH24:MI:SS'), '{livello}', '{causa}', {sensore_id});")
    return records

def genera_interventi(num_records=NUM_INTERVENTI):
    """Genera INSERT per la tabella INTERVENTI"""
    records = []
    for i in range(1, num_records + 1):
        descrizione = random.choice(['riparazione', 'calibrazione', 'sostituzione'])
        data = random_timestamp()
        esito = random.choice(['successo', 'fallimento', 'parziale'])
        records.append(f"INSERT INTO INTERVENTI (ID, Descrizione, DataEsecuzione, Esito) VALUES ({i}, '{descrizione}', TO_TIMESTAMP('{data}', 'YYYY-MM-DD HH24:MI:SS'), '{esito}');")
    return records

def genera_report(num_records=NUM_REPORT):
    """Genera INSERT per la tabella REPORT"""
    records = []
    for i in range(1, num_records + 1):
        valutazione = random.choice(VALUTAZIONI_REPORT)
        records.append(f"INSERT INTO REPORT (ID, Valutazione) VALUES ({i}, '{valutazione}');")
    return records

# Funzioni di generazione relazioni
def genera_utilizzo_sensori(num_records=NUM_UTILIZZO_SENSORI):
    """Genera INSERT per la tabella UTILIZZO_SENSORI"""
    records = []
    relazioni_generate = set()
    
    for i in range(1, num_records + 1):
        # Evita inserimenti duplicati
        while True:
            missione = random.randint(1, NUM_MISSIONI)
            sensore = random.randint(1, NUM_SENSORI)
            relazione = (missione, sensore)
            
            if relazione not in relazioni_generate:
                relazioni_generate.add(relazione)
                records.append(f"INSERT INTO UTILIZZO_SENSORI (MissioneID, SensoreID) VALUES ({missione}, {sensore});")
                break
    
    return records

def genera_utilizzo_robot(num_records=NUM_UTILIZZO_ROBOT):
    """Genera INSERT per la tabella UTILIZZO_ROBOT"""
    records = []
    relazioni_generate = set()
    
    for i in range(1, num_records + 1):
        while True:
            missione = random.randint(1, NUM_MISSIONI)
            robot = random.randint(1, NUM_ROBOT)
            relazione = (missione, robot)
            
            if relazione not in relazioni_generate:
                relazioni_generate.add(relazione)
                records.append(f"INSERT INTO UTILIZZO_ROBOT (MissioneID, RobotID) VALUES ({missione}, {robot});")
                break
    
    return records

def genera_partecipazioni(num_records=NUM_PARTECIPAZIONI):
    """Genera INSERT per la tabella PARTECIPAZIONI"""
    records = []
    relazioni_generate = set()
    
    for i in range(1, num_records + 1):
        while True:
            missione = random.randint(1, NUM_MISSIONI)
            membro = random.randint(1, NUM_MEMBRI)
            relazione = (missione, membro)
            
            if relazione not in relazioni_generate:
                relazioni_generate.add(relazione)
                records.append(f"INSERT INTO PARTECIPAZIONI (MissioneID, MembroID) VALUES ({missione}, {membro});")
                break
    
    return records

def genera_coinvolgimenti(num_records=NUM_COINVOLGIMENTI):
    """Genera INSERT per la tabella COINVOLGIMENTI"""
    records = []
    relazioni_generate = set()
    
    for i in range(1, num_records + 1):
        while True:
            intervento = random.randint(1, NUM_INTERVENTI)
            membro = random.randint(1, NUM_MEMBRI)
            relazione = (intervento, membro)
            
            if relazione not in relazioni_generate:
                relazioni_generate.add(relazione)
                records.append(f"INSERT INTO COINVOLGIMENTI (InterventoID, MembroID) VALUES ({intervento}, {membro});")
                break
    
    return records

def genera_interazioni_tecniche(num_records=NUM_INTERAZIONI_TECNICHE):
    """Genera INSERT per la tabella INTERAZIONI_TECNICHE"""
    records = []
    for i in range(1, num_records + 1):
        membro = random.randint(1, NUM_MEMBRI)
        sensore = random.randint(1, NUM_SENSORI)
        timestamp = random_timestamp()
        tipo = random.choice(TIPI_INTERAZIONE)
        records.append(f"INSERT INTO INTERAZIONI_TECNICHE (MembroID, SensoreID, Timestamp, Tipo) VALUES ({membro}, {sensore}, TO_TIMESTAMP('{timestamp}', 'YYYY-MM-DD HH24:MI:SS'), '{tipo}');")
    return records

def genera_risoluzioni(num_records=NUM_RISOLUZIONI):
    """Genera INSERT per la tabella RISOLUZIONI"""
    records = []
    max_risoluzioni = min(NUM_INTERVENTI, NUM_ANOMALIE)
    
    for i in range(1, min(num_records, max_risoluzioni) + 1):
        intervento = i
        anomalia = i
        esito = random.choice(['risolta', 'non_risolta'])
        data = random_timestamp()
        records.append(f"INSERT INTO RISOLUZIONI (InterventoID, AnomaliaID, Esito, DataEsecuzione) VALUES ({intervento}, {anomalia}, '{esito}', TO_DATE('{data.split()[0]}', 'YYYY-MM-DD'));")
    
    return records

def genera_redazioni(num_records=NUM_REDAZIONI):
    """Genera INSERT per la tabella REDAZIONE"""
    records = []
    max_redazioni = min(NUM_REPORT, num_records)
    
    for i in range(1, max_redazioni + 1):
        membro = random.randint(1, NUM_MEMBRI)
        missione = random.randint(1, NUM_MISSIONI)
        report = i
        data = random_timestamp()
        records.append(f"INSERT INTO REDAZIONE (MembroID, MissioneID, ReportID, Data) VALUES ({membro}, {missione}, {report}, TO_TIMESTAMP('{data}', 'YYYY-MM-DD HH24:MI:SS'));")
    
    return records

def salva_su_file(records, filepath):
    """Salva i record generati su un file"""
    with open(filepath, "w") as f:
        f.write("\n".join(records))
    print(f"File generato: {filepath} con {len(records)} records")

def main():
    """Funzione principale che coordina la generazione dei dati"""
    # Entità principali in un unico file
    entita_principali = []
    entita_principali.extend(genera_missioni())
    entita_principali.extend(genera_membri())
    entita_principali.extend(genera_sensori())
    entita_principali.extend(genera_robot())
    salva_su_file(entita_principali, "seed_partenope_orbitale.sql")
    
    # Entità secondarie e relazioni in un secondo file
    relazioni = []
    relazioni.extend(genera_rilevazioni())
    relazioni.extend(genera_anomalie())
    relazioni.extend(genera_interventi())
    relazioni.extend(genera_report())
    relazioni.extend(genera_utilizzo_sensori())
    relazioni.extend(genera_utilizzo_robot())
    relazioni.extend(genera_partecipazioni())
    relazioni.extend(genera_coinvolgimenti())
    relazioni.extend(genera_interazioni_tecniche())
    relazioni.extend(genera_risoluzioni())
    relazioni.extend(genera_redazioni())
    salva_su_file(relazioni, "seed_partenope_orbitale_2.sql")

# Esecuzione del programma
if __name__ == "__main__":
    main()