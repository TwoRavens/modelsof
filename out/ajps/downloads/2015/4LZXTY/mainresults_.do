***Table 1
use "racial_polarization_winners.dta", clear
**Column 1
xtmixed biggestsplit H_citytract_multi_i diversityinterp pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop  i. year south midwest west if winner==1||geo_id2:
***predicted effects following Table 1
margins, at((mean) _all H_citytract_multi_i=(.23 .54))

***Column 2
xtmixed biggestsplit H_citytract_NHW_i diversity pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop  i. year south midwest west if winner==1||geo_id2:

***Column 3
xtmixed biggestsplit H_citytract_NHW_i diversity pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop whiteideology_fill2 i. year south midwest west if winner==1||geo_id2:


***Table 2
use "fin_seg.dta", clear

***Column 1
xtreg dgepercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & dgepercap_cpi~=0,fe vce(cluster geo_id2)
***predicted effects following Table 2
margins, at((mean) _all H_citytract_NHW_i=(.01 .10))

***Column 2
xtreg dgepercap_cpi H_citytract_NHW_i pctblkpopinterp pctasianpopinterp pctlatinopopinterp chng5pctblk chng5pctlatino chng5pctasian  medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  dgepercap_cpi~=0,fe vce(cluster geo_id2)

***Column 3
xtreg dgepercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop ideology_fill if totaltracts>1 &  dgepercap_cpi~=0,fe vce(cluster geo_id2)



***Table 3
use "fin_seg.dta", clear

***Column 1
xtreg highwayspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & highwayspercapNC_cpi~=0, fe vce(cluster geo_id2)

***Column 2
xtreg policepercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & policepercapNC_cpi~=0 , fe vce(cluster geo_id2)

***Column 3
xtreg parkspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  parkspercapNC_cpi~=0 , fe vce(cluster geo_id2)

***Column 4
xtreg sewerspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & sewerspercapNC_cpi~=0 , fe vce(cluster geo_id2)

***Column 5
xtreg welfhoushealthNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & welfhoushealthNC_cpi~=0, fe vce(cluster geo_id2)

***Column 6
xtreg genrevownpercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & genrevownpercap_cpi ~=0, fe vce(cluster geo_id2)

***Figure 1
xtreg highwayspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & highwayspercapNC_cpi~=0, fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .5))
marginsplot, xlabel(0(.1).5) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Roads Expenditure Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))

xtreg policepercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & policepercapNC_cpi~=0 , fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .5))
marginsplot, xlabel(0(.1).5) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Police Expenditure Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))

xtreg parkspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  parkspercapNC_cpi~=0 , fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .5))
marginsplot, xlabel(0(.1).5) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Parks Expenditure Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))

xtreg sewerspercapNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & sewerspercapNC_cpi~=0 , fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .5))
marginsplot, xlabel(0(.1).5) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Sewers Expenditure Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))

xtreg welfhoushealthNC_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & welfhoushealthNC_cpi~=0, fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .3))
marginsplot, xlabel(0(.1).3) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Welfare Expenditure Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white)) 

xtreg genrevownpercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 & genrevownpercap_cpi ~=0, fe vce(cluster geo_id2)
quietly margins, at((mean) _all H_citytract_NHW_i=(0 (.01) .5))
marginsplot, xlabel(0(.1).5) xtitle("Segregation", margin(medium) size(large)) plotopts(color(black)) recast(line) ciopts(color(gs14)) recastci(rarea) title("") ytitle("Own Source Revenue Per Capita, $1000s", size(medium) margin(small)) graphregion(margin(medlarge) fcolor(white)) legend(off) plotregion(color(white))

***Table 4
xtreg dgepercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  dgepercap_cpi~=0,fe vce(cluster geo_id2)
***Columns 2 & 3
table pctnonwht_xtile, c(mean pctnonwht mean H_citytract_NHW_i)
***Determine min/max values for each quintile
table pctnonwht_xtile, c(min H_citytract_NHW_i max H_citytract_NHW_i )
***Calculate marginal effect of changing from minimum to maximum level of segregation for each quintile
***Columns 4 & 5
margins, over(pctnonwht_xtile) at((mean) _all H_citytract_NHW_i=(0 .38726727 .68708962 .76654474 .73449214 .66859493)) contrast(atcontrast(r._at) wald)

