# infra/aws/iam-hardening.tf

provider "aws" {
  region = "us-east-1"
}

# 1. IAM Role para el Task de ECS (Donde corre Node.js)
# Principio: La app solo debe tener permisos para lo que necesita.
resource "aws_iam_role" "node_service_role" {
  name = "cashea_node_microservice_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# 2. Política Estricta: Solo permitir escribir logs y leer secretos específicos
resource "aws_iam_policy" "node_minimal_policy" {
  name        = "cashea_node_minimal_policy"
  description = "Política restrictiva para microservicio Node.js"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = ["secretsmanager:GetSecretValue"],
        # IMPORTANTE: Solo permitimos leer el secreto de Stripe, nada más.
        Resource = "arn:aws:secretsmanager:us-east-1:123456789012:secret:prod/stripe-key-*"
      }
    ]
  })
}