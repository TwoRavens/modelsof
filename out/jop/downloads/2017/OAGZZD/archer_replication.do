/*
archer
political advan, disadvan, and the demand for partisan news
replication file
*/

*************
* FL PAPERS *
*************
// DV: changes from year after election year in t-4 to year after most recent election year
clear
* open "FL_circulations_replication.csv"

* note: st. pete = tampa bay times (prev. st. pete times)

reg didr_tplusone gopmargpct, robust
scatter didr_tplusone gopmargpct 

gen totaltampacircs=(stpete_yrafter + tampa_yrafter)
sum totaltampacircs

sum gopmargpct

// additional vars
gen changegdp=gdp-gdp_last
tab changegdp

gen gopmargpct_last=gopmargpct[_n-1]
list gopmargpct gopmargpct_last

gen radioprd=0
replace radioprd=1 if circyr>1929 & circyr<1953
tab radioprd
list circyr radioprd

gen tvprd=0
replace tvprd=1 if circyr>1953
tab tvprd
list circyr tvprd

gen time=.
replace time=1 if circyr ==1932
replace time=2 if circyr ==1936
replace time=3 if circyr ==1940
replace time=4 if circyr ==1944
replace time=5 if circyr ==1948
replace time=6 if circyr ==1952
replace time=7 if circyr ==1956
replace time=8 if circyr ==1960
replace time=9 if circyr ==1964
replace time=10 if circyr ==1968
replace time=11 if circyr ==1972
replace time=12 if circyr ==1976
replace time=13 if circyr ==1980
replace time=14 if circyr ==1984
replace time=15 if circyr ==1988
replace time=16 if circyr ==1992
replace time=17 if circyr ==1996
replace time=18 if circyr ==2000
replace time=19 if circyr ==2004
replace time=20 if circyr ==2008
replace time=21 if circyr ==2012
tab time

gen timesq=(time^2)
tab timesq

* create change in gop margin between last election and current election
gen gopmargpctchange=(gopmargpct-gopmargpct_last)
tab gopmargpctchange

* elex yr diffs 
gen elexyrafterdiff=(tampa_yrafter-stpete_yrafter)

gen elexyrafterdiffpct=(elexyrafterdiff/(stpete_yrafter + tampa_yrafter))*100
tab elexyrafterdiffpct

gen elexyrafterdifflagpct=elexyrafterdiffpct[_n-1]
tab elexyrafterdifflagpct

list circyr elexyrafterdiffpct elexyrafterdifflagpct

// table 1 analyses
reg didr_tplusone gopmargpct, robust 
reg didr_tplusone gopmargpct changegdp, robust
reg didr_tplusone gopmargpct gopmargpct_last, robust
reg didr_tplusone gopmargpct radioprd, robust
reg didr_tplusone gopmargpct time timesq, robust

	
// ONLINE APPENDIX A: change in gop vote margin as only IV
reg didr_tplusone gopmargpctchange, robust

// ONLINE APPENDIX B: comparing to DV using year of election
gen stpete_lagged=stpete_m[_n-1]
list circyr stpete_m stpete_lagged

gen tampa_lagged=tampa_m[_n-1]
list circyr tampa_m tampa_lagged

gen didr=(((tampa_m-tampa_lagged)-(stpete_m-stpete_lagged))/(stpete_m + tampa_m))*100

reg didr gopmargpct, robust 

corr didr_tplusone didr
	*correlation=0.92

*******************
* alternative specification
* open "UoA_FLpaperspartyyear.dta"

gen timesq=time^2
list year time timesq

gen changegdp=gdp-gdp_last

gen radioprd=0
replace radioprd=1 if year>1929 & year<1953
tab radioprd
list year radioprd

gen tvprd=0
replace tvprd=1 if year>1953
tab tvprd
list year tvprd
	
gen yr1940s=0
replace yr1940s=1 if year>1939&year<1950

gen yr1950s=0
replace yr1950s=1 if year>1949&year<1960
	
gen yr1960s=0
replace yr1960s=1 if year>1959&year<1970

gen yr1970s=0
replace yr1970s=1 if year>1969&year<1980

gen yr1980s=0
replace yr1980s=1 if year>1979&year<1990

gen yr1990s=0
replace yr1990s=1 if year>1989&year<2000

gen yr2000s=0
replace yr2000s=1 if year>1999&year<2010

gen yr2010s=0
replace yr2010s=1 if year>2009&year<2020

