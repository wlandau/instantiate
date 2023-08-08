library(pkglite)
spec <- file_spec(
  path = ".",
  pattern = "*",
  format = "text",
  all_files = TRUE,
  recursive = TRUE
)
collection <- collate(pkg = "example", spec)
pack(collection, output = "inst/example.txt", quiet = TRUE)
