# 🧹 Limpieza automática de archivos en servidores Windows / Windows File Cleanup Script

Este repositorio contiene una plantilla de script PowerShell para automatizar la eliminación de archivos antiguos en servidores Windows.  
This repository contains a PowerShell script template to automate old file cleanup on Windows servers.

---


## 📋 Características / Features

- 🕐 Elimina archivos según la antigüedad configurada / Deletes files based on configurable retention days  
- 📂 Permite excluir carpetas / Allows excluding specific folders  
- 🧪 Modo simulación disponible / Simulation mode available  
- 📜 Crea logs de la limpieza / Generates daily cleanup logs  
- 🔁 Elimina también logs antiguos (más de 1 año) / Also deletes logs older than 1 year  
- 🌐 Disponible en español e inglés / Available in Spanish and English

---

## 🛠️ ¿Cómo usarlo? / How to use

### 1. Copia los archivos / Copy the files

```plaintext
📁 /Scripts/
│   ├── LimpiarFicheros.ps1      ← Español / Spanish
│   ├── CleanupFiles.ps1         ← Inglés / English
│   └── config.json              ← Archivo de configuración / Configuration file
```

### 2. Edita `config.json`

```json
{
  "Jobs": [
    {
      "Path": "C:\Ruta\AEvaluar",
      "KeepDays": 30,
      "ExcludeFolders": ["Importante"]
    }
  ],
  "DryRun": true,
  "LogDirectory": "C:\LogsLimpieza"
}
```

- `"DryRun": true` = solo simula, no borra  
- `"DryRun": false` = realiza el borrado real

### 3. Ejecutar / Run manually

```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\LimpiarFicheros.ps1"
```

---

## 🧩 Archivos incluidos / Included files

| Español (ES)         | Inglés (EN)         |
|----------------------|---------------------|
| `LimpiarFicheros.ps1`| `CleanupFiles.ps1`  |
| `config.json`        | `config.json`       |
| `README.md`          | `README_EN.md`      |
| `LICENSE`            | `LICENSE`           |

---

## 🧪 Ejemplo de ejecución / Example Output

```plaintext
2025-04-02 08:29:32 - ===== INICIO DE LIMPIEZA =====
2025-04-02 08:29:32 - Ruta: C:\Users\...\Prueba
2025-04-02 08:29:32 - [SIMULACIÓN] Eliminaría: ...\archivo.log
...
2025-04-02 08:29:32 - ===== FIN DE LIMPIEZA =====
```

```plaintext
2025-04-02 08:29:32 - ===== CLEANUP STARTED =====
2025-04-02 08:29:32 - Path: C:\Users\...\Test
2025-04-02 08:29:32 - [SIMULATION] Would delete: ...\file.log
...
2025-04-02 08:29:32 - ===== CLEANUP COMPLETED =====
```

---

## 🪪 Licencia / License

Este proyecto se publica bajo licencia MIT.  
This project is released under the MIT License.

---

## 🤝 Contribuciones / Contributions

Pull requests bienvenidos. Traducciones o mejoras también.  
Pull requests welcome. Translations or improvements appreciated.
