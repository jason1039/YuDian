Create Table FeatureRoles
(
    FeatureID Int Not Null,
    RoleStr Varchar(40) Not Null,
    Primary Key (FeatureID, RoleStr)
)
Alter Table FeatureRoles Add Constraint FeatureRoles_FK1 Foreign Key (FeatureID) References FeaturesName(FeatureID) On Delete Cascade