Create Procedure sp_AddSystemUser(
    @iSystemUserID varchar(10),
    @iSystemUserEmail varchar(40),
    @iSystemUserSex bit,
    @iSystemUserNumber varchar(10)
)
As
DECLARE @_SystemUserName varchar(10)

BEGIN
    Select @_SystemUserName = InviteName
    From UserInvite
    Where InviteEmail = @iSystemUserEmail
    OPEN SYMMETRIC KEY KeyYuDian DECRYPTION BY CERTIFICATE [CertYuDian]
    Insert Into SystemUser
        (SystemUserID, SystemUserEmail, SystemUserName, SystemUserSex, SystemUserNumber, AccountState)
    Values
        (EncryptByKey(Key_GUID('KeyYuDian'),@iSystemUserID), @iSystemUserEmail, @_SystemUserName, @iSystemUserSex, EncryptByKey(Key_GUID('KeyYuDian'),@iSystemUserNumber), 'U')

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