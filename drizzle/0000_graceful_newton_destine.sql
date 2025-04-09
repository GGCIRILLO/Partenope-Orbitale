CREATE TABLE `ANOMALIE` (
	`ID` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`Timestamp` text NOT NULL,
	`Livello` text NOT NULL,
	`Causa` text(100) NOT NULL,
	`SensoreID` integer NOT NULL,
	FOREIGN KEY (`SensoreID`) REFERENCES `SENSORI`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `IDX_ANOMALIE_LIVELLO` ON `ANOMALIE` (`Livello`);--> statement-breakpoint
CREATE TABLE `COINVOLGIMENTI` (
	`InterventoID` integer NOT NULL,
	`MembroID` integer NOT NULL,
	PRIMARY KEY(`InterventoID`, `MembroID`),
	FOREIGN KEY (`InterventoID`) REFERENCES `INTERVENTI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`MembroID`) REFERENCES `MEMBRI_EQUIPAGGIO`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `INTERAZIONI_TECNICHE` (
	`MembroID` integer NOT NULL,
	`SensoreID` integer NOT NULL,
	`Timestamp` text NOT NULL,
	`Tipo` text NOT NULL,
	PRIMARY KEY(`MembroID`, `SensoreID`, `Timestamp`),
	FOREIGN KEY (`MembroID`) REFERENCES `MEMBRI_EQUIPAGGIO`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`SensoreID`) REFERENCES `SENSORI`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `INTERVENTI` (
	`ID` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`Descrizione` text(100) NOT NULL,
	`DataEsecuzione` text NOT NULL,
	`Esito` text(30)
);
--> statement-breakpoint
CREATE TABLE `MEMBRI_EQUIPAGGIO` (
	`ID` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`Nome` text(50) NOT NULL,
	`Cognome` text(50) NOT NULL,
	`Ruolo` text(30) NOT NULL
);
--> statement-breakpoint
CREATE INDEX `IDX_MEMBRI_RUOLO` ON `MEMBRI_EQUIPAGGIO` (`Ruolo`);--> statement-breakpoint
CREATE TABLE `MISSIONI` (
	`ID` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`Obiettivo` text(100) NOT NULL,
	`DataInizio` text NOT NULL,
	`DataFine` text,
	`Stato` text NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `MISSIONI_ID_unique` ON `MISSIONI` (`ID`);--> statement-breakpoint
CREATE INDEX `IDX_MISSIONI_STATO` ON `MISSIONI` (`Stato`);--> statement-breakpoint
CREATE TABLE `PARTECIPAZIONI` (
	`MissioneID` integer NOT NULL,
	`MembroID` integer NOT NULL,
	PRIMARY KEY(`MissioneID`, `MembroID`),
	FOREIGN KEY (`MissioneID`) REFERENCES `MISSIONI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`MembroID`) REFERENCES `MEMBRI_EQUIPAGGIO`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `REDAZIONE` (
	`MembroID` integer NOT NULL,
	`MissioneID` integer NOT NULL,
	`ReportID` integer NOT NULL,
	`Data` text NOT NULL,
	PRIMARY KEY(`MembroID`, `MissioneID`),
	FOREIGN KEY (`MembroID`) REFERENCES `MEMBRI_EQUIPAGGIO`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`MissioneID`) REFERENCES `MISSIONI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`ReportID`) REFERENCES `REPORT`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `IDX_REPORT_DATA` ON `REDAZIONE` (`Data`);--> statement-breakpoint
CREATE TABLE `REPORT` (
	`ID` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`Valutazione` text(100)
);
--> statement-breakpoint
CREATE TABLE `RILEVAZIONI` (
	`ID` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`Timestamp` text NOT NULL,
	`Valore` real NOT NULL,
	`SensoreID` integer NOT NULL,
	FOREIGN KEY (`SensoreID`) REFERENCES `SENSORI`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `IDX_RILEVAZIONI_SENSORI_TIMESTAMP` ON `RILEVAZIONI` (`SensoreID`,`Timestamp`);--> statement-breakpoint
CREATE TABLE `RISOLUZIONI` (
	`InterventoID` integer PRIMARY KEY NOT NULL,
	`AnomaliaID` integer NOT NULL,
	`Esito` text(20),
	`DataEsecuzione` text NOT NULL,
	FOREIGN KEY (`InterventoID`) REFERENCES `INTERVENTI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`AnomaliaID`) REFERENCES `ANOMALIE`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `ROBOT` (
	`ID` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`Tipo` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `SENSORI` (
	`ID` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`Tipo` text NOT NULL,
	`Latitudine` real NOT NULL,
	`Longitudine` real NOT NULL,
	`Altitudine` real NOT NULL,
	`DataInstallazione` text NOT NULL,
	`DataUltimoControllo` text,
	`Stato` text NOT NULL
);
--> statement-breakpoint
CREATE INDEX `IDX_SENSORI_TIPO` ON `SENSORI` (`Tipo`);--> statement-breakpoint
CREATE TABLE `UTILIZZO_ROBOT` (
	`MissioneID` integer NOT NULL,
	`RobotID` integer NOT NULL,
	PRIMARY KEY(`MissioneID`, `RobotID`),
	FOREIGN KEY (`MissioneID`) REFERENCES `MISSIONI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`RobotID`) REFERENCES `ROBOT`(`ID`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `UTILIZZO_SENSORI` (
	`MissioneID` integer NOT NULL,
	`SensoreID` integer NOT NULL,
	PRIMARY KEY(`MissioneID`, `SensoreID`),
	FOREIGN KEY (`MissioneID`) REFERENCES `MISSIONI`(`ID`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`SensoreID`) REFERENCES `SENSORI`(`ID`) ON UPDATE no action ON DELETE no action
);
