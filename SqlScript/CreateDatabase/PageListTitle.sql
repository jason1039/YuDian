Create Table PageListTitle
(
    TitleSeq Int Not Null,
    TitleName Nvarchar(20) Not Null,
    Primary Key(TitleSeq)
)
Alter Table PageListTitle Add Constraint CK_PageListTitle_TitleSeq Check (TitleSeq > 0)
Insert Into PageListTitle
    (TitleSeq, TitleName)
Values(1, '邀請')