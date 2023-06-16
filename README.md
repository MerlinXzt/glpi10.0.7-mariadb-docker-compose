# glpi10.0.7-mariadb-docker-compose
Repositorio para la configuración de un entorno Docker con GLPI 10.0.7 y MariaDB 10.0.7
# Repositorio de Docker para GLPI

Este repositorio contiene archivos de configuración para crear un entorno de Docker con GLPI (Gestionnaire Libre de Parc Informatique). GLPI es un sistema de gestión de activos y tickets de ayuda de código abierto.

## Requisitos previos

Asegúrate de tener instalado Docker y Docker Compose en tu sistema antes de continuar.

- Docker: [Instrucciones de instalación](https://docs.docker.com/get-docker/)
- Docker Compose: [Instrucciones de instalación](https://docs.docker.com/compose/install/)

## Instrucciones de uso

1. Clona este repositorio en tu máquina local:

git clone https://github.com/MerlinXzt/glpi10.0.7-mariadb-docker-compose.git


2. Navega hasta el directorio clonado:

cd <DIRECTORIO_DEL_REPOSITORIO>

3. Abre el archivo `docker-compose.yml` y ajusta las variables de entorno según tus necesidades. Puedes cambiar el nombre de la base de datos, el usuario, la contraseña, etc.

4. Ejecuta el siguiente comando para iniciar los contenedores de Docker:

docker-compose up -d


Esto creará y ejecutará los contenedores de Docker necesarios para GLPI y la base de datos asociada.

5. Accede a GLPI a través de tu navegador web en la siguiente URL:

http://localhost:80


¡Listo! Ahora deberías poder acceder a la interfaz de GLPI y comenzar a utilizarlo.

## Personalización

Puedes personalizar aún más la configuración de GLPI modificando el archivo `Dockerfile` y el archivo de configuración de Apache `apache-glpi.conf`. Estos archivos se encuentran en este repositorio y puedes ajustarlos según tus necesidades específicas.

## Notas

- La versión de PHP utilizada en este entorno de Docker es la 8.1 con Apache como servidor web.
- El archivo `config_db.php` se genera automáticamente durante la construcción del contenedor y contiene la configuración de conexión a la base de datos. No es necesario modificarlo manualmente.
- Los directorios de datos de GLPI se almacenan fuera del directorio raíz web para mayor seguridad y persistencia.



