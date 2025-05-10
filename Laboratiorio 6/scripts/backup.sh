#!/bin/bash
if [ -z "$1" ]; then
  echo "Por favor, proporciona un directorio para respaldar."
  exit 1
fi
if [ ! -d "$1" ]; then
  echo "El directorio $1 no existe."
  exit 1
fi
fecha=$(date +"%Y-%m-%d_%H-%M-%S")
directorio=$(basename "$1")
archivo_respaldo=~/laboratorio/respaldo/"$directorio"_"$fecha".tar.gz

tar -czf "$archivo_respaldo" -C "$1" .
if [ $? -eq 0 ]; then
  echo "Respaldo creado con éxito: $archivo_respaldo"
  echo "Tamaño del archivo: $(du -sh "$archivo_respaldo" | cut -f1)"
else
  echo "Hubo un error al crear el respaldo."
  exit 1
fi
