---
name: pdf-doc
description: Generate PDF-ready markdown documents with professional formatting (APA-style), hierarchical headings, widow/orphan control, and proper cover page. Use when the user asks to create a document, report, paper, academic work, entregable, informe, práctica, or wants to convert markdown to PDF with pandoc.
---

# PDF-Ready Markdown Document Generator

Use this skill to generate `.md` files that are ready to be converted to PDF with `pandoc` + `pdflatex`. The output follows academic/professional formatting conventions.

## Dependencies

The user must have installed:
- `pandoc` (≥3.x)
- `pdflatex` (TeX Live or similar)
- A serif font available (Liberation Serif, Times New Roman, or DejaVu Serif)

## YAML Frontmatter Template

Every generated `.md` file MUST include this exact YAML header. Only skip `title`, `subtitle`, `author`, `date`, `institute`, and `course` if they are truly not applicable — but always include them as commented lines so the user can fill them in.

```yaml
---
title: "Título del Documento"
subtitle: "Subtítulo (opcional)"
author: ""
date: "DD de mes, AAAA"
institute: "Institución"
course: "Código — Nombre del Curso"
fontsize: 11pt
mainfont: "Liberation Serif"
geometry: margin=2.5cm
header-includes:
  - \usepackage{float}
  - \usepackage{graphicx}
  - \usepackage{titlesec}
  - \usepackage{setspace}
  - \usepackage{needspace}
  - \raggedbottom
  - \doublespacing
  - \widowpenalty=10000
  - \clubpenalty=10000
  - \titleformat{\section}{\normalfont\fontsize{13}{15}\bfseries}{\thesection}{1em}{}
  - \titleformat{\subsection}{\normalfont\fontsize{12}{14}\bfseries}{\thesubsection}{1em}{}
  - \titleformat{\subsubsection}{\normalfont\fontsize{11}{13}\bfseries}{\thesubsubsection}{1em}{}
---
```

### Formatting rules explained

| Rule | Purpose |
|---|---|
| `fontsize: 11pt` | Body text size |
| `mainfont: "Liberation Serif"` | Metrically compatible with Times New Roman. Check available fonts with `fc-list \| grep -i serif` and fall back to `DejaVu Serif` if needed |
| `geometry: margin=2.5cm` | Standard academic margins |
| `\doublespacing` | Double spacing for APA/readability |
| `\widowpenalty=10000` | Prevents widow lines (last line of paragraph alone at top of page) |
| `\clubpenalty=10000` | Prevents orphan lines (first line of paragraph alone at bottom of page) |
| `\raggedbottom` | Prevents LaTeX from stretching inter-paragraph glue to fill pages, which causes orphaned headings |
| `\usepackage{needspace}` | Required for the needspace Lua filter below |
| `\titleformat{\section}{...}{13}{15}...` | H1 at 13pt |
| `\titleformat{\subsection}{...}{12}{14}...` | H2 at 12pt |
| `\titleformat{\subsubsection}{...}{11}{13}...` | H3 at 11pt — same size as body but bold/structured |
| `\usepackage{float}` | Better float (figure/table) placement |
| `\usepackage{graphicx}` | Image support |
| `\usepackage{titlesec}` | Custom heading formatting |
| `\usepackage{setspace}` | Line spacing control |

**Font detection rule:** Before writing the YAML, check available serif fonts. Priority order: `Liberation Serif` > `Times New Roman` > `DejaVu Serif`.

## Document Structure

The generated markdown MUST follow this exact order:

### 1. Cover page

```markdown
\thispagestyle{empty}
\begin{center}
\vspace*{3cm}
{\LARGE \textbf{Título Principal}}\\[1cm]
{\Large \textbf{Subtítulo}}\\[1cm]
{\large \textbf{Título secundario (opcional)}}\\[2cm]
{\large \textbf{Institución}}\\
{\large Escuela o Facultad}\\
{\large Código y Curso}\\
{\large Sección — Período}\\[1cm]
{\large Docente: Nombre del profesor}\\[2cm]
{\large Fecha}
\end{center}
\newpage
```

**Rules for the cover page:**
- ALWAYS wrap it in `\thispagestyle{empty}` to hide the page number
- Use `\vspace*{3cm}` for top margin
- Use `\\[Xcm]` for vertical spacing between elements
- `\newpage` at the end MUST come before `\tableofcontents`
- Cover page does NOT count in `\tableofcontents`

### 2. Table of contents

```markdown
\tableofcontents
\newpage
```

