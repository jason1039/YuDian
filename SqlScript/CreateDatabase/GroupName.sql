Create Table GroupsName
(
    GroupID Int Identity(1,1) Not Null,
    GroupName Nvarchar(20) Not Null,
    ParentGroupID INT,
    PRIMARY KEY (GroupID)
)
Insert Into GroupsName
    (GroupName, ParentGroupID)
Values
    ('Admin', 1)
ALTER TABLE GroupsName ALTER COLUMN ParentGroupID INT NOT NULL
ALTER TABLE GroupsName ADD CONSTRAINT GroupsName_FK1 FOREIGN KEY (ParentGroupID) REFERENCES GroupsName(GroupID)