#!/bin/bash

# Definir directorios de trabajo
directorio_logs="/var/log"
directorio_salida="$HOME/laboratorio/datos/salida"
informe="$directorio_salida/informe_logs.md"

# Verificar si el directorio de salida existe, si no lo crea
mkdir -p "$directorio_salida"

# Obtener la fecha y hora del análisis
fecha=$(date +"%Y-%m-%d %H:%M:%S")

# Buscar los 5 archivos de log más grandes en /var/log
archivos_log=$(find "$directorio_logs" -type f -name "*.log" -exec du -h {} + | sort -rh | head -n 5)

# Inicializar variables para almacenar el archivo con más errores
archivo_mas_errores=""
max_errores=0
errores_archivo_mas_errores=""

# Crear el archivo markdown con los resultados
echo "# Informe de Análisis de Logs" > "$informe"
echo "Fecha y hora del análisis: $fecha" >> "$informe"
echo "" >> "$informe"
echo "Tabla de archivos analizados:" >> "$informe"
echo "| Nombre del Archivo | Tamaño | Número de Errores |" >> "$informe"
echo "| ------------------ | ------ | ----------------- |" >> "$informe"

# Procesar cada archivo y obtener el tamaño y nombre de archivo correctamente
while IFS= read -r archivo; do
    # Extraer el tamaño y el nombre del archivo correctamente
    tamaño_log=$(echo "$archivo" | awk '{print $1}')
    archivo_log=$(echo "$archivo" | awk '{print $2}')
    
    # Contar el número de ocurrencias de "error" (ignorando mayúsculas/minúsculas)
    num_errores=$(grep -i "error" "$archivo_log" | wc -l)

    # Escribir la información en el archivo markdown
    echo "| $archivo_log | $tamaño_log | $num_errores |" >> "$informe"

    # Verificar si este archivo tiene más errores que el anterior
    if [ "$num_errores" -gt "$max_errores" ]; then
        archivo_mas_errores="$archivo_log"
        max_errores=$num_errores
        errores_archivo_mas_errores=$(grep -i "error" "$archivo_log" | tail -n 3)
    fi
done <<< "$archivos_log"

# Agregar la sección de los 3 últimos errores
echo "" >> "$informe"
echo "Los 3 últimos errores en el archivo con más errores ($archivo_mas_errores):" >> "$informe"
echo "$errores_archivo_mas_errores" >> "$informe"

# Mostrar resumen en pantalla
echo "Análisis completado."
echo "Fecha y hora del análisis: $fecha"
echo ""
echo "Tabla de archivos analizados:"
echo "| Nombre del Archivo | Tamaño | Número de Errores |"
echo "| ------------------ | ------ | ----------------- |"
cat "$informe" | grep -E "\| .+ \| .+ \| .+ \|"
echo ""
echo "Los 3 últimos errores en el archivo con más errores ($archivo_mas_errores):"
echo "$errores_archivo_mas_errores"
