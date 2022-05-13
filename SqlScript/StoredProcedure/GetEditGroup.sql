CREATE PROCEDURE sp_GetEditGroup(
    @iSystemUserEmail VARCHAR(40),
    @iGroupID INT,
    @iGroupName NVARCHAR(20) OUTPUT,
    @iParentName NVARCHAR(20) OUTPUT
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
        SELECT @_ParentGroupID = ParentGroupID, @iGroupName = GroupName
        FROM GroupsName
        WHERE GroupID = @iGroupID
        SELECT @iParentName = GroupName
        FROM GroupsName
        WHERE GroupID = @_ParentGroupID
    END
    ELSE
    BEGIN
        SET @_ParentGroupID = -1
        SET @iGroupName = ''
        SET @iParentName = ''
    END
    CREATE TABLE #sp_GetEditGroup_Temp
    (
        FeatureID INT NOT NULL,
        PRIMARY KEY (FeatureID)
    )
    BEGIN
        INSERT INTO #sp_GetEditGroup_Temp
        SELECT FeaturesName.FeatureID
        FROM FeaturesName LEFT JOIN GroupWithFeature ON FeaturesName.FeatureID = GroupWithFeature.FeatureID
        WHERE GroupWithFeature.GroupID = @iGroupID
    END

    SELECT FeaturesNameP.FeatureID, FeaturesNameP.FeatureName, CASE WHEN FeaturesNameS.FeatureID IS NULL THEN CONVERT(BIT, 0) ELSE CONVERT(BIT, 1) END AS 'Choosed'
    FROM GroupWithFeature GroupWithFeatureP
        LEFT JOIN FeaturesName FeaturesNameP ON GroupWithFeatureP.FeatureID = FeaturesNameP.FeatureID
        LEFT JOIN #sp_GetEditGroup_Temp FeaturesNameS ON FeaturesNameS.FeatureID = FeaturesNameP.FeatureID
    WHERE GroupWithFeatureP.GroupID = @_ParentGroupID

    DROP TABLE #ParentGroupIDs
    DROP TABLE #sp_GetEditGroup_Temp
END