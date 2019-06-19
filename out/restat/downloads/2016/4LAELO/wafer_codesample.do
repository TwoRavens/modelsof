*****************************************************************************
* wafer_codesample.do
* Byrne, Kovak, and Michaels - REStat
* Quality-Adjusted Price Measurement
*
* Cleans raw GSA wafer transaction price data, codes variables used
* in analysis, and restricts sample.
*
* Sample restrictions: 
* - Q1 2004 - Q4 2010
* - Production runs (no engineering)
* - 150-300mm wafers (no 100mm)
* - CMOS only
* - Pure-play foundry production only (no IDM)
* - Drops Europe (Other), Japan, and Korea
*****************************************************************************

set more off
capture log close
clear
clear matrix

log using wafer_codesample.txt, text replace

use gsa_wafer_raw, clear // Not included in replication archive.  Researchers must apply to GSA for data access.

*************************
* code important variables

rename quarter qtrstr
gen quarter = .
replace quarter=1 if qtrstr=="Q2 2004" // calendar Q1 2004
replace quarter=2 if qtrstr=="Q3 2004"
replace quarter=3 if qtrstr=="Q4 2004"
replace quarter=4 if qtrstr=="Q1 2005"
replace quarter=5 if qtrstr=="Q2 2005"
replace quarter=6 if qtrstr=="Q3 2005"
replace quarter=7 if qtrstr=="Q4 2005"
replace quarter=8 if qtrstr=="Q1 2006"
replace quarter=9 if qtrstr=="Q2 2006"
replace quarter=10 if qtrstr=="Q3 2006"
replace quarter=11 if qtrstr=="Q4 2006"
replace quarter=12 if qtrstr=="Q1 2007"
replace quarter=13 if qtrstr=="Q2 2007"
replace quarter=14 if qtrstr=="Q3 2007"
replace quarter=15 if qtrstr=="Q4 2007"
replace quarter=16 if qtrstr=="Q1 2008"
replace quarter=17 if qtrstr=="Q2 2008"
replace quarter=18 if qtrstr=="Q3 2008"
replace quarter=19 if qtrstr=="Q4 2008"
replace quarter=20 if qtrstr=="Q1 2009"
replace quarter=21 if qtrstr=="Q2 2009"
replace quarter=22 if qtrstr=="Q3 2009"
replace quarter=23 if qtrstr=="Q4 2009"
replace quarter=24 if qtrstr=="Q1 2010"
replace quarter=25 if qtrstr=="Q2 2010"
replace quarter=26 if qtrstr=="Q3 2010"
replace quarter=27 if qtrstr=="Q4 2010"
replace quarter=28 if qtrstr=="Q1 2011" // calendar Q4 2010
tab quarter, gen(q)
keep if inrange(quarter,1,28)

generate year=.
replace year=2004 if inrange(quarter,1,4)
replace year=2005 if inrange(quarter,5,8)
replace year=2006 if inrange(quarter,9,12)
replace year=2007 if inrange(quarter,13,16)
replace year=2008 if inrange(quarter,17,20)
replace year=2009 if inrange(quarter,21,24)
replace year=2010 if inrange(quarter,25,28)
replace year=2011 if inrange(quarter,29,32)

gen year04 = year==2004
gen year05 = year==2005
gen year06 = year==2006
gen year07 = year==2007
gen year08 = year==2008
gen year09 = year==2009
gen year10 = year==2010
gen year11 = year==2011

generate wafer=.
replace wafer=100 if wafersize=="100mm"
replace wafer=150 if wafersize=="150mm"
replace wafer=200 if wafersize=="200mm"
replace wafer=300 if wafersize=="300mm"

gen drop_100mm = wafer==100 // drop 100mm wafers

generate wafer150 = wafer==150
generate wafer200 = wafer==200
generate wafer300 = wafer==300

gen drop_eng = developmentstage=="E" // drop engineering runs

