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

Every generated `.md` file MUST include this exact YAML header. When the document includes a custom LaTeX cover page (via `\thispagestyle{empty}`), **omit `title`, `subtitle`, `author`, `date`, `institute`, and `course`** — pandoc otherwise generates a duplicate automatic title page before the cover. Keep only the typography and layout keys.

```yaml
---
fontsize: 11pt
mainfont: "Liberation Serif"
geometry: margin=2.5cm
header-includes:
  - \usepackage{float}
  - \floatplacement{figure}{H}
  - \usepackage{graphicx}
  - \usepackage{titlesec}
  - \usepackage{setspace}
  - \usepackage{indentfirst}
  - \usepackage{enumitem}
  - \setlist{nosep,itemsep=0pt,parsep=0pt,leftmargin=\parindent}
  - \AtBeginEnvironment{itemize}{\singlespacing}
  - \AtBeginEnvironment{enumerate}{\singlespacing}
  - \doublespacing
  - \setlength{\parindent}{1.27cm}
  - \widowpenalty=10000
  - \clubpenalty=10000
  - \titleformat{\section}{\normalfont\fontsize{14}{15}\bfseries}{\thesection}{1em}{}
  - \titleformat{\subsection}{\normalfont\fontsize{13}{14}\bfseries}{\thesubsection}{1em}{}
  - \titleformat{\subsubsection}{\normalfont\fontsize{12}{13}\bfseries}{\thesubsubsection}{1em}{}
---
```

### Formatting rules explained

| Rule | Purpose |
|---|---|
| `fontsize: 11pt` | Body text size |
| `mainfont: "Liberation Serif"` | Metrically compatible with Times New Roman. Check available fonts with `fc-list \| grep -i serif` and fall back to `DejaVu Serif` if needed |
| `geometry: margin=2.5cm` | Standard academic margins |
| `\doublespacing` | Double spacing for APA/readability |
| `\setlength{\parindent}{1.27cm}` | First-line paragraph indent (standard APA) |
| `\widowpenalty=10000` | Prevents widow lines (last line of paragraph alone at top of page) |
| `\clubpenalty=10000` | Prevents orphan lines (first line of paragraph alone at bottom of page) |
| `\titleformat{\section}{...}{14}{15}...` | H1 at 14pt |
| `\titleformat{\subsection}{...}{13}{14}...` | H2 at 13pt |
| `\titleformat{\subsubsection}{...}{12}{13}...` | H3 at 12pt — same size as body but bold/structured |
| `\usepackage{float}` | Better float (figure/table) placement |
| `\floatplacement{figure}{H}` | Force figures to appear exactly where defined in source (prevents image reordering) |
| `\usepackage{graphicx}` | Image support |
| `\usepackage{titlesec}` | Custom heading formatting |
| `\usepackage{setspace}` | Line spacing control |
| `\usepackage{indentfirst}` | Indents first paragraph after every section heading |
| `\usepackage{enumitem}` | Fine-grained control over list layout |
| `\setlist{...,leftmargin=\parindent}` | Removes extra spacing between list items and aligns bullet margin with paragraph indent |
| `\AtBeginEnvironment{itemize/enumerate}{\singlespacing}` | Forces single spacing inside lists despite `\doublespacing` |

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

After writing the `.md` file, instruct the user to run:

```bash
pandoc documento.md -o documento.pdf --pdf-engine=pdflatex -V lang=es -N
```

Flags explained:
- `--pdf-engine=pdflatex` — Use LaTeX engine
- `-V lang=es` — Spanish hyphenation and labels (change to `en`, `pt`, etc.)
- `-N` — Number sections (1, 1.1, 1.1.1)

**Do NOT use `--toc`**. The TOC is already in the body via `\tableofcontents`.

## Quality Checklist

Before finalizing the `.md` file, verify:

- [ ] YAML frontmatter includes all header-includes rules
- [ ] Cover page uses `\thispagestyle{empty}` and `\newpage`
- [ ] `\tableofcontents` is after cover page, NOT via `--toc` flag
- [ ] Heading hierarchy: H1 > H2 > H3 >= body (13 > 12 > 11 = 11pt)
- [ ] Widow/orphan penalties set to 10000
- [ ] Double spacing enabled
- [ ] Images have width constraints
- [ ] Bibliography formatted consistently (if present)
- [ ] The `\newpage` before `\tableofcontents` and after cover page is present
