library(vegsoup)
library(rgdal)
library(readxl)
library(linktaxa)

rm(list = ls())
load("~/Documents/vegsoup-data/rosenheim-mühldorf fields dta/rma.rda")

#	change taxonomy of vegsoup object according to this source
#	https://www.lfu.bayern.de/natur/codeplan/index.htm
i <- read.csv("~/Documents/vegsoup-data/rosenheim-mühldorf fields dta/taxon2lfucodepage.csv")

#	reference taxonomy stored as csv file, state april 2022
#	zip("~/Documents/vegsoup-data/rosenheim-mühldorf fields dta/lfucodepage.csv.zip", "~/Documents/vegsoup-data/rosenheim-mühldorf fields dta/lfucodepage.csv", flags = "-r9Xj")

unzip("~/Documents/vegsoup-data/rosenheim-mühldorf fields dta/lfucodepage.csv.zip")
z <- read.csv("~/Documents/vegsoup-data/rosenheim-mühldorf fields dta/lfucodepage.csv")
file.remove("~/Documents/vegsoup-data/rosenheim-mühldorf fields dta/lfucodepage.csv")

z <- z[ z$Synonym == 0, ]
z <- z[ c("Taxon", "Autor", "Name_Deutsch", "Art_ID", "Gattung", "RLB", "RLD", "Schutz_BNatSchG")]
names(z) <- tolower(names(z))
names(z)[ 3 ] <- "vernacular.name"
names(z)[ 5 ] <- "genus"
names(z)[ names(z) == "schutz_bnatschg" ] <- "bnatschg"
z$abbr <- ""

z <- z[ match(i$matched.taxon, z$taxon), ]

z0 <- taxonomy(taxonomy(rma))[ c("abbr", "taxon") ]

z <- cbind(abbr = z0$abbr, z, taxon.standard = z0$taxon)

names(z)[ names(z) == "art_id"] <- "lfutaxon"
rma@taxonomy <- taxonomy(z)
rma@taxonomy <- taxonomy(rma)[, -grep("abbr.1", names(taxonomy(taxonomy(rma)))) ]

save(rma, file = "~/Documents/vegsoup-data/rosenheim-mühldorf fields dta/rma-lfucodepage.rda")
