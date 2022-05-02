Create Procedure sp_GetGroupList
As
BEGIN
    Select Row_Number() OVER(Partition by GroupsName.GroupID order by GroupsName.GroupID  ) AS 'Seq', *
    From GroupsName
END
GO