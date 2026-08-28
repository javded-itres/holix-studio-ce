# Настройка Holix Studio CE и агента

Один пользователь, ваша машина. Облачная подписка не нужна.

Нужны [uv](https://docs.astral.sh/uv/) и Python 3.12+.

## 1. Установить

```bash
curl -fsSL https://raw.githubusercontent.com/javded-itres/holix-studio-ce/main/scripts/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
```

Скрипт ставит агент **Holix 1.1.0** **в PATH** (`~/.local/bin/holix`, и `/usr/local/bin/holix`, если каталог доступен для записи) и IDE **Studio CE** (wheel с [Releases](https://github.com/javded-itres/holix-studio-ce/releases)).

Проверка:

```bash
export PATH="$HOME/.local/bin:$PATH"
holix version
holix models list
holix-studio-ce --help
```

## 2. Запустить Studio

Из папки проекта, с которым будет работать агент:

```bash
cd ~/Projects/my-app
holix-studio-ce setup
holix-studio-ce serve
```

В терминале появятся:

- адрес IDE: **http://127.0.0.1:8788/studio/**
- `profile=…` — это **логин**
- при первом запуске — пароль (`New Studio login password`). Его показывают **один раз**

Откройте Studio в браузере. Логин = имя профиля, пароль = из терминала.

Сбросить пароль позже:

```bash
holix studio auth reset-password
```

## 3. Подключить модель (агент без ключа не отвечает)

Studio — оболочка. Агент Holix вызывает LLM. Нужен хотя бы один провайдер.

### В браузере (удобно)

1. Войдите в Studio.
2. Откройте **Админка → Модели** (или **Настройки → Модели**).
3. **Добавить провайдер**:
   - preset: OpenAI, OpenRouter, Ollama, vLLM, Groq, DeepSeek…
   - **API key** для облака (`sk-…`)
   - для Ollama / vLLM / LM Studio: **Host** `http://127.0.0.1` и порт (Ollama — `11434`)
4. Нажмите **Добавить**. При ошибке сети включите «не дергать API сейчас».
5. **Загрузить с провайдера** — список моделей. Или впишите id вручную (`gpt-4o-mini`, `llama3.2`).
6. Выберите **провайдер и модель по умолчанию** → **Применить default** / **Сохранить каталог**.
7. Вернитесь в чат IDE и напишите сообщение.

Типичные ключи:

| Провайдер | Что нужно |
|---|---|
| OpenAI | `OPENAI_API_KEY` / ключ в форме |
| OpenRouter | ключ с [openrouter.ai](https://openrouter.ai) (много моделей, в т.ч. Anthropic) |
| Groq, DeepSeek, Mistral, xAI | ключ сервиса |
| Ollama | локально: `ollama serve`, модель `ollama pull llama3.2` |

### В терминале (тот же агент)

```bash
holix bootstrap          # мастер LLM + профиль
holix models setup       # провайдер и ключ
holix models list
holix tui                # чат в терминале
```

Профиль Holix общий: ключ, заданный в Studio, виден агенту в TUI, и наоборот.

## 4. Работать в IDE

После модели:

- чат с агентом слева
- файлы, git, терминал — в workspace (каталог, из которого запущен `serve`)
- один пользователь, без инвайтов и без instance license

Только агент, без браузера: `holix tui`. Документация агента: [Holix](https://github.com/javded-itres/Holix).

## Если не работает

| Симптом | Что проверить |
|---|---|
| `holix-studio-ce: command not found` | `export PATH="$HOME/.local/bin:$PATH"` |
| Нет wheel / нет команды `holix-studio-ce` | Есть ли `.whl` на [Releases](https://github.com/javded-itres/holix-studio-ce/releases)? Агент при этом уже есть: `holix` |
| Страница логина, пароль не подходит | Смотрите вывод `serve` при **первом** старте. Сброс: `holix studio auth reset-password` |
| Агент молчит / ошибка модели | Нет провайдера или ключа. Админка → Модели. Для Ollama: демон запущен, модель скачана |
| Порт 8788 занят | `holix-studio-ce stop` или `holix-studio-ce serve --port 8789` |

Cloud для команд: [holix-studio.ru](https://holix-studio.ru).
