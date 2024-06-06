. .\Functions.ps1
. .\WriteCoreFiles.ps1

$projectName = Prompt-ProjectName -promptMessage "Enter the Web API project name"

# Create project directory, solution, directories, add projects to solution.
Write-ProjectDirectory -projectName $projectName
Write-Solution -projectName $projectName
Write-Directories -projectName $projectName
Write-Projects -projectName $projectName
Add-ProjectsToSolution -projectName $projectName

# Install NuGet packages, and restore NuGet packages
Install-NuGetPackages -projectName $projectName
Restore-NuGetPackages -projectName $projectName

# Create core files
Write-CoreFiles -projectName $projectName

# Init Git and add migration
Add-Git
Add-MigrationAndUpdateDatabase -projectName $projectName
Start-Project