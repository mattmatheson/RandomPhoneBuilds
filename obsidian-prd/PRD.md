# Matt Matheson — Second Brain PRD
## Obsidian Vault: Personal Knowledge Base + Business Backend

---

## 1. What This Is

A personal Obsidian vault that serves as Matt's "second brain" — the single backend system where all knowledge, client info, project notes, inspiration, and random life stuff lives. It's not client-facing. It's the engine behind everything Matt builds, whether that final output is a Canva PDF, a Photoshop invoice, a QuickBooks entry, or a video edit.

**Two users access this vault:**
- **Matt** — browsing, capturing, reviewing via Obsidian app (Mac + iPhone)
- **Claude (Neo)** — reading, searching, writing, and processing notes via direct file access

---

## 2. The Problem This Solves

Matt is a talented videographer/creative whose work consistently impresses clients. But his process between first contact and final delivery is chaotic:

- Everything lives in his head, on sticky notes, or scattered across Google Keep, Milanote, YouTube likes, Instagram saves
- No consistent client workflow — clients lose trust mid-project because there's no visible process
- ADHD makes it hard to track multiple projects, deadlines, and deliverables simultaneously
- Inspiration gets saved and buried ("save and forget graveyard")
- No single place where an AI assistant can access all context to help

**The vault fixes this by being one place where everything goes, and one place where Claude can find everything.**

---

## 3. Vault Structure

```
📁 Matt-Brain/                          ← Vault root
├── CLAUDE.md                           ← Rules for Claude when working in this vault
├── 📁 Inbox/                           ← Quick capture landing zone (process weekly)
├── 📁 Business/
│   ├── 📁 Clients/                     ← One note per client (contact info, history, vibe)
│   ├── 📁 Projects/                    ← One note per project (linked to client)
│   ├── 📁 Rates-and-Templates/         ← Rate card, invoice templates, contract templates
│   └── 📁 Inspiration/                 ← Client mood boards, reference videos, visual refs
├── 📁 Life/
│   ├── 📁 Ideas/                       ← Random thoughts, concepts, shower thoughts
│   ├── 📁 Finds/                       ← YouTube videos, reels, podcasts, articles
│   ├── 📁 Music/                       ← Guitar noodlings, song ideas, audio references
│   ├── 📁 Learning/                    ← Book excerpts, course notes, how-tos
│   └── 📁 Photos-and-Scans/           ← Notebook photos, screenshots, visual captures
├── 📁 Daily/                           ← Daily journal notes (auto-created)
├── 📁 Maps/                            ← MOCs (index pages) — added later as vault grows
└── 📁 Archive/                         ← Completed projects, old stuff (out of sight, not deleted)
```

**Why this structure:**
- Two top-level worlds: `Business/` and `Life/` — clean mental separation
- `Inbox/` is the junk drawer with permission — dump anything, process later
- `Daily/` gives Matt a place to brain dump each day (voice-to-text friendly)
- `Archive/` keeps things clean without deleting history
- Flat enough that nothing gets buried, deep enough to stay organized

---

## 4. Note Types & Templates

### 4a. Client Note (`Business/Clients/`)
One per client. Living document — updated over time.

```markdown
---
type: client
name:
phone:
email:
source: # how they found you (referral, Instagram, etc.)
status: # active / past / lead
created: {{date}}
---

## About
<!-- Who they are, what they do, their vibe -->

## Contact History
<!-- Reverse chronological — newest on top -->
- {{date}} — First contact via Facebook DM. Wants a boxing promo video.

## Projects
<!-- Links to project notes -->
- [[Project - Aaren Boxing Promo]]

## Notes
<!-- Anything else — their preferences, personality, what they respond to -->
```

### 4b. Project Note (`Business/Projects/`)
One per project. This is the "process" that makes Matt look professional.

```markdown
---
type: project
client: "[[Client Name]]"
status: # lead / booked / pre-production / shooting / editing / delivered / archived
shoot-date:
due-date:
rate:
paid: # yes / no / partial
created: {{date}}
---

## Overview
<!-- What the project is, what the client wants -->

## Inspiration & References
<!-- YouTube links, Instagram reels, photos, mood board links -->

## Pre-Production
<!-- Shot list, locations, gear needed, talent, call sheet info -->

## Shoot Notes
<!-- Day-of brain dump — what happened, what you got, anything to remember for edit -->

## Edit Notes
<!-- Edit decisions, music choices, revision requests -->

## Deliverables
<!-- What was delivered, how (text, email, link), when -->

## Invoice
<!-- Rate, what was charged, payment status -->
```

### 4c. Daily Note (`Daily/`)
Auto-created each day. Matt talks into his phone, it lands here.

```markdown
---
type: daily
date: {{date}}
---

## Brain Dump
<!-- Whatever's on your mind. Voice-to-text, typed, doesn't matter. -->

## To Do
- [ ]

## Captures
<!-- Stuff you found today — links, screenshots, ideas. Process into proper notes later. -->
```

### 4d. Find/Capture Note (`Life/Finds/` or `Inbox/`)
For YouTube videos, reels, podcasts, articles, anything found online.

