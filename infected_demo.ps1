$rutaCSV = Join-Path $PSScriptRoot "../data/ghost_hosts.csv"
$amenaces = Import-Csv -Path $rutaCSV

foreach ($amenaca in $amenaces) {
    Write-Output (
        "[SIMULACION] Aislar equipo {0} | IP: {1} | Puerto: {2}" -f
        $amenaca.Hostname,
        $amenaca.IP,
        $amenaca.Port_Infectat
    )
}