list year yr1940s yr1950s yr1960s yr1970s yr1980s yr1990s yr2000s yr2010s

gen diffcirc_yrafter=circyrafter-laggedyraftercirc

// table 1, column 6
reg diffcirc_yrafter winner yr1940s yr1950s yr1960s yr1970s yr1980s yr1990s yr2000s yr2010s, cluster(year) robust

// ONLINE APPENDIX A: additional controls and IVs
reg diffcirc_yrafter winner changegdp yr1940s yr1950s yr1960s yr1970s yr1980s yr1990s yr2000s yr2010s, cluster(year) robust
reg diffcirc voteshare yr1940s yr1950s yr1960s yr1970s yr1980s yr1990s yr2000s yr2010s, cluster(year) robust


********************
* ALL LOCAL PAPERS *
********************

// data transformation
clear
* open "all_circulations_replication.csv"

// IVs 
gen gopmargpct=.
replace gopmargpct=((gopvote-demvote)/totalvotes)*100
tab gopmargpct

gen gopmargpct_last=.
replace gopmargpct_last=gopmargpct[_n-1]
tab gopmargpct_last
list year gopmargpct gopmargpct_last

gen gopmargchange=(gopmarg-gopmarg_last)
tab gopmargchange

gen gopmargpctchange=(gopmargpct-gopmargpct_last)
tab gopmargpctchange

gen changegdp=gdp-gdp_last
tab changegdp

gen radioprd=0
replace radioprd=1 if year>1929 & year<1953
tab radioprd
list year radioprd

gen tvprd=0
replace tvprd=1 if year>1953
tab tvprd
list year tvprd

gen time=.
replace time=1 if year==1932
replace time=2 if year==1936
replace time=3 if year==1940
replace time=4 if year==1944
replace time=5 if year==1948
replace time=6 if year==1952
replace time=7 if year==1956
replace time=8 if year==1960
replace time=9 if year==1964
replace time=10 if year==1968
replace time=11 if year==1972
replace time=12 if year==1976
replace time=13 if year==1980
replace time=14 if year==1984
replace time=15 if year==1988
replace time=16 if year==1992
replace time=17 if year==1996
replace time=18 if year==2000
replace time=19 if year==2004
tab time

gen timesq=(time^2)
tab timesq

// DVs
gen totalcircs=circsumr+circsumd+circsumi+circsumn
tab totalcircs

gen totalcircs_last=totalcircs[_n-1]
tab totalcircs_last

gen didrpct=.
replace didrpct=(((circsumr-circsumrlast)-(circsumd-circsumdlast))/totalcircs)*100
tab didrpct

gen didripct=.
replace didripct=(((circsumr-circsumrlast)-(circsumi-circsumilast))/totalcircs)*100
tab didripct

gen diddipct=.
replace diddipct=(((circsumd-circsumdlast)-(circsumi-circsumilast))/totalcircs)*100
tab diddipct

* subscription difference in year t as DV 
gen elexyrdiff=(circsumr-circsumd)
tab elexyrdiff

gen elexyrdifflag=elexyrdiff[_n-1]
list year elexyrdiff elexyrdifflag

gen elexyrdiffpct=(elexyrdiff/totalcircs)*100
tab elexyrdiffpct

gen elexyrdifflagpct=(elexyrdifflag/totalcircs_last)*100
tab elexyrdifflagpct

// Analyses

* table 2 
reg didrpct gopmargpct if year>1928, robust
reg didrpct gopmargpct changegdp if year>1928, robust
reg didrpct gopmargpct gopmargpct_last if year>1928, robust 
reg didrpct gopmargpct radioprd if year>1928, robust
reg didrpct gopmargpct time timesq if year>1928, robust

reg elexyrdiffpct gopmargpct elexyrdifflagpct if year>1928, robust

* table 3 analyses
* note: House data from http://history.house.gov/Institution/Party-Divisions/Party-Divisions/
gen hseats_pct=((hrep_elexyr-hdem_elexyr)/435)*100

reg didrpct hseats_pct if year>1928, robust
reg didrpct hseats_pct gopmargpct if year>1928, robust
reg didrpct hseats_pct gopmargpct changegdp if year>1928, robust
reg didrpct hseats_pct gopmargpct gopmargpct_last if year>1928, robust
reg didrpct hseats_pct gopmargpct radioprd if year>1928, robust
reg didrpct hseats_pct gopmargpct time timesq if year>1928, robust

