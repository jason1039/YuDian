using System.ComponentModel.DataAnnotations;

namespace YuDian.Models;

public class Features
{
    [Key]
    public int FeatureID { get; set; }
    public string FeatureName { get; set; }

}