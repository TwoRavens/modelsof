** Replication file for "Racial Sorting and the Emergence of Segregation in American Cities" ***

/* Allison Shertzer, 6/8/18

Note:  this file produces many more counterfactual segregation estimates than are reported in the paper.
In particular we only reported dissimilarity indexes the paper but also computed isolation below. 
Please see the included Excel file "Table 6 for Replication" for details on which indices we used in 
the paper and how we constructed the counterfactuals reported in Table 6.
*/


use all_hexagon_iv.dta, clear

* note this is a balanced panel used elsewhere in the empirical work

bysort city_cd year: egen tpop = total(pop)
bysort city_cd year: egen min_size = min(pop)
bysort city_cd year: egen min_num = min(hexagonID)

bysort city_cd year: egen twhite = total(white)
bysort city_cd year: egen tblack = total(black)
bysort city_cd year: egen tsouthern_black = total(southern_black)

gen twhite00a = twhite if year==1900
gen twhite10a = twhite if year==1910
gen twhite20a = twhite if year==1920
gen twhite30a = twhite if year==1930

egen twhite00 = max(twhite00a), by(uniqueID)
egen twhite10 = max(twhite10a), by(uniqueID)
egen twhite20 = max(twhite20a), by(uniqueID)
egen twhite30 = max(twhite30a), by(uniqueID)

gen tblack00a = tblack if year==1900
gen tblack10a = tblack if year==1910
gen tblack20a = tblack if year==1920
gen tblack30a = tblack if year==1930

egen tblack00 = max(tblack00a), by(uniqueID)
egen tblack10 = max(tblack10a), by(uniqueID)
egen tblack20 = max(tblack20a), by(uniqueID)
egen tblack30 = max(tblack30a), by(uniqueID)

gen tsouthern_black00a = tsouthern_black if year==1900
gen tsouthern_black10a = tsouthern_black if year==1910
gen tsouthern_black20a = tsouthern_black if year==1920
gen tsouthern_black30a = tsouthern_black if year==1930

egen tsouthern_black00 = max(tsouthern_black00a), by(uniqueID)
egen tsouthern_black10 = max(tsouthern_black10a), by(uniqueID)
egen tsouthern_black20 = max(tsouthern_black20a), by(uniqueID)
egen tsouthern_black30 = max(tsouthern_black30a), by(uniqueID)

gen tpop00a = tpop if year==1900
gen tpop10a = tpop if year==1910
gen tpop20a = tpop if year==1920
gen tpop30a = tpop if year==1930

egen tpop00 = max(tpop00a), by(uniqueID)
egen tpop10 = max(tpop10a), by(uniqueID)
egen tpop20 = max(tpop20a), by(uniqueID)
egen tpop30 = max(tpop30a), by(uniqueID)

gen white_city_growth10 = twhite10 - twhite00
gen white_city_growth20 = twhite20 - twhite10
gen white_city_growth30 = twhite30 - twhite20

gen black_city_growth10 = tblack10 - tblack00
gen black_city_growth20 = tblack20 - tblack10
gen black_city_growth30 = tblack30 - tblack20


mat segregation = J(30,4,.)

gen edv_black_i = (black/tblack)*(black/pop)
gen edv_black_d = abs((black/tblack)-(white/twhite))

*** First set:  isolation, adjusted isolation, and dissimilarity for basic sample

local j = 1

