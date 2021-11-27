urls <- c(
  "1998" = "https://www.spd.de/fileadmin/Dokumente/Beschluesse/Bundesparteitag/koalitionsvertrag_bundesparteitag_bonn_1998.pdf",
  "2002" = "https://www.nachhaltigkeit.info/media/1248173898php7wc9Pc.pdf",
  "2005" = "https://www.kmk.org/fileadmin/pdf/foederalismus/2005_11_11-Koalitionsvertrag-Dok04.pdf",
  "2009" = "https://archiv.cdu.de/system/tdf/media/dokumente/091026-koalitionsvertrag-cducsu-fdp_0.pdf",
  "2013" = "https://archiv.cdu.de/sites/default/files/media/dokumente/koalitionsvertrag.pdf",
  "2018" = "https://archiv.cdu.de/system/tdf/media/dokumente/koalitionsvertrag_2018.pdf",
  "2021" = "https://www.spd.de/fileadmin/Dokumente/Koalitionsvertrag/Koalitionsvertrag_2021-2025.pdf"
)

setwd("~/Lab/github/coalagree/data-raw")

for (year in names(urls)){
  download.file(url = urls[[year]], destfile = paste(year, "pdf", sep = "."))
}

cat(
  paste(
    "The pdf files in this directory have been retrieved using the downloads.R file. Date of download:",
    Sys.time(), sep = " "
  ),
  file = "./README"
)

