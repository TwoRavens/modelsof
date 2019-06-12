*===================================================================================================
* set up
*===================================================================================================
cap log close

global name = "figure1"
local cdate : di %tdCCYY.NN.DD date(c(current_date),"DMY")
log using "${logs}/${name}_`cdate'.log", text replace

*===============================================================================
* Figure 1
*===============================================================================

use "${data}/geoconflict_main.dta", clear
keep lat lon  ANY_EVENT_ACLED SPEI4pg _ID
collapse (mean) ANY_EVENT_ACLED SPEI4pg, by(lat lon _ID)

outsheet lat lon ANY_EVENT_ACLED using "${temp}/figure1A.csv", comma replace
outsheet lat lon SPEI4pg using "${temp}/figure1B.csv", comma replace

/* Continue interactively in ArcMap:

1) In Arc Catalog, right click on "${temp}/figure1A.csv", choose “create feature class from XY table” and create XYSheet.
2) Join XYSheet with "${data}/raster_Africa.shp" using: Analysis Tools>Overlay>Spatial Join; target features = raster_Africa, Join Features = XYSheet, unselect “Keep all target features". Obtain raster_Africa_joined.
3) Display as layers: raster_Africa_joined, default ArcMap Africa map (Traditional Layouts > World > Africa).
4) File>Export map.

Repeat for figure1B.

*/

log close
