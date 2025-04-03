# Cleanup Script for Windows Servers

This repository contains a PowerShell script template to automatically clean up old files on Windows servers.

## 🧩 What does this script do?

- Deletes old files based on configurable retention days
- Allows excluding specific folders
- Creates a daily log of all actions performed
- Supports **simulation mode** (no deletion) and real cleanup
- Automatically deletes old log files (older than 1 year)

---

## 📁 Included files

- `LimpiarFicheros.ps1`: Reusable and well-commented PowerShell script
- `config.json`: Editable configuration template
- `README.md`: This documentation (English version)
- `LICENSE`: MIT License

---

## ⚙️ How to use

1. Copy the files to your target path (e.g. `C:\Scripts`)
2. Edit `config.json` to define the folders you want to clean
3. Run PowerShell as Administrator and execute:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\LimpiarFicheros.ps1"
```

4. Review the logs in the folder defined in `LogDirectory` (e.g. `C:\LogsLimpieza`)

---

## 🔧 Customization

- **Add new folders**: add items in the `Jobs` array in `config.json`
- **Exclude subfolders**: use `"ExcludeFolders"` in a job
- **Simulation mode**: `"DryRun": true`
- **Real cleanup**: `"DryRun": false`

### 📝 Example block in `config.json`:

```json
{
  "Path": "C:\MyFolder\ToClean",
  "KeepDays": 90,
  "ExcludeFolders": ["Important", "DoNotDelete"]
}
```

---

## 📄 License

This project is released under the MIT License. You are free to use and adapt it.
