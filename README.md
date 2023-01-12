# Migrate GPOs to other domains
_Simple powershell command to backup GPOs from one domain and then migrate them to another, whilst prepending the target GPO names with "MIGRATED - "._


## Usage
- Copy the `ps1` file from this project to your origin DC, or a machine that is joined to your origin domain.
- Edit the `ps1` file to include the source/origin domain name. e.g.
```
$domain = "mydomain.tld"
```
- Run the `ps1` file with the `Backup` argument. e.g.
```
.\migrate-gpos.ps1 Backup
```
- This will create a folder called "GPOs" in the same directory as the `ps1` file, along with a `mapping.csv` file, which will contain the GPO name mappings.
- Copy the `GPOs` folder, the `mapping.csv` file and the `ps1` script file to the destination DC, or a machine that is joined to your destination domain.
- Run the `ps1` file with the `Import` argument. e.g.
```
.\migrate-gpos.ps1 Import
```
- Open Group Policy Management and link these policies to the necessary containers.
