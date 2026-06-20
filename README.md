# AI Skills Directory

Coleccion de skills para asistentes de codigo basados en IA. Cada skill es un archivo `SKILL.md` con instrucciones detalladas que el modelo sigue para realizar tareas especificas.

## Skills disponibles

| Skill | Descripcion |
|---|---|
| **formal-email** | Redacta correos formales/profesionales en multiples idiomas y tonos |
| **pdf-doc** | Genera documentos markdown listos para convertir a PDF con pandoc (formato APA) |
| **presenterm** | Crea presentaciones de terminal con [presenterm](https://github.com/mfontanini/presenterm) |
| **slides** | Genera presentaciones de terminal con [slides](https://maaslalani.com/slides/) |
| **llm-wiki** | Construye y mantiene una wiki de conocimiento estilo Karpathy en Obsidian |

## Estructura de un skill

```
skills/
  nombre-del-skill/
    SKILL.md          # Instrucciones para el modelo (requerido)
    ...               # Archivos auxiliares (templates, ejemplos, etc.)
```

Cada `SKILL.md` usa frontmatter YAML con `name` y `description`. El resto del archivo contiene las instrucciones detalladas que el modelo de IA ejecuta.

## Instalacion por plataforma

### OpenCode

Coloca las carpetas de skills en `~/.config/opencode/skills/`. OpenCode las descubre automaticamente mediante el frontmatter de cada `SKILL.md`.

```bash
git clone https://github.com/tu-user/ai-skills.git /tmp/ai-skills
cp -r /tmp/ai-skills/* ~/.config/opencode/skills/
```

### Claude Code

Claude Code soporta comandos personalizados via archivos `.md` en `.claude/commands/`. Copia el contenido de `SKILL.md` como un comando:

```bash
# Crear un comando a partir de un skill
mkdir -p .claude/commands
cp skills/formal-email/SKILL.md .claude/commands/formal-email.md
# Uso: /formal-email
```

Alternativamente, incluye las instrucciones directamente en tu `CLAUDE.md`.

### Gemini CLI

Gemini CLI usa `.gemini/commands/` para comandos personalizados:

```bash
mkdir -p .gemini/commands
cp skills/pdf-doc/SKILL.md .gemini/commands/pdf-doc.md
# Uso: /pdf-doc
```

Tambien podes incluir las instrucciones en `GEMINI.md` como contexto persistente.

### GitHub Copilot / Cursor

Copia el contenido relevante en `.cursor/rules/` o en `.github/copilot-instructions.md`:

```bash
mkdir -p .cursor/rules
cp skills/slides/SKILL.md .cursor/rules/slides.md
```

### ChatGPT / Claude.ai (Projects)

En proyectos de ChatGPT o Claude.ai, copia el contenido de `SKILL.md` en las instrucciones personalizadas del proyecto (Custom Instructions / Project Knowledge).

## Crear un skill nuevo

1. Crea una carpeta: `mkdir skills/mi-skill`
2. Crea `SKILL.md` con frontmatter YAML:

```markdown
---
name: mi-skill
description: Descripcion clara de cuando usar este skill
---

# Titulo del skill

Instrucciones detalladas paso a paso para el modelo...
```

3. En OpenCode, el skill se cargara automaticamente. En otras plataformas, copialo como comando o instruccion personalizada.

## Contribuir

Los skills se mejoran con el uso. Si encontras mejoras, editá el `SKILL.md` correspondiente y enviá un PR.
