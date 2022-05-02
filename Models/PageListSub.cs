using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace YuDian.Models;
[Keyless]
public class PageListSub
{
    public int PageSeq { get; set; }
    public string FeatureName { get; set; }
    public string MainController { get; set; }
    public string MainAction { get; set; }
}