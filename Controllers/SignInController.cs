using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using YuDian.Models;
using Microsoft.AspNetCore.Authentication;
using YuDian.FeaturesFunc;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;

namespace YuDian.Controllers;

public class SignInController : Controller
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly ILogger<SignInController> _logger;
    public SignInController(ILogger<SignInController> logger, IHttpClientFactory httpClientFactory)
    {
        _logger = logger;
        _httpClientFactory = httpClientFactory;
    }
    [AllowAnonymous]
    public async Task<IActionResult> Index([FromForm] GoogleData GoogleData)
    {
        Interact interact = new(_httpClientFactory);
        interact.Start($"https://oauth2.googleapis.com/tokeninfo?id_token={GoogleData.credential}");
        if (interact.GetIsSuccessStatusCode())
        {
            UserData userData = await interact.GetResult<UserData>();

            List<Claim> Cliams = new();
            Cliams.Add(new Claim(ClaimTypes.NameIdentifier, userData.email));
            Cliams.Add(new Claim(ClaimTypes.Sid, userData.email));
            Cliams.Add(new Claim(ClaimTypes.Name, userData.name));
            Cliams.Add(new Claim(ClaimTypes.Role, "Login.Logout"));
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, CP.Create(Cliams));
            return Redirect(Url.Action("Index", "Home"));
        }
        else return Redirect(Url.Action("Error", controller: "Login"));
    }
    [Authorize(Policy = "Login.Logout")]
    public async Task<IActionResult> Logout()
    {
        await HttpContext.SignOutAsync();
        return Redirect(Url.Action("Index", "Home"));
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
public class GoogleData
{
    public string clientId { get; set; }
    public string credential { get; set; }
    public string select_by { get; set; }
    public string g_csrf_token { get; set; }
}
public class UserData
{
    public string iss { get; set; }
    public string nbf { get; set; }
    public string aud { get; set; }
    public string sub { get; set; }
    public string email { get; set; }
    public string email_verified { get; set; }
    public string azp { get; set; }
    public string name { get; set; }
    public string picture { get; set; }
    public string given_name { get; set; }
    public string family_name { get; set; }
    public string iat { get; set; }
    public string exp { get; set; }
    public string jti { get; set; }
    public string alg { get; set; }
    public string kid { get; set; }
    public string typ { get; set; }
}