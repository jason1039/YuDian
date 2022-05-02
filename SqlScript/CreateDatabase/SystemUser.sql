Use YuDian
Create table SystemUser
(
    ID int Identity(1,1) NOT NULL,
    SystemUserID varbinary(max) NOT NULL,
    SystemUserEmail varchar(40) NOT NULL,
    SystemUserName nvarchar(10) NOT NULL,
    SystemUserSex bit NOT NULL,
    SystemUserNumber varbinary(max) NOT NULL,
    CreateTime Datetime NOT NULL Default getdate(),
    AccountState char(1) NOT NULL,
    primary key(ID)
)
alter table SystemUser add constraint CK_SystemUser_SystemUserSex CHECK (SystemUserSex IN (0,1))
Alter Table SystemUser Add Constraint CK_SystemUser_AccountState Check (AccountState IN ('U', 'S', 'D'))
OPEN SYMMETRIC KEY KeyYuDian DECRYPTION BY CERTIFICATE [CertYuDian] 
GO
Insert Into SystemUser
    (SystemUserID, SystemUserEmail, SystemUserName, SystemUserSex, SystemUserNumber, AccountState)
Values
    (EncryptByKey(Key_GUID('KeyYuDian'),'A126814943'), 'jason10391039@gmail.com', '曾韋傑', 1, EncryptByKey(Key_GUID('KeyYuDian'),'0928887941'), 'U')
CLOSE ALL SYMMETRIC KEYS 
    GO
    