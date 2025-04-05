CREATE VIEW `ANDAMENTO_MISSIONI` AS select "MISSIONI"."ID", "MISSIONI"."Obiettivo", "MISSIONI"."Stato", COUNT("ANOMALIE"."ID") as "totaleAnomalie" from "MISSIONI" left join "ANOMALIE" on "MISSIONI"."ID" = "ANOMALIE"."SensoreID" group by "MISSIONI"."ID", "MISSIONI"."Obiettivo", "MISSIONI"."Stato" order by totaleAnomalie desc;--> statement-breakpoint
CREATE VIEW `CALENDARIO_INTERVENTI` AS select "INTERVENTI"."ID", "INTERVENTI"."Descrizione", "INTERVENTI"."DataEsecuzione", "ANOMALIE"."ID", "ANOMALIE"."Livello", "ANOMALIE"."SensoreID" from "INTERVENTI" left join "RISOLUZIONI" on "INTERVENTI"."ID" = "RISOLUZIONI"."InterventoID" left join "ANOMALIE" on "RISOLUZIONI"."AnomaliaID" = "ANOMALIE"."ID" order by "INTERVENTI"."DataEsecuzione" asc;--> statement-breakpoint
CREATE VIEW `EROI_DELLA_LUNA` AS select "MEMBRI_EQUIPAGGIO"."ID", "MEMBRI_EQUIPAGGIO"."Nome", "MEMBRI_EQUIPAGGIO"."Cognome", COUNT(DISTINCT "PARTECIPAZIONI"."MissioneID") as "missioniPartecipate", COUNT(DISTINCT "COINVOLGIMENTI"."InterventoID") as "interventiEffettuati" from "MEMBRI_EQUIPAGGIO" left join "PARTECIPAZIONI" on "MEMBRI_EQUIPAGGIO"."ID" = "PARTECIPAZIONI"."MembroID" left join "COINVOLGIMENTI" on "MEMBRI_EQUIPAGGIO"."ID" = "COINVOLGIMENTI"."MembroID" group by "MEMBRI_EQUIPAGGIO"."ID", "MEMBRI_EQUIPAGGIO"."Nome", "MEMBRI_EQUIPAGGIO"."Cognome" order by interventiEffettuati desc;--> statement-breakpoint
CREATE VIEW `REDAZIONE_RECENTE` AS select "REPORT"."ID", "REPORT"."Valutazione", "REDAZIONE"."Data", "MISSIONI"."Obiettivo", "MEMBRI_EQUIPAGGIO"."Nome" || ' ' || "MEMBRI_EQUIPAGGIO"."Cognome" as "autore" from "REPORT" inner join "REDAZIONE" on "REPORT"."ID" = "REDAZIONE"."ReportID" inner join "MISSIONI" on "REDAZIONE"."MissioneID" = "MISSIONI"."ID" inner join "MEMBRI_EQUIPAGGIO" on "REDAZIONE"."MembroID" = "MEMBRI_EQUIPAGGIO"."ID" order by "REDAZIONE"."Data" desc limit 10;--> statement-breakpoint
CREATE VIEW `SENSORI_SOTTO_PRESSIONE` AS select "SENSORI"."ID", "SENSORI"."Tipo", COUNT("ANOMALIE"."ID") as "numeroAnomalie" from "SENSORI" left join "ANOMALIE" on "SENSORI"."ID" = "ANOMALIE"."SensoreID" group by "SENSORI"."ID", "SENSORI"."Tipo" order by numeroAnomalie desc;--> statement-breakpoint
CREATE VIEW `STATISTICHE_RILEVAZIONI` AS select "SENSORI"."ID", "SENSORI"."Tipo", ROUND(AVG("RILEVAZIONI"."Valore"), 2) as "mediaValore", MAX("RILEVAZIONI"."Valore") as "valoreMassimo", MIN("RILEVAZIONI"."Valore") as "valoreMinimo" from "SENSORI" inner join "RILEVAZIONI" on "SENSORI"."ID" = "RILEVAZIONI"."SensoreID" group by "SENSORI"."ID", "SENSORI"."Tipo" order by "SENSORI"."Tipo", mediaValore desc;