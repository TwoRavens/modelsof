***On-Line Appendix

use "1970_2011_City_H.dta", clear
scatter E_city_NHW pctnhwht_city, xtitle("% White", margin(medium) size(large)) ytitle("White/Non-White Entropy", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))

use "racial_polarization_winners.dta", clear
***Column 1
xtmixed biggestsplit isolationwht_i diversityinterp pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop  i. year south midwest west if winner==1||geo_id2:
***Column 2
xtmixed biggestsplit isolationwht_i diversityinterp pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop whiteideology_fill i. year south midwest west if winner==1||geo_id2:

 use "fin_seg.dta", clear
 ***Isolation Index
 ***Top Row
 ***Column 1
 xtreg dgepercap_cpi isolationwht_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  dgepercap_cpi~=0,fe vce(cluster geo_id2)
  ***Column 2
  xtreg highwayspercapNC_cpi isolationwht_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & highwayspercapNC_cpi~=0, fe vce(cluster geo_id2)
  ***Column 3
 xtreg policepercapNC_cpi isolationwht_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & policepercapNC_cpi~=0 , fe vce(cluster geo_id2)
  ***Column 4
 xtreg parkspercapNC_cpi isolationwht_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  parkspercapNC_cpi~=0 , fe vce(cluster geo_id2)

 ***Bottom Row
***Column 1
xtreg sewerspercapNC_cpi isolationwht_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & sewerspercapNC_cpi~=0 , fe vce(cluster geo_id2)
***Column 2
xtreg welfhoushealthNC_cpi isolationwht_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & welfhoushealthNC_cpi~=0, fe vce(cluster geo_id2)
***Column 3
xtreg genrevownpercap_cpi isolationwht_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & genrevownpercap_cpi ~=0, fe vce(cluster geo_id2)

****Multi-Group H Index
***Top Row
 ***Column 1
 xtreg dgepercap_cpi H_citytract_multi_i  diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  dgepercap_cpi~=0,fe vce(cluster geo_id2)
  ***Column 2
  xtreg highwayspercapNC_cpi H_citytract_multi_i  diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & highwayspercapNC_cpi~=0, fe vce(cluster geo_id2)
  ***Column 3
 xtreg policepercapNC_cpi H_citytract_multi_i  diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & policepercapNC_cpi~=0 , fe vce(cluster geo_id2)
  ***Column 4
 xtreg parkspercapNC_cpi H_citytract_multi_i  diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  parkspercapNC_cpi~=0 , fe vce(cluster geo_id2)

 ***Bottom Row
***Column 1
xtreg sewerspercapNC_cpi H_citytract_multi_i  diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & sewerspercapNC_cpi~=0 , fe vce(cluster geo_id2)
***Column 2
xtreg welfhoushealthNC_cpi H_citytract_multi_i  diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & welfhoushealthNC_cpi~=0, fe vce(cluster geo_id2)
***Column 3
xtreg genrevownpercap_cpi H_citytract_multi_i  diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & genrevownpercap_cpi ~=0, fe vce(cluster geo_id2)

***Testing Polarization
use "racial_polarization_winners.dta", clear
keep geo_id2 year biggestsplit
sort geo_id2 year
by geo_id2 year: egen meansplit=mean( biggestsplit)
drop biggestsplit
duplicates drop
tsset geo_id2 year
tsfill
by geo_id2: ipolate meansplit year, gen(meansplit_i)
merge 1:1 geo_id2 year using  "fin_seg.dta"
drop if _merge==1
drop _merge
***Column 1
xtreg dgepercap_cpi H_citytract_NHW_i  if totaltracts>1 &  dgepercap_cpi~=0 & meansplit_i~=., vce(cluster geo_id2)
***Column 2
xtreg dgepercap_cpi H_citytract_NHW_i   meansplit_i if totaltracts>1 &  dgepercap_cpi~=0 & meansplit_i~=., vce(cluster geo_id2)

clear
