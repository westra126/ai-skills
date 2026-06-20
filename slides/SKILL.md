---
name: slides
description: >-
  Generate terminal-based presentations as markdown files compatible with
  maaslalani/slides (https://maaslalani.com/slides/). Use when the user asks
  to create a presentation, slide deck, slides, or talk on any topic. Also
  use when asked to convert content into a slides-compatible markdown file.
  Produces two files: the presentation .md and a speaker-notes .md. Not for
  PowerPoint, Keynote, or reveal.js formats.
---

# Slides — Terminal Presentation Generator

Generate markdown presentations compatible with [maaslalani/slides](https://maaslalani.com/slides/) and a companion speaker notes document.

## Slides format reference

The `slides` CLI reads a single markdown file. Key rules:

- **Slide separator**: a line containing only `---` (YAML horizontal rule) splits slides.
- **Frontmatter** (optional, first slide only): YAML block delimited by `---` with fields `theme`, `author`, `date`, `paging`.
- **Content**: standard markdown — headings, lists, code blocks, images, tables, blockquotes.
- **Code execution**: fenced code blocks can be executed in-slide with `Ctrl+E`.
- **Pre-processing**: code blocks with `~~~` (tildes) run a command before display and replace the block with stdout.

### Frontmatter fields

| Field    | Description                                                                 | Default             |
|----------|-----------------------------------------------------------------------------|---------------------|
| `theme`  | Path or URL to a [glamour theme](https://github.com/charmbracelet/glamour/tree/master/styles) JSON | built-in            |
| `author` | String shown bottom-left of each slide                                      | OS username         |
| `date`   | Format string: `YYYY`=year, `MMMM`=month, `DD`=day                         | `YYYY-MM-DD`        |
| `paging` | `%d` directives: first = current slide, second = total. Quote if starts with `%` | `Slide %d / %d` |

## Workflow

When the user requests a presentation:

### 1. Gather requirements

Ask the user (or infer from context) for:

- **Topic / title** of the presentation
- **Audience** (technical, executive, general)
- **Approximate number of slides** (default: 8-12)
- **Language** of the content (match the user's language)
- **Author name** for the frontmatter
- **Any specific sections or points** to cover
- **Output directory** (default: current working directory)

### 2. Plan the slide outline

Before writing, produce a brief outline:

```
Slide 1: Title slide — title, subtitle, author, date
Slide 2: Agenda / overview
Slide 3-N: Content slides (one idea per slide)
Slide N+1: Summary / key takeaways
Slide N+2: Q&A / closing slide
```

Confirm the outline with the user before generating files.

### 3. Generate the presentation file

File: `<slug>-slides.md` (e.g., `intro-to-rust-slides.md`)

Structure:

```markdown
---
author: <Author Name>
date: YYYY-MM-DD
paging: Slide %d / %d
---

# <Presentation Title>
## <Subtitle or tagline>

---

## Agenda

* Topic one
* Topic two
* Topic three

---

## <Slide Title>

<Content: bullet points, paragraphs, code blocks, tables, etc.>

---

## <Next Slide Title>

<Content>

---

# Thank you!

Questions?
```

Rules for slide content:

- **One idea per slide.** If a slide has more than 5-6 bullet points, split it.
- **Use headings** (`##` for slide titles, `#` only for the title slide).
- **Keep text concise.** Terminal screens are small — aim for < 15 lines of content per slide.
- **Code blocks** should specify a language for syntax highlighting.
- **Tables** work well for comparisons.
- **Blockquotes** for emphasis or citations.
- **No HTML** — slides renders markdown only.
- **Images** are not reliably rendered in terminal; prefer ASCII diagrams, tables, or code blocks instead.
- **The first `---` after frontmatter** starts slide 2. The frontmatter block itself is part of slide 1.

### 4. Generate the speaker notes file

File: `<slug>-notes.md` (e.g., `intro-to-rust-notes.md`)

Structure:

```markdown
# Speaker Notes: <Presentation Title>

> Companion notes for `<slug>-slides.md`

---

## Slide 1: <Title>

<What to say. Key talking points, anecdotes, data to mention.
Timing suggestion: ~1 min>

---

## Slide 2: <Title>

<Talking points for this slide.
Include transitions to the next slide.
Timing suggestion: ~2 min>

---

## Slide N: <Title>

<Talking points.
Timing suggestion: ~1 min>

---

## General Notes

- **Total estimated time**: ~X minutes
- **Key transitions**: ...
- **Anticipated questions**: ...
- **Backup slides** (if any): ...
```

Rules for speaker notes:

- **One section per slide**, numbered and titled to match the slides file.
- **Talking points**, not a script — bullet points the presenter can glance at.
- **Timing suggestions** per slide (rough estimates).
- **Transitions** — how to move naturally from one slide to the next.
- **Anticipated questions** section at the end with suggested answers.
- **Total time estimate** in the General Notes section.

### 5. Present the output

After generating both files, tell the user:

- The paths to both files
- How to present: `slides <slug>-slides.md`
- That the notes file is a companion document to keep open on a second screen or printed

## Example

Given the request: "Create a 5-slide presentation about Git branching strategies"

**`git-branching-slides.md`:**

```markdown
---
author: Jane Doe
date: 2026-06-10
paging: Slide %d / %d
---

# Git Branching Strategies
## Keep your repository clean and your team aligned

---

## Agenda

* Why branching matters
* Trunk-based development
* Git Flow
* GitHub Flow
* Choosing the right strategy

---

## Why Branching Matters

* Isolates work in progress
* Enables parallel development
* Protects the main branch
* Facilitates code review

---

## Trunk-Based Development

* Short-lived feature branches (< 1 day)
* Frequent merges to main
* Feature flags for incomplete work
* Best for: small teams, CI/CD mature projects

---

# Thank you!

Questions?
```

**`git-branching-notes.md`:**

```markdown
# Speaker Notes: Git Branching Strategies

> Companion notes for `git-branching-slides.md`

---

## Slide 1: Title

Introduce yourself. Mention that branching strategy is one of the most
impactful decisions a team makes. ~30s

---

## Slide 2: Agenda

Quickly walk through the topics. Set expectation: practical advice,
not theory. ~30s

---

## Slide 3: Why Branching Matters

Ask the audience: "How many of you have had a merge conflict that
blocked a release?" Use the response to motivate the topic. ~2 min

---

## Slide 4: Trunk-Based Development

Emphasize the CI/CD maturity requirement. Mention Google and Facebook
as examples. Warn about the learning curve. ~3 min

---

## Slide 5: Closing

Open the floor for questions. Have examples ready for "which strategy
for monorepos?" ~1 min

---

## General Notes

- **Total estimated time**: ~7 minutes + Q&A
- **Key transitions**: each strategy builds on "why branching matters"
- **Anticipated questions**: monorepos, release branches, hotfix workflows
```

## Tips

- Match the **user's language** for all content (slides and notes).
- For technical talks, include **code examples** in slides — they render beautifully in the terminal.
- For executive audiences, favor **tables and comparisons** over bullet lists.
- Always include a **closing/Q&A slide**.
- If the user provides a file or URL as source material, read it first and extract key points for the slides.