forvalues t=1900(10)1930 {

* going to report Cutler et al formula for isolation using common base (all blacks)

bysort city_cd: egen isol_black_`t' = total(edv_black_i) if year==`t'
gen Cisol_black_`t' = (isol_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t'

summ Cisol_black_`t' if hexagonID==min_num & year==`t'
mat segregation[1,`j'] = r(mean)
summ isol_black_`t' if hexagonID==min_num & year==`t'
mat segregation[2,`j'] = r(mean)

bysort city_cd: egen diss_black_`t' = total(edv_black_d) if year==`t'
replace diss_black_`t' = .5*diss_black_`t' if year==`t'

summ diss_black_`t' if hexagonID==min_num & year==`t'
mat segregation[3,`j'] = r(mean)

local j = `j'+1

}

*** Second set: assign blacks according to 1900 distribution in all years (dissimilarity stays the same)

gen pred_white00 = white00
gen pred_white10 = white00+(white00/twhite00)*white_city_growth10
gen pred_white20 = white00+(white00/twhite00)*white_city_growth10 + (white00/twhite00)*white_city_growth20
gen pred_white30 = white00+(white00/twhite00)*white_city_growth10 + (white00/twhite00)*white_city_growth20 +  (white00/twhite00)*white_city_growth30

gen pred_black00 = black00
gen pred_black10 = black00+(black00/tblack00)*black_city_growth10
gen pred_black20 = black00+(black00/tblack00)*black_city_growth10 + (black00/tblack00)*black_city_growth20
gen pred_black30 = black00+(black00/tblack00)*black_city_growth10 + (black00/tblack00)*black_city_growth20 + (black00/tblack00)*black_city_growth30

gen pred_black = pred_black00 if year==1900
replace pred_black = pred_black10 if year==1910
replace pred_black = pred_black20 if year==1920
replace pred_black = pred_black30 if year==1930

gen pred_white = pred_white00 if year==1900
replace pred_white = pred_white10 if year==1910
replace pred_white = pred_white20 if year==1920
replace pred_white = pred_white30 if year==1930

gen pred_pop = pred_white + pred_black

* note by construction that tblack and twhite are the same predicted or actual (but not pop)

gen edv_pred_black_i = (pred_black/tblack)*(pred_black/pred_pop)
gen edv_pred_black_d = abs((pred_black/tblack)-(pred_white/twhite))

local j = 1

forvalues t=1900(10)1930 {

* going to report Cutler et al formula for isolation using common base (all pred_blacks)

bysort city_cd: egen isol_pred_black_`t' = total(edv_pred_black_i) if year==`t'
gen Cisol_pred_black_`t' = (isol_pred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t'

summ Cisol_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[4,`j'] = r(mean)
summ isol_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[5,`j'] = r(mean)

bysort city_cd: egen diss_pred_black_`t' = total(edv_pred_black_d) if year==`t'
replace diss_pred_black_`t' = .5*diss_pred_black_`t' if year==`t'

summ diss_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[6,`j'] = r(mean)

local j = `j'+1

}

drop pred_* edv_* diss_*

*** Third set:  applying IV flight, rescaling proportionally, constraining blacks by black distribution by decade

* first, get the amount of white population that needs to be allocated when we rescale

gen ivpred_black10 = black10
gen ivpred_black20 = black20
gen ivpred_black30 = black30

gen ivpred_white10 = 0
gen ivpred_white20 = 0
gen ivpred_white30 = 0

* 1930

ivregress2 liml whitediff30 (blackdiff30 = IV_black30) i.city_cd if year==1930

predict pred_whitediff30

replace ivpred_white30 = white20 + pred_whitediff30 if year==1930

* 1920

ivregress2 liml whitediff20 (blackdiff20 = IV_black20) i.city_cd if year==1920

predict pred_whitediff20

replace ivpred_white20 = white10 + pred_whitediff20 if year==1920

* 1910

ivregress2 liml whitediff10 (blackdiff10 = IV_black10) i.city_cd if year==1910

predict pred_whitediff10

replace ivpred_white10 = white00 + pred_whitediff10 if year==1910

rename ivpred_white10 unscaled_ivpred_white10
rename ivpred_white20 unscaled_ivpred_white20
rename ivpred_white30 unscaled_ivpred_white30

* citywide gain in white population over preceding decade = total flow of whites into city

bysort city_cd year: egen total_whitediff30 = total(whitediff30)
bysort city_cd year: egen total_whitediff20 = total(whitediff20)
bysort city_cd year: egen total_whitediff10 = total(whitediff10)

* citywide predicted gain in white population

bysort city_cd year: egen total_predwhitediff30 = total(pred_whitediff30)
bysort city_cd year: egen total_predwhitediff20 = total(pred_whitediff20)
bysort city_cd year: egen total_predwhitediff10 = total(pred_whitediff10)

gen diff_in_diff30 = total_predwhitediff30 - total_whitediff30
gen diff_in_diff20 = total_predwhitediff20 - total_whitediff20
gen diff_in_diff10 = total_predwhitediff10 - total_whitediff10

gen ivpred_white10 = 0
gen ivpred_white20 = 0
gen ivpred_white30 = 0 

replace ivpred_white30 = unscaled_ivpred_white30 + pop20/tpop20*diff_in_diff30
replace ivpred_white20 = unscaled_ivpred_white20 + pop10/tpop10*diff_in_diff20   
replace ivpred_white10 = unscaled_ivpred_white10 + pop00/tpop00*diff_in_diff10
              
gen ivpred_black = black00 if year==1900
replace ivpred_black = ivpred_black10 if year==1910
replace ivpred_black = ivpred_black20 if year==1920
replace ivpred_black = ivpred_black30 if year==1930

gen ivpred_white = white00 if year==1900
replace ivpred_white = ivpred_white10 if year==1910
replace ivpred_white = ivpred_white20 if year==1920
replace ivpred_white = ivpred_white30 if year==1930

gen ivpred_pop = ivpred_white + ivpred_black

gen edv_ivpred_black_d = abs((ivpred_black/tblack)-(ivpred_white/twhite))
gen edv_ivpred_black_i = (ivpred_black/tblack)*(ivpred_black/ivpred_pop) if ivpred_pop>=0

local j = 1

forvalues t=1900(10)1930 {

* going to report Cutler et al formula for isolation using common base (all pred_blacks)

bysort city_cd: egen isol_ivpred_black_`t' = total(edv_ivpred_black_i) if year==`t'
gen Cisol_ivpred_black_`t' = (isol_ivpred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t' & ivpred_pop>=0

summ Cisol_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[7,`j'] = r(mean)

bysort city_cd: egen diss_ivpred_black_`t' = total(edv_ivpred_black_d) if year==`t'
replace diss_ivpred_black_`t' = .5*diss_ivpred_black_`t' if year==`t'

summ diss_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[8,`j'] = r(mean)

local j = `j'+1

}

drop ivpred_* edv_ivpred_* diss_ivpred* pred_* Cisol* isol* total_* diff* unscaled*

*** Fourth set:  applying IV flight, not rescaling (tossing whites), constraining blacks by black distribution by decade

gen ivpred_black10 = black00 + (black00/tblack00)*black_city_growth10
gen ivpred_black20 = black10 + (black10/tblack10)*black_city_growth20
gen ivpred_black30 = black20 + (black20/tblack20)*black_city_growth30

gen ivpred_white10 = 0
gen ivpred_white20 = 0
gen ivpred_white30 = 0

* 1930

ivregress2 liml whitediff30 (blackdiff30 = IV_black30) i.city_cd if year==1930

predict pred_whitediff30

replace ivpred_white30 = white20 + pred_whitediff30 if year==1930

* 1920

ivregress2 liml whitediff20 (blackdiff20 = IV_black20) i.city_cd if year==1920

predict pred_whitediff20

replace ivpred_white20 = white10 + pred_whitediff20 if year==1920

* 1910

ivregress2 liml whitediff10 (blackdiff10 = IV_black10) i.city_cd if year==1910

predict pred_whitediff10

replace ivpred_white10 = white00 + pred_whitediff10 if year==1910
              
gen ivpred_black = black00 if year==1900
replace ivpred_black = ivpred_black10 if year==1910
replace ivpred_black = ivpred_black20 if year==1920
replace ivpred_black = ivpred_black30 if year==1930

gen ivpred_white = white00 if year==1900
replace ivpred_white = ivpred_white10 if year==1910
replace ivpred_white = ivpred_white20 if year==1920
replace ivpred_white = ivpred_white30 if year==1930

gen ivpred_pop = ivpred_white + ivpred_black

gen edv_ivpred_black_d = abs((ivpred_black/tblack)-(ivpred_white/twhite))
gen edv_ivpred_black_i = (ivpred_black/tblack)*(ivpred_black/ivpred_pop) if ivpred_pop>=0

local j = 1

forvalues t=1900(10)1930 {

bysort city_cd: egen isol_ivpred_black_`t' = total(edv_ivpred_black_i) if year==`t'
gen Cisol_ivpred_black_`t' = (isol_ivpred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t' & ivpred_pop>=0

summ Cisol_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[9,`j'] = r(mean)

bysort city_cd: egen diss_ivpred_black_`t' = total(edv_ivpred_black_d) if year==`t'
replace diss_ivpred_black_`t' = .5*diss_ivpred_black_`t' if year==`t'

summ diss_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[10,`j'] = r(mean)

local j = `j'+1

}

drop pred_* edv_* diss_* isol* Cisol*
*** Fifth set: no flight baseline, constraining blacks by black distribution by decade

gen pred_white00 = white00
gen pred_white10 = white00+(pop00/tpop00)*white_city_growth10
gen pred_white20 = white10+(pop10/tpop10)*white_city_growth20 
gen pred_white30 = white20+(pop20/tpop20)*white_city_growth30 

gen pred_black00 = black00
gen pred_black10 = black00+(black00/tblack00)*black_city_growth10
gen pred_black20 = black10+(black10/tblack10)*black_city_growth20 
gen pred_black30 = black20+(black20/tblack20)*black_city_growth30

gen pred_black = pred_black00 if year==1900
replace pred_black = pred_black10 if year==1910
replace pred_black = pred_black20 if year==1920
replace pred_black = pred_black30 if year==1930

gen pred_white = pred_white00 if year==1900
replace pred_white = pred_white10 if year==1910
replace pred_white = pred_white20 if year==1920
replace pred_white = pred_white30 if year==1930

gen pred_pop = pred_white + pred_black

* note by construction that tblack and twhite are the same predicted or actual (but not pop)

gen edv_pred_black_i = (pred_black/tblack)*(pred_black/pred_pop)
gen edv_pred_black_d = abs((pred_black/tblack)-(pred_white/twhite))

local j = 1

forvalues t=1900(10)1930 {

* going to report Cutler et al formula for isolation using common base (all pred_blacks)

bysort city_cd: egen isol_pred_black_`t' = total(edv_pred_black_i) if year==`t'
gen Cisol_pred_black_`t' = (isol_pred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t'

summ Cisol_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[11,`j'] = r(mean)

bysort city_cd: egen diss_pred_black_`t' = total(edv_pred_black_d) if year==`t'
replace diss_pred_black_`t' = .5*diss_pred_black_`t' if year==`t'

summ diss_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[12,`j'] = r(mean)

local j = `j'+1

}

drop ivpred_* pred_* Cisol* isol* 

*** Sixth set:  applying IV flight, not rescaling, allowing blacks to have overall population propagation by decade

* first, get the amount of white population that needs to be allocated when we rescale

gen ivpred_black10 = black00 + (pop00/tpop00)*black_city_growth10 if year==1910
gen ivpred_black20 = black10 + (pop10/tpop10)*black_city_growth20 if year==1920
gen ivpred_black30 = black20 + (pop20/tpop20)*black_city_growth30 if year==1930

gen ivpred_white10 = 0
gen ivpred_white20 = 0
gen ivpred_white30 = 0

* 1930

ivregress2 liml whitediff30 (blackdiff30 = IV_black30) i.city_cd if year==1930

predict pred_whitediff30

replace ivpred_white30 = white20 + pred_whitediff30 if year==1930

* 1920

ivregress2 liml whitediff20 (blackdiff20 = IV_black20) i.city_cd if year==1920

predict pred_whitediff20

replace ivpred_white20 = white10 + pred_whitediff20 if year==1920

* 1910

ivregress2 liml whitediff10 (blackdiff10 = IV_black10) i.city_cd if year==1910

predict pred_whitediff10

replace ivpred_white10 = white00 + pred_whitediff10 if year==1910

gen ivpred_black = black00 if year==1900
replace ivpred_black = ivpred_black10 if year==1910
replace ivpred_black = ivpred_black20 if year==1920
replace ivpred_black = ivpred_black30 if year==1930

gen ivpred_white = white00 if year==1900
replace ivpred_white = ivpred_white10 if year==1910
replace ivpred_white = ivpred_white20 if year==1920
replace ivpred_white = ivpred_white30 if year==1930

gen ivpred_pop = ivpred_white + ivpred_black

gen edv_ivpred_black_d = abs((ivpred_black/tblack)-(ivpred_white/twhite))
gen edv_ivpred_black_i = (ivpred_black/tblack)*(ivpred_black/ivpred_pop) if ivpred_pop>=0

local j = 1

forvalues t=1900(10)1930 {

bysort city_cd: egen isol_ivpred_black_`t' = total(edv_ivpred_black_i) if year==`t'
gen Cisol_ivpred_black_`t' = (isol_ivpred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t' & ivpred_pop>=0

summ Cisol_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[13,`j'] = r(mean)

bysort city_cd: egen diss_ivpred_black_`t' = total(edv_ivpred_black_d) if year==`t'
replace diss_ivpred_black_`t' = .5*diss_ivpred_black_`t' if year==`t'

summ diss_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[14,`j'] = r(mean)

local j = `j'+1

}

drop pred_* edv_pred* diss_pred* Cisol* isol* 

*** Seventh set: no flight baseline, allowing blacks to have overall population propagation by decade

gen pred_white00 = white00
gen pred_white10 = white00+(pop00/tpop00)*white_city_growth10
gen pred_white20 = white10+(pop10/tpop10)*white_city_growth20 
gen pred_white30 = white20+(pop20/tpop20)*white_city_growth30 

gen pred_black00 = black00
gen pred_black10 = black00+(pop00/tpop00)*black_city_growth10
gen pred_black20 = black10+(pop10/tpop10)*black_city_growth20 
gen pred_black30 = black20+(pop20/tpop20)*black_city_growth30

gen pred_black = pred_black00 if year==1900
replace pred_black = pred_black10 if year==1910
replace pred_black = pred_black20 if year==1920
replace pred_black = pred_black30 if year==1930

gen pred_white = pred_white00 if year==1900
replace pred_white = pred_white10 if year==1910
replace pred_white = pred_white20 if year==1920
replace pred_white = pred_white30 if year==1930

gen pred_pop = pred_white + pred_black

* note by construction that tblack and twhite are the same predicted or actual (but not pop)

gen edv_pred_black_i = (pred_black/tblack)*(pred_black/pred_pop)
gen edv_pred_black_d = abs((pred_black/tblack)-(pred_white/twhite))

local j = 1

forvalues t=1900(10)1930 {

* going to report Cutler et al formula for isolation using common base (all pred_blacks)

bysort city_cd: egen isol_pred_black_`t' = total(edv_pred_black_i) if year==`t'
gen Cisol_pred_black_`t' = (isol_pred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t'

summ Cisol_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[15,`j'] = r(mean)

bysort city_cd: egen diss_pred_black_`t' = total(edv_pred_black_d) if year==`t'
replace diss_pred_black_`t' = .5*diss_pred_black_`t' if year==`t'

summ diss_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[16,`j'] = r(mean)

local j = `j'+1

}

drop ivpred_* edv_ivpred_* diss_ivpred* pred_* Cisol* isol* 

*** Eighth set:  applying regression, not rescaling, blacks propagate like Italians in 1930

* note that the shares in this exercise refer to share of Italian population of city in your neighborhood

bysort city_cd year: egen titalian = total(italy)
gen italian = italy
gen share_italian = italy/titalian

local group = "italian"

gen edv_`group'_i = (`group'/t`group')*(`group'/pop)

* let's examine segregation of Italians for fun

local j = 1

forvalues t=1900(10)1930 {

bysort city_cd: egen isol_`group'_`t' = total(edv_`group'_i) if year==`t'
gen Cisol_`group'_`t' = (isol_`group'_`t' - (t`group'/tpop))/(min(t`group'/min_size,1) - (t`group'/tpop)) if year==`t'

summ Cisol_`group'_`t' if hexagonID==min_num & year==`t'
mat segregation[23,`j'] = r(mean)

local j = `j'+1

}

gen share_`group'00a = share_`group' if year==1900
gen share_`group'10a = share_`group' if year==1910
gen share_`group'20a = share_`group' if year==1920
gen share_`group'30a = share_`group' if year==1930

egen share_`group'00 = max(share_`group'00a), by(uniqueID)
egen share_`group'10 = max(share_`group'10a), by(uniqueID)
egen share_`group'20 = max(share_`group'20a), by(uniqueID)
egen share_`group'30 = max(share_`group'30a), by(uniqueID)

gen share_black = black/tblack

sort year city_cd share_black

egen group_cd = group(year city_cd)

* this index orders neighborhoods by city black share within year and city

bysort group_cd: egen index = seq()

sort year city_cd index

save all_hexagon_iv_sort.dta, replace

* now make an Italian index to merge back on using index

keep year city_cd share_`group' group_cd

sort year city_cd share_`group'

bysort group_cd: egen index = seq()

rename share_`group' synthetic_share_`group'

sort year city_cd index

save merger.dta, replace

merge year city_cd index using all_hexagon_iv_sort.dta

drop _merge

gen synthetic_share_`group'00a = synthetic_share_`group' if year==1900
gen synthetic_share_`group'10a = synthetic_share_`group' if year==1910
gen synthetic_share_`group'20a = synthetic_share_`group' if year==1920
gen synthetic_share_`group'30a = synthetic_share_`group' if year==1930

egen synthetic_share_`group'00 = max(synthetic_share_`group'00a), by(uniqueID)
egen synthetic_share_`group'10 = max(synthetic_share_`group'10a), by(uniqueID)
egen synthetic_share_`group'20 = max(synthetic_share_`group'20a), by(uniqueID)
egen synthetic_share_`group'30 = max(synthetic_share_`group'30a), by(uniqueID)

gen ivpred_white10 = 0
gen ivpred_white20 = 0
gen ivpred_white30 = 0

* change here to get 1910 or 1930 fixed distribution

gen ivpred_black10 = black00 + synthetic_share_`group'30*black_city_growth10 if year==1910
gen ivpred_black20 = black10 + synthetic_share_`group'30*black_city_growth20 if year==1920
gen ivpred_black30 = black20 + synthetic_share_`group'30*black_city_growth30 if year==1930

/*
*** to create distribution pictures

keep year city_cd index synthetic_share_italian share_black
duplicates drop
sort year city_cd index
outsheet using helper.xls, replace
*/

* 1930

ivregress2 liml whitediff30 (blackdiff30 = IV_black30) i.city_cd if year==1930

predict pred_whitediff30

replace ivpred_white30 = white20 + pred_whitediff30 if year==1930

* 1920

ivregress2 liml whitediff20 (blackdiff20 = IV_black20) i.city_cd if year==1920

predict pred_whitediff20

replace ivpred_white20 = white10 + pred_whitediff20 if year==1920

* 1910

ivregress2 liml whitediff10 (blackdiff10 = IV_black10) i.city_cd if year==1910

predict pred_whitediff10

replace ivpred_white10 = white00 + pred_whitediff10 if year==1910

* going to use the black values later for the no flight case

gen italian_black10 = ivpred_black10
gen italian_black20 = ivpred_black20
gen italian_black30 = ivpred_black30
              
gen ivpred_black = black00 if year==1900
replace ivpred_black = ivpred_black10 if year==1910
replace ivpred_black = ivpred_black20 if year==1920
replace ivpred_black = ivpred_black30 if year==1930

gen ivpred_white = white00 if year==1900
replace ivpred_white = ivpred_white10 if year==1910
replace ivpred_white = ivpred_white20 if year==1920
replace ivpred_white = ivpred_white30 if year==1930

gen ivpred_pop = ivpred_white + ivpred_black

gen edv_ivpred_black_d = abs((ivpred_black/tblack)-(ivpred_white/twhite))
gen edv_ivpred_black_i = (ivpred_black/tblack)*(ivpred_black/ivpred_pop) if ivpred_pop>=0

local j = 1

forvalues t=1900(10)1930 {

bysort city_cd: egen isol_ivpred_black_`t' = total(edv_ivpred_black_i) if year==`t'
gen Cisol_ivpred_black_`t' = (isol_ivpred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t' & ivpred_pop>=0

summ Cisol_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[17,`j'] = r(mean)

bysort city_cd: egen diss_ivpred_black_`t' = total(edv_ivpred_black_d) if year==`t'
replace diss_ivpred_black_`t' = .5*diss_ivpred_black_`t' if year==`t'

summ diss_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[18,`j'] = r(mean)

local j = `j'+1

}


drop pred_* edv_pred* diss_pred* Cisol* isol* 

*** Ninth set: no flight baseline and allowing blacks to propagate like Italians

gen pred_white00 = white00
gen pred_white10 = white00+(pop00/tpop00)*white_city_growth10
gen pred_white20 = white10+(pop10/tpop10)*white_city_growth20 
gen pred_white30 = white20+(pop20/tpop20)*white_city_growth30 

* from Italian flight case

gen pred_black00 = black00
gen pred_black10 = italian_black10
gen pred_black20 = italian_black20
gen pred_black30 = italian_black30

gen pred_white = pred_white00 if year==1900
replace pred_white = pred_white10 if year==1910
replace pred_white = pred_white20 if year==1920
replace pred_white = pred_white30 if year==1930

gen pred_black = pred_black00 if year==1900
replace pred_black = pred_black10 if year==1910
replace pred_black = pred_black20 if year==1920
replace pred_black = pred_black30 if year==1930

gen pred_pop = pred_white + pred_black

* note by construction that tblack and twhite are the same predicted or actual (but not pop)

gen edv_pred_black_i = (pred_black/tblack)*(pred_black/pred_pop)
gen edv_pred_black_d = abs((pred_black/tblack)-(pred_white/twhite))

local j = 1

forvalues t=1900(10)1930 {

* going to report Cutler et al formula for isolation using common base (all pred_blacks)

bysort city_cd: egen isol_pred_black_`t' = total(edv_pred_black_i) if year==`t'
gen Cisol_pred_black_`t' = (isol_pred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t'

summ Cisol_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[19,`j'] = r(mean)

bysort city_cd: egen diss_pred_black_`t' = total(edv_pred_black_d) if year==`t'
replace diss_pred_black_`t' = .5*diss_pred_black_`t' if year==`t'

summ diss_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[20,`j'] = r(mean)

local j = `j'+1

}

drop ivpred_* edv_ivpred_* diss_ivpred* pred_* Cisol* isol* 

*** Tenth set:  allow flight effect to vary by range of blackshare

* (not rescaling, allowing blacks to have overall population propagation by decade)

gen ivpred_black10 = black00 + (pop00/tpop00)*black_city_growth10 if year==1910
gen ivpred_black20 = black10 + (pop10/tpop10)*black_city_growth20 if year==1920
gen ivpred_black30 = black20 + (pop20/tpop20)*black_city_growth30 if year==1930

gen ivpred_white10 = 0
gen ivpred_white20 = 0
gen ivpred_white30 = 0

* 1930

ivregress2 liml whitediff30 blackpct00 (blackdiff30 = IV_black30) i.city_cd if year==1930 & blackpct20<5
predict pred_whitediff30a
replace ivpred_white30 = white20 + pred_whitediff30a if year==1930 & blackpct20<5
ivregress2 liml whitediff30 blackpct00 (blackdiff30 = IV_black30) i.city_cd if year==1930 & blackpct20>=5 & blackpct20<10
predict pred_whitediff30b
replace ivpred_white30 = white20 + pred_whitediff30b if year==1930 & blackpct20>=5 & blackpct20<10
ivregress2 liml whitediff30 blackpct00 (blackdiff30 = IV_black30) i.city_cd if year==1930 & blackpct20>=10 & blackpct20<20
predict pred_whitediff30c
replace ivpred_white30 = white20 + pred_whitediff30c if year==1930 & blackpct20>=10 & blackpct20<20
ivregress2 liml whitediff30 blackpct00 (blackdiff30 = IV_black30) i.city_cd if year==1930 & blackpct20>=20
predict pred_whitediff30d
replace ivpred_white30 = white20 + pred_whitediff30d if year==1930 & blackpct20>=20

* 1920

ivregress2 liml whitediff20 blackpct00 (blackdiff20 = IV_black20) i.city_cd if year==1920 & blackpct10<5
predict pred_whitediff20a
replace ivpred_white20 = white10 + pred_whitediff20a if year==1920 & blackpct10<5
ivregress2 liml whitediff20 blackpct00 (blackdiff20 = IV_black20) i.city_cd if year==1920 & blackpct10>=5 & blackpct10<10
predict pred_whitediff20b
replace ivpred_white20 = white10 + pred_whitediff20b if year==1920 & blackpct10>=5 & blackpct10<10
ivregress2 liml whitediff20 blackpct00 (blackdiff20 = IV_black20) i.city_cd if year==1920 & blackpct10>=10 & blackpct10<20
predict pred_whitediff20c
replace ivpred_white20 = white10 + pred_whitediff20c if year==1920 & blackpct10>=10 & blackpct10<20
ivregress2 liml whitediff20 blackpct00 (blackdiff20 = IV_black20) i.city_cd if year==1920 & blackpct10>=20
predict pred_whitediff20d
replace ivpred_white20 = white10 + pred_whitediff20d if year==1920 & blackpct10>=20

* 1910

ivregress2 liml whitediff10 blackpct00 (blackdiff10 = IV_black10) i.city_cd if year==1910 & blackpct00<5
predict pred_whitediff10a
replace ivpred_white10 = white00 + pred_whitediff10a if year==1910 & blackpct00<5
ivregress2 liml whitediff10 blackpct00 (blackdiff10 = IV_black10) i.city_cd if year==1910 & blackpct00>=5 & blackpct00<10
predict pred_whitediff10b
replace ivpred_white10 = white00 + pred_whitediff10b if year==1910 & blackpct00>=5 & blackpct00<10
ivregress2 liml whitediff10 blackpct00 (blackdiff10 = IV_black10) i.city_cd if year==1910 & blackpct00>=10 & blackpct00<20
predict pred_whitediff10c
replace ivpred_white10 = white00 + pred_whitediff10c if year==1910 & blackpct00>=10 & blackpct00<20
ivregress2 liml whitediff10 blackpct00 (blackdiff10 = IV_black10) i.city_cd if year==1910 & blackpct00>=20
predict pred_whitediff10d
replace ivpred_white10 = white00 + pred_whitediff10d if year==1910 & blackpct00>=20

gen ivpred_black = black00 if year==1900
replace ivpred_black = ivpred_black10 if year==1910
replace ivpred_black = ivpred_black20 if year==1920
replace ivpred_black = ivpred_black30 if year==1930

gen ivpred_white = white00 if year==1900
replace ivpred_white = ivpred_white10 if year==1910
replace ivpred_white = ivpred_white20 if year==1920
replace ivpred_white = ivpred_white30 if year==1930

gen ivpred_pop = ivpred_white + ivpred_black

gen edv_ivpred_black_d = abs((ivpred_black/tblack)-(ivpred_white/twhite))
gen edv_ivpred_black_i = (ivpred_black/tblack)*(ivpred_black/ivpred_pop) if ivpred_pop>=0

local j = 1

forvalues t=1900(10)1930 {

bysort city_cd: egen isol_ivpred_black_`t' = total(edv_ivpred_black_i) if year==`t'
gen Cisol_ivpred_black_`t' = (isol_ivpred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t' & ivpred_pop>=0

summ Cisol_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[21,`j'] = r(mean)

bysort city_cd: egen diss_ivpred_black_`t' = total(edv_ivpred_black_d) if year==`t'
replace diss_ivpred_black_`t' = .5*diss_ivpred_black_`t' if year==`t'

summ diss_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[22,`j'] = r(mean)

local j = `j'+1

}

drop ivpred_* edv_ivpred_* diss_ivpred* pred_* Cisol* isol* 

*** Note:  no flight baseline for this exercise is the same as total population propagation

*** Eleventh set:  applying IV flight, not rescaling (tossing whites), constraining blacks by southern black distribution by decade

gen ivpred_black10 = black00 + (southern_black00/tsouthern_black00)*black_city_growth10
gen ivpred_black20 = black10 + (southern_black10/tsouthern_black10)*black_city_growth20
gen ivpred_black30 = black20 + (southern_black20/tsouthern_black20)*black_city_growth30

gen ivpred_white10 = 0
gen ivpred_white20 = 0
gen ivpred_white30 = 0

* 1930

ivregress2 liml whitediff30 (blackdiff30 = IV_black30) i.city_cd if year==1930

predict pred_whitediff30

replace ivpred_white30 = white20 + pred_whitediff30 if year==1930

* 1920

ivregress2 liml whitediff20 (blackdiff20 = IV_black20) i.city_cd if year==1920

predict pred_whitediff20

replace ivpred_white20 = white10 + pred_whitediff20 if year==1920

* 1910

ivregress2 liml whitediff10 (blackdiff10 = IV_black10) i.city_cd if year==1910

predict pred_whitediff10

replace ivpred_white10 = white00 + pred_whitediff10 if year==1910
              
gen ivpred_black = black00 if year==1900
replace ivpred_black = ivpred_black10 if year==1910
replace ivpred_black = ivpred_black20 if year==1920
replace ivpred_black = ivpred_black30 if year==1930

gen ivpred_white = white00 if year==1900
replace ivpred_white = ivpred_white10 if year==1910
replace ivpred_white = ivpred_white20 if year==1920
replace ivpred_white = ivpred_white30 if year==1930

gen ivpred_pop = ivpred_white + ivpred_black

gen edv_ivpred_black_d = abs((ivpred_black/tblack)-(ivpred_white/twhite))
gen edv_ivpred_black_i = (ivpred_black/tblack)*(ivpred_black/ivpred_pop) if ivpred_pop>=0

local j = 1

forvalues t=1900(10)1930 {

bysort city_cd: egen isol_ivpred_black_`t' = total(edv_ivpred_black_i) if year==`t'
gen Cisol_ivpred_black_`t' = (isol_ivpred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t' & ivpred_pop>=0

summ Cisol_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[23,`j'] = r(mean)

bysort city_cd: egen diss_ivpred_black_`t' = total(edv_ivpred_black_d) if year==`t'
replace diss_ivpred_black_`t' = .5*diss_ivpred_black_`t' if year==`t'

summ diss_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[24,`j'] = r(mean)

local j = `j'+1

}

drop pred_* edv_* diss_* isol* Cisol*

*** Twelfth set: no flight baseline, constraining blacks by SOUTHERN black distribution by decade

gen pred_white00 = white00
gen pred_white10 = white00+(pop00/tpop00)*white_city_growth10
gen pred_white20 = white10+(pop10/tpop10)*white_city_growth20 
gen pred_white30 = white20+(pop20/tpop20)*white_city_growth30 

gen pred_black00 = black00
gen pred_black10 = black00+(southern_black00/tsouthern_black00)*black_city_growth10
gen pred_black20 = black10+(southern_black10/tsouthern_black10)*black_city_growth20 
gen pred_black30 = black20+(southern_black20/tsouthern_black20)*black_city_growth30

gen pred_black = pred_black00 if year==1900
replace pred_black = pred_black10 if year==1910
replace pred_black = pred_black20 if year==1920
replace pred_black = pred_black30 if year==1930

gen pred_white = pred_white00 if year==1900
replace pred_white = pred_white10 if year==1910
replace pred_white = pred_white20 if year==1920
replace pred_white = pred_white30 if year==1930

gen pred_pop = pred_white + pred_black

* note by construction that tblack and twhite are the same predicted or actual (but not pop)

gen edv_pred_black_i = (pred_black/tblack)*(pred_black/pred_pop)
gen edv_pred_black_d = abs((pred_black/tblack)-(pred_white/twhite))

local j = 1

forvalues t=1900(10)1930 {

* going to report Cutler et al formula for isolation using common base (all pred_blacks)

bysort city_cd: egen isol_pred_black_`t' = total(edv_pred_black_i) if year==`t'
gen Cisol_pred_black_`t' = (isol_pred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t'

summ Cisol_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[25,`j'] = r(mean)

bysort city_cd: egen diss_pred_black_`t' = total(edv_pred_black_d) if year==`t'
replace diss_pred_black_`t' = .5*diss_pred_black_`t' if year==`t'

summ diss_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[26,`j'] = r(mean)

local j = `j'+1

}

drop ivpred_* pred_* Cisol* isol* 

*** Thirteenth set:  applying IV flight, not rescaling (tossing whites), constraining blacks by black distribution in 1900

gen ivpred_black10 = black00 + (black00/tblack00)*black_city_growth10
gen ivpred_black20 = black10 + (black00/tblack00)*black_city_growth20
gen ivpred_black30 = black20 + (black00/tblack00)*black_city_growth30

gen ivpred_white10 = 0
gen ivpred_white20 = 0
gen ivpred_white30 = 0

* 1930

ivregress2 liml whitediff30 (blackdiff30 = IV_black30) i.city_cd if year==1930

predict pred_whitediff30

replace ivpred_white30 = white20 + pred_whitediff30 if year==1930

* 1920

ivregress2 liml whitediff20 (blackdiff20 = IV_black20) i.city_cd if year==1920

predict pred_whitediff20

replace ivpred_white20 = white10 + pred_whitediff20 if year==1920

* 1910

ivregress2 liml whitediff10 (blackdiff10 = IV_black10) i.city_cd if year==1910

predict pred_whitediff10

replace ivpred_white10 = white00 + pred_whitediff10 if year==1910
              
gen ivpred_black = black00 if year==1900
replace ivpred_black = ivpred_black10 if year==1910
replace ivpred_black = ivpred_black20 if year==1920
replace ivpred_black = ivpred_black30 if year==1930

gen ivpred_white = white00 if year==1900
replace ivpred_white = ivpred_white10 if year==1910
replace ivpred_white = ivpred_white20 if year==1920
replace ivpred_white = ivpred_white30 if year==1930

gen ivpred_pop = ivpred_white + ivpred_black

gen edv_ivpred_black_d = abs((ivpred_black/tblack)-(ivpred_white/twhite))
gen edv_ivpred_black_i = (ivpred_black/tblack)*(ivpred_black/ivpred_pop) if ivpred_pop>=0

local j = 1

forvalues t=1900(10)1930 {

bysort city_cd: egen isol_ivpred_black_`t' = total(edv_ivpred_black_i) if year==`t'
gen Cisol_ivpred_black_`t' = (isol_ivpred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t' & ivpred_pop>=0

summ Cisol_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[27,`j'] = r(mean)

bysort city_cd: egen diss_ivpred_black_`t' = total(edv_ivpred_black_d) if year==`t'
replace diss_ivpred_black_`t' = .5*diss_ivpred_black_`t' if year==`t'

summ diss_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[28,`j'] = r(mean)

local j = `j'+1

}

drop pred_* edv_* diss_* isol* Cisol*

*** Fourteenth set: no flight baseline, constraining blacks by black distribution in 1900

gen pred_white00 = white00
gen pred_white10 = white00+(pop00/tpop00)*white_city_growth10
gen pred_white20 = white10+(pop10/tpop10)*white_city_growth20 
gen pred_white30 = white20+(pop20/tpop20)*white_city_growth30 

gen pred_black00 = black00
gen pred_black10 = black00+(black00/tblack00)*black_city_growth10
gen pred_black20 = black10+(black00/tblack00)*black_city_growth20 
gen pred_black30 = black20+(black00/tblack00)*black_city_growth30

gen pred_black = pred_black00 if year==1900
replace pred_black = pred_black10 if year==1910
replace pred_black = pred_black20 if year==1920
replace pred_black = pred_black30 if year==1930

gen pred_white = pred_white00 if year==1900
replace pred_white = pred_white10 if year==1910
replace pred_white = pred_white20 if year==1920
replace pred_white = pred_white30 if year==1930

gen pred_pop = pred_white + pred_black

* note by construction that tblack and twhite are the same predicted or actual (but not pop)

gen edv_pred_black_i = (pred_black/tblack)*(pred_black/pred_pop)
gen edv_pred_black_d = abs((pred_black/tblack)-(pred_white/twhite))

local j = 1

forvalues t=1900(10)1930 {

* going to report Cutler et al formula for isolation using common base (all pred_blacks)

bysort city_cd: egen isol_pred_black_`t' = total(edv_pred_black_i) if year==`t'
gen Cisol_pred_black_`t' = (isol_pred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t'

summ Cisol_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[29,`j'] = r(mean)

bysort city_cd: egen diss_pred_black_`t' = total(edv_pred_black_d) if year==`t'
replace diss_pred_black_`t' = .5*diss_pred_black_`t' if year==`t'

summ diss_pred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[30,`j'] = r(mean)

local j = `j'+1

}

drop ivpred_* pred_* Cisol* isol* titalian italian* share_* group_* index synthetic_*

*** Fifteenth set:  applying regression, not rescaling, blacks propagate like Italians in 1930

* note that the shares in this exercise refer to share of Italian population of city in your neighborhood

bysort city_cd year: egen titalian = total(italy)
gen italian = italy
gen share_italian = italy/titalian

local group = "italian"

gen edv_`group'_i = (`group'/t`group')*(`group'/pop)

* let's examine segregation of Italians for fun

local j = 1

forvalues t=1900(10)1930 {

bysort city_cd: egen isol_`group'_`t' = total(edv_`group'_i) if year==`t'
gen Cisol_`group'_`t' = (isol_`group'_`t' - (t`group'/tpop))/(min(t`group'/min_size,1) - (t`group'/tpop)) if year==`t'

summ Cisol_`group'_`t' if hexagonID==min_num & year==`t'
mat segregation[23,`j'] = r(mean)

local j = `j'+1

}

gen share_`group'00a = share_`group' if year==1900
gen share_`group'10a = share_`group' if year==1910
gen share_`group'20a = share_`group' if year==1920
gen share_`group'30a = share_`group' if year==1930

egen share_`group'00 = max(share_`group'00a), by(uniqueID)
egen share_`group'10 = max(share_`group'10a), by(uniqueID)
egen share_`group'20 = max(share_`group'20a), by(uniqueID)
egen share_`group'30 = max(share_`group'30a), by(uniqueID)

gen share_black = black/tblack

sort year city_cd share_black

egen group_cd = group(year city_cd)

* this index orders neighborhoods by city black share within year and city

bysort group_cd: egen index = seq()

sort year city_cd index

save all_hexagon_iv_sort.dta, replace

* now make an Italian index to merge back on using index

keep year city_cd share_`group' group_cd

sort year city_cd share_`group'

bysort group_cd: egen index = seq()

rename share_`group' synthetic_share_`group'

sort year city_cd index

save merger.dta, replace

merge year city_cd index using all_hexagon_iv_sort.dta

drop _merge

gen synthetic_share_`group'00a = synthetic_share_`group' if year==1900
gen synthetic_share_`group'10a = synthetic_share_`group' if year==1910
gen synthetic_share_`group'20a = synthetic_share_`group' if year==1920
gen synthetic_share_`group'30a = synthetic_share_`group' if year==1930

egen synthetic_share_`group'00 = max(synthetic_share_`group'00a), by(uniqueID)
egen synthetic_share_`group'10 = max(synthetic_share_`group'10a), by(uniqueID)
egen synthetic_share_`group'20 = max(synthetic_share_`group'20a), by(uniqueID)
egen synthetic_share_`group'30 = max(synthetic_share_`group'30a), by(uniqueID)

gen ivpred_white10 = 0
gen ivpred_white20 = 0
gen ivpred_white30 = 0

* change here to get 1910 or 1930 fixed distribution

gen ivpred_black10 = black00 + synthetic_share_`group'10*black_city_growth10 if year==1910
gen ivpred_black20 = black10 + synthetic_share_`group'10*black_city_growth20 if year==1920
gen ivpred_black30 = black20 + synthetic_share_`group'10*black_city_growth30 if year==1930

/*
*** to create distribution pictures

keep year city_cd index synthetic_share_italian share_black
duplicates drop
sort year city_cd index
outsheet using helper.xls, replace
*/

* 1930

ivregress2 liml whitediff30 (blackdiff30 = IV_black30) i.city_cd if year==1930

predict pred_whitediff30

replace ivpred_white30 = white20 + pred_whitediff30 if year==1930

* 1920

ivregress2 liml whitediff20 (blackdiff20 = IV_black20) i.city_cd if year==1920

predict pred_whitediff20

replace ivpred_white20 = white10 + pred_whitediff20 if year==1920

* 1910

ivregress2 liml whitediff10 (blackdiff10 = IV_black10) i.city_cd if year==1910

predict pred_whitediff10

replace ivpred_white10 = white00 + pred_whitediff10 if year==1910

* going to use the black values later for the no flight case

gen italian_black10 = ivpred_black10
gen italian_black20 = ivpred_black20
gen italian_black30 = ivpred_black30
              
gen ivpred_black = black00 if year==1900
replace ivpred_black = ivpred_black10 if year==1910
replace ivpred_black = ivpred_black20 if year==1920
replace ivpred_black = ivpred_black30 if year==1930

gen ivpred_white = white00 if year==1900
replace ivpred_white = ivpred_white10 if year==1910
replace ivpred_white = ivpred_white20 if year==1920
replace ivpred_white = ivpred_white30 if year==1930

gen ivpred_pop = ivpred_white + ivpred_black

gen edv_ivpred_black_d = abs((ivpred_black/tblack)-(ivpred_white/twhite))
gen edv_ivpred_black_i = (ivpred_black/tblack)*(ivpred_black/ivpred_pop) if ivpred_pop>=0

local j = 1

forvalues t=1900(10)1930 {

bysort city_cd: egen isol_ivpred_black_`t' = total(edv_ivpred_black_i) if year==`t'
gen Cisol_ivpred_black_`t' = (isol_ivpred_black_`t' - (tblack/tpop))/(min(tblack/min_size,1) - (tblack/tpop)) if year==`t' & ivpred_pop>=0

summ Cisol_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[17,`j'] = r(mean)

bysort city_cd: egen diss_ivpred_black_`t' = total(edv_ivpred_black_d) if year==`t'
replace diss_ivpred_black_`t' = .5*diss_ivpred_black_`t' if year==`t'

summ diss_ivpred_black_`t' if hexagonID==min_num & year==`t'
mat segregation[18,`j'] = r(mean)

local j = `j'+1

}


drop pred_* edv_pred* diss_pred* Cisol* isol* 

drop _all
svmat segregation
outsheet using segregation.xls, replace






