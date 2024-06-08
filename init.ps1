. .\CoreFunctions.ps1
. .\Write-CoreFiles.ps1

$projectName = Get-ProjectName -promptMessage "Enter the Web API project name"
$templateDir = ".\templates\core_templates"


# Create project directory, solution, directories, add projects to solution.
Write-ProjectDirectory -projectName $projectName
Write-Solution -projectName $projectName
Write-Directories -projectName $projectName
Write-Projects -projectName $projectName
Add-ProjectsToSolution -projectName $projectName

# Install NuGet packages, and restore NuGet packages
Install-NuGetPackages -projectName $projectName
Restore-NuGetPackages -projectName $projectName
 
# Write core files using templates
Write-CoreFiles -projectName $projectName -templateDir $templateDir

##Show success message
Write-Host "Project setup complete. Now migrate the database and run the project."

# Init Git and add migration
# Add-Git
# Add-MigrationAndUpdateDatabase -projectName $projectName
# -projectName $projectName
# Start-Project