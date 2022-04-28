using System.Text.Json;

namespace YuDian.FeaturesFunc
{
    public class SessionFunc
    {
        public static string ToJson(object obj)
        {
            return JsonSerializer.Serialize(obj);
        }
        public static T ToObj<T>(string value)
        {
            return JsonSerializer.Deserialize<T>(value);
        }
    }
}