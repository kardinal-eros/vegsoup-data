library(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/strauch2010"
key <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8")$key

#	species
file <- file.path(path, "Strauch2010SupplementTabT16-19-20-21.csv")
X <- stackSpecies(file = file)[, 1:4]

#	sites
file <- file.path(path, "Strauch2010SupplementTabT16-19-20-21Locations.csv")

df <- read.delim(file, header = TRUE, colClasses = "character")
	
df <- data.frame(df, t(sapply(df[,4], str2latlng, USE.NAMES = FALSE)))
names(df)[grep("precision", names(df))] <- "accuracy"

df$slope <- round(unlist(lapply(strsplit(as.character(df$slope.str), "-", fixed = TRUE),
	function (x) mean(as.numeric(as.character(x))))), 0)
df$slope[is.na(df$slope)] <- NA

y <- pt <- df

y <- y[, -grep("slope.str", names(y))]
y <- y[, -grep("code", names(y))]
y <- y[, -grep("tms", names(y))]

Y <- stackSites(y)

file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(x = X, file.y = file)

obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

#	order layers
layers(obj) <- c("tl", "sl", "hl")

#	unique rownames
rownames(obj) <- paste(key, "TabT16-19-20-21", rownames(obj), sep = ":")

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


