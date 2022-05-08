using System.Text.Json;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Identity;
using YuDian.Models;

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
    public class Interact
    {
        private IHttpClientFactory _httpClientFactory;
        private HttpRequestMessage _httpRequestMessage;
        private HttpClient _httpClient;
        private Task<HttpResponseMessage> _response;
        private HttpMethod _method = HttpMethod.Get;
        public HttpMethod Method
        {
            set { _method = value; }
        }
        public Interact(IHttpClientFactory HttpClientFactory)
        {
            this._httpClientFactory = HttpClientFactory;
        }
        public bool GetIsSuccessStatusCode()
        {
            return this._response.Result.IsSuccessStatusCode;
        }
        public void Start(string url)
        {
            SetRequestMessage(url);
            CreateClient();
            GetResponse();
        }
        public async Task<T> GetResult<T>()
        {
            Stream content = await this.GetContent();
            return await JsonSerializer.DeserializeAsync<T>(content);
        }
        private async Task<Stream> GetContent()
        {
            return await this._response.Result.Content.ReadAsStreamAsync();
        }
        private void GetResponse()
        {
            this._response = this._httpClient.SendAsync(this._httpRequestMessage);
        }
        private void SetRequestMessage(string url)
        {
            this._httpRequestMessage = new HttpRequestMessage(this._method, url);
            this._httpRequestMessage.Headers.Add("Accept", "application/vnd.github.v3+json");
        }
        private void CreateClient()
        {
            this._httpClient = _httpClientFactory.CreateClient();
        }
    }
    public static class CP
    {
        public static ClaimsPrincipal Create(List<Claim> Cliams)
        {
            ClaimsIdentity identity = CreateCI();
            AddClaims(ref identity, Cliams);
            return new ClaimsPrincipal(identity);
        }
        private static ClaimsIdentity CreateCI()
        {
            return new ClaimsIdentity(CookieAuthenticationDefaults.AuthenticationScheme);
        }
        private static void AddClaims(ref ClaimsIdentity identity, List<Claim> Cliams)
        {
            foreach (Claim cm in Cliams.ToArray())
            {
                identity.AddClaim(cm);
            }
        }
    }
    public static class Auth
    {
        public static void AddPolicy(ref Microsoft.AspNetCore.Authorization.AuthorizationOptions options)
        {
            string[] FilesPath = GetFilesList();
            for (int i = 0; i < FilesPath.Length; i++)
            {
                string Controller = ReplacePath(FilesPath[i]);
                string[] Controlers = GetControls(FilesPath[i]);
                foreach (string control in Controlers)
                {
                    string authPolicy = $"{Controller}.{control}";
                    Console.WriteLine(authPolicy);
                    options.AddPolicy(authPolicy, policy => policy.RequireRole(authPolicy));
                }
            }
        }
        private static string ReplacePath(string Path)
        {
            System.Text.RegularExpressions.Regex reg = new(@"\.\/Controllers\/");
            Path = reg.Replace(Path, "");
            reg = new(@"Controller.cs");
            Path = reg.Replace(Path, "");
            return Path;
        }
        private static string[] GetFilesList()
        {
            return System.IO.Directory.GetFiles("./Controllers/");
        }
        private static string[] GetControls(string path)
        {
            List<string> result = new();
            System.Text.RegularExpressions.Regex _reg = new(@"public\s(async\sTask<)?(IActionResult|JsonResult|EmptyResult)(>)?\s[A-Za-z_]*\([^\)]*\)");
            string FileContent = System.IO.File.ReadAllText(path);
            System.Text.RegularExpressions.MatchCollection Lines = _reg.Matches(FileContent);
            foreach (var i in Lines)
            {
                System.Text.RegularExpressions.Regex __reg = new(@"(public\s)(async\sTask<)?(IActionResult|JsonResult|EmptyResult)(>)?(\s)([A-Za-z_]*)(\([^\)]*\))");
                string pattern = @"(public\s)(async\sTask<)?(IActionResult|JsonResult|EmptyResult)(>)?(\s)([A-Za-z_]*)(\([^\)]*\))";
                string replacement = "$6";
                string result_str = System.Text.RegularExpressions.Regex.Replace(i.ToString(), pattern, replacement);
                result.Add(result_str);
            }
            return result.ToArray();
        }
    }
    public static class SignUp
    {
        public static bool CheckIdentity(string Identity)
        {
            if (Identity.Length != 10) return false;
            System.Text.RegularExpressions.Regex reg = new(@"^[A-Z][1|2][0-9]{8}$");
            if (!reg.IsMatch(Identity)) return false;
            int[] compareTable = { 10, 11, 12, 13, 14, 15, 16, 17, 34, 18, 19, 20, 21, 22, 35, 23, 24, 25, 26, 27, 28, 29, 32, 30, 31, 33 };
            int temp = 0;
            temp += (compareTable[Convert.ToInt32(Identity[0]) - 65] / 10);
            temp += (compareTable[Convert.ToInt32(Identity[0]) - 65] % 10) * 9;
            for (int i = 1; i < 9; i++)
            {
                temp += (9 - i) * int.Parse(Identity[i].ToString());
            }
            return (temp += int.Parse(Identity[9].ToString())) % 10 == 0;
        }
        public static bool GetSex(string Identity)
        {
            return Identity[1] == '1';
        }
        public static bool CheckPhoneNumber(string PhoneNumber)
        {
            System.Text.RegularExpressions.Regex reg = new(@"^0[0-9]{8,9}$");
            return reg.IsMatch(PhoneNumber);
        }
    }
    public static class User
    {
        private static string Keyword = "$@!::::$@!";
        public static string GetUserEmail(ClaimsPrincipal User)
        {
            return User.Claims.Where(c => c.Type == ClaimTypes.Email).Select(c => c.Value).SingleOrDefault();
        }
        private static string _Encryption(string UserEmail, string EncryptionString)
        {
            string result = string.Empty;
            for (int i = 0; i < EncryptionString.Length; i++)
                result += (char)((int)EncryptionString[i] ^ (int)UserEmail[i % UserEmail.Length]);
            return result;
        }
        public static string Encryption(ClaimsPrincipal User, string EncryptionString)
        {
            string UserEmail = GetUserEmail(User);

            EncryptionString = $"{DateTime.Now.ToString("yyyyMMddHHmmssffff")}{Keyword}" + EncryptionString + Keyword;
            while (EncryptionString.Length < 40)
                EncryptionString += ":A0";
            string result = _Encryption(UserEmail, EncryptionString);

            return result;
        }
        public static string Decryption(ClaimsPrincipal User, string DecryptionString)
        {
            string UserEmail = GetUserEmail(User);
            string temp = _Encryption(UserEmail, DecryptionString);

            string result = temp.Split(Keyword)[1];
            return result;
        }
    }
}