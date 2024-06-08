. .\CoreFunctions.ps1
. .\Write-CoreFiles.ps1

$projectName = Get-ProjectName -promptMessage "Enter the Web API project name"
$templateDir = ".\templates\core_templates"


# Write project directories, solution, and projects
Write-ProjectDirectory -projectName $projectName
Write-Solution -projectName $projectName
Write-Projects -projectName $projectName

# Add projects to the solution
Add-ProjectsToSolution -projectName $projectName
# Write directories
Write-Directories -projectName $projectName
# Write core files using templates
Write-CoreFiles -projectName $projectName -templateDir $templateDir

# Install NuGet packages, and restore NuGet packages
Install-NuGetPackages -projectName $projectName
Restore-NuGetPackages -projectName $projectName

# Show success message
Write-Host "Project setup complete. Now migrate the database and run the project."

# Init Git and add migration
Add-Git
Add-MigrationAndUpdateDatabase -projectName $projectName

# Start the project
Start-Project