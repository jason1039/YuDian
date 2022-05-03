CREATE DATABASE YuDian
GO
Use YuDian
GO
-- Create Key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '@@YuDianPwd$$';
GO
CREATE CERTIFICATE CertYuDian
  AUTHORIZATION dbo
  WITH SUBJECT = 'CertYuDian'
GO
CREATE SYMMETRIC KEY KeyYuDian
  AUTHORIZATION dbo
  WITH ALGORITHM = AES_256           -- 加密演算法
  ENCRYPTION BY CERTIFICATE CertYuDian   -- 利用 CertDemo Certificate 來加密 KeyDemo Key
GO

CREATE TABLE SystemUser
(
    ID INT IDENTITY(1,1) NOT NULL,
    SystemUserID VARBINARY(max) NOT NULL,
    SystemUserEmail VARCHAR(40) NOT NULL,
    SystemUserName NVARCHAR(10) NOT NULL,
    SystemUserSex BIT NOT NULL,
    SystemUserNumber VARBINARY(max) NOT NULL,
    CreateTime DATETIME NOT NULL DEFAULT GETDATE(),
    AccountState CHAR(1) NOT NULL,
    PRIMARY KEY(ID)
)
ALTER TABLE SystemUser ADD CONSTRAINT CK_SystemUser_SystemUserSex CHECK (SystemUserSex IN (0,1))
Alter TABLE SystemUser ADD CONSTRAINT CK_SystemUser_AccountState CHECK (AccountState IN ('U', 'S', 'D'))
GO

CREATE TABLE UserInvite
(
    Inviter INT NOT NULL,
    InviteEndTime DATETIME NOT NULL DEFAULT DATEADD(DAY,10,GETDATE()),
    InviteTime DATETIME NOT NULL DEFAULT GETDATE(),
    InviteEmail VARCHAR(40) NOT NULL,
    InviteName VARCHAR(10) NOT NULL,
    PRIMARY KEY (InviteEmail, InviteTime)
)
ALTER TABLE UserInvite ADD FOREIGN KEY (Inviter) REFERENCES SystemUser(ID)
GO

CREATE TABLE GroupsName
(
    GroupID INT IDENTITY(1,1) NOT NULL,
    GroupName VARCHAR(20) NOT NULL,
    PRIMARY KEY (GroupID)
)
GO

CREATE TABLE FeaturesName
(
    FeatureID INT IDENTITY(1,1) NOT NULL,
    FeatureName NVARCHAR(20) NOT NULL,
    FeatureState CHAR(1) NOT NULL DEFAULT 'U',
    MainController VARCHAR(20) NOT NULL,
    MainAction VARCHAR(20) NOT NULL,
    PRIMARY KEY (FeatureID)
)
ALTER TABLE FeaturesName ADD CONSTRAINT CK_FeaturesName_FeatureState CHECK (FeatureState IN ('U','S'))
GO

CREATE TABLE FeatureRoles
(
    FeatureID INT NOT NULL,
    RoleStr VARCHAR(20) NOT NULL,
    PRIMARY KEY (FeatureID, RoleStr)
)
ALTER TABLE FeatureRoles ADD CONSTRAINT FeatureRoles_FK1 FOREIGN KEY (FeatureID) REFERENCES FeaturesName(FeatureID)
GO

CREATE TABLE GroupWithFeature
(
    GroupID INT NOT NULL,
    FeatureID INT NOT NULL,
    PRIMARY KEY (GroupID, FeatureID)
)
ALTER TABLE GroupWithFeature ADD CONSTRAINT GroupWithFeature_FK1 FOREIGN KEY (GroupID) REFERENCES GroupsName(GroupID) ON DELETE CASCADE
ALTER TABLE GroupWithFeature ADD CONSTRAINT GroupWithFeature_FK2 FOREIGN KEY (FeatureID) REFERENCES FeaturesName(FeatureID) ON DELETE CASCADE
GO

CREATE TABLE SystemUserWithGroup
(
    ID INT NOT NULL,
    GroupID INT NOT NULL,
    PRIMARY KEY (ID,GroupID)
)
ALTER TABLE SystemUserWithGroup ADD CONSTRAINT SystemUserWithGroup_FK1 FOREIGN KEY (ID) REFERENCES SystemUser(ID)
ALTER TABLE SystemUserWithGroup ADD CONSTRAINT SystemUserWithGroup_FK2 FOREIGN KEY (GroupID) REFERENCES GroupsName(GroupID)
GO

