CREATE PROCEDURE sp_GetEditGroup(
    @iGroupID INT
)
AS
DECLARE @_ParentGroupID INT
BEGIN
    BEGIN
        SELECT @_ParentGroupID = ParentGroupID
        FROM GroupsName
        WHERE GroupID = @iGroupID
    END
    SELECT *
    FROM GroupsName
    WHERE GroupID = @iGroupID
    SELECT *
    FROM GroupWithFeature LEFT JOIN FeaturesName ON GroupWithFeature.FeatureID = FeaturesName.FeatureID
    WHERE GroupID = @_ParentGroupID
END