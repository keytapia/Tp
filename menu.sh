# Tp 1 de introducción 

# !/bin/bash

export FILENAME="FILENAME"

export RUTA_A_EPN1="$HOME/EPNro1"
export ARCHIVO="$RUTA_A_EPN1/salida/$FILENAME.txt"

seguir=1
proceso_activo=0


if [ "$1" = "-d" ]; then
    	echo "Matando proceso consolidar.sh..."
    	pkill -f "consolidar.sh"

    	echo "Eliminando entorno..."
    	rm -r "$RUTA_A_EPN1"

    	echo "Entorno eliminado correctamente."
    	exit 0
fi

crear_consolidar() {
	touch "$RUTA_A_EPN1/consolidar.sh"
	cat > "$RUTA_A_EPN1/consolidar.sh" << 'EOF'
#!/bin/bash

RUTA_A_EPN1="$HOME/EPNro1"
FILENAME="FILENAME"
ARCHIVO="$RUTA_A_EPN1/salida/$FILENAME.txt"

while true; do
	for archivo in "$RUTA_A_EPN1/entrada"/*.txt; do
      	if [[ -f "$archivo" ]]; then
            	cat "$archivo" >> "$ARCHIVO"
            	mv "$archivo" "$RUTA_A_EPN1/procesado/"
        	fi
    	done
    sleep 5
done
EOF
}

crear_entorno() {

	mkdir -p "$RUTA_A_EPN1" "$RUTA_A_EPN1/entrada" "$RUTA_A_EPN1/salida" "$RUTA_A_EPN1/procesado"

	echo "Creando archivo de salida."
	touch "$ARCHIVO"

	crear_consolidar

	echo "Entorno creado correctamente. Antes de correr el proceso agregue los archivos deseados a la carpeta 'entrada'."

}

correr_proceso() {

	for dir in "$RUTA_A_EPN1" "$RUTA_A_EPN1/entrada" "$RUTA_A_EPN1/salida" "$RUTA_A_EPN1/procesado"; do
        	if [[ ! -d "$dir" ]]; then
            	echo "Error: el directorio no existe."
                echo "Cree el entorno primero (opción 1)."
           		return
        	fi
    	done

	if [ $proceso_activo -eq 1 ]; then
		echo "El proceso ya está corriendo."
		return
  	fi

	bash "$RUTA_A_EPN1/consolidar.sh" &
	proceso_activo=1

	echo "Proceso iniciado. "
}

listar_alumnos() {

	if [ -f "$ARCHIVO" ]; then
		echo "Listado ordenado por padrón: "
		sort -n -k1 "$ARCHIVO"
	else
		echo "El archivo no existe."
	fi
}

top_notas() {

	if [ -f "$ARCHIVO" ]; then
		echo "Diez notas más altas."
		sort -k5 -nr "$ARCHIVO" | head
  	else
    		echo "El archivo no existe."
  	fi

}

buscar_padron() {

	if [ -f "$ARCHIVO" ]; then
    		read -p "Ingrese padrón: " padron
    		grep "^$padron" "$ARCHIVO"
  	else
    		echo "El archivo no existe."
  	fi

}

while [ $seguir -eq 1 ]
do
	echo "------ MENÚ ------"
  	echo "1) Crear entorno."
  	echo "2) Correr proceso."
  	echo "3) Listar alumnos."
  	echo "4) Diez notas más altas."
  	echo "5) Buscar padrón."
 	echo "6) Salir."

  	read -p "Seleccione una opción: " opcion

  	case $opcion in
    		1) crear_entorno ;;
    		2) correr_proceso ;;
    		3) listar_alumnos ;;
    		4) top_notas ;;
    		5) buscar_padron ;;
    		6) seguir=0 ;;
    		*) echo "Opción inválida. Intentelo de nuevo: " ;;
  	esac
done
