# Demander à l'utilisateur le chemin de la source à analyser
$Source = Read-Host "Indiquez le chemin du C:\ de la source à analyser (ex: D:\collect\...)"

IF ($Source -eq ""){$Source = "D:\Collect\Data\z_Collection_machin-domain-local_C-_2021-11-10T09-08-07Z"}
$UsersRoot = $Source + "\uploads\auto\C%3A\users"

$Results = @()

Get-ChildItem -Path $UsersRoot -Directory -ErrorAction SilentlyContinue | ForEach-Object {

    $UserName = $_.Name
    $CachePath = Join-Path $_.FullName "AppData\Local\Microsoft\Terminal Server Client\Cache"

    if (Test-Path $CachePath) {
        $FileCount = (Get-ChildItem -Path $CachePath -File -ErrorAction SilentlyContinue).Count
    }
    else {
        $FileCount = 0
    }

    $Results += [PSCustomObject]@{
        Utilisateur = $UserName
        NbFichiers  = $FileCount
        CachePath   = $CachePath

    }

if ($FileCount -gt 0)
	{
	write-host -fore Green $UserName : $FileCount;
	Write-host -fore Blue "Appuyez sur une touche Ouvrir l'explorer"
	pause
	Start-Process explorer.exe $CachePath
	}
}

# Affichage tableau
$Results | Format-Table -AutoSize

