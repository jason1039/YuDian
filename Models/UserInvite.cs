using System.ComponentModel.DataAnnotations;

namespace YuDian.Models;

public class UserInvite
{
    [Required]
    public int Inviter { get; set; }
    public DateTime InviteEndTime { get; set; }
    public DateTime InviteTime { get; set; }
    [Key]
    [Required]
    [DataType(DataType.EmailAddress)]
    public string InviteEmail { get; set; }
}