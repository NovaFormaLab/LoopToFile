# 📺 LoopToFile
![Estado](https://img.shields.io/badge/Estado-En%20Desarrollo-FFD6A5)
![Versión](https://img.shields.io/badge/Versión-v0\.1\.0-FDFFB6)
![Licencia](https://img.shields.io/badge/Licencia-GPL--3\.0-CAFFBF)
![Lua](https://img.shields.io/badge/lua-Script-BDB2FF)
![Desarrollado](https://img.shields.io/badge/Desarrollado-@coiapy%20en%20NovaFormaLab-ffc0cb)<br><br>
Script funcional para mpv que permite generar loops de reproduccion y extraer fragmentos multimedia en nuevos archivos. <br>file.ext → ...[..]. → l∞p → file.ext

[mpv](https://mpv.io/) (media player) [https://github.com/mpv-player/mpv](https://github.com/mpv-player/mpv)

## 🎬 Info
Alternar la repeticion o no entera del archivo completo, crear loops de repeticion de un rango preciso de tiempo (puedes ayudarte de . y ,), ver tiempo (frame) en milisegundos, ver tiempo de loop seleccionado, comprobar si ffmpeg está accesible desde mpv y crear un archivo nuevo (con la misma extension y formato) en el mismo directorio.

## 🛠️ Instalación
1. Descarga loop.zip y extrae loop-tools.lua
2. Crea carpeta scripts dentro de mpv (si no existe) en:<br>
	`home/user/.config/mpv/` o `~/.config/mpv/`
3. Pega en loop-tools.lua dentro de scripts:<br>
	`~/.config/mpv/scripts/loop-tools.lua` o
	`/home/user/.config/mpv/scripts/loop-tools.lua`

## 📦 Requerimientos/Dependencias
1.   [ffmpeg](https://ffmpeg.org/)
## 🚀 Uso
1. Situate en la linea de tiempo donde quieres que comience el loop (puedes ayudarte de . y ,) 
2. Pulsa `Meta+Alt+i` para definir el inicio, 
3. Desplazate en la linea de tiempo hasta donde quieres el final del loop
4. Pulsa `Meta+Alt+o` (si omites este paso se asigna un intervalo por defecto de 20 segundos)
5. Pulsa `Meta+Alt+x` para crear el nuevo archivo con tu intervalo

## ⚙️ ShortCut / Comandos

| ShortCut        | Action                                                            |
| --------------- | ----------------------------------------------------------------- |
| meta + alt + l  | Alternates repeating the entire file infinitely  (by default off) |
| meta + alt + i  | Start loop                                                        |
| meta + alt + o  | End loop                                                          |
| meta + alt + c  | Cancel loop                                                       |
| meta  + alt + t | Display time with milliseconds                                    |
| meta + alt + u  | Show loop times                                                   |
| meta + alt + z  | Create '.loop' file with info                                     |
| meta + alt + f  | Check if ffmpeg is installed                                      |
| meta + alt + x  | Create row with clipping                                          |
