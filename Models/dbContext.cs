using YuDian.Models;
using Microsoft.EntityFrameworkCore;

namespace YuDian.Models;

public class MainContext : DbContext
{
    public MainContext(DbContextOptions<MainContext> options) : base(options)
    {
    }
    public DbSet<SystemUser> SystemUser { get; set; }
}