function Get-ProjectName {
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

function Write-ProjectDirectory {
    param(
        [string]$projectName
    )
    New-Item -ItemType Directory -Force -Path $projectName
    Set-Location $projectName
}

function Write-Solution {
    param(
        [string]$projectName
    )
    dotnet new sln -n $projectName
}

function Write-Directories {
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

function Write-Projects {
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

function Add-Git {
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

function Start-Project {
    dotnet watch run
}
