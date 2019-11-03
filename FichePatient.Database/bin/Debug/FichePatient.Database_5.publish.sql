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
USE [$(DatabaseName)];


GO
/*
La colonne [dbo].[PATIENT].[CIVILITE] de la table [dbo].[PATIENT] doit être ajoutée mais la colonne ne comporte pas de valeur par défaut et n'autorise pas les valeurs NULL. Si la table contient des données, le script ALTER ne fonctionnera pas. Pour éviter ce problème, vous devez ajouter une valeur par défaut à la colonne, la marquer comme autorisant les valeurs Null ou activer la génération de smart-defaults en tant qu'option de déploiement.
*/

IF EXISTS (select top 1 1 from [dbo].[PATIENT])
    RAISERROR (N'Lignes détectées. Arrêt de la mise à jour du schéma en raison d''''un risque de perte de données.', 16, 127) WITH NOWAIT

GO
PRINT N'Suppression de contrainte sans nom sur [dbo].[PATIENT]...';


GO
ALTER TABLE [dbo].[PATIENT] DROP CONSTRAINT [DF__PATIENT__STATUTE__3B75D760];


GO
PRINT N'Suppression de [dbo].[FK_PATIENT_ETATSANTE]...';


GO
ALTER TABLE [dbo].[PATIENT] DROP CONSTRAINT [FK_PATIENT_ETATSANTE];


GO
PRINT N'Suppression de [dbo].[FK_SOIN_PATIENT]...';


GO
ALTER TABLE [dbo].[SOIN] DROP CONSTRAINT [FK_SOIN_PATIENT];


GO
PRINT N'Début de la régénération de la table [dbo].[PATIENT]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_PATIENT] (
    [ID]                         INT            IDENTITY (1, 1) NOT NULL,
    [CIVILITE]                   NVARCHAR (10)  NOT NULL,
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
    [STATUTENREGISTREMENT]       BIT            DEFAULT 1 NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[PATIENT])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_PATIENT] ON;
        INSERT INTO [dbo].[tmp_ms_xx_PATIENT] ([ID], [NOM_FAMILLE], [PRENOM], [RUE], [NUMERO], [LOCALITE_ID], [DATE_NAISSANCE], [TELEPHONE], [EMAIL], [MEDECIN_TRAITANT], [MEDECIN_TRAITANT_TELEPHONE], [ETAT_SANTE_ID], [STATUTENREGISTREMENT])
        SELECT   [ID],
                 [NOM_FAMILLE],
                 [PRENOM],
                 [RUE],
                 [NUMERO],
                 [LOCALITE_ID],
                 [DATE_NAISSANCE],
                 [TELEPHONE],
                 [EMAIL],
                 [MEDECIN_TRAITANT],
                 [MEDECIN_TRAITANT_TELEPHONE],
                 [ETAT_SANTE_ID],
                 [STATUTENREGISTREMENT]
        FROM     [dbo].[PATIENT]
        ORDER BY [ID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_PATIENT] OFF;
    END

DROP TABLE [dbo].[PATIENT];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_PATIENT]', N'PATIENT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Création de [dbo].[FK_PATIENT_ETATSANTE]...';


GO
ALTER TABLE [dbo].[PATIENT] WITH NOCHECK
    ADD CONSTRAINT [FK_PATIENT_ETATSANTE] FOREIGN KEY ([ETAT_SANTE_ID]) REFERENCES [dbo].[ETAT_SANTE] ([ID]);


GO
PRINT N'Création de [dbo].[FK_SOIN_PATIENT]...';


GO
ALTER TABLE [dbo].[SOIN] WITH NOCHECK
    ADD CONSTRAINT [FK_SOIN_PATIENT] FOREIGN KEY ([PATIENT_ID]) REFERENCES [dbo].[PATIENT] ([ID]);


GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[PATIENT] WITH CHECK CHECK CONSTRAINT [FK_PATIENT_ETATSANTE];

ALTER TABLE [dbo].[SOIN] WITH CHECK CHECK CONSTRAINT [FK_SOIN_PATIENT];


GO
PRINT N'Mise à jour terminée.';


GO
