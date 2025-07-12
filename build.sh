#!/bin/bash

echo "==================================="
echo "  Build Guide Builder"
echo "==================================="
echo

# Check if Pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "[ERROR] Pandoc is not installed or not in PATH"
    echo "Please install Pandoc:"
    echo "  Ubuntu/Debian: sudo apt-get install pandoc"
    echo "  CentOS/RHEL: sudo yum install pandoc"
    echo "  macOS: brew install pandoc"
    exit 1
fi

# Check if src directory exists
if [ ! -d "src" ]; then
    echo "[ERROR] Source directory 'src' not found"
    exit 1
fi

# Check if template exists
if [ ! -f "template/template.html" ]; then
    echo "[ERROR] Template file template/template.html not found"
    exit 1
fi

# Create docs directory structure if it doesn't exist
mkdir -p docs/css docs/images

echo "[INFO] Copying CSS files..."
# Copy CSS files
if [ -f "src/css/style.css" ]; then
    cp src/css/style.css docs/css/
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to copy CSS files"
        exit 1
    fi
else
    echo "[ERROR] CSS file src/css/style.css not found"
    exit 1
fi

echo "[INFO] Processing Markdown files..."
# Process all .md files in src directory
found_files=0
for mdfile in src/*.md; do
    # Check if glob matched any files
    if [ ! -f "$mdfile" ]; then
        continue
    fi
    
    found_files=1
    filename=$(basename "$mdfile" .md)
    echo "[INFO] Processing: $mdfile"
    echo "[INFO] Output: docs/$filename.html"
    
    # Convert Markdown to HTML
    pandoc --standalone -f markdown -t html5 --css css/style.css --template template/template.html --toc -i "$mdfile" -o "docs/$filename.html"
    
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to convert $mdfile to HTML"
        exit 1
    fi
    
    # Copy corresponding image directory if it exists
    if [ -d "src/images/$filename" ]; then
        echo "[INFO] Copying images for: $filename"
        mkdir -p "docs/images/$filename"
        cp -r "src/images/$filename"/* "docs/images/$filename/"
        if [ $? -ne 0 ]; then
            echo "[ERROR] Failed to copy images for $filename"
            exit 1
        fi
    else
        echo "[INFO] No image directory found for: $filename"
    fi
    
    echo "[SUCCESS] Completed: $filename.html"
    echo
done

if [ $found_files -eq 0 ]; then
    echo "[ERROR] No Markdown files found in src directory"
    exit 1
fi

echo
echo "[SUCCESS] Build completed successfully!"
echo "Output directory: docs/"
echo
echo "Files generated:"
for htmlfile in docs/*.html; do
    if [ -f "$htmlfile" ]; then
        echo "  - $(basename "$htmlfile")"
    fi
done
echo
echo "Ready for GitHub Pages deployment!"
echo