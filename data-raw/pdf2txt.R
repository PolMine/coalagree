library(pdftools)
library(magrittr)
library(cwbtools)
library(data.table)
library(RcppCWB)

setwd("~/Lab/github/coalagree/data-raw")

ts <- rbindlist(lapply(
  c("1998", "2002", "2005", "2009", "2013", "2018", "2021"),
  function(year){
    pdftools::pdf_text(paste(year, "pdf", sep = ".")) %>%
      tokenizers::tokenize_words(lowercase = FALSE, strip_punct = FALSE) %>%
      unlist() %>%
      data.table(year = year, word = .)
  }
))


# Create directories

pkg_dir <- path.expand("~/Lab/github/coalagree")
registry <- file.path(pkg_dir, "inst", "extdata", "cwb", "registry")
data_dir <- file.path(pkg_dir, "inst", "extdata", "cwb", "indexed_corpora")

if (!file.exists(registry)) dir.create(registry, recursive = TRUE)

coalagree_data_dir <- file.path(data_dir, "coalagree")
if (!file.exists(coalagree_data_dir)) dir.create(coalagree_data_dir, recursive = TRUE)
file.remove(list.files(coalagree_data_dir, full.names = TRUE))


# Create corpus

CoalAgree <- CorpusData$new()

CoalAgree$tokenstream <- ts
CoalAgree$tokenstream[, stem := SnowballC::wordStem(ts[["word"]], language = "german")]
CoalAgree$tokenstream[, cpos := 0L:(nrow(ts) - 1L)]

cpos_max_min <- function(x) list(cpos_left = min(x[["cpos"]]), cpos_right = max(x[["cpos"]]))
CoalAgree$metadata <- CoalAgree$tokenstream[, cpos_max_min(.SD), by = year]
CoalAgree$metadata[, year := as.character(year)]
setcolorder(CoalAgree$metadata, c("cpos_left", "cpos_right", "year"))

CoalAgree$tokenstream[, year := NULL]
setcolorder(CoalAgree$tokenstream, c("cpos", "word", "stem"))

CoalAgree$encode(
   corpus = "COALAGREE", encoding = "utf8",
   p_attributes = c("word", "stem"), s_attributes = "year",
   registry_dir = registry, data_dir = coalagree_data_dir,
   method = "R", compress = FALSE
)


