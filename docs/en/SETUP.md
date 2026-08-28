# Set up Holix Studio CE and the agent

Single user, your machine. No cloud seat.

You need [uv](https://docs.astral.sh/uv/) and Python 3.12+.

## 1. Install

```bash
curl -fsSL https://raw.githubusercontent.com/javded-itres/holix-studio-ce/main/scripts/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
```

The script installs the **Holix 1.1.0** agent and the **Studio CE** IDE (wheel from [Releases](https://github.com/javded-itres/holix-studio-ce/releases)).

Check:

```bash
holix version
holix-studio-ce --help
```

## 2. Start Studio

From the project folder the agent should work in:

```bash
cd ~/Projects/my-app
holix-studio-ce setup
holix-studio-ce serve
```

The terminal prints:

- IDE URL: **http://127.0.0.1:8788/studio/**
- `profile=…` — that is your **login**
- on first start — a password (`New Studio login password`). It is shown **once**

Open Studio in the browser. Username = profile name, password = the one from the terminal.

Reset the password later:

```bash
holix studio auth reset-password
```

## 3. Connect a model (the agent will not answer without one)

Studio is the shell. The Holix agent calls an LLM. You need at least one provider.

### In the browser (easiest)

1. Sign in to Studio.
2. Open **Admin → Models** (or **Settings → Models**).
3. **Add provider**:
   - preset: OpenAI, OpenRouter, Ollama, vLLM, Groq, DeepSeek…
   - **API key** for cloud (`sk-…`)
   - for Ollama / vLLM / LM Studio: **Host** `http://127.0.0.1` and port (Ollama is `11434`)
4. Click **Add**. If the network probe fails, tick “skip live probe”.
5. **Load from provider** to fetch the model list — or type an id (`gpt-4o-mini`, `llama3.2`).
6. Set the **default provider and model** → **Apply default** / **Save catalog**.
7. Go back to the IDE chat and send a message.

Typical keys:

| Provider | What you need |
|---|---|
| OpenAI | `OPENAI_API_KEY` / key in the form |
| OpenRouter | key from [openrouter.ai](https://openrouter.ai) (many models, including Anthropic) |
| Groq, DeepSeek, Mistral, xAI | that vendor’s key |
| Ollama | local: `ollama serve`, then `ollama pull llama3.2` |

### In the terminal (same agent)

```bash
holix bootstrap          # LLM + profile wizard
holix models setup       # provider and key
holix models list
holix tui                # terminal chat
```

The Holix profile is shared: a key set in Studio is visible to the TUI agent, and the other way around.

## 4. Work in the IDE

After a model is set:

- agent chat on the left
- files, git, terminal — in the workspace (the directory you started `serve` from)
- one user, no invites, no instance license

Agent only, no browser: `holix tui`. Agent docs: [Holix](https://github.com/javded-itres/Holix).

## If it fails

| Symptom | Check |
|---|---|
| `holix-studio-ce: command not found` | `export PATH="$HOME/.local/bin:$PATH"` |
| No wheel / no `holix-studio-ce` command | Is there a `.whl` on [Releases](https://github.com/javded-itres/holix-studio-ce/releases)? The agent is still there: `holix` |
| Login page, password rejected | Use the password printed on **first** `serve`. Reset: `holix studio auth reset-password` |
| Agent silent / model error | No provider or key. Admin → Models. For Ollama: daemon running, model pulled |
| Port 8788 busy | `holix-studio-ce stop` or `holix-studio-ce serve --port 8789` |

Cloud for teams: [holix-studio.ru](https://holix-studio.ru).
