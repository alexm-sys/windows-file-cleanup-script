# LimpiarFicheros.ps1

$configPath = Join-Path $PSScriptRoot "config.json"
if (!(Test-Path $configPath)) {
    Write-Error "Archivo de configuración no encontrado: $configPath"
    exit 1
}

$config = Get-Content $configPath -Raw | ConvertFrom-Json
$LogDir = $config.LogDirectory
if (!(Test-Path $LogDir)) {
    New-Item -Path $LogDir -ItemType Directory | Out-Null
}
$LogFile = Join-Path $LogDir ("Limpieza_" + (Get-Date -Format "yyyy-MM-dd") + ".log")

function Escribir-Log {
    param([string]$Texto)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "$timestamp - $Texto"
}

function Limpiar-Carpeta {
    param (
        [string]$Path,
        [int]$KeepDays,
        [bool]$DryRun,
        [string[]]$ExcludeFolders
    )

    if (!(Test-Path $Path)) {
        Escribir-Log "Ruta no encontrada: $Path"
        return
    }

    $BeforeDate = (Get-Date).AddDays(-$KeepDays)
    Escribir-Log "---- Limpieza en: $Path (mantener últimos $KeepDays días, antes de $BeforeDate) ----"

    $archivos = Get-ChildItem -Path $Path -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object {
        $_.LastWriteTime -lt $BeforeDate -and
        ($null -eq $ExcludeFolders -or ($ExcludeFolders -notcontains $_.Directory.Name))
    }

    foreach ($archivo in $archivos) {
        if ($DryRun) {
            Escribir-Log ('[SIMULACIÓN] Eliminaría: ' + $archivo.FullName)
        } else {
            try {
                Remove-Item $archivo.FullName -Force
                Escribir-Log ('[BORRADO] ' + $archivo.FullName)
            } catch {
                Escribir-Log ('[ERROR] ' + $archivo.FullName + ' - ' + $_.Exception.Message)
            }
        }
    }
}

# Limpieza de logs en la carpeta de logs
function Limpiar-Logs {
    param (
        [string]$LogDir,
        [int]$KeepDays
    )

    $BeforeDate = (Get-Date).AddDays(-$KeepDays)

    # Obtiene los archivos de log en el directorio
    $logs = Get-ChildItem -Path $LogDir -File -Force -ErrorAction SilentlyContinue | Where-Object {
        $_.LastWriteTime -lt $BeforeDate
    }

    foreach ($log in $logs) {
        try {
            Remove-Item $log.FullName -Force
            Escribir-Log ('[BORRADO LOG] ' + $log.FullName)
        } catch {
            Escribir-Log ('[ERROR LOG] ' + $log.FullName + ' - ' + $_.Exception.Message)
        }
    }
}

# Llamar a la función de limpieza de logs después de procesar las carpetas
Escribir-Log "===== INICIO DE LIMPIEZA ====="
foreach ($job in $config.Jobs) {
    Limpiar-Carpeta -Path $job.Path -KeepDays $job.KeepDays -DryRun $config.DryRun -ExcludeFolders $job.ExcludeFolders
}

# Limpiar los logs en la carpeta de logs
Limpiar-Logs -LogDir "C:\LogsLimpieza" -KeepDays 365

Escribir-Log "===== FIN DE LIMPIEZA ====="
