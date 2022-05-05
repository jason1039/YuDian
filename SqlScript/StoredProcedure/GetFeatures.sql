CREATE PROCEDURE sp_GetFeatures(
    @iSystemUserEmail VARCHAR(40)
)
AS
BEGIN
    Select FeatureName, FeaturesName.FeatureID
    From FeaturesName
        Left Join GroupWithFeature On FeaturesName.FeatureID = GroupWithFeature.FeatureID
        Left Join GroupsName On GroupWithFeature.GroupID = GroupsName.GroupID
        Left Join SystemUserWithGroup On GroupsName.GroupID = SystemUserWithGroup.GroupID
        Left Join SystemUser On SystemUserWithGroup.ID = SystemUser.ID
    Where SystemUser.SystemUserEmail = @iSystemUserEmail
    Group By FeatureName, FeaturesName.FeatureID
END
GO
