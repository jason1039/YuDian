CREATE PROCEDURE sp_GetRoles(
    @iSystemUserEmail VARCHAR(40)
)
AS
BEGIN
    SELECT RoleStr
    FROM FeatureRoles
        LEFT JOIN FeaturesName ON FeatureRoles.FeatureID = FeaturesName.FeatureID
        LEFT JOIN GroupWithFeature ON FeaturesName.FeatureID = GroupWithFeature.FeatureID
        LEFT JOIN GroupsName ON GroupWithFeature.GroupID = GroupsName.GroupID
        LEFT JOIN SystemUserWithGroup ON GroupsName.GroupID = SystemUserWithGroup.GroupID
        LEFT JOIN SystemUser ON SystemUserWithGroup.ID = SystemUser.ID
    Where SystemUser.SystemUserEmail = @iSystemUserEmail AND FeaturesName.FeatureState = 'U'
    GROUP BY RoleStr
END
GO
