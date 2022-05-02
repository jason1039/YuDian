Create Table FeatureRoles
(
    FeatureID Int Not Null,
    RoleStr Varchar(20) Not Null,
    Primary Key (FeatureID, RoleStr)
)
Alter Table FeatureRoles Add Constraint FeatureRoles_FK1 Foreign Key (FeatureID) References FeaturesName(FeatureID)

Insert Into FeatureRoles
    (FeatureID, RoleStr)
Values
    (1, 'Invite.Add')
Insert Into FeatureRoles
    (FeatureID, RoleStr)
Values
    (1, 'Invite.AddPost')
Insert Into FeatureRoles
    (FeatureID, RoleStr)
Values
    (1, 'Invite.Index')
Insert Into FeatureRoles
    (FeatureID, RoleStr)
Values
    (2, 'Invite.Index')
Insert Into FeatureRoles
    (FeatureID, RoleStr)
Values
    (3, 'SetGroup.Index')
Insert Into FeatureRoles
    (FeatureID, RoleStr)
Values
    (3, 'SetGroup.Add')