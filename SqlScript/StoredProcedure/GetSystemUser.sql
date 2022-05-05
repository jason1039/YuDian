CREATE PROCEDURE sp_GetSystemUser(
    @iSystemUserEmail VARCHAR(40)
)
AS
BEGIN
    OPEN SYMMETRIC KEY KeyYuDian DECRYPTION BY CERTIFICATE [CertYuDian]
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
