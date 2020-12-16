require(vegsoup)
require(bibtex)

path <- "~/Documents/vegsoup-data/erschbamer1992"
bib <- read.bib(file.path(path, "references.bib"), encoding = "UTF-8"); key <- bib$key

file <- file.path(path, "Erschbamer1992Tab4.txt")

# read digitized table
x1 <- read.verbatim(file, colnames = "Aufnahme Nr.")

# extract header (sites) data from VegsoupVerbatim object
y1 <- header(x1)

# translate and groome names
names(y1) <- c("plot", "altitude", "aspect", "slope", "cover", "pH", "block")

# promote to Sites object	
y1$plot <- rownames(y1) # header returns plot names as rownames 
y1 <- stackSites(y1, schema = "plot")

# promote table body to Species object
x1 <- species(x1)

# get species from table footer
# a listing of species not covered by the main table and plot where they occur in
# the source does not supply any abundance values, we assume '+'
file <- file.path(path, "Erschbamer1992Tab4Tablefooter.txt")
x2 <- castFooter(file, species.first = TRUE, abundance.first = NA,
                 abundance = "+")
x2$plot <- sprintf("%03d", as.numeric(x2$plot))
richness(x2)
# bind species in table footer with main table
X <- vegsoup::bind(x1, x2)

#   additional sites data including coordinates as a tab delimited file
file <- file.path(path, "Erschbamer1992Tab4Locations.txt")
y2 <- read.delim(file, colClasses = "character")
head(y2)
# add leading zeros
y2$nr <- sprintf("%03d", as.numeric(y2$nr))
# promote to class "Sites"
y2 <- stackSites(y2, schema = "nr")

#	bind with sites data from table header
Y <- vegsoup::bind(y1, y2)

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
Z <- taxonomy(file, sep = ";")

# groome abundance scale codes to fit the standard
# of the extended Braun-Blanquet scale used in the origional publication
X$cov <- gsub("m", "2m", X$cov)
X$cov <- gsub("a", "2a", X$cov)
X$cov <- gsub("b", "2b", X$cov)

# promote to class "Vegsoup"
obj <- Vegsoup(X, Y, Z, coverscale = "braun.blanquet")

#	unique rownames
rownames(obj) <- paste(key, "Tab4", sprintf("%03d", as.numeric(rownames(obj))), sep = ":")	
#	assign result object
assign(key, obj)

#	richness
obj$richness <- richness(obj, "sample")

#	add citation
obj$author <- ifelse(length(bib$author) > 1, paste0(as.character(bib$author), collapse = ", "), as.character(bib$author))
obj$citation <- format(bib, style = "text")

#	save to disk
do.call("save", list(key, file = file.path(path, paste0(key, ".rda"))))
write.verbatim(obj, file.path(path, "transcript.txt"), sep = "",
	add.lines = TRUE, table.nr = TRUE)

#	tidy up
rm(list = ls()[-grep(key, ls())])