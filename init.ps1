. .\Functions.ps1
. .\CreateBasicFiles.ps1

$projectName = Prompt-ProjectName -promptMessage "Enter the Web API project name"
Create-ProjectDirectory -projectName $projectName
Create-Solution -projectName $projectName
Create-Directories -projectName $projectName
Create-Projects -projectName $projectName
Add-ProjectsToSolution -projectName $projectName
Install-NuGetPackages -projectName $projectName
Restore-NuGetPackages -projectName $projectName

# Call individual file creation functions
Create-AccountController -projectName $projectName
Create-Extensions -projectName $projectName
Create-GlobalUsing -projectName $projectName
Create-Program -projectName $projectName
Create-TokenService -projectName $projectName
Create-ApplicationDBContext -projectName $projectName
Create-AppUser -projectName $projectName
Create-RegisterDto -projectName $projectName
Create-LoginDto -projectName $projectName
Create-NewUserDto -projectName $projectName
Create-ITokenService -projectName $projectName
Create-AppSettings -projectName $projectName

Init-Git
Add-MigrationAndUpdateDatabase -projectName $projectName
Run-Project