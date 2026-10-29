# Literature Reading Skill

Understand a paper first, explore details as needed, and save progress with a learner profile that adapts to confirmed feedback.

Optional thinking interaction supports direct explanation, light prompts, or deeper discussion of alternatives, evidence and research questions. Prompts are skippable; answers do not automatically save notes or change ability levels.

English | [中文](README.zh.md)

## Features

- Both paper uploads and reading commands first offer profile/preferences setup or reuse of current settings. Setup is optional; choose a reading mode before analysis unless already specified. Explanations retain the necessary reasoning and evidence rather than a fixed word limit.
- Natural-language controls: continue, give an example, expand, skip, summarize, save and pause.
- CORE / REL / METH classification with independent identifiers; any category can be read in depth.
- Optional background interview or learning about the reader through paper discussion (default); the assistant maintains the profile, with no manual file editing.
- Confirmed concepts, open questions and explanation preferences inform future saved sessions. Paper counts never automatically promote a learning stage.
- Chinese-first, bilingual or original-language titles. Translations are labeled; original titles remain available for retrieval and deduplication.
- No historical cards by default (N=0), conditional reference loading and incremental notes.
- Reading preferences expose history settings, with a one-time optional prompt once another paper card exists. Temporary overrides and persistent settings are separate; N limits automatic history only, not explicit comparisons.
- User-selected knowledge cards for terms, concepts, tools and methods: save explanations and usage, retrieve by name or alias, and extend existing cards with paper-specific context. Cards live in `knowledge/` and link to saved papers; creating or viewing one does not imply mastery or increase paper counts.

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

Current repository version: **0.4.0 / 1029** (2026-10-29). See the [changelog](CHANGELOG.md). DSH package metadata is retained; a repository update does not imply an npm publication. MIT license.

The Windows installer supports Codex and DSH, with project or user scope. See [Quickstart](QUICKSTART.md) for paths and activation checks.

Saving supports manual, end/switch reminders (new-user default), and explicitly enabled automatic progress checkpoints. Existing preferences remain unchanged. Source archiving is separate. Research tracks stay in paper cards and can be retrieved by name or keyword beyond the automatic history limit N.

## Temporary files and cleanup

PDF extraction may create text and page-image caches. After ending a paper or switching papers, once all required saves have succeeded, the assistant cleans only files created by the current task that are not referenced by notes. Pausing, save/archive failures, or a request to retain caches skips cleanup. Original papers, personal records, and unidentified older caches are retained. This is workflow-triggered cleanup, not a background timer, and remains subject to tool permissions.

To update an installed copy, rerun the installer for the same platform and project path, then start a new conversation. Editing the source checkout alone does not update installed skills.
