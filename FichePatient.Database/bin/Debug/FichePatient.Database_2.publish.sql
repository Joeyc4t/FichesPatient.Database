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
PRINT N'L''opération suivante a été générée à partir d''un fichier journal de refactorisation dcf52525-db8b-46ff-b5c9-b71ed45d7969';

PRINT N'Renommer [dbo].[ETAT_SANTE].[HYPERKERATOSES_COR_PERI-UNGUEAL] en HYPERKERATOSES_COR_PERI_UNGUEAL';


GO
EXECUTE sp_rename @objname = N'[dbo].[ETAT_SANTE].[HYPERKERATOSES_COR_PERI-UNGUEAL]', @newname = N'HYPERKERATOSES_COR_PERI_UNGUEAL', @objtype = N'COLUMN';


GO
PRINT N'L''opération suivante a été générée à partir d''un fichier journal de refactorisation 3456a476-df26-4dd6-a49c-8f90e628827f';

PRINT N'Renommer [dbo].[ETAT_SANTE].[HYPERKERATOSES_COR_PERI-UNGUEAL_DESC] en HYPERKERATOSES_COR_PERI_UNGUEAL_DESC';


GO
EXECUTE sp_rename @objname = N'[dbo].[ETAT_SANTE].[HYPERKERATOSES_COR_PERI-UNGUEAL_DESC]', @newname = N'HYPERKERATOSES_COR_PERI_UNGUEAL_DESC', @objtype = N'COLUMN';


GO
PRINT N'L''opération suivante a été générée à partir d''un fichier journal de refactorisation e7f637ba-44ee-496b-b5d4-653d3226ae45';

PRINT N'Renommer [dbo].[ETAT_SANTE].[HYPERKERATOSES_COR_SOUS-UNGUEAL] en HYPERKERATOSES_COR_SOUS_UNGUEAL';


GO
EXECUTE sp_rename @objname = N'[dbo].[ETAT_SANTE].[HYPERKERATOSES_COR_SOUS-UNGUEAL]', @newname = N'HYPERKERATOSES_COR_SOUS_UNGUEAL', @objtype = N'COLUMN';


GO
PRINT N'L''opération suivante a été générée à partir d''un fichier journal de refactorisation 4a77c482-c8d4-49f6-8184-19d4e63d93c0';

PRINT N'Renommer [dbo].[ETAT_SANTE].[HYPERKERATOSES_COR_SOUS-UNGUEAL_DESC] en HYPERKERATOSES_COR_SOUS_UNGUEAL_DESC';


GO
EXECUTE sp_rename @objname = N'[dbo].[ETAT_SANTE].[HYPERKERATOSES_COR_SOUS-UNGUEAL_DESC]', @newname = N'HYPERKERATOSES_COR_SOUS_UNGUEAL_DESC', @objtype = N'COLUMN';


GO
-- Étape de refactorisation pour mettre à jour le serveur cible avec des journaux de transactions déployés
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
PRINT N'Mise à jour terminée.';


GO
