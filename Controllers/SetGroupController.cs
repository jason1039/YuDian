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
        ViewBag.GroupList = _context.sp_GetGroupList();
        return View();
    }
    [HttpGet]
    public IActionResult Add()
    {
        string UserEmail = FeaturesFunc.User.GetUserEmail(User);
        ViewBag.Features = _context.sp_GetFeatures(UserEmail);
        return View();
    }
    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}
