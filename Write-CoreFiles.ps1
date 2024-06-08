<#
.SYNOPSIS
This script contains functions to write basic files for the .NET Web API project using templates.
#>

function Get-TemplateContent {
    param (
        [string]$templatePath
    )

    $content = Get-Content -Path $templatePath -Raw
    return $content
}

function Write-CoreFiles {
    param(
        [string]$projectName,
        [string]$templateDir
    )


    Write-AccountController -projectName $projectName -templateDir $templateDir
    Write-Extensions -projectName $projectName -templateDir $templateDir
    Write-GlobalUsing -projectName $projectName -templateDir $templateDir
    Write-Program -projectName $projectName -templateDir $templateDir
    Write-TokenService -projectName $projectName -templateDir $templateDir
    Write-ApplicationDBContext -projectName $projectName -templateDir $templateDir
    Write-AppUser -projectName $projectName -templateDir $templateDir
    Write-RegisterDto -projectName $projectName -templateDir $templateDir
    Write-LoginDto -projectName $projectName -templateDir $templateDir
    Write-NewUserDto -projectName $projectName -templateDir $templateDir
    Write-ITokenService -projectName $projectName -templateDir $templateDir
    Write-AppSettings -projectName $projectName -templateDir $templateDir
}

function Write-AccountController {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    
    $templatePath = Join-Path -Path $templateDir -ChildPath "AccountController.cs.template"    

    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/Controllers/AccountController.cs" -Value $content
}

function Write-Extensions {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    $templatePath =  Join-Path -Path $templateDir -ChildPath "Extensions.cs.template"
    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/Helpers/Extensions.cs" -Value $content
}

function Write-GlobalUsing {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    $templatePath = Join-Path -Path $templateDir -ChildPath "GlobalUsing.cs.template"
    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/GlobalUsing.cs" -Value $content
}

function Write-Program {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    $templatePath = Join-Path -Path $templateDir -ChildPath "Program.cs.template"
    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/Program.cs" -Value $content
}

function Write-TokenService {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    $templatePath = Join-Path -Path $templateDir -ChildPath "TokenService.cs.template"
    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/Services/TokenService.cs" -Value $content
}

function Write-ApplicationDBContext {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    $templatePath = Join-Path -Path $templateDir -ChildPath "ApplicationDBContext.cs.template"
    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/Data/ApplicationDBContext.cs" -Value $content
}

function Write-AppUser {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    $templatePath = Join-Path -Path $templateDir -ChildPath "AppUser.cs.template"
    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/Models/AppUser.cs" -Value $content
}

function Write-RegisterDto {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    $templatePath = Join-Path -Path $templateDir -ChildPath "RegisterDto.cs.template"
    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/Dtos/Account/RegisterDto.cs" -Value $content
}

function Write-LoginDto {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    $templatePath = Join-Path -Path $templateDir -ChildPath "LoginDto.cs.template"
    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/Dtos/Account/LoginDto.cs" -Value $content
}

function Write-NewUserDto {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    $templatePath = Join-Path -Path $templateDir -ChildPath "NewUserDto.cs.template"
    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/Dtos/Account/NewUserDto.cs" -Value $content
}

function Write-ITokenService {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    $templatePath = Join-Path -Path $templateDir -ChildPath "ITokenService.cs.template"
    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/Interfaces/ITokenService.cs" -Value $content
}

function Write-AppSettings {
    param(
        [string]$projectName,
        [string]$templateDir
    )

    $templatePath = Join-Path -Path $templateDir -ChildPath "appsettings.json.template"
    $content = Get-TemplateContent -templatePath $templatePath
    $content = $content -replace "{{ProjectName}}", $projectName
    Set-Content -Path "$projectName/src/$projectName.Api/appsettings.json" -Value $content
}
