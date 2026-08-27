# Holix Studio CE

[![Holix](https://img.shields.io/pypi/v/Holix.svg)](https://pypi.org/project/Holix/)
[![Python](https://img.shields.io/badge/python-3.12%2B-blue.svg)](https://python.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Holix GitHub](https://img.shields.io/github/stars/javded-itres/Holix?style=social)](https://github.com/javded-itres/Holix)

Одноместная IDE для агента [Holix](https://github.com/javded-itres/Holix): чат, файлы, git и терминал **на вашей машине**. Один пользователь. Без облачной подписки.

Cloud для команд — [holix-studio.ru](https://holix-studio.ru). Этот репозиторий — витрина и установщик агента.

<p align="center">
  <img src="docs/assets/hero.jpg" alt="Holix Studio" width="920">
</p>

**English:** [below](#english)

---

## Что это

| | **CE (здесь)** | **Cloud** |
|---|---|---|
| Кто | вы на своём компьютере | команда на holix-studio.ru |
| Пользователей | один | организации, инвайты, тарифы |
| Лицензия инстанса | не нужна | нужна |
| Репозиторий | эта витрина + [Holix](https://github.com/javded-itres/Holix) MIT | закрытый продукт |

CE — не «открытый GitLab». Исходники Cloud не лежат в этом git.

## Возможности

<p align="center">
  <img src="docs/assets/feature-agent.jpg" alt="Агент" width="300">
  <img src="docs/assets/feature-editor.jpg" alt="Редактор" width="300">
  <img src="docs/assets/feature-terminal.jpg" alt="Терминал" width="300">
</p>

- Агент Holix в браузере: чат, план, правки в workspace  
- Файлы, git, терминал  
- Свой ключ модели (OpenAI-совместимый / LiteLLM)

## Установка на свою машину

Нужны [uv](https://docs.astral.sh/uv/) и Python 3.12+.

```bash
curl -fsSL https://raw.githubusercontent.com/javded-itres/holix-studio-ce/main/scripts/install.sh | bash
```

Скрипт ставит **Holix 1.1.0** и, если есть [GitHub Release](https://github.com/javded-itres/holix-studio-ce/releases) с wheel, **Studio CE**.

```bash
export PATH="$HOME/.local/bin:$PATH"
holix-studio-ce setup
holix-studio-ce serve
# http://127.0.0.1:8788/studio/
```

Ключ модели — в профиле Holix (`OPENAI_API_KEY` или LiteLLM). Только агент: `holix` (TUI). Документация агента: [Holix](https://github.com/javded-itres/Holix).

Wheel IDE — source-available (как Cloud), не MIT. Ставить и пользоваться на одной машине можно; перепродавать и поднимать чужой SaaS — нет.

Релизы wheel собираются из закрытого репозитория Studio (**Actions → Publish CE wheel**), в этот git исходники Cloud не кладутся.

## Cloud

Команды, биллинг, франшиза: **[holix-studio.ru](https://holix-studio.ru)**

## Участие

- Баги установщика и тексты витрины — [Issues](https://github.com/javded-itres/holix-studio-ce/issues)  
- Агент, CLI, gateway — [javded-itres/Holix](https://github.com/javded-itres/Holix/issues)

Патчи к этому репо: docs и `scripts/install.sh`. См. [CONTRIBUTING.md](CONTRIBUTING.md).

## Лицензия

Витрина и скрипты — [MIT](LICENSE). Cloud Studio — отдельная source-available лицензия, сюда не входит.

---

## English

**Holix Studio CE** is a **single-user** IDE for the [Holix](https://github.com/javded-itres/Holix) agent: chat, files, git, and terminal **on your machine**. No cloud seat.

Teams use **[holix-studio.ru](https://holix-studio.ru)**. This repository is the public landing + Holix installer, not a dump of Cloud source.

```bash
curl -fsSL https://raw.githubusercontent.com/javded-itres/holix-studio-ce/main/scripts/install.sh | bash
holix
```

Requires [uv](https://docs.astral.sh/uv/) and Python 3.12+. Configure a model key in the Holix profile. `./scripts/install.sh` installs Holix 1.1.0 and, when a GitHub Release wheel exists, the Studio CE IDE (`holix-studio-ce serve` → http://127.0.0.1:8788/studio/). The IDE wheel is source-available (same as Cloud), not MIT.
