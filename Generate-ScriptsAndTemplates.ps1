# Create Scripts and Templates directories
New-Item -ItemType Directory -Force -Path "Scripts"
New-Item -ItemType Directory -Force -Path "Templates"

# Define the script and template names
$scripts = @(
    "Initialize-Project.ps1",
    "Install-NuGetPackages.ps1",
    "Create-AccountController.ps1",
    "Create-Extensions.ps1",
    "Create-GlobalUsing.ps1",
    "Create-Program.ps1",
    "Create-TokenService.ps1",
    "Create-ApplicationDBContext.ps1",
    "Create-AppUser.ps1",
    "Create-RegisterDto.ps1",
    "Create-LoginDto.ps1",
    "Create-NewUserDto.ps1",
    "Create-ITokenService.ps1",
    "Create-AppSettings.ps1",
    "Initialize-Git.ps1",
    "Setup-Database.ps1",
    "Run-Project.ps1",
    "Create-Core-Files.ps1"
)

$templates = @(
    "AccountController.cs.temp",
    "Extensions.cs.temp",
    "GlobalUsing.cs.temp",
    "Program.cs.temp",
    "TokenService.cs.temp",
    "ApplicationDBContext.cs.temp",
    "AppUser.cs.temp",
    "RegisterDto.cs.temp",
    "LoginDto.cs.temp",
    "NewUserDto.cs.temp",
    "ITokenService.cs.temp",
    "appsettings.json.temp"
)

# Create blank script files
foreach ($script in $scripts) {
    $filePath = ".\Scripts\$script"
    if (-not (Test-Path -Path $filePath)) {
        New-Item -ItemType File -Force -Path $filePath
    }
}

# Create blank template files
foreach ($template in $templates) {
    $filePath = ".\Templates\$template"
    if (-not (Test-Path -Path $filePath)) {
        New-Item -ItemType File -Force -Path $filePath
    }
}

# Populate Create-Core-Files.ps1 with the structure for creating core files
$coreFilesContent = @"
param (
    [string] \$projectName
)

. .\Scripts\Create-AccountController.ps1 -projectName \$projectName
. .\Scripts\Create-Extensions.ps1 -projectName \$projectName
. .\Scripts\Create-GlobalUsing.ps1 -projectName \$projectName
. .\Scripts\Create-Program.ps1 -projectName \$projectName
. .\Scripts\Create-TokenService.ps1 -projectName \$projectName
. .\Scripts\Create-ApplicationDBContext.ps1 -projectName \$projectName
. .\Scripts\Create-AppUser.ps1 -projectName \$projectName
. .\Scripts\Create-RegisterDto.ps1 -projectName \$projectName
. .\Scripts\Create-LoginDto.ps1 -projectName \$projectName
. .\Scripts\Create-NewUserDto.ps1 -projectName \$projectName
. .\Scripts\Create-ITokenService.ps1 -projectName \$projectName
. .\Scripts\Create-AppSettings.ps1 -projectName \$projectName
"@
Set-Content ".\Scripts\Create-Core-Files.ps1" -Value $coreFilesContent

# Populate init.ps1 with the structure for execution
$initContent = @"
# Main script execution
\$projectName = Read-Host "Enter the Web API project name"

# Execute individual scripts
. .\Scripts\Initialize-Project.ps1 -projectName \$projectName
. .\Scripts\Install-NuGetPackages.ps1 -projectName \$projectName
. .\Scripts\Create-Core-Files.ps1 -projectName \$projectName
. .\Scripts\Initialize-Git.ps1
. .\Scripts\Setup-Database.ps1 -projectName \$projectName
. .\Scripts\Run-Project.ps1
"@
Set-Content ".\init.ps1" -Value $initContent
