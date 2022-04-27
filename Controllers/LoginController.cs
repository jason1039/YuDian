using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using YuDian.Models;
using Microsoft.AspNetCore.Authentication;
using System.Text.Json;
using System.Runtime.Serialization.Formatters.Binary;

namespace YuDian.Controllers;

public class LoginController : Controller
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly ILogger<LoginController> _logger;

    public LoginController(ILogger<LoginController> logger, IHttpClientFactory httpClientFactory)
    {
        _logger = logger;
        _httpClientFactory = httpClientFactory;
    }

    public IActionResult SignInGoogle(string provider, string returnUrl = null)
    {
        var redirectUrl = Url.Action("Callback", controller: "Login", values: new { returnUrl });
        return new ChallengeResult(provider, new AuthenticationProperties { RedirectUri = redirectUrl ?? "/" });
    }

    public async Task<IActionResult> Index([FromForm] GoogleData GoogleData)
    {
        HttpRequestMessage request = new HttpRequestMessage(HttpMethod.Get, $"https://oauth2.googleapis.com/tokeninfo?id_token={GoogleData.credential}");
        request.Headers.Add("Accept", "application/vnd.github.v3+json");
        var client = _httpClientFactory.CreateClient();

        var response = await client.SendAsync(request);
        if (response.IsSuccessStatusCode)
        {
            Stream responseStream = await response.Content.ReadAsStreamAsync();
            UserData userData = await JsonSerializer.DeserializeAsync<UserData>(responseStream);
            HttpContext.Session.SetString("UserEmail", userData.email);
            // _logger.LogInformation("UserData: {}", userData);
            // _logger.LogInformation("Session Time: {Time}", HttpContext.Session.Get<DateTime>(SessionKeyTime));
            // Session["UserData"] = userData;
            return Redirect(Url.Action("Index", "Home"));
        }
        else return Redirect(Url.Action("Error", controller: "Login"));

        // return View();
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