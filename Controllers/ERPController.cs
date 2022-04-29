using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using YuDian.Models;
using Microsoft.AspNetCore.Authorization;

namespace YuDian.Controllers;
public class ERPController : Controller
{
    private readonly ILogger<ERPController> _logger;
    public ERPController(ILogger<ERPController> logger)
    {
        _logger = logger;
    }
    [Authorize(Policy = "ERP.Index")]
    public IActionResult Index()
    {
        return View();
    }
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
}