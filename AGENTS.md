# CLAUDE.md

ユーザとの対話は日本語を使用する。
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a static documentation generator for creating HTML build guides from Markdown source files. The project is specifically designed for generating keyboard build guides that will be published to GitHub Pages. It uses Pandoc to convert Markdown files to HTML with custom styling and templates.

## Build Commands

### Windows
```bash
build.bat
```

### Unix/Linux/macOS
```bash
chmod +x build.sh
./build.sh
```

Both scripts perform the same operations:
1. Check for Pandoc installation
2. Validate required directories and template files exist
3. Copy CSS files from `src/css/` to `docs/css/`
4. Convert all `.md` files in `src/` to HTML in `docs/`
5. Copy corresponding image directories from `src/images/` to `docs/images/`

## Architecture

### Directory Structure
- `src/` - Source content directory
  - `*.md` - Markdown files to be converted
  - `css/style.css` - Source CSS file
  - `images/[filename]/` - Images organized by document name
- `template/template.html` - Pandoc HTML template with TOC support
- `docs/` - Generated output directory (created by build process)
  - `*.html` - Generated HTML files
  - `css/style.css` - Copied CSS file
  - `images/` - Copied image directories

### Build Process
The build system automatically:
- Generates HTML with table of contents using `--toc` flag
- Links CSS stylesheet with `--css css/style.css`
- Uses custom HTML template for consistent layout
- Copies image directories matching document names
- Creates responsive layout with sidebar TOC

### Dependencies
- **Pandoc** (required): Used for Markdown to HTML conversion
- The build scripts check for Pandoc availability and provide installation instructions if missing

### Template System
- Uses Pandoc templating with conditional TOC generation
- Template includes responsive design with sidebar navigation
- Japanese content support with appropriate fonts
- GitHub-style formatting and color scheme

### Output
Generated files in `docs/` directory are ready for GitHub Pages deployment without additional configuration.