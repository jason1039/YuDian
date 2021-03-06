using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.Cookies;
using YuDian.FeaturesFunc;
using YuDian.Middleware;
using YuDian.Models;

WebApplicationBuilder builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddDistributedMemoryCache();
builder.Services.AddDbContext<MainContext>(options =>
    options.UseSqlServer("Server=DESKTOP-UG4OT54\\SQLEXPRESS;Database=YuDian;Trusted_Connection=True;"));
builder.Services.AddSession(options =>
            {
                options.Cookie.Name = ".AdventureWorks.Session";
                options.IdleTimeout = TimeSpan.FromSeconds(10);//设置session的过期时间
                options.Cookie.HttpOnly = true;//设置在浏览器不能通过js获得该cookie的值 
            });
builder.Services.AddHttpClient();
builder.Services.AddAuthorization(options =>
{
    Auth.AddPolicy(ref options);
    options.AddPolicy("RequireClaim", policy =>
           policy.RequireRole("admin"));
})
.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme).AddCookie(options =>
{
    options.LoginPath = new PathString("/SignIn/Index");
    options.AccessDeniedPath = new PathString("/Home/Index");
});
builder.Services.AddHttpContextAccessor();
var app = builder.Build();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseSession();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.UseSelfAuthorization();

app.MapControllerRoute(name: "default", pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
