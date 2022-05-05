Create Table SystemUserWithGroup
(
    ID Int Not Null,
    GroupID Int Not Null,
    Primary Key (ID,GroupID)
)
Alter Table SystemUserWithGroup Add Constraint SystemUserWithGroup_FK1 Foreign Key (ID) References SystemUser(ID) On Delete Cascade
Alter Table SystemUserWithGroup Add Constraint SystemUserWithGroup_FK2 Foreign Key (GroupID) References GroupsName(GroupID) On Delete Cascade