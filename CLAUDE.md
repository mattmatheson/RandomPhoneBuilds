# RandomPhoneBuilds — Claude Instructions

This repo hosts HTML/XML research documents on GitHub Pages at:
**https://mattmatheson.github.io/RandomPhoneBuilds/**

The homepage auto-discovers all project folders using the GitHub API — no manual index updates needed.

## When Matt asks to upload/publish/add a new HTML document:

Follow these steps exactly:

### 1. Choose a folder name
- Ask Matt what to name it, or derive a short, descriptive kebab-case or snake_case name from the topic
- Example: `crt-signal-research`, `ai_agent_overview`, `guitar-pedal-guide`

### 2. Create the folder and add files
- Create a new folder at the repo root with that name
- Put the HTML file(s) inside as `index.html` (and any supporting files)
- The HTML should be fully self-contained (inline CSS, no external dependencies beyond Google Fonts or CDN links)
- Give the `<title>` tag a clear, descriptive name — the homepage reads it and displays it automatically

### 3. Commit and push to main
```
git add FOLDER_NAME/
git commit -m "Add FOLDER_NAME: short description"
git push origin main
```

That's it. The homepage will automatically pick up the new folder.

### 4. Give Matt the link
The live URL will be:
**https://mattmatheson.github.io/RandomPhoneBuilds/FOLDER_NAME/**

GitHub Pages deploys automatically — usually takes 30-60 seconds.

## Design style guide
- If Matt provides raw content/research, build it into a clean, readable HTML article
- Use the same Apple-inspired design as existing projects:
  - Font: Inter (from Google Fonts) + system SF Pro fallback
  - Clean typography, generous whitespace
  - Accent color: #C42020 (red)
  - Background: #FAFAFA
  - Text: #1D1D1F primary, #6E6E73 secondary
  - Responsive — must look good on phones
- Keep HTML self-contained (inline styles, no build step)

## Important
- Always push to `main` branch — that's what GitHub Pages serves
- Do NOT edit the root `index.html` — it's dynamic and self-updating
- Each project folder must have an `index.html` with a descriptive `<title>`
