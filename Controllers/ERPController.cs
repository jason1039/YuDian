using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using YuDian.Models;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;

namespace YuDian.Controllers;
// [Authorize(Policy = "RequireClaim")]
public class ERPController : Controller
{
    private readonly ILogger<ERPController> _logger;
    public ERPController(ILogger<ERPController> logger)
    {
        _logger = logger;
    }
    public IActionResult Index()
    {
        return View();
    }
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}