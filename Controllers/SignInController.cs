using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using YuDian.Models;
using Microsoft.AspNetCore.Authentication;
using YuDian.FeaturesFunc;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using System.Text;

namespace YuDian.Controllers;

public class SignInController : Controller
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly ILogger<SignInController> _logger;
    private readonly MainContext _context;
    public SignInController(ILogger<SignInController> logger, IHttpClientFactory httpClientFactory, MainContext context)
    {
        _logger = logger;
        _httpClientFactory = httpClientFactory;
        _context = context;
    }
    [AllowAnonymous]
    public async Task<IActionResult> Index([FromForm] GoogleData GoogleData)
    {
        Interact interact = new(_httpClientFactory);
        interact.Start($"https://oauth2.googleapis.com/tokeninfo?id_token={GoogleData.credential}");
        if (interact.GetIsSuccessStatusCode())
        {
            UserData userData = await interact.GetResult<UserData>();
            if (!_context.sp_HasSystemUser(userData.email))
            {
                if (_context.sp_HasUserInvited(userData.email))
                {
                    HttpContext.Session.SetString("SignUpData", SessionFunc.ToJson(userData));
                    return Redirect(Url.Action("SignUp", "SignIn"));
                }
                return Redirect(Url.Action("Error", controller: "SignIn"));
            }

            SystemUser user = _context.sp_GetSystemUser(userData.email);
            List<Roles> Roles = _context.sp_GetRoles(userData.email);

            List<Claim> Cliams = new();
            Cliams.Add(new Claim(ClaimTypes.NameIdentifier, user.SystemUserEmail));
            Cliams.Add(new Claim(ClaimTypes.Sid, user.SystemUserID));
            Cliams.Add(new Claim(ClaimTypes.Name, user.SystemUserName));
            Cliams.Add(new Claim(ClaimTypes.Email, user.SystemUserEmail));
            Cliams.Add(new Claim(ClaimTypes.Role, "SignIn.Logout"));
            foreach (var role in Roles)
            {
                Cliams.Add(new Claim(ClaimTypes.Role, role.RoleStr));
            }
            // HttpContext.Session.SetString("PageList", SessionFunc.ToJson(_context.sp_GetPageList(userData.email)));
            await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, CP.Create(Cliams));
            return Redirect(Url.Action("Index", "Home"));
        }
        else return Redirect(Url.Action("Error", controller: "SignIn"));
    }
    [Authorize(Policy = "SignIn.Logout")]
    public async Task<IActionResult> Logout()
    {
        await HttpContext.SignOutAsync();
        HttpContext.Session.Clear();
        ViewBag.PageList = null;
        return Redirect(Url.Action("Index", "Home"));
    }
    [AllowAnonymous]
    [HttpGet]
    public IActionResult SignUp()
    {
        if (HttpContext.Session.GetString("SignUpData") != string.Empty)
        {
            UserData user = SessionFunc.ToObj<UserData>(HttpContext.Session.GetString("SignUpData"));
            UserInvite info = _context.sp_GetUserInvite(user.email);
            ViewBag.Email = info.InviteEmail;
            ViewBag.Name = info.InviteName;
            return View();
        }
        return Redirect(Url.Action("Error", controller: "SignIn"));
    }
    [AllowAnonymous]
    [HttpPost]
    [ActionName("SignUp")]
    public IActionResult SignUpPost([FromForm] SignUpData signUpData)
    {
        if (HttpContext.Session.GetString("SignUpData") != string.Empty)
        {
            UserData user = SessionFunc.ToObj<UserData>(HttpContext.Session.GetString("SignUpData"));
            UserInvite info = _context.sp_GetUserInvite(user.email);
            if (user.email != info.InviteEmail) return Redirect(Url.Action("Error", controller: "SignIn"));
            if (!FeaturesFunc.SignUp.CheckIdentity(signUpData.UserID)) return Redirect(Url.Action("Error", controller: "SignIn"));
            if (!FeaturesFunc.SignUp.CheckPhoneNumber(signUpData.UserPhone)) return Redirect(Url.Action("Error", controller: "SignIn"));
            bool Sex = FeaturesFunc.SignUp.GetSex(signUpData.UserID);
            _context.sp_AddSystemUser(signUpData.UserID, info.InviteEmail, Sex, signUpData.UserPhone);
            HttpContext.Session.Clear();
            return Redirect(Url.Action("Index", "Home"));
        }
        return Redirect(Url.Action("Error", controller: "SignIn"));
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
public class SignUpData
{
    public string UserID { get; set; }
    public string UserPhone { get; set; }
}