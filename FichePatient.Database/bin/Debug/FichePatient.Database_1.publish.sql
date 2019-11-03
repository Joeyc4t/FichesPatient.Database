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
La colonne [dbo].[PATIENT].[CODE_POSTAL] est en cours de suppression, des données risquent d'être perdues.
*/

IF EXISTS (select top 1 1 from [dbo].[PATIENT])
    RAISERROR (N'Lignes détectées. Arrêt de la mise à jour du schéma en raison d''''un risque de perte de données.', 16, 127) WITH NOWAIT

GO
PRINT N'L''opération de refactorisation de changement de nom avec la clé eb2c9db3-2945-40ef-9342-42ec1a285e4c est ignorée, l''élément [dbo].[LOCALITE].[Id] (SqlSimpleColumn) ne sera pas renommé en ID';


GO
PRINT N'Modification de [dbo].[PATIENT]...';


GO
ALTER TABLE [dbo].[PATIENT] DROP COLUMN [CODE_POSTAL];


GO
PRINT N'Création de [dbo].[LOCALITE]...';


GO
CREATE TABLE [dbo].[LOCALITE] (
    [ID]          INT           NOT NULL,
    [NOM]         NVARCHAR (75) NOT NULL,
    [CODE_POSTAL] INT           NOT NULL,
    [COMMUNE]     NVARCHAR (75) NOT NULL,
    [PROVINCE]    NVARCHAR (75) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
PRINT N'Création de [dbo].[FK_PATIENT_LOCALITE]...';


GO
ALTER TABLE [dbo].[PATIENT] WITH NOCHECK
    ADD CONSTRAINT [FK_PATIENT_LOCALITE] FOREIGN KEY ([LOCALITE_ID]) REFERENCES [dbo].[LOCALITE] ([ID]);


GO
-- Étape de refactorisation pour mettre à jour le serveur cible avec des journaux de transactions déployés
IF NOT EXISTS (SELECT OperationKey FROM [dbo].[__RefactorLog] WHERE OperationKey = 'eb2c9db3-2945-40ef-9342-42ec1a285e4c')
INSERT INTO [dbo].[__RefactorLog] (OperationKey) values ('eb2c9db3-2945-40ef-9342-42ec1a285e4c')

GO

GO
PRINT N'Vérification de données existantes par rapport aux nouvelles contraintes';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[PATIENT] WITH CHECK CHECK CONSTRAINT [FK_PATIENT_LOCALITE];


GO
PRINT N'Mise à jour terminée.';


GO
