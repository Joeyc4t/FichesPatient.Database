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
PRINT N'Suppression de [dbo].[FK_SOIN_PATIENT]...';


GO
ALTER TABLE [dbo].[SOIN] DROP CONSTRAINT [FK_SOIN_PATIENT];


GO
PRINT N'Début de la régénération de la table [dbo].[SOIN]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_SOIN] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [DATE]       DATETIME2 (7) NOT NULL,
    [TRAITEMENT] TEXT          NULL,
    [PANSEMENTS] TEXT          NULL,
    [CONSEILS]   TEXT          NULL,
    [PATIENT_ID] INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[SOIN])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_SOIN] ON;
        INSERT INTO [dbo].[tmp_ms_xx_SOIN] ([ID], [DATE], [TRAITEMENT], [PANSEMENTS], [CONSEILS], [PATIENT_ID])
        SELECT   [ID],
                 [DATE],
                 [TRAITEMENT],
                 [PANSEMENTS],
                 [CONSEILS],
                 [PATIENT_ID]
        FROM     [dbo].[SOIN]
        ORDER BY [ID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_SOIN] OFF;
    END

DROP TABLE [dbo].[SOIN];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_SOIN]', N'SOIN';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


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
ALTER TABLE [dbo].[SOIN] WITH CHECK CHECK CONSTRAINT [FK_SOIN_PATIENT];


GO
PRINT N'Mise à jour terminée.';


GO
