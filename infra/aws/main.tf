provider "aws" {
  region = "us-east-1"
}

# --- 1. Repositorio de Docker (Gratis hasta 500MB/mes) ---
resource "aws_ecr_repository" "cashea_repo" {
  name                 = "cashea-secure-repo"
  image_tag_mutability = "MUTABLE"

  # Vulnerability Scanning activado (Scan on Push es gratis en la capa básica)
  image_scanning_configuration {
    scan_on_push = true
  }
}

# --- 2. IAM User para Github Actions (Siempre Gratis) ---
resource "aws_iam_user" "github_ci_user" {
  name = "github-actions-deployer"
}

# --- 3. Política de Mínimo Privilegio (Seguridad) ---
# Solo permitimos subir imágenes al ECR, nada más.
resource "aws_iam_policy" "ci_policy" {
  name        = "cashea-ci-ecr-policy"
  description = "Permite a Github Actions subir imágenes a ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource = aws_ecr_repository.cashea_repo.arn
      },
      {
        Effect = "Allow",
        Action = "ecr:GetAuthorizationToken",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_ci" {
  user       = aws_iam_user.github_ci_user.name
  policy_arn = aws_iam_policy.ci_policy.arn
}