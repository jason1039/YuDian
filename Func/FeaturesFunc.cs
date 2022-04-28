using System.Text.Json;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication.Cookies;

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
}