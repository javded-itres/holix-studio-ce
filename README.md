# Holix Studio CE

[![Holix](https://img.shields.io/pypi/v/Holix.svg)](https://pypi.org/project/Holix/)
[![Python](https://img.shields.io/badge/python-3.12%2B-blue.svg)](https://python.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Holix GitHub](https://img.shields.io/github/stars/javded-itres/Holix?style=social)](https://github.com/javded-itres/Holix)

Одноместная IDE для агента [Holix](https://github.com/javded-itres/Holix): чат, файлы, git и терминал **на вашей машине**. Один пользователь. Без облачной подписки.

Cloud для команд — [holix-studio.ru](https://holix-studio.ru). Этот репозиторий — витрина и установщик.

**English:** [setup below](#english) · [full guide](docs/en/SETUP.md)

<p align="center">
  <img src="docs/assets/hero.jpg" alt="Holix Studio" width="920">
</p>

---

## Что это

| | **CE (здесь)** | **Cloud** |
|---|---|---|
| Кто | вы на своём компьютере | команда на holix-studio.ru |
| Пользователей | один | организации, инвайты, тарифы |
| Лицензия инстанса | не нужна | нужна |
| Репозиторий | эта витрина + [Holix](https://github.com/javded-itres/Holix) MIT | закрытый продукт |

CE — не «открытый GitLab». Исходники Cloud в этом git не лежат.

## Возможности

<p align="center">
  <img src="docs/assets/feature-agent.jpg" alt="Агент" width="300">
  <img src="docs/assets/feature-editor.jpg" alt="Редактор" width="300">
  <img src="docs/assets/feature-terminal.jpg" alt="Терминал" width="300">
</p>

- Агент Holix в браузере: чат, план, правки в workspace
- Файлы, git, терминал
- Свой ключ модели (OpenAI, OpenRouter, Ollama, любой OpenAI-совместимый API)

Полный текст: [docs/ru/SETUP.md](docs/ru/SETUP.md)

---

## Настройка Studio и агента

Нужны [uv](https://docs.astral.sh/uv/) и Python **3.12+**.

### 1. Установить

```bash
curl -fsSL https://raw.githubusercontent.com/javded-itres/holix-studio-ce/main/scripts/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
```

Ставятся агент **Holix 1.1.0** и IDE **Studio CE** (wheel с [Releases](https://github.com/javded-itres/holix-studio-ce/releases)).

### 2. Запустить IDE

Из папки проекта:

```bash
cd ~/Projects/my-app
holix-studio-ce setup
holix-studio-ce serve
```

Откройте **http://127.0.0.1:8788/studio/**

В терминале:

- `profile=…` — это **логин**
- при первом запуске пароль печатается один раз (`New Studio login password`) — сохраните его

### 3. Подключить модель

Без провайдера агент не отвечает. В Studio:

1. **Админка → Модели** (или **Настройки → Модели**).
2. **Добавить провайдер** — preset (OpenAI, OpenRouter, Ollama, Groq, vLLM…).
3. Вставьте **API key**. Для Ollama: Host `http://127.0.0.1`, порт `11434`, ключ не обязателен.
4. **Загрузить с провайдера** (список моделей) или впишите id вручную, например `gpt-4o-mini`.
5. Задайте **модель по умолчанию** и сохраните каталог.
6. Вернитесь в чат и напишите сообщение.

Тот же агент в терминале:

```bash
holix bootstrap
holix models setup
holix tui
```

| Провайдер | Что нужно |
|---|---|
| OpenAI | ключ `sk-…` |
| OpenRouter | ключ с [openrouter.ai](https://openrouter.ai) (много моделей, в т.ч. Anthropic) |
| Ollama | `ollama serve` и `ollama pull llama3.2` |
| Groq / DeepSeek / xAI | ключ сервиса |

Профиль Holix общий: ключ из Studio виден в `holix tui`, и наоборот.

### Если не работает

| Проблема | Что делать |
|---|---|
| `command not found` | `export PATH="$HOME/.local/bin:$PATH"` |
| Нет `holix-studio-ce`, есть `holix` | На [Releases](https://github.com/javded-itres/holix-studio-ce/releases) ещё нет `.whl` — агент уже можно запускать: `holix tui` |
| Неверный пароль | Пароль с **первого** `serve`. Сброс: `holix studio auth reset-password` |
| Агент молчит | Нет ключа / провайдера. Админка → Модели |
| Порт 8788 занят | `holix-studio-ce stop` или `--port 8789` |

Wheel IDE — source-available (как Cloud), не MIT. Ставить и пользоваться на одной машине можно; перепродавать и поднимать чужой SaaS — нет.

---

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

Teams use **[holix-studio.ru](https://holix-studio.ru)**. This repository is the public landing + installer, not a dump of Cloud source.

Full guide: [docs/en/SETUP.md](docs/en/SETUP.md)

### 1. Install

Needs [uv](https://docs.astral.sh/uv/) and Python **3.12+**.

```bash
curl -fsSL https://raw.githubusercontent.com/javded-itres/holix-studio-ce/main/scripts/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
```

Installs **Holix 1.1.0** and the Studio CE IDE wheel from [Releases](https://github.com/javded-itres/holix-studio-ce/releases).

### 2. Start the IDE

```bash
cd ~/Projects/my-app
holix-studio-ce setup
holix-studio-ce serve
```

Open **http://127.0.0.1:8788/studio/**

- `profile=…` in the terminal is your **username**
- first start prints a one-time password (`New Studio login password`) — save it

### 3. Connect a model

The agent will not answer until a provider is configured.

1. In Studio open **Admin → Models** (or **Settings → Models**).
2. **Add provider** — OpenAI, OpenRouter, Ollama, Groq, vLLM…
3. Paste the **API key**. For Ollama: Host `http://127.0.0.1`, port `11434`, key optional.
4. **Load from provider** or type a model id (`gpt-4o-mini`).
5. Set the **default model** and save.
6. Go back to chat.

Same agent in the terminal:

```bash
holix bootstrap
holix models setup
holix tui
```

| Provider | What you need |
|---|---|
| OpenAI | `sk-…` key |
| OpenRouter | key from [openrouter.ai](https://openrouter.ai) (many models, including Anthropic) |
| Ollama | `ollama serve` and `ollama pull llama3.2` |
| Groq / DeepSeek / xAI | that vendor’s key |

The Holix profile is shared: a key set in Studio is visible to `holix tui`, and vice versa.

### If it fails

| Problem | Fix |
|---|---|
| `command not found` | `export PATH="$HOME/.local/bin:$PATH"` |
| No `holix-studio-ce`, `holix` works | No `.whl` on [Releases](https://github.com/javded-itres/holix-studio-ce/releases) yet — use `holix tui` |
| Wrong password | Use the password from the **first** `serve`. Reset: `holix studio auth reset-password` |
| Agent silent | No provider/key. Admin → Models |
| Port 8788 busy | `holix-studio-ce stop` or `--port 8789` |

The IDE wheel is source-available (same as Cloud), not MIT. You may run it on one machine; you may not resell it or host it as someone else’s SaaS.
