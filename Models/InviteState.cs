using Microsoft.EntityFrameworkCore;

namespace YuDian.Models;
[Keyless]
public class InviteState
{
    public Int64 Seq { get; set; }
    public string InviteName { get; set; }
    public string InviteEmail { get; set; }
    public string Completed { get; set; }
}