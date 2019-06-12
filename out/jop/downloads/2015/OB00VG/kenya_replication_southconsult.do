insheet using howhappy_combo.csv, comma clear

gen happy2=.
replace happy2 = happy if veryhappy==.
replace happy2 = veryhappy+happy if veryhappy!=.

gen unhappy2=.
replace unhappy2 = unhappy if veryunhappy==.
replace unhappy2 = veryunhappy+unhappy if veryunhappy!=.

gen ci95 = 1.96/(2*sqrt(n))
replace ci95=ci95*100

gen happy2_lb = happy2-ci95
gen happy2_ub = happy2+ci95
gen unhappy2_lb = unhappy2-ci95
gen unhappy2_ub = unhappy2+ci95

gen monthnum = ((year-2010)*12)+month

keep happy2 monthnum region
reshape wide happy2, i(monthnum) j(region)
rename happy21 Nairobi
rename happy22 Coast
rename happy23 NorthEastern
rename happy24 Eastern
rename happy25 Central
rename happy26 RiftValley
rename happy27 Western
rename happy28 Nyanza

local leg legend(order(1 "Central" 2 "Rift Valley"))
local leg2 xlabel(11 "Nov 10" 21 "Sep 11" 22 " " 26 "Feb 12")
twoway connect Central RiftValley monthnum, `leg' `leg2' xtitle("Date") ytitle("Percent Happy with ICC") title("Kenyatta/Ruto Regions")
	graph save uhuruto.gph, replace

local leg legend(order(1 "Nyanza" 2 "Western"))
local leg2 xlabel(11 "Nov 10" 21 "Sep 11" 22 " " 26 "Feb 12")

twoway connect Nyanza Western monthnum, `leg' `leg2' xtitle("Date") ytitle("Percent Happy with ICC") title("Odinga Regions")
	graph save odinga.gph, replace
	graph combine uhuruto.gph odinga.gph, ycomm xcomm
