using System.Security.Claims;
using YuDian.Models;
using YuDian.FeaturesFunc;
namespace YuDian.Middleware;

public class AuthorizationMiddleware
{
    private readonly RequestDelegate _next;

    public AuthorizationMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context, MainContext _dbContext)
    {
        string Email = context.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (Email != null && context.Session.GetString("PageList") != string.Empty)
        {
            context.Session.SetString("PageList", SessionFunc.ToJson(_dbContext.sp_GetPageList(Email)));
        }
        await _next(context);
    }
}

public static class AuthorizationMiddlewareExtensions
{
    public static IApplicationBuilder UseSelfAuthorization(this IApplicationBuilder builder)
    {
        return builder.UseMiddleware<AuthorizationMiddleware>();
    }
}