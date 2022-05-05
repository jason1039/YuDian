Create Procedure sp_GetPageList(
    @iSystemUserEmail VARCHAR(40)
)
As
BEGIN
    SELECT FeaturesName.FeatureName, FeaturesName.MainController, FeaturesName.MainAction, PageList.PageSeq, PageListTitle.TitleName, PageListTitle.TitleSeq
    FROM FeaturesName
        LEFT JOIN PageList ON FeaturesName.FeatureID = PageList.FeatureID
        LEFT JOIN PageListTitle ON PageList.TitleSeq = PageListTitle.TitleSeq
        LEFT JOIN GroupWithFeature ON FeaturesName.FeatureID = GroupWithFeature.FeatureID
        LEFT JOIN SystemUserWithGroup ON GroupWithFeature.GroupID = SystemUserWithGroup.GroupID
        LEFT JOIN SystemUser ON SystemUserWithGroup.ID = SystemUser.ID
    WHERE SystemUser.SystemUserEmail = @iSystemUserEmail
    GROUP BY FeaturesName.FeatureName, FeaturesName.MainController, FeaturesName.MainAction, PageList.PageSeq, PageListTitle.TitleName, PageListTitle.TitleSeq
    ORDER BY PageListTitle.TitleSeq, PageList.PageSeq
END
GO
