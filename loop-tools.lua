-- ~/.config/mpv/scripts/loop-tools.lua

local loop_start = nil
local loop_end = nil
local looping = false
local video_path = mp.get_property("path")

local function toggle_loop_file()
    local current = mp.get_property("loop-file")

    if current == "inf" then
        mp.set_property("loop-file", "no")
        mp.osd_message("loop-file: OFF")
    else
        mp.set_property("loop-file", "inf")
        mp.osd_message("loop-file: ON")
    end
end

function check_ffmpeg_installed()
    local utils = require 'mp.utils'
    
    -- Intenta ejecutar el comando 'ffmpeg -version'
    local result = utils.subprocess({
        args = {'ffmpeg', '-version'},
        cancellable = false,
    })
    
    -- Comprueba si el comando se ejecutó correctamente
    if result.status == 0 then
        -- FFmpeg está instalado
        mp.osd_message(string.match(result.stdout, "[^-]+"), 5)
        return true
    else
        -- FFmpeg no está instalado o no está en el PATH
        mp.osd_message("FFmpeg is not installed")
        return false
    end
end

local function cut_video_from_loops(video_path)
    -- Obtener carpeta del video
    local dir = video_path:match("(.*/)")
    local file_path = dir .. ".loop"

    -- Leer el archivo .file
    local file = io.open(file_path, "r")
    if not file then
        print("Error: No se pudo abrir el archivo: " .. file_path)
        return
    end

    local loop_start = tonumber(file:read("*l"))
    local loop_end = tonumber(file:read("*l"))
    local stored_video_path = file:read("*l")
    file:close()

    -- Validaciones
    if not (loop_start and loop_end and stored_video_path) then
        print("Error: Datos inválidos en el archivo .loop")
        return
    end

    if stored_video_path ~= video_path then
        print("Advertencia: La ruta del video en .loop no coincide con la actual")
    end

    if loop_start >= loop_end then
        print("Error: loop_start debe ser menor que loop_end")
        return
    end

    -- Obtener la extensión del archivo original (ej. ".mp4")
    local extension = video_path:match("^.+(%..+)$")

    -- Obtener el nombre base sin la carpeta ni la extensión
    local base_name = video_path:match("^.+/(.+)%..+$")

    -- Obtener la carpeta
    local dir = video_path:match("(.+)/")

    -- Obtener la fecha y hora actual
    local datetime = os.date("%Y%m%d_%H%M%S")

    -- Construir nombre final: mismo nombre base + fecha + extensión
    local output_path = string.format("%s/%s_%s%s", dir, base_name, datetime, extension)

    -- Comando ffmpeg
    local cmd = string.format(
        'ffmpeg -i "%s" -ss %.3f -to %.3f -c copy "%s"',
        video_path, loop_start, loop_end, output_path
    )

    print("Ejecutando:", cmd)
    os.execute(cmd)
end

local function write_loop_file()
    if loop_start ~= nil and loop_end ~= nil then
        -- Obter a ruta do arquivo que se está reproducindo
        local video_path = mp.get_property("path")
        
        -- Si non hai video cargado, sair
        if not video_path then
            mp.osd_message("There is no file playing")
            return
        end
        
        -- Extrae path do arquivo
        local video_dir = ""
        if string.find(video_path, "/") then
            -- Para rutas estilo Unix/Mac
            video_dir = string.match(video_path, "(.+)/[^/]*$")
        elseif string.find(video_path, "\\") then
            -- Para rutas estilo Windows
            video_dir = string.match(video_path, "(.+)\\[^\\]*$")
        else
            -- Si no hay separador de dir, usar dir actual
            video_dir = "."
        end
        
        -- Crea a ruta completa para 'loop'
        local loop_file_path = video_dir .. (video_dir == "." and "" or "/") .. ".loop"
        
        -- Abre arquivo para escritura (modo 'w' sobreescribe si existe)
        local file, err = io.open(loop_file_path, "w")
        if not file then
            mp.osd_message("Error creating file: " .. (err or "undefined"))
            return
        end
        
        -- Escribir os valores no arquivo
        file:write(tostring(loop_start) .. "\n")
        file:write(tostring(loop_end) .. "\n")
        file:write(tostring(video_path) .. "\n")
        file:close()
        
        -- mp.osd_message("loop saved in .loop")
    end
