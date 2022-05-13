CREATE PROCEDURE sp_EditGroup(
    @iGroupID INT,
    @iSystemUserEmail VARCHAR(40),
    @iFeatures AS XML
)
AS
DECLARE @_ParentGroupID INT
BEGIN
    CREATE TABLE #ParentGroupIDs
    (
        ParentGroupID INT NOT NULL,
        PRIMARY KEY (ParentGroupID)
    )

    INSERT INTO #ParentGroupIDs
    SELECT ParentGroupID
    FROM GroupsName
    WHERE GroupID = @iGroupID
    WHILE @@ROWCOUNT > 0
    BEGIN
        INSERT INTO #ParentGroupIDs
        SELECT ParentGroupID
        FROM GroupsName
        WHERE GroupID IN (SELECT *
            FROM #ParentGroupIDs) AND ParentGroupID NOT IN (SELECT *
            FROM #ParentGroupIDs)
    END

    IF EXISTS(SELECT 0
    FROM #ParentGroupIDs
        LEFT JOIN SystemUserWithGroup ON #ParentGroupIDs.ParentGroupID = SystemUserWithGroup.GroupID
        LEFT JOIN SystemUser ON SystemUserWithGroup.ID = SystemUser.ID
    WHERE SystemUser.SystemUserEmail = @iSystemUserEmail)
    BEGIN
        DROP TABLE #ParentGroupIDs
        BEGIN
            SELECT @_ParentGroupID = ParentGroupID
            FROM GroupsName
            WHERE GroupID = @iGroupID
        END
        -- 子群組
        CREATE TABLE #SubGroupsID
        (
            GroupID INT NOT NULL,
            PRIMARY KEY(GroupID)
        )
        INSERT INTO #SubGroupsID
            (GroupID)
        VALUES
            (@iGroupID)
        WHILE @@ROWCOUNT > 0
        BEGIN
            INSERT INTO #SubGroupsID
            SELECT GroupID
            FROM GroupsName
            WHERE GroupID NOT IN (SELECT *
                FROM #SubGroupsID) AND ParentGroupID IN (SELECT *
                FROM #SubGroupsID)
        END

        -- 要刪除的功能
        CREATE TABLE #DelFeatures
        (
            FeatureID INT NOT NULL,
            PRIMARY KEY(FeatureID)
        )
        INSERT INTO #DelFeatures
        SELECT FeatureID
        FROM GroupWithFeature
        WHERE GroupID = @iGroupID AND FeatureID NOT IN (SELECT FeatureID = x.v.value('FeatureID[1]', 'INT')
            FROM @iFeatures.nodes('/root/row') x(v))

        -- 添加功能
        INSERT INTO GroupWithFeature
        SELECT @iGroupID, FeatureID = x.v.value('FeatureID[1]', 'INT')
        FROM @iFeatures.nodes('/root/row') x(v)
        WHERE x.v.value('FeatureID[1]', 'INT') NOT IN (SELECT FeatureID
            FROM GroupWithFeature
            WHERE GroupID = @iGroupID) AND x.v.value('FeatureID[1]', 'INT') IN (SELECT FeatureID
            FROM GroupWithFeature
            WHERE GroupID = @_ParentGroupID)

        -- 刪除功能
        DELETE FROM GroupWithFeature WHERE GroupID IN (SELECT *
            FROM #SubGroupsID) AND FeatureID IN (SELECT *
            FROM #DelFeatures)
        DROP TABLE #SubGroupsID
    END
    SELECT GroupWithFeature.GroupID, GroupsName.GroupName, FeaturesName.FeatureName
    FROM GroupWithFeature LEFT JOIN GroupsName ON GroupWithFeature.GroupID = GroupsName.GroupID LEFT JOIN FeaturesName ON GroupWithFeature.FeatureID = FeaturesName.FeatureID
    WHERE GroupWithFeature.GroupID = @iGroupID



-- CREATE TABLE #sp_EditGroup_Temp
-- (
--     Seq INT,
--     GroupID INT NOT NULL,
--     GroupName NVARCHAR(20) NOT NULL,
--     ParentGroupID INT NOT NULL
-- )
-- INSERT INTO #sp_EditGroup_Temp
-- EXEC sp_GetGroupList @iSystemUserEmail

-- IF (SELECT COUNT(*)
-- FROM #sp_EditGroup_Temp
-- WHERE GroupID = @iGroupID) = 1
-- BEGIN
--     DROP TABLE #sp_EditGroup_Temp
--     CREATE TABLE #sp_EditGroup_DelFeatures
--     (
--         FeatureID INT NOT NULL
--     )
--     INSERT INTO #sp_EditGroup_DelFeatures
--     SELECT FeatureID
--     FROM GroupWithFeature
--     WHERE GroupID = @iGroupID AND FeatureID NOT IN (SELECT FeatureID = x.v.value('FeatureID[1]', 'INT')
--         FROM @iFeatures.nodes('/root/row') x(v))
--     INSERT INTO GroupWithFeature
--     SELECT @iGroupID, FeatureID = x.v.value('FeatureID[1]', 'INT')
--     FROM @iFeatures.nodes('/root/row') x(v)
--     WHERE x.v.value('FeatureID[1]', 'INT') NOT IN (SELECT FeatureID
--     FROM GroupWithFeature
--     WHERE GroupID = @iGroupID)
--     CREATE TABLE #sp_EditGroup_Temp2
--     (
--         GroupID INT NOT NULL,
--         PRIMARY KEY(GroupID)
--     )
--     INSERT INTO #sp_EditGroup_Temp2
--         (GroupID)
--     VALUES
--         (@iGroupID)
--     WHILE @@ROWCOUNT <> 0
--     BEGIN
--         INSERT INTO #sp_EditGroup_Temp2
--         SELECT GroupID
--         FROM GroupsName
--         WHERE ParentGroupID IN (SELECT *
--             FROM #sp_EditGroup_Temp2) AND GroupID NOT IN (SELECT *
--             FROM #sp_EditGroup_Temp2)
--     END
--     DELETE FROM GroupWithFeature WHERE GroupID IN (SELECT *
--         FROM #sp_EditGroup_Temp2) AND FeatureID IN (SELECT *
--         FROM #sp_EditGroup_DelFeatures)
-- END
-- SELECT GroupWithFeature.GroupID, GroupsName.GroupName, FeaturesName.FeatureName
-- FROM GroupWithFeature
--     LEFT JOIN GroupsName ON GroupWithFeature.GroupID = GroupsName.GroupID
--     LEFT JOIN FeaturesName ON GroupWithFeature.FeatureID = FeaturesName.FeatureID
-- WHERE GroupWithFeature.GroupID = @iGroupID
END