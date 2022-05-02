using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace YuDian.Models;
[Keyless]
public class PageList
{
    public int TitleSeq { get; set; }
    public int PageSeq { get; set; }
    public string TitleName { get; set; }
    public string FeatureName { get; set; }
    public string MainController { get; set; }
    public string MainAction { get; set; }
}