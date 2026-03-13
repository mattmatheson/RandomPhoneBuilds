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

### Listen button
- Red pill button in the header (after the `.scope` paragraph)
- Styled as a pill: `background: var(--accent); color: white; border-radius: 2rem; padding: 0.6rem 1.5rem;`
- On mobile, full-width under the subtitle

### Voice selector dropdown
- Dropdown next to the listen button (or in the player bar) to pick a voice
- **Whitelist only decent-sounding voices.** Filter `speechSynthesis.getVoices()` to match these names (case-insensitive): Samantha, Karen, Daniel, Moira, Tessa, Ava, Allison, Tom, Aaron, Nicky, Evan, Zoe, Joelle, Fiona, Martha, Arthur, and any voice whose name includes "Google US English" or "Google UK English"
- Exclude novelty/robotic voices (Bubbles, Zarvox, Trinoids, etc.) — if a voice name doesn't match the whitelist, don't show it
- Default to Samantha or the first available whitelisted voice

### Speed control
- Button that cycles through: **0.8x → 1x → 1.2x → 1.5x** (then wraps back to 0.8x)
- Applies `utterance.rate` to each new utterance

### Pro tip for premium voice
- Below the header controls (or in the player bar), include a small muted paragraph:
  > *Pro tip: For a better voice, tap "select all" below then use iOS Speak Selection (Settings > Accessibility > Spoken Content > Speak Selection).*
- Include a "select all" link/button that programmatically selects the main content container using `document.createRange()` + `range.selectNodeContents(container)` + `window.getSelection().addRange(range)`

### Sticky bottom player bar
- When playback starts, a **dark frosted-glass bar** slides up from the bottom (like a music player mini-bar)
- `position: fixed; bottom: 0; left: 0; right: 0;` with `padding-bottom: env(safe-area-inset-bottom)` for iPhone home indicator
- Background: dark translucent with `backdrop-filter: blur(20px)` (e.g. `rgba(30, 30, 30, 0.92)`)
- Hidden by default. Slides in via `transform: translateY(100%)` → `translateY(0)` with a CSS transition
- Contains (in a single row, compact): **play/pause button**, **current section title** (truncated), **voice picker**, **speed control**, **stop button**
- Stays visible while audio is playing or paused. Slides away on stop or when playback completes

### Section-by-section reading with chunk-based pacing
- Do NOT read an entire section as one huge blob of text
- Break each `<section>` into individual **paragraphs** (`<p>`, `<li>`, `<h2>`, `<h3>`, etc.)
- Create a separate `SpeechSynthesisUtterance` for each paragraph/element
- **Pacing pauses:** 200ms pause between paragraphs, 400ms pause after headings
- **Heading style:** Read headings at a slightly slower rate (0.9x of current speed) with a slight pitch shift (`utterance.pitch = 1.05`) to differentiate them from body text
- Use the `onend` event of each utterance to advance to the next chunk, applying the appropriate pause via `setTimeout`

### Section highlight + auto-scroll
- The **currently-reading section** gets a highlight class:
  ```css
  section.reading {
    border-left: 3px solid var(--accent);
    background: rgba(196, 32, 32, 0.04);
    padding-left: 1rem;
    border-radius: 4px;
    transition: all 0.3s ease;
  }
  ```
- Auto-scrolls to each new section: `scrollIntoView({ behavior: 'smooth', block: 'start' })`
- Remove `.reading` from the previous section before highlighting the next
- Don't fight manual scrolling — only auto-scroll on section transitions

### Chrome keep-alive workaround
- Chrome kills long utterances silently. Set up a `setInterval` that calls `speechSynthesis.resume()` every **10 seconds** while playback is active
- Clear the interval when playback stops

## Branch Rules
- Try `git push origin main` first.
- If you get a 403 or can't push to main, push to a `claude/*` branch instead. **A GitHub Action will auto-merge it to main within ~30 seconds.** This is expected and normal — just tell Matt the link will be live in about a minute.
- Do NOT create pull requests. Just push.
- Do NOT edit the root `index.html` — it's dynamic and self-updating.
- Each project folder must have an `index.html` with a descriptive `<title>`.
