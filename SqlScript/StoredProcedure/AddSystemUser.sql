CREATE PROCEDURE sp_AddSystemUser(
    @iSystemUserID VARCHAR(10),
    @iSystemUserEmail VARCHAR(40),
    @iSystemUserSex BIT,
    @iSystemUserNumber VARCHAR(10)
)
AS
DECLARE @_SystemUserName VARCHAR(10)

BEGIN
    SELECT @_SystemUserName = InviteName
    FROM UserInvite
    WHERE InviteEmail = @iSystemUserEmail
    OPEN SYMMETRIC KEY KeyYuDian DECRYPTION BY CERTIFICATE [CertYuDian]
    INSERT INTO SystemUser
        (SystemUserID, SystemUserEmail, SystemUserName, SystemUserSex, SystemUserNumber, AccountState)
    VALUES
        (EncryptByKey(Key_GUID('KeyYuDian'),@iSystemUserID), @iSystemUserEmail, @_SystemUserName, @iSystemUserSex, EncryptByKey(Key_GUID('KeyYuDian'),@iSystemUserNumber), 'U')

    SELECT CAST(DECRYPTBYKEY(SystemUserID) AS VARCHAR) AS 'SystemUserID',
        SystemUserEmail,
        SystemUserName,
        CAST(DECRYPTBYKEY(SystemUserNumber) AS VARCHAR) AS 'SystemUserNumber',
        SystemUserSex,
        CreateTime,
        AccountState
    FROM SystemUser
    WHERE SystemUserEmail = @iSystemUserEmail
    CLOSE ALL SYMMETRIC KEYS
END
GO
