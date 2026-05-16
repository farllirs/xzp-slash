# xzp/slash

![Build Status](https://img.shields.io/badge/build-passing-brightgreen?style=flat-square&labelColor=0d1117&color=39ff14)
![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square&labelColor=0d1117&color=00f5ff)
![Version](https://img.shields.io/badge/version-v1.0.0-orange?style=flat-square&labelColor=0d1117&color=f0c040)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Termux-purple?style=flat-square&labelColor=0d1117&color=9f7aea)

> **El lanzador de comandos definitivo para Linux y Termux. Rápido, contextual y visual.**

---

## ⚡ Quick Start

```bash
curl -sSL https://raw.githubusercontent.com/farllirs/xzp-slash/master/install.sh | bash
```

Después de instalar, ejecuta:

```bash
slash
```

---

## 📦 Instalación

### Método 1 — CURL (Recomendado)

```bash
curl -sSL https://raw.githubusercontent.com/farllirs/xzp-slash/master/install.sh | bash
```

### Método 2 — APT (Debian / Ubuntu / Arch)

```bash
# Añadir repositorio
echo "deb [trusted=yes] https://farllirs.github.io/xzp-slash/ ./" | sudo tee /etc/apt/sources.list.d/xzp-slash.list

# Actualizar e instalar
sudo apt update && sudo apt install xzp-slash
```

### Método 3 — PKG (Termux)

```bash
# Añadir repositorio
echo "deb [trusted=yes] https://farllirs.github.io/xzp-slash/ ./" > $PREFIX/etc/apt/sources.list.d/xzp-slash.list

# Actualizar e instalar
pkg update && pkg install xzp-slash
```

---

## ✨ Características

| Feature | Descripción |
|---|---|
| 🌐 **Multiplataforma** | Soporte nativo para Debian, Arch, Alpine y Termux |
| 🧠 **Contextual** | Detecta proyectos Git, Node.js y Python automáticamente |
| 🖥️ **Visual** | Task Manager estético integrado en la terminal |
| ⚡ **Ligero** | Escrito en Bash y Python, sin dependencias pesadas |

---

## 🖥️ Screenshots

```
❯ slash

⚡ xzp-slash — selecciona un comando
▶ git status           — contexto: repo Git detectado
  npm run dev          — contexto: proyecto Node.js
  python -m venv .env  — contexto: proyecto Python
  slash-task           — abrir Task Manager
  slash-health         — estado del sistema
```

---

## 📋 Comandos principales

### `slash`
Lanzador principal. Abre el menú fzf interactivo con comandos contextuales basados en el proyecto detectado.

```bash
slash
```

### `slash-task`
Administrador de tareas visual integrado en la terminal. Muestra procesos, CPU, RAM y red de forma estética.

```bash
slash-task
```

### `slash-health`
Reporte completo del estado del sistema: disco, memoria, temperatura, uptime y más.

```bash
slash-health
```

---

## 🔧 Plataformas soportadas

- ✅ Debian / Ubuntu
- ✅ Arch Linux
- ✅ Alpine Linux
- ✅ Termux (Android)

---

## 📄 Licencia

MIT © [farllirs](https://github.com/farllirs)
