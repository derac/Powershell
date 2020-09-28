<#
   I run this from Task scheduler

        Policy for IAM user
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Sid" : "AllowPublicHostedZonePermissions",
         "Effect": "Allow",
         "Action": [
            "route53:CreateHostedZone",
            "route53:UpdateHostedZoneComment",
            "route53:GetHostedZone",
            "route53:ListHostedZones",
            "route53:ChangeResourceRecordSets",
            "route53:ListResourceRecordSets",
            "route53:ListHostedZonesByName"
         ],
         "Resource": "*"
      }
   ]
}

    Installing AWS tools for powershell - https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up-windows.html
    Specifying AWS creds - https://docs.aws.amazon.com/powershell/latest/userguide/specifying-your-aws-credentials.html

    This will be stored in plaintext.
Set-AWSCredential `
                 -AccessKey AKIA0123456787EXAMPLE `
                 -SecretKey wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY `
                 -StoreAs MyNewProfile
#>

param (
    [Parameter(Mandatory)]
    [string]$zone_name,
    [string]$profile_name = 'default'
)

Set-AWSCredential -ProfileName $profile_name

$hosted_zone = (Get-R53HostedZoneList | where Name -eq $zone_name).Id
$resource_record_set = (Get-R53ResourceRecordSet -hostedzoneid $hosted_zone -StartRecordName $zone_name -StartRecordType A).ResourceRecordSets | where Type -eq A
$my_ip = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip

# Exit if current IP is already set
if ($resource_record_set.ResourceRecords.Value -eq $my_ip) { exit }

# Modify old record
$resource_record_set.ResourceRecords = New-Object Amazon.Route53.Model.ResourceRecord ($my_ip)

# Change record
$change = New-Object Amazon.Route53.Model.Change ([Amazon.Route53.ChangeAction]::UPSERT, $resource_record_set)
try { Edit-R53ResourceRecordSet -HostedZoneId $hosted_zone -ChangeBatch_Change $change -ChangeBatch_Comment 'Edited by dyndns script' }
catch { Write-Error "Could not update recordset" }