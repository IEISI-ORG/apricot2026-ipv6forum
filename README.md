# Presentation Build Workflow

This repository contains the source code for the APRICOT 2026 presentation. The slides are built using [Marp](https://marp.app/) (Markdown Presentation Ecosystem).

A `Makefile` is provided to standardize the build process, manage dependencies via `npx`, and simplify export tasks.

## 📋 Prerequisites

To use the build system, ensure you have the following installed in your environment:

1. **GNU Make**: Standard on Linux/macOS.
2. **Node.js & npm**: Required to run the Marp CLI.
   - *Note: You do not need to install Marp globally. The Makefile uses `npx` to fetch the latest version automatically.*

## ⚡ Quick Start

To generate the final HTML and PDF outputs in one go, simply run:

```bash
make
```

## 🛠 Build Commands

The `Makefile` abstracts the complex CLI flags. Use the following targets for specific tasks:

### 1. Development Mode (Live Preview)
Use this while writing. It starts a local web server that watches `presentation.md` for changes and automatically refreshes the browser.

```bash
make watch
```
*Press `Ctrl+C` to stop the server.*

### 2. Build HTML Only
Generates a self-contained HTML file (ideal for presenting via a web browser).

```bash
make html
```
*Output: `presentation.html`*

### 3. Build PDF Only
Generates a PDF for distribution.
*Note: This target includes the `--allow-local-files` flag to ensure local images/screenshots are embedded correctly.*

```bash
make pdf
```
*Output: `presentation.pdf`*

### 4. Clean Up
Removes all generated artifacts (`.html` and `.pdf` files) to start fresh.

```bash
make clean
```

## 📂 File Structure

- **`presentation.md`**: The source code for the slides.
- **`Makefile`**: Automation scripts for building and watching.
- **`*.html / *.pdf`**: Generated output files (ignored by git if configured).

## 📝 Editor Recommendation

While the Makefile handles the **build** process, for **editing**, it is highly recommended to use **VS Code** with the [Marp for VS Code](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode) extension for syntax highlighting and Intellisense.

---
*Build logic maintained via Makefile.*

