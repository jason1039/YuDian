OPEN SYMMETRIC KEY KeyYuDian DECRYPTION BY CERTIFICATE [CertYuDian] 
GO
INSERT INTO SystemUser
    (SystemUserID, SystemUserEmail, SystemUserName, SystemUserSex, SystemUserNumber, AccountState)
VALUES
    (EncryptByKey(Key_GUID('KeyYuDian'),'A126814943'), 'jason10391039@gmail.com', '曾韋傑', 1, EncryptByKey(Key_GUID('KeyYuDian'),'0928887941'), 'U')
CLOSE ALL SYMMETRIC KEYS 
GO
