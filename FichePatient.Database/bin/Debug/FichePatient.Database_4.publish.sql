/*
Script de déploiement pour FichePatient.Database

Ce code a été généré par un outil.
La modification de ce fichier peut provoquer un comportement incorrect et sera perdue si
le code est régénéré.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "FichePatient.Database"
:setvar DefaultFilePrefix "FichePatient.Database"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\"

GO
:on error exit
GO
/*
Détectez le mode SQLCMD et désactivez l'exécution du script si le mode SQLCMD n'est pas pris en charge.
Pour réactiver le script une fois le mode SQLCMD activé, exécutez ce qui suit :
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'Le mode SQLCMD doit être activé de manière à pouvoir exécuter ce script.';
        SET NOEXEC ON;
    END


GO
USE [master];


GO

IF (DB_ID(N'$(DatabaseName)') IS NOT NULL) 
BEGIN
    ALTER DATABASE [$(DatabaseName)]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [$(DatabaseName)];
END

GO
PRINT N'Création de $(DatabaseName)...'
GO
CREATE DATABASE [$(DatabaseName)]
    ON 
    PRIMARY(NAME = [$(DatabaseName)], FILENAME = N'$(DefaultDataPath)$(DefaultFilePrefix)_Primary.mdf')
    LOG ON (NAME = [$(DatabaseName)_log], FILENAME = N'$(DefaultLogPath)$(DefaultFilePrefix)_Primary.ldf') COLLATE SQL_Latin1_General_CP1_CI_AS
GO
USE [$(DatabaseName)];


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET READ_COMMITTED_SNAPSHOT OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Impossible de modifier les paramètres de base de données. Vous devez être administrateur système pour appliquer ces paramètres.';
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET HONOR_BROKER_PRIORITY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'Impossible de modifier les paramètres de base de données. Vous devez être administrateur système pour appliquer ces paramètres.';
    END


GO
ALTER DATABASE [$(DatabaseName)]
    SET TARGET_RECOVERY_TIME = 0 SECONDS 
    WITH ROLLBACK IMMEDIATE;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET FILESTREAM(NON_TRANSACTED_ACCESS = OFF),
                CONTAINMENT = NONE 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF),
                MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF,
                DELAYED_DURABILITY = DISABLED 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE (QUERY_CAPTURE_MODE = ALL, DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_PLANS_PER_QUERY = 200, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 367), MAX_STORAGE_SIZE_MB = 100) 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET QUERY_STORE = OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
        ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
        ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'$(DatabaseName)')
    BEGIN
        ALTER DATABASE [$(DatabaseName)]
            SET TEMPORAL_HISTORY_RETENTION ON 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
PRINT N'Création de [dbo].[ETAT_SANTE]...';


GO
CREATE TABLE [dbo].[ETAT_SANTE] (
    [ID]                                            INT  NOT NULL,
    [AUTO_EXAMEN_POSSIBLE]                          BIT  NOT NULL,
    [AUTO_EXAMEN_POSSIBLE_DESC]                     TEXT NULL,
    [MONOFILAMENT_PG_FAIT]                          BIT  NOT NULL,
    [MONOFILAMENT_PG_FAIT_DESC]                     TEXT NULL,
    [MONOFILAMENT_PD_FAIT]                          BIT  NOT NULL,
    [MONOFILAMENT_PD_FAIT_DESC]                     TEXT NULL,
    [MONOFILAMENT_PG_COTE]                          INT  NULL,
    [MONOFILAMENT_PD_COTE]                          INT  NULL,
    [DIABETE_TYPE_1]                                BIT  NOT NULL,
    [DIABETE_TYPE_1_DESC]                           TEXT NULL,
    [DIABETE_TYPE_2]                                BIT  NOT NULL,
    [DIABETE_TYPE_2_DESC]                           TEXT NULL,
    [DIABETE_SECONDAIRE]                            BIT  NOT NULL,
    [DIABETE_SECONDAIRE_DESC]                       TEXT NULL,
    [PROTHESE_GENOU_G]                              BIT  NOT NULL,
    [PROTHESE_GENOU_G_DESC]                         TEXT NULL,
    [PROTHESE_GENOU_D]                              BIT  NOT NULL,
    [PROTHESE_GENOU_D_DESC]                         TEXT NULL,
    [PROTHESE_HANCHE_D]                             BIT  NOT NULL,
    [PROTHESE_HANCHE_D_DESC]                        TEXT NULL,
    [PROTHESE_HANCHE_G]                             BIT  NOT NULL,
    [PROTHESE_HANCHE_G_DESC]                        TEXT NULL,
    [MALADIES_CARDIAQUES]                           BIT  NOT NULL,
    [MALADIES_CARDIAQUES_DESC]                      TEXT NULL,
    [VALVE_CARDIAQUE]                               BIT  NOT NULL,
    [VALVE_CARDIAQUE_DESC]                          TEXT NULL,
    [ANTI_COAGULANT]                                BIT  NOT NULL,
    [ANTI_COAGULANT_DESC]                           TEXT NULL,
    [THYROIDE]                                      BIT  NOT NULL,
    [THYROIDE_DESC]                                 TEXT NULL,
    [TRANSPLANTE_RENAL]                             BIT  NOT NULL,
    [TRANSPLANTE_RENAL_DESC]                        TEXT NULL,
    [ALLERGIES]                                     BIT  NOT NULL,
    [ALLERGIES_DESC]                                TEXT NULL,
    [AUTRE]                                         BIT  NOT NULL,
    [AUTRE_DESC]                                    TEXT NULL,
    [CIRCULATION_SANGUINE_NORMALE]                  BIT  NOT NULL,
    [CIRCULATION_SANGUINE_NORMALE_DESC]             TEXT NULL,
    [CIRCULATION_SANGUINE_VARICES]                  BIT  NOT NULL,
    [CIRCULATION_SANGUINE_VARICES_DESC]             TEXT NULL,
    [CIRCULATION_SANGUINE_OEDEME]                   BIT  NOT NULL,
    [CIRCULATION_SANGUINE_OEDEME_DESC]              TEXT NULL,
    [TROUBLE_SUDATION_ANIDROSE]                     BIT  NOT NULL,
    [TROUBLE_SUDATION_ANIDROSE_DESC]                TEXT NULL,
    [TROUBLE_SUDATION_HYPERHYDROSE]                 BIT  NOT NULL,
    [TROUBLE_SUDATION_HYPERHYDROSE_DESC]            TEXT NULL,
    [TROUBLE_SUDATION_BROMIDROSE]                   BIT  NOT NULL,
    [TROUBLE_SUDATION_BROMIDROSE_DESC]              TEXT NULL,
    [HYPERKERATOSES_DURILLON]                       BIT  NOT NULL,
    [HYPERKERATOSES_DURILLON_DESC]                  TEXT NULL,
    [HYPERKERATOSES_COR_PERI_UNGUEAL]               BIT  NOT NULL,
    [HYPERKERATOSES_COR_PERI_UNGUEAL_DESC]          TEXT NULL,
    [HYPERKERATOSES_COR_SOUS_UNGUEAL]               BIT  NOT NULL,
    [HYPERKERATOSES_COR_SOUS_UNGUEAL_DESC]          TEXT NULL,
    [HYPERKERATOSES_COR_ARTICULATION_INTERPHA]      BIT  NOT NULL,
    [HYPERKERATOSES_COR_ARTICULATION_INTERPHA_DESC] TEXT NULL,
    [HYPERKERATOSES_COR_PULPAIRE]                   BIT  NOT NULL,
    [HYPERKERATOSES_COR_PULPAIRE_DESC]              TEXT NULL,
    [HYPERKERATOSES_COR_PLANTAIRE]                  BIT  NOT NULL,
    [HYPERKERATOSES_COR_PLANTAIRE_DESC]             TEXT NULL,
    [HYPERKERATOSES_OEIL_PERDRIX]                   BIT  NOT NULL,
    [HYPERKERATOSES_OEIL_PERDRIX_DESC]              TEXT NULL,
    [HYPERKERATOSES_AMPOULE]                        BIT  NOT NULL,
    [HYPERKERATOSES_AMPOULE_DESC]                   TEXT NULL,
    [HYPERKERATOSES_RHAGADE]                        BIT  NOT NULL,
    [HYPERKERATOSES_RHAGADE_DESC]                   TEXT NULL,
    [HYPERKERATOSES_ECZEMA]                         BIT  NOT NULL,
    [HYPERKERATOSES_ECZEMA_DESC]                    TEXT NULL,
    [HYPERKERATOSES_VERRUE]                         BIT  NOT NULL,
    [HYPERKERATOSES_VERRUE_DESC]                    TEXT NULL,
    [HYPERKERATOSES_PSORIASIS]                      BIT  NOT NULL,
    [HYPERKERATOSES_PSORIASIS_DESC]                 TEXT NULL,
    [REMARQUES]                                     TEXT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
PRINT N'Création de [dbo].[PATIENT]...';


GO
CREATE TABLE [dbo].[PATIENT] (
    [ID]                         INT            IDENTITY (1, 1) NOT NULL,
    [NOM_FAMILLE]                NVARCHAR (75)  NOT NULL,
    [PRENOM]                     NVARCHAR (75)  NOT NULL,
    [RUE]                        NVARCHAR (MAX) NOT NULL,
    [NUMERO]                     NVARCHAR (10)  NOT NULL,
    [LOCALITE_ID]                INT            NOT NULL,
    [DATE_NAISSANCE]             DATETIME2 (7)  NULL,
    [TELEPHONE]                  NVARCHAR (50)  NULL,
    [EMAIL]                      NVARCHAR (100) NULL,
    [MEDECIN_TRAITANT]           NVARCHAR (100) NULL,
    [MEDECIN_TRAITANT_TELEPHONE] NVARCHAR (50)  NULL,
    [ETAT_SANTE_ID]              INT            NOT NULL,
    [STATUTENREGISTREMENT]       BIT            NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
PRINT N'Création de [dbo].[SOIN]...';


GO
CREATE TABLE [dbo].[SOIN] (
    [ID]         INT           NOT NULL,
    [DATE]       DATETIME2 (7) NOT NULL,
    [TRAITEMENT] TEXT          NULL,
    [PANSEMENTS] TEXT          NULL,
    [CONSEILS]   TEXT          NULL,
    [PATIENT_ID] INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
PRINT N'Création de contrainte sans nom sur [dbo].[PATIENT]...';


GO
ALTER TABLE [dbo].[PATIENT]
    ADD DEFAULT 1 FOR [STATUTENREGISTREMENT];


GO
PRINT N'Création de [dbo].[FK_PATIENT_ETATSANTE]...';


GO
ALTER TABLE [dbo].[PATIENT]
    ADD CONSTRAINT [FK_PATIENT_ETATSANTE] FOREIGN KEY ([ETAT_SANTE_ID]) REFERENCES [dbo].[ETAT_SANTE] ([ID]);


GO
PRINT N'Création de [dbo].[FK_SOIN_PATIENT]...';


GO
ALTER TABLE [dbo].[SOIN]
    ADD CONSTRAINT [FK_SOIN_PATIENT] FOREIGN KEY ([PATIENT_ID]) REFERENCES [dbo].[PATIENT] ([ID]);


GO
-- Étape de refactorisation pour mettre à jour le serveur cible avec des journaux de transactions déployés

IF OBJECT_ID(N'dbo.__RefactorLog') IS NULL
BEGIN
    CREATE TABLE [dbo].[__RefactorLog] (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
    EXEC sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
END
GO
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'd390f7a2-9a9b-4533-9fa7-089aaa8bf521')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('d390f7a2-9a9b-4533-9fa7-089aaa8bf521')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '9e58f63c-dc7e-4b67-93f5-8c1cf8b3d0c2')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('9e58f63c-dc7e-4b67-93f5-8c1cf8b3d0c2')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '70ed82ac-ec0d-43bb-9d43-3af5922dc120')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('70ed82ac-ec0d-43bb-9d43-3af5922dc120')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '2301b6dd-6302-4dc0-b45a-edbdb5eaa32b')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('2301b6dd-6302-4dc0-b45a-edbdb5eaa32b')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'eb2c9db3-2945-40ef-9342-42ec1a285e4c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('eb2c9db3-2945-40ef-9342-42ec1a285e4c')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'dcf52525-db8b-46ff-b5c9-b71ed45d7969')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('dcf52525-db8b-46ff-b5c9-b71ed45d7969')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '3456a476-df26-4dd6-a49c-8f90e628827f')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('3456a476-df26-4dd6-a49c-8f90e628827f')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'e7f637ba-44ee-496b-b5d4-653d3226ae45')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('e7f637ba-44ee-496b-b5d4-653d3226ae45')
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = '4a77c482-c8d4-49f6-8184-19d4e63d93c0')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('4a77c482-c8d4-49f6-8184-19d4e63d93c0')

GO

GO
DECLARE @VarDecimalSupported AS BIT;

SELECT @VarDecimalSupported = 0;

IF ((ServerProperty(N'EngineEdition') = 3)
    AND (((@@microsoftversion / power(2, 24) = 9)
          AND (@@microsoftversion & 0xffff >= 3024))
         OR ((@@microsoftversion / power(2, 24) = 10)
             AND (@@microsoftversion & 0xffff >= 1600))))
    SELECT @VarDecimalSupported = 1;

IF (@VarDecimalSupported > 0)
    BEGIN
        EXECUTE sp_db_vardecimal_storage_format N'$(DatabaseName)', 'ON';
    END


GO
PRINT N'Mise à jour terminée.';


GO
