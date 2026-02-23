# cloud-engineer-assessment

1. Getting started

Export your AWS IAM AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY as well as an AWS_REGION by running the following commands depending on your OS.

Linux: 

```
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_REGION="us-east-1"
```

Windows (CMD):

```
set AWS_ACCESS_KEY_ID="anaccesskey"
set AWS_SECRET_ACCESS_KEY="asecretkey"
set AWS_REGION="us-east-1"
```

Windows (PowerShell):
```
$env:AWS_ACCESS_KEY_ID="anaccesskey"
$env:AWS_SECRET_ACCESS_KEY="asecretkey"
$env:AWS_REGION="us-east-1"
```

Then go to a project directory and run:

```
terraform plan
```

2. Manejo del estado en un equipo distribuido

Para manejar el estado de la infraestructura de manera segura y consistente, se debe utilizar un bloque `backend` que apunte a un bucket de S3 para almacenar los archivos .tfstate.

```
terraform {
  backend "s3" {
    bucket = var.terraform_states_bucket
    key = "path/to/terraform.tfstate"
    region = var.aws_region
  }
}
```

3. Decisiones arquitectónicas

* Diagrama de arquitectura escenario 1 y 2
  * Los recursos están dentro de una subred privada para evitar su exposición a internet.
  * Debido a que un certificado no puede ser asignado directamente a un Virtual Node, se utiliza cert-manager que con un ClusterIssuer hace referencia al ARN del ACM Private Certificate Authority.
  * El Virtual Node hace la validación de los certificados mediante las rutas `/certs` asegurando que únicamente los pods que contengan estos archivos puedan comunicarse entre sí

<img width="4600" height="3440" alt="image" src="https://github.com/user-attachments/assets/88bd8cc9-a755-4710-b312-8b9e60294f63" />


* Diagrama de arquitectura escenario 3

<img width="2676" height="1576" alt="image" src="https://github.com/user-attachments/assets/d755cd82-eaee-41dd-ac9e-fbf299463d51" />


