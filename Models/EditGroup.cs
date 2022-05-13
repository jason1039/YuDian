namespace YuDian.Models;
public class EditGroup
{
    public string GroupName { get; set; }
    public string ParentName { get; set; }
    public List<EditFeatures> Features { get; set; }
}