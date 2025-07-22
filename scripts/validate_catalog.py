#!/usr/bin/env python3
import argparse
import pandas as pd
import sys

def load_valid_tags(tagfile):
    with open(tagfile, 'r', encoding='utf-8') as f:
        return {line.strip() for line in f if line and not line.startswith('#')}

def validate_catalog(catalog_file, valid_tags):
    df = pd.read_json(catalog_file)
    invalid_found = False

    if 'tags' not in df.columns:
        print('Error: "tags" field not found in catalog', file=sys.stderr)
        sys.exit(1)

    for idx, row in df.iterrows():
        tag_field = row['tags']
        if not isinstance(tag_field, str):
            print(f'Row {idx}: tags field is not a string', file=sys.stderr)
            continue
        tags = [t.strip() for t in tag_field.split(',') if t.strip()]
        invalid = [t for t in tags if t not in valid_tags]
        invalid_found |= bool(invalid)
        if invalid:
            print(f'Row {idx}: invalid tags: {", ".join(invalid)}', file=sys.stderr)
    return invalid_found

def main():
    parser = argparse.ArgumentParser(description='Validate catalog tags against a tag list')
    parser.add_argument('--catalog', help='Path to catalog JSON file', default='scripts/output/library/catalog.json')
    parser.add_argument('--tags', help='Path to tags.txt file', default='tags/tags.txt')
    args = parser.parse_args()

    valid_tags = load_valid_tags(args.tags)
    invalid_found = validate_catalog(args.catalog, valid_tags)
    if invalid_found:
        print('Catalog validation failed', file=sys.stderr)
        sys.exit(1)
    else:
        print('Catalog validation passed')

    print("⚠️  TODO: check pages and toc exisence checks")

if __name__ == '__main__':
    main()

