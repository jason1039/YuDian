Create Procedure sp_AddUserInvite(
    @iInviterEmail varchar(40),
    @iInviteEmail varchar(40),
    @iInviteName varchar(10)
)
As
Declare @_ID int
BEGIN
    Select @_ID = ID
    From SystemUser
    Where SystemUserEmail = @iInviterEmail

    Select *
    From UserInvite
    Where InviteEmail = @iInviteEmail
    IF (Select @@rowcount As UserInvite) = 1
	Update UserInvite Set InviteEndTime = DateAdd(Day,10,getdate()), InviteTime = getdate()
	Else
    Insert Into UserInvite
        (Inviter, InviteEmail, InviteName)
    Values
        (@_ID, @iInviteEmail, @iInviteName)

    Select *
    From UserInvite
    Where InviteEmail = @iInviteEmail
END
GO