Create Procedure sp_GetRoles(
    @iSystemUserEmail varchar(40)
)
AS
BEGIN
    Select RoleStr
    From FeatureRoles
        Left Join FeaturesName On FeatureRoles.FeatureID = FeaturesName.FeatureID
        Left Join GroupWithFeature On FeaturesName.FeatureID = GroupWithFeature.FeatureID
        Left Join GroupName On GroupWithFeature.GroupID = GroupName.GroupID
        Left Join SystemUserWithGroup On GroupName.GroupID = SystemUserWithGroup.GroupID
        Left Join SystemUser On SystemUserWithGroup.ID = SystemUser.ID
    Where SystemUser.SystemUserEmail = @iSystemUserEmail And FeaturesName.FeatureState = 'U'
    Group By RoleStr
END
GO