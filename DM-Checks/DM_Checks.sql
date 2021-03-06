PRINT '---- Orphaned Users ----'
GO
sp_change_users_login @Action='Report';

DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10);
SET NOCOUNT ON; 

PRINT @NewLineChar
PRINT '---- Users with the same name ----'
SELECT username, COUNT(*) Count FROM tblUsers GROUP BY username HAVING COUNT(username) > 1


PRINT @NewLineChar
PRINT '---- Doctypes with the same name ----'
SELECT docTypeName, COUNT(*) Count FROM tblDocTypes GROUP BY docTypeName HAVING COUNT(docTypeName) > 1

PRINT @NewLineChar
PRINT '---- Does constID 1038 exist? (Upgrading from 6.9 to new) ----'
SELECT constID, constValue FROM tblGlobalSettings WHERE constID = 1038 

PRINT @NewLineChar
PRINT '---- LDAP users with the same name ----'
SELECT ldapGroupName, COUNT(*) Count FROM tblLdapMappings GROUP BY ldapGroupName HAVING COUNT(ldapGroupName) > 1

PRINT @NewLineChar
PRINT '---- Archive directory locations ----'
GO
SELECT fileRootID, path FROM tblArchiveDirectories