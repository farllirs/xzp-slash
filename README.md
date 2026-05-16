# 󰘳 xzp-slash

[![Build and Release .deb](https://github.com/farllirs/xzp-slash/actions/workflows/release.yml/badge.svg)](https://github.com/farllirs/xzp-slash/actions/workflows/release.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/farllirs/xzp-slash/releases/latest)

**xzp-slash** es un lanzador de comandos inteligente, contextual y visual diseñado para optimizar el flujo de trabajo en la terminal. Compatible nativamente con **Linux** (Debian, Arch, Alpine, Fedora) y **Termux**.

---

## 🚀 Instalación Rápida

### 1. Método Universal (Recomendado)
Instala automáticamente todas las dependencias y configura los widgets con un solo comando:

```bash
curl -sSL https://raw.githubusercontent.com/farllirs/xzp-slash/master/install.sh | bash
```

### 2. Repositorio Oficial (APT / PKG)
Añade nuestro repositorio para recibir actualizaciones automáticas:

**En Linux:**
```bash
echo "deb [trusted=yes] https://farllirs.github.io/xzp-slash/ ./" | sudo tee /etc/apt/sources.list.d/xzp-slash.list
sudo apt update && sudo apt install xzp-slash
```

**En Termux:**
```bash
echo "deb [trusted=yes] https://farllirs.github.io/xzp-slash/ ./" > $PREFIX/etc/apt/sources.list.d/xzp-slash.list
pkg update && pkg install xzp-slash
```

---

## ✨ Características Principales

- 🧠 **Detección Contextual:** Identifica automáticamente si estás en un proyecto de Git, Node.js, Python, Rust, C++ o Docker y te ofrece los comandos más usados.
- 🛠️ **Integración de Herramientas:** Acceso rápido a utilidades como `fzf`, `jq`, `ssh`, `rsync` y más, con autocompletado inteligente.
- 📊 **Task Manager Visual:** Incluye `slash-task`, un administrador de procesos interactivo basado en terminal.
- 🏥 **Health Check:** `slash-health` verifica al instante el estado de tus herramientas y variables de entorno.
- ⌨️ **Widgets de Shell:** Integración profunda con Bash y Zsh mediante el widget `/` (opcional).

---

## 🛠️ Comandos Incluidos

| Comando | Descripción |
| :--- | :--- |
| `slash` | Abre el menú principal de comandos contextuales. |
| `slash-task` | Administrador de procesos visual (matar, monitorear, filtrar). |
| `slash-health` | Diagnóstico de dependencias y configuración del sistema. |
| `slash-run` | Wrapper de ejecución para integración con widgets. |

---

## ⌨️ Configuración de Widgets

Si instalaste manualmente o quieres reactivar los widgets de teclado (presionar `/` para buscar):

**Bash (~/.bashrc):**
```bash
source /usr/share/slash/completions/bash_widget.sh
```

**Zsh (~/.zshrc):**
```bash
source /usr/share/slash/completions/zsh_widget.zsh
source /usr/share/slash/completions/pkg_completion.zsh
```

---

## 🤝 Contribuir

1. Haz un Fork del proyecto.
2. Crea una rama para tu característica (`git checkout -b feature/AmazingFeature`).
3. Haz un Commit de tus cambios (`git commit -m 'Add AmazingFeature'`).
4. Haz un Push a la rama (`git push origin feature/AmazingFeature`).
5. Abre un Pull Request.

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](debian/copyright) para más detalles.

---

<p align="center">
  Desarrollado con ❤️ para la comunidad de CLI.
</p>
