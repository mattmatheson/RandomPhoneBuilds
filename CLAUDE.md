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

## Formatting Rules
- Never wrap URLs/links in bold (`**`). Just paste them plain. Matt hates bolded links.

## Listen Mode (Read Aloud) — REQUIRED on every research document

Every research document must include a **Listen** button in the header area, right below the title/scope. This uses the browser's built-in **Web Speech API** (`speechSynthesis`) — no external dependencies needed.

### How it works
1. A play/pause button sits at the top of the article (inside `<header>`, after the `.scope` paragraph)
2. When pressed, it reads the document **section by section** using `speechSynthesis.speak()`
3. The **currently-reading section** gets a highlight class (subtle left border + light background, using the accent color)
4. The page **auto-scrolls** to each section as it begins reading (`scrollIntoView({ behavior: 'smooth', block: 'start' })`)
5. When a section finishes, the highlight moves to the next section
6. The button toggles between ▶ Play / ⏸ Pause / ■ Stop states
7. Clicking while playing pauses; clicking again resumes; long-idle auto-stops

### Listen button design
- Sits in the header after the scope/subtitle
- Styled as a pill button: `background: var(--accent); color: white; border-radius: 2rem; padding: 0.6rem 1.5rem;`
- Icon + text: "▶ Listen" / "⏸ Pause" / "■ Stop"
- On mobile, full-width under the subtitle
- Smooth transitions on state changes

### Section highlight style
```css
section.reading {
  border-left: 3px solid var(--accent);
  background: rgba(196, 32, 32, 0.04);
  padding-left: 1rem;
  border-radius: 4px;
  transition: all 0.3s ease;
}
```

### Implementation notes
- Gather all `<section>` elements in document order
- For each section, extract `.textContent` (strips HTML tags — speech API only needs plain text)
- Create a `SpeechSynthesisUtterance` for each section
- Use the `onend` event of each utterance to advance to the next section
- Use `onstart` to add the `.reading` class and scroll into view
- Remove `.reading` from the previous section before highlighting the next
- Handle edge cases: user scrolls manually (don't fight it), page visibility change (pause if tab hidden), reaching the end (reset button to Play)
- Prefer a natural-sounding voice if available (check for voices with "English" and pick one that isn't robotic — `speechSynthesis.getVoices()`)
- Set a comfortable speech rate: `utterance.rate = 1.0` (can be adjusted)
- The listen feature must work on both desktop and mobile Safari/Chrome

## Branch Rules
- Try `git push origin main` first.
- If you get a 403 or can't push to main, push to a `claude/*` branch instead. **A GitHub Action will auto-merge it to main within ~30 seconds.** This is expected and normal — just tell Matt the link will be live in about a minute.
- Do NOT create pull requests. Just push.
- Do NOT edit the root `index.html` — it's dynamic and self-updating.
- Each project folder must have an `index.html` with a descriptive `<title>`.
