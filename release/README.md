# # Library Releases

## v1.0
A seed catalog file is generated with GPT o3 with the following prompt: 
```text
can you create a catalog.csv of 50 must read public domain books? for each book include id (integer), title, author, year, description, file (put "FILE" and i'll fix it manually), tags, source. tags a comma seperated list of tag. You can also have two level tags, such as medieval-literature/Chinese,religions-and-spirituality/Christianity

If there anything important missing from the columns add it.
```

then a librray is created with `scripts/gutenberg.ipynb`
