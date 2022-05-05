using Microsoft.EntityFrameworkCore;
using Microsoft.Data.SqlClient;
using System.ComponentModel.DataAnnotations;
//https://ithelp.ithome.com.tw/articles/10186656
namespace YuDian.Models;

public partial class MainContext : DbContext
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
    // protected override void OnModelCreating(ModelBuilder modelBuilder)
    // {
    //     modelBuilder.Entity<SystemUser>().ToTable("SystemUser");
    // }
}