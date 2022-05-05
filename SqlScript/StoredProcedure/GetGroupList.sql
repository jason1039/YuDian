Create Procedure sp_GetGroupList(
    @iSystemUserEmail varchar(40)
)
As
BEGIN
    Select Row_Number() OVER(Partition by GroupsName.GroupID order by GroupsName.GroupID  ) AS 'Seq', GroupsName.*
    From GroupsName
        LEFT JOIN SystemUserWithGroup ON GroupsName.GroupID = SystemUserWithGroup.GroupID
        LEFT JOIN SystemUser ON SystemUserWithGroup.ID = SystemUser.ID
    WHERE SystemUser.SystemUserEmail = @iSystemUserEmail
END
GO
