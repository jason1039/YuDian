CREATE PROCEDURE sp_GetFeatures(
    @iSystemUserEmail VARCHAR(40)
)
AS
BEGIN
    SELECT FeatureName, FeaturesName.FeatureID
    FROM FeaturesName
        LEFT JOIN GroupWithFeature ON FeaturesName.FeatureID = GroupWithFeature.FeatureID
        LEFT JOIN GroupsName ON GroupWithFeature.GroupID = GroupsName.GroupID
        LEFT JOIN SystemUserWithGroup ON GroupsName.GroupID = SystemUserWithGroup.GroupID
        LEFT JOIN SystemUser ON SystemUserWithGroup.ID = SystemUser.ID
    WHERE SystemUser.SystemUserEmail = @iSystemUserEmail
    GROUP BY FeatureName, FeaturesName.FeatureID
END
GO
