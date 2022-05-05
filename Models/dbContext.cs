using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;
using System.ComponentModel.DataAnnotations;
//https://ithelp.ithome.com.tw/articles/10186656
namespace YuDian.Models;

public class MainContext : DbContext
{
    //Server=localhost\SQLEXPRESS;Database=master;Trusted_Connection=True;
    public MainContext(DbContextOptions<MainContext> options) : base(options)
    {
    }
    private DbSet<SystemUser> SystemUser { get; set; }
    private DbSet<UserInvite> UserInvite { get; set; }
    private DbSet<InviteState> _InviteState { get; set; }
    private DbSet<Roles> _Roles { get; set; }
    private DbSet<Features> _Features { get; set; }
    private DbSet<PageList> _PageList { get; set; }
    private DbSet<GroupsName> _GroupsName { get; set; }
    private DbSet<GroupWithFeature> _GroupWithFeature { get; set; }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<SystemUser>().ToTable("SystemUser");
    }
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
    public List<GroupWithFeature> sp_AddGroup(string iGroupName, System.Xml.Linq.XDocument iFeaturesID, string iSystemUserEmail)
    {
        SqlParameter _GroupName = new("@iGroupName", iGroupName);
        SqlParameter _FeaturesID = new("@iFeaturesID", iFeaturesID.ToString());
        SqlParameter _SystemUserEmail = new("@iSystemUserEmail", iSystemUserEmail);
        List<GroupWithFeature> result = this._GroupWithFeature.FromSqlRaw("EXEC sp_AddGroup @iGroupName, @iFeaturesID, @iSystemUserEmail", _GroupName, _FeaturesID, _SystemUserEmail).ToList();
        return result;
    }
}