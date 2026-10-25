# Literature Reading Skill

> Read a paper → auto-archive → generate a card → your capability profile grows.
>
> A [DeepSeek Harness](https://github.com/deepseek-ai) skill. Install and go.

English | [中文](README.zh.md)

---

## In one sentence

**The hardest part of graduate-level paper reading is not the English — it is that nothing survives the reading.**

Twenty papers in, you cannot recall a single one when writing the survey. Asked "what was that paper about?" in a group meeting, you have three words: "I forgot."

This skill makes every paper leave three things behind: **the archived PDF, a structured card, and a growing capability profile.**

---

## Core design

### 1. Three-way classification

| Class | Prefix | What counts | Affects level | How it is explained |
|---|---|---|---|---|
| **Core** | `CORE-` | Directly addresses your research problem | ✅ Yes | Full nine sections |
| **Related** | `REL-` | Adjacent field, some transferable value | ❌ No | Four quick questions |
| **Method** | `METH-` | Optimization, ML, statistics, simulation… | ❌ No | Only "how to use it" |

**Level is computed from `CORE-` only.** This prevents false progress from reading the wrong things.

### 2. Nine output sections

| Section | Content |
|---|---|
| **A Overview** | Three sentences + "remember one thing" |
| **B Positioning** | What problem, standing on whose shoulders |
| **C Section-by-section** | Mark skimmable vs must-read |
| **D Method** | Assumption table, decision variables, formula de-scaling |
| **E Experiments** | Scale, baselines, metric definitions, **overhead counted?** |
| **F Critique** | Three weaknesses + implicit premises |
| **G Novelty** | Real contribution or packaging? Classified per claim |
| **G2 Transferable** | Modeling / method / experiment / writing / engineering |
| **G3 What to learn** | Three tiers, plus "what you can skip" |

### 3. Ask before acting

It does not dump 8000 characters at you:

```
Paper received
   ↓
Asks three questions (goal / depth / where to start)
   ↓
You answer → outputs 1–2 sections at a time
   ↓
Asks "continue?" after each
   ↓
You can interrupt any time: expand / skip / rephrase
```

**Why**: dump it all at once and you will read only the first and last paragraph.

### 4. The profile grows

The skill reads `.literature/config.md` and adapts to your stage:

| Stage | Criterion (CORE- only) | Explanation style |
|---|---|---|
| 0 Beginner | < 5 papers | Explain every term, skip all math |
| 1 Novice | 5–15 | Explain terms on first use only |
| 2 Competent | 15–30 | Assume common abbreviations are known |
| 3 Familiar | 30+ | Jump straight to differences and disputes |

**Stage only advances when you confirm it.** The model is not allowed to promote you after one paper.

### 5. Token-aware: reads only what it needs

The more you read, the more cards accumulate. Re-reading all of them every time would burn ~20k tokens per paper after 30 papers.

So it reads selectively:

| What | When | Cost |
|---|---|---|
| Config file | Always | ~2.5KB |
| Index table | Before archiving a new paper (dedup) | ~1KB |
| **Recent N cards** | Every time you read a paper | N is yours to set |
| Other historical cards | Only when you ask | — |

#### Recent N cards: you decide

A config field, `recent N`, controls how much context comes along:

| N | Effect | Extra cost |
|---|---|---|
| `0` | Each paper stands alone (cheapest) | 0 |
| `1` | Can relate to the previous one | ~2KB |
| **`3` (default)** | Covers your recent reading | ~5KB |
| `5` | Most continuous context | ~10KB |

**Why this exists**: with no history, the model cannot tell you "this contradicts the paper you read last week". With too much, you pay for it. So you set the dial.

#### Dedup: it will not archive the same paper twice

**Before archiving anything, it checks the index table** (~1KB, not every card):

1. **DOI** (most reliable)
2. **English title** (lowercased, first 5 words)
3. Chinese short name

On a hit it stops and asks:

> "You already read this: **CORE-003**, on 2026-10-20.
> Want me to **load the saved card** (cheap, no re-read), or **read it again**?"

| Your choice | What it does |
|---|---|
| **Load the card** | Reads the card, restates the key points, **does not re-analyse** |
| **Read again** | Runs the normal nine-section flow but **updates the existing card** |

**It also checks card completeness.** If that card was only `screened` (abstract only), it tells you what is missing rather than passing off a partial record as complete:

```
⚠️ This card is incomplete (it was "screened", abstract only).
   Missing:
   - D: the actual method design
   - E: experiment scale and numbers
   Read the full text now?
```

The index row is tiny:

```
| ID | Short title | English title | DOI/link | Year | Class | Status | PDF | Date |
```

**Incomplete fields are fine.** It degrades gracefully: DOI → link → English title → "none".

> ⚠️ **It will never invent a DOI to fill the column.** A fabricated DOI is worse than a blank one — future dedup breaks and your citations go wrong.

#### The saving

| Strategy | Cost per paper after 30 papers |
|---|---|
| Read all history | ~22,000 tokens |
| **Index + recent 3** (default) | ~7,000 tokens |

**Two-thirds saved**, and the gap widens as you read more.

---

# Detailed guide

---

## Install

### Easiest: double-click installer

```
① Download ZIP (green Code button → Download ZIP) → extract
② Open install\ and double-click install.cmd
③ Press Enter at the menu (defaults to global install)
④ Restart DSH, open a new conversation, say "read this paper"
```

That is it. No command line, no npm, no account.

### The other three ways

| Method | Best for | How |
|---|---|---|
| **Global install** (above) | All projects | Double-click → Enter |
| **Single project** | One project, **no C: drive** | Double-click → choose 2 → enter project path |
| **Manual copy** | Full control | Copy `skills/literature-reading` to `<project>/.dsh/skills/` |
| **Other desktop clients** | Cursor / Claude | Double-click → choose 4 for platform notes |

> Global installs to `C:\Users\<you>\.agents\skills\`
> Project install goes to `<project>\.dsh\skills\` — **never touches C:**

**Detailed steps and troubleshooting** → [QUICKSTART.md](QUICKSTART.md) (Chinese)

### Where a skill may live

**The location must be one the client actually scans**, or the skill is invisible.

DSH scans these, highest priority first:

| Priority | Location | Needs C: | Scope |
|---|---|---|---|
| 100 | `<project>/.dsh/skills/` | ❌ | That project only |
| 200 | `<project>/.agents/skills/` | ❌ | That project only |
| 300 | Custom dir (needs registration) | ❌ | Per config |
| 400 | `~/.dsh/skills/` | ✅ | All projects |
| 500 | `~/.agents/skills/` | ✅ | All projects |

### From npm (optional)

```bash
dsh plugin --profile web add dsh-skill-literature-reading
# or for the desktop app
dsh plugin --profile desktop add dsh-skill-literature-reading
```

### Verify

Open a new conversation and say "read this paper". It should ask you a few questions first.

### Other desktop clients

| Platform | How |
|---|---|
| **Cursor** | Copy into a `.mdc` file under `.cursor\rules\` |
| **Cline / Roo Code** | Put into `.clinerules` at the project root |
| **Claude Projects** | Paste into Project instructions; upload templates as knowledge |
| **ChatGPT custom GPT** | Paste SKILL.md into Instructions |
| **Web ChatGPT / Doubao** | Paste SKILL.md at the start of every conversation |

---

## What is in the download

After extracting the ZIP:

```
dsh-skill-literature-reading/
│
├─ skills/        ⭐ The skill itself. The only folder that matters
│  └─ literature-reading/
│     ├─ SKILL.md          Main instructions the model follows
│     └─ references/       5 templates (config, cards, glossary, onboarding)
│
├─ install/       ⭐ Installer. Double-click install.cmd
│  ├─ install.cmd          Windows entry point
│  └─ install.ps1          Actual install logic
│
├─ example/       📖 Examples. Shows what a filled-in setup looks like
│  ├─ .literature/config.md   Example config
│  ├─ cards/00-index.md       Example card index
│  ├─ papers/                 PDF folder (empty)
│  └─ links.md                Example link registry
│
├─ docs/          📚 Documentation
│  ├─ manual.md            Full manual (cards, profile growth)
│  ├─ design.md            Design notes and diagrams
│  └─ files.md             What each file does (for maintainers)
│
├─ README.zh.md   📄 Chinese version
├─ README.md      This file
├─ QUICKSTART.md  Install guide (Chinese)
│
├─ package.json        Optional. Only for npm install
├─ cordis.patch.yml    Optional. Only for plugin install
├─ LICENSE             MIT
└─ .gitignore          Keeps personal data out of the repo
```

### What you actually need

| You want to | Use |
|---|---|
| **Install the skill** | `install/` (double-click) or `skills/` (manual copy) |
| **See an example setup** | `example/` |
| **Read the docs** | `docs/` |
| **Ignore everything else** | `package.json`, `cordis.patch.yml` |

> ⚠️ **Do not edit files under `example/`** — they are samples.
> Your real config is generated when the skill first interviews you, at `<project>/.literature/config.md`.

---

## Usage

### Two ways to start

**Both work, but they behave differently.**

#### Option 1: self-check first (recommended)

```
You: 文献阅读
   ↓
It:  📋 status card (config / stage / four paths)
   ↓
You: read this paper + PDF
```

**Why**: it confirms the environment. A missing config, a wrong path, or a stale skill version shows up **immediately** instead of halfway through a paper.

```
📋 文献阅读 · 状态

Config    ✅ .literature/config.md
Stage     0 beginner | 3 papers read | context: last 3

PDFs      ✅ papers/
Cards     ✅ cards/
Index     ✅ cards/00-index.md
Links     ✅ links.md

Next: say "read this paper" and attach the PDF
```

#### Option 2: just send the paper

```
You: read this paper + PDF
```

**It handles this too**, in this order:

```
① Archive first (the PDF is saved, you are told where)
② No config found → asks three rounds of questions
③ Config created → asks "read this paper now?"
```

**Why archive first**: if you close the conversation, the paper is not lost.

**But it costs two extra steps** — the paper you sent sits idle until you finish answering.

### First-time advice

**On your first run, use Option 1:**

```
1. Say 文献阅读
2. See "config missing" in the status card
3. Answer the three rounds
4. See "✓ config created"
5. Then send the paper
```

After that, either option is fine.

> **Design goal**: any opening works. The fixed phrase is an optimisation, not a requirement.

### First run: create a config

If `.literature/config.md` is missing, the skill asks three questions and generates one.

Or copy the template manually:

```bash
mkdir -p .literature
cp node_modules/dsh-skill-literature-reading/skills/literature-reading/references/config-template.md .literature/config.md
```

A minimal config is three lines:

```markdown
**Core direction**: Edge computing, deployment
**Current stage**: 0 beginner
**Paper path**: ./papers/
```

### Everyday use

```
You: read this paper
     [attach PDF]
     ↓
AI: 📥 Archived: papers/CORE-001-xxx.pdf
    This is a core-direction paper (CORE-).
    [1] What do you want?  [2] How deep?  [3] Where to start?
     ↓
You: b, standard, from the top
     ↓
AI: [A + B] Continue?
     ↓
You: continue / skip E / expand D
```

When done:

```
You: make a card
     ↓
AI: writes card → updates index → updates config
```

---

## Permissions

### What it needs

**Only read/write access to your own project folder.**

| Operation | Scope | Extra approval |
|---|---|---|
| Read config / index / cards / PDFs | Inside your project | ❌ |
| Create cards, update index | Inside your project | ❌ |
| Copy a PDF into `papers/` | Source: wherever you point<br>Target: inside project | ❌ (usually) |
| Create directories | Inside project | ❌ |

A global install (`~/.agents/skills/`) needs one write during the installer. Nothing after that.

### What it will never do

| ❌ Never | Why it matters |
|---|---|
| Modify your original PDF | Your source files are never renamed, moved or deleted |
| Touch files outside the project | It does not scan your other folders |
| Install software / change system settings | Text operations only |
| Change file permissions | No `chmod` / `icacls` style operations |
| Delete your files | Including ones that "look useless" |

### When permission is denied

```
⚠️ Write failed: F:\my-papers\PDF (access denied)

Possible causes:
  1. The directory is locked by another program
  2. Your user lacks write permission
  3. The path does not exist and cannot be created

Fall back to the default path ./papers/?
```

**It stops and tells you instead of working around it.**

> ⚠️ **An "access denied" from the tool is a policy refusal, not a bug.**
> Change the path or grant access manually. **Do not try to fix permissions** — that usually makes it worse.

### A real case

Someone kept the project at `F:\文献阅读` while DSH's workspace was elsewhere, so the sandbox refused writes. The agent attempted two permission repairs. It worked in the end, but:

- it cost extra time
- it left a test file that could not be deleted
- the user had no idea what had been changed

**The better setup**: make the project folder the DSH workspace. Permissions then line up by construction.

---

## Layout

Your project after setup:

```
your-project/
├─ .literature/
│  └─ config.md              ← your direction, level, accumulated knowledge
├─ papers/                   ← PDFs
│  └─ CORE-001-xxx.pdf
├─ cards/                    ← paper cards
│  ├─ 00-index.md
│  └─ CORE-001-xxx.md
└─ links.md                  ← link registry
```

The skill itself:

```
dsh-skill-literature-reading/
├─ skills/
│  └─ literature-reading/
│     ├─ SKILL.md
│     └─ references/
│        ├─ config-template.md
│        ├─ card-template.md
│        ├─ card-template-lite.md
│        └─ glossary.md
├─ cordis.patch.yml
└─ package.json
```

---

## Documentation

| Document | Content |
|---|---|
| [QUICKSTART.md](QUICKSTART.md) | 5-minute setup (Chinese) |
| [docs/manual.md](docs/manual.md) | Full manual with troubleshooting (Chinese) |
| [docs/design.md](docs/design.md) | Architecture diagrams |
| [docs/files.md](docs/files.md) | What each file does |

---

## Customization

The skill is pure Markdown. Edit `SKILL.md` and restart.

| Want to change | Edit |
|---|---|
| Output sections | "Nine sections" in `SKILL.md` |
| Classification rules | "Determine the class" in `SKILL.md` |
| The questions asked | "Ask three things" in `SKILL.md` |
| Card format | `references/card-template.md` |
| Glossary | `references/glossary.md` |

---

## Philosophy

1. **The model de-scales, structures, translates, critiques, extends; you judge.** Judgment cannot be outsourced.
2. **The "my judgment" section of a card must be written by you.** If the model writes it, you have "seen" the paper, not "read" it.
3. **The model's output reads fluently and will make you think you understood.** The only antidote: a few days later, close everything and restate the paper in three sentences.

---

## License

MIT
