# SparkReader Library

This repository contains the **catalog** used by the [SparkReader](https://sparkreader.app/) Android app.

## About the Library

The SparkReader Library is a curated collection of seminal public domain books spanning the entirety of human history—from ancient times to the present—and across diverse world regions. Our selection covers a wide range of disciplines, including philosophy, religion, science, and law, as well as literary fiction genres such as crime, thriller, and mystery, and non-fiction categories such as travel writing and biographies.

All books are sourced from Project Gutenberg and other public domain collections, ensuring they are freely available and legally distributable.

## Contents
- `catalog.json` — canonical catalog consumed by the app  
- `schema/` — JSON schema for validating the catalog  
- `tags.txt` — tags referenced by the catalog  
- `VERSION.md` — latest library version information used by the app  

## Library Creation Pipeline

The library is created through a systematic pipeline process:

1. **Tag-based Curation**: Starting with predefined tags in `tags.txt`, an LLM creates an initial catalog of books that best represent each category
2. **Project Gutenberg Matching**: The curated list is matched against the Project Gutenberg catalog to find corresponding PG IDs
3. **Content Validation**: Books are downloaded and validated; entries without downloadable text or broken symlinks are removed
4. **Metadata Completion**: LLM completes the tagging and metadata for all validated items
5. **Schema Validation**: All entries are validated against the JSON schema to ensure consistency
6. **Release Preparation**: The final catalog and book files are packaged into versioned release bundles

## Schema

The library uses a JSON schema (`schema/catalog.schema.json`) to validate book metadata. Each book entry requires:

- **id**: Unique identifier
- **title**: Book title
- **tags**: Comma-separated classification tags (must match valid tags from tags.txt)
- **author**: Author name(s)
- **date**: Publication year (4-digit format)
- **description**: Short description or abstract
- **file**: Relative path to plain text file
- **source**: Origin or publisher
- **source_link**: Canonical URL of original source

## Releases
GitHub Releases provide the **downloadable library bundle** (`library.zip`) and **catalog** for each version. Catalogs are also version-controlled in the repository under `catalog/catalog.json` and are accessible via git tags
