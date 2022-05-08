using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;
using System.ComponentModel.DataAnnotations;
//https://ithelp.ithome.com.tw/articles/10186656
namespace YuDian.Models;

public partial class MainContext : DbContext
{
    public List<UserInvite> sp_AddUserInvite(string Inviter, string InviteEmail, string InviteName)
    {
        try
        {
            SqlParameter _InviterEmail = new("@iInviterEmail", Inviter);
            SqlParameter _InviteEmail = new("@iInviteEmail", InviteEmail);
            SqlParameter _InviteName = new("@iInviteName", InviteName);
            List<UserInvite> res = this.UserInvite.FromSqlRaw("Exec sp_AddUserInvite @iInviterEmail, @iInviteEmail, @iInviteName", _InviterEmail, _InviteEmail, _InviteName).ToList();
            return res;
        }
        catch (Exception e)
        {
            throw e;
        }
    }
    public List<InviteState> sp_GetUserInviteList()
    {
        try
        {
            List<InviteState> res = this._InviteState.FromSqlRaw("Exec sp_GetUserInviteList").ToList();
            return res;
        }
        catch (Exception e)
        {
            throw e;
        }
    }
    public List<Roles> sp_GetRoles(string iSystemUserEmail)
    {
        try
        {
            SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
            List<Roles> res = this._Roles.FromSqlRaw("Exec sp_GetRoles @iSystemUserEmail", _SystemUserEmail).ToList();
            return res;
        }
        catch (Exception e)
        {
            throw e;
        }
    }
    public List<Features> sp_GetFeatures(string iSystemUserEmail)
    {
        try
        {
            SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
            List<Features> res = this._Features.FromSqlRaw("Exec sp_GetFeatures @iSystemUserEmail", _SystemUserEmail).ToList();
            return res;
        }
        catch (Exception e)
        {
            throw e;
        }
    }
    public List<PageListTitle> sp_GetPageList(string iSystemUserEmail)
    {
        SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
        List<PageList> res = this._PageList.FromSqlRaw("Exec sp_GetPageList @iSystemUserEmail", _SystemUserEmail).ToList();
        List<PageListTitle> Result = new();
        foreach (PageList li in res)
        {
            if (!Result.Any(e => e.TitleSeq == li.TitleSeq))
            {
                PageListTitle title = new();
                title.TitleSeq = li.TitleSeq;
                title.TitleName = li.TitleName;
                title.PageListSubs = new();
                List<PageList> temp = res.FindAll(t => t.TitleSeq == li.TitleSeq);
                foreach (PageList t in temp)
                {
                    PageListSub s = new();
                    s.PageSeq = t.PageSeq;
                    s.FeatureName = t.FeatureName;
                    s.MainController = t.MainController;
                    s.MainAction = t.MainAction;
                    title.PageListSubs.Add(s);
                }
                Result.Add(title);
            }
        }
        return Result;
    }
    public SystemUser sp_GetSystemUser(string iSystemUserEmail)
    {
        SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
        SystemUser user = this.SystemUser.FromSqlRaw("Exec sp_GetSystemUser @iSystemUserEmail", _SystemUserEmail).ToList().First();
        return user;
    }
    public bool sp_HasSystemUser(string iSystemUserEmail)
    {
        SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
        return this.SystemUser.FromSqlRaw("Exec sp_GetSystemUser @iSystemUserEmail", _SystemUserEmail).ToList().Count() == 1;
    }
    public SystemUser sp_AddSystemUser(string iSystemUserID, string iSystemUserEmail, bool iSystemUserSex, string iSystemUserNumber)
    {
        SqlParameter _SystemUserID = new("@iSystemUserID", iSystemUserID);
        SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
        SqlParameter _SystemUserSex = new("@iSystemUserSex", iSystemUserSex);
        SqlParameter _SystemUserNumber = new("@iSystemUserNumber", iSystemUserNumber);
        SystemUser user = this.SystemUser.FromSqlRaw("Exec sp_AddSystemUser @iSystemUserID, @iSystemUserEmail, @iSystemUserSex, @iSystemUserNumber", _SystemUserID, _SystemUserEmail, _SystemUserSex, _SystemUserNumber).ToList().First();
        return user;
    }
    public bool sp_HasUserInvited(string iSystemUserEmail)
    {
        SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
        return this.UserInvite.FromSqlRaw("Exec sp_GetUserInvite @iSystemUserEmail", _SystemUserEmail).ToList().Count() == 1;
    }
    public UserInvite sp_GetUserInvite(string iSystemUserEmail)
    {
        SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
        UserInvite user = this.UserInvite.FromSqlRaw("Exec sp_GetUserInvite @iSystemUserEmail", _SystemUserEmail).ToList().First();
        return user;
    }
    public List<GroupsName> sp_GetGroupList(string iSystemUserEmail)
    {
        SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
        List<GroupsName> result = this._GroupsName.FromSqlRaw("Exec sp_GetGroupList @iSystemUserEmail", _SystemUserEmail).ToList();
        return result;
    }
    public List<GroupsName> sp_GetEditGroupList(string iSystemUserEmail)
    {
        SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
        List<GroupsName> result = this._GroupsName.FromSqlRaw("Exec sp_GetEditGroupList @iSystemUserEmail", _SystemUserEmail).ToList();
        return result;
    }
    public List<Features> sp_GetGroupFeatures(string iSystemUserEmail, int iGroupID)
    {
        try
        {
            SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
            SqlParameter _GroupID = new("@iGroupID", iGroupID);
            List<Features> res = this._Features.FromSqlRaw("Exec sp_GetGroupFeatures @iSystemUserEmail, @iGroupID", _SystemUserEmail, _GroupID).ToList();
            return res;
        }
        catch (Exception e)
        {
            throw e;
        }
    }
    public List<GroupWithFeature> sp_AddGroup(string iGroupName, System.Xml.Linq.XDocument iFeaturesID, string iSystemUserEmail, int ParentGroupID)
    {
        SqlParameter _GroupName = new("@iGroupName", iGroupName);
        SqlParameter _FeaturesID = new("@iFeaturesID", iFeaturesID.ToString());
        SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
        SqlParameter _ParentGroupID = new("@iParentGroupID", ParentGroupID);
        List<GroupWithFeature> result = this._GroupWithFeature.FromSqlRaw("EXEC sp_AddGroup @iGroupName, @iFeaturesID, @iSystemUserEmail, @iParentGroupID", _GroupName, _FeaturesID, _SystemUserEmail, _ParentGroupID).ToList();
        return result;
    }
}