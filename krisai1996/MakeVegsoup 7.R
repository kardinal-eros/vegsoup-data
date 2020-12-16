require(vegsoup)

#	read prepared digitized table
file <- file.path(path, "Krisai1996Tab7taxon2standard.txt")
x <- read.verbatim(file, "Aufnahme Nr.", verbose = FALSE, layers = "@")
X0 <- species(x)

#	and footer taxa
file <- file.path(path, "Krisai1996Tab7FooterSpecies.csv")
X1 <- species(file, sep = ";")[, 1:4]

X <- vegsoup::bind(X0, X1)

#   sites data including coordinates
file <- file.path(path, "Krisai1996Tab7Locations.csv")
Y <- stackSites(file = file)

# taxonomy reference list
file <- "~/Documents/vegsoup-standards/austrian standard list 2008/austrian standard list 2008.csv"
XZ <- SpeciesTaxonomy(X, file.y = file)

# promote to class "Vegsoup"
obj <- Vegsoup(XZ, Y, coverscale = "braun.blanquet2")

# assign header data stored as attributes in
# imported original community table
# omit dimnames, plot id (Releveé number) and class
a <- header(x)

# reorder by plot
a <- a[match(rownames(obj), rownames(a)), ] 

# give names and assign variables
obj$pls <- a$"Groesse.qm.x10" * 10
obj$expo <- as.character(a$Exposition)
obj$slope <- a$"Neigung.in.Grad"
obj$htl <- a$"Baumschicht..Hoehe.m"

obj$tcov <- a$"Baumschicht..Deckung.."
obj$scov <- a$"Strauchschicht..Deckung.."
obj$hcov <- a$"Krautschicht..Deckung.."

#	unique rownames
rownames(obj) <- paste(key, "Tab7", sprintf("%02d", as.numeric(rownames(obj))), sep = ":")

tab7 <- obj
