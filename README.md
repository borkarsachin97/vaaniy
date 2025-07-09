
<p align="center">
  <img src="assets/vaaniy-logo.svg" alt="Vaaniy Logo" width="200"/>
</p>

# 📣 Vaaniy — Speak Your Linux

**Vaaniy** is a simple, script-based solution to deeply integrate [Piper TTS](https://github.com/rhasspy/piper) into your Linux desktop.  
Select any text, press `CTRL+`\` (`Ctrl + backtick/backqoute`), and Vaaniy will instantly speak it — in **English**, **Hindi**, or **Malayalam**.  
It works **completely offline**, requires **no GPU**, and uses **very little CPU** — so it’s perfect for laptops, old PCs, or energy-efficient setups.  
It works alongside your screen reader, or as a lightweight alternative for on-demand text-to-speech.

---

## 🔑 What is Vaaniy?

- A **collection of shell scripts** that run Piper TTS seamlessly on Linux.
- **Completely offline** — no internet needed after setup.
- **Low resource usage** — no GPU required, very minimal CPU load.
- Piper binaries are **included** — no separate install needed.
- Supports multiple language pairs:
  - 🇬🇧 **English**
  - 🇮🇳 **Hindi**
  - 🇮🇳 **Malayalam**
  - **English + Hindi** → auto-detects which language the text is in
  - **English + Malayalam** → same smart detection
- Runs two Piper models side-by-side for bilingual TTS.
- Uses lightweight FIFOs (named pipes) for zero-lag speech.

---

## ⚙️ Requirements

- `xsel` — to grab selected text.
- `inotify-tools` — for file watching.
- `mkfifo` — for named pipe creation.
- **Piper is bundled** — no need to install it separately.
- Tested on:
  - Debian 12 GNOME
  - Debian 11 MATE

---

## 📦 How to Install

1️⃣ **Download**  
- Download the ZIP from GitHub, or  
- Clone it:
  ```bash
  git clone <YOUR-REPO-URL>
  ```

2️⃣ Unpack (if using ZIP).

3️⃣ Create your Vaaniy directory:

   ```bash
   mkdir -p ~/applications/vaaniy/
   ```
---

## 🚀 How to Run
**Note**: Vaaniy is currently **beta** — there’s no autostart script yet.
This makes it easy to kill if needed.

1️⃣ Open your `terminal`.

2️⃣ Open as many `tabs` as you need — one for each language:

- For English + Hindi:

```bash
./server/startup_en.sh
./server/startup_hi.sh
```
- For English + Malayalam:

```bash
./server/startup_en.sh
./server/startup_mal.sh
```
These scripts launch Piper for each language and create the FIFOs.
Your TTS “server” is now running!

---
## ⌨️ Add Your Keyboard Shortcut
- **Path**: `Settings > Keyboard > Keyboard Shortcuts > Custom Shortcuts`
- **Name**: `Vaaniy`
- **Shortcut**:  Ctrl + `
    - **ℹ️ Note:** The \` (backtick / backquote) key is usually found **on the left side of the `1` key, just below the `ESC` key, and above the `TAB` key** on most keyboards.

- **Command**:

  - For Hindi + English:

```bash
/home/username/applications/vaaniy/accessibility/txt-rec-en_hi.sh
```
  - For Malayalam + English:
```bash
/home/username/applications/vaaniy/accessibility/txt-rec-en_ml.sh
```
---
## 🗣️ How to Use
1. Highlight any text with your mouse.
2. Press `Ctrl + ``
3. Vaaniy detects the language, splits it into sentences, and speaks it through Piper.

---

## 🧩 Screen Reader Support
Vaaniy works **with** your existing screen reader too.
You can tweak configs in:

```bash
/home/username/applications/vaaniy/accessibility/
```
More ready-to-use profiles will be added in future releases.

---
## 🌐 Local Website
Vaaniy also includes a tiny Apache-based website, which you can access locally inside the `www` folder and local website:

👉 `http://www.vaaniy.com:8080/`

---
## 🧩 Browser Extensions
Vaaniy also supports Chrome, Firefox, and Edge extensions (beta) and you can find it inside `extension` folder.

These may need manual edits for your system and user groups — detailed instructions may coming soon!

---
## ⚡ Current Status
- ✅ Fully working on Debian 12 GNOME and Debian 11 MATE.
- ✅ Lightweight, no bloat.
- ✅ Easy to extend for more languages and voices.
  - 🚧 Beta — test it, break it, help shape it.

📝 License
MIT — use it, share it, remix it.

---
🫶 Made with `Metta ☸️`  by vixxkigoli

## 🪷 Namo Buddhay! 🪷 


