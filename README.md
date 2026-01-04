# SparkReader Library

This repository contains the **catalog** used by the [SparkReader](https://sparkreader.app/) Android app.

## About the Library

The SparkReader Library is a curated collection of seminal public domain books spanning the entirety of human history—from ancient times to the present—and across diverse world regions. Our selection covers a wide range of disciplines, including philosophy, religion, science, and law, as well as literary fiction genres such as crime, thriller, and mystery, and non-fiction categories such as travel writing and biographies.

All books are sourced from [Project Gutenberg](https://www.gutenberg.org/) and other public domain collections.


## Library Creation Pipeline

The library is created through a pipeline process:

1. **Tag-based Curation**: Starting with the [predefined tags](catalog/tags.txt), a state-of-the-art foundational large language model (LLM) creates an initial catalog of books that best represent each category
2. **Project Gutenberg Matching**: The curated list is matched against the [Project Gutenberg catalog](https://www.gutenberg.org/ebooks/offline_catalogs.html) to find corresponding Project Gutenberg IDs
3. **Content Validation**: The catalog is deduplicated, then the books are downloaded and validated; entries without downloadable text or broken links are removed
4. **Metadata Completion**: An LLM completes the tagging and metadata for all validated items
5. **Catalog Creation**: A catalog is created and validated against the [JSON schema](schema/catalog.schema.json) to ensure consistency
6. **Release Preparation**: The final catalog and book files are packaged into versioned release bundles

## Contents
- `catalog/catalog.json` — canonical catalog consumed by the app  
- `catalog/tags.txt` — tags referenced by the catalog  
- `schema/catalog.schema.json` — JSON schema for validating the catalog  
- `VERSION.md` — latest library version information used by the app

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

## Discussion and Contributions

We welcome discussions about books, suggestions for new additions, and feedback on the library content. Please use the [GitHub Issues](https://github.com/sparkreaderapp/sparkreader-library/issues) section of this repository to:

- Suggest new books for inclusion
- Discuss existing books in the library
- Report issues with book content or metadata
- Propose improvements to the curation process

For app-related issues and feature requests, please visit the main [SparkReader repository](https://github.com/sparkreaderapp/sparkreader).

## Releases
GitHub Releases provide the **downloadable library bundle** (`library.zip`) and **catalog** for each version. Catalogs are also version-controlled in the repository under `catalog/catalog.json` and are accessible via git tags
