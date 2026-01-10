<div align="center">

# 🥚 Pterodactyl Eggs Builder

**Инструментарий для профессиональной разработки, сборки и тестирования яиц Pterodactyl Panel.**

[![Build Status](https://img.shields.io/github/actions/workflow/status/sliva-dev/pterodactyl-eggs/deploy.yml?style=flat-square&logo=github&label=Build)](https://github.com/sliva-dev/pterodactyl-eggs/actions)
[![Pterodactyl](https://img.shields.io/badge/Pterodactyl-v1.0%2B-blue?style=flat-square&logo=pterodactyl&logoColor=white)](https://pterodactyl.io)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)

<p>
  <a href="#-features">Возможности</a> •
  <a href="#-структура-проекта">Структура</a> •
  <a href="#-как-это-работает">Синтаксис</a> •
  <a href="#-использование">Запуск</a> •
  <a href="#-todo">Планы</a>
</p>

</div>

---

## 📖 Описание

Этот проект решает проблему ручного редактирования гигантских JSON-файлов для Pterodactyl. Мы используем модульный подход: пишем конфигурации в удобном **YAML**, выносим скрипты в отдельные файлы (`.sh`) и собираем всё это в готовые к импорту JSON-файлы одной командой.

### 🛠 Технологический стек

![Bash Badge](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)
![Docker Badge](https://img.shields.io/badge/-Docker-2496ED?style=flat-square&logo=docker&logoColor=white)
![YAML Badge](https://img.shields.io/badge/-YAML-CB171E?style=flat-square&logo=yaml&logoColor=white)
![JSON Badge](https://img.shields.io/badge/-JSON-000000?style=flat-square&logo=json&logoColor=white)

---

## ✨ Features

- **YAML вместо JSON** — Человекочитаемый формат конфигов с комментариями.
- **Модульность** — Скрипты установки (`install.sh`) лежат отдельно. Больше никакой каши в одной строке JSON.
- **Наследование переменных** — Общие переменные (версии Java, Docker образы) хранятся в `variables.yml` и переиспользуются.
- **Автосборка** — Скрипт `build.sh` автоматически собирает все яйца в папку `.dist`.
- **Локальное тестирование** — Скрипт `test.sh` поднимает Docker и проверяет, работает ли скрипт установки, не загружая яйцо в панель.
- **CI/CD** — Автоматическая генерация `index.json` для API и деплой через GitHub Actions.

---

## 📂 Структура проекта

```text
.
├── 📂 bin/                 # Скрипты автоматизации
│   ├── build.sh            # Сборщик (YAML -> JSON)
│   ├── index.sh            # Генератор индекса API
│   └── test.sh             # Локальный тестер в Docker
├── 📂 eggs/                # Исходный код яиц
│   └── 📂 <game>/<name>/   # Например: minecraft-java/paper
│       ├── egg.yml         # Основной конфиг яйца
│       └── install.sh      # Скрипт установки
├── 📂 .dist/               # Сюда сохраняются готовые JSON (игнорируется git)
├── variables.yml           # Глобальные переменные (образы, теги)
└── translation.yml         # Переводы полей

```

---

## 🧩 Как это работает

В файлах `egg.yml` используются специальные теги для подстановки данных. Сборщик обрабатывает их при компиляции.

| Тег | Описание | Пример использования |
| --- | --- | --- |
| **`!!file`** | Загружает содержимое файла как строку. Идеально для скриптов. | `script: !!file install.sh` |
| **`!!var`** | Подставляет значение из `variables.yml`. | `images: [ !!var images.java ]` |
| **`!!in`** | Подставляет перевод из `translation.yml`. | `name: !!in variables.startup.name` |

### Пример `egg.yml`

```yaml
name: Paper
images:
  - !!var images.java   # Подставит список Java образов

install:
  script: !!file install.sh  # Загрузит код из install.sh
  container: "debian:bookworm-slim"

config:
  startup: !!var config.minecraft.startup

```

---

## 🚀 Использование

### 1. Установка зависимостей

Для работы скриптов вам понадобятся `jq` и `docker` (для тестов).

```bash
# Ubuntu / Debian
sudo apt update && sudo apt install -y jq docker.io

```

### 2. Сборка яиц (Build)

Собирает все YAML файлы из папки `eggs/` и сохраняет результат в `.dist/`.

```bash
bash bin/build.sh

```

### 3. Тестирование (Test)

Запускает эмуляцию установки яйца в Docker контейнере. Это позволяет найти ошибки в `install.sh` до загрузки в панель.

```bash
# Тестировать все яйца
bash bin/test.sh

# Тестировать конкретное яйцо (фильтр по имени)
bash bin/test.sh fabric

```

### 4. Генерация индекса

Создает `index.json` для подключения репозитория в панель (обычно выполняется в CI).

```bash
export URL="[https://your-domain.com/](https://your-domain.com/)"
bash bin/index.sh

```

---

## ✅ ToDo

Планы по развитию проекта:

---

<div align="center">
<sub>Built with ❤️ by FaithNode Team</sub>
</div>

```
