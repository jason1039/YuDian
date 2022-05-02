using System.ComponentModel.DataAnnotations;
public class GroupsName
{
    public Int64 Seq { get; set; }
    [Key]
    public int GroupID { get; set; }
    public string GroupName { get; set; }
}