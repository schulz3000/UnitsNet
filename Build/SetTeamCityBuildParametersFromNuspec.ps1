try {

[ xml ]$nuspecXml = Get-Content -Path UnitsNet.nuspec

# Split "1.2.3-alpha" into ["1.2.3", "alpha"]
# Split "1.2.3" into ["1.2.3"]
$semVerVersionParts = $nuspecXml.package.metadata.version.Split('-')
$currentVersion = [Version]::Parse($semVerVersionParts[0])
$postfix = if ($semVerVersionParts.Length -eq 2) { "-" + $semVerVersionParts[1]} else { "" }

$major = $currentVersion.Major
$minor = $currentVersion.Minor
$patch = $currentVersion.Build
$newBuildNumber = "$major.$minor.$patch"+"$postfix"

Write-Host "##teamcity[setParameter name='MajorVersion' value='$major']"
Write-Host "##teamcity[setParameter name='MinorVersion' value='$minor']"
Write-Host "##teamcity[setParameter name='PatchVersion' value='$patch']"
Write-Host "##teamcity[setParameter name='SemVerPostfix' value='$postfix']"
Write-Host "##teamcity[buildNumber '$newBuildNumber']"

}
catch {
	$myError = $error[0]
    Write-Error "##teamcity[buildStatus status='ERROR: Failed to update build parameters from .nuspec file: `n$myError' ]"
    exit 1
}