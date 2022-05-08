Create Table FeaturesName
(
    FeatureID Int Identity(1,1) Not Null,
    FeatureName Nvarchar(20) Not Null,
    FeatureState Char(1) Not Null Default 'U',
    MainController Varchar(20) Not Null,
    MainAction Varchar(20) Not Null,
    Primary Key (FeatureID)
)
Alter Table FeaturesName Add Constraint CK_FeaturesName_FeatureState Check (FeatureState In ('U','S'))