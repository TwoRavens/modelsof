*****************************************
* ADD UNEMPLOYMENT DATA
*  
*    Observation every 3 mos, 11 years (4*11=44)
****************************************
global pathimmpgm\\ssb2f\ssb24\SatSocDyn\Immigranten\GBWD\CHOICES

set more off

preserve

use $pathimmpgm\werkloosheid9909.dta, clear
mata: mata clear
mata: NatUnemrate= st_data(., ("regwerkloosnl" ))

restore
/* # obs Unemployment = 44 */
matrix Econdata = J(44,1,0)
mata: st_replacematrix("Econdata",NatUnemrate)

gen NatUnemrate = 0
**** ADD UNEMPLOYMENT DATA ***
forvalues k = 1(1)44 {
  local j = `k'
  replace NatUnemrate= Econdata[`k',1] if ///
      ( 4*(year(datum)-1999) + quarter(datum) == `j' )
}

* centreren naar gemid van 2.94 ?
