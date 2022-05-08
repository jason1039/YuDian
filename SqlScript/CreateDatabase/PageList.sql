Create Table PageList
(
    TitleSeq Int Not Null,
    PageSeq Int Not Null,
    FeatureID Int Not Null,
    Primary Key (TitleSeq, PageSeq)
)
Alter Table PageList Add Constraint CK_PageList_PageSeq Check (PageSeq > 0)
Alter Table PageList Add Constraint PageList_FK1 Foreign Key (TitleSeq) References PageListTitle(TitleSeq) On Delete Cascade On Update Cascade
Alter Table PageList Add Constraint PageList_FK2 Foreign Key (FeatureID) References FeaturesName(FeatureID) On Delete Cascade