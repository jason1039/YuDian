---使用者				(SystemUser)
使用者ID				(SystemUserID)				(INT IDENTITY(0,1) NOT NULL)	//0 is super user
使用者帳號				(UserAccount)				(VARCHAR(255) NOT NULL)
使用者密碼				(UserPassword)				(VARCHAR(400) NOT NULL)
使用者性別				(UserSex)					(BIT NOT NULL)	//1 is man, 0 is woman
使用者姓名				(UserName)					(VARCHAR(8) NOT NULL)
使用者身份證字號		(UserIdemtity)				(CHAR(10) NOT NULL)
使用者連絡電話			(UserPhoneNumber)			(CHAR(10) NOT NULL)
使用者創建時間			(CreateTime)				(DATETIME NOT NULL DEFAULT GETDATE())
使用者帳號啟用狀態		(AccountState)				(BIT NOT NULL DEFAULT '1')	//1 is On useing
創建者					(Creator)					(INT NOT NULL FOREIGN KEY Creator REFERENCES SystemUser(SystemUserID))

---登入資訊				(LoginInfomation)
登入ID					(LoginID)					(INT IDENTITY(1,1) NOT NULL)
使用者ID				(SystemUserID)				(INT NOT NULL FOREIGN KEY SystemUserID REFERENCES SystemUser(SystemUserID))
登入IP					(LoginIP)					(VARCHAR(15) NOT NULL)
登入時間				(LoginTime)					(DATETIME NOT NULL DEFAULT GETDATE())

---使用者群組			(UserGroup)
使用者群組ID			(UserGroupID)				(INT IDENTITY(1,1) NOT NULL)
使用者群組名稱			(UserGroupName)				(VARCHAR(30) NOT NULL)
創建時間				(CreateTIme)				(DATETIME NOT NULL DEFAULT GETDATE())
創建者					(Creator)					(INT NOT NULL FOREIGN KEY Creator REFERENCES SystemUser(SystemUserID))

---使用者群組權限		(UserGroupJurisdiction)
使用者群組權限ID		(UserGroupJurisdictionID)	(INT IDENTITY(1,1) NOT NULL)
使用者群組ID			(UserGroupID)				(INT NOT NULL FOREIGN KEY UserGroupID REFERENCES UserGroup(UserGroupID))
頁面路徑				(UrlAddress)				(VARCHAR(50) NOT NULL)
新增權限				(AddState)					(BIT NOT NULL DEFAULT 1)	//1 is true
編輯權限				(EditState)					(BIT NOT NULL DEFAULT 1)	//1 is true
刪除權限				(DeleteState)				(BIT NOT NULL DEFAULT 1)	//1 is true
查詢權限				(QueryState)				(BIT NOT NULL DEFAULT 1)	//1 is true
最後修改時間			(LastUpdateTime)			(DATETIME NOT NULL DEFAULT GETDATE())
最後修改者				(LastUpdater)				(INT NOT NULL FOREIGN KEY LastUpdater REFERENCES SystemUser(SystemUserID))

---使用者群組清單		(UserGroupList)
使用者群組權限清單ID	(UserGroupListID)			(INT IDENTITY(1,1) NOT NULL)
使用者群組ID			(UserGroupID)				(INT NOT NULL FOREIGN KEY UserGroupID REFERENCES UserGroup(UserGroupID))
使用者群組權限ID		(UserGroupJurisdictionID)	(INT NOT NULL FOREIGN KEY UserGroupJurisdictionID REFERENCES UserGroupJurisdiction(UserGroupJurisdictionID))
最後編輯時間			(LastUpdateTime)			(DATETIME NOT NULL DEFAULT GETDATE())
最後修改者				(LastUpdater)				(INT NOT NULL FOREIGN KEY LastUpdater REFERENCES SystemUser(SystemUserID))

---帳號創建邀請			(UserInvite)				
創建邀請ID				(UserInviteID)				(INT IDENTITY(1,1) NOT NULL)
邀請哈希值				(InviteHash)				(VARCHAR(300) NOT NULL)
邀請者ID				(Inviter)					(INT NOT NULL FOREIGN KEY Inviter REFERENCES SystemUser(SystemUserID))
邀請時限				(InviteEndTime)				(DATETIME NOT NULL)
邀請時間				(InviteTime)				(DATETIME NOT NULL DEFAULT GETDATE())
被邀請者姓名			(Invitee)					(VARCHAR(8) NOT NULL)
被邀請者Email			(InviteeEmail)				(VARCHAR(40) NOT NULL)