**Critical rule:** NEVER use pandoc's `--toc` flag. The `--toc` flag inserts the TOC before the YAML body content, which puts it before the cover page. Always use `\tableofcontents` inline in the markdown body after the cover page.

### 3. Content sections

Use standard markdown headings:
- `#` → H1 (14pt, section)
- `##` → H2 (13pt, subsection)
- `###` → H3 (12pt, subsubsection)

### 4. Bibliography (if applicable)

```markdown
# Bibliografía

Author, A. (AAAA). *Title in italics*. Publisher. URL
```

Use hanging indent style. Wrap each reference in a paragraph.

## Images

Always use relative paths and add a width constraint:

```markdown
![Alt text](path/to/image.png){width=90%}
```

For diagrams wider than the page, use `{width=85%}` or smaller.
Add `\newpage` before or after large images to prevent awkward page breaks.

## PDF Generation Command

After writing the `.md` file, you MUST also write a `needspace.lua` filter file alongside it, and instruct the user to run:

```bash
pandoc documento.md -o documento.pdf --pdf-engine=pdflatex -V lang=es -N
```

Flags explained:
- `--pdf-engine=pdflatex` — Use LaTeX engine
- `-V lang=es` — Spanish hyphenation and labels (change to `en`, `pt`, etc.)
- `-N` — Number sections (1, 1.1, 1.1.1)

**Do NOT use `--toc`**. The TOC is already in the body via `\tableofcontents`.

### needspace.lua filter

Alongside every `.md` file, write a `needspace.lua` file with this content:

```lua
function Header(el)
  local space = 4
  if el.level == 3 then
    space = 3
  elseif el.level == 2 then
    space = 4
  elseif el.level == 1 then
    space = 5
  end
  return {
    pandoc.RawBlock('latex', '\\needspace{' .. space .. '\\baselineskip}'),
    el
  }
end
```

This filter forces a page break before any heading that would end up at the bottom of a page with fewer than `space` lines of content following it. H3 requires 3 lines, H2 requires 4, H1 requires 5.

This only works for real Markdown headings (`#`, `##`, `###`), not for inline bold labels.

## Orphaned Bold Labels → H3 Conversion

**Symptom:** Lines like `**Alternativas consideradas:**` or `**Relación con otros componentes:**` appear alone at the bottom of a page with their content on the next page.

**Root cause:** These are inline bold text, not headings. LaTeX does not protect them from page breaks. The needspace filter has no effect on them.

**Solution:** Convert any standalone bold label that acts as a section divider into a real `###` heading. Example:

```markdown
## Before
**Alternativas consideradas:** Se consideraron las siguientes...

## After  
### Alternativas consideradas

Se consideraron las siguientes...
```

This applies to patterns like:
- `**Nombre del componente:**` → `### Nombre del componente`
- `**Responsabilidad principal:**` → `### Responsabilidad principal`  
- `**Entradas y salidas principales:**` → `### Entradas y salidas principales`
- `**Relación con otros componentes:**` → `### Relación con otros componentes`
- `**Razón de separación:**` → `### Razón de separación`
- `**Título:**` → `### Título`
- `**Estado:**` → `### Estado`
- `**Contexto:**` → `### Contexto`
- `**Decisión tomada:**` → `### Decisión tomada`
- `**Alternativas consideradas:**` → `### Alternativas consideradas`
- `**Consecuencias:**` → `### Consecuencias`

Once converted to real headings, the needspace filter protects them from being orphaned.

Do NOT convert list-item italic labels like `*Positivas:*` or `*Entradas:*` — these are within list items and semantically subordinate to their parent section.

## Quality Checklist

Before finalizing the `.md` file, verify:

- [ ] YAML frontmatter includes `\usepackage{needspace}`, `\raggedbottom`, and all header-includes rules
- [ ] Cover page uses `\thispagestyle{empty}` and `\newpage`
- [ ] `\tableofcontents` is after cover page, NOT via `--toc` flag
- [ ] Heading hierarchy: H1 > H2 > H3 >= body (13 > 12 > 11 = 11pt)
- [ ] Widow/orphan penalties set to 10000
- [ ] Double spacing enabled
- [ ] All standalone bold labels converted to `###` headings (never leave `**Label:**` as inline bold)
- [ ] `needspace.lua` filter file exists alongside the `.md` file
- [ ] Pandoc command includes `--lua-filter=needspace.lua`
- [ ] Images have width constraints
- [ ] Bibliography formatted consistently (if present)
- [ ] The `\newpage` before `\tableofcontents` and after cover page is present
