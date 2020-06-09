----Create DB.
USE [master];
GO

----Uncomment the following code if the database is not created yet
----Create DB.
--CREATE DATABASE ReadingDBLog;
--GO

/*STEP 2: Set the recovery model*/
--ALTER DATABASE ReadingDBLog SET RECOVERY FULL;

--if no Backup operation, the FULL Recovery mode will act just like the SIMPLE!
--BACKUP DATABASE ReadingDBLog
--TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2019\MSSQL\DATA\ReadingDBLog.bak'
--WITH INIT

USE ReadingDBLog;
GO

----Drop Table
--IF OBJECT_ID('dbo.Location', 'U') IS NOT NULL 
--  DROP TABLE dbo.Location;
--GO
--Uncomment the following code if the table is not created yet

--CREATE TABLE [Location] (
--    [Sr.No] INT IDENTITY,
--    [Date] DATETIME DEFAULT GETDATE (),
--    [City] CHAR (25) DEFAULT 'Bangalore');
--GO

--INSERT INTO Location DEFAULT VALUES ;
--GO 10

--try to add Column
--ALTER TABLE Location
--ADD iso3 char(10);
--GO

--ALTER TABLE Location
--ADD iso2 char(10);
--GO

---- try to update the entries
--UPDATE Location
--SET city='Tokyo', iso2='JP', iso3='JPN'
--WHERE [Sr.No]>5;
--GO

--UPDATE Location
--SET city='Bangkok', iso2='TH', iso3='THA'
--WHERE [Sr.No]<4;
--GO

--update a particular row with typo
--UPDATE Location
--SET city='Badg'
--WHERE [Sr.No]=1;
--GO

----Sr.No will casue the error  "multi-part identifier could not be bound"
--SELECT Location.[Sr.No] FROM Location;
--change the name of column then
--EXEC sp_RENAME 'Location.[Sr.No]', 'SrNo', 'COLUMN'


----the following will generate LOP_MODIFY_ROW
--UPDATE Location
--SET city='Kyuto', iso2='JP', iso3='JPN'
--WHERE [SrNo]=10;
--GO

----the following will generate LOP_MODIFY_COLUMNS
--UPDATE Location
--SET city='New York', iso2='US', iso3='USA'
--WHERE [SrNo]=10;
--GO


----read the location table
SELECT *
FROM Location;

----check the transaction log if any insert/modify/delete(DML) has happened
--SELECT TOP(10)
-- [Current LSN],
-- [Transaction ID],
-- [Operation],
--  [Transaction Name],
-- [CONTEXT],
-- [AllocUnitName],
-- [Page ID],
-- [Slot ID],
-- [Begin Time],
-- [End Time],
-- [Number of Locks],
-- [Lock Information]
--FROM sys.fn_dblog(NULL,NULL)
--WHERE Operation IN 
--   ('LOP_INSERT_ROWS','LOP_MODIFY_ROW',
--    'LOP_DELETE_ROWS','LOP_BEGIN_XACT','LOP_COMMIT_XACT') 
--ORDER BY [Current LSN] DESC;

----check if the checkpoint system will damage the transaction log
--CHECKPOINT
--GO

