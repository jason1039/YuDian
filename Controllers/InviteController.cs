using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using YuDian.Models;
using System.Security.Claims;

namespace YuDian.Controllers;

public class InviteController : Controller
{
    private ILogger<InviteController> _logger;
    private readonly MainContext _context;
    public InviteController(ILogger<InviteController> logger, MainContext context)
    {
        _logger = logger;
        _context = context;
    }
    [Authorize(Policy = "Invite.Index")]
    public IActionResult Index()
    {
        ViewBag.InviteState = _context.sp_GetUserInviteList();
        return View();
    }
    [Authorize(Policy = "Invite.Add")]
    [HttpGet]
    public IActionResult Add()
    {
        return View();
    }
    [Authorize(Policy = "Invite.AddPost")]
    [HttpPost]
    [ActionName("Add")]
    public async Task<IActionResult> AddPost([FromForm] AddPostData formData)
    {
        string InviterEmail = User.Claims.Where(c => c.Type == ClaimTypes.Email).Select(c => c.Value).SingleOrDefault();
        _context.sp_AddUserInvite(InviterEmail, formData.InviteEmail, formData.InviteName);
        return Redirect(Url.Action("Index", controller: "Invite"));
    }
}
public class AddPostData
{
    public string InviteName { get; set; }
    public string InviteEmail { get; set; }
}