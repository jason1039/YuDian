CREATE PROCEDURE sp_GetGroupFeatures(
    @iSystemUserEmail VARCHAR(40),
    @iGroupID INT
)
AS
BEGIN
    CREATE TABLE #sp_GetGroupFeatures_Result
    (
        Seq INT,
        GroupID INT NOT NULL,
        GroupName NVARCHAR(20) NOT NULL,
        ParentGroupID INT NOT NULL
    )
    INSERT INTO #sp_GetGroupFeatures_Result
    EXEC sp_GetGroupList @iSystemUserEmail

    IF (SELECT COUNT(*)
    FROM #sp_GetGroupFeatures_Result
    WHERE GroupID = @iGroupID) = 1
        SELECT FeatureName, FeaturesName.FeatureID
    FROM FeaturesName
        LEFT JOIN GroupWithFeature ON FeaturesName.FeatureID = GroupWithFeature.FeatureID
        LEFT JOIN GroupsName ON GroupWithFeature.GroupID = GroupsName.GroupID
    WHERE GroupsName.GroupID = @iGroupID
    GROUP BY FeatureName, FeaturesName.FeatureID

    ELSE
        SELECT FeatureName, FeatureID
    FROM FeaturesName
    WHERE FeatureID = -1
    GROUP BY FeatureName, FeatureID

END
GO
