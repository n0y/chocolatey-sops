$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  PackageName    = 'sops'
  Url64bit       = 'https://github.com/mozilla/sops/releases/download/v%%VERSION%%/sops-v%%VERSION%%.amd64.exe'
  Checksum64     = '%%CHECKSUM%%'
  ChecksumType64 = 'sha256'
  FileFullPath   = "$toolsDir\sops.exe"
}

Get-ChocolateyWebFile @packageArgs
