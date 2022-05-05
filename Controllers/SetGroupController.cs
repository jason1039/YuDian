using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using YuDian.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace YuDian.Controllers;
[AllowAnonymous]
public class SetGroupController : Controller
{
    private readonly ILogger<SetGroupController> _logger;
    private readonly MainContext _context;

    public SetGroupController(ILogger<SetGroupController> logger, MainContext context)
    {
        _logger = logger;
        _context = context;
    }
    [Authorize(Policy = "SetGroup.Index")]
    public IActionResult Index()
    {
        string UserEmail = FeaturesFunc.User.GetUserEmail(User);
        ViewBag.GroupList = _context.sp_GetGroupList(UserEmail);
        return View();
    }
    [HttpGet]
    [Authorize(Policy = "SetGroup.Add")]
    public IActionResult Add()
    {
        string UserEmail = FeaturesFunc.User.GetUserEmail(User);
        ViewBag.Features = _context.sp_GetFeatures(UserEmail);
        return View();
    }
    [HttpPost]
    [ActionName("Add")]
    [Authorize(Policy = "SetGroup.AddPost")]
    public IActionResult AddPost()
    {
        string UserEmail = FeaturesFunc.User.GetUserEmail(User);
        List<Features> features = _context.sp_GetFeatures(FeaturesFunc.User.GetUserEmail(User));
        List<int> FeaturesID = new();

        foreach (Features feature in features)
        {
            Microsoft.Extensions.Primitives.StringValues f = HttpContext.Request.Form[feature.FeatureName];
            if (f.Count == 1) FeaturesID.Add(feature.FeatureID);
        }
        System.Xml.Linq.XDocument doc = new();
        doc.Add(new System.Xml.Linq.XElement("root", FeaturesID.ToList().Select(x => new System.Xml.Linq.XElement("row", new System.Xml.Linq.XElement("FeatureID", x)))));
        _context.sp_AddGroup(HttpContext.Request.Form["GroupName"].First(), doc, UserEmail);
        return Redirect(Url.Action("Index", controller: "SetGroup"));
    }
    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
