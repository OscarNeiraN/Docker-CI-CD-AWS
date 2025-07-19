# Docker-CI-DC-AWS
Despliegue de contenedores mediante Docker, integración e implementación continua (CI/CD) con GitHub Actions, y provisión de infraestructura en nube pública utilizando AWS.


# Despliegue de infraestructura IaC (Terraform)

Contenido:
    -Security Group
        -Instancia EC2

# DockerFile

Contenido:
    - FROM nginx
        -ruta directorio WEB

# Workflows:

Contenido:
    -creacion iamgen
        -Login
            -Subir a repositorio Docker Hub
    -Conexión SSH instancia EC2 (AWS)
        -Verificación si se encuentran activas contenedores antiguos
            -Decargar Imagen
                -correr contenedor.