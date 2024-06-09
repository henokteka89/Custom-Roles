-- Creating SQL Server login
CREATE LOGIN TestUser1 WITH PASSWORD = '2121';
CREATE LOGIN TestUser2 WITH PASSWORD = '2121';
CREATE LOGIN TestUser3 WITH PASSWORD = '2121';
CREATE LOGIN TestUser4 WITH PASSWORD = '2121';
-- Creating database users for each login
USE [YourTestDatabase];  -- Replace with your database name
CREATE USER TestUser1 FOR LOGIN TestUser1;
CREATE USER TestUser2 FOR LOGIN TestUser2;
CREATE USER TestUser3 FOR LOGIN TestUser3;
CREATE USER TestUser4 FOR LOGIN TestUser4;

-- Creating a custom role
CREATE ROLE Developer;
CREATE ROLE Temp;
CREATE ROLE Validator;

-- Granting specific permissions to the custom role
GRANT SELECT, INSERT, UPDATE, DELETE  TO Developer;  -- Deletes all classes of objects except DATABASE SCOPED CONFIGURATION, and SERVER
GRANT SELECT, INSERT, UPDATE, DELETE   TO Temp;  --Update records using synonyms, tables and views objects. Permission can be granted at the database, schema, or object level.
GRANT SELECT, INSERT     TO Validator;-- Insert records using synonyms, tables and views objects. Permission can be granted at the database, schema, or object level.

-- Granting EXECUTE permission on procedures and functions
 GRANT EXECUTE  TO Developer; --To run CLR types, external scripts, procedures, scalar and aggregate functions
 GRANT EXECUTE  TO Temp;
  GRANT REFERENCES TO Developer--The REFERENCES permission on a table is needed to create a FOREIGN KEY constraint that references that table


 -- Granting VIEW DEFINITION to allow viewing the definition of tables, views, procedures, etc.
GRANT VIEW DEFINITION   TO Developer , Temp ; ---Enables the grantee to access metadata
GRANT ALTER to Temp, Developer, Validator --ALTER permission on a schema includes the ability to create, alter, and drop objects from the schema
GRANT CREATE SCHEMA TO  Temp,  Developer, Validator
GRANT CREATE TABLE TO Temp,  Developer, Validator
GRANT VIEW DEFINITION	TO Temp,  Developer, Validator --Enables the grantee to access metadata


ALTER AUTHORIZATION ON SCHEMA::[db_ddladmin] TO Validator;
ALTER AUTHORIZATION ON SCHEMA::[db_datareader] TO [Validator];
ALTER AUTHORIZATION ON SCHEMA::[db_datawriter] TO [Validator];
 
 

-- Adding users to the custom role
EXEC sp_addrolemember 'Developer', 'TestUser1';
EXEC sp_addrolemember 'Validator', 'TestUser3';
 EXEC sp_addrolemember 'Validator', 'TestUser4';



--testing
EXECUTE AS LOGIN = 'TestUser1';

alter table report.Testuser3 (id int)
-- Revert back to your original user
REVERT;


--some source: --https://www.mssqltips.com/sqlservertip/4990/tighten-sql-server-security-with-custom-server-and-database-roles/


/*
--Check SYSADMIN users
SELECT 
   SP1.name AS ServerRoleName, 
   ISNULL(SP2.name, 'No members') AS LoginName
FROM sys.server_role_members AS SRM
RIGHT OUTER JOIN sys.server_principals AS SP1 ON SRM.role_principal_id = SP1.principal_id
LEFT OUTER JOIN sys.server_principals AS SP2 ON SRM.member_principal_id = SP2.principal_id
WHERE SP1.is_fixed_role = 1 and SP1.name = ‘sysadmin’
ORDER BY SP1.name;
GO

*/


/*
changing table that has null to not null and then make it primary key
UPDATE tableuser4 SET id=0 WHERE id IS NULL
ALTER TABLE tableuser4 ALTER COLUMN id INTEGER NOT NULL

ALTER TABLE tableuser4 ADD PRIMARY KEY (ID);
*/