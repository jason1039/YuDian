CREATE PROCEDURE sp_GetGroupList
AS
BEGIN
    SELECT Row_Number() OVER(PARTITION BY GroupsName.GroupID ORDER BY GroupsName.GroupID  ) AS 'Seq', *
    FROM GroupsName
END
GO
