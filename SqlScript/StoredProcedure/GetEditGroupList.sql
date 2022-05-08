CREATE PROCEDURE sp_GetEditGroupList(
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
    BEGIN
        INSERT INTO #Result
        SELECT GroupsName.*
        FROM GroupsName
        WHERE ParentGroupID IN (SELECT GroupID
            FROM #Result) AND GroupID NOT IN (SELECT GroupID
            FROM #Result)
    END

    DELETE FROM #Result WHERE GroupID IN(SELECT GroupsName.GroupID
    FROM GroupsName
        LEFT JOIN SystemUserWithGroup ON GroupsName.GroupID = SystemUserWithGroup.GroupID
        LEFT JOIN SystemUser ON SystemUserWithGroup.ID = SystemUser.ID
    WHERE SystemUser.SystemUserEmail = @iSystemUserEmail)

    SELECT Row_Number() OVER(ORDER BY GroupID  ) AS 'Seq', *
    FROM #Result
END
GO
