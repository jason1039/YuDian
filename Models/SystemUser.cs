using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace YuDian.Models;
public class SystemUser
{
    [Key]
    [Required]
    [StringLength(10)]
    [RegularExpression("^[A-Z][0-9]{9}$")]
    public string SystemUserID { get; set; }
    [Required]
    [DataType(DataType.EmailAddress)]
    public string SystemUserEmail { get; set; }
    public string SystemUserName { get; set; }
    [StringLength(1)]
    [RegularExpression("^[M|W]$")]
    public string SystemUserSex { get; set; }
    [StringLength(10)]
    [RegularExpression("^[0-9]{9,10}$")]
    public string SystemUserNumber { get; set; }
    [DataType(DataType.DateTime)]
    [DisplayFormat(DataFormatString = "{yyyy-MM-dd HH:mm:ss}", ApplyFormatInEditMode = true)]
    public DateTime CreateTime { get; set; }
    [StringLength(1)]
    [RegularExpression("^[U|S|D]$")]
    public string AccountState { get; set; }
    [Required]
    [StringLength(10)]
    [RegularExpression("^[A-Z][0-9]{9}$")]
    public string Creator { get; set; }
}