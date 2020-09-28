# Powershell-stuff

Some scripts that I have made. Not maintained, so read the source!

- Install-Update-Sysinternals.ps1 - Downloads the latest sysinternals.zip, unzips to C:\Program Files\Sysinternals by default and adds it to the path if it isn't there

- Parse-Youtube-from-Facebook.ps1 - Point it at an HTML file from someone's wall and it will spit out a youtube playlist of the links. Autoscroll stub in comments.

- Set-AWSR53-DynDNS.ps1 - Updates AWS53 hosted zone A record to the public IP of the computer running it. Made to be run as a scheduled task. Comments detail how to set up creds with IAM.