reg didrpct hseats_pct gopmargpctchange if year>1928, robust
reg elexyrdiffpct hseats_pct gopmargpct elexyrdifflagpct if year>1928, robust

corr hseats_pct gopmargpct

// MISC. ANALYSES DISCUSSED IN PAPER / ONLINE APPENDIX

* substantive interpretation of model 1, table 2
sum gopmargpct if year>1928
sum totalcircs if year>1928
di (-0.10*13.06/100)*(5.31e+07)

* objective news as baseline
reg didripct gopmargpct if year>1928, robust
reg diddipct gopmargpct if year>1928, robust

* Table A2: alternative models
gen didrpct2=.
replace didrpct2=(((circsumr-circsumrlast)-(circsumd-circsumdlast))/totalcircs_last)*100
tab didrpct2

gen didrpct3=(((circsumr-circsumrlast)/circsumrlast)*100)-(((circsumd-circsumdlast)/circsumdlast)*100)
tab didrpct3   

gen repratechange=((circsumr-circsumrlast)/circsumrlast)*100
tab repratechange   

gen gopvotepct=(gopvote/totalvotes)*100
tab gopvotepct

gen demratechange=((circsumd-circsumdlast)/circsumdlast)*100
tab demratechange

gen demvotepct=(demvote/totalvotes)*100
tab demvotepct

reg didrpct gopmargpct if year>1928, robust
reg didrpct2 gopmargpct if year>1928, robust
reg didrpct3 gopmargpct if year>1928, robust
reg didrpct gopmargpct gdp if year>1928, robust
reg didrpct gopmargpctchange if year>1928, robust
reg repratechange gopvotepct if year>1928, robust
reg demratechange demvotepct if year>1928, robust

* Table A3: analyses with raw data
reg didr gopmarg if year>1928, robust
reg didr gopmarg changegdp if year>1928, robust
reg didr gopmarg gopmarg_last if year>1928, robust
reg didr gopmarg radioprd if year>1928, robust
reg didr gopmarg time timesq if year>1928, robust

reg didr gopmargchange if year>1928, robust
reg elexyrdiff gopmarg elexyrdifflag if year>1928, robust

* Table A4: regress election year difference on gopvoteshare
gen gopvoteshare=(gopvote/totalvotes)*100
reg elexyrdiff gopvoteshare if year>1928, robust

	* Gentzkow, Shapiro, Sinkinson (2014) relate gop vote share to relative subscriptions to alleviate concerns about partisanship of papers changing
	gen gopvoteshare=(gopvote/totalvotes)*100
	reg elexyrdiffpct gopvoteshare if radioprd==1
	reg elexyrdiffpct gopvoteshare if tvprd==1
	reg elexyrdiffpct gopvoteshare 

* Table A4: dividing time period of main analysis into thirds
gen yr1932to1956=0
replace yr1932to1956=1 if year>1931&year<1957
list yr1932to1956 year

gen yr1960to1980=0
replace yr1960to1980=1 if year>1956&year<1981
list yr1960to1980 year

gen yr1984to2004=0
replace yr1984to2004=1 if year>1981
list yr1984to2004 year

gen yr1932to1956Xgopmargpct=yr1932to1956*gopmargpct
gen yr1960to1980Xgopmargpct=yr1960to1980*gopmargpct
gen yr1984to2004Xgopmargpct=yr1984to2004*gopmargpct

reg didrpct gopmargpct yr1960to1980 yr1984to2004 yr1960to1980Xgopmargpct yr1984to2004Xgopmargpct if year>1928, robust
lincom gopmargpct+yr1960to1980Xgopmargpct
lincom gopmargpct+yr1984to2004Xgopmargpct

* Table A5: analyses with alternative DV that removes nonpartisan papers from denom
gen didrpct_RDdenom=.
replace didrpct_RDdenom=(((circsumr-circsumrlast)-(circsumd-circsumdlast))/(circsumr+circsumd))*100
tab didrpct_RDdenom

reg didrpct_RDdenom gopmargpct if year>1928, robust
reg didrpct_RDdenom gopmargpct changegdp if year>1928, robust
reg didrpct_RDdenom gopmargpct gopmargpct_last if year>1928, robust 
reg didrpct_RDdenom gopmargpct radioprd if year>1928, robust
reg didrpct_RDdenom gopmargpct time timesq if year>1928, robust

* Table A6: IV denominator as just sum of D and R votes
gen gopmargpct2=.
replace gopmargpct2=((gopvote-demvote)/(gopvote+demvote))*100
tab gopmargpct2

