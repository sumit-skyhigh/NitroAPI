# MIT License
# Copyright (c) 2024 Sumit Chakrabarty
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


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