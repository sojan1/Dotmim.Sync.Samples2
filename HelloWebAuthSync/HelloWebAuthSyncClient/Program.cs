using Dotmim.Sync;
using Dotmim.Sync.Enumerations;
using Dotmim.Sync.Sqlite;
using Dotmim.Sync.SqlServer;
using Dotmim.Sync.Web.Client;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace HelloWebSyncClient
{
    class Program
    {
        // private static string clientConnectionString = $"Data Source=(localdb)\\mssqllocaldb; Initial Catalog=Client;Integrated Security=true;";
        private static string clientConnectionString = $"Data Source=C:\\Users\\sojan\\Downloads\\Dotmim.Sync-master1\\Dotmim.Sync-master\\DB\\CoreDatabase.db";

        static async Task Main()
        {
            try
            {
                Console.WriteLine("Be sure the web api has started. Then click enter..");
                Console.ReadLine();
                await SynchronizeAsync();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        private static async Task SynchronizeAsync()
        {
            var token = GenerateJwtToken("spertus@microsoft.com", "SPERTUS01");
            HttpClient httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var serverOrchestrator = new WebRemoteOrchestrator("http://127.0.0.1:84/api/sync", client: httpClient);
            //var serverOrchestrator = new WebRemoteOrchestrator("http://192.168.178.25:84/api/sync", client: httpClient);
            var clientProvider = new SqliteSyncProvider(clientConnectionString);

            // Set the web server Options
            var options = new SyncOptions
            {
                BatchDirectory = Path.Combine(SyncOptions.GetDefaultUserBatchDirectory(), "client")
            };
            //options.TransactionMode = TransactionMode.AllOrNothing;
            var agent = new SyncAgent(clientProvider, serverOrchestrator, options);


            var progress = new SynchronousProgress<ProgressArgs>(
                  pa => Console.WriteLine($"{pa.ProgressPercentage:p}\t {pa.Message}"));

            //var parameters2 = new SyncParameters
            //    {
            //        { "CLNT_ID","D1" },
            //        { "PROJ_ID","MASTER" }
            //    };

            var parameters2 = new SyncParameters
                {
                    { "CLNT_ID","D1" }
                };
            var s1 = await agent.SynchronizeAsync("v0", SyncType.Normal, parameters2, progress);
            Console.WriteLine(s1);

            Console.WriteLine("End");
        }

        private static string GenerateJwtToken(string email, string userid)
        {
            var claims = new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames.Iss, "Dotmim.Sync.Bearer"),
                new Claim(JwtRegisteredClaimNames.Aud, "Dotmim.Sync.Bearer"),
                new Claim(JwtRegisteredClaimNames.Sub, "Dotmim.Sync"),
                new Claim(JwtRegisteredClaimNames.Email, email),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new Claim(ClaimTypes.NameIdentifier, userid)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("KEY_CLIENT_12345"));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var expires = DateTime.Now.AddDays(Convert.ToDouble(10));

            var token = new JwtSecurityToken(
                "Dotmim.Sync.Bearer",
                "Dotmim.Sync.Bearer",
                claims,
                expires: expires,
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
