Create Table UserInvite
(
    Inviter int NOT NULL,
    InviteEndTime DateTime NOT NULL Default DateAdd(Day,10,getdate()),
    InviteTime Datetime NOT NULL Default getdate(),
    InviteEmail varchar(40) NOT NULL,
    InviteName varchar(10) NOT NULL,
    Primary Key (InviteEmail, InviteTime)
)
Alter Table UserInvite Add Foreign Key (Inviter) References SystemUser(ID)