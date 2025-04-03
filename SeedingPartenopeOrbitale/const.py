# Configurazione: numero di record per ogni tabella
NUM_MISSIONI = 20
NUM_MEMBRI = 40
NUM_SENSORI = 30
NUM_ROBOT = 20
NUM_RILEVAZIONI = 200         
NUM_ANOMALIE = 60             
NUM_INTERVENTI = 50           
NUM_REPORT = 20               
NUM_UTILIZZO_SENSORI = 60     
NUM_UTILIZZO_ROBOT = 40       
NUM_PARTECIPAZIONI = 60       
NUM_COINVOLGIMENTI = 60       
NUM_INTERAZIONI_TECNICHE = 90 
NUM_RISOLUZIONI = 50          
NUM_REDAZIONI = 20           

# ENUM
STATI_MISSIONE = ['pianificata', 'in_corso', 'completata', 'annullata']
TIPI_SENSORE = ['temperatura', 'pressione', 'gas', 'radiazioni', 'geologia']
STATI_SENSORE = ['attivo', 'standby', 'manutenzione', 'malfunzionante']
TIPI_ROBOT = ['esplorazione', 'manutenzione', 'raccolta_risorse']
LIVELLI_ANOMALIA = ['bassa', 'media', 'alta', 'critica']
TIPI_INTERAZIONE = ['manutenzione', 'riparazione', 'verifica']

# Attributi descrittivi
RUOLI_EQUIPAGGIO = [
    "Ingegnere di Sensori",
    "Tecnico Robotico",
    "Analista Dati Lunari",
    "Esperto di Anomalie",
    "Preparatore Craterico",
    "AstroCalciatore",
    "Fisio Spaziale",
    "Tattico Marziano",
    "Responsabile del Modulo Kvara",
    "Scout Gravità Zero",
    "Addetto al VAR Lunare",
    "Analista di Telemetria",
    "Comunicatore Terra-Luna",
]
OBBIETTIVI_MISSIONI = [
    "Mappatura geologica del Cratere Maradona",
    "Ricerca di ghiaccio sotterraneo",
    "Installazione sensori atmosferici",
    "Raccolta campioni minerali",
    "Test di robot a gravità ridotta",
    "Analisi radiazioni cosmiche",
    "Costruzione modulo sperimentale",
    "Calibrazione apparati scientifici",
    "Tracciamento polveri lunari",
    "Addestramento tattico orbitale"
]

CAUSE_ANOMALIE = [
    "Sovraccarico energetico",
    "Tempesta di polveri",
    "Danno da impatto micrometeoriti",
    "Errore di calibrazione",
    "Infiltrazione di regolite",
    "Interferenza elettromagnetica",
    "Surriscaldamento circuito principale",
    "Malfunzionamento software",
    "Corrosione da radiazione",
    "Perdita di segnale remoto"
]
VALUTAZIONI_REPORT = [
    "Missione riuscita con successo",
    "Obiettivo completato, anomalie minori",
    "Comunicazioni intermittenti",
    "Completamento parziale della missione",
    "Operazioni ritardate da guasti tecnici",
    "Performance oltre le aspettative",
    "Robot malfunzionante, intervento richiesto",
    "Rilevazioni incoerenti, verifica necessaria",
    "Installazione completata senza problemi",
    "Situazione sotto controllo"
]