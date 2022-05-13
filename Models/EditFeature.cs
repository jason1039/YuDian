using System.ComponentModel.DataAnnotations;
namespace YuDian.Models;

public class EditFeatures
{
    [Key]
    public int FeatureID { get; set; }
    public string FeatureName { get; set; }
    public bool Choosed { get; set; }
}