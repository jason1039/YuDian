CREATE PROCEDURE sp_GetUserInvite(
    @iSystemEmail VARCHAR(40)
)
AS
BEGIN
    SELECT *
    FROM UserInvite
    WHERE InviteEmail = @iSystemEmail
END
GO
