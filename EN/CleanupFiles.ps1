# ====================================================================================
# SCRIPT: CleanupFiles.ps1
# PURPOSE: Delete old files from specified folders on Windows servers
# CONFIGURATION: Uses parameters defined in a config.json file
# ====================================================================================

# Get the path to the config.json file in the same folder as the script
$configPath = Join-Path $PSScriptRoot "config.json"

# Check if the config file exists
if (!(Test-Path $configPath)) {
    Write-Error "Configuration file not found: $configPath"
    exit 1
}

# Load and parse the JSON config into a PowerShell object
$config = Get-Content $configPath -Raw | ConvertFrom-Json

# Directory to save logs (defined in config.json)
$LogDir = $config.LogDirectory

# Create the log directory if it doesn't exist
if (!(Test-Path $LogDir)) {
    New-Item -Path $LogDir -ItemType Directory | Out-Null
}

# Generate the log file with today's date
$LogFile = Join-Path $LogDir ("Cleanup_" + (Get-Date -Format "yyyy-MM-dd") + ".log")

# Function to write log entries with a timestamp
function Write-Log {
    param([string]$Text)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "$timestamp - $Text"
}

# Main function to clean up old files in a specified folder
function Cleanup-Folder {
    param (
        [string]$Path,               # Path to clean
        [int]$KeepDays,             # Number of days to retain
        [bool]$DryRun,              # Simulation mode or real deletion
        [string[]]$ExcludeFolders   # Optional: folders to exclude
    )

    if (!(Test-Path $Path)) {
        Write-Log "Path not found: $Path"
        return
    }

    $BeforeDate = (Get-Date).AddDays(-$KeepDays)
    Write-Log "---- Cleaning: $Path (keeping last $KeepDays days, before $BeforeDate) ----"

    # Get old files, excluding those in excluded folders
    $files = Get-ChildItem -Path $Path -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object {
        $_.LastWriteTime -lt $BeforeDate -and
        ($null -eq $ExcludeFolders -or ($ExcludeFolders -notcontains $_.Directory.Name))
    }

    foreach ($file in $files) {
        if ($DryRun) {
            # Simulation mode: only show what would be deleted
            Write-Log ('[SIMULATION] Would delete: ' + $file.FullName)
        } else {
            try {
                Remove-Item $file.FullName -Force
                Write-Log ('[DELETED] ' + $file.FullName)
            } catch {
                Write-Log ('[ERROR] ' + $file.FullName + ' - ' + $_.Exception.Message)
            }
        }
    }
}

# Function to clean old logs in the log directory
function Cleanup-Logs {
    param (
        [string]$LogDir,
        [int]$KeepDays
    )

    $BeforeDate = (Get-Date).AddDays(-$KeepDays)

    # Get log files older than threshold
    $logs = Get-ChildItem -Path $LogDir -File -Force -ErrorAction SilentlyContinue | Where-Object {
        $_.LastWriteTime -lt $BeforeDate
    }

    foreach ($log in $logs) {
        try {
            Remove-Item $log.FullName -Force
            Write-Log ('[DELETED LOG] ' + $log.FullName)
        } catch {
            Write-Log ('[ERROR LOG] ' + $log.FullName + ' - ' + $_.Exception.Message)
        }
    }
}

# =====================================
# START EXECUTION
# =====================================
Write-Log "===== CLEANUP STARTED ====="

# Run the cleanup process for each job in config.json
foreach ($job in $config.Jobs) {
    Cleanup-Folder -Path $job.Path -KeepDays $job.KeepDays -DryRun $config.DryRun -ExcludeFolders $job.ExcludeFolders
}

# Clean up old log files (older than 1 year)
Cleanup-Logs -LogDir $LogDir -KeepDays 365

Write-Log "===== CLEANUP COMPLETED ====="
