# RandomPhoneBuilds — Claude Instructions

This repo hosts HTML/XML research documents on GitHub Pages at:
**https://mattmatheson.github.io/RandomPhoneBuilds/**

## When Matt asks to upload/publish/add a new HTML document:

Follow these steps exactly:

### 1. Choose a folder name
- Ask Matt what to name it, or derive a short, descriptive kebab-case or snake_case name from the topic
- Example: `crt-signal-research`, `ai_agent_overview`, `guitar-pedal-guide`

### 2. Create the folder and add files
- Create a new folder at the repo root with that name
- Put the HTML file(s) inside as `index.html` (and any supporting files)
- The HTML should be fully self-contained (inline CSS, no external dependencies beyond Google Fonts or CDN links)

### 3. Update the root index.html
- Open `index.html` at the repo root
- Add a new `<li>` entry between the `<!-- PROJECT_LIST_START -->` and `<!-- PROJECT_LIST_END -->` comments
- Format: `<li><a href="FOLDER_NAME/"><span class="title">Display Title</span><br><span class="desc">Short description</span></a></li>`
- Add new entries at the TOP of the list (newest first)

### 4. Commit and push to main
```
git add FOLDER_NAME/ index.html
git commit -m "Add FOLDER_NAME: short description"
git push origin main
```

### 5. Give Matt the link
The live URL will be:
**https://mattmatheson.github.io/RandomPhoneBuilds/FOLDER_NAME/**

GitHub Pages deploys automatically — it usually takes 30-60 seconds.

## Important notes
- Always push to `main` branch — that's what GitHub Pages serves
- Keep HTML self-contained (inline styles, no build step)
- The root index.html is a directory/listing page — always update it when adding new projects
- If Matt provides raw content/research, build it into a clean, readable HTML article with the same design style as existing projects (Inter font, clean typography, red accent color #C42020)
