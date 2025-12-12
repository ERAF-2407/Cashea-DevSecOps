# 🛡️ CasheaSec-Node: Secure Fintech Microservice

Este proyecto demuestra una arquitectura **DevSecOps** completa para un microservicio basado en **Node.js**, integrando seguridad en el ciclo de vida (SDLC) según los requerimientos de Cashea.

## 🛠️ Tech Stack & Security Tools

| Área | Tecnología | Herramienta de Seguridad | Función |
| :--- | :--- | :--- | :--- |
| **Backend** | Node.js (Express) | **Njsscan** (SAST) | Detecta patrones inseguros (Eval, Command Injection). |
| **Deps** | NPM | **NPM Audit** (SCA) | Auditoría de librerías vulnerables. |
| **Infra** | Docker | **Trivy** | Hardening de imagen y escaneo de SO. |
| **Git** | GitHub | **Gitleaks** | Prevención de fugas de secretos (API Keys). |
| **Cloud** | AWS / Terraform | **Checkov / IAM** | Política de Mínimo Privilegio (IaC). |

## 🚨 Vulnerabilidades Demostradas (Para propósitos educativos)

El archivo `src/app.js` contiene vulnerabilidades intencionales para probar la eficacia del pipeline:
1.  **Command Injection:** Uso inseguro de `exec()` detectado por **Njsscan**.
2.  **Secret Leak:** Key de Stripe hardcodeada detectada por **Gitleaks**.
3.  **Insecure Container:** (Antes del fix) Correr como root detectado por **Trivy**.

## ☁️ Cloud Hardening Strategy
Se incluye código Terraform (`infra/aws`) que define un rol IAM para ECS con **Least Privilege**, permitiendo al contenedor Node.js acceder únicamente a sus logs y a su secreto específico en AWS Secrets Manager, mitigando el impacto lateral si el contenedor es comprometido.