CREATE TABLE PageListTitle
(
    TitleSeq INT NOT NULL,
    TitleName NVARCHAR(20) NOT NULL,
    PRIMARY KEY(TitleSeq)
)
ALTER TABLE PageListTitle ADD CONSTRAINT CK_PageListTitle_TitleSeq CHECK (TitleSeq > 0)
GO

CREATE TABLE PageList
(
    TitleSeq INT NOT NULL,
    PageSeq INT NOT NULL,
    FeatureID INT NOT NULL,
    PRIMARY KEY (TitleSeq, PageSeq)
)
ALTER TABLE PageList ADD CONSTRAINT CK_PageList_PageSeq CHECK (PageSeq > 0)
ALTER TABLE PageList ADD CONSTRAINT PageList_FK1 FOREIGN KEY (TitleSeq) REFERENCES PageListTitle(TitleSeq) ON DELETE CASCADE ON UPDATE CASCADE
ALTER TABLE PageList ADD CONSTRAINT PageList_FK2 FOREIGN KEY (FeatureID) REFERENCES FeaturesName(FeatureID) ON DELETE CASCADE
GO



INSERT INTO GroupsName
    (GroupName)
VALUES
    ('Admin')
GO

INSERT INTO FeaturesName
    (FeatureName, MainController, MainAction)
VALUES
    ('邀請人員', 'Invite', 'Add')
INSERT INTO FeaturesName
    (FeatureName, MainController, MainAction)
VALUES
    ('檢視邀請狀態', 'Invite', 'Index')
INSERT INTO FeaturesName
    (FeatureName, MainController, MainAction)
VALUES
    ('檢視群組列表', 'SetGroup', 'Index')
INSERT INTO FeaturesName
    (FeatureName, MainController, MainAction)
VALUES
    ('新增群組', 'SetGroup', 'Add')
GO

INSERT INTO FeatureRoles
    (FeatureID, RoleStr)
VALUES
    (1, 'Invite.Add')
INSERT INTO FeatureRoles
    (FeatureID, RoleStr)
VALUES
    (1, 'Invite.AddPost')
INSERT INTO FeatureRoles
    (FeatureID, RoleStr)
VALUES
    (1, 'Invite.Index')
INSERT INTO FeatureRoles
    (FeatureID, RoleStr)
VALUES
    (2, 'Invite.Index')
INSERT INTO FeatureRoles
    (FeatureID, RoleStr)
VALUES
    (3, 'SetGroup.Index')
INSERT INTO FeatureRoles
    (FeatureID, RoleStr)
VALUES
    (4, 'SetGroup.Add')
GO

INSERT INTO PageListTitle
    (TitleSeq, TitleName)
VALUES(1, '邀請')
INSERT INTO PageListTitle
    (TitleSeq, TitleName)
VALUES(2, '群組')
GO

INSERT INTO PageList
    (TitleSeq, PageSeq, FeatureID)
VALUES
    (1, 1, 1)
INSERT INTO PageList
    (TitleSeq, PageSeq, FeatureID)
VALUES
    (1, 2, 2)
INSERT INTO PageList
    (TitleSeq, PageSeq, FeatureID)
VALUES
    (2, 1, 3)
INSERT INTO PageList
    (TitleSeq, PageSeq, FeatureID)
VALUES
    (2, 2, 4)
GO

OPEN SYMMETRIC KEY KeyYuDian DECRYPTION BY CERTIFICATE [CertYuDian] 
GO
INSERT INTO SystemUser
    (SystemUserID, SystemUserEmail, SystemUserName, SystemUserSex, SystemUserNumber, AccountState)
VALUES
    (EncryptByKey(Key_GUID('KeyYuDian'),'A126814943'), 'jason10391039@gmail.com', '曾韋傑', 1, EncryptByKey(Key_GUID('KeyYuDian'),'0928887941'), 'U')
CLOSE ALL SYMMETRIC KEYS 
GO

INSERT INTO GroupWithFeature
    (GroupID, FeatureID)
VALUES
    (1, 1)
INSERT INTO GroupWithFeature
    (GroupID, FeatureID)
VALUES
    (1, 2)
INSERT INTO GroupWithFeature
    (GroupID, FeatureID)
VALUES
    (1, 3)
INSERT INTO GroupWithFeature
    (GroupID, FeatureID)
VALUES
    (1, 4)
GO