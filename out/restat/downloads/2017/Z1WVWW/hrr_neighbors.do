* David Molitor 4/17/2012

* Input: hrr_neighbors.dta
* 	1. First, I downloaded the HRR shape file from http://www.dartmouthatlas.org/tools/downloads.aspx#boundaries
* 	2. Second, I calculated neighbors using ArcMap and the python script "Find Adjacent & Neighboring Polygons" at http://resources.arcgis.com/gallery/file/geoprocessing/details?entryID=50F58FCF-1422-2418-884B-A053393CEF92
*	3. I converted the csv file to xlsx, then used stattransfer to convert to state
*	4. The final file is hrr_neighbors.dta, which is what this do file requires to process.

* Convert the original HRR neighbor file into "long" format, where each obs is an (hrr,neighbor) pair.  
* Both level 1 and 2 neighbors included

* What is the region id?
local id hrrnum

* Load the data. Varnames are id, Neighbors1, and Neighbors2
use hrr_neighbors.dta, replace
rename id `id'

* Reshape so that each hrrnum has an observation for level 1 and level 2 neighbors
reshape long Neighbors, i(`id') j(neighbor_level)

* Create list of neighbors, replacing semi-colons with spaces
gen neighbors = subinstr(Neighbors,";", " ",.)

* Create a separate neighbor variable for each neighbor
gen numneighbors = wordcount(neighbors)
sum numneighbors, d
forvalues i = 1/`r(max)' {
	gen neighbor`i' = word(neighbors,`i')
	destring neighbor`i', replace
}
drop Neighbors neighbors

* Save wide version
* observations identified by (`id', neighbor_level)
saveold hrr_neighbors_wide, replace

* Convert to long
reshape long neighbor, i(`id' neighbor_level) j(count)

* Drop missing neighbors (will drop regions that have no neighbors)
bys `id': drop if missing(neighbor)
bys `id' neighbor_level: assert _N==numneighbors | numneighbors==0
drop numneighbors count

* Save long version
* observations identified by (`id', neighbor)
saveold hrr_neighbors_long, replace