reg didrpct gopmargpct2 if year>1928, robust
reg didrpct gopmargpct2 changegdp if year>1928, robust
reg didrpct gopmargpct2 gopmargpct_last if year>1928, robust 
reg didrpct gopmargpct2 radioprd if year>1928, robust
reg didrpct gopmargpct2 time timesq if year>1928, robust

reg didrpct gopmargpctchange2 if year>1928, robust

* Table A7: placebo tests using GOPMARGPCT from before/after current election
gen gopmargpct_next=gopmargpct[_n+1]
list year gopmargpct gopmargpct_next

gen gopmargpct_next2=gopmargpct[_n+2]
list year gopmargpct gopmargpct_next2

gen gopmargpct_last2=gopmargpct[_n-2]
list year gopmargpct gopmargpct_last gopmargpct_last2

reg didrpct gopmargpct_next2 time timesq if year>1928, robust 
reg didrpct gopmargpct_next time timesq if year>1928, robust 
reg didrpct gopmargpct_last time timesq if year>1928, robust 
reg didrpct gopmargpct_last2 time timesq if year>1928, robust

* Table A8: differential effects of GOPMARGPCT in competitive elections
list year gopmargpct
sum gopmargpct

gen closeelex=0
replace closeelex=1 if gopmargpct >-10.01 & gopmargpct < 10.01
tab closeelex
list year closeelex gopmargpct

gen gopmargpctXcloseelex=gopmargpct*closeelex

reg didrpct gopmargpct closeelex gopmargpctXcloseelex if year>1928, robust
lincom gopmargpct+gopmargpctXcloseelex

*******************************************
* Table A1: non-former Confederate states *
*******************************************

clear
* open "nonsouth_circulations_replication.csv"

gen didr=(((circr-circr_prev)-(circd-circd_prev))/totalcircs)*100

gen elexyrdiff=((circr-circd)/totalcircs)*100
gen elexyrdiff_prev=((circr_prev-circd_prev)/(totalcircs_last))*100

gen gopmargpct=.
replace gopmargpct=((gopvote-demvote)/totalvotes)*100
tab gopmargpct

reg didr gopmargpct if year>1928, robust
reg elexyrdiff gopmargpct elexyrdiff_prev if year>1928, robust

*************************************
* Cities with One R and One D Paper * 
*************************************

clear
* open "twopapercities_circulations_replication.csv"

gen gopmargpct=.
replace gopmargpct=((gopvote-demvote)/totalvotes)*100
tab gopmargpct

gen didr_2p=.
replace didr_2p=((circr_2p-circrlag_2p)-(circd_2p-circdlag_2p))
tab didr_2p

gen didrpct_2p=.
replace didrpct_2p=((((circr_2p-circrlag_2p)-(circd_2p-circdlag_2p))/totalcircs) *100)
tab didrpct_2p

// analyses
reg didrpct_2p gopmargpct if year>1928, robust

**********************************************************
* Alternative Specification: unit of analysis party-year *
**********************************************************

* open  "allcircs_state_appended.dta"

gen changegdp=gdp-gdp_last

encode state, generate(istate)

* state-year fixed effects
egen stateyr = concat (state year), punct(" ")
encode stateyr, generate(istateyr)
egen unique = tag(istateyr)
list unique

gen hseats=.
replace hseats=117 if year==1932 & dempaper==0
replace hseats=88 if year==1936 & dempaper==0
replace hseats=162 if year==1940 & dempaper==0
replace hseats=189 if year==1944 & dempaper==0
replace hseats=171 if year==1948 & dempaper==0
replace hseats=221 if year==1952 & dempaper==0
replace hseats=203 if year==1956 & dempaper==0
replace hseats=173 if year==1960 & dempaper==0
replace hseats=140 if year==1964 & dempaper==0
replace hseats=192 if year==1968 & dempaper==0
replace hseats=192 if year==1972 & dempaper==0
replace hseats=143 if year==1976 & dempaper==0
replace hseats=192 if year==1980 & dempaper==0
replace hseats=180 if year==1984 & dempaper==0
replace hseats=173 if year==1988 & dempaper==0
replace hseats=176 if year==1992 & dempaper==0
replace hseats=226 if year==1996 & dempaper==0
replace hseats=220 if year==2000 & dempaper==0
replace hseats=233 if year==2004 & dempaper==0
replace hseats=313 if year==1932 & dempaper==1
replace hseats=334 if year==1936 & dempaper==1
replace hseats=267 if year==1940 & dempaper==1
replace hseats=244 if year==1944 & dempaper==1
replace hseats=263 if year==1948 & dempaper==1
replace hseats=213 if year==1952 & dempaper==1
replace hseats=232 if year==1956 & dempaper==1
replace hseats=264 if year==1960 & dempaper==1
replace hseats=295 if year==1964 & dempaper==1
replace hseats=243 if year==1968 & dempaper==1
replace hseats=243 if year==1972 & dempaper==1
replace hseats=292 if year==1976 & dempaper==1
replace hseats=243 if year==1980 & dempaper==1
replace hseats=255 if year==1984 & dempaper==1
replace hseats=262 if year==1988 & dempaper==1
replace hseats=258 if year==1992 & dempaper==1
replace hseats=207 if year==1996 & dempaper==1
replace hseats=213 if year==2000 & dempaper==1
replace hseats=201 if year==2004 & dempaper==1
tab hseats

