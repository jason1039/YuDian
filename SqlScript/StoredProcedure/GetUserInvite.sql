Create Procedure sp_GetUserInvite(
    @iSystemEmail varchar(40)
)
As
BEGIN
    Select *
    From UserInvite
    Where InviteEmail = @iSystemEmail
END
GO
