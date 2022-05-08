CREATE PROCEDURE sp_EditGroup(
    @iGroupID INT,
    @iSystemUserEmail VARCHAR(40),
    @iGroupName NVARCHAR(20),
    @iFeatures AS XML
)
AS
BEGIN
    CREATE TABLE #sp_EditGroup_Temp
    (
        Seq INT,
        GroupID INT NOT NULL,
        GroupName NVARCHAR(20) NOT NULL,
        ParentGroupID INT NOT NULL
    )
    INSERT INTO #sp_EditGroup_Temp
    EXEC sp_GetGroupList @iSystemUserEmail

    IF (SELECT COUNT(*)
    FROM #sp_EditGroup_Temp
    WHERE GroupID = @iGroupID) = 1
    BEGIN
        DROP TABLE #sp_EditGroup_Temp
        CREATE TABLE #sp_EditGroup_DelFeatures
        (
            FeatureID INT NOT NULL
        )
        INSERT INTO #sp_EditGroup_DelFeatures
        SELECT FeatureID
        FROM GroupWithFeature
        WHERE GroupID = @iGroupID AND FeatureID NOT IN (SELECT FeatureID = x.v.value('FeatureID[1]', 'INT')
            FROM @iFeatures.nodes('/root/row') x(v))
        INSERT INTO GroupWithFeature
        SELECT @iGroupID, FeatureID = x.v.value('FeatureID[1]', 'INT')
        FROM @iFeatures.nodes('/root/row') x(v)
        WHERE x.v.value('FeatureID[1]', 'INT') NOT IN (SELECT FeatureID
        FROM GroupWithFeature
        WHERE GroupID = @iGroupID)
        CREATE TABLE #sp_EditGroup_Temp2
        (
            GroupID INT NOT NULL,
            PRIMARY KEY(GroupID)
        )
        INSERT INTO #sp_EditGroup_Temp2
            (GroupID)
        VALUES
            (@iGroupID)
        WHILE @@ROWCOUNT <> 0
        BEGIN
            INSERT INTO #sp_EditGroup_Temp2
            SELECT GroupID
            FROM GroupsName
            WHERE ParentGroupID IN (SELECT *
                FROM #sp_EditGroup_Temp2) AND GroupID NOT IN (SELECT *
                FROM #sp_EditGroup_Temp2)
        END
        DELETE FROM GroupWithFeature WHERE GroupID IN (SELECT *
            FROM #sp_EditGroup_Temp2) AND FeatureID IN (SELECT *
            FROM #sp_EditGroup_DelFeatures)
    END
    SELECT GroupWithFeature.GroupID, GroupsName.GroupName, FeaturesName.FeatureName
    FROM GroupWithFeature
        LEFT JOIN GroupsName ON GroupWithFeature.GroupID = GroupsName.GroupID
        LEFT JOIN FeaturesName ON GroupWithFeature.FeatureID = FeaturesName.FeatureID
    WHERE GroupWithFeature.GroupID = @iGroupID
END