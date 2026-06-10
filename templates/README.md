# 🧩 Documentation Templates

Reusable starting points so every doc in this repo has a **consistent, navigable
structure**. Copy a template, fill in the `<PLACEHOLDER>`s, delete the guidance
comment at the top, and run `make lint`.

## Contents

- [Available templates](#available-templates)
- [Conventions (the house style)](#conventions-the-house-style)
- [If you are an LLM](#if-you-are-an-llm)
- [If you are a human](#if-you-are-a-human)

## Available templates

| Template | Use it for | Copy to |
|----------|-----------|---------|
| [lab.md](lab.md) | A hands-on Console/CLI walkthrough | `labs/<service>/NN_<slug>.md` |
| [cheatsheet.md](cheatsheet.md) | A one-screen service summary | `cheatsheets/<service>.md` |
| [exam-question.md](exam-question.md) | Practice questions with reasoning | `exam_practices/<EXAM>/<topic>.md` |
| [note.md](note.md) | A general structured note | anywhere |

## Conventions (the house style)

- **One `#` H1 title** per file, on the first line (emoji is fine in the title).
- **Plain-text section headings** (`## Objectives`, not `## 🎯 Objectives`) whenever
  the doc has a **Contents** TOC — this keeps the anchor links stable. Cheatsheets
  have no TOC, so they keep their emoji headings.
- **Add a Contents TOC** when a doc has **4+ sections**; shorter docs use just the
  breadcrumb + metadata line.
- **Breadcrumb** back to the section index near the top:
  `[← Labs index](../README.md)`.
- **Metadata line** for labs: `Service · Level · Est. time · Est. cost`.
- **Every lab ends with a `## Cleanup` section** listing how to delete billable
  resources.
- **Redact** account IDs, CloudFront distribution IDs, and personal bucket names
  from commands, policy JSON, and screenshots.
- Screenshots live in `labs/shared_assets/<service>/` and are embedded with
  **relative** paths.
- Run **`make lint`** before committing — markdownlint validates the TOC anchors.

## If you are an LLM

Follow this exactly when asked to add or edit a doc:

1. **Pick the template** that matches the doc type (table above) and read it fully.
2. **Copy it** to the correct path, replace **every** `<PLACEHOLDER>`, and delete the
   `<!-- ... -->` guidance comment.
3. **Preserve the section order and heading text** so the Contents anchors stay valid.
4. If you add or rename a section, **update the Contents TOC** to match. GitHub anchors
   are lowercase with spaces turned into hyphens and punctuation removed.
5. Keep additions **factual** — do not invent metrics, costs, screenshots, or links.
6. **Register the new doc** in the relevant index (`labs/README.md`,
   `cheatsheets/README.md`, `exam_practices/README.md`, ...).
7. Run `make lint` (or `pre-commit run markdownlint-cli2 --all-files`) and fix every
   finding before finishing.

## If you are a human

Copy the file, fill it in, delete the comment, preview it on GitHub, and link it from
the section's `README.md`. Run `make lint` and you're done.
