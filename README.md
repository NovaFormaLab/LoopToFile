---
lang: es
---

# 📺 LoopToFile
![Estado](https://img.shields.io/badge/Estado-En%20Desarrollo-FFD6A5)
![Versión](https://img.shields.io/badge/Versión-v0\.1\.0-FDFFB6)
![Licencia](https://img.shields.io/badge/Licencia-GPL--3\.0-CAFFBF)
![Lua](https://img.shields.io/badge/Lua-Script-BDB2FF)
![Desarrollado](https://img.shields.io/badge/Desarrollado-@coiapy%20en%20NovaFormaLab-ffc0cb)<br><br>
**L∞pToFile** es un script funcional para **mpv** que permite generar loops de reproduccion y extraer fragmentos multimedia en nuevos archivos. <br>file.ext → ...[..]. → l∞p → file.ext<br><br>
[User Scripts](https://github.com/mpv-player/mpv/wiki/User-Scripts)<br>
[mpv](https://mpv.io/) (media player)<br> 
[github](https://github.com/mpv-player/mpv)<br>

## 🎬 Info
Puede alternar (repetir/no repetir) archivo completo, crear loops de repetición de un rango preciso de tiempo (puedes ayudarte de . y ,), ver tiempo (frame) en milisegundos y ajustar, ver tiempo de loop seleccionado, comprobar si ffmpeg está accesible desde mpv y crear un archivo nuevo (con la misma extension y formato) en el mismo directorio.

## 🛠️ Instalación
1. Descarga en [LoopToFile-main.zip](https://github.com/NovaFormaLab/LoopToFile/archive/refs/heads/main.zip) y extrae loop-tools.lua
2. Crea carpeta scripts dentro de mpv (si no existe) en:<br>
	`home/user/.config/mpv/` o `~/.config/mpv/`
3. Pega en loop-tools.lua dentro de scripts:<br>
	`~/.config/mpv/scripts/loop-tools.lua` o
	`/home/user/.config/mpv/scripts/loop-tools.lua`

## 📦 Requerimientos/Dependencias
1.   [ffmpeg](https://ffmpeg.org/)
## 🚀 Uso
1. Situate en la linea de tiempo donde quieres que comience el loop (puedes ayudarte de . y ,). 
2. Pulsa `Meta+Alt+i` para definir el inicio. 
3. Desplazate en la linea de tiempo hasta donde quieres el final del loop.
4. Pulsa `Meta+Alt+o` (si omites este paso \[3y4\]se asigna un intervalo por defecto de 20 segundos).
5. Pulsa `Meta+Alt+x` para crear el nuevo archivo con tu intervalo.
6. Busca el nuevo archivo en la carpeta del que estes reproduciendo.

## ⚙️ ShortCut / Comandos

| ShortCut        | Acción                                                            |
| --------------- | ----------------------------------------------------------------- |
| meta + alt + l  | Alterna repeticion infinita/no del archivo completo (defecto off) |
| meta + alt + i  | Establecer inicio de loop                                         |
| meta + alt + o  | Establecer final de loop                                          |
| meta + alt + c  | Cancelar loop                                                     |
| meta  + alt + t | Ver tiempo en milisegundos                                        |
| meta + alt + u  | Ver tiempos de loop                                               |
| meta + alt + z  | Crear archivo '.loop' con info del loop                           |
| meta + alt + f  | Comprobar si ffmpeg está instalado                                |
| meta + alt + x  | Crear nuevo archivo con el loop activo                            |