end

mp.add_key_binding("Meta+Alt+l", "toggle-loop-file", toggle_loop_file)


mp.add_key_binding("Meta+Alt+i", "set-loop-start", function()
    loop_start = mp.get_property_number("time-pos")
    if loop_end == nil then
        loop_end = loop_start + 20
    end
    mp.osd_message(string.format("Start loop: %.3f", loop_start))
end)

mp.add_key_binding("Meta+Alt+o", "set-loop-end", function()
    loop_end = mp.get_property_number("time-pos")
    if loop_start and loop_end and loop_end > loop_start then
        mp.osd_message(string.format("Loop: %.3f  →  %.3f", loop_start, loop_end))
        looping = true
    else
        mp.osd_message("Select start first (meta + i), then end (meta + o)")
    end
end)

mp.add_key_binding("Meta+Alt+c", "cancel-loop", function()
    loop_start = nil
    loop_end = nil
    looping = false
    mp.osd_message("Cancel loop")
end)

mp.add_key_binding("Meta+Alt+t", "show-time-ms", function()
    local time = mp.get_property_native("time-pos")
    if time then
        local ms = math.floor((time % 1) * 1000)
        local total = os.date("!%H:%M:%S", time)
        mp.osd_message(string.format("Time: %s.%03d", total, ms), 5)
    end
end)

mp.add_key_binding("Meta+Alt+u", "imprime-loop", function()
    
    local mensaje = ""
    
    if loop_start ~= nil and loop_end ~= nil then
        mensaje = string.format("Loop: Start= %.2f, End= %.2f", loop_start, loop_end)
    elseif loop_start ~= nil then
        mensaje = string.format("Loop: Start= %.2f, End= undefined", loop_start)
    elseif loop_end ~= nil then
        mensaje = string.format("Loop: Start= undefined, End= %.2f", loop_end)
    else
        mensaje = "Undefined loop"
    end
    
    mp.osd_message(mensaje)
end)

mp.add_key_binding("Meta+Alt+z", "write-loop", function()
    if loop_start ~= nil and loop_end ~= nil then
        -- Obter a ruta do arquivo que se está reproducindo
        local video_path = mp.get_property("path")
        
        -- Si non hai video cargado, sair
        if not video_path then
            mp.osd_message("There is no file playing")
            return
        end
        
        -- Extrae path do arquivo
        local video_dir = ""
        if string.find(video_path, "/") then
            -- Para rutas estilo Unix/Mac
            video_dir = string.match(video_path, "(.+)/[^/]*$")
        elseif string.find(video_path, "\\") then
            -- Para rutas estilo Windows
            video_dir = string.match(video_path, "(.+)\\[^\\]*$")
        else
            -- Si no hay separador de dir, usar dir actual
            video_dir = "."
        end
        
        -- Crea a ruta completa para 'loop'
        local loop_file_path = video_dir .. (video_dir == "." and "" or "/") .. ".loop"
        
        -- Abre arquivo para escritura (modo 'w' sobreescribe si existe)
        local file, err = io.open(loop_file_path, "w")
        if not file then
            mp.osd_message("Error creating file: " .. (err or "undefined"))
            return
        end
        
        -- Escribir os valores no arquivo
        file:write(tostring(loop_start) .. "\n")
        file:write(tostring(loop_end) .. "\n")
        file:write(tostring(video_path) .. "\n")
        file:close()
        
        mp.osd_message("loop saved in .loop")

    else
        mp.osd_message("Unable to save: incomplete loop")
    end
end)

mp.add_key_binding("Meta+Alt+f", "check_ffmpeg", check_ffmpeg_installed)


mp.add_key_binding("Meta+Alt+x", "cut-video", function()
  local video_path = mp.get_property("path")
  if video_path then
    mp.osd_message("🧠 Working!! Wait, don't exit MPV!!", 9999)
    write_loop_file()
    cut_video_from_loops(video_path)
    mp.osd_message("✅ End!! video created!!", 4)
  else
    mp.osd_message("❌ Without video", 3)
  end
end)

mp.register_event("tick", function()
    if looping and loop_start and loop_end then
        local pos = mp.get_property_number("time-pos")
        if pos and pos >= loop_end then
            mp.set_property_number("time-pos", loop_start)
        end
    end
end)