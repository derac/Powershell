param (
    [string]$installpath = "C:\Program Files\Sysinternals"
)

$zippath = "$PSScriptRoot\SysinternalsSuite.zip"

$ErrorActionPreference = "stop"

# If the SysinternalsSuite.zip file is not in this directory, try to download it
if (![System.IO.File]::Exists($zippath)) {
    try {
        (New-Object System.Net.WebClient).DownloadFile("https://download.sysinternals.com/files/SysinternalsSuite.zip", $zippath)
    } catch {
        Write-Error "Downloading https://download.sysinternals.com/files/SysinternalsSuite.zip did not work, please download the file manually and put it in the same directory as this script"
        
    }
}

# Create C:\Program Files\Sysinternals
New-Item -Path $installpath -ItemType Directory

# Extract Zip file to C:\Program Files\Sysinternals
Add-Type -Assembly System.IO.Compression.FileSystem
[io.compression.zipfile]::ExtractToDirectory($zippath, $installpath)

# Add the install location to the PATH
if (-not ($env:Path -like "*$installpath*")) {
    [Environment]::SetEnvironmentVariable("Path",$env:Path + ";$installpath","Process")
}