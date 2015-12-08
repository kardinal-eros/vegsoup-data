CSV schema
==========

Github offers nice CSV rendering, however, only for comma separated files. Up to now everything is separated with semi-colons. This may change?

`./oberndorf dta` is the first data that has file `species.csv` seperated with comma.


Interpreted taxa from literature
================================

Vascular plants
---------------

Pre 2000 determinations of *Nigritella nigra* for Salzburg (Austria) are likely to belong to *N. rhelicanii* (P. Pilsl)

> ./isda1989
> ./erschbamer1992

A single observation of *Medicago minima* belongs to *M. lupulina* (P. Pilsl)

> ./eckkrammer2003


Abbreviations
=============

Vascular plants
---------------

replace `fest rubr` with `fest rubr slat` and delete from reference list

> ./eckkrammer2003
> ./hohewand dta
> ./schleißheim dta
> ./windsfeld dta


Lichens
-------

rename `clad rang` (*Cladonia rangiferina*) to `clad rang rina` because of addition of *Cladonia rangiformis* with abbreviation `clad rang rmis`

> ./windsfeld dta  
> ./hauser kaibling dta  
> ./hagengebirge dta  
> ./gernkogel dta  
> ./erschbamer1992  
> ./dachstein dta  
> ./bockhart dta  
> ./aineck dta  

Bryopyhtes
----------

there are two homonymous instances, `bryo unde` and `unde bryu`, keep only one

> ./hüttschlag dta
> ./wolfgangsee dta

there are two homonymous instances in standard list for *Polypodium vulgare*

> `poly vule` Polypodium vulgare  
> `poly vulg` Polypodium vulgare s.str.

instances with `euph dulc` should be replaced with `euph dulc dulc` 

there are two homonymous instances in standard list for *Hypnum cupressiforme*

instances with `hypn cupr` should be replaced with `hypn cupr slat`

*Barbula reflexa* and *Barbula rigidula* are not valid taxa.


> ./* many data sets 
