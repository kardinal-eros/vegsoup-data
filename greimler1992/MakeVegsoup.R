library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/greimler1992"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	read prepared digitized table
file <- file.path(path, "Greimler1992Tab2taxon2standard.txt")
x <- xx <- read.verbatim(file, "Aufnahmenummer", layers = "@")

X0 <- species(x)[, 1:4]
X0$plot <- as.numeric(X0$plot)

#	and footer taxa
#	the publication has additional species data for plot 22 on page 182,
# 	but the table does not have a plot 22?
file <- file.path(path, "Greimler1992Tab2Footer species.csv")
X1 <- species(file, sep = ",")[, 1:4]

#	bind
X <- bind(X0, X1)

#   sites data including coordinates
file <- "~/Documents/vegsoup-data/greimler1992/Greimler1992Tab2Locations.csv"
Y <- stackSites(file = file, sep = ",")

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	unique rownames
rownames(obj) <- paste(key, "Tab2", sprintf("%01d", as.numeric(rownames(obj))), sep = ":")

#	order layers
layers(obj) <- c("hl", "ml")

#	assign alliance
obj$alliance.code <- "SES-01A"
obj$alliance <- "Seslerion caeruleae Br.-Bl. in Br.-Bl. et Jenny 1926"

#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "",
	add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])
