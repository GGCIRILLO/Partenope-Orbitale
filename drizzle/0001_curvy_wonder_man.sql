PRAGMA foreign_keys=OFF;--> statement-breakpoint
CREATE TABLE `__new_RISOLUZIONI` (
	`InterventoID` integer,
	`AnomaliaID` integer NOT NULL,
	`Esito` text(20),
	`DataEsecuzione` text NOT NULL,
	FOREIGN KEY (`InterventoID`) REFERENCES `INTERVENTI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`AnomaliaID`) REFERENCES `ANOMALIE`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_RISOLUZIONI`("InterventoID", "AnomaliaID", "Esito", "DataEsecuzione") SELECT "InterventoID", "AnomaliaID", "Esito", "DataEsecuzione" FROM `RISOLUZIONI`;--> statement-breakpoint
DROP TABLE `RISOLUZIONI`;--> statement-breakpoint
ALTER TABLE `__new_RISOLUZIONI` RENAME TO `RISOLUZIONI`;--> statement-breakpoint
PRAGMA foreign_keys=ON;--> statement-breakpoint
CREATE UNIQUE INDEX `MISSIONI_ID_unique` ON `MISSIONI` (`ID`);--> statement-breakpoint
CREATE TABLE `__new_ANOMALIE` (
	`ID` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`Timestamp` text NOT NULL,
	`Livello` text NOT NULL,
	`Causa` text(100) NOT NULL,
	`SensoreID` integer NOT NULL,
	FOREIGN KEY (`SensoreID`) REFERENCES `SENSORI`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_ANOMALIE`("ID", "Timestamp", "Livello", "Causa", "SensoreID") SELECT "ID", "Timestamp", "Livello", "Causa", "SensoreID" FROM `ANOMALIE`;--> statement-breakpoint
DROP TABLE `ANOMALIE`;--> statement-breakpoint
ALTER TABLE `__new_ANOMALIE` RENAME TO `ANOMALIE`;--> statement-breakpoint
CREATE TABLE `__new_COINVOLGIMENTI` (
	`InterventoID` integer NOT NULL,
	`MembroID` integer NOT NULL,
	FOREIGN KEY (`InterventoID`) REFERENCES `INTERVENTI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`MembroID`) REFERENCES `MEMBRI_EQUIPAGGIO`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_COINVOLGIMENTI`("InterventoID", "MembroID") SELECT "InterventoID", "MembroID" FROM `COINVOLGIMENTI`;--> statement-breakpoint
DROP TABLE `COINVOLGIMENTI`;--> statement-breakpoint
ALTER TABLE `__new_COINVOLGIMENTI` RENAME TO `COINVOLGIMENTI`;--> statement-breakpoint
CREATE TABLE `__new_INTERAZIONI_TECNICHE` (
	`MembroID` integer NOT NULL,
	`SensoreID` integer NOT NULL,
	`Timestamp` text NOT NULL,
	`Tipo` text NOT NULL,
	FOREIGN KEY (`MembroID`) REFERENCES `MEMBRI_EQUIPAGGIO`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`SensoreID`) REFERENCES `SENSORI`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_INTERAZIONI_TECNICHE`("MembroID", "SensoreID", "Timestamp", "Tipo") SELECT "MembroID", "SensoreID", "Timestamp", "Tipo" FROM `INTERAZIONI_TECNICHE`;--> statement-breakpoint
DROP TABLE `INTERAZIONI_TECNICHE`;--> statement-breakpoint
ALTER TABLE `__new_INTERAZIONI_TECNICHE` RENAME TO `INTERAZIONI_TECNICHE`;--> statement-breakpoint
CREATE TABLE `__new_PARTECIPAZIONI` (
	`MissioneID` integer NOT NULL,
	`MembroID` integer NOT NULL,
	FOREIGN KEY (`MissioneID`) REFERENCES `MISSIONI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`MembroID`) REFERENCES `MEMBRI_EQUIPAGGIO`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_PARTECIPAZIONI`("MissioneID", "MembroID") SELECT "MissioneID", "MembroID" FROM `PARTECIPAZIONI`;--> statement-breakpoint
DROP TABLE `PARTECIPAZIONI`;--> statement-breakpoint
ALTER TABLE `__new_PARTECIPAZIONI` RENAME TO `PARTECIPAZIONI`;--> statement-breakpoint
CREATE TABLE `__new_REDAZIONE` (
	`MembroID` integer NOT NULL,
	`MissioneID` integer NOT NULL,
	`ReportID` integer NOT NULL,
	`Data` text NOT NULL,
	FOREIGN KEY (`MembroID`) REFERENCES `MEMBRI_EQUIPAGGIO`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`MissioneID`) REFERENCES `MISSIONI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`ReportID`) REFERENCES `REPORT`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_REDAZIONE`("MembroID", "MissioneID", "ReportID", "Data") SELECT "MembroID", "MissioneID", "ReportID", "Data" FROM `REDAZIONE`;--> statement-breakpoint
DROP TABLE `REDAZIONE`;--> statement-breakpoint
ALTER TABLE `__new_REDAZIONE` RENAME TO `REDAZIONE`;--> statement-breakpoint
CREATE TABLE `__new_RILEVAZIONI` (
	`ID` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`Timestamp` text NOT NULL,
	`Valore` real NOT NULL,
	`SensoreID` integer NOT NULL,
	FOREIGN KEY (`SensoreID`) REFERENCES `SENSORI`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_RILEVAZIONI`("ID", "Timestamp", "Valore", "SensoreID") SELECT "ID", "Timestamp", "Valore", "SensoreID" FROM `RILEVAZIONI`;--> statement-breakpoint
DROP TABLE `RILEVAZIONI`;--> statement-breakpoint
ALTER TABLE `__new_RILEVAZIONI` RENAME TO `RILEVAZIONI`;--> statement-breakpoint
CREATE TABLE `__new_UTILIZZO_ROBOT` (
	`MissioneID` integer NOT NULL,
	`RobotID` integer NOT NULL,
	FOREIGN KEY (`MissioneID`) REFERENCES `MISSIONI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`RobotID`) REFERENCES `ROBOT`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_UTILIZZO_ROBOT`("MissioneID", "RobotID") SELECT "MissioneID", "RobotID" FROM `UTILIZZO_ROBOT`;--> statement-breakpoint
DROP TABLE `UTILIZZO_ROBOT`;--> statement-breakpoint
ALTER TABLE `__new_UTILIZZO_ROBOT` RENAME TO `UTILIZZO_ROBOT`;--> statement-breakpoint
CREATE TABLE `__new_UTILIZZO_SENSORI` (
	`MissioneID` integer NOT NULL,
	`SensoreID` integer NOT NULL,
	FOREIGN KEY (`MissioneID`) REFERENCES `MISSIONI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`SensoreID`) REFERENCES `SENSORI`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
INSERT INTO `__new_UTILIZZO_SENSORI`("MissioneID", "SensoreID") SELECT "MissioneID", "SensoreID" FROM `UTILIZZO_SENSORI`;--> statement-breakpoint
DROP TABLE `UTILIZZO_SENSORI`;--> statement-breakpoint
ALTER TABLE `__new_UTILIZZO_SENSORI` RENAME TO `UTILIZZO_SENSORI`;