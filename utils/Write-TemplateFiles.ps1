# Write-TemplateFiles.ps1
# Script to generate template files for .NET project

$templateDir = ".\templates\core_templates"

# Ensure template directory exists
if (-Not (Test-Path -Path $templateDir)) {
    New-Item -ItemType Directory -Path $templateDir -Force
}

# Template content for each file
$templates = @{
    "AccountController.cs.template" = @"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using {{ProjectName}}.Api.Dtos.Account;
using {{ProjectName}}.Api.Interfaces;
using {{ProjectName}}.Api.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace {{ProjectName}}.Api.Controllers
{
    [Route(""api/account"")]
    [ApiController]
    public class AccountController : ControllerBase
    {
        private readonly UserManager<AppUser> _userManager;
        private readonly ITokenService _tokenService;
        private readonly SignInManager<AppUser> _signinManager;
        public AccountController(UserManager<AppUser> userManager, ITokenService tokenService, SignInManager<AppUser> signInManager)
        {
            _userManager = userManager;
            _tokenService = tokenService;
            _signinManager = signInManager;
        }

        [HttpPost(""login"")]
        public async Task<IActionResult> Login(LoginDto loginDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var user = await _userManager.Users.FirstOrDefaultAsync(x => x.UserName == loginDto.Username.ToLower());

            if (user == null) return Unauthorized(""Invalid username!"");

            var result = await _signinManager.CheckPasswordSignInAsync(user, loginDto.Password, false);

            if (!result.Succeeded) return Unauthorized(""Username not found and/or password incorrect"");

            return Ok(
                new NewUserDto
                {
                    UserName = user.UserName,
                    Email = user.Email,
                    Token = _tokenService.CreateToken(user)
                }
            );
        }

        [HttpPost(""register"")]
        public async Task<IActionResult> Register([FromBody] RegisterDto registerDto)
        {
            try
            {
                if (!ModelState.IsValid)
                    return BadRequest(ModelState);

                var appUser = new AppUser
                {
                    UserName = registerDto.Username,
                    Email = registerDto.Email
                };

                var createdUser = await _userManager.CreateAsync(appUser, registerDto.Password);

                if (createdUser.Succeeded)
                {
                    var roleResult = await _userManager.AddToRoleAsync(appUser, ""User"");
                    if (roleResult.Succeeded)
                    {
                        return Ok(
                            new NewUserDto
                            {
                                UserName = appUser.UserName,
                                Email = appUser.Email,
                                Token = _tokenService.CreateToken(appUser)
                            }
                        );
                    }
                    else
                    {
                        return StatusCode(500, roleResult.Errors);
                    }
                }
                else
                {
                    return StatusCode(500, createdUser.Errors);
                }
            }
            catch (Exception e)
            {
                return StatusCode(500, e);
            }
        }
    }
}
"@
    "Extensions.cs.template" = @"
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using {{ProjectName}}.Api.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace {{ProjectName}}.Api.Helpers
{
    public class QueryObject
    {   
        // Pagination     
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 20;
    }
}
"
    "GlobalUsing.cs.template" = @"
global using Microsoft.AspNetCore.Mvc;
global using Microsoft.EntityFrameworkCore;
global using Microsoft.Extensions.Configuration;
global using Microsoft.Extensions.DependencyInjection;
global using Microsoft.Extensions.Hosting;
global using System;
global using System.Collections.Generic;
global using System.Threading.Tasks;

global using {{ProjectName}}.Api.Data;
global using {{ProjectName}}.Api.Interfaces;
global using {{ProjectName}}.Api.Models;
//global using {{ProjectName}}.Api.Repositories;
global using {{ProjectName}}.Api.Services;
global using {{ProjectName}}.Api.Helpers;
//global using {{ProjectName}}.Api.Mappers;
global using {{ProjectName}}.Api.Dtos.Account;
"
    "Program.cs.template" = @"
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddSwaggerGen(option =>
{
    option.SwaggerDoc(""v1"", new OpenApiInfo { Title = ""{{ProjectName}}"", Version = ""v1"" });
    option.AddSecurityDefinition(""Bearer"", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = ""Please enter a valid token"",
        Name = ""Authorization"",
        Type = SecuritySchemeType.Http,
        BearerFormat = ""JWT"",
        Scheme = ""Bearer""
    });
    option.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type=ReferenceType.SecurityScheme,
                    Id=""Bearer""
                }
            },
            new string[]{}
        }
    });
});

builder.Services.AddControllers().AddNewtonsoftJson(options =>
{
    options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore;
});

builder.Services.AddDbContext<ApplicationDBContext>(options =>
{
    options.UseSqlite(builder.Configuration.GetConnectionString(""DefaultConnection""));
});

