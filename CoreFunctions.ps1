# Functions.ps1
# Common utility functions for setting up the .NET Web API project

<#
.SYNOPSIS
Prompts the user for the project name.
#>
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

<#
.SYNOPSIS
Creates the project directory and navigates into it.
#>
function Write-ProjectDirectory {
    param(
        [string]$projectName
    )
    try {
        New-Item -ItemType Directory -Force -Path $projectName
        #Set-Location $projectName
    } catch {
        Write-Host "Error creating project directory: $_"
        exit
    }
}

<#
.SYNOPSIS
Creates the solution file for the project.
#>
function Write-Solution {
    param(
        [string]$projectName
    )
    try {
        dotnet new sln -n $projectName
    } catch {
        Write-Host "Error creating solution: $_"
        exit
    }
}

<#
.SYNOPSIS
Creates the necessary directory structure for the project.
#>
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
        try {
            New-Item -ItemType Directory -Force -Path $dir
        } catch {
            Write-Host "Error creating directory $_"
            exit
        }
    }
}

<#
.SYNOPSIS
Creates the main Web API project.
#>
function Write-Projects {
    param(
        [string]$projectName
    )
    try {
        dotnet new webapi -n "$projectName.Api" -o "$projectName/src/$projectName.Api"
    } catch {
        Write-Host "Error creating project: $_"
        exit
    }
}

<#
.SYNOPSIS
Adds the created project to the solution.
#>
function Add-ProjectsToSolution {
    param(
        [string]$projectName
    )
    try {
        dotnet sln add "$projectName/src/$projectName.Api/$projectName.Api.csproj"
    } catch {
        Write-Host "Error adding project to solution: $_"
        exit
    }
}

<#
.SYNOPSIS
Installs the necessary NuGet packages for the project.
#>
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

<#
.SYNOPSIS
Restores NuGet packages for the project.
#>
function Restore-NuGetPackages {
    param(
        [string]$projectName
    )
    try {
        dotnet restore "$projectName.sln"
    } catch {
        Write-Host "Error restoring NuGet packages: $_"
        exit
    }
}

<#
.SYNOPSIS
Initializes a Git repository and creates a .gitignore file.
#>
function Add-Git {
    try {
        git init
        dotnet new gitignore
    } catch {
        Write-Host "Error initializing git: $_"
        exit
    }
}

<#
.SYNOPSIS
Adds an initial migration and updates the database.
#>
function Add-MigrationAndUpdateDatabase {
    param(
        [string]$projectName
    )
    try {
        #Set-Location "$projectName/src/$projectName.Api"
        dotnet ef migrations add InitialCreateWithIdentity
        dotnet ef database update
    } catch {
        Write-Host "Error adding migration and updating database: $_"
        exit
    }
}

<#
.SYNOPSIS
Runs the project using dotnet watch run.
#>
function Start-Project {
    try {
        dotnet watch run
    } catch {
        Write-Host "Error running project: $_"
        exit
    }
}
