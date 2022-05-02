using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace YuDian.Models;
[Keyless]
public class PageListTitle
{
    public int TitleSeq { get; set; }
    public string TitleName { get; set; }
    public List<PageListSub> PageListSubs { get; set; }
}