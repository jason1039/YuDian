Create Procedure sp_GetSystemUser(
    @iSystemUserEmail Varchar(40)
)
As
BEGIN
    OPEN SYMMETRIC KEY KeyYuDian DECRYPTION BY CERTIFICATE [CertYuDian]
    Select CAST(DECRYPTBYKEY(SystemUserID) AS varchar) As 'SystemUserID',
        SystemUserEmail,
        SystemUserName,
        CAST(DECRYPTBYKEY(SystemUserNumber) AS varchar) As 'SystemUserNumber',
        SystemUserSex,
        CreateTime,
        AccountState
    From SystemUser
    Where SystemUserEmail = @iSystemUserEmail
    CLOSE ALL SYMMETRIC KEYS
END
GO