***Table 5
***Install IVREG2 package if not already installed
 ssc install ivreg2
 ssc install ranktest 
 
***Top Row
***Column 1
ivreg2 dgepercap_cpi (H_citytract_NHW_i= total_rivs_all logpop ) dgepercap_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if dgepercap_cpi~=0
***Column 2
ivreg2 highwayspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) highwayspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  highwayspercapNC_cpi~=0
***Column 3
ivreg2 policepercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) policepercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  policepercapNC_cpi ~=0 
***Column 4
ivreg2 parkspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) parkspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  parkspercapNC_cpi ~=0 

***Bottom Row
***Column 1
ivreg2 sewerspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) sewerspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if sewerspercapNC_cpi ~=0 
***Column 2
ivreg2 welfhoushealthNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) welfhoushealthNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if welfhoushealthNC_cpi ~=0 
***Column 3
ivreg2 genrevownpercap_cpi (H_citytract_NHW_i= total_rivs_all logpop ) genrevownpercap_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if genrevownpercap_cpi ~=0 


***Appendix

**Appendix Table A1 & A2
use "racial_polarization_winners.dta", clear
xtmixed biggestsplit H_citytract_multi_i diversityinterp pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop  i. year south midwest west if winner==1||geo_id2:
***Table A1
sum biggestsplit H_citytract_multi_i H_citytract_NHW diversityinterp pctasianpopinterp pctblkpopinterp pctlatinopopinterp medincinterp pctrentersinterp pctcollegegradinterp biracial nonpartisan primary logpop whiteideology_fill  if e(sample)
***Table A2
table cityname biggestsplit_gr if e(sample)
table cityname if e(sample), c(mean H_citytract_multi_i mean H_citytract_NHW_i)

***Appendix Table A3
use "fin_seg.dta", clear
xtreg dgepercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop if totaltracts>1 &  dgepercap_cpi~=0,fe vce(cluster geo_id2)
sum  dgepercap_cpi H_citytract_NHW_i diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp chng5pctblk chng5pctlatino chng5pctasian medinc_cpi pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp logpop ideology_fill population if e(sample)
sum  highwayspercapNC_cpi  if e(sample) & highwayspercapNC_cpi~=0
sum  policepercapNC_cpi if e(sample) & policepercapNC_cpi~=0
sum parkspercapNC_cpi  if e(sample) & parkspercapNC_cpi ~=0
sum sewerspercapNC_cpi if e(sample) & sewerspercapNC_cpi ~=0
sum  welfhoushealthNC_cpi if e(sample) &  welfhoushealthNC_cpi ~=0
sum  genrevownpercap_cpi if e(sample) &  genrevownpercap_cpi  ~=0

***Appendix Table A4
***Column 1
ivreg2 dgepercap_cpi (H_citytract_NHW_i= total_rivs_all logpop ) dgepercap_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if dgepercap_cpi~=0, first
***Column 2
ivreg2 highwayspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) highwayspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  highwayspercapNC_cpi~=0, first
***Column 3
ivreg2 policepercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) policepercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  policepercapNC_cpi ~=0, first
***Column 4
ivreg2 parkspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) parkspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if  parkspercapNC_cpi ~=0, first 

***Bottom Row
***Column 1
ivreg2 sewerspercapNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) sewerspercapNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if sewerspercapNC_cpi ~=0, first 
***Column 2
ivreg2 welfhoushealthNC_cpi (H_citytract_NHW_i= total_rivs_all logpop ) welfhoushealthNC_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if welfhoushealthNC_cpi ~=0, first 
***Column 3
ivreg2 genrevownpercap_cpi (H_citytract_NHW_i= total_rivs_all logpop ) genrevownpercap_cpilag diversityinterp pctblkpopinterp pctasianpopinterp pctlatinopopinterp medincinterp pctlocalgovworker_100 pctrentersinterp pctover65 pctcollegegradinterp northeast south midwest y5 - y9 if genrevownpercap_cpi ~=0, first 

