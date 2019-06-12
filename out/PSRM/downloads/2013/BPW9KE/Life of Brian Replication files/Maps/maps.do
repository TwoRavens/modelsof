/***********************************************************
************************************************************
** Alexander Baturo and Slava Mikhaylov (2013). "Life of Brian Revisited: Assessing Informational and Non-Informational Leadership Tools." Political Science Research and Methods, 2013, 1(1): 139-157.
** Replication files
************************************************************
**  Maps
************************************************************
************************************************************/


*Requires shp2dta, spmap

*To convert shapefile into .dta format:
*shp2dta using regions2010, database(rusdb) coordinates(ruscoord) genid(id)


use maps.dta, clear

preserve 
keep if year==2009
collapse score_nof, by(subject) 
save y2009, replace
restore

preserve 
keep if year==2010
collapse score_nof, by(subject)
save y2010, replace
restore

preserve 
keep if year==2011
collapse score_nof, by(subject) 
save y2011, replace
restore

preserve 
keep if year==2011
collapse score_nof, by(subject) 
save y2011, replace
restore

preserve 
keep if year==2012
collapse score_nof, by(subject) 
save y2012, replace
restore





use y2009, clear

merge m:m subject using rusdb

spmap score_noforeign using ruscoord, id(id) fcolor(Reds2) ocolor(white ..) osize(vvthin ..) clbreaks(-.414(.05).414) clnumber(10)  clmethod(custom) legstyle(3) legend(ring(1) position(3)) title("Raw wordscores 2009")

graph export map2009.pdf, replace


use y2010, clear

merge m:m subject using rusdb

spmap score_noforeign using ruscoord, id(id) fcolor(Reds2) ocolor(white ..) osize(vvthin ..) clbreaks(-.414(.05).414) clnumber(10)  clmethod(custom) legstyle(3) legend(ring(1) position(3)) title("Raw wordscores 2010")

graph export map2010.pdf, replace


use y2011, clear

merge m:m subject using rusdb

spmap score_noforeign using ruscoord, id(id) fcolor(Reds2) ocolor(white ..) osize(vvthin ..) clbreaks(-.414(.05).414) clnumber(10)  clmethod(custom) legstyle(3) legend(ring(1) position(3)) title("Raw wordscores 2011")

graph export map2011.pdf, replace

use y2012, clear

merge m:m subject using rusdb

spmap score_noforeign using ruscoord, id(id) fcolor(Reds2) ocolor(white ..) osize(vvthin ..) clbreaks(-.414(.05).414) clnumber(10)  clmethod(custom) legstyle(3) legend(ring(1) position(3)) title("Raw wordscores 2012")

graph export map2012.pdf, replace

