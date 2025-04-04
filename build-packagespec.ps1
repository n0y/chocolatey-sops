$Props = convertfrom-stringdata (get-content versions.properties | Select-String -pattern "^#" -NotMatch)
$SopsVersion = $Props.UPSTREAM_VERSION
"Building Upstream Version: $SopsVersion"
""

$ChecksumResponse = Invoke-WebRequest -Uri "https://github.com/getsops/sops/releases/download/v$SopsVersion/sops-v$SopsVersion.checksums.txt"
$SopsChecksum = (($ChecksumResponse.tostring() -split "[`r`n]" | Select-String "sops-v$SopsVersion.amd64.exe" | select -First 1) -split " ")[0].ToUpper()

"Discovered Checksum: $SopsChecksum"

if (Test-Path -LiteralPath .\target) {
    Remove-Item -LiteralPath .\target -Recurse
}
New-Item -ItemType Directory -Force -Path .\target\tools | Out-Null

(Get-Content .\src\tools\chocolateyinstall.template.ps1) -replace '%%VERSION%%', $SopsVersion -replace '%%CHECKSUM%%', $SopsChecksum | Out-File -Encoding utf8 ".\target\tools\chocolateyinstall.ps1"
(Get-Content .\src\sops.template.nuspec) -replace '%%VERSION%%', $SopsVersion -replace '%%CHECKSUM%%', $SopsChecksum | Out-File -Encoding utf8 ".\target\sops.nuspec"