generate loc=.
replace loc=1 if foundrylocation=="China"
replace loc=2 if foundrylocation=="Europe" | foundrylocation=="Other"
replace loc=3 if foundrylocation=="Japan"
replace loc=4 if foundrylocation=="Malaysia"
replace loc=6 if foundrylocation=="Singapore"
replace loc=7 if foundrylocation=="South Korea"
replace loc=8 if foundrylocation=="Taiwan"
replace loc=9 if foundrylocation=="United States"

gen drop_noloc = loc>=. // drop missing location

generate china = loc==1
generate europe = loc==2
generate japan = loc==3
generate malaysia = loc==4
generate singapore = loc==6
generate korea = loc==7
generate taiwan = loc==8
generate usa = loc==9

generate cmos = process=="CMOS"
generate idm = type=="IDM"

generate line=.
replace line=500 if inlist(processgeometry,"0.5","0.45","0.6","0.8")
replace line=500 if inlist(processgeometry,">=1.0",">=1.",">1.0","1.5","1.2","1")
replace line=350 if processgeometry=="0.35"
replace line=250 if processgeometry=="0.25"
replace line=180 if processgeometry=="0.18"
replace line=150 if inlist(processgeometry,"0.14","0.15")
replace line=130 if processgeometry=="0.13"
replace line=90 if inlist(processgeometry,"0.09","0.08")
replace line=65 if inlist(processgeometry,"0.065","0.06")
replace line=45 if inlist(processgeometry,"0.040/0.045")

gen line4 = line==500
gen line5 = line==350
gen line6 = line==250
gen line7 = line==180
gen line8 = line==150
gen line9 = line==130
gen line10= line==90
gen line11= line==65
gen line12= line==45

gen epitax = epitaxial == "Y"

* fill in Q2 2005 obs that have priceperlayer = 0
gen ppl_calc = priceperwafer / masklayers
gen ppl_calc_flag = (abs(priceperlayer - ppl_calc) > 0.01) // check that priceperlayer is calculated correctly
replace priceperlayer = ppl_calc if ppl_calc_flag
drop ppl_calc ppl_calc_flag

gen drop_bigorder = waferspurchased>150000 // drop huge shipment based on conversation with Chelsea Boone (GSA) Aug 7, 2009
gen drop_nowafers = waferspurchased==.|waferspurchased==0 // drop orders with missing numwafers
gen drop_noppw = priceperwafer==.|priceperwafer==0 // drop orders with missing ppw

*************************
* identify cells that need to be dropped due to zero weight in iSuppli data
preserve

keep loc wafer line quarter
duplicates drop quarter loc wafer line, force
sort loc wafer line quarter
save wafer_bins, replace

sort loc wafer line quarter
merge 1:1 loc wafer line quarter using isuppli_shipments
drop if _merge == 2 // just weight, no observations
drop _merge

gen drop_noweight = 1 if shipments == 0 // merged with zero weight
replace drop_noweight = 1 if shipments >= .
replace drop_noweight = 0 if drop_noweight != 1
replace drop_noweight = 0 if loc >= . // can't blame a lack of weight when foundry location is unknown
sort loc wafer line quarter
save drop_noweight, replace

restore

*************************
* merge in indicators for cells that need to be dropped due to zero weight

sort loc wafer line quarter
merge m:1 loc wafer line quarter using drop_noweight
drop _merge
replace drop_noweight = 0 if drop_noweight >= . // replace missings with zeros

*************************
* dropped observations summary stats

* drop engineering, 100mm, non-CMOS, IDM, and post-2010 observations before reporting
drop if drop_eng | drop_100mm | (!cmos) | idm | year>2010
drop drop_eng drop_100mm cmos idm year11

* drop Europe, Japan, Korea
drop if inlist(loc,2,3,7)

* dropped observation statistics
gen drop_any = drop_noloc | drop_bigorder | drop_nowafers | drop_noweight
tab drop_any
tab drop_noloc
tab drop_bigorder
tab drop_noweight
tab drop_nowafers

*************************
* drop remaining unused observations and save for analysis

drop if drop_noloc | drop_bigorder | drop_nowafers | drop_noweight
drop drop_any drop_noloc drop_bigorder drop_nowafers drop_noweight

save wafer, replace


log close