```markdown
---
type: find
source: # youtube / instagram / podcast / article / other
url:
tags: []
created: {{date}}
---

## What It Is
<!-- One line — what is this and why did you save it -->

## Why It Matters
<!-- What caught your attention, how you might use it -->

## Key Takeaways
<!-- If applicable — the actual info you wanted to remember -->
```

### 4e. Idea Note (`Life/Ideas/`)
For random thoughts, concepts, creative sparks.

```markdown
---
type: idea
tags: []
created: {{date}}
---

<!-- Just write. One idea per note. Keep it atomic. -->
```

### 4f. Voice Memo / Audio Note (`Life/Music/` or `Inbox/`)
For guitar noodlings, voice recordings, audio captures.

```markdown
---
type: audio
source: # voice-memo / guitar / recording
file: # filename or path to audio file
tags: []
created: {{date}}
---

## What This Is
<!-- Brief description -->

## Transcription
<!-- If it's a voice note, transcribe it here (Claude can help) -->
```

---

## 5. How Claude (Neo) Works With the Vault

### Reading
- Claude reads notes directly via file system access
- Frontmatter `type:` and `status:` fields make it easy to query ("show me all active projects," "find the client named Aaren")
- Claude can search across the entire vault with Grep/Glob

### Writing
- Claude can create new notes using templates (client intake after a meeting, project kickoff, processing inbox captures)
- Claude can update existing notes (add to contact history, update project status, log deliverables)
- Claude follows the `CLAUDE.md` at vault root for naming conventions and rules

### Processing
- Matt dumps raw captures into `Inbox/`
- Claude processes them: creates proper notes, files them in the right folder, adds frontmatter
- Example: Matt takes a photo of notebook scribbles → drops in Inbox → Claude reads the image, transcribes it, creates a client note and project note from the content

### Querying
- "What projects do I have due this week?"
- "Pull up everything on the Aaren boxing project"
- "What was that YouTube video I saved about lighting setups?"
- "How much have I invoiced this month?"

---

## 6. Capture Workflows

### On iPhone (primary)
1. **Voice brain dump** → Open Obsidian mobile → Daily note → talk into it (speech-to-text keyboard)
2. **Quick capture** → Obsidian mobile → new note in `Inbox/` → paste link / type thought / attach photo
3. **iOS Share Sheet** → Share a YouTube/Instagram link → Obsidian (or Shortcut that creates an Inbox note)
4. **Voice Memo** → Record in Voice Memos app → import file into vault later (or tell Claude about it)
5. **Photo of notebook** → Take photo → drop in `Inbox/` or attach to a note

### On Mac
1. **Obsidian app** → Full editing, reviewing, browsing
2. **Claude Code** → "Hey, create a new client note for Aaren Alred" → done
3. **Drag and drop** → Pull files, images, audio into vault folders

---

## 7. Plugin Stack (Lean)

**Essential (install day 1):**
| Plugin | What It Does |
|--------|-------------|
| Templater | Auto-fills templates with dates, prompts |
| Dataview | Query your notes like a database |
| Calendar | Visual calendar linked to daily notes |
| Periodic Notes | Auto-creates daily/weekly notes |

**Add when ready:**
| Plugin | What It Does |
|--------|-------------|
| QuickAdd | One-click capture from desktop |
| Tasks | Track to-dos across all notes |
| Smart Connections | AI-powered semantic search across vault |

**Skip for now:**
- Anything that adds complexity without solving a problem you actually have today

---

## 8. What Success Looks Like

### Month 1
- Vault is set up with structure and templates
- Matt is capturing daily notes via phone (even just voice-to-text brain dumps)
- New clients get a Client note + Project note within 24 hours of first contact
- Claude can answer "what's on my plate right now?"

### Month 3
- Inbox processing is routine (weekly, or Claude handles it)
- Client workflow feels professional — Matt knows every project's status at a glance
- Inspiration/finds are searchable instead of buried in Instagram saves
- Clients notice the difference: clear communication, shoot plans, organized delivery

### Month 6
- The vault is the single source of truth for Matt's business and creative life
- Pre-production docs, call sheets, and mood boards start from vault knowledge
- Matt trusts the system enough to stop using sticky notes
- Revenue tracking is possible ("how much did I make in Q1?")

---

## 9. What This Is NOT

- **Not client-facing** — clients never see the vault. They see polished PDFs, Canva designs, texts with video links
- **Not a project management tool** — it's a knowledge base. If Matt needs Gantt charts or Kanban boards, that's a different tool layered on top
- **Not a replacement for creative tools** — Photoshop, Canva, QuickBooks, Final Cut/Premiere still do their jobs. The vault just holds the knowledge that feeds into those tools
- **Not precious** — notes can be messy, incomplete, one sentence long. The system works because stuff goes IN, not because it's perfect

---

## 10. Next Steps

1. **Matt reviews this PRD** — add, remove, or change anything
2. **Install Obsidian** (if not already installed)
3. **Claude creates the vault** — folder structure, templates, CLAUDE.md, starter notes
4. **Matt starts capturing** — even just one daily note a day
5. **Iterate** — the system grows with use, not with planning
