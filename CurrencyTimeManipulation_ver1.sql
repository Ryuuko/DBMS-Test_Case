-- access the database
USE ReadingDBLog;
GO


--the number of records
--SELECT COUNT(*) AS Total FROM Location;

--SPECIFIED for particular keylock, read the transaction log-command 
-- and its time only for it
declare @keyLock nvarchar(20)

SET @keyLock = (
SELECT  %%lockres%%
FROM Location --replaced depend on table name 
ORDER BY 1 --assume there's no hash collision and key lock is unique
OFFSET 9 ROWS --to iterate through each row
FETCH NEXT 1 ROWS ONLY);

--check the value of keyLock
--SELECT @keyLock;


--record the name of the primary key and its key
declare @primaryKey nvarchar(20)
SET @primaryKey = (
SELECT 1 --traditionally here is the name of primary key
FROM Location --replaced depend on table name 
ORDER BY 1 --assume there's no hash collision and key lock is unique
OFFSET 0 ROWS --to iterate through each row
FETCH NEXT 1 ROWS ONLY);

--Select @primaryKey


----look closer to the combination of lock key and
SELECT %%lockres%%, *
FROM Location --replaced depend on table name 
ORDER BY 1 --assume there's no hash collision and key lock is unique
OFFSET 0 ROWS


--check the time log according to keyLock, save it as subquery
DECLARE @timeLog TABLE(
LockKey CHAR(130),
Operation CHAR(20),
Time_Record datetime2
);

--form the time log according the transaction commit time
INSERT INTO @timeLog 
SELECT Subset.[Lock Information] , Subset.[Operation], Whole.[End Time]
FROM
(SELECT [Current LSN],
 [Transaction ID],
 [Operation],
  [Page ID],
 [Slot ID],
  [Transaction Name],
 [CONTEXT],
  [Lock Information],
 [AllocUnitName]
 FROM sys.fn_dblog(NULL,NULL)
 WHERE AllocUnitName='dbo.Location') AS Subset
 JOIN 
 (SELECT 
 [Transaction ID],
 [Operation],
 [Transaction Name],
 [End Time]
 FROM sys.fn_dblog(NULL,NULL)
 WHERE Operation='LOP_COMMIT_XACT') AS Whole
 ON Subset.[Transaction ID] = Whole.[Transaction ID]
 WHERE (SELECT 
     CHARINDEX(@keyLock, Subset.[Lock Information])) > 0
ORDER BY [End Time] ASC;

SELECT * FROM @timeLog -- for debugging: read how's the time record in the @timeLog subquery

--SELECT COUNT(*) AS recordAmount FROM @timeLog -- for debugging: how many records in the transaction set?

-- how many time does the row get updated?
DECLARE @N FLOAT
SET @N = (SELECT COUNT(*) FROM @timeLog)-1; --minus 1, because one of the records must be the first capture

-- what's the age of the row?

--SELECT datediff(millisecond, timeLog.Time_Record, SYSDATETIME()) FROM -- for debugging
--(SELECT TOP 1 Time_Record FROM @timeLog) AS timeLog;

-- save the difference between the recorded time and assessment time in the variable age
-- be careful: not the maximum difference for millisecond are 24 days, 20 hours
DECLARE @age FLOAT
SET @age=
(SELECT datediff(second, timeLog.Time_Record, SYSDATETIME()) FROM 
(SELECT TOP 1 Time_Record FROM @timeLog) AS timeLog); -- the earliest record should be the INSERT, i.e. the first time of capture

--The update frequency per millisecond
DECLARE @updateFreq Float
SET @updateFreq = @N/@age

--what's the age of most updated value

--SELECT TOP 1 Time_Record FROM @timeLog ORDER BY Time_Record DESC -- for debugging

-- find the transaction time of the most updated record
DECLARE @ageUpdate FLOAT
SET @ageUpdate=
(SELECT datediff(second, timeLog.Time_Record, SYSDATETIME()) FROM 
(SELECT TOP 1 Time_Record FROM @timeLog ORDER BY Time_Record DESC --make sure to use descendent order
) timeLog);

--return one single table with all the necessary information
SELECT @updateFreq AS updateFreq, @ageUpdate AS ageUpdate, @primaryKey As primaryKey;
