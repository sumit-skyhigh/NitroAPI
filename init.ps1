. .\Functions.ps1

$projectName = Prompt-ProjectName -promptMessage "Enter the Web API project name"
Create-ProjectDirectory -projectName $projectName
Create-Solution -projectName $projectName
Create-Directories -projectName $projectName
Create-Projects -projectName $projectName
Add-ProjectsToSolution -projectName $projectName
Install-NuGetPackages -projectName $projectName
Restore-NuGetPackages -projectName $projectName
Create-BasicFiles -projectName $projectName
Init-Git
Add-MigrationAndUpdateDatabase -projectName $projectName
Run-Project