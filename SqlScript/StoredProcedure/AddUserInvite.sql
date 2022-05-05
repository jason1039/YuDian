CREATE PROCEDURE sp_AddUserInvite(
    @iInviterEmail VARCHAR(40),
    @iInviteEmail VARCHAR(40),
    @iInviteName VARCHAR(10)
)
AS
Declare @_ID int
BEGIN
    SELECT @_ID = ID
    FROM SystemUser
    WHERE SystemUserEmail = @iInviterEmail

    SELECT *
    FROM UserInvite
    WHERE InviteEmail = @iInviteEmail
    IF (SELECT @@rowcount AS UserInvite) = 1
	Update UserInvite SET InviteEndTime = DateAdd(Day,10,getdate()), InviteTime = getdate()
	Else
    INSERT INTO UserInvite
        (Inviter, InviteEmail, InviteName)
    VALUES
        (@_ID, @iInviteEmail, @iInviteName)

    SELECT *
    FROM UserInvite
    WHERE InviteEmail = @iInviteEmail
END
GO
