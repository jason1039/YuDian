Create Procedure sp_GetFeatures(
    @iSystemUserEmail varchar(40)
)
AS
BEGIN
    Select FeatureName
    From FeaturesName
        Left Join GroupWithFeature On FeaturesName.FeatureID = GroupWithFeature.FeatureID
        Left Join GroupName On GroupWithFeature.GroupID = GroupName.GroupID
        Left Join SystemUserWithGroup On GroupName.GroupID = SystemUserWithGroup.GroupID
        Left Join SystemUser On SystemUserWithGroup.ID = SystemUser.ID
    Where SystemUser.SystemUserEmail = @iSystemUserEmail
    Group By FeatureName
END
GO