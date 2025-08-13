# Resources Directory

This directory contains the exported picture files database from the main HTML/Markdown content.

## Contents

### picture_files_database.json
A comprehensive database containing metadata for all image references found in the repository's HTML/Markdown content.

**Structure:**
- `metadata`: General information about the database
- `images`: Array of image objects with detailed information

**Image Object Properties:**
- `id`: Unique identifier
- `name`: Descriptive name
- `alt_text`: Alt text from the original markdown
- `url`: Source URL of the image
- `type`: Type of image (badge, static_image, etc.)
- `source_file`: Original file containing the reference
- `source_line`: Line number in the source file
- `description`: Human-readable description
- `category`: Classification category

## Exported Images

1. **Windows Platform Badge** - Dynamic badge showing platform compatibility
2. **Batch Script Badge** - Dynamic badge showing programming language
3. **Graph** - Static documentation image

## Usage

This database can be used to:
- Track all image dependencies in the project
- Update image references
- Maintain consistency in documentation
- Audit external image dependencies

## Notes

- Dynamic badges (shields.io) are not downloaded as they change based on parameters
- Static images should be downloaded when network access permits
- The database preserves the original source location for each image reference