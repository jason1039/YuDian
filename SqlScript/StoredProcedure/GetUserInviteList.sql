Create Procedure sp_GetUserInviteList
As
BEGIN
    Select Row_Number() OVER(Partition by UserInvite.InviteName order by UserInvite.InviteName ) AS 'Seq',
        UserInvite.InviteName,
        UserInvite.InviteEmail,
        IsNull(SystemUser.SystemUserEmail,0) As 'Completed'
    From UserInvite
        Left Join SystemUser On SystemUser.SystemUserEmail = UserInvite.InviteEmail
END
GO