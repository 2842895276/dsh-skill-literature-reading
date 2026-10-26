# Literature Reading Skill

Understand a paper first, explore details as needed, and save progress with a learner profile that adapts to confirmed feedback.

English | [中文](README.zh.md)

## Features

- A beginner-friendly overview before optional method, evidence, novelty or reproduction branches. No mandatory onboarding questionnaire.
- Natural-language controls: continue, give an example, expand, skip, summarize, save and pause.
- CORE / REL / METH classification with independent identifiers; any category can be read in depth.
- Confirmed concepts, open questions and explanation preferences inform future saved sessions. Paper counts never automatically promote a learning stage.
- Chinese-first, bilingual or original-language titles. Translations are labeled; original titles remain available for retrieval and deduplication.
- No historical cards by default (N=0), conditional reference loading and incremental notes.

## Getting started

Provide the complete `skills/literature-reading/` directory to an assistant with local file access, ask it to read `SKILL.md`, and confirm access to the actual literature project directory. Keep `references/`: the entry point alone does not contain the saving and growth procedures. File access and automatic skill discovery depend on the client.

The existing DSH installer remains available at `install/install.cmd`; manual project installation copies the complete skill directory into `.dsh/skills/`. See the [setup guide](QUICKSTART.md).

```text
Read this paper and explain the problem first. [attach PDF]
Give me an example of the method.
Use Chinese paper titles from now on.
Save my progress and pause.
```

Reading can start without a configuration. Initialize or save explicitly to create one. Summarizing or pausing alone does not write files. A new conversation resumes from saved progress, not an assumed memory of earlier chats.

## Saving and learning

Saving checks identifiers and original titles, reuses an existing card for the same paper, and preserves personal judgments. Cards can be partial and grow as reading progresses. Feedback affects the current conversation immediately; saved or explicitly updated preferences carry into later sessions. Learning stages require confirmation, and concepts can return to “needs reinforcement.”

Data stays within the confirmed project boundary. Original papers are not modified. Root-level personal data directories are excluded by `.gitignore`; `example/` contains samples only.

## Documentation

[User guide](docs/manual.md) · [Design](docs/design.md) · [File map](docs/files.md) · [Changelog](CHANGELOG.md) · [Review record](docs/interaction-review.md)

Validation currently covers static checks and scenario walkthroughs. Actual PDF extraction and cross-session recovery still need a client-level trial. Character reductions are not measured token savings.

DSH package metadata is retained. These working-tree updates have not been published as a new npm version. MIT license.
