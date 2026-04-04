# 🚀 Tech Interview Preparation Wiki

A professional, high-performance wiki-style website built with **Hugo** and the **Hextra** theme.

## 🛠️ Local Setup

### 1. Install Hugo
Ensure you have the extended version of Hugo installed.
- **Mac**: `brew install hugo`
- **Windows**: `choco install hugo-extended`
- **Linux**: `apt install hugo`

### 2. Initial Setup
If you just cloned this repo, initialize the theme submodule:
```bash
git submodule update --init --recursive
```

### 3. Run Locally
Start the development server:
```bash
hugo server -D
```
Visit `http://localhost:1313` to see your wiki.

### 4. Run with Docker (Recommended)
If you don't want to install Hugo on your host machine:
```bash
docker-compose up
```
Visit `http://localhost:1313` to see your wiki.

---

## 📂 Project Structure

```text
.
├── content/               # Wiki Markdown pages
│   ├── java/              # Java specific content
│   ├── dsa/               # Data Structures & Algorithms
│   ├── system-design/     # HLD & LLD case studies
│   └── database/          # SQL & NoSQL deep dives
├── themes/
│   └── hextra/            # The Hextra documentation theme
└── hugo.toml              # Project configuration
```

---

## 🎨 Adding New Content
Every page follows a standard layout for interview prep:
1. **Title**
2. **📌 Question**
3. **🎯 What is being tested**
4. **🧠 Explanation**
5. **✅ Ideal Answer**
6. **💻 Code Example**
7. **⚠️ Common Mistakes**
8. **🔄 Follow-ups**

---

## 🌐 Deployment

### GitHub Pages
1. Create a `.github/workflows/hugo.yml` file.
2. Search for "Hugo GitHub Pages Action" and paste the standard config.
3. Push to `main`.

### Netlify
1. Connect your GitHub repository to Netlify.
2. Build Command: `hugo --gc --minify`
3. Publish Directory: `public`
4. Environment Variable: `HUGO_VERSION = 0.124.1` (or latest)

---

## ✨ Features
- **Dockerfile**: Production-ready Nginx build.
- **Docker Compose**: Easy local development server.
- **Sidebar**: Auto-generated from folder structure.
- **Search**: Fast, client-side search (FlexSearch).
- **Dark Mode**: Built-in toggle.
- **Responsive**: Fully optimized for mobile.
