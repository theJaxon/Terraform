### Functions
#### [element(list, index)](https://www.terraform.io/language/functions/element)
- Doesn't throw out-of-bound exception
- Produces an error only if used with an empty list

```hcl
output "element_test" {
  # returns b as it's zero based indexing
  value = element(["a", "b", "c"], 1)
  
  # Doesn't throw an error but returns c as it's evaluated as
  # a => 0 , b => 1, c => 2, a => 3, b => 4, c => 5
  value = element(["a", "b", "c"], 5)
}
```

---

#### [fileset(path, pattern)](https://www.terraform.io/language/functions/fileset)
- returns a set containing file names matching the pattern (oftentimes the pattern is file extensions that should be matched)
- Can be used to list all the files under a given path `fileset(path.module, "*")`