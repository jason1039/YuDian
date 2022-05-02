Create Table GroupsName
(
    GroupID Int Identity(1,1) Not Null,
    GroupName Nvarchar(20) Not Null,
    Primary Key (GroupID)
)
Insert Into GroupName
    (GroupName)
Values
    ('Admin')