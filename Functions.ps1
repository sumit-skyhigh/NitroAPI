function Prompt-ProjectName {
    param(
        [string]$promptMessage
    )
    $projectName = Read-Host $promptMessage

    if (-not $projectName -or $projectName -notmatch "^[a-zA-Z0-9_]+$") {
        Write-Host "Invalid project name. Please enter a valid project name."
        exit
    }

    return $projectName
}

function Create-ProjectDirectory {
    param(
        [string]$projectName
    )
    New-Item -ItemType Directory -Force -Path $projectName
    Set-Location $projectName
}

function Create-Solution {
    param(
        [string]$projectName
    )
    dotnet new sln -n $projectName
}

function Create-Directories {
    param(
        [string]$projectName
    )
    $directories = @(
        "$projectName/src/$projectName.Api/Controllers",
        "$projectName/src/$projectName.Api/Repositories",
        "$projectName/src/$projectName.Api/Data",
        "$projectName/src/$projectName.Api/Models",
        "$projectName/src/$projectName.Api/Services",
        "$projectName/src/$projectName.Api/Helpers",
        "$projectName/src/$projectName.Api/Interfaces",
        "$projectName/src/$projectName.Api/Mappers",
        "$projectName/src/$projectName.Api/Dtos/Account"
    )

    foreach ($dir in $directories) {
        New-Item -ItemType Directory -Force -Path $dir
    }
}

function Create-Projects {
    param(
        [string]$projectName
    )
    dotnet new webapi -n "$projectName.Api" -o "$projectName/src/$projectName.Api"
}

function Add-ProjectsToSolution {
    param(
        [string]$projectName
    )
    dotnet sln add "$projectName/src/$projectName.Api/$projectName.Api.csproj"
}

function Install-NuGetPackages {
    param(
        [string]$projectName
    )
    $nugetPackages = @(
        "Microsoft.AspNetCore.Authentication.JwtBearer 8.0.0",
        "Microsoft.AspNetCore.Identity.EntityFrameworkCore 8.0.0",
        "Microsoft.AspNetCore.Mvc.NewtonsoftJson 8.0.0",
        "Microsoft.AspNetCore.OpenApi 8.0.0",
        "Microsoft.EntityFrameworkCore.Design 8.0.0",
        "Microsoft.EntityFrameworkCore.Sqlite 8.0.0",
        "Microsoft.EntityFrameworkCore.Tools 8.0.0",
        "Microsoft.Extensions.Identity.Core 8.0.0",
        "Newtonsoft.Json 13.0.3",
        "Swashbuckle.AspNetCore 6.4.0"
    )

    foreach ($package in $nugetPackages) {
        $packageDetails = $package.Split(" ")
        $packageName = $packageDetails[0]
        if ($packageDetails.Length -gt 1) {
            $packageVersion = $packageDetails[1]
        } else {
            $packageVersion = "latest"
        }
        dotnet add "$projectName/src/$projectName.Api/$projectName.Api.csproj" package $packageName --version $packageVersion
    }
}

function Restore-NuGetPackages {
    param(
        [string]$projectName
    )
    dotnet restore "$projectName.sln"
}