builder.Services.AddIdentity<AppUser, IdentityRole>(options =>
{
    options.Password.RequireDigit = true;
    options.Password.RequireLowercase = true;
    options.Password.RequireUppercase = true;
    options.Password.RequireNonAlphanumeric = true;
    options.Password.RequiredLength = 12;
})
.AddEntityFrameworkStores<ApplicationDBContext>();

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme =
    options.DefaultChallengeScheme =
    options.DefaultForbidScheme =
    options.DefaultScheme =
    options.DefaultSignInScheme =
    options.DefaultSignOutScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidIssuer = builder.Configuration[""JWT:Issuer""],
        ValidateAudience = true,
        ValidAudience = builder.Configuration[""JWT:Audience""],
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(
            System.Text.Encoding.UTF8.GetBytes(builder.Configuration[""JWT:SigningKey""])
        )
    };
});

builder.Services.AddScoped<ITokenService, TokenService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
"@
    "TokenService.cs.template" = @"
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using {{ProjectName}}.Api.Interfaces;
using {{ProjectName}}.Api.Models;
using Microsoft.IdentityModel.Tokens;

namespace {{ProjectName}}.Api.Services
{
    public class TokenService : ITokenService
    {
        private readonly IConfiguration _config;
        private readonly SymmetricSecurityKey _key;

        public TokenService(IConfiguration config)
        {
            _config = config;
            _key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config[""JWT:SigningKey""]));
        }
        public string CreateToken(AppUser user)
        {
            var claims = new List<Claim>
            {
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim(JwtRegisteredClaimNames.GivenName, user.UserName)
            };

            var creds = new SigningCredentials(_key, SecurityAlgorithms.HmacSha512Signature);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddDays(7),
                SigningCredentials = creds,
                Issuer = _config[""JWT:Issuer""],
                Audience = _config[""JWT:Audience""]
            };

            var tokenHandler = new JwtSecurityTokenHandler();

            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }
    }
}
"@
    "ApplicationDBContext.cs.template" = @"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using {{ProjectName}}.Api.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace {{ProjectName}}.Api.Data
{
    public class ApplicationDBContext : IdentityDbContext<AppUser>
    {
        public ApplicationDBContext(DbContextOptions dbContextOptions)
        : base(dbContextOptions)
        {

        }

        //add DbSet here

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            List<IdentityRole> roles = new List<IdentityRole>
            {
                new IdentityRole
                {
                    Name = ""Admin"",
                    NormalizedName = ""ADMIN""
                },
                new IdentityRole
                {
                    Name = ""User"",
                    NormalizedName = ""USER""
                },
            };
            builder.Entity<IdentityRole>().HasData(roles);
        }
    }
}
"@
    "AppUser.cs.template" = @"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;

namespace {{ProjectName}}.Api.Models
{
    public class AppUser : IdentityUser
    {

    }
}
"@
    "RegisterDto.cs.template" = @"
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace {{ProjectName}}.Api.Dtos.Account
{
    public class RegisterDto
    {
        [Required]
        public string? Username { get; set; }
        [Required]
        [EmailAddress]
        public string? Email { get; set; }
        [Required]
        public string? Password { get; set; }
    }
}
"@
    "LoginDto.cs.template" = @"
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace {{ProjectName}}.Api.Dtos.Account
{
    public class LoginDto
    {
        [Required]
        public string Username { get; set; }
        [Required]
        public string Password { get; set; }
    }
}
"@
    "NewUserDto.cs.template" = @"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace {{ProjectName}}.Api.Dtos.Account
{
    public class NewUserDto
    {
        public string UserName { get; set; }
        public string Email { get; set; }
        public string Token { get; set; }
    }
}
"@
    "ITokenService.cs.template" = @"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using {{ProjectName}}.Api.Models;

namespace {{ProjectName}}.Api.Interfaces
{
    public interface ITokenService
    {
        string CreateToken(AppUser user);
    }
}
"
    "appsettings.json.template" = @"
{
    ""ConnectionStrings"": {
        ""DefaultConnection"": ""Data Source=app.db;""
    },
    ""Logging"": {
        ""LogLevel"": {
            ""Default"": ""Information"",
            ""Microsoft.AspNetCore"": ""Warning""
        }
    },
    ""AllowedHosts"": ""*"",
    ""JWT"": {
        ""Issuer"": ""http://localhost:5246"",
        ""Audience"": ""http://localhost:5246"",
        ""SigningKey"": ""sdgfijh3466iu345g87g08c24g7gr803g30587ghh35807fg39074fvg80493745gf082b507807g807fgf""
    }
}
"@
}

# Write templates to files
foreach ($template in $templates.GetEnumerator()) {
    $filePath = Join-Path -Path $templateDir -ChildPath $template.Key
    Set-Content -Path $filePath -Value $template.Value
}
