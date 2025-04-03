# Limpieza de Archivos en Servidores Windows

Este repositorio contiene una plantilla de script PowerShell para realizar limpieza automática de archivos antiguos en servidores Windows.

## 🧩 ¿Qué hace este script?

- Borra archivos antiguos según los días configurados
- Permite excluir carpetas específicas
- Crea un log diario con todo lo que hace
- Permite ejecutar en **modo simulación** o borrado real
- También elimina los logs antiguos (más de 1 año)

---

## 📁 Archivos incluidos

- `LimpiarFicheros.ps1`: Script PowerShell comentado y reutilizable
- `config.json`: Plantilla de configuración editable
- `README.md`: Esta documentación
- `LICENSE`: Licencia MIT

---

## ⚙️ Cómo usar

1. Copia los archivos a la ruta deseada (ej: `C:\Scripts`)
2. Modifica el `config.json` con las rutas que quieras limpiar
3. Ejecuta PowerShell como administrador y lanza:

```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\Scripts\LimpiarFicheros.ps1"
```

4. Revisa los logs generados en la carpeta definida (ej: `C:\LogsLimpieza`)

---

## 🔧 Personalización

- **Añadir nuevas rutas**: edita el array `Jobs` en `config.json`
- **Excluir carpetas dentro de una ruta**: usa `"ExcludeFolders"`
- **Modo simulación**: `"DryRun": true`
- **Borrado real**: `"DryRun": false`

### 📝 Ejemplo de bloque en `config.json`:

```json
{
  "Path": "C:\MiRuta\A_Limpiar",
  "KeepDays": 90,
  "ExcludeFolders": ["Importante", "NoBorrar"]
}
```

---

## 📄 Licencia

Este proyecto se publica bajo la licencia MIT. Puedes usarlo y adaptarlo libremente.