function Create-BasicFiles {
    param(
        [string]$projectName
    )

    $files = @(
        @{path="$projectName/src/$projectName.Api/Controllers/AccountController.cs"; content=@"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using $projectName.Api.Dtos.Account;
using $projectName.Api.Interfaces;
using $projectName.Api.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace $($projectName).Api.Controllers
{
    [Route("api/account")]
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

        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginDto loginDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var user = await _userManager.Users.FirstOrDefaultAsync(x => x.UserName == loginDto.Username.ToLower());

            if (user == null) return Unauthorized("Invalid username!");

            var result = await _signinManager.CheckPasswordSignInAsync(user, loginDto.Password, false);

            if (!result.Succeeded) return Unauthorized("Username not found and/or password incorrect");

            return Ok(
                new NewUserDto
                {
                    UserName = user.UserName,
                    Email = user.Email,
                    Token = _tokenService.CreateToken(user)
                }
            );
        }

        [HttpPost("register")]
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
                    var roleResult = await _userManager.AddToRoleAsync(appUser, "User");
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
        },
        @{path="$projectName/src/$projectName.Api/Helpers/Extensions.cs"; content=@"
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using $projectName.Api.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace $projectName.Api.Helpers
{
    public class QueryObject
    {   
        // Pagination     
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 20;
    }
}
"@
        },
        @{path="$projectName/src/$projectName.Api/GlobalUsing.cs"; content=@"
global using Microsoft.AspNetCore.Mvc;
global using Microsoft.EntityFrameworkCore;
global using Microsoft.Extensions.Configuration;
global using Microsoft.Extensions.DependencyInjection;
global using Microsoft.Extensions.Hosting;
global using System;
global using System.Collections.Generic;
global using System.Threading.Tasks;

global using $projectName.Api.Data;
global using $projectName.Api.Interfaces;
global using $projectName.Api.Models;
//global using $projectName.Api.Repositories;
global using $projectName.Api.Services;
global using $projectName.Api.Helpers;
//global using $projectName.Api.Mappers;
global using $projectName.Api.Dtos.Account;
"@
        },
        @{path="$projectName/src/$projectName.Api/Program.cs"; content=@"
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
    option.SwaggerDoc("v1", new OpenApiInfo { Title = "$projectName", Version = "v1" });
    option.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Please enter a valid token",
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        BearerFormat = "JWT",
        Scheme = "Bearer"
    });
    option.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type=ReferenceType.SecurityScheme,
                    Id="Bearer"
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
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection"));
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
        ValidIssuer = builder.Configuration["JWT:Issuer"],
        ValidateAudience = true,
        ValidAudience = builder.Configuration["JWT:Audience"],
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(
            System.Text.Encoding.UTF8.GetBytes(builder.Configuration["JWT:SigningKey"])
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
        },
        @{path="$projectName/src/$projectName.Api/Services/TokenService.cs"; content=@"
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using $projectName.Api.Interfaces;
using $projectName.Api.Models;
using Microsoft.IdentityModel.Tokens;

namespace $projectName.Api.Services
{
    public class TokenService : ITokenService
    {
        private readonly IConfiguration _config;
        private readonly SymmetricSecurityKey _key;

        public TokenService(IConfiguration config)
        {
            _config = config;
            _key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["JWT:SigningKey"]));
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
                Issuer = _config["JWT:Issuer"],
                Audience = _config["JWT:Audience"]
            };

            var tokenHandler = new JwtSecurityTokenHandler();

            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }
    }
}
"@
        },
        @{path="$projectName/src/$projectName.Api/Data/ApplicationDBContext.cs"; content=@"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using $projectName.Api.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace $projectName.Api.Data
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
                    Name = "Admin",
                    NormalizedName = "ADMIN"
                },
                new IdentityRole
                {
                    Name = "User",
                    NormalizedName = "USER"
                },
            };
            builder.Entity<IdentityRole>().HasData(roles);
        }
    }
}
"@
        },
        @{path="$projectName/src/$projectName.Api/Models/AppUser.cs"; content=@"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Identity;

namespace $projectName.Api.Models
{
    public class AppUser : IdentityUser
    {

    }
}
"@
        },
        @{path="$projectName/src/$projectName.Api/Dtos/Account/RegisterDto.cs"; content=@"
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace $projectName.Api.Dtos.Account
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
        },
        @{path="$projectName/src/$projectName.Api/Dtos/Account/LoginDto.cs"; content=@"
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace $projectName.Api.Dtos.Account
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
        },
        @{path="$projectName/src/$projectName.Api/Dtos/Account/NewUserDto.cs"; content=@"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace $projectName.Api.Dtos.Account
{
    public class NewUserDto
    {
        public string UserName { get; set; }
        public string Email { get; set; }
        public string Token { get; set; }
    }
}
"@
        },
        @{path="$projectName/src/$projectName.Api/Interfaces/ITokenService.cs"; content=@"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using $projectName.Api.Models;

namespace  $projectName.Api.Interfaces
{
    public interface ITokenService
    {
        string CreateToken(AppUser user);
    }
}
"@
        },
        @{path="$projectName/src/$projectName.Api/appsettings.json"; content=@"
{
    "ConnectionStrings": {
      "DefaultConnection": "Data Source=app.db;"
    },
    "Logging": {
      "LogLevel": {
        "Default": "Information",
        "Microsoft.AspNetCore": "Warning"
      }
    },
    "AllowedHosts": "*",
    "JWT": {
      "Issuer": "http://localhost:5246",
      "Audience": "http://localhost:5246",
      "SigningKey": "sdgfijh3466iu345g87g08c24g7gr803g30587ghh35807fg39074fvg80493745gf082b507807g807fgf"
    }
  }
"@
        }
    )

    foreach ($file in $files) {
        Set-Content $file.path -Value $file.content
    }
}

function Init-Git {
    git init
    dotnet new gitignore
}

function Add-MigrationAndUpdateDatabase {
    param(
        [string]$projectName
    )
    Set-Location "$projectName/src/$projectName.Api"
    dotnet ef migrations add InitialCreateWithIdentity
    dotnet ef database update
}

function Run-Project {
    dotnet watch run
}
