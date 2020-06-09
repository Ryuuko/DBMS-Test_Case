USE [master];
GO

----Uncomment the following code if database is not created yet
----Create DB.
--CREATE DATABASE ReadingDBLog;
--GO

-- Create tables
USE ReadingDBLog;
GO

/*Set the recovery model*/
--ALTER DATABASE ReadingDBLog SET RECOVERY FULL;

----if no Backup operation, the FULL Recovery mode will act just like the SIMPLE!
--BACKUP DATABASE ReadingDBLog
--TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2019\MSSQL\DATA\ReadingDBLog.bak'
--WITH INIT

--IF OBJECT_ID('dbo.ingredients', 'U') IS NOT NULL 
--  DROP TABLE dbo.ingredients;
--GO

--CREATE TABLE ingredients (
--  ingredient_id INT NOT NULL, 
--  ingredient_name VARCHAR(30) NOT NULL,
--  ingredient_price INT NOT NULL,
--  PRIMARY KEY (ingredient_id),  
--  UNIQUE (ingredient_name)
--);

--INSERT INTO ingredients
--    (ingredient_id, ingredient_name, ingredient_price)
--VALUES 
--	(1, 'Beef', 5),
--    (2, 'Lettuce', 1),
--    (3, 'Tomatoes', 2),
--    (4, 'Taco Shell', 2),
--    (5, 'Cheese', 3),
--    (6, 'Milk', 1),
--    (7, 'Bread', 2

--);

Select * FROM ingredients;

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

--CHECKPOINT 
--GO