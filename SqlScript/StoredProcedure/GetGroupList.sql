CREATE PROCEDURE sp_GetGroupList(
    @iSystemUserEmail VARCHAR(40)
)
AS
BEGIN
    CREATE TABLE #Result
    (
        GroupID INT NOT NULL,
        GroupName NVARCHAR(20) NOT NULL,
        ParentGroupID INT NOT NULL
    )

    INSERT INTO #Result
    SELECT GroupsName.*
    FROM GroupsName
        LEFT JOIN SystemUserWithGroup ON GroupsName.GroupID = SystemUserWithGroup.GroupID
        LEFT JOIN SystemUser ON SystemUserWithGroup.ID = SystemUser.ID
    WHERE SystemUser.SystemUserEmail = @iSystemUserEmail

    WHILE @@ROWCOUNT <> 0
    INSERT INTO #Result
    SELECT GroupsName.*
    FROM GroupsName
    WHERE ParentGroupID IN (SELECT GroupID
        FROM #Result) AND GroupID NOT IN (SELECT GroupID
        FROM #Result)

    SELECT Row_Number() OVER(Partition by GroupID order by GroupID  ) AS 'Seq', *
    FROM #Result
END
GO