// analyses
set matsize 1000

reg diffcirc winner i.istateyr, robust
reg diffcirc winner i.istate i.year, robust
reg diffcirc voteshare i.istateyr, robust
reg diffcirc voteshare i.istate i.year, robust

reg diffcirc winner hseats i.istateyr, robust
reg diffcirc voteshare hseats i.istateyr, robust

* drop former Confederate States
gen southern=0
replace southern=1 if state=="ALABAMA"|state=="FLORIDA"|state=="GEORGIA"|state=="LOUISIANA"|state=="MISSISSIPPI"|state=="SOUTH CAROLINA"|state=="TEXAS"|state=="ARKANSAS"|state=="NORTH CAROLINA"|state=="TENNESSEE"|state=="VIRGINIA"
tab southern

reg diffcirc winner i.istateyr if southern==0, robust


*********************************
* current vs. prev year's circs *
*********************************
clear
* open "additional_circulations.csv"

* delete line for 2010 circs because data do not exist
drop in  81
destring, replace

//ajc
gen atl_mlast=atl_m[_n-1]
list atl_m atl_mlast 
reg atl_m atl_mlast
est store AJC

//azr
gen azrep_mlast=azrep_m[_n-1]
list azrep_m azrep_mlast
reg azrep_m azrep_mlast
est store AZR

//cst
gen cst_mlast=cst_m[_n-1]
list cst_m cst_mlast
reg cst_m cst_mlast
est store CST

//ct
gen ctrib_mlast=ctrib_m[_n-1]
list ctrib_m ctrib_mlast
reg ctrib_m ctrib_mlast
est store CT

//lat
gen lat_mlast=lat_m[_n-1]
list lat_m lat_mlast
reg lat_m lat_mlast
est store LAT

//nyt
gen nyt_mlast=nyt_m[_n-1]
list nyt_m nyt_mlast
reg nyt_m nyt_mlast
est store NYT

//pi
gen philly_mlast=philly_m[_n-1]
list philly_m philly_mlast
reg philly_m philly_mlast
est store PI

//spt
gen stpete_mlast=stpete_m[_n-1]
list stpete_m stpete_mlast
reg stpete_m stpete_mlast
est store SPT

//tt
gen tampa_mlast=tampa_m[_n-1]
list tampa_m tampa_mlast
reg tampa_m tampa_mlast
est store TT

//wp
gen wapo_mlast=wapo_m[_n-1]
list wapo_m wapo_mlast
reg wapo_m wapo_mlast
est store WP

//ws
gen wastar_mlast=wastar_m[_n-1]
list wastar_m wastar_mlast
reg wastar_m wastar_mlast
est store WS

//wsj
gen wsj_mlast=wsj_m[_n-1]
list wsj_m wsj_mlast
reg wsj_m wsj_mlast
est store WSJ

//wt
gen watime_mlast=watime_m[_n-1]
list watime_m watime_mlast
reg watime_m watime_mlast
est store WT

est table AJC AZR CST CT LAT NYT PI SPT TT WP WS WSJ WT, b(%9.2f) star(.1 .05 .01) stats(N) eq(1)
est table AJC AZR CST CT LAT NYT PI SPT TT WP WS WSJ WT, b(%9.2f) se stats(N) eq(1) style(col)

di (0.96+0.99+0.89+1+0.98+1.04+0.95+0.97+0.93+0.98+0.96+1+0.25)/13

