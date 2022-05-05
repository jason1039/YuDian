CREATE PROCEDURE sp_AddGroup(
    @iGroupName VARCHAR(20),
    @iFeaturesID AS XML,
    @iSystemUserEmail VARCHAR(40)
)
AS
DECLARE @_GroupID INT,
@_ID INT
BEGIN
    INSERT INTO GroupsName
        (GroupName)
    VALUES
        (@iGroupName)
    SELECT @_GroupID = GroupID
    FROM GroupsName
    WHERE GroupName = @iGroupName
    INSERT INTO GroupWithFeature
    SELECT @_GroupID, FeatureID = x.v.value('FeatureID[1]', 'INT')
    FROM @iFeaturesID.nodes('/root/row') x(v)
    SELECT @_ID = ID
    FROM SystemUser
    WHERE SystemUserEmail = @iSystemUserEmail
    INSERT INTO SystemUserWithGroup
        (ID, GroupID)
    VALUES
        (@_ID, @_GroupID)
    IF @_ID <> 1
    INSERT INTO SystemUserWithGroup
        (ID, GroupID)
    VALUES
        (1, @_GroupID)
    SELECT GroupWithFeature.GroupID, GroupsName.GroupName, FeaturesName.FeatureName
    FROM GroupWithFeature
        LEFT JOIN GroupsName ON GroupWithFeature.GroupID = GroupsName.GroupID
        LEFT JOIN FeaturesName ON GroupWithFeature.FeatureID = FeaturesName.FeatureID
    WHERE GroupWithFeature.GroupID = @_GroupID
END