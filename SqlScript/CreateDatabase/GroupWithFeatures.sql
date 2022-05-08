Create Table GroupWithFeature
(
    GroupID Int Not Null,
    FeatureID Int Not Null,
    Primary Key (GroupID, FeatureID)
)
Alter Table GroupWithFeature Add Constraint GroupWithFeature_FK1 Foreign Key (GroupID) References GroupsName(GroupID) On Delete Cascade
Alter Table GroupWithFeature Add Constraint GroupWithFeature_FK2 Foreign Key (FeatureID) References FeaturesName(FeatureID) On Delete Cascade