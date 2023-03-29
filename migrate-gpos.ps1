param ($Action, $Name)

# This script requires that the GPMC module is installed.
# You can install this using `Install-WindowsFeature GPMC`

$domain = "" # Specify the domain here
$targetPath = "$($PSScriptRoot)\GPOs"
$mappingCSVFile = "$($PSScriptRoot)\mapping.csv"

function Backup-GPOs-From-Domain() {
  mkdir -Force $targetPath -ErrorAction Stop
  "Guid,OldName,NewName" | Out-File -FilePath $mappingCSVFile

  $gpos = Get-GPO -All -Domain $domain

  foreach($gpo in $gpos) {
    if ($Name -and ($gpo.DisplayName -ne $Name)) {
     continue
    }

    $guid = $gpo.Id;
    $displayName = $gpo.DisplayName;

    Write-Host "Backing up $($displayName)..."
    Backup-GPO -Guid $guid -Path $targetPath

    $newName = "MIGRATED - $($displayName)"

    "$($guid),""$($displayName)"",""$($newName)""" | Out-File -FilePath $mappingCSVFile -Append
  }

  Write-Host "Backed up GPOs to $($targetPath)!"
}

function Import-GPOs-To-Domain() {
 $GUIDToNameMap = Import-CSV -Path $mappingCSVFile

 foreach($mapping in $GUIDToNameMap) {
   if ($Name -and ($mapping.OldName -ne $Name)) {
    continue
   }
 
   Write-Host "Importing '$($mapping.NewName)'..."
   Import-GPO -BackupGpoName "$($mapping.OldName)" -TargetName "$($mapping.NewName)" -Path $targetPath -CreateIfNeeded
 }
}


switch($Action) {
  "Import" { Import-GPOs-To-Domain; Break; }
  "Backup" { Backup-GPOs-From-Domain; Break; }
  Default { Write-Host "Invalid action. Please specify either 'Import' or 'Backup' as the first parameter (or using -Action)." }
}