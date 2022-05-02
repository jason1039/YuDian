Create Procedure sp_GetPageList(
    @iSystemUserEmail Varchar(40)
)
As
BEGIN
    Select FeaturesName.FeatureName, FeaturesName.MainController, FeaturesName.MainAction, PageList.PageSeq, PageListTitle.TitleName, PageListTitle.TitleSeq
    From FeaturesName
        Left Join PageList On FeaturesName.FeatureID = PageList.FeatureID
        Left Join PageListTitle On PageList.TitleSeq = PageListTitle.TitleSeq
        Left Join GroupWithFeature On FeaturesName.FeatureID = GroupWithFeature.FeatureID
        Left Join SystemUserWithGroup On GroupWithFeature.GroupID = SystemUserWithGroup.GroupID
        Left Join SystemUser On SystemUserWithGroup.ID = SystemUser.ID
    Where SystemUser.SystemUserEmail = @iSystemUserEmail
    Group By FeaturesName.FeatureName, FeaturesName.MainController, FeaturesName.MainAction, PageList.PageSeq, PageListTitle.TitleName, PageListTitle.TitleSeq
    Order by PageListTitle.TitleSeq, PageList.PageSeq
END
GO