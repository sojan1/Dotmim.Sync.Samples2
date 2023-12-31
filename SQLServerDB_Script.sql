USE [master]
GO
/****** Object:  Database [CORE3]    Script Date: 20/09/2023 10:42:38 AM ******/
CREATE DATABASE [CORE3]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CORE_v3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\CORE3.mdf' , SIZE = 301632KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CORE_v3_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS01\MSSQL\DATA\CORE3_log.ldf' , SIZE = 84416KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [CORE3] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CORE3].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CORE3] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CORE3] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CORE3] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CORE3] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CORE3] SET ARITHABORT OFF 
GO
ALTER DATABASE [CORE3] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [CORE3] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CORE3] SET AUTO_UPDATE_STATISTICS OFF 
GO
ALTER DATABASE [CORE3] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CORE3] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CORE3] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CORE3] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CORE3] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CORE3] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CORE3] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CORE3] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CORE3] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CORE3] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CORE3] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [CORE3] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CORE3] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CORE3] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CORE3] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CORE3] SET  MULTI_USER 
GO
ALTER DATABASE [CORE3] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CORE3] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CORE3] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CORE3] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [CORE3] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CORE3] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [CORE3] SET QUERY_STORE = OFF
GO
USE [CORE3]
GO
/****** Object:  User [IIS APPPOOL\MauiWebServerAuth]    Script Date: 20/09/2023 10:42:38 AM ******/
CREATE USER [IIS APPPOOL\MauiWebServerAuth] FOR LOGIN [IIS APPPOOL\MauiWebServerAuth] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [IIS APPPOOL\MauiWebServer]    Script Date: 20/09/2023 10:42:38 AM ******/
CREATE USER [IIS APPPOOL\MauiWebServer] FOR LOGIN [IIS APPPOOL\MauiWebServer] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [IIS APPPOOL\MauiWebServerAuth]
GO
ALTER ROLE [db_owner] ADD MEMBER [IIS APPPOOL\MauiWebServer]
GO
/****** Object:  UserDefinedTableType [dbo].[_clnt_v0_BulkType]    Script Date: 20/09/2023 10:42:38 AM ******/
CREATE TYPE [dbo].[_clnt_v0_BulkType] AS TABLE(
	[GEO_ID] [uniqueidentifier] NOT NULL,
	[CLNT_ID] [varchar](6) NULL,
	[Name] [nvarchar](100) NULL,
	[Description] [nvarchar](255) NULL,
	[EnforceDB] [bit] NULL,
	[KML] [nvarchar](max) NULL,
	PRIMARY KEY CLUSTERED 
(
	[GEO_ID] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
/****** Object:  UserDefinedFunction [dbo].[fnPermittedProjects]    Script Date: 20/09/2023 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Geroc
-- Create date: 26/04/2015
-- Description:	Checks for permission
-- =============================================
CREATE FUNCTION [dbo].[fnPermittedProjects] ()

RETURNS TABLE 
AS

RETURN 
(
	SELECT 
	CLNT_ID + ',' + PROJ_ID AS 'Permitted'
    FROM  dbo._perm
    --WHERE 
    --WIN_ID = SYSTEM_USER
    --AND ACTIVE = 1

	--WIN_ID = SYSTEM_USER AND ACTIVE = 1
	--OR (SELECT CLNT_ID + ',' + PROJ_ID FROM  dbo._perm WHERE WIN_ID = SYSTEM_USER AND ACTIVE = 1 AND CLNT_ID = 'D1' AND PROJ_ID = 'MASTER') = 'D1,MASTER'
	--OR (SELECT CLNT_ID + ',' + PROJ_ID FROM  dbo._perm WHERE WIN_ID = SYSTEM_USER AND ACTIVE = 1) = 'MASTER,MASTER'
)
GO
/****** Object:  Table [dbo].[_clnt]    Script Date: 20/09/2023 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_clnt](
	[GEO_ID] [uniqueidentifier] NOT NULL,
	[CLNT_ID] [varchar](6) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Description] [nvarchar](255) NULL,
	[EnforceDB] [bit] NULL,
	[KML] [nvarchar](max) NULL,
 CONSTRAINT [PK__clnt] PRIMARY KEY NONCLUSTERED 
(
	[GEO_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX__clnt] UNIQUE CLUSTERED 
(
	[CLNT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[scope_info]    Script Date: 20/09/2023 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[scope_info](
	[sync_scope_name] [nvarchar](100) NOT NULL,
	[sync_scope_schema] [nvarchar](max) NULL,
	[sync_scope_setup] [nvarchar](max) NULL,
	[sync_scope_version] [nvarchar](10) NULL,
	[sync_scope_last_clean_timestamp] [bigint] NULL,
	[sync_scope_properties] [nvarchar](max) NULL,
 CONSTRAINT [PKey_scope_info_server] PRIMARY KEY CLUSTERED 
(
	[sync_scope_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[scope_info_client]    Script Date: 20/09/2023 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[scope_info_client](
	[sync_scope_id] [uniqueidentifier] NOT NULL,
	[sync_scope_name] [nvarchar](100) NOT NULL,
	[sync_scope_hash] [nvarchar](100) NOT NULL,
	[sync_scope_parameters] [nvarchar](max) NULL,
	[scope_last_sync_timestamp] [bigint] NULL,
	[scope_last_server_sync_timestamp] [bigint] NULL,
	[scope_last_sync_duration] [bigint] NULL,
	[scope_last_sync] [datetime] NULL,
	[sync_scope_errors] [nvarchar](max) NULL,
	[sync_scope_properties] [nvarchar](max) NULL,
 CONSTRAINT [PKey_scope_info_client] PRIMARY KEY CLUSTERED 
(
	[sync_scope_id] ASC,
	[sync_scope_name] ASC,
	[sync_scope_hash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[_clnt] ADD  CONSTRAINT [DF__clnt_GEO_ID]  DEFAULT (newid()) FOR [GEO_ID]
GO
/****** Object:  StoredProcedure [dbo].[_clnt_v0_bulkdelete]    Script Date: 20/09/2023 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_clnt_v0_bulkdelete]
	@sync_min_timestamp bigint,
	@sync_scope_id uniqueidentifier,
	@changeTable [dbo].[_clnt_v0_BulkType] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got deleted
declare @dms_changed TABLE ([GEO_ID] uniqueidentifier,  PRIMARY KEY ( [GEO_ID]));

DECLARE @var_sync_scope_id varbinary(128) = cast(@sync_scope_id as varbinary(128));

;WITH 
  CHANGE_TRACKING_CONTEXT(@var_sync_scope_id),
  [_clnt_tracking] AS (
	SELECT [p].[GEO_ID], 
	CAST([CT].[SYS_CHANGE_CONTEXT] as uniqueidentifier) AS [sync_update_scope_id], 
	[CT].[SYS_CHANGE_VERSION] as [sync_timestamp],
	CASE WHEN [CT].[SYS_CHANGE_OPERATION] = 'D' THEN 1 ELSE 0 END AS [sync_row_is_tombstone]
	FROM @changeTable AS [p] 
	LEFT JOIN CHANGETABLE(CHANGES [_clnt], @sync_min_timestamp) AS [CT] ON [p].[GEO_ID] = [CT].[GEO_ID]
	)
DELETE [_clnt]
OUTPUT  DELETED.[GEO_ID]
INTO @dms_changed 
FROM [_clnt] [base]
JOIN [_clnt_tracking] [changes] ON [changes].[GEO_ID] = [base].[GEO_ID]
WHERE [changes].[sync_timestamp] <= @sync_min_timestamp OR [changes].[sync_timestamp] IS NULL OR [changes].[sync_update_scope_id] = @sync_scope_id;



--Select all ids not inserted / deleted / updated as conflict
SELECT  [t].[GEO_ID] ,[t].[CLNT_ID] ,[t].[Name] ,[t].[Description] ,[t].[EnforceDB] ,[t].[KML]
FROM @changeTable [t]
WHERE NOT EXISTS (
	 SELECT  [GEO_ID]	 FROM @dms_changed [i]
	 WHERE  [t].[GEO_ID] = [i].[GEO_ID]	)

END
GO
/****** Object:  StoredProcedure [dbo].[_clnt_v0_bulkupdate]    Script Date: 20/09/2023 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_clnt_v0_bulkupdate]
	@sync_min_timestamp bigint,
	@sync_scope_id uniqueidentifier,
	@changeTable [dbo].[_clnt_v0_BulkType] READONLY
AS
BEGIN
-- use a temp table to store the list of PKs that successfully got updated/inserted
declare @dms_changed TABLE ([GEO_ID] uniqueidentifier,  PRIMARY KEY ( [GEO_ID]));

DECLARE @var_sync_scope_id varbinary(128) = cast(@sync_scope_id as varbinary(128));

;WITH 
  CHANGE_TRACKING_CONTEXT(@var_sync_scope_id),
  [_clnt_tracking] AS (
	SELECT [p].[GEO_ID], [p].[CLNT_ID], [p].[Name], [p].[Description], [p].[EnforceDB], [p].[KML], 
	CAST([CT].[SYS_CHANGE_CONTEXT] AS uniqueidentifier) AS [sync_update_scope_id],
	[CT].[SYS_CHANGE_VERSION] AS [sync_timestamp],
	CASE WHEN [CT].[SYS_CHANGE_OPERATION] = 'D' THEN 1 ELSE 0 END AS [sync_row_is_tombstone],
	[CT].[SYS_CHANGE_COLUMNS] AS [sync_change_columns]
	FROM @changeTable AS [p]
	LEFT JOIN CHANGETABLE(CHANGES [_clnt], @sync_min_timestamp) AS [CT] ON [CT].[GEO_ID] = [p].[GEO_ID]
	)
MERGE [_clnt] AS [base]
USING [_clnt_tracking] as [changes] ON [changes].[GEO_ID] = [base].[GEO_ID]
WHEN MATCHED AND (
	[changes].[sync_timestamp] <= @sync_min_timestamp
	OR [changes].[sync_timestamp] IS NULL
	OR [changes].[sync_update_scope_id] = @sync_scope_id
) THEN
	UPDATE SET
	[CLNT_ID] = [changes].[CLNT_ID]
	, [Name] = [changes].[Name]
	, [Description] = [changes].[Description]
	, [EnforceDB] = [changes].[EnforceDB]
	, [KML] = [changes].[KML]
WHEN NOT MATCHED BY TARGET AND ([changes].[sync_timestamp] <= @sync_min_timestamp OR [changes].[sync_timestamp] IS NULL) THEN

	INSERT
	([GEO_ID], [CLNT_ID], [Name], [Description], [EnforceDB], [KML])
	VALUES ([changes].[GEO_ID], [changes].[CLNT_ID], [changes].[Name], [changes].[Description], [changes].[EnforceDB], [changes].[KML])

OUTPUT  INSERTED.[GEO_ID]
	INTO @dms_changed; -- populates the temp table with successful PKs

--Select all ids not inserted / deleted / updated as conflict
SELECT  [t].[GEO_ID] ,[t].[CLNT_ID] ,[t].[Name] ,[t].[Description] ,[t].[EnforceDB] ,[t].[KML]
FROM @changeTable [t]
WHERE NOT EXISTS (
	 SELECT  [GEO_ID]	 FROM @dms_changed [i]
	 WHERE  [t].[GEO_ID] = [i].[GEO_ID]	)

END
GO
/****** Object:  StoredProcedure [dbo].[_clnt_v0_changes]    Script Date: 20/09/2023 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_clnt_v0_changes]
	@sync_min_timestamp bigint,
	@sync_scope_id uniqueidentifier
AS
BEGIN
;WITH 
  [_clnt_tracking] AS (
	SELECT [CT].[GEO_ID], 
	CAST([CT].[SYS_CHANGE_CONTEXT] AS uniqueidentifier) AS [sync_update_scope_id],
	[CT].[SYS_CHANGE_VERSION] AS [sync_timestamp],
	CASE WHEN [CT].[SYS_CHANGE_OPERATION] = 'D' THEN 1 ELSE 0 END AS [sync_row_is_tombstone],
	[CT].[SYS_CHANGE_COLUMNS] AS [sync_change_columns]
	FROM CHANGETABLE(CHANGES [_clnt], @sync_min_timestamp) AS [CT]
	)
SELECT DISTINCT
	[side].[GEO_ID], 
	[base].[CLNT_ID], 
	[base].[Name], 
	[base].[Description], 
	[base].[EnforceDB], 
	[base].[KML], 
	[side].[sync_row_is_tombstone],
	[side].[sync_update_scope_id]
FROM [_clnt] [base]
RIGHT JOIN [_clnt_tracking] [side]ON [base].[GEO_ID] = [side].[GEO_ID]
WHERE (
	[side].[sync_timestamp] > @sync_min_timestamp
	AND ([side].[sync_update_scope_id] <> @sync_scope_id OR [side].[sync_update_scope_id] IS NULL)
)

END
GO
/****** Object:  StoredProcedure [dbo].[_clnt_v0_delete]    Script Date: 20/09/2023 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_clnt_v0_delete]
	@GEO_ID uniqueidentifier,
	@sync_force_write int,
	@sync_min_timestamp bigint,
	@sync_scope_id uniqueidentifier,
	@sync_row_count int OUTPUT
AS
BEGIN
SET @sync_row_count = 0;

DECLARE @var_sync_scope_id varbinary(128) = cast(@sync_scope_id as varbinary(128));

;WITH 
  CHANGE_TRACKING_CONTEXT(@var_sync_scope_id),
  [_clnt_tracking] AS (
	SELECT [p].[GEO_ID], 
	CAST([CT].[SYS_CHANGE_CONTEXT] as uniqueidentifier) AS [sync_update_scope_id],
	[CT].[SYS_CHANGE_VERSION] as [sync_timestamp],
	CASE WHEN [CT].[SYS_CHANGE_OPERATION] = 'D' THEN 1 ELSE 0 END AS [sync_row_is_tombstone]
	FROM (SELECT @GEO_ID as [GEO_ID]) AS [p]
	LEFT JOIN CHANGETABLE(CHANGES [_clnt], @sync_min_timestamp) AS [CT] ON [CT].[GEO_ID] = [p].[GEO_ID]	)
DELETE [_clnt]
FROM [_clnt] [base]
JOIN [_clnt_tracking] [side] ON [base].[GEO_ID] = [side].[GEO_ID]
WHERE ([side].[sync_timestamp] <= @sync_min_timestamp OR [side].[sync_timestamp] IS NULL OR [side].[sync_update_scope_id] = @sync_scope_id OR @sync_force_write = 1)
AND ([base].[GEO_ID] = @GEO_ID);

SET @sync_row_count = @@ROWCOUNT;

END
GO
/****** Object:  StoredProcedure [dbo].[_clnt_v0_initialize]    Script Date: 20/09/2023 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_clnt_v0_initialize]
	@sync_min_timestamp bigint = NULL
AS
BEGIN
;WITH 
  [_clnt_tracking] AS (
	SELECT [CT].[GEO_ID], 
	CAST([CT].[SYS_CHANGE_CONTEXT] as uniqueidentifier) AS [sync_update_scope_id], 
	[CT].[SYS_CHANGE_VERSION] as [sync_timestamp],
	CASE WHEN [CT].[SYS_CHANGE_OPERATION] = 'D' THEN 1 ELSE 0 END AS [sync_row_is_tombstone]
	FROM CHANGETABLE(CHANGES [_clnt], @sync_min_timestamp) AS [CT]
	)
SELECT 
	  [base].[GEO_ID]
	, [base].[CLNT_ID]
	, [base].[Name]
	, [base].[Description]
	, [base].[EnforceDB]
	, [base].[KML]
	, [side].[sync_row_is_tombstone] as [sync_row_is_tombstone]
FROM [_clnt] [base]
LEFT JOIN [_clnt_tracking] [side] ON [base].[GEO_ID] = [side].[GEO_ID]
WHERE (
	([side].[sync_timestamp] > @sync_min_timestamp OR @sync_min_timestamp IS NULL)
)
UNION
SELECT
	  [side].[GEO_ID]
	, [base].[CLNT_ID]
	, [base].[Name]
	, [base].[Description]
	, [base].[EnforceDB]
	, [base].[KML]
	, [side].[sync_row_is_tombstone] as [sync_row_is_tombstone]
FROM [_clnt] [base]
RIGHT JOIN [_clnt_tracking] [side] ON [base].[GEO_ID] = [side].[GEO_ID]
WHERE ([side].[sync_timestamp] > @sync_min_timestamp AND [side].[sync_row_is_tombstone] = 1);

END
GO
/****** Object:  StoredProcedure [dbo].[_clnt_v0_update]    Script Date: 20/09/2023 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[_clnt_v0_update]
	@GEO_ID uniqueidentifier,
	@CLNT_ID varchar (6),
	@Name nvarchar (100) = NULL,
	@Description nvarchar (255) = NULL,
	@EnforceDB bit = NULL,
	@KML nvarchar (MAX) = NULL,
	@sync_min_timestamp bigint,
	@sync_scope_id uniqueidentifier,
	@sync_force_write int,
	@sync_row_count int OUTPUT
AS
BEGIN

DECLARE @var_sync_scope_id varbinary(128) = cast(@sync_scope_id as varbinary(128));

SET @sync_row_count = 0;

;WITH 
  CHANGE_TRACKING_CONTEXT(@var_sync_scope_id),
  [_clnt_tracking] AS (
	SELECT [p].[GEO_ID], [p].[CLNT_ID], [p].[Name], [p].[Description], [p].[EnforceDB], [p].[KML], 
	CAST([CT].[SYS_CHANGE_CONTEXT] as uniqueidentifier) AS [sync_update_scope_id],
	[CT].[SYS_CHANGE_VERSION] AS [sync_timestamp],
	CASE WHEN [CT].[SYS_CHANGE_OPERATION] = 'D' THEN 1 ELSE 0 END AS [sync_row_is_tombstone],
	[CT].[SYS_CHANGE_COLUMNS] AS [sync_change_columns]
	FROM (SELECT 
		 @GEO_ID as [GEO_ID], @CLNT_ID as [CLNT_ID], @Name as [Name], @Description as [Description], @EnforceDB as [EnforceDB], @KML as [KML]) AS [p]
	LEFT JOIN CHANGETABLE(CHANGES [_clnt], @sync_min_timestamp) AS [CT] ON [CT].[GEO_ID] = [p].[GEO_ID]	)
MERGE [_clnt] AS [base]
USING [_clnt_tracking] as [changes] ON [changes].[GEO_ID] = [base].[GEO_ID]
WHEN MATCHED AND (
	[changes].[sync_timestamp] <= @sync_min_timestamp
	OR [changes].[sync_timestamp] IS NULL
	OR [changes].[sync_update_scope_id] = @sync_scope_id
	OR @sync_force_write = 1
) THEN
	UPDATE SET
	[CLNT_ID] = [changes].[CLNT_ID]
	, [Name] = [changes].[Name]
	, [Description] = [changes].[Description]
	, [EnforceDB] = [changes].[EnforceDB]
	, [KML] = [changes].[KML]
WHEN NOT MATCHED BY TARGET AND ([changes].[sync_timestamp] <= @sync_min_timestamp OR [changes].[sync_timestamp] IS NULL OR @sync_force_write = 1) THEN

	INSERT
	([GEO_ID], [CLNT_ID], [Name], [Description], [EnforceDB], [KML])
	VALUES ([changes].[GEO_ID], [changes].[CLNT_ID], [changes].[Name], [changes].[Description], [changes].[EnforceDB], [changes].[KML]);

SET @sync_row_count = @@ROWCOUNT;

END
GO
EXEC [CORE3].sys.sp_addextendedproperty @name=N'RELEASE_DATE', @value=N'2023-07-18' 
GO
USE [master]
GO
ALTER DATABASE [CORE3] SET  READ_WRITE 
GO
