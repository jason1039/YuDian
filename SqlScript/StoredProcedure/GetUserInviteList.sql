CREATE PROCEDURE sp_GetUserInviteList
AS
BEGIN
    SELECT Row_Number() OVER(PARTITION BY UserInvite.InviteName ORDER BY UserInvite.InviteName ) AS 'Seq',
        UserInvite.InviteName,
        UserInvite.InviteEmail,
        IsNull(SystemUser.SystemUserEmail,0) AS 'Completed'
    FROM UserInvite
        LEFT JOIN SystemUser ON SystemUser.SystemUserEmail = UserInvite.InviteEmail
END
GO
