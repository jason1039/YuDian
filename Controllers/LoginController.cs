using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using YuDian.Models;
using Microsoft.AspNetCore.Authentication;

namespace YuDian.Controllers;

public class LoginController : Controller
{
    private readonly ILogger<LoginController> _logger;

    public LoginController(ILogger<LoginController> logger)
    {
        _logger = logger;
    }

    public IActionResult SignInGoogle(string provider, string returnUrl = null)
    {
        var redirectUrl = Url.Action("Callback", controller: "Login", values: new { returnUrl });
        return new ChallengeResult(provider, new AuthenticationProperties { RedirectUri = redirectUrl ?? "/" });
    }

    public IActionResult Index(string returnUrl = null, string remoteError = null)
    {
        var claims = HttpContext.User;
        Console.WriteLine(claims.Identity);
        // 略...後續流程可直接參考官方範例，或自訂
        return Ok();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
