* To construct the data, run in this order: 1.	leader data prep file.do, 2. data prep file.do
*DON'T TRY TO EXECUTE THIS DO-FILE IN A SINGLE RUN. IT IS LONG AND SOME PARTS TAKE A V. LONG TIME TO COMPLETE. USE DISCRETE PARTS TO REPRODUCE PARTICULAR TABLES. 
*You will need to adjust the "use" commands to record the location where you have the data files. 


*Table 1

use "C:\Democracy\Archigos_v.2.9_tv-Public.dta", clear
save "C:\Democracy\AJPS\fortable1.dta", replace
*combine Germany and W Germany*
replace ccode= 255 if ccode==260
*rename pre-1910 "South Korea" as "Korea"*
replace ccname="Korea" if ccode==730
*Vietnam*
replace ccode = 818 if ccode==815
replace ccode = 818 if ccode==816&year>1976
*change Serbia ccode*
replace ccode = 342 if ccode==340
*change Pakistan ccode*
replace ccode = 770 if ccode==769
*combine Austria-Hungary with Austria*
replace ccode = 305 if ccode==300
gen cyear = ccode*10000+year
sort cyear
replace exit_tv = 0 if exit_tv==-888
egen leaderid = group(leadid)
save "C:\Democracy\AJPS\fortable1.dta", replace
merge cyear using "C:\Democracy\AJPS\Maddison longi.dta", sort uniqusing
sort cyear
gen case=_n
tsset case
egen tag = tag(cyear)
gen z = .
replace z =l.gdppc if tag==1&l.ccode==ccode
bysort cyear: egen lgdppc=min(z)
drop z
*this gets lagged gdppc that is correct even when multiple leader changes in same year
drop if leadid==""
sort leaderid year
drop case
gen case = _n
tsset case
drop if leaderid==F.leaderid&year==F.year
*reduce to just one leader per year, the last
xtset leaderid year
drop _merge
drop if ccname==""
sort cyear
save "C:\Democracy\AJPS\fortable1.dta", replace

insheet using "C:\Democracy\April 13 2011 Version\Copy of p4v2009.txt", clear
xtset ccode year
replace ccode = 347 if country=="Kosovo"
*remove duplicate Yugoslavia 1991 entry*
drop if cyear==3451991
replace ccode = 345 if country=="Yugoslavia"
replace ccode=345 if country=="Serbia and Montenegro"&year>2002&year<2007
replace ccode = 341 if country=="Montenegro"
*remove duplicate Ethiopia 1993 entry*
drop if cyear==5291993
replace ccode=530 if country=="Ethiopia"
*consolidate Pakistan entries*
replace ccode=770 if country=="Pakistan"
*combine WG with Prussia and Germany with ccode = 255*
drop if cyear==2601945
drop if cyear==2601990
replace ccode=255 if ccode==260
*correct error in Iran*
replace polity2=-9 if country=="Iran"&year==1979
replace polity2=-8 if country=="Iran"&year==1980
replace polity2=-7 if country=="Iran"&year==1981
*code Hungary as -7 in 1956, same as in 1955 and 1957; Polity codes this as foreign occupied, so it otherwise falls out of the data*
replace polity2=-7 if country=="Hungary"&year==1956
drop if year==1922&country=="Russia"
replace ccode=365 if ccode==364
*make consistent cyear*
drop cyear
gen cyear = ccode*10000 + year

*drop missing values*
replace democ = . if democ<-10
replace autoc = . if autoc <-10
replace polity2 = . if polity2 <-10
replace polity2 = . if polity==-77
xtset ccode year
by ccode: ipolate polity2 year, gen(pol3)
replace pol3=. if polity2==.&polity~=-77&polity~=-88
replace polity2=pol3

*I interpolate linearly to replace Polity's code for transitional or interregnum years (-88 and -77).
*I leave years of foreign occupation (polity = -66) as missing. Polity codes the interregnum years (polity=-77) as 0.
*This means that, for instance, during Afghanistan's civil war after 1991 the country's regime shot up to 0 from -8, only to fall back down
*to -7 when the Taliban took over. My code is not perfect--the -66 years are included in the interpolations, but then replaced by missing--but is very close to right.

*Make rescaled polity2 variable*
gen pol2norm = .
replace pol2norm = (5*polity2+50)/100 if polity2~=.

xtset ccode year
gen d10pol2=f9.polity2-l.polity2
replace d10pol2 = f10.polity2-polity2 if country=="Mexico"&year==1994
replace d10pol2 = f10.polity2-polity2 if country=="Portugal"&year==1974
replace d10pol2 = 15.5 if year==1989&country=="Czechoslovakia"
* I am interested in the level of polity2 at the time of leader change. In these cases, there was polity change in the given year before the leader change, so I start from the end of year polity2 value and take the 10 years that follow it.
*In case of Czechoslovakia: use the average Polity2 scores of Slovak and Czech Republics at end of 1999, 9.5, minus the Polity2 score for Czechoslovakia in 1989, -6
replace d10pol2 = 3 if country=="Malaysia"&year==2003
*use figure for 8 years after turnover, since data end there
gen lpolity2=l.polity2

save "C:\Democracy\AJPS\polwork.dta", replace
use "C:\Democracy\AJPS\fortable1.dta", clear
sort cyear
merge cyear using "C:\Democracy\AJPS\polwork.dta", sort uniqusing
drop _merge
save "C:\Democracy\AJPS\fortable1.dta", replace

gen inyear = year(eindate)
gen outyear = year(eoutdate)
replace outyear=. if exit==-888
gen tenureleader = outyear - inyear
drop if leader==""
bysort leaderid: gen x = lgdppc if outyear==year&outyear~=.
bysort leaderid: egen loutgdppc = mean(x)
drop x
bysort leaderid: gen y = lgdppc if inyear==year&inyear~=.
bysort leaderid: egen lingdppc = mean(y)
drop y
*so outgdp and ingdp refer to level at end of preceding year.
bysort leaderid: gen x = gdppc if outyear==year&outyear~=.
bysort leaderid: egen outgdppc = mean(x)
drop x
bysort leaderid: gen y = gdppc if inyear==year&inyear~=.
bysort leaderid: egen ingdppc = mean(y)
drop y
gen deltagdppc = outgdppc/ingdppc
gen avgrowth = (exp(ln(deltagdp)/tenureleader) -1)*100
xtset leaderid year
gen oneyrgrow = ((gdppc/l.gdppc)-1)*100 
gen loneyrgrow = l.oneyrgrow
bysort leaderid: gen x = pol2norm if outyear==year&outyear~=.
bysort leaderid: egen pol2out = mean(x)
drop x
xtset leaderid year

gen dummy = 1
replace dummy=0 if year==outyear
by leaderid, sort: egen y = sum(polity2*dummy)
gen avpolity2 = y/(outyear-inyear)
drop dummy y
bysort leaderid: gen x = lpolity2 if year==outyear
bysort leaderid: egen polity2beforeout = mean(x)
drop x
bysort leaderid: gen x = polity2 if inyear==year&inyear~=.
bysort leaderid: egen polity2in = mean(x)
drop x
bysort leaderid: gen x = lpolity2 if year==inyear
bysort leaderid: egen polity2beforein = mean(x)
drop x
gen deltapolity2 = polity2beforeout - polity2beforein
replace deltapolity2 = polity2beforeout - polity2in if leader=="Lee Kuan Yew"
replace deltapolity2 = polity2beforeout - polity2in if leader=="Idris"
*measure Polity2 change from end of turnover year rather than its beginning because no Polity2 score for previous year, as leader entered in first year of independence

list ccname leader inyear outyear  deltapolity2 d10pol2 if year==outyear&lingdppc<6000&loutgdppc>6000&polity2in<6
mean(d10pol2) if year==outyear&lingdppc<6000&loutgdppc>6000&polity2in<6

list ccname leader inyear outyear  deltapolity2 d10pol2 if year==outyear&lingdppc<5000&loutgdppc>5000&polity2in<6
mean(d10pol2) if year==outyear&lingdppc<5000&loutgdppc>5000&polity2in<6

list ccname leader inyear outyear  deltapolity2 d10pol2 if year==outyear&lingdppc<7000&loutgdppc>7000&polity2in<6
mean(d10pol2) if year==outyear&lingdppc<7000&loutgdppc>7000&polity2in<6

save "C:\Democracy\AJPS\fortable1.dta", replace

*But the average Polity2 increase 10 years after the dictator left, +8.1 on a 21-point scale, far exceeds the average for nondemocracies, +1.1.
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen pol10 = F10.polity2 - polity2
mean (pol10) if polity2<6

*Countries that reach a perfect 10—18 percent during the 20th century—cannot rise higher, however much they modernize. 
insheet using "C:\Democracy\April 13 2011 Version\Copy of p4v2009.txt", clear
gen pol10 = 0
replace pol10=1 if polity2==10
replace pol10=. if polity2==.
mean(pol10) if year>1899&year<2001


*Table 2*
*Panel A: first for just 1960-2000*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if year>1959&year<2001, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if year>1959&year<2001, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if year>1959&year<2001, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if year>1959&year<2001, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if year>1959&year<2001, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*Panel B: 1820-2008,  Polity2(t-1) < 6*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*Panel C: 1875-2004: Polity, Polity2<6 *

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom ((_b[llngdppc])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llnltdiff5 = llngdppc*ltdiff5
reg pol2norm lpol2norm llngdppc ltdiff5 llnltdiff5 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llnltdiff5])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llnltdiff10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llnltdiff10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llnltdiff10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llnltdiff15 = llngdppc*ltdiff15
reg pol2norm lpol2norm llngdppc ltdiff15 llnltdiff15 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llnltdiff15])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llnltdiff20 = llngdppc*ltdiff20
reg pol2norm lpol2norm llngdppc ltdiff20 llnltdiff20 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llnltdiff20])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen ls15 = l.s15_plus
gen ls15turn10 = ls15*ltdiff10
reg pol2norm lpol2norm ltdiff10 ls15 ls15turn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[ls15]+_b[ls15turn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[ls15]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res


*FOR MARGINS PLOTS

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
gen lleaderturn = l.leaderturn
reg pol2norm lpol2norm i.lleaderturn##c.llngdppc i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
margins lleaderturn, at(lpol2norm=0 llngdppc=(6(1)11))
marginsplot, recast(line) noci title("Figure 1A:  Predicted increase in democracy in year t, with and" "without leader change in year t-1, non-democracies, 1875-2004" " ", size(medium) color(gs0))  ylabel(, nogrid) ytitle("Change in Polity2, 0-1 scale") xtitle(Ln GDP per capita) legend(cols(1)) legend(label(1 "No leader change in t-1")) legend(label(2 "Leader changed in t-1")) note("Source: See Table A18; calculated from Table 2, model 11." )
graph save Graph "C:\Democracy\AJPS\Revision Mar 2013\Figure 1A.gph", replace
margins, dydx(lleaderturn) at(lpol2norm=0 llngdppc=(6(0.2)11))
marginsplot, recast(line) yline(0, lcolor(gs10) lpattern(dot)) title("Figure 1B:  Difference in predicted increase in democracy in year t, with" "leader change in t-1 compared to without, non-democracies, 1875-2004" " ", size(medium) color(gs0))  ylabel(, nogrid) ytitle("Difference in predicted change in Polity2, 0-1 scale") xtitle(Ln GDP per capita) note("Source: See Table A18; calculated from Table 2, model 11; 95 percent confidence intervals" )
graph save Graph "C:\Democracy\AJPS\Final files\Figure 1B.gph", replace

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llnltdiff10 = llngdppc*ltdiff10
reg pol2norm lpol2norm i.ltdiff10##c.llngdppc i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
margins ltdiff10, at(lpol2norm=0 llngdppc=(6(1)11))
marginsplot, recast(line) noci title("Figure A1A:  Predicted increase in democracy after ten years, with and" "without prior leader change, non-democracies, 1875-2004" " ", size(medium) color(gs0))  ylabel(, nogrid) ytitle("Change in Polity2, 0-1 scale") xtitle(Ln GDP per capita) legend(cols(1)) legend(label(1 "No leader change in preceding 10 years")) legend(label(2 "Leader change in preceding 10 years")) note("Source: See Table A18; calculated from Table 2, model 13." )
graph save Graph "C:\Democracy\AJPS\Final files\Figure A1A.gph", replace
margins, dydx(ltdiff10) at(lpol2norm=0 llngdppc=(6(0.2)11))
marginsplot, recast(line) yline(0, lcolor(gs10) lpattern(dot)) title("Figure A1B:  Difference in predicted increase in democracy after ten years," "with prior leader change compared to without, non-democracies, 1875-2004" " ", size(medium) color(gs0))  ylabel(, nogrid) ytitle("Difference in predicted change in Polity2, 0-1 scale") xtitle(Ln GDP per capita) note("Source: See Table A18; calculated from Table 2, model 13; 95 percent confidence intervals" ) 
graph save Graph "C:\Democracy\AJPS\Final files\Figure A1B.gph", replace


*Table A4 Error correction model*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen dpol2 = pol2norm-l.pol2norm
gen dlnturn = (lngdppc-l.lngdppc)*l.leaderturn
gen dlnnoturn = (lngdppc-l.lngdppc)*(1-l.leaderturn)
gen lpol2turn = lpol2norm*l.leaderturn
gen lpol2noturn = lpol2norm*(1-l.leaderturn)
gen llnturn = llngdppc*l.leaderturn
gen llnnoturn = llngdppc*(1-l.leaderturn)
gen ccodeturn = ccode*l.leaderturn
gen ccodenoturn = ccode*(1-l.leaderturn)
gen yearturn=year*l.leaderturn
gen yearnoturn=year*(1-l.leaderturn)
reg dpol2 dlnturn lpol2turn llnturn dlnnoturn  lpol2noturn llnnoturn l.leaderturn i.ccodeturn i.ccodenoturn i.yearturn i.yearnoturn if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
nlcom (_b[llnturn]/_b[lpol2turn])
*the negative of this is the equilibrium relationship between polity2 and llngdppc in years after leader exit
predict res, resid
xtfisher res
drop res


*Appendix tables*
*Table A1*

*Panel A: 1820-2008,  Polity2(t-1) < 6 NO INCOME INTERPOLATIONS*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen lngdppcnoti = ln(gdppcnoti)
gen llngdppc = .
replace llngdppc = l.lngdppcnoti if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen lngdppcnoti = ln(gdppcnoti)
gen llngdppc = .
replace llngdppc = l.lngdppcnoti if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen lngdppcnoti = ln(gdppcnoti)
gen llngdppc = .
replace llngdppc = l.lngdppcnoti if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen lngdppcnoti = ln(gdppcnoti)
gen llngdppc = .
replace llngdppc = l.lngdppcnoti if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen lngdppcnoti = ln(gdppcnoti)
gen llngdppc = .
replace llngdppc = l.lngdppcnoti if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*Panel B: Just upward moves of pol2norm*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen pol2up = max(pol2norm, lpol2norm)
replace pol2up=. if pol2norm==.|lpol2norm==.
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2up lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen pol2up = max(pol2norm, lpol2norm)
replace pol2up=. if pol2norm==.|lpol2norm==.
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2up lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen pol2up = max(pol2norm, lpol2norm)
replace pol2up=. if pol2norm==.|lpol2norm==.
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2up lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen pol2up = max(pol2norm, lpol2norm)
replace pol2up=. if pol2norm==.|lpol2norm==.
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2up lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen pol2up = max(pol2norm, lpol2norm)
replace pol2up=. if pol2norm==.|lpol2norm==.
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2up lpol2norm llngdppc i.year i.ccode if l.polity2<6, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*Panel C: 1820-2000, just non-dems, Boix-Rosato dichotomous variables*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg brosdembmr llngdppc i.year i.ccode if l.brosdembmr==0, rob cluster(ccode)
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg brosdembmr llngdppc i.year i.ccode if l.brosdembmr==0, rob cluster(ccode)
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg brosdembmr llngdppc i.year i.ccode if l.brosdembmr==0, rob cluster(ccode)
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg brosdembmr llngdppc i.year i.ccode if l.brosdembmr==0, rob cluster(ccode)
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg brosdembmr llngdppc i.year i.ccode if l.brosdembmr==0, rob cluster(ccode)
predict res, resid
xtfisher res
drop res

*Panel D: 1820-2008, l.Polity2(t-1) < 10*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<10, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<10, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<10, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<10, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
reg pol2norm lpol2norm llngdppc i.year i.ccode if l.polity2<10, rob cluster(ccode)
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res


*Panel E: 1820-2008, Honoré Two Side Estimator*
*Note: stata fails to complete calculations if year dummies included in the annual and 5-yr panels; I include them in the 10, 15, and 20-yr panels*
*Bear in mind: two_side takes a LONG time to perform calculations*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
two_side pol2norm lpol2norm llngdppc ccode

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
two_side pol2norm lpol2norm llngdppc ccode

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
xi: two_side pol2norm  lpol2norm llngdppc i.year ccode

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
xi: two_side pol2norm  lpol2norm llngdppc i.year ccode

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
xi: two_side pol2norm  lpol2norm llngdppc i.year ccode

*Panel F: 1820-2008, Arellano Bond*

use "C:\Democracy\AJPS\merge5yeari.dta", clear
gen yr5 = year/5
xtset ccode yr5
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
xi: xtabond2 pol2norm lpol2norm llngdppc i.year if l.polity2<6, gmm(pol2norm lngdppc, lag (2 2)) iv(i.year) nolevel robust
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\merge10yeari.dta", clear
gen yr10 = year/10
xtset ccode yr10
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
xi: xtabond2 pol2norm lpol2norm llngdppc i.year if l.polity2<6, gmm(pol2norm lngdppc, lag (2 2)) iv(i.year) nolevel robust
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\merge15yeari.dta", clear
gen yr15 = (year-1820)/15
xtset ccode yr15
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
xi: xtabond2 pol2norm lpol2norm llngdppc i.year if l.polity2<6, gmm(pol2norm lngdppc, lag (2 2)) iv(i.year) nolevel robust
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\merge20yeari.dta", clear
gen yr20 = year/20
xtset ccode yr20
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
xi: xtabond2 pol2norm lpol2norm llngdppc i.year if l.polity2<6, gmm(pol2norm lngdppc, lag (2 2)) iv(i.year) nolevel robust
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))


*Table A2*

*Panel A: 1820-2000, just non-dems, Boix-Rosato dichotomous variables*
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg brosdembmr llngdppc llngdpturn1 l.leaderturn i.year i.ccode if l.brosdembmr==0&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
lincom (_b[llngdppc]+_b[llngdpturn1])
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn5 = ltdiff5*llngdppc
reg brosdembmr llngdppc llngdpturn5 ltdiff5 i.year i.ccode if l.brosdembmr ==0&year>1874&year<2005, rob cluster(ccode) 
lincom (_b[llngdppc]+_b[llngdpturn5])
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn10 = ltdiff10*llngdppc
reg brosdembmr llngdppc llngdpturn10 ltdiff10 i.year i.ccode if l.brosdembmr ==0&year>1874&year<2005, rob cluster(ccode) 
lincom (_b[llngdppc]+_b[llngdpturn10])
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn15 = ltdiff15*llngdppc
reg brosdembmr llngdppc llngdpturn15 ltdiff15 i.year i.ccode if l.brosdembmr ==0&year>1874&year<2005, rob cluster(ccode) 
lincom (_b[llngdppc]+_b[llngdpturn15])
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn20 = ltdiff20*llngdppc
reg brosdembmr llngdppc llngdpturn20 ltdiff20 i.year i.ccode if l.brosdembmr==0&year>1874&year<2005, rob cluster(ccode) 
lincom (_b[llngdppc]+_b[llngdpturn20])
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn10 = ltdiff10*llngdppc
gen ls15 = l.s15_plus
gen ls15turn10 = ls15*ltdiff10
reg brosdembmr ltdiff10 ls15 ls15turn10 i.year i.ccode if l.brosdembmr==0&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom (_b[ls15]+_b[ls15turn10])
*if leader not replaced*
nlcom _b[ls15]
predict res, resid
xtfisher res
drop res

*Panel B: Just upward moves of pol2norm*
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
gen pol2up = max(pol2norm, lpol2norm)
replace pol2up=. if pol2norm==.|lpol2norm==.
reg pol2up lpol2norm llngdppc llngdpturn1 l.leaderturn i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn5 = llngdppc*ltdiff5
gen pol2up = max(pol2norm, lpol2norm)
replace pol2up=. if pol2norm==.|lpol2norm==.
reg pol2up lpol2norm llngdppc ltdiff5 llngdpturn5 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn5])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
gen pol2up = max(pol2norm, lpol2norm)
replace pol2up=. if pol2norm==.|lpol2norm==.
reg pol2up lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn15 = llngdppc*ltdiff15
gen pol2up = max(pol2norm, lpol2norm)
replace pol2up=. if pol2norm==.|lpol2norm==.
reg pol2up lpol2norm llngdppc ltdiff15 llngdpturn15 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn15])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn20 = llngdppc*ltdiff20
gen pol2up = max(pol2norm, lpol2norm)
replace pol2up=. if pol2norm==.|lpol2norm==.
reg pol2up lpol2norm llngdppc ltdiff20 llngdpturn20 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn20])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*lturn10yr
gen ls15 = l.s15_plus
gen ls15turn10 = ls15*ltdiff10
gen pol2up = max(pol2norm, lpol2norm)
replace pol2up=. if pol2norm==.|lpol2norm==.
reg pol2up lpol2norm ltdiff10 ls15 ls15turn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[ls15]+_b[ls15turn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[ls15]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*Panel C: 1820-2008,  Polity2(t-1) < 6 NO INCOME INTERPOLATIONS*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lngdppcnoti = ln(gdppcnoti)
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppcnoti if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen lngdppcnoti = ln(gdppcnoti)
gen llngdppc = .
replace llngdppc = l.lngdppcnoti if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn5 = llngdppc*ltdiff5
reg pol2norm lpol2norm llngdppc ltdiff5 llngdpturn5 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn5])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen lngdppcnoti = ln(gdppcnoti)
gen llngdppc = .
replace llngdppc = l.lngdppcnoti if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen lngdppcnoti = ln(gdppcnoti)
gen llngdppc = .
replace llngdppc = l.lngdppcnoti if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn15 = llngdppc*ltdiff15
reg pol2norm lpol2norm llngdppc ltdiff15 llngdpturn15 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn15])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen lngdppcnoti = ln(gdppcnoti)
gen llngdppc = .
replace llngdppc = l.lngdppcnoti if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn20 = llngdppc*ltdiff20
reg pol2norm lpol2norm llngdppc ltdiff20 llngdpturn20 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn20])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen lngdppcnoti = ln(gdppcnoti)
gen llngdppc = .
replace llngdppc = l.lngdppcnoti if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
gen ls15 = l.s15_plus
gen ls15turn10 = ls15*ltdiff10
reg pol2norm lpol2norm ltdiff10 ls15 ls15turn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[ls15]+_b[ls15turn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[ls15]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res


*Table A3: without lagged dep var*

*Panel A: 1875-2004: Polity, Polity2<6 *

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm llngdppc llngdpturn1 l.leaderturn i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom (_b[llngdppc]+_b[llngdpturn1])
*if leader not replaced*
nlcom _b[llngdppc]
predict res, resid
xtfisher res
drop res


use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn5 = llngdppc*ltdiff5
reg pol2norm llngdppc ltdiff5 llngdpturn5 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom (_b[llngdppc]+_b[llngdpturn5])
*if leader not replaced*
nlcom _b[llngdppc]
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom (_b[llngdppc]+_b[llngdpturn10])
*if leader not replaced*
nlcom _b[llngdppc]
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn15 = llngdppc*ltdiff15
reg pol2norm llngdppc ltdiff15 llngdpturn15 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom (_b[llngdppc]+_b[llngdpturn15])
*if leader not replaced*
nlcom _b[llngdppc]
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn20 = llngdppc*ltdiff20
reg pol2norm llngdppc ltdiff20 llngdpturn20 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom (_b[llngdppc]+_b[llngdpturn20])
*if leader not replaced*
nlcom _b[llngdppc]
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
gen ls15 = l.s15_plus
gen ls15turn10 = ls15*ltdiff10
reg pol2norm ltdiff10 ls15 ls15turn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom (_b[ls15]+_b[ls15turn10])
*if leader not replaced*
nlcom _b[ls15]
predict res, resid
xtfisher res
drop res


*Table A5: descriptive statistics*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen threeperiod = .
replace threeperiod = 1 if year>1874&year<1901
replace threeperiod = 2 if year>1900&year<1951
replace threeperiod = 3 if year>1950&year<2001

gen incgroup = .
replace incgroup = 1 if gdppc<3001
replace incgroup = 2 if gdppc>3000&gdppc<6001
replace incgroup = 3 if gdppc>6000&gdppc<10001
replace incgroup = 4 if gdppc>10000

gen oneyrhigher = .
replace oneyrhigher = 1 if leaderturn==1&f.polity2>polity2&f.polity2~=.&polity2~=.
replace oneyrhigher = 0 if leaderturn==1&f.polity2<polity2&f.polity2~=.&polity2~=.
replace oneyrhigher = 0 if leaderturn==1&f.polity2==polity2&f.polity2~=.&polity2~=.

gen fiveyrhigher = .
replace fiveyrhigher = 1 if leaderturn==1&f5.polity2>polity2&f5.polity2~=.&polity2~=.
replace fiveyrhigher = 0 if leaderturn==1&f5.polity2<polity2&f5.polity2~=.&polity2~=.
replace fiveyrhigher = 0 if leaderturn==1&f5.polity2==polity2&f5.polity2~=.&polity2~=.

gen tenyrhigher = .
replace tenyrhigher = 1 if leaderturn==1&f10.polity2>polity2&f10.polity2~=.&polity2~=.
replace tenyrhigher = 0 if leaderturn==1&f10.polity2<polity2&f10.polity2~=.&polity2~=.
replace tenyrhigher = 0 if leaderturn==1&f10.polity2==polity2&f10.polity2~=.&polity2~=.

tab threeperiod leaderturn if polity2<6, row
tab threeperiod leaderturn if polity2>5&polity2~=., row
tab incgroup leaderturn if polity2<6, row
tab incgroup leaderturn if polity2>5&polity2~=., row

tab oneyrhigher if polity2<6
tab fiveyrhigher if polity2<6
tab tenyrhigher if polity2<6

*percentage of cases of different values of turnover variables*

tab leaderturn if l.polity2<6&polity2<6&year>1874&year<2005&l.polity2~=.
tab lturn5yr if l5.polity2<6& l4.polity2<6& l3.polity2<6& l2.polity2<6& l.polity2<6& polity2<6&year>1874&year<2005&l5.polity2~=.
tab lturn10yr if l10.polity2<6& l9.polity2<6& l8.polity2<6& l7.polity2<6& l6.polity2<6& l5.polity2<6& l4.polity2<6& l3.polity2<6& l2.polity2<6& l.polity2<6& polity2<6&year>1874&year<2005&l10.polity2~=.
tab lturn15yr if l15.polity2<6& l14.polity2<6& l13.polity2<6& l12.polity2<6& l11.polity2<6& l10.polity2<6& l9.polity2<6& l8.polity2<6& l7.polity2<6& l6.polity2<6& l5.polity2<6& l4.polity2<6& l3.polity2<6& l2.polity2<6& l.polity2<6& polity2<6&year>1874&year<2005&l15.polity2~=.
tab lturn20yr if l20.polity2<6& l19.polity2<6& l18.polity2<6& l17.polity2<6& l16.polity2<6& l15.polity2<6& l14.polity2<6& l13.polity2<6& l12.polity2<6& l11.polity2<6& l10.polity2<6& l9.polity2<6& l8.polity2<6& l7.polity2<6& l6.polity2<6& l5.polity2<6& l4.polity2<6& l3.polity2<6& l2.polity2<6& l.polity2<6& polity2<6&year>1874&year<2005&l20.polity2~=.

tab leaderturn if l.polity2>5&polity2>5&year>1874&year<2005&l.polity2~=.
tab lturn5yr if l5.polity2>5& l4.polity2>5& l3.polity2>5& l2.polity2>5& l.polity2>5& polity2>5&year>1874&year<2005&l5.polity2~=.
tab lturn10yr if l10.polity2>5& l9.polity2>5& l8.polity2>5& l7.polity2>5& l6.polity2>5& l5.polity2>5& l4.polity2>5& l3.polity2>5& l2.polity2>5& l.polity2>5& polity2>5&year>1874&year<2005&l10.polity2~=.
tab lturn15yr if l15.polity2>5& l14.polity2>5& l13.polity2>5& l12.polity2>5& l11.polity2>5& l10.polity2>5& l9.polity2>5& l8.polity2>5& l7.polity2>5& l6.polity2>5& l5.polity2>5& l4.polity2>5& l3.polity2>5& l2.polity2>5& l.polity2>5& polity2>5&year>1874&year<2005&l15.polity2~=.
tab lturn20yr if l20.polity2>5& l19.polity2>5& l18.polity2>5& l17.polity2>5& l16.polity2>5& l15.polity2>5& l14.polity2>5& l13.polity2>5& l12.polity2>5& l11.polity2>5& l10.polity2>5& l9.polity2>5& l8.polity2>5& l7.polity2>5& l6.polity2>5& l5.polity2>5& l4.polity2>5& l3.polity2>5& l2.polity2>5& l.polity2>5& polity2>5&year>1874&year<2005&l20.polity2~=.


*TABLE A6. Switching the starting year of panels*

*Run the regression for the 10-year panel starting in each year of the decade. Use the interpolated data.*

use "C:\Democracy\AJPS\democworki.dta", clear
keep if (year-1820)/10 == int((year-1820)/10)
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if (year-1811)/10 == int((year-1811)/10)
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if (year-1812)/10 == int((year-1812)/10)
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if (year-1813)/10 == int((year-1813)/10)
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if (year-1814)/10 == int((year-1814)/10)
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if (year-1815)/10 == int((year-1815)/10)
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if (year-1816)/10 == int((year-1816)/10)
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if (year-1817)/10 == int((year-1817)/10)
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if (year-1818)/10 == int((year-1818)/10)
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if (year-1819)/10 == int((year-1819)/10)
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
reg pol2norm lpol2norm llngdppc ltdiff10 llngdpturn10 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn10])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))


*Run the regression for the 5-year panel starting in every year. Use the interpolated data.*

use "C:\Democracy\AJPS\democworki.dta", clear
keep if ((year-1820)/5)==int((year-1820)/5)
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn5 = llngdppc*ltdiff5
reg pol2norm lpol2norm llngdppc ltdiff5 llngdpturn5 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn5])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if ((year-1821)/5)==int((year-1821)/5)
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn5 = llngdppc*ltdiff5
reg pol2norm lpol2norm llngdppc ltdiff5 llngdpturn5 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn5])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if ((year-1822)/5)==int((year-1822)/5)
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn5 = llngdppc*ltdiff5
reg pol2norm lpol2norm llngdppc ltdiff5 llngdpturn5 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn5])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if ((year-1823)/5)==int((year-1823)/5)
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn5 = llngdppc*ltdiff5
reg pol2norm lpol2norm llngdppc ltdiff5 llngdpturn5 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn5])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

use "C:\Democracy\AJPS\democworki.dta", clear
keep if ((year-1824)/5)==int((year-1824)/5)
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn5 = llngdppc*ltdiff5
reg pol2norm lpol2norm llngdppc ltdiff5 llngdpturn5 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn5])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))

*Miscellaneous issues*
*Could it be that the Polity coders simply take leadership change as a sign of democratization? In this case, the association between leader exit and democratization would be trivial.* 
 
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen polupdummy = 0	
replace polupdummy = 1 if pol2norm>l.pol2norm	
replace polupdummy=. if pol2norm==.|l.pol2norm==.	
tab polupdummy leaderturn, row col	

gen lturnthisorlast = 0	
replace  lturnthisorlast =. if leaderturn==.|l.leaderturn==.	
replace  lturnthisorlast =1 if leaderturn==1|l.leaderturn==1	
tab polupdummy lturnthisorlast, row col	
	

*Are there too few cases of democratization without any prior leader change to estimate the relationship between income and  democratization in such circumstances? *

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen polupdummy = 0	
replace polupdummy = 1 if pol2norm>l.pol2norm	
replace polupdummy=. if pol2norm==.|l.pol2norm==.	
gen lleaderturn = l.leaderturn
tab polupdummy lturn20yr if l.polity2<6, row col
tab polupdummy lturn15yr if l.polity2<6, row col
tab polupdummy lturn10yr if l.polity2<6, row col
tab polupdummy lturn5yr if l.polity2<6, row col
tab polupdummy lleaderturn, row col	


*Robustnesss: Table A7*

*1. Repeating basic model*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*2. Democracy elsewhere in the world*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn l.closdem_cont_dist i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*3. Trade*
*must have already run growth instrument.do*
use "C:\Democracy\April 13 2011 Version\RussetOnealwork.dta", clear
by ccodeayear: egen tradesum = total(trade)
gen tradegdp = tradesum/gdpcountrya
collapse (mean) ccodea year tradegdp, by(ccodeayear)
drop if year>1992
gen cyear = ccodeayear
sort cyear
save "C:\Democracy\tradegdp.dta", replace
use "C:\Democracy\AJPS\democworki.dta", clear
drop _merge
sort cyear
merge cyear using "C:\Democracy\tradegdp.dta", sort

save "C:\Democracy\AJPS\democworki.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn l.tradegdp i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*4. Oil*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn lnoil i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*5.Elected legislatures, elected executives, and non-regime parties*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn l.defacto2 l.legelbanks l.exelbanks i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*6. Types of authoritarian regimes: Banks*
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn l.militaryregime l.monarchy i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*7. Types of authoritarian regimes: Geddes*
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn l.gwf_party  l.gwf_monarchy l.gwf_personal l.gwfmisc i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*8. Democratic capital*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn l.demcap_delta94 i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*9. Previous transitions*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn prevtrans i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*10. Percent of previous leader turnovers irregular*
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn l.pctirreg i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res


*11. War and civil war*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc

*mildef is dummy for military defeat in war that did not result in foreign occupation or imposition of leader any time in following 10 years.*
gen mildef = 0
replace mildef= lostwarthisyr
*exclude if occupied in following 10 years or if leader imposed*
replace mildef=. if lostwarthisyr==1&polity==-66
replace mildef=. if lostwarthisyr==1&f.polity==-66
replace mildef=. if lostwarthisyr==1&f2.polity==-66
replace mildef=. if lostwarthisyr==1&f3.polity==-66
replace mildef=. if lostwarthisyr==1&f4.polity==-66
replace mildef=. if lostwarthisyr==1&f5.polity==-66
replace mildef=. if lostwarthisyr==1&f6.polity==-66
replace mildef=. if lostwarthisyr==1&f7.polity==-66
replace mildef=. if lostwarthisyr==1&f8.polity==-66
replace mildef=. if lostwarthisyr==1&f9.polity==-66
replace mildef=. if lostwarthisyr==1&f10.polity==-66
replace mildef=. if country=="Vietnam South"&year==1975
*South Vietnam ceases to exist*
replace mildef=. if lostwarthisyr==1&entry==2
replace mildef=. if lostwarthisyr==1&f.entry==2
replace mildef=. if lostwarthisyr==1&f2.entry==2
replace mildef=. if lostwarthisyr==1&f3.entry==2
replace mildef=. if lostwarthisyr==1&f4.entry==2
replace mildef=. if lostwarthisyr==1&f5.entry==2
replace mildef=. if lostwarthisyr==1&f6.entry==2
replace mildef=. if lostwarthisyr==1&f7.entry==2
replace mildef=. if lostwarthisyr==1&f8.entry==2
replace mildef=. if lostwarthisyr==1&f9.entry==2
replace mildef=. if lostwarthisyr==1&f10.entry==2

reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn l.mildef lostcwarlastyr woncwarlastyr  wonwarlastyr l.civilwar l.interstatewar i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
*if leader replaced*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*if leader not replaced*
nlcom (_b[llngdppc]/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*Including the country fixed effects is clearly important. Even in a super-saturated model including all the aforementioned controls simultaneously,*
 *an F-test rejects the hypothesis that the country fixed effects are jointly zero at p = .0000. *

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
xi: reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn l.closdem_cont_dist l.tradegdp lnoil l.defacto2 l.legelbanks l.exelbanks l.gwf_party  l.gwf_monarchy l.gwf_personal l.gwfmisc l.militaryregime l.monarchy l.demcap_delta94 prevtrans l.pctirreg lostwarlastyr lostcwarlastyr woncwarlastyr  wonwarlastyr l.civilwar l.interstatewar i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 

test (_Iccode_100=0) (_Iccode_101=0) (_Iccode_130=0) (_Iccode_135=0) (_Iccode_140=0) (_Iccode_145=0) (_Iccode_150=0) (_Iccode_155=0) (_Iccode_160=0) (_Iccode_165=0) (_Iccode_220=0) (_Iccode_230=0) (_Iccode_235=0) (_Iccode_290=0) (_Iccode_310=0) (_Iccode_339=0) (_Iccode_344=0) (_Iccode_345=0) (_Iccode_350=0) (_Iccode_355=0) (_Iccode_359=0) (_Iccode_360=0) (_Iccode_365=0) (_Iccode_372=0) (_Iccode_40=0) (_Iccode_404=0) (_Iccode_41=0) (_Iccode_42=0) (_Iccode_432=0) (_Iccode_433=0) (_Iccode_434=0) (_Iccode_435=0) (_Iccode_436=0) (_Iccode_437=0) (_Iccode_438=0) (_Iccode_439=0) (_Iccode_450=0) (_Iccode_451=0) (_Iccode_452=0) (_Iccode_461=0) (_Iccode_471=0) (_Iccode_475=0) (_Iccode_481=0) (_Iccode_482=0) (_Iccode_483=0) (_Iccode_484=0) (_Iccode_490=0) (_Iccode_500=0) (_Iccode_501=0) (_Iccode_510=0) (_Iccode_516=0) (_Iccode_517=0) (_Iccode_520=0) (_Iccode_530=0) (_Iccode_540=0) (_Iccode_541=0) (_Iccode_551=0) (_Iccode_552=0) (_Iccode_553=0) (_Iccode_560=0) (_Iccode_570=0) (_Iccode_572=0) (_Iccode_580=0) (_Iccode_600=0) (_Iccode_615=0) (_Iccode_616=0) (_Iccode_620=0) (_Iccode_625=0) (_Iccode_630=0) (_Iccode_640=0) (_Iccode_645=0) (_Iccode_651=0) (_Iccode_652=0) (_Iccode_660=0) (_Iccode_663=0) (_Iccode_670=0) (_Iccode_690=0) (_Iccode_696=0) (_Iccode_698=0) (_Iccode_70=0) (_Iccode_700=0) (_Iccode_701=0) (_Iccode_702=0) (_Iccode_703=0) (_Iccode_704=0) (_Iccode_705=0) (_Iccode_710=0) (_Iccode_712=0) (_Iccode_713=0) (_Iccode_731=0) (_Iccode_732=0) (_Iccode_770=0) (_Iccode_771=0) (_Iccode_775=0) (_Iccode_780=0) (_Iccode_790=0) (_Iccode_800=0) (_Iccode_811=0) (_Iccode_812=0) (_Iccode_820=0) (_Iccode_830=0) (_Iccode_840=0) (_Iccode_850=0) (_Iccode_90=0) (_Iccode_91=0) (_Iccode_92=0) (_Iccode_93=0) (_Iccode_95=0) 


*IDENTIFICATION*


*Prep for Table 3
*Identify cases in which leader died natural death in office. Note: there are more of these than in the main dataset because main dataset only keeps the last leader in office in each year.
*Generate full list of country years in which leader died of nat causes

use "C:\Democracy\edreynal work1.dta", clear
replace ccode=365 if leader=="Yeltsin"

*complete cyear*
replace cyear = ccode*10000+year
*drop Besley Reynal cases that are not in Archigos--lack info about turnover*
drop if leadid==""
gen leaderturn = 1 
sort cyear eindate
drop case
gen case=_n
tsset case
gen llead = leader[_n-1]
tsset case
gen natcauses = 0
replace natcauses = 1 if exit==2
sort cyear
save "C:\Democracy\natdeath.dta", replace

insheet using "C:\Democracy\April 13 2011 Version\Copy of p4v2009.txt", clear
save "C:\Democracy\p4xxx.dta", replace
xtset ccode year
replace ccode = 347 if country=="Kosovo"
*remove duplicate Yugoslavia 1991 entry
drop if cyear==3451991
replace ccode = 345 if country=="Yugoslavia"
replace ccode=345 if country=="Serbia and Montenegro"&year>2002&year<2007
replace ccode = 341 if country=="Montenegro"
*remove duplicate Ethiopia 1993 entry
drop if cyear==5291993
replace ccode=530 if country=="Ethiopia"
*consolidate Pakistan entries*
replace ccode=770 if country=="Pakistan"
*combine WG with Prussia and Germany with ccode = 255
drop if cyear==2601945
drop if cyear==2601990
replace ccode=255 if ccode==260
*combine USSR with Russia
drop if ccode==365&year==1922
replace ccode=365 if ccode==364
*correct error in Iran*
replace polity2=-9 if country=="Iran"&year==1979
replace polity2=-8 if country=="Iran"&year==1980
replace polity2=-7 if country=="Iran"&year==1981
*make consistent cyear
drop cyear
gen cyear = ccode*10000 + year

*drop missing values*
replace democ = . if democ<-10
replace autoc = . if autoc <-10
replace polity2 = . if polity2 <-10
replace polity2 = . if polity==-77
replace xrreg = . if xrreg <-10
replace xrcomp = . if xrcomp <-10
replace xropen = . if xropen <-10
replace xconst = . if xconst <-10
replace parreg = . if parreg <-10
replace parcomp = . if parcomp <-10
replace exrec = . if exrec <-10
replace exconst = . if exconst <-10
replace polcomp = . if polcomp<-10

xtset ccode year
by ccode: ipolate polity2 year, gen(pol3)
replace pol3=. if polity2==.&polity~=-77&polity~=-88
replace polity2=pol3

*I interpolate linearly to replace Polity's code for transitional or interregnum years (-88 and -77).
*I leave years of foreign occupation (polity = -66) as missing. Polity codes the interregnum years (polity=-77) as 0.
*This means that, for instance, during Afghanistan's civil war after 1991 the country's regime shot up to 0 from -8, only to fall back down
*to -7 when the Taliban took over. My code is not perfect--the -66 years are included in the interpolations, but then replaced by missing--but is very close to right.

gen lpolity2=l.polity2
save "C:\Democracy\p4xxx.dta", replace

use "C:\Democracy\revision dec 2011\Maddison longi.dta", clear
drop if ccode==365&year<1992
replace ccode=365 if ccode==364&year<1992
drop if ccode==364
xtset ccode year
gen lgdppc = l.gdppc
drop cyear
gen cyear = ccode*10000 + year
sort cyear
save "C:\Democracy\revision dec 2011\Madnatdeath", replace

use "C:\Democracy\natdeath.dta", clear
replace ccode=365 if ccode==364
drop cyear
gen cyear = ccode*10000 + year
sort cyear
merge cyear using "C:\Democracy\p4xxx.dta", sort uniqusing
drop _merge

sort cyear
merge cyear using "C:\Democracy\revision dec 2011\Madnatdeath.dta", sort uniqusing
drop _merge
save "C:\Democracy\natdeath.dta", replace

drop if leadno==.
save "C:\Democracy\natdeath.dta", replace
sort ccode year eindate
drop case
gen case=_n
tsset case
replace llead = leader[_n-1]
*this for construction of ncfull*
list ccname year llead lpolity2 lgdppc if l.natcauses==1&lpolity2<6

*now based on this listing, create variable in the main data

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen ncfull=0
replace ncfull=1 if country=="Nepal" & year==1877
replace ncfull=1 if country=="Mongolia" & year==1952
replace ncfull=1 if country=="Nepal" & year==1901
replace ncfull=1 if country=="Nepal" & year==1948
replace ncfull=1 if country=="Nepal" & year==1932
replace ncfull=1 if country=="Nepal" & year==1929
replace ncfull=1 if country=="Guinea" & year==1984
replace ncfull=1 if country=="Nepal" & year==1955
replace ncfull=1 if country=="China" & year==1908
replace ncfull=1 if country=="China" & year==1916
replace ncfull=1 if country=="Niger" & year==1987
replace ncfull=1 if country=="Comoros" & year==1998
replace ncfull=1 if country=="Venezuela" & year==1878
replace ncfull=1 if country=="Nepal" & year==1972
replace ncfull=1 if country=="Morocco" & year==1894
replace ncfull=1 if country=="Brazil" & year==1909
replace ncfull=1 if country=="Peru" & year==1904
replace ncfull=1 if country=="Thailand" & year==1925
replace ncfull=1 if country=="Thailand" & year==1910
replace ncfull=1 if country=="China" & year==1976
replace ncfull=1 if country=="Philippines" & year==1948
replace ncfull=1 if country=="Egypt" & year==1936
replace ncfull=1 if country=="Haiti" & year==1971
replace ncfull=1 if country=="Mozambique" & year==1986
replace ncfull=1 if country=="Vietnam" & year==1986
replace ncfull=1 if country=="Laos" & year==1992
replace ncfull=1 if country=="Iran" & year==1907
replace ncfull=1 if country=="Angola" & year==1979
replace ncfull=1 if country=="Mauritania" & year==1979
replace ncfull=1 if country=="Yemen North" & year==1962
replace ncfull=1 if country=="Kenya" & year==1978
replace ncfull=1 if country=="Portugal" & year==1889
replace ncfull=1 if country=="Thailand" & year==1963
replace ncfull=1 if country=="Nigeria" & year==1998
replace ncfull=1 if country=="Russia" & year==1894
replace ncfull=1 if country=="Nicaragua" & year==1923
replace ncfull=1 if country=="Iraq" & year==1933
replace ncfull=1 if country=="Egypt" & year==1970
replace ncfull=1 if country=="Ivory Coast" & year==1993
replace ncfull=1 if country=="Iraq" & year==1939
replace ncfull=1 if country=="Romania" & year==1927
replace ncfull=1 if country=="Morocco" & year==1961
replace ncfull=1 if country=="Philippines" & year==1957
replace ncfull=1 if country=="USSR" & year==1923
replace ncfull=1 if country=="Bulgaria" & year==1949
replace ncfull=1 if country=="Guatemala" & year==1926
replace ncfull=1 if country=="Bulgaria" & year==1943
replace ncfull=1 if country=="Liberia" & year==1971
replace ncfull=1 if country=="Bulgaria" & year==1950
replace ncfull=1 if country=="Poland" & year==1935
replace ncfull=1 if country=="Turkey" & year==1938
replace ncfull=1 if country=="Italy" & year==1887
replace ncfull=1 if country=="South Africa" & year==1919
replace ncfull=1 if country=="Romania" & year==1914
replace ncfull=1 if country=="Japan" & year==1923
replace ncfull=1 if country=="Japan" & year==1926
replace ncfull=1 if country=="Paraguay" & year==1940
replace ncfull=1 if country=="Bolivia" & year==1969
replace ncfull=1 if country=="Greece" & year==1941
replace ncfull=1 if country=="Romania" & year==1965
replace ncfull=1 if country=="Germany" & year==1888
replace ncfull=1 if country=="Greece" & year==1955
replace ncfull=1 if country=="Albania" & year==1985
replace ncfull=1 if country=="Saudi Arabia" & year==1953
replace ncfull=1 if country=="Swaziland" & year==1982
replace ncfull=1 if country=="Korea North" & year==1994
replace ncfull=1 if country=="Malaysia" & year==1976
replace ncfull=1 if country=="Austria" & year==1916
replace ncfull=1 if country=="Morocco" & year==1999
replace ncfull=1 if country=="Chile" & year==1910
replace ncfull=1 if country=="Nicaragua" & year==1966
replace ncfull=1 if country=="Algeria" & year==1978
replace ncfull=1 if country=="Poland" & year==1956
replace ncfull=1 if country=="China" & year==1997
replace ncfull=1 if country=="USSR" & year==1953
replace ncfull=1 if country=="South Africa" & year==1958
replace ncfull=1 if country=="Venezuela" & year==1935
replace ncfull=1 if country=="Chile" & year==1941
replace ncfull=1 if country=="Iraq" & year==1966
replace ncfull=1 if country=="Iran" & year==1989
replace ncfull=1 if country=="Taiwan" & year==1975
replace ncfull=1 if country=="Argentina" & year==1906
replace ncfull=1 if country=="Czechoslovakia" & year==1953
replace ncfull=1 if country=="Jordan" & year==1999
replace ncfull=1 if country=="Czechoslovakia" & year==1957
replace ncfull=1 if country=="Taiwan" & year==1978
replace ncfull=1 if country=="Portugal" & year==1968
replace ncfull=1 if country=="Bahrain" & year==1999
replace ncfull=1 if country=="Gabon" & year==1967
replace ncfull=1 if country=="Panama" & year==1981
replace ncfull=1 if country=="Yugoslavia" & year==1980
replace ncfull=1 if country=="Poland" & year==1980
replace ncfull=1 if country=="Croatia" & year==1999
replace ncfull=1 if country=="USSR" & year==1982
replace ncfull=1 if country=="USSR" & year==1984
replace ncfull=1 if country=="USSR" & year==1985
replace ncfull=1 if country=="Syria" & year==2000
replace ncfull=1 if country=="Spain" & year==1975
replace ncfull=1 if country=="Taiwan" & year==1988
replace ncfull=1 if country=="Saudi Arabia" & year==1982
replace ncfull=1 if country=="Kuwait" & year==1978
replace ncfull=1 if country=="Kuwait" & year==1965
replace ncfull=1 if country=="Haiti" & year==1896
replace ncfull=1 if country=="Haiti" & year==1913
replace ncfull=1 if country=="Nicaragua" & year==1889
replace ncfull=1 if country=="Panama" & year==1910
replace ncfull=1 if country=="Panama" & year==1918
replace ncfull=1 if country=="Panama" & year==1939
replace ncfull=1 if country=="Guyana" & year==1985
replace ncfull=1 if country=="Ecuador" & year==1911
replace ncfull=1 if country=="Ecuador" & year==1939
replace ncfull=1 if country=="Peru" & year==1894
replace ncfull=1 if country=="Paraguay" & year==1880
replace ncfull=1 if country=="Paraguay" & year==1919
replace ncfull=1 if country=="Liberia" & year==1896
replace ncfull=1 if country=="Ethiopia" & year==1911
replace ncfull=1 if country=="Ethiopia" & year==1930
replace ncfull=1 if country=="Orange Free State" & year==1888
replace ncfull=1 if country=="Oman" & year==1888
replace ncfull=1 if country=="Oman" & year==1913
replace ncfull=1 if country=="Afghanistan" & year==1880
replace ncfull=1 if country=="Afghanistan" & year==1901
replace ncfull=1 if country=="Bhutan" & year==1952
replace ncfull=1 if country=="Bhutan" & year==1972
replace ncfull=1 if country=="Pakistan" & year==1948
replace ncfull=. if l.leaderturn==.
*note: have changed Russia to USSR for Soviet period, Yemen Arab Republic to Yemen North, NorthKorea to Korea North, Cote d'Ivoire to Ivory Coast*

*create regional identifiers using World Bank regions*
gen str region ="."
replace region = "EAsiaPac" if country=="American Samoa"
replace region = "Sasia" if country=="Afghanistan"
replace region = "EurCA" if country=="Albania"
replace region = "MENA" if country=="Algeria"
replace region = "WEurNA" if country=="Andorra"
replace region = "SubSahAf" if country=="Angola"
replace region = "LatAmCar" if country=="Antigua"
replace region = "LatAmCar" if country=="Argentina"
replace region = "EurCA" if country=="Armenia"
replace region = "Oceania" if country=="Australia"
replace region = "WEurNA" if country=="Austria"
replace region = "EurCA" if country=="Azerbaijan"
replace region = "LatAmCar" if country=="Bahamas"
replace region = "MENA" if country=="Bahrain"
replace region = "Sasia" if country=="Bangladesh"
replace region = "LatAmCar" if country=="Barbados"
replace region = "EurCA" if country=="Belarus"
replace region = "WEurNA" if country=="Belgium"
replace region = "LatAmCar" if country=="Belize"
replace region = "SubSahAf" if country=="Benin"
replace region = "Sasia" if country=="Bhutan"
replace region = "LatAmCar" if country=="Bolivia"
replace region = "EurCA" if country=="Bosnia"
replace region = "EurCA" if country=="Bosnia and Herzegovina"
replace region = "SubSahAf" if country=="Botswana"
replace region = "LatAmCar" if country=="Brazil"
replace region = "EAsiaPac" if country=="Brunei"
replace region = "EurCA" if country=="Bulgaria"
replace region = "SubSahAf" if country=="Burkina Faso"
replace region = "EAsiaPac" if country=="Burma"
replace region = "SubSahAf" if country=="Burundi"
replace region = "EAsiaPac" if country=="Cambodia"
replace region = "SubSahAf" if country=="Cameroon"
replace region = "WEurNA" if country=="Canada"
replace region = "SubSahAf" if country=="Cape Verde"
replace region = "SubSahAf" if country=="Central African Republic"
replace region = "SubSahAf" if country=="Chad"
replace region = "LatAmCar" if country=="Chile"
replace region = "EAsiaPac" if country=="China"
replace region = "LatAmCar" if country=="Colombia"
replace region = "SubSahAf" if country=="Comoro Islands"
replace region = "SubSahAf" if country=="Comoros"
replace region = "SubSahAf" if country=="Congo 'Brazzaville'"
replace region = "SubSahAf" if country=="Congo, Dem. Rep.”"
replace region = "SubSahAf" if country=="Congo, Rep."
replace region = "LatAmCar" if country=="Costa Rica"
replace region = "SubSahAf" if country=="Cote d'Ivoire"
replace region = "SubSahAf" if country=="Ivory Coast"
replace region = "EurCA" if country=="Croatia"
replace region = "LatAmCar" if country=="Cuba"
replace region = "WEurNA" if country=="Cyprus"
replace region = "EurCA" if country=="Czech Republic"
replace region = "EurCA" if country=="Czechoslovakia"
replace region = "WEurNA" if country=="Denmark"
replace region = "MENA" if country=="Djibouti"
replace region = "LatAmCar" if country=="Dominica"
replace region = "LatAmCar" if country=="Dominican Republic"
replace region = "EAsiaPac" if country=="East Timor"
replace region = "LatAmCar" if country=="Ecuador"
replace region = "MENA" if country=="Egypt"
replace region = "LatAmCar" if country=="El Salvador"
replace region = "SubSahAf" if country=="Equatorial Guinea"
replace region = "SubSahAf" if country=="Eritrea"
replace region = "EurCA" if country=="Estonia"
replace region = "SubSahAf" if country=="Ethiopia"
replace region = "SubSahAf" if country=="Ethiopia 1993-"
replace region = "SubSahAf" if country=="Ethiopia -pre 1993”"
replace region = "EAsiaPac" if country=="Fiji"
replace region = "WEurNA" if country=="Finland"
replace region = "WEurNA" if country=="France"
replace region = "SubSahAf" if country=="Gabon"
replace region = "SubSahAf" if country=="Gambia"
replace region = "SubSahAf" if country=="Gambia, The"
replace region = "EurCA" if country=="Georgia"
replace region = "WEurNA" if country=="Germany"
replace region = "WEurNA" if country=="Germany, East"
replace region = "WEurNA" if country=="Germany, West"
replace region = "SubSahAf" if country=="Ghana"
replace region = "WEurNA" if country=="Greece"
replace region = "LatAmCar" if country=="Grenada"
replace region = "LatAmCar" if country=="Guatemala"
replace region = "SubSahAf" if country=="Guinea"
replace region = "SubSahAf" if country=="Guinea Bissau"
replace region = "SubSahAf" if country=="Guinea-Bissau"
replace region = "LatAmCar" if country=="Guyana"
replace region = "LatAmCar" if country=="Haiti"
replace region = "LatAmCar" if country=="Haïti"
replace region = "LatAmCar" if country=="Honduras"
replace region = "EAsiaPac" if country=="Hong Kong"
replace region = "EurCA" if country=="Hungary"
replace region = "WEurNA" if country=="Iceland"
replace region = "Sasia" if country=="India"
replace region = "EAsiaPac" if country=="Indonesia"
replace region = "EAsiaPac" if country=="Indonesia (including Timor until 1999)"
replace region = "MENA" if country=="Iran"
replace region = "MENA" if country=="Iraq"
replace region = "WEurNA" if country=="Ireland"
replace region = "MENA" if country=="Israel"
replace region = "WEurNA" if country=="Italy"
replace region = "LatAmCar" if country=="Jamaica"
replace region = "EAsiaPac" if country=="Japan"
replace region = "MENA" if country=="Jordan"
replace region = "EurCA" if country=="Kazakhstan"
replace region = "SubSahAf" if country=="Kenya"
replace region = "EAsiaPac" if country=="Kiribati"
replace region = "EAsiaPac" if country=="Korea"
replace region = "EAsiaPac" if country=="Korea, Dem. Rep."
replace region = "EAsiaPac" if country=="Korea, Rep."
replace region = "EAsiaPac" if country=="Korea North"
replace region = "EAsiaPac" if country=="Korea South"
replace region = "EurCA" if country=="Kosovo"
replace region = "MENA" if country=="Kuwait"
replace region = "EurCA" if country=="Kyrgyz Republic"
replace region = "EurCA" if country=="Kyrgyzstan"
replace region = "EAsiaPac" if country=="Lao PDR"
replace region = "EAsiaPac" if country=="Laos"
replace region = "EurCA" if country=="Latvia"
replace region = "MENA" if country=="Lebanon"
replace region = "SubSahAf" if country=="Lesotho"
replace region = "SubSahAf" if country=="Liberia"
replace region = "MENA" if country=="Libya"
replace region = "WEurNA" if country=="Liechtenstein"
replace region = "EurCA" if country=="Lithuania"
replace region = "WEurNA" if country=="Luxembourg"
replace region = "EurCA" if country=="Macedonia"
replace region = "EurCA" if country=="Macedonia, FYR"
replace region = "SubSahAf" if country=="Madagascar"
replace region = "SubSahAf" if country=="Malawi"
replace region = "EAsiaPac" if country=="Malaysia"
replace region = "Sasia" if country=="Maldives"
replace region = "SubSahAf" if country=="Mali"
replace region = "WEurNA" if country=="Malta"
replace region = "SubSahAf" if country=="Mauritania"
replace region = "SubSahAf" if country=="Mauritius"
replace region = "LatAmCar" if country=="Mexico"
replace region = "EurCA" if country=="Moldova"
replace region = "EAsiaPac" if country=="Mongolia"
replace region = "EurCA" if country=="Montenegro"
replace region = "MENA" if country=="Morocco"
replace region = "SubSahAf" if country=="Mozambique"
replace region = "EAsiaPac" if country=="Myanmar"
replace region = "SubSahAf" if country=="Namibia"
replace region = "Sasia" if country=="Nepal"
replace region = "WEurNA" if country=="Netherlands"
replace region = "Oceania" if country=="New Zealand"
replace region = "LatAmCar" if country=="Nicaragua"
replace region = "SubSahAf" if country=="Niger"
replace region = "SubSahAf" if country=="Nigeria"
replace region = "EAsiaPac" if country=="North Korea"
replace region = "WEurNA" if country=="Norway"
replace region = "MENA" if country=="Oman"
replace region = "Sasia" if country=="Pakistan"
replace region = "Sasia" if country=="Pakistan-post-1972"
replace region = "Sasia" if country=="Pakistan-pre-1972"
replace region = "LatAmCar" if country=="Panama"
replace region = "EAsiaPac" if country=="Papua New Guinea"
replace region = "LatAmCar" if country=="Paraguay"
replace region = "LatAmCar" if country=="Peru"
replace region = "EAsiaPac" if country=="Philippines"
replace region = "EurCA" if country=="Poland"
replace region = "WEurNA" if country=="Portugal"
replace region = "WEurNA" if country=="Puerto Rico"
replace region = "MENA" if country=="Qatar"
replace region = "EurCA" if country=="Romania"
replace region = "EurCA" if country=="Russia"
replace region = "EurCA" if country=="Russian Federation"
replace region = "SubSahAf" if country=="Rwanda"
replace region = "SubSahAf" if country=="São Tomé and Principe"
replace region = "SubSahAf" if country=="Sao Tome and Principe"
replace region = "MENA" if country=="Saudi Arabia"
replace region = "SubSahAf" if country=="Senegal"
replace region = "EurCA" if country=="Serbia"
replace region = "EurCA" if country=="Serbia and Montenegro"
replace region = "SubSahAf" if country=="Seychelles"
replace region = "SubSahAf" if country=="Sierra Leone"
replace region = "EAsiaPac" if country=="Singapore"
replace region = "EurCA" if country=="Slovakia"
replace region = "EurCA" if country=="Slovenia"
replace region = "EAsiaPac" if country=="Solomon Islands"
replace region = "SubSahAf" if country=="Somalia"
replace region = "SubSahAf" if country=="South Africa"
replace region = "EAsiaPac" if country=="South Korea"
replace region = "WEurNA" if country=="Spain"
replace region = "Sasia" if country=="Sri Lanka"
replace region = "SubSahAf" if country=="Sudan"
replace region = "SubSahAf" if country=="Swaziland"
replace region = "WEurNA" if country=="Sweden"
replace region = "WEurNA" if country=="Switzerland"
replace region = "MENA" if country=="Syria"
replace region = "MENA" if country=="Syrian Arab Republic"
replace region = "EAsiaPac" if country=="Taiwan"
replace region = "EurCA" if country=="Tajikistan"
replace region = "SubSahAf" if country=="Tanzania"
replace region = "EAsiaPac" if country=="Thailand"
replace region = "SubSahAf" if country=="Togo"
replace region = "EurCA" if country=="Total Former USSR"
replace region = "LatAmCar" if country=="Trinidad and Tobago"
replace region = "MENA" if country=="Tunisia"
replace region = "EurCA" if country=="Turkey"
replace region = "EurCA" if country=="Turkmenistan"
replace region = "SubSahAf" if country=="Uganda"
replace region = "EurCA" if country=="Ukraine"
replace region = "MENA" if country=="United Arab Emirates"
replace region = "MENA" if country=="UAE"
replace region = "WEurNA" if country=="United Kingdom"
replace region = "WEurNA" if country=="UK"
replace region = "WEurNA" if country=="United States"
replace region = "LatAmCar" if country=="Uruguay"
replace region = "EurCA" if country=="USSR"
replace region = "EurCA" if country=="Uzbekistan"
replace region = "LatAmCar" if country=="Venezuela"
replace region = "LatAmCar" if country=="Venezuela, RB"
replace region = "EAsiaPac" if country=="Vietnam"
replace region = "EAsiaPac" if country=="Vietnam North"
replace region = "EAsiaPac" if country=="Vietnam South"
replace region = "EAsiaPac" if country=="Vietnam, North"
replace region = "EAsiaPac" if country=="Vietnam, South"
replace region = "MENA" if country=="West Bank and Gaza"
replace region = "MENA" if country=="Yemen"
replace region = "MENA" if country=="Yemen North"
replace region = "MENA" if country=="Yemen South"
replace region = "MENA" if country=="Yemen Arab Republic"
replace region = "MENA" if country=="Yemen, N.Arab"
replace region = "MENA" if country=="Yemen, South"
replace region = "EurCA" if country=="Yugoslavia"
replace region = "SubSahAf" if country=="Zaire (Congo Kinshasa)"
replace region = "SubSahAf" if country=="Zambia"
replace region = "SubSahAf" if country=="Zimbabwe"
replace region = "EAsiaPac" if country=="Marshall Islands"
replace region = "EAsiaPac" if country=="Micronesia"
replace region = "EAsiaPac" if country=="Micronesia, Fed. Sts"
replace region = "EAsiaPac" if country=="Palau"
replace region = "EAsiaPac" if country=="Samoa"
replace region = "EAsiaPac" if country=="Tuvalau"
replace region = "EAsiaPac" if country=="Vanuatu"
replace region = "LatAmCar" if country=="St. Kitts and Nevis"
replace region = "LatAmCar" if country=="St. Lucia"
replace region = "LatAmCar" if country=="St. Vincent and the Grenadines"
replace region = "LatAmCar" if country=="Suriname"
replace region = "SubSahAf" if country=="Mayotte"
replace region="LatAmCar" if ccode>30&ccode<166
replace region="WEurNA" if ccode>199&ccode<300
replace region="EurCA" if ccode>338&ccode<348
replace region="SubSahAf" if ccode>400&ccode<518
replace region="SubSahAf" if ccode>540&ccode<592
replace region="EAsiaPac" if ccode==730|ccode==775
replace region="Sasia" if ccode==781
replace region="EAsiaPac" if ccode>814&ccode<899
replace region="EAsiaPac" if ccode==911
replace region="EAsiaPac" if ccode==914
replace region="EAsiaPac" if ccode==946
replace region="EAsiaPac" if ccode==955
replace region="EAsiaPac" if ccode==983
replace region="EAsiaPac" if ccode==986
replace region="EAsiaPac" if ccode==987
replace region="EAsiaPac" if ccode==990
replace region="WEurNA" if ccode==300
replace region="EurCA" if ccode>314&ccode<318
replace region="WEurNA" if ccode>323&ccode<338
replace region="EurCA" if ccode==364
replace region="MENA" if ccode==525|ccode==529
replace region="SubSahAf" if ccode==591
replace region="MENA" if ccode>677&ccode<681
replace region="Sasia" if ccode==769
replace region="WEurNA" if ccode==1002

xtset ccode year
gen currenttenure = year-year(ein2)

xtset ccode year
gen numreg =.
replace numreg = 1 if region=="EAsiaPac"
replace numreg = 2 if region=="EurCA"
replace numreg = 3 if region=="LatAmCar"
replace numreg = 4 if region=="MENA"
replace numreg = 5 if region=="Sasia"
replace numreg = 6 if region=="SubSahAf"
replace numreg = 7 if region=="WEurNA"
replace numreg = 8 if region=="Oceania"
replace numreg = . if polity2==.
label var numreg "1: EAsiaPac; 2: EurCA; 3: LatAmCar; 4:MENA; 5: Sasia; 6:SubSahAf; 7:WEurNA; 8:Oceania"

gen incomegroup = .
replace incomegroup = 1 if gdppc<=800
replace incomegroup = 2 if gdppc>800&gdppc<=1100
replace incomegroup = 3 if gdppc>1100&gdppc<=1500
replace incomegroup = 4 if gdppc>1500&gdppc<=2200
replace incomegroup = 5 if gdppc>2200&gdppc<=3000
replace incomegroup = 6 if gdppc>3000&gdppc~=.
replace incomegroup = . if polity2==.

gen polgroup = .
replace polgroup=1 if polity2<-8
replace polgroup=2 if polity2>=-8&polity2<-6
replace polgroup=3 if polity2>=-6&polity2<-3
replace polgroup=4 if polity2>=-3&polity2<3 
replace polgroup=5 if polity2>=3&polity2<6

*gen decade = int(year/10)*10*
*replace decade =. if decade<1870*
*replace decade = . if polity2==.*
*The Fisher test cannot be calculated with this with available memory resources*

gen timeg=.
replace timeg = 1 if year >=1875&year<1890
replace timeg = 2 if year >=1890&year<1905
replace timeg = 3 if year >=1905&year<1920
replace timeg = 4 if year >=1920&year<1935
replace timeg = 5 if year >=1935&year<1950
replace timeg = 6 if year >=1950&year<1965
replace timeg = 7 if year >=1965&year<1980
replace timeg = 8 if year >=1980&year<1995
replace timeg = 9 if year >=1995&year<2005
replace timeg = . if  polity2==.

gen tengroup = .
replace tengroup=1 if currenttenure <2
replace tengroup=2 if currenttenure >=2&currenttenure <4
replace tengroup=3 if currenttenure >=4&currenttenure <6
replace tengroup=4 if currenttenure >=6&currenttenure <10 
replace tengroup=5 if currenttenure >=10&currenttenure <.
gen ltengroup = l.tengroup

gen agenewgroup = .
replace agenewgroup = 1 if l.agenew<46
replace agenewgroup = 2 if l.agenew>46&l.agenew<=52
replace agenewgroup = 3 if l.agenew>52&l.agenew<=58
replace agenewgroup = 4 if l.agenew>58&l.agenew<=64
replace agenewgroup = 5 if l.agenew>64&l.agenew~=.
replace agenewgroup=. if polity2==.

*for Table A8*
tab ncfull incomegroup if polity2<6&year>1874&year<2005, chi2 row exact
tab ncfull numreg if polity2<6&year>1874&year<2005, chi2 row exact(5)
tab ncfull polgroup if polity2<6&year>1874&year<2005, chi2 row exact
tab ncfull timeg if polity2<6&year>1874&year<2005, chi2 row exact(200)
tab ncfull ltengroup if polity2<6&year>1874&year<2005, chi2 row exact
tab ncfull agenewgroup if polity2<6&year>1874&year<2005, chi2 row exact

save "C:\Democracy\AJPS\democworki.dta", replace

*for Table 3*
gen df10pol2 = f10.pol2norm-pol2norm
gen loggdppc = log10(gdppc)
gen lloggdppc = l.loggdppc
reg df10pol2 lloggdppc if ncfull==1&polity2<6&year>1874&year<2005, rob

gen nonatc10 = 0
replace nonatc10=1 if f10.ncfull==0& f9.ncfull==0&f8.ncfull==0&f7.ncfull==0&f6.ncfull==0&f5.ncfull==0&f4.ncfull==0&f3.ncfull==0&f2.ncfull==0&f.ncfull==0&ncfull==0
replace nonatc10=. if f10.ncfull==.|f9.ncfull==.|f8.ncfull==.|f7.ncfull==.|f6.ncfull==.|f5.ncfull==.|f4.ncfull==.|f3.ncfull==.|f2.ncfull==.|f.ncfull==.|ncfull==.
reg df10pol2 lloggdppc if nonatc10==1&polity2<6&year>1874&year<2005, rob

gen nolt10=0
replace nolt10 = 1 if f10.leaderturn==0&f9.leaderturn==0&f8.leaderturn==0&f7.leaderturn==0&f6.leaderturn==0&f5.leaderturn==0&f4.leaderturn==0&f3.leaderturn==0&f2.leaderturn==0&f.leaderturn==0&leaderturn==0
replace nolt10 = . if f10.leaderturn==.|f9.leaderturn==.|f8.leaderturn==.|f7.leaderturn==.|f6.leaderturn==.|f5.leaderturn==.|f4.leaderturn==.|f3.leaderturn==.|f2.leaderturn==.|f.leaderturn==.|leaderturn==.
reg df10pol2 lloggdppc if nolt10==1&polity2<6&year>1874&year<2005, rob

gen lt10=0
replace lt10 = . if f10.leaderturn==.|f9.leaderturn==.|f8.leaderturn==.|f7.leaderturn==.|f6.leaderturn==.|f5.leaderturn==.|f4.leaderturn==.|f3.leaderturn==.|f2.leaderturn==.|f.leaderturn==.|leaderturn==.
replace lt10 = 1 if f10.leaderturn==1|f9.leaderturn==1|f8.leaderturn==1|f7.leaderturn==1|f6.leaderturn==1|f5.leaderturn==1|f4.leaderturn==1|f3.leaderturn==1|f2.leaderturn==1|f.leaderturn==1|leaderturn==1
tab nonatc10 lt10 if polity2<6, row

*and controlling for region, tenure group , and age group: Table A9

reg df10pol2 lloggdppc i.numreg i.ltengroup i.agenewgroup if ncfull==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc i.numreg i.ltengroup i.agenewgroup if nonatc10==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc i.numreg i.ltengroup i.agenewgroup if nolt10==1&polity2<6&year>1874&year<2005, rob

reg df10pol2 lloggdppc i.numreg l.currenttenure l.agenew if ncfull==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc i.numreg l.currenttenure l.agenew if nonatc10==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc i.numreg l.currenttenure l.agenew if nolt10==1&polity2<6&year>1874&year<2005, rob


*now with wars and leader change*
*mildef is dummy for military defeat in war that did not result in foreign occupation or imposition of leader any time in following 10 years.*
gen mildef = lostwarthisyr
*exclude if occupied in following 10 years or if leader imposed*
replace mildef=. if lostwarthisyr==1&polity==-66
replace mildef=. if lostwarthisyr==1&f.polity==-66
replace mildef=. if lostwarthisyr==1&f2.polity==-66
replace mildef=. if lostwarthisyr==1&f3.polity==-66
replace mildef=. if lostwarthisyr==1&f4.polity==-66
replace mildef=. if lostwarthisyr==1&f5.polity==-66
replace mildef=. if lostwarthisyr==1&f6.polity==-66
replace mildef=. if lostwarthisyr==1&f7.polity==-66
replace mildef=. if lostwarthisyr==1&f8.polity==-66
replace mildef=. if lostwarthisyr==1&f9.polity==-66
replace mildef=. if lostwarthisyr==1&f10.polity==-66
replace mildef=. if country=="Vietnam South"&year==1975
*South Vietnam ceases to exist*
replace mildef=. if lostwarthisyr==1&entry==2
replace mildef=. if lostwarthisyr==1&f.entry==2
replace mildef=. if lostwarthisyr==1&f2.entry==2
replace mildef=. if lostwarthisyr==1&f3.entry==2
replace mildef=. if lostwarthisyr==1&f4.entry==2
replace mildef=. if lostwarthisyr==1&f5.entry==2
replace mildef=. if lostwarthisyr==1&f6.entry==2
replace mildef=. if lostwarthisyr==1&f7.entry==2
replace mildef=. if lostwarthisyr==1&f8.entry==2
replace mildef=. if lostwarthisyr==1&f9.entry==2
replace mildef=. if lostwarthisyr==1&f10.entry==2

gen mildefturn = mildef*leaderturn

gen nomildefturn= 0
replace nomildefturn= 1 if f10.mildefturn==0&f9.mildefturn==0&f8.mildefturn==0&f7.mildefturn==0&f6.mildefturn==0&f5.mildefturn==0&f4.mildefturn==0&f3.mildefturn==0&f2.mildefturn==0&f.mildefturn==0&mildefturn==0
replace nomildefturn=. if  f10.mildefturn==.|f9.mildefturn==.|f8.mildefturn==.|f7.mildefturn==.|f6.mildefturn==.|f5.mildefturn==.|f4.mildefturn==.|f3.mildefturn==.|f2.mildefturn==.|f.mildefturn==.|mildefturn==.

gen mildefnoturn= 0
replace mildefnoturn= 1 if mildef ==1&f10.leaderturn==0 &f9.leaderturn==0&f8.leaderturn==0&f7.leaderturn==0&f6.leaderturn==0&f5.leaderturn==0&f4.leaderturn==0&f3.leaderturn==0&f2.leaderturn==0&f.leaderturn==0&leaderturn==0
replace mildefnoturn=. if  f10.leaderturn==.|f9.leaderturn==.|f8.leaderturn==.|f7.leaderturn==.|f6.leaderturn==.|f5.leaderturn==.|f4.leaderturn==.|f3.leaderturn==.|f2.leaderturn==.|f.leaderturn==.|leaderturn==.

reg df10pol2 lloggdppc if mildefturn==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc if nomildefturn==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc if mildefnoturn==1&polity2<6&year>1874&year<2005, rob


*check that these mildefturn regimes are not disproportionately the military ones that are sensitive to military defeat

gen lmilitaryregime = l.militaryregime
gen lmonarchy=l.monarchy
tab  lmilitaryregime mildefturn if polity2<6, column
*From this, proportion of military regimes among nondemocracies that lost war and where leader replaced  in same year is a bit higher (11%)
*than proportion of military regimes in all nondemocracy country years, 5%. So control for military regime (as of previous period):


*but, a problem if we just run this regression controlling for military regime, because data gaps mean N drops from 14 to 6. I therefore fill the gaps where possible based on historical research:

replace militaryregime=0 if country=="Germany"&year==1918
replace militaryregime=0 if country=="Austria"&year==1918
replace militaryregime=0 if country=="Hungary"&year==1919
replace militaryregime=0 if country=="Hungary"&year==1945
replace militaryregime=0 if country=="Italy"&year==1943
replace militaryregime=0 if country=="Bulgaria"&year==1918
replace militaryregime=0 if country=="Bulgaria"&year==1944
replace militaryregime=1 if country=="Romania"&year==1944
replace lmilitaryregime=0 if country=="Germany"&year==1918
replace lmilitaryregime=0 if country=="Austria"&year==1918
replace lmilitaryregime=0 if country=="Hungary"&year==1919
replace lmilitaryregime=0 if country=="Hungary"&year==1945
replace lmilitaryregime=0 if country=="Italy"&year==1943
replace lmilitaryregime=0 if country=="Bulgaria"&year==1918
replace lmilitaryregime=0 if country=="Bulgaria"&year==1944
replace lmilitaryregime=1 if country=="Romania"&year==1944
replace lmonarchy=1 if country=="Germany"&year==1918
replace lmonarchy=1 if country=="Austria"&year==1918
replace lmonarchy=0 if country=="Hungary"&year==1919
replace lmonarchy=0 if country=="Hungary"&year==1945
replace lmonarchy=0 if country=="Italy"&year==1943
replace lmonarchy=1 if country=="Bulgaria"&year==1918
replace lmonarchy=0 if country=="Bulgaria"&year==1944
replace lmonarchy=0 if country=="Romania"&year==1944

reg df10pol2 lloggdppc lmilitaryregime lmonarchy if mildefturn==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc lmilitaryregime lmonarchy if nomildefturn==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc lmilitaryregime lmonarchy if mildefnoturn==1&polity2<6&year>1874&year<2005, rob

save "C:\Democracy\AJPS\democworki.dta", replace


*no leader turnover in next 3 years
gen mildefnoturn3= 0
replace mildefnoturn3= 1 if mildef ==1&f3.leaderturn==0&f2.leaderturn==0&f.leaderturn==0&leaderturn==0
replace mildefnoturn3=. if  f3.leaderturn==.|f2.leaderturn==.|f.leaderturn==.|leaderturn==.
reg df10pol2 lloggdppc lmilitaryregime if mildefnoturn3==1&polity2<6&year>1874&year<2005, rob


*Results are similar excluding cases where the country itself started the war, but somewhat less significant (coefficient: 1.01, p < .10) as the number of cases of exit after military defeat falls to nine. 
reg df10pol2 lloggdppc if mildefturn==1&polity2<6&year>1874&year<2005&inwar~=1&l.inwar~=1& l2.inwar~=1& l3.inwar~=1& l4.inwar~=1, rob


*now using growth elsewhere in world. Use growthinst, which is world growth, weighted by weight in the given country's trade*
*must have run the growthinst.do
list country year l.gdppc l.polity2 df10pol2 growthinst if growthinst<1.00&l.polity2<6

*use this to create globrec in Excel workbook*
*globrec is for nondems for which growth in other countries weighted by trade, averaged less than 0 this year or last year. 
gen globrec=0
replace globrec = 1 if country=="Afghanistan" & year==1991
replace globrec = 1 if country=="Afghanistan" & year==1992
replace globrec = 1 if country=="Afghanistan" & year==1993
replace globrec = 1 if country=="Afghanistan" & year==1994
replace globrec = 1 if country=="Afghanistan" & year==1998
replace globrec = 1 if country=="Albania" & year==1930
replace globrec = 1 if country=="Albania" & year==1931
replace globrec = 1 if country=="Albania" & year==1932
replace globrec = 1 if country=="Albania" & year==1990
replace globrec = 1 if country=="Albania" & year==1991
replace globrec = 1 if country=="Albania" & year==1992
replace globrec = 1 if country=="Albania" & year==1993
replace globrec = 1 if country=="Algeria" & year==1991
replace globrec = 1 if country=="Angola" & year==1991
replace globrec = 1 if country=="Argentina" & year==1908
replace globrec = 1 if country=="Argentina" & year==1921
replace globrec = 1 if country=="Argentina" & year==1930
replace globrec = 1 if country=="Argentina" & year==1931
replace globrec = 1 if country=="Argentina" & year==1932
replace globrec = 1 if country=="Azerbaijan" & year==1992
replace globrec = 1 if country=="Azerbaijan" & year==1993
replace globrec = 1 if country=="Azerbaijan" & year==1994
replace globrec = 1 if country=="Azerbaijan" & year==1995
replace globrec = 1 if country=="Azerbaijan" & year==1996
replace globrec = 1 if country=="Bahrain" & year==1983
replace globrec = 1 if country=="Bahrain" & year==1985
replace globrec = 1 if country=="Bahrain" & year==1986
replace globrec = 1 if country=="Belarus" & year==1996
replace globrec = 1 if country=="Belarus" & year==1998
replace globrec = 1 if country=="Bolivia" & year==1981
replace globrec = 1 if country=="Bolivia" & year==1982
replace globrec = 1 if country=="Brazil" & year==1908
replace globrec = 1 if country=="Brazil" & year==1921
replace globrec = 1 if country=="Brazil" & year==1981
replace globrec = 1 if country=="Brazil" & year==1982
replace globrec = 1 if country=="Brazil" & year==1983
replace globrec = 1 if country=="Bulgaria" & year==1923
replace globrec = 1 if country=="Bulgaria" & year==1930
replace globrec = 1 if country=="Bulgaria" & year==1931
replace globrec = 1 if country=="Bulgaria" & year==1932
replace globrec = 1 if country=="Bulgaria" & year==1963
replace globrec = 1 if country=="Bulgaria" & year==1990
replace globrec = 1 if country=="Burkina Faso" & year==1975
replace globrec = 1 if country=="Cambodia" & year==1991
replace globrec = 1 if country=="Cambodia" & year==1998
replace globrec = 1 if country=="Central African Republic" & year==1992
replace globrec = 1 if country=="Central African Republic" & year==1993
replace globrec = 1 if country=="Central African Republic" & year==1995
replace globrec = 1 if country=="Chile" & year==1908
replace globrec = 1 if country=="Chile" & year==1921
replace globrec = 1 if country=="Chile" & year==1930
replace globrec = 1 if country=="Chile" & year==1931
replace globrec = 1 if country=="Chile" & year==1932
replace globrec = 1 if country=="China" & year==1908
replace globrec = 1 if country=="China" & year==1930
replace globrec = 1 if country=="China" & year==1931
replace globrec = 1 if country=="China" & year==1932
replace globrec = 1 if country=="China" & year==1991
replace globrec = 1 if country=="Colombia" & year==1930
replace globrec = 1 if country=="Colombia" & year==1931
replace globrec = 1 if country=="Colombia" & year==1932
replace globrec = 1 if country=="Colombia" & year==1938
replace globrec = 1 if country=="Congo Kinshasa" & year==1975
replace globrec = 1 if country=="Cuba" & year==1930
replace globrec = 1 if country=="Cuba" & year==1931
replace globrec = 1 if country=="Cuba" & year==1932
replace globrec = 1 if country=="Cuba" & year==1938
replace globrec = 1 if country=="Cuba" & year==1990
replace globrec = 1 if country=="Cuba" & year==1991
replace globrec = 1 if country=="Cuba" & year==1992
replace globrec = 1 if country=="Cuba" & year==1993
replace globrec = 1 if country=="Cuba" & year==1994
replace globrec = 1 if country=="Cuba" & year==1998
replace globrec = 1 if country=="Czechoslovakia" & year==1990
replace globrec = 1 if country=="Egypt" & year==1991
replace globrec = 1 if country=="El Salvador" & year==1930
replace globrec = 1 if country=="El Salvador" & year==1931
replace globrec = 1 if country=="El Salvador" & year==1932
replace globrec = 1 if country=="El Salvador" & year==1947
replace globrec = 1 if country=="El Salvador" & year==1982
replace globrec = 1 if country=="Equatorial Guinea" & year==1991
replace globrec = 1 if country=="Equatorial Guinea" & year==1992
replace globrec = 1 if country=="Equatorial Guinea" & year==1993
replace globrec = 1 if country=="Ethiopia" & year==1991
replace globrec = 1 if country=="Finland" & year==1932
replace globrec = 1 if country=="Gabon" & year==1982
replace globrec = 1 if country=="Georgia" & year==1992
replace globrec = 1 if country=="Georgia" & year==1993
replace globrec = 1 if country=="Georgia" & year==1994
replace globrec = 1 if country=="Georgia" & year==1995
replace globrec = 1 if country=="Germany" & year==1908
replace globrec = 1 if country=="Ghana" & year==1991
replace globrec = 1 if country=="Greece" & year==1921
replace globrec = 1 if country=="Guatemala" & year==1930
replace globrec = 1 if country=="Guatemala" & year==1931
replace globrec = 1 if country=="Guatemala" & year==1932
replace globrec = 1 if country=="Guatemala" & year==1947
replace globrec = 1 if country=="Guatemala" & year==1982
replace globrec = 1 if country=="Guinea" & year==1991
replace globrec = 1 if country=="Guinea-Bissau" & year==1975
replace globrec = 1 if country=="Guinea-Bissau" & year==1991
replace globrec = 1 if country=="Haiti" & year==1975
replace globrec = 1 if country=="Haiti" & year==1982
replace globrec = 1 if country=="Honduras" & year==1930
replace globrec = 1 if country=="Honduras" & year==1931
replace globrec = 1 if country=="Honduras" & year==1932
replace globrec = 1 if country=="Honduras" & year==1982
replace globrec = 1 if country=="Hungary" & year==1930
replace globrec = 1 if country=="Hungary" & year==1931
replace globrec = 1 if country=="Hungary" & year==1932
replace globrec = 1 if country=="Hungary" & year==1981
replace globrec = 1 if country=="Hungary" & year==1990
replace globrec = 1 if country=="Indonesia" & year==1998
replace globrec = 1 if country=="Iran" & year==1926
replace globrec = 1 if country=="Iran" & year==1931
replace globrec = 1 if country=="Iran" & year==1932
replace globrec = 1 if country=="Iraq" & year==1947
replace globrec = 1 if country=="Iraq" & year==1991
replace globrec = 1 if country=="Italy" & year==1908
replace globrec = 1 if country=="Italy" & year==1921
replace globrec = 1 if country=="Italy" & year==1930
replace globrec = 1 if country=="Italy" & year==1931
replace globrec = 1 if country=="Italy" & year==1932
replace globrec = 1 if country=="Japan" & year==1893
replace globrec = 1 if country=="Japan" & year==1908
replace globrec = 1 if country=="Japan" & year==1921
replace globrec = 1 if country=="Japan" & year==1930
replace globrec = 1 if country=="Japan" & year==1931
replace globrec = 1 if country=="Japan" & year==1932
replace globrec = 1 if country=="Japan" & year==1938
replace globrec = 1 if country=="Jordan" & year==1983
replace globrec = 1 if country=="Jordan" & year==1991
replace globrec = 1 if country=="Korea North" & year==1961
replace globrec = 1 if country=="Korea North" & year==1991
replace globrec = 1 if country=="Korea North" & year==1998
replace globrec = 1 if country=="Kyrgyzstan" & year==1992
replace globrec = 1 if country=="Kyrgyzstan" & year==1993
replace globrec = 1 if country=="Kyrgyzstan" & year==1994
replace globrec = 1 if country=="Kyrgyzstan" & year==1995
replace globrec = 1 if country=="Kyrgyzstan" & year==1996
replace globrec = 1 if country=="Kyrgyzstan" & year==1998
replace globrec = 1 if country=="Laos" & year==1998
replace globrec = 1 if country=="Liberia" & year==1998
replace globrec = 1 if country=="Libya" & year==1953
replace globrec = 1 if country=="Libya" & year==1975
replace globrec = 1 if country=="Libya" & year==1991
replace globrec = 1 if country=="Libya" & year==1993
replace globrec = 1 if country=="Malaysia" & year==1998
replace globrec = 1 if country=="Mali" & year==1991
replace globrec = 1 if country=="Mauritania" & year==1991
replace globrec = 1 if country=="Mauritania" & year==1993
replace globrec = 1 if country=="Mexico" & year==1893
replace globrec = 1 if country=="Mexico" & year==1894
replace globrec = 1 if country=="Mexico" & year==1896
replace globrec = 1 if country=="Mexico" & year==1908
replace globrec = 1 if country=="Mexico" & year==1921
replace globrec = 1 if country=="Mexico" & year==1930
replace globrec = 1 if country=="Mexico" & year==1931
replace globrec = 1 if country=="Mexico" & year==1932
replace globrec = 1 if country=="Mexico" & year==1938
replace globrec = 1 if country=="Mexico" & year==1982
replace globrec = 1 if country=="Moldova" & year==1992
replace globrec = 1 if country=="Moldova" & year==1993
replace globrec = 1 if country=="Mongolia" & year==1959
replace globrec = 1 if country=="Mongolia" & year==1963
replace globrec = 1 if country=="Mongolia" & year==1979
replace globrec = 1 if country=="Mongolia" & year==1990
replace globrec = 1 if country=="Mongolia" & year==1991
replace globrec = 1 if country=="Mongolia" & year==1992
replace globrec = 1 if country=="Morocco" & year==1991
replace globrec = 1 if country=="Myanmar (Burma)" & year==1998
replace globrec = 1 if country=="Nepal" & year==1965
replace globrec = 1 if country=="Netherlands" & year==1908
replace globrec = 1 if country=="Nicaragua" & year==1930
replace globrec = 1 if country=="Nicaragua" & year==1931
replace globrec = 1 if country=="Nicaragua" & year==1932
replace globrec = 1 if country=="Nicaragua" & year==1947
replace globrec = 1 if country=="Nicaragua" & year==1982
replace globrec = 1 if country=="Nigeria" & year==1975
replace globrec = 1 if country=="Oman" & year==1998
replace globrec = 1 if country=="Paraguay" & year==1952
replace globrec = 1 if country=="Paraguay" & year==1981
replace globrec = 1 if country=="Paraguay" & year==1982
replace globrec = 1 if country=="Peru" & year==1908
replace globrec = 1 if country=="Peru" & year==1921
replace globrec = 1 if country=="Poland" & year==1930
replace globrec = 1 if country=="Poland" & year==1931
replace globrec = 1 if country=="Poland" & year==1932
replace globrec = 1 if country=="Poland" & year==1990
replace globrec = 1 if country=="Poland" & year==1991
replace globrec = 1 if country=="Portugal" & year==1908
replace globrec = 1 if country=="Portugal" & year==1931
replace globrec = 1 if country=="Portugal" & year==1932
replace globrec = 1 if country=="Qatar" & year==1998
replace globrec = 1 if country=="Romania" & year==1908
replace globrec = 1 if country=="Romania" & year==1930
replace globrec = 1 if country=="Romania" & year==1931
replace globrec = 1 if country=="Romania" & year==1932
replace globrec = 1 if country=="Romania" & year==1981
replace globrec = 1 if country=="Romania" & year==1990
replace globrec = 1 if country=="Romania" & year==1991
replace globrec = 1 if country=="Romania" & year==1992
replace globrec = 1 if country=="Romania" & year==1993
replace globrec = 1 if country=="Romania" & year==1994
replace globrec = 1 if country=="Russia" & year==1901
replace globrec = 1 if country=="Russia" & year==1908
replace globrec = 1 if country=="Russia" & year==1921
replace globrec = 1 if country=="Russia" & year==1992
replace globrec = 1 if country=="Russia" & year==1993
replace globrec = 1 if country=="Sierra Leone" & year==1981
replace globrec = 1 if country=="Singapore" & year==1998
replace globrec = 1 if country=="Somalia" & year==1983
replace globrec = 1 if country=="Somalia" & year==1986
replace globrec = 1 if country=="South Africa" & year==1921
replace globrec = 1 if country=="South Africa" & year==1926
replace globrec = 1 if country=="South Africa" & year==1930
replace globrec = 1 if country=="South Africa" & year==1931
replace globrec = 1 if country=="South Africa" & year==1932
replace globrec = 1 if country=="Sudan" & year==1991
replace globrec = 1 if country=="Swaziland" & year==1974
replace globrec = 1 if country=="Swaziland" & year==1975
replace globrec = 1 if country=="Sweden" & year==1901
replace globrec = 1 if country=="Syria" & year==1981
replace globrec = 1 if country=="Syria" & year==1991
replace globrec = 1 if country=="Syria" & year==1992
replace globrec = 1 if country=="Syria" & year==1993
replace globrec = 1 if country=="Syria" & year==1994
replace globrec = 1 if country=="Tajikistan" & year==1992
replace globrec = 1 if country=="Tajikistan" & year==1993
replace globrec = 1 if country=="Tajikistan" & year==1994
replace globrec = 1 if country=="Tajikistan" & year==1995
replace globrec = 1 if country=="Thailand" & year==1930
replace globrec = 1 if country=="Thailand" & year==1931
replace globrec = 1 if country=="Togo" & year==1975
replace globrec = 1 if country=="Tunisia" & year==1991
replace globrec = 1 if country=="Tunisia" & year==1993
replace globrec = 1 if country=="Turkey" & year==1892
replace globrec = 1 if country=="Turkey" & year==1908
replace globrec = 1 if country=="Turkey" & year==1930
replace globrec = 1 if country=="Turkey" & year==1931
replace globrec = 1 if country=="Turkey" & year==1932
replace globrec = 1 if country=="Turkey" & year==1981
replace globrec = 1 if country=="Turkmenistan" & year==1992
replace globrec = 1 if country=="Turkmenistan" & year==1993
replace globrec = 1 if country=="Turkmenistan" & year==1994
replace globrec = 1 if country=="UAE" & year==1998
replace globrec = 1 if country=="Ukraine" & year==1994
replace globrec = 1 if country=="Uruguay" & year==1930
replace globrec = 1 if country=="Uruguay" & year==1931
replace globrec = 1 if country=="Uruguay" & year==1932
replace globrec = 1 if country=="Uruguay" & year==1981
replace globrec = 1 if country=="USSR" & year==1930
replace globrec = 1 if country=="USSR" & year==1931
replace globrec = 1 if country=="USSR" & year==1932
replace globrec = 1 if country=="USSR" & year==1990
replace globrec = 1 if country=="USSR" & year==1991
replace globrec = 1 if country=="Uzbekistan" & year==1992
replace globrec = 1 if country=="Uzbekistan" & year==1993
replace globrec = 1 if country=="Uzbekistan" & year==1994
replace globrec = 1 if country=="Venezuela" & year==1908
replace globrec = 1 if country=="Venezuela" & year==1910
replace globrec = 1 if country=="Venezuela" & year==1930
replace globrec = 1 if country=="Venezuela" & year==1931
replace globrec = 1 if country=="Venezuela" & year==1932
replace globrec = 1 if country=="Venezuela" & year==1938
replace globrec = 1 if country=="Yugoslavia" & year==1930
replace globrec = 1 if country=="Yugoslavia" & year==1931
replace globrec = 1 if country=="Yugoslavia" & year==1932
replace globrec = 1 if country=="Yugoslavia" & year==1981
replace globrec = 1 if country=="Yugoslavia" & year==1990
replace globrec = 1 if country=="Yugoslavia" & year==1991
replace globrec = 1 if country=="Yugoslavia" & year==1992
replace globrec = 1 if country=="Yugoslavia" & year==1993
replace globrec = 1 if country=="Yugoslavia" & year==1994
replace globrec=. if growthinst==.

gen globrecturn = globrec*leaderturn
gen llngdppc = l.lngdppc
gen noglobrecturn= 0
replace noglobrecturn= 1 if f10.globrecturn==0&f9.globrecturn==0&f8.globrecturn==0&f7.globrecturn==0&f6.globrecturn==0&f5.globrecturn==0&f4.globrecturn==0&f3.globrecturn==0&f2.globrecturn==0&f.globrecturn==0&globrecturn==0
replace noglobrecturn=. if  f10.globrecturn==.|f9.globrecturn==.|f8.globrecturn==.|f7.globrecturn==.|f6.globrecturn==.|f5.globrecturn==.|f4.globrecturn==.|f3.globrecturn==.|f2.globrecturn==.|f.globrecturn==.|globrecturn==.

gen globrecnolt10 = 0
replace globrecnolt10=1 if globrec==1&f10.leaderturn==0&f9.leaderturn==0&f8.leaderturn==0&f7.leaderturn==0&f6.leaderturn==0&f5.leaderturn==0&f4.leaderturn==0&f3.leaderturn==0&f2.leaderturn==0&f.leaderturn==0&leaderturn==0
replace globrecnolt10=. if f10.leaderturn==.|f9.leaderturn==.|f8.leaderturn==.|f7.leaderturn==.|f6.leaderturn==.|f5.leaderturn==.|f4.leaderturn==.|f3.leaderturn==.|f2.leaderturn==.|f.leaderturn==.|leaderturn==.

reg df10pol2 lloggdppc if globrecturn==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc if noglobrecturn==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc if globrecnolt10==1&polity2<6&year>1874&year<2005, rob

*no leader turnover in next 3 years
gen globrecnolt3= 0
replace globrecnolt3=1 if globrec==1&f3.leaderturn==0&f2.leaderturn==0&f.leaderturn==0&leaderturn==0
replace globrecnolt3=. if f3.leaderturn==.|f2.leaderturn==.|f.leaderturn==.|leaderturn==.
reg df10pol2 lloggdppc if globrecnolt3==1&polity2<6&year>1874&year<2005, rob

*check that these are not disproportionately military regimes, since Geddes says military regimes more sensitive to ec crisis

tab  militaryregime globrecturn if polity2<6, column

*control for  regime

reg df10pol2 lloggdppc lmilitaryregime lmonarchy if globrecturn==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc lmilitaryregime lmonarchy if noglobrecturn==1&polity2<6&year>1874&year<2005, rob
reg df10pol2 lloggdppc lmilitaryregime  lmonarchy if globrecnolt10==1&polity2<6&year>1874&year<2005, rob


*Table A10 Previous rate of leader turnover*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
gen llead=l.leaderturn
gen lturnrate20 = l.turnrate20
gen lturnrate10 = l.turnrate10
gen lturnrate5 = l.turnrate5
sum lturnrate20 lturnrate10 lturnrate5 if l.polity2<6
*From this  mean plus one SD for each is: lturnrate20	0.5223498; lturnrate10	0.5245265; lturnrate5	0.5329687

reg pol2norm lpol2norm llngdppc llngdpturn1 l.leaderturn i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*with leader exit
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*without leader exit
nlcom ((_b[llngdppc])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

gen llnlturn = lturnrate20*llngdppc
gen lleadturn = llead*lturnrate20
gen lleadturnlln = llnlturn*llead
reg pol2norm lpol2norm llead llngdppc lturnrate20 llnlturn llngdpturn1 lleadturn lleadturnlln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*with turnover, lturnrate=.52
*with leader exit
nlcom ((_b[llngdppc]+_b[llnlturn]*.52+_b[llngdpturn1]+_b[lleadturnlln]*.52)/(1-_b[lpol2norm]))
*without leader exit
nlcom ((_b[llngdppc]+_b[llnlturn]*.52)/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

drop llnlturn lleadturn lleadturnlln
gen llnlturn = lturnrate10*llngdppc
gen lleadturn = llead*lturnrate10
gen lleadturnlln = llnlturn*llead
reg pol2norm lpol2norm llead llngdppc lturnrate10 llnlturn llngdpturn1 lleadturn lleadturnlln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*with turnover, lturnrate=.52
*with leader exit
nlcom ((_b[llngdppc]+_b[llnlturn]*.52+_b[llngdpturn1]+_b[lleadturnlln]*.52)/(1-_b[lpol2norm]))
*without leader exit
nlcom ((_b[llngdppc]+_b[llnlturn]*.52)/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

drop llnlturn lleadturn lleadturnlln
gen llnlturn = lturnrate5*llngdppc
gen lleadturn = llead*lturnrate5
gen lleadturnlln = llnlturn*llead
reg pol2norm lpol2norm llead llngdppc lturnrate5 llnlturn llngdpturn1 lleadturn lleadturnlln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*with turnover, lturnrate=.53
*with leader exit
nlcom ((_b[llngdppc]+_b[llnlturn]*.53+_b[llngdpturn1]+_b[lleadturnlln]*.53)/(1-_b[lpol2norm]))
*without leader exit
nlcom ((_b[llngdppc]+_b[llnlturn]*.53)/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*TABLE A11. Popular mobilizations and press freedom*
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lnbanksagd = ln(1+banksagd)
gen lnbanksriots = ln(1+banksriots)
gen lnbanksrev = ln(1+banksrev)
gen lnbanksstrikes = ln(1+banksstrikes)
gen fhpresrev = 100 - fhpress
*eliminate an error*
replace fhpresrev=. if fhpresrev==-230

by ccode: egen lnagdmean = mean(lnbanksagd)if fhpresrev~=.
by ccode: egen lnriotsmean = mean(lnbanksriots)if fhpresrev~=.
by ccode: egen lnrevmean = mean(lnbanksrev)if fhpresrev~=.
by ccode: egen lnstrikesmean = mean(lnbanksstrikes)if fhpresrev~=.
by ccode: egen fhpresrevmean = mean(fhpresrev)if fhpresrev~=.
by ccode: egen pol2normmean = mean(pol2norm)if fhpresrev~=.
by ccode: egen oneyrgrowmean = mean(oneyrgrow)if fhpresrev~=.
by ccode: egen lngdppcmean = mean(lngdppc)

reg lnagdmean fhpresrevmean pol2normmean lngdppcmean oneyrgrowmean if year==2000, rob 
reg lnriotsmean fhpresrevmean pol2normmean lngdppcmean oneyrgrowmean if year==2000, rob 
reg lnstrikesmean fhpresrevmean pol2normmean lngdppcmean oneyrgrowmean if year==2000, rob 
reg lnrevmean fhpresrevmean pol2normmean lngdppcmean oneyrgrowmean if year==2000, rob 

*if year==2000 just to limit regression to one year* 

*Table A12: Explaining leader exit
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen mildef = lostwarthisyr
*exclude if occupied in following 10 years or if leader imposed*
replace mildef=. if lostwarthisyr==1&polity==-66
replace mildef=. if lostwarthisyr==1&f.polity==-66
replace mildef=. if lostwarthisyr==1&f2.polity==-66
replace mildef=. if lostwarthisyr==1&f3.polity==-66
replace mildef=. if lostwarthisyr==1&f4.polity==-66
replace mildef=. if lostwarthisyr==1&f5.polity==-66
replace mildef=. if lostwarthisyr==1&f6.polity==-66
replace mildef=. if lostwarthisyr==1&f7.polity==-66
replace mildef=. if lostwarthisyr==1&f8.polity==-66
replace mildef=. if lostwarthisyr==1&f9.polity==-66
replace mildef=. if lostwarthisyr==1&f10.polity==-66
replace mildef=. if country=="Vietnam South"&year==1975
*South Vietnam ceases to exist*
replace mildef=. if lostwarthisyr==1&entry==2
replace mildef=. if lostwarthisyr==1&f.entry==2
replace mildef=. if lostwarthisyr==1&f2.entry==2
replace mildef=. if lostwarthisyr==1&f3.entry==2
replace mildef=. if lostwarthisyr==1&f4.entry==2
replace mildef=. if lostwarthisyr==1&f5.entry==2
replace mildef=. if lostwarthisyr==1&f6.entry==2
replace mildef=. if lostwarthisyr==1&f7.entry==2
replace mildef=. if lostwarthisyr==1&f8.entry==2
replace mildef=. if lostwarthisyr==1&f9.entry==2
replace mildef=. if lostwarthisyr==1&f10.entry==2
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lnantigov = ln(1+ banksagd)
gen dantigov = banksagd-l.banksagd
gen ldantilln = l.dantigov*llngdppc
gen regyear = numreg*10000+year
by regyear, sort: egen reglfalls = mean(leaderfalls)
*since leaderfalls is 0 or 1, this gives proportion of 1s*
by regyear, sort: egen countlfalls = count(leaderfalls)
gen regotherlfalls = reglfalls
replace regotherlfalls = (reglfalls*countlfalls-1)/countlfalls if leaderfalls==1
gen tenureleader = year -year(ein2)
xtset ccode year
gen dem=0
replace dem=1 if polity2>=6
replace dem=. if polity2==.
gen ldemoneyr = l.dem*oneyrgrowth
gen ldemmildef = l.dem*mildef
gen ldeml2lnantigov = l.dem*l2.lnantigov
gen ldemldantigov = l.dem*l.dantigov
gen ldembanksass= l.dem*l.banksassass
gen ldemgwar= l.dem*l.gwar
gen ldemcivilwar= l.dem*l.civilwar
gen ldemcrisis= l.dem*l.crisis
gen ldemlln =l.dem*llngdppc
gen ldemlreg = l.dem*l.regotherlfalls
gen ldemlage = l.dem*l.agenew
gen ldemlprev = l.dem*l.prevtimes
gen ldemtenure = l.dem*l.tenureleader

*column 1
xtlogit leaderfalls oneyrgrowth  l.dem llngdppc l.regotherlfalls l.agenew l.prevtimes l.tenureleader ldemoneyr ldemlln ldemlreg ldemlage ldemlprev ldemtenure  i.year if year>1874&year<2005, fe
nlcom (_b[oneyrgrowth]+_b[ldemoneyr])
nlcom (_b[llngdppc]+_b[ldemlln])
nlcom (_b[l.agenew]+_b[ldemlage])
nlcom (_b[l.tenureleader]+_b[ldemtenure])

*column 2: IV*
gen lagenew= l.agenew
gen lprevtimes = l.prevtimes 
gen ltenureleader=l.tenureleader 
gen lregotherlfalls = l.regotherlfalls
gen demoneyr = l.dem*oneyrgrowth
gen demgi = l.dem*growthinst
gen ldem = l.dem
gen l2lnantigov = l2.lnantigov
gen ldantigov = l.dantigov
gen lbanksass =  l.banksassass 
gen lgwar =l.gwar 
gen lcivilwar = l.civilwar 
gen lcrisis =l.crisis

xi: ivreg2 leaderfalls llngdppc (oneyrgrowth demoneyr = growthinst demgi) ldem interstatewar lregotherlfalls lagenew lprevtimes ltenureleader ldemlln ldemlreg ldemlage ldemlprev ldemtenure i.year i.ccode if year>1874&year<2005, rob first fwl(i.ccode i.year) cluster(ccode)
lincom (_b[oneyrgrowth]+_b[demoneyr])
lincom (_b[llngdppc]+_b[ldemlln])
lincom (_b[lagenew]+_b[ldemlage])
lincom (_b[ltenureleader]+_b[ldemtenure])
predict res, resid
xtfisher res
drop res

*column 3
xtlogit leaderfalls mildef  l.dem llngdppc l.regotherlfalls l.agenew l.prevtimes l.tenureleader ldemmildef ldemlln ldemlreg ldemlage ldemlprev ldemtenure  i.year if year>1874&year<2005, fe
nlcom (_b[mildef]+_b[ldemmildef])
nlcom (_b[llngdppc]+_b[ldemlln])
nlcom (_b[l.agenew]+_b[ldemlage])
nlcom (_b[l.tenureleader]+_b[ldemtenure])

*column 5
xtlogit leaderfalls l2.lnantigov l.dantigov  l.dem llngdppc  l.regotherlfalls l.agenew l.prevtimes l.tenureleader ldeml2lnantigov  ldemldantigov ldemlln ldemlreg ldemlage ldemlprev ldemtenure  i.year if year>1874&year<2005, fe
nlcom (_b[l2.lnantigov]+_b[ldeml2lnantigov])
nlcom (_b[l.dantigov]+_b[ldemldantigov])
nlcom (_b[llngdppc]+_b[ldemlln])
nlcom (_b[l.agenew]+_b[ldemlage])
nlcom (_b[l.tenureleader]+_b[ldemtenure])

*column 6
xtlogit leaderfalls l.banksassass l.gwar l.civilwar l.crisis  l.dem llngdppc  l.regotherlfalls l.agenew l.prevtimes l.tenureleader ldembanksass ldemgwar ldemcivilwar ldemcrisis ldemlln ldemlreg ldemlage ldemlprev ldemtenure  i.year if year>1874&year<2005, fe
nlcom (_b[l.banksassass]+_b[ldembanksass])
nlcom (_b[l.gwar]+_b[ldemgwar])
nlcom (_b[l.civilwar]+_b[ldemcivilwar])
nlcom (_b[l.crisis]+_b[ldemcrisis])
nlcom (_b[llngdppc]+_b[ldemlln])
nlcom (_b[l.agenew]+_b[ldemlage])
nlcom (_b[l.tenureleader]+_b[ldemtenure])

*column 7
gen lmilitaryregime= l.militaryregime
gen lmonarchy=l.monarchy
replace lmilitaryregime=0 if country=="Germany"&year==1918
replace lmilitaryregime=0 if country=="Austria"&year==1918
replace lmilitaryregime=0 if country=="Hungary"&year==1919
replace lmilitaryregime=0 if country=="Hungary"&year==1945
replace lmilitaryregime=0 if country=="Italy"&year==1943
replace lmilitaryregime=0 if country=="Bulgaria"&year==1918
replace lmilitaryregime=0 if country=="Bulgaria"&year==1944
replace lmilitaryregime=1 if country=="Romania"&year==1944
replace lmonarchy=1 if country=="Germany"&year==1918
replace lmonarchy=1 if country=="Austria"&year==1918
replace lmonarchy=0 if country=="Hungary"&year==1919
replace lmonarchy=0 if country=="Hungary"&year==1945
replace lmonarchy=0 if country=="Italy"&year==1943
replace lmonarchy=1 if country=="Bulgaria"&year==1918
replace lmonarchy=0 if country=="Bulgaria"&year==1944
replace lmonarchy=0 if country=="Romania"&year==1944


xtlogit leaderfalls lmilitaryregime lmonarchy l.dem llngdppc  l.regotherlfalls l.agenew l.prevtimes l.tenureleader ldemlln ldemlreg ldemlage ldemlprev ldemtenure  i.year if year>1874&year<2005, fe
nlcom (_b[llngdppc]+_b[ldemlln])
nlcom (_b[l.agenew]+_b[ldemlage])
nlcom (_b[l.tenureleader]+_b[ldemtenure])

*column 8
xtlogit leaderfalls l.gwf_milit l.gwf_personal l.gwf_monarchy l.gwfmisc  llngdppc l.dem l.regotherlfalls l.agenew l.prevtimes l.tenureleader ldemlln ldemlreg ldemlage ldemlprev ldemtenure  i.year if year>1874&year<2005, fe
nlcom (_b[llngdppc]+_b[ldemlln])
nlcom (_b[l.agenew]+_b[ldemlage])
nlcom (_b[l.tenureleader]+_b[ldemtenure])


*column 4

*Hazard model: need to switch to leader-year data, using the Bueno de Mesquita and Smith (2010) data on leader change**

xtset ccode year
drop _merge
sort cyear 
save "C:\Democracy\AJPS\democworki.dta", replace

*now merge this into the BdM and Smith leader-year data*

use "C:\Democracy\alastair smith dta\leader_year_dataWORKING.dta", clear
save "C:\Democracy\April 13 2011 Version\leader_year_dataWORKINGDT.dta", replace 

gen cyear = .
replace cyear = ccode*10000+year
sort cyear
*note this produces a lot of double cyears for same country and year where more than one leader per year*

merge cyear using "C:\Democracy\AJPS\democworki.dta", sort uniqusing

*need to correct the tenureleader variable*
gen inyear = year(eindate)
drop tenureleader
gen tenureleader =.
replace tenureleader = year-inyear
save "C:\Democracy\April 13 2011 Version\leader_year_dataWORKINGDT.dta", replace 

sort ccode eindate year
gen outyear = year(eoutdate)
gen leadout = .
replace leadout = 1 if year==outyear
replace leadout = 0 if year<outyear
replace leadout =. if year==2004&exit==-888
*note that BdM and Smith do not do this; I am dropping observations from the last year of data, 2004, when the leader did not leave office. BDM and Smith seem to code these as leader removals*
replace leadout = 0 if leadout==1&exit==2
replace leadout = 0 if leadout==1&exit==2.1
replace leadout = 0 if leadout==1&exit==2.2
*coded as not removed if they died of natural causes, commited suicide, or retired because of bad health; following BDM and Smith on this.*
replace leadout = . if eindate==.

drop _merge
sort cyear
merge cyear using "C:\Democracy\April 13 2011 Version\MM.dta", sort uniqusing

stset endobs, failure(leadout) id(ID) origin(time eindate) scale(365.25)
save "C:\Democracy\April 13 2011 Version\leader_year_dataWORKINGDT.dta", replace 

gen one100 = oneyrgrowth/100
gen one100dem = one100*ldem

streg  oneyrgrowth ldem ldemoneyr mildef ldemmildef llngdppc lregotherlfalls lagenew lprevtimes ltenureleader ldemlln ldemlreg ldemlage ldemlprev ldemtenure, dis(wei) anc(ldem) cluster(ccode)
nlcom (_b[oneyrgrowth]+_b[ldemoneyr])
nlcom (_b[mildef]+_b[ldemmildef])
nlcom (_b[llngdppc]+_b[ldemlln])
nlcom (_b[lagenew]+_b[ldemlage])
nlcom (_b[ltenureleader]+_b[ldemtenure])


*Table A13 and Table 4*

*col 1: growth*
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
gen loneyrlln = l.oneyrgrowth*llngdppc
gen loneyrturn = l.oneyrgrowth*l.leaderturn
gen loneyrturnlln = loneyrturn*llngdppc

reg pol2norm lpol2norm llngdppc l.leaderturn llngdpturn1 l.oneyrgrowth loneyrlln loneyrturn loneyrturnlln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*effect of income given l.oneyrgrow = -10 and no leader exit*
nlcom ( (_b[llngdppc]+_b[loneyrlln]*-10 )/(1-_b[lpol2norm]))
*effect of income given l.oneyrgrow = -10 and leader exit*
nlcom ( (_b[llngdppc]+_b[llngdpturn1]+_b[loneyrlln]*-10+_b[loneyrturnlln]*-10)/(1-_b[lpol2norm]))
*effect of income given l.oneyrgrow = -5 and no leader exit*
nlcom ( (_b[llngdppc]+_b[loneyrlln]*-5 )/(1-_b[lpol2norm]))
*effect of income given l.oneyrgrow = -5 and leader exit*
nlcom ( (_b[llngdppc]+_b[llngdpturn1]+_b[loneyrlln]*-5+_b[loneyrturnlln]*-5 )/(1-_b[lpol2norm]))
*effect of income given l.oneyrgrow = 0 and no leader exit*
nlcom ( (_b[llngdppc] )/(1-_b[lpol2norm]))
*effect of income given l.oneyrgrow = 0 and leader exit*
nlcom ( (_b[llngdppc]+_b[llngdpturn1]) /(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*military defeat*

*col 2*

gen lmildeflln = l.mildef*llngdppc
gen lmildefturn = l.mildef*l.leaderturn
gen lmildefturnlln = lmildefturn*llngdppc
reg pol2norm lpol2norm llngdppc l.leaderturn llngdpturn1 l.mildef lmildeflln lmildefturn lmildefturnlln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*effect of income given military defeat and no leader exit*
nlcom ( (_b[llngdppc]+_b[lmildeflln] )/(1-_b[lpol2norm]))
*effect of income given military defeat and leader exit*
nlcom ( (_b[llngdppc]+_b[llngdpturn1]+_b[lmildeflln]+_b[lmildefturnlln] )/(1-_b[lpol2norm]))
*effect of income given NO military defeat and leader exit*
nlcom ( (_b[llngdppc]+_b[llngdpturn1] )/(1-_b[lpol2norm]))
*effect of income given NO military defeat and no leader exit*
nlcom ( (_b[llngdppc])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*excluding wars with fewer than 500 battledeaths
gen mildef2 = mildef
replace mildef2 = . if mildef==1&batdeath<500
gen lmildef2lln = l.mildef2*llngdppc
gen lmildef2turn = l.mildef2*l.leaderturn
gen lmildef2turnlln = lmildef2turn*llngdppc
reg pol2norm lpol2norm llngdppc l.leaderturn llngdpturn1  l.mildef2 lmildef2lln lmildef2turn lmildef2turnlln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 

*effect of income given military defeat and no leader exit*
nlcom ( (_b[llngdppc]+_b[lmildef2lln] )/(1-_b[lpol2norm]))
*effect of income given military defeat and leader exit*
nlcom ( (_b[llngdppc]+_b[llngdpturn1]+_b[lmildef2lln]+_b[lmildef2turnlln] )/(1-_b[lpol2norm]))
*effect of income given NO military defeat and leader exit*
nlcom ( (_b[llngdppc]+_b[llngdpturn1] )/(1-_b[lpol2norm]))
*effect of income given NO military defeat and no leader exit*
nlcom ( (_b[llngdppc])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*domestic mobilization*
*col 3

gen lnagd = ln(1+ banksagd)
gen dagd = banksagd-l.banksagd
gen dagdlln = dagd*llngdppc
gen dagdturn = dagd*l.leaderturn
gen dagdturnlln = dagdturn*llngdppc
gen ldagd = l.dagd
gen ldagdlln = l.dagdlln
gen ldagdturn = l.leaderturn*ldagd
gen ldagdturnlln = ldagdturn*llngdppc

reg pol2norm lpol2norm llngdppc l.leaderturn  llngdpturn1 l2.lnagd ldagd ldagdlln ldagdturn ldagdturnlln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
*ldagd=2, l.leaderturn=1
nlcom ((_b[llngdppc]+_b[llngdpturn1]+_b[ldagdlln]*2+_b[ldagdturnlln]*2)/(1-_b[lpol2norm]))
*ldagd=2, l.leaderturn=0
nlcom ((_b[llngdppc]+_b[ldagdlln]*2)/(1-_b[lpol2norm]))
*ldagd=0, l.leaderturn=1
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*ldagd=0, l.leaderturn=0
nlcom ((_b[llngdppc])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res


*and mobilization after leader change*
reg pol2norm lpol2norm llngdppc l.leaderturn  llngdpturn1 l.lnagd dagd dagdlln dagdturn dagdturnlln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
*dagd=2, l.leaderturn=1
nlcom ((_b[llngdppc]+_b[llngdpturn1]+_b[dagdlln]*2+_b[dagdturnlln]*2)/(1-_b[lpol2norm]))
*dagd=2, l.leaderturn=0
nlcom ((_b[llngdppc]+_b[dagdlln]*2)/(1-_b[lpol2norm]))
*dagd=0, l.leaderturn=1
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*dagd=0, l.leaderturn=0
nlcom ((_b[llngdppc])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res



*state fragility
*assassinations--not necessarily of leader and not necessarily successful: "Any politically motivated murder or attempted murder of a high government official or politician."

gen lass = l.banksass
replace lass = . if l.banksass==.
gen lasslln = lass*llngdppc
gen lassturn = lass*l.leaderturn
gen lassturnlln = lassturn*llngdppc
reg pol2norm lpol2norm llngdppc l.leaderturn llngdpturn1 lass lasslln lassturn lassturnlln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
*lass=1, l.leaderturn=1
nlcom ((_b[llngdppc]+_b[llngdpturn1]+_b[lasslln]*1+_b[lassturnlln]*1)/(1-_b[lpol2norm]))
*lass=1, l.leaderturn=0
nlcom ((_b[llngdppc]+_b[lasslln]*1)/(1-_b[lpol2norm]))
*lass=0, l.leaderturn=1
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*lass=0, l.leaderturn=0
nlcom ((_b[llngdppc])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res


*guerrilla warfare--"Any armed activity, sabotage, or bombings carried on by independent bands of citizens or irregular forces and aimed at the overthrow of the present regime."

gen guer = l.gwar
gen guerlln = guer*llngdppc
gen guerturn = guer*l.leaderturn
gen guerllnturn = guerturn*llngdppc 
reg pol2norm lpol2norm llngdppc l.leaderturn llngdpturn1 guer guerlln guerturn  guerllnturn i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
*g warfare, no leader exit*
nlcom ((_b[llngdppc]+_b[guerlln])/(1-_b[lpol2norm]))
*g warfare,  leader exit*
nlcom ((_b[llngdppc]+_b[llngdpturn1]+_b[guerlln]+_b[guerllnturn])/(1-_b[lpol2norm]))
*no g warfare, leader exit*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*no g warfare, no leader exit*
nlcom ((_b[llngdppc])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*civil war--COW

gen cwlln = l.civilwar*llngdppc
gen cwturn = l.civilwar*l.leaderturn
gen cwturnlln = cwturn*llngdppc
reg pol2norm lpol2norm llngdppc l.leaderturn llngdpturn1  l.civilwar cwlln cwturn cwturnlln   i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
*civilwar, l.leaderturn=1 
nlcom ((_b[llngdppc]+_b[llngdpturn1]+_b[cwlln]*1+_b[cwturnlln]*1)/(1-_b[lpol2norm]))
*civilwar, l.leaderturn=0
nlcom ((_b[llngdppc]+_b[cwlln]*1)/(1-_b[lpol2norm]))
*no civil war, l.leaderturn=1
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*no civil war, l.leaderturn=0
nlcom ((_b[llngdppc])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*Major govt crisis "Any rapidly developing situation that threatens to bring the downfall of the present regime - excluding situations of revolt aimed at such overthrow"

gen gcrislln = l.crisis*llngdppc
gen gcristurn = l.crisis*l.leaderturn
gen gcrisllnturn = gcristurn*llngdppc 
reg pol2norm lpol2norm llngdppc l.leaderturn llngdpturn1 l.crisis gcrislln gcristurn  gcrisllnturn i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
*gcris, no leader exit*
nlcom ((_b[llngdppc]+_b[gcrislln])/(1-_b[lpol2norm]))
*gcris,  leader exit*
nlcom ((_b[llngdppc]+_b[llngdpturn1]+_b[gcrislln]+_b[gcrisllnturn])/(1-_b[lpol2norm]))
*no gcris, leader exit*
nlcom ((_b[llngdppc]+_b[llngdpturn1])/(1-_b[lpol2norm]))
*no g warfare, no leader exit*
nlcom ((_b[llngdppc])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res




*Type of authoritarian regime  COME BACK TO THIS. DO EACH TYPE AGAINST ALL OTHERS. WITH MARGINS

*Table A14

*BANKS
*1. military, monarchy, others, using Banks

use "C:\Democracy\AJPS\democworki.dta", clear
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
xtset ccode year
gen llead = l.leaderturn
gen lmil = l.militaryregime
gen lmon = l.monarchy
reg pol2norm lpol2norm c.llngdppc##i.llead##i.lmil c.llngdppc##i.llead##i.lmon  i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
margins, dydx(llngdppc) at(lpol2norm=0 llead=(0 1))
margins, dydx(llngdppc) at(lpol2norm=0 llead=(0 1) lmon=0 lmil=0)
margins, dydx(llngdppc) at(lpol2norm=0 llead=(0 1) lmon=0 lmil=1)
margins, dydx(llngdppc) at(lpol2norm=0 llead=(0 1) lmon=1 lmil=0)
predict res, resid
xtfisher res
drop res


use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen lmil = l.militaryregime
gen lmon = l.monarchy
reg pol2norm lpol2norm c.llngdppc##i.ltdiff5##i.lmil c.llngdppc##i.ltdiff5##i.lmon  i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff5=(0 1))
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff5=(0 1) lmon=0 lmil=0)
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff5=(0 1) lmon=0 lmil=1)
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff5=(0 1) lmon=1 lmil=0)
predict res, resid
xtfisher res
drop res


use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen lmil = l.militaryregime
gen lmon = l.monarchy
reg pol2norm lpol2norm c.llngdppc##i.ltdiff10##i.lmil c.llngdppc##i.ltdiff10##i.lmon  i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff10=(0 1))
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff10=(0 1) lmon=0 lmil=0)
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff10=(0 1) lmon=0 lmil=1)
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff10=(0 1) lmon=1 lmil=0)
predict res, resid
xtfisher res
drop res


use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen lmil = l.militaryregime
gen lmon = l.monarchy
reg pol2norm lpol2norm c.llngdppc##i.ltdiff15##i.lmil c.llngdppc##i.ltdiff15##i.lmon  i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff15=(0 1))
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff15=(0 1) lmon=0 lmil=0)
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff15=(0 1) lmon=0 lmil=1)
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff15=(0 1) lmon=1 lmil=0)
predict res, resid
xtfisher res
drop res

*20 YEAR MARGINS 'NOT ESTIMABLE'


*GEDDES

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llead=l.leaderturn
gen lgwfmisc = l.gwfmis
gen lgwfmon= l.gwf_monarchy
gen lgwfpers= l.gwf_personal
gen lgwfparty= l.gwf_party
reg pol2norm lpol2norm c.llngdppc##i.llead##i.lgwfmisc c.llngdppc##i.llead##i.lgwfmon c.llngdppc##i.llead##i.lgwfpers c.llngdppc##i.llead##i.lgwfparty i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*all
margins, dydx(llngdppc) at(lpol2norm=0 llead=(0 1))
*mil
margins, dydx(llngdppc) at(lpol2norm=0 llead=(0 1) lgwfmisc=0 lgwfmon=0 lgwfpers=0  lgwfparty=0)
*misc
margins, dydx(llngdppc) at(lpol2norm=0 llead=(0 1) lgwfmisc=1 lgwfmon=0 lgwfpers=0  lgwfparty=0)
*mon
margins, dydx(llngdppc) at(lpol2norm=0 llead=(0 1) lgwfmisc=0 lgwfmon=1 lgwfpers=0  lgwfparty=0)
*pers
margins, dydx(llngdppc) at(lpol2norm=0 llead=(0 1) lgwfmisc=0 lgwfmon=0 lgwfpers=1  lgwfparty=0)
*party
margins, dydx(llngdppc) at(lpol2norm=0 llead=(0 1) lgwfmisc=0 lgwfmon=0 lgwfpers=0  lgwfparty=1)
predict res, resid
xtfisher res
drop res



use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llead=l.leaderturn
gen lgwfmisc = l.gwfmis
gen lgwfmon= l.gwf_monarchy
gen lgwfpers= l.gwf_personal
gen lgwfparty= l.gwf_party
reg pol2norm lpol2norm c.llngdppc##i.ltdiff5##i.lgwfmisc c.llngdppc##i.ltdiff5##i.lgwfmon c.llngdppc##i.ltdiff5##i.lgwfpers c.llngdppc##i.ltdiff5##i.lgwfparty i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*all
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff5=(0 1))
*mil
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff5=(0 1) lgwfmisc=0 lgwfmon=0 lgwfpers=0  lgwfparty=0)
*misc
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff5=(0 1) lgwfmisc=1 lgwfmon=0 lgwfpers=0  lgwfparty=0)
*mon
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff5=(0 1) lgwfmisc=0 lgwfmon=1 lgwfpers=0  lgwfparty=0)
*pers
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff5=(0 1) lgwfmisc=0 lgwfmon=0 lgwfpers=1  lgwfparty=0)
*party
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff5=(0 1) lgwfmisc=0 lgwfmon=0 lgwfpers=0  lgwfparty=1)
predict res, resid
xtfisher res
drop res

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llead=l.leaderturn
gen lgwfmisc = l.gwfmis
gen lgwfmon= l.gwf_monarchy
gen lgwfpers= l.gwf_personal
gen lgwfparty= l.gwf_party
reg pol2norm lpol2norm c.llngdppc##i.ltdiff10##i.lgwfmisc c.llngdppc##i.ltdiff10##i.lgwfmon c.llngdppc##i.ltdiff10##i.lgwfpers c.llngdppc##i.ltdiff10##i.lgwfparty i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*all
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff10=(0 1))
*mil
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff10=(0 1) lgwfmisc=0 lgwfmon=0 lgwfpers=0  lgwfparty=0)
*misc
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff10=(0 1) lgwfmisc=1 lgwfmon=0 lgwfpers=0  lgwfparty=0)
*mon
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff10=(0 1) lgwfmisc=0 lgwfmon=1 lgwfpers=0  lgwfparty=0)
*pers
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff10=(0 1) lgwfmisc=0 lgwfmon=0 lgwfpers=1  lgwfparty=0)
*party
margins, dydx(llngdppc) at(lpol2norm=0 ltdiff10=(0 1) lgwfmisc=0 lgwfmon=0 lgwfpers=0  lgwfparty=1)
predict res, resid
xtfisher res
drop res


*Table A15: Types of leader turnover*
*NOTE: FOR THE PANELS OF 5-YRS AND HIGHER THE EXIT TYPE REFERS TO THE LAST TURNOVER WITHIN THE PANEL PERIOD AND CODES AS ZERO IF THERE IS A NET INCREASE IN POLITY2 DURING THE PERIOD BUT IT ALL COMES 
*BEFORE OR IN SAME YEAR AS THE LEADER EXIT SO AS NOT TO CREDIT CHANGE IN POLITY2 THAT DID NOT COME AFTER THE TURNOVER TO THAT TURNOVER. 


*1 yr panel*
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
gen regllngdp = l.regular*llngdppc
gen natcausellngdp = l.natcauses*llngdppc
gen ncfullllngdp = l.ncfull*llngdppc
gen irregllngdp = l.irregular*llngdppc
gen deposedllngdp = l.deposed*llngdppc
gen suicidellngdp = l.suicide*llngdppc
gen retiredllngdp = l.retired*llngdppc
reg pol2norm lpol2norm llngdppc l.regular l.irregular l.natcauses l.deposed l.suicide l.retired regllngdp irregllng natcausellng deposedllng suicidellng retiredllng i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced: regular*
nlcom ((_b[llngdppc]+_b[regllngdp])/(1-_b[lpol2norm]))
*if leader replaced: nat causes*
nlcom ((_b[llngdppc]+_b[natcausellngdp])/(1-_b[lpol2norm]))
*if leader replaced: irregular*
nlcom ((_b[llngdppc]+_b[irregllngdp])/(1-_b[lpol2norm]))
*if leader replaced: deposed*
nlcom ((_b[llngdppc]+_b[deposedllngdp])/(1-_b[lpol2norm]))
*if leader replaced: suicide*
nlcom ((_b[llngdppc]+_b[suicidellngdp])/(1-_b[lpol2norm]))
*if leader replaced: retired*
nlcom ((_b[llngdppc]+_b[retiredllngdp])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*5 yr panel*

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn5 = llngdppc*ltdiff5
gen regllngdp = regdiff5*llngdppc
gen natcausellngdp = natcausesdiff5*llngdppc
gen irregllngdp = irregdiff5*llngdppc
gen deposedllngdp = depdiff5*llngdppc
gen suicidellngdp = suidiff5*llngdppc
gen retiredllngdp = retdiff5*llngdppc
reg pol2norm lpol2norm llngdppc regdiff5 natcausesdiff5 irregdiff5 depdiff5 suidiff5 retdiff5 regllngdp irregllng natcausellng deposedllng suicidellng retiredllng i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced: regular*
nlcom ((_b[llngdppc]+_b[regllngdp])/(1-_b[lpol2norm]))
*if leader replaced: nat causes*
nlcom ((_b[llngdppc]+_b[natcausellngdp])/(1-_b[lpol2norm]))
*if leader replaced: irregular*
nlcom ((_b[llngdppc]+_b[irregllngdp])/(1-_b[lpol2norm]))
*if leader replaced: deposed*
nlcom ((_b[llngdppc]+_b[deposedllngdp])/(1-_b[lpol2norm]))
*if leader replaced: suicide*
nlcom ((_b[llngdppc]+_b[suicidellngdp])/(1-_b[lpol2norm]))
*if leader replaced: retired*
nlcom ((_b[llngdppc]+_b[retiredllngdp])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*10 yr panel*

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
gen regllngdp = regdiff10*llngdppc
gen natcausellngdp = natcausesdiff10*llngdppc
gen irregllngdp = irregdiff10*llngdppc
gen deposedllngdp = depdiff10*llngdppc
gen suicidellngdp = suidiff10*llngdppc
gen retiredllngdp = retdiff10*llngdppc
reg pol2norm lpol2norm llngdppc regdiff10 natcausesdiff10 irregdiff10 depdiff10 suidiff10 retdiff10 regllngdp irregllng natcausellng deposedllng suicidellng retiredllng i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced: regular*
nlcom ((_b[llngdppc]+_b[regllngdp])/(1-_b[lpol2norm]))
*if leader replaced: nat causes*
nlcom ((_b[llngdppc]+_b[natcausellngdp])/(1-_b[lpol2norm]))
*if leader replaced: irregular*
nlcom ((_b[llngdppc]+_b[irregllngdp])/(1-_b[lpol2norm]))
*if leader replaced: deposed*
nlcom ((_b[llngdppc]+_b[deposedllngdp])/(1-_b[lpol2norm]))
*if leader replaced: suicide*
nlcom ((_b[llngdppc]+_b[suicidellngdp])/(1-_b[lpol2norm]))
*if leader replaced: retired*
nlcom ((_b[llngdppc]+_b[retiredllngdp])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*15 yr panel*

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn15 = llngdppc*ltdiff15
gen regllngdp = regdiff15*llngdppc
gen natcausellngdp = natcausesdiff15*llngdppc
gen irregllngdp = irregdiff15*llngdppc
gen deposedllngdp = depdiff15*llngdppc
gen suicidellngdp = suidiff15*llngdppc
gen retiredllngdp = retdiff15*llngdppc
reg pol2norm lpol2norm llngdppc regdiff15 natcausesdiff15 irregdiff15 depdiff15 suidiff15 retdiff15 regllngdp irregllng natcausellng deposedllng suicidellng retiredllng i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced: regular*
nlcom ((_b[llngdppc]+_b[regllngdp])/(1-_b[lpol2norm]))
*if leader replaced: nat causes*
nlcom ((_b[llngdppc]+_b[natcausellngdp])/(1-_b[lpol2norm]))
*if leader replaced: irregular*
nlcom ((_b[llngdppc]+_b[irregllngdp])/(1-_b[lpol2norm]))
*if leader replaced: deposed*
nlcom ((_b[llngdppc]+_b[deposedllngdp])/(1-_b[lpol2norm]))
*if leader replaced: suicide*
nlcom ((_b[llngdppc]+_b[suicidellngdp])/(1-_b[lpol2norm]))
*if leader replaced: retired*
nlcom ((_b[llngdppc]+_b[retiredllngdp])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res

*20 yr panel*

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn20 = llngdppc*ltdiff20
gen regllngdp = regdiff20*llngdppc
gen natcausellngdp = natcausesdiff20*llngdppc
gen irregllngdp = irregdiff20*llngdppc
gen deposedllngdp = depdiff20*llngdppc
gen suicidellngdp = suidiff20*llngdppc
gen retiredllngdp = retdiff20*llngdppc
reg pol2norm lpol2norm llngdppc regdiff20 natcausesdiff20 irregdiff20 depdiff20 suidiff20 retdiff20 regllngdp irregllng natcausellng deposedllng suicidellng retiredllng i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode) 
*if leader replaced: regular*
nlcom ((_b[llngdppc]+_b[regllngdp])/(1-_b[lpol2norm]))
*if leader replaced: nat causes*
nlcom ((_b[llngdppc]+_b[natcausellngdp])/(1-_b[lpol2norm]))
*if leader replaced: irregular*
nlcom ((_b[llngdppc]+_b[irregllngdp])/(1-_b[lpol2norm]))
*if leader replaced: deposed*
nlcom ((_b[llngdppc]+_b[deposedllngdp])/(1-_b[lpol2norm]))
*if leader replaced: suicide*
nlcom ((_b[llngdppc]+_b[suicidellngdp])/(1-_b[lpol2norm]))
*if leader replaced: retired*
nlcom ((_b[llngdppc]+_b[retiredllngdp])/(1-_b[lpol2norm]))
predict res, resid
xtfisher res
drop res


*Boix-Rosato*

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = .
replace lpol2norm = l.pol2norm if l.ccode==ccode
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
gen regllngdp = l.regular*llngdppc
gen natcausellngdp = l.natcauses*llngdppc
gen ncfullllngdp = l.ncfull*llngdppc
gen irregllngdp = l.irregular*llngdppc
gen deposedllngdp = l.deposed*llngdppc
gen suicidellngdp = l.suicide*llngdppc
gen retiredllngdp = l.retired*llngdppc
reg brosdembmr llngdppc l.regular l.irregular l.natcauses l.deposed l.suicide l.retired regllngdp irregllng natcausellng deposedllng suicidellng retiredllng i.year i.ccode if l.brosdembmr==0&year>1874&year<2005, rob cluster(ccode) 
*if leader not replaced*
nlcom (_b[llngdppc])
*if leader replaced: regular*
nlcom ((_b[llngdppc]+_b[regllngdp]))
*if leader replaced: nat causes*
nlcom ((_b[llngdppc]+_b[natcausellngdp]))
*if leader replaced: irregular*
nlcom ((_b[llngdppc]+_b[irregllngdp]))
*if leader replaced: deposed*
nlcom ((_b[llngdppc]+_b[deposedllngdp]))
*if leader replaced: suicide*
nlcom ((_b[llngdppc]+_b[suicidellngdp]))
*if leader replaced: retired*
nlcom ((_b[llngdppc]+_b[retiredllngdp]))
predict res, resid
xtfisher res
drop res

*5 yr panel*

use "C:\Democracy\AJPS\merge5yeari.dta", clear
xtset ccode year, delta(5)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn5 = llngdppc*ltdiff5
gen regllngdp = regdiff5*llngdppc
gen natcausellngdp = natcausesdiff5*llngdppc
gen irregllngdp = irregdiff5*llngdppc
gen deposedllngdp = depdiff5*llngdppc
gen suicidellngdp = suidiff5*llngdppc
gen retiredllngdp = retdiff5*llngdppc
reg brosdembmr llngdppc regdiff5 natcausesdiff5 irregdiff5 depdiff5 suidiff5 retdiff5 regllngdp irregllng natcausellng deposedllng suicidellng retiredllng i.year i.ccode if l.brosdembmr==0&year>1874&year<2005, rob cluster(ccode) 
*if leader not replaced*
nlcom (_b[llngdppc])
*if leader replaced: regular*
nlcom ((_b[llngdppc]+_b[regllngdp]))
*if leader replaced: nat causes*
nlcom ((_b[llngdppc]+_b[natcausellngdp]))
*if leader replaced: irregular*
nlcom ((_b[llngdppc]+_b[irregllngdp]))
*if leader replaced: deposed*
nlcom ((_b[llngdppc]+_b[deposedllngdp]))
*if leader replaced: suicide*
nlcom ((_b[llngdppc]+_b[suicidellngdp]))
*if leader replaced: retired*
nlcom ((_b[llngdppc]+_b[retiredllngdp]))
predict res, resid
xtfisher res
drop res

*10 yr panel*

use "C:\Democracy\AJPS\merge10yeari.dta", clear
xtset ccode year, delta(10)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn10 = llngdppc*ltdiff10
gen regllngdp = regdiff10*llngdppc
gen natcausellngdp = natcausesdiff10*llngdppc
gen irregllngdp = irregdiff10*llngdppc
gen deposedllngdp = depdiff10*llngdppc
gen suicidellngdp = suidiff10*llngdppc
gen retiredllngdp = retdiff10*llngdppc
reg brosdembmr llngdppc regdiff10 natcausesdiff10 irregdiff10 depdiff10 suidiff10 retdiff10 regllngdp irregllng natcausellng deposedllng suicidellng retiredllng i.year i.ccode if l.brosdembmr==0&year>1874&year<2005, rob cluster(ccode) 
*if leader not replaced*
nlcom (_b[llngdppc])
*if leader replaced: regular*
nlcom ((_b[llngdppc]+_b[regllngdp]))
*if leader replaced: nat causes*
nlcom ((_b[llngdppc]+_b[natcausellngdp]))
*if leader replaced: irregular*
nlcom ((_b[llngdppc]+_b[irregllngdp]))
*if leader replaced: deposed*
nlcom ((_b[llngdppc]+_b[deposedllngdp]))
*if leader replaced: suicide*
nlcom ((_b[llngdppc]+_b[suicidellngdp]))
*if leader replaced: retired*
nlcom ((_b[llngdppc]+_b[retiredllngdp]))
predict res, resid
xtfisher res
drop res

*15 yr panel*

use "C:\Democracy\AJPS\merge15yeari.dta", clear
xtset ccode year, delta(15)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn15 = llngdppc*ltdiff15
gen regllngdp = regdiff15*llngdppc
gen natcausellngdp = natcausesdiff15*llngdppc
gen irregllngdp = irregdiff15*llngdppc
gen deposedllngdp = depdiff15*llngdppc
gen suicidellngdp = suidiff15*llngdppc
gen retiredllngdp = retdiff15*llngdppc
reg brosdembmr llngdppc regdiff15 natcausesdiff15 irregdiff15 depdiff15 suidiff15 retdiff15 regllngdp irregllng natcausellng deposedllng suicidellng retiredllng i.year i.ccode if l.brosdembmr==0&year>1874&year<2005, rob cluster(ccode) 
*if leader not replaced*
nlcom (_b[llngdppc])
*if leader replaced: regular*
nlcom ((_b[llngdppc]+_b[regllngdp]))
*if leader replaced: nat causes*
nlcom ((_b[llngdppc]+_b[natcausellngdp]))
*if leader replaced: irregular*
nlcom ((_b[llngdppc]+_b[irregllngdp]))
*if leader replaced: deposed*
nlcom ((_b[llngdppc]+_b[deposedllngdp]))
*if leader replaced: suicide*
nlcom ((_b[llngdppc]+_b[suicidellngdp]))
*if leader replaced: retired*
nlcom ((_b[llngdppc]+_b[retiredllngdp]))
predict res, resid
xtfisher res
drop res

*20 yr panel*

use "C:\Democracy\AJPS\merge20yeari.dta", clear
xtset ccode year, delta(20)
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn20 = llngdppc*ltdiff20
gen regllngdp = regdiff20*llngdppc
gen natcausellngdp = natcausesdiff20*llngdppc
gen irregllngdp = irregdiff20*llngdppc
gen deposedllngdp = depdiff20*llngdppc
gen suicidellngdp = suidiff20*llngdppc
gen retiredllngdp = retdiff20*llngdppc
reg brosdembmr llngdppc regdiff20 natcausesdiff20 irregdiff20 depdiff20 suidiff20 retdiff20 regllngdp irregllng natcausellng deposedllng suicidellng retiredllng i.year i.ccode if l.brosdembmr==0&year>1874&year<2005, rob cluster(ccode) 
*if leader not replaced*
nlcom (_b[llngdppc])
*if leader replaced: regular*
nlcom ((_b[llngdppc]+_b[regllngdp]))
*if leader replaced: nat causes*
nlcom ((_b[llngdppc]+_b[natcausellngdp]))
*if leader replaced: irregular*
nlcom ((_b[llngdppc]+_b[irregllngdp]))
*if leader replaced: deposed*
nlcom ((_b[llngdppc]+_b[deposedllngdp]))
*if leader replaced: suicide*
nlcom ((_b[llngdppc]+_b[suicidellngdp]))
*if leader replaced: retired*
nlcom ((_b[llngdppc]+_b[retiredllngdp]))
predict res, resid
xtfisher res
drop res


*WHY DOES EXIT MATTER?

*Between 1900 and 2006, Boix et al. (2012) record 128 cases of democratization; of these, only 31 occurred during a mass resistance campaign, as identified by Chenoweth and Stephan (2011). 
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen brospos = 0
replace brospos=1 if brosdembmr==1&l.brosdembmr==0
replace brospos=. if brosdembmr==.|l.brosdembmr==.
tab brospos if year>1899&year<2007

gen massresist = 0
replace massresist=1 if chennonviol==1|chenviol==1
replace massresist=. if chennonviol==.|chenviol==.
tab brospos massresist if year>1899&year<2007, row
gen banksagdspos = 0
replace banksagdspos=1 if banksagd>0&banksagd<.
replace banksagdspos=. if banksagd==.
tab brospos banksagdspos, row

*mobilization graph
*1.  GREATER MOBILIZATION AFTER LEADER CHANGE

gen banksstrikespos = 0
replace banksstrikespos=1 if banksstrikes>0&banksstrikes<.
replace banksstrikespos=. if banksstrikes==.
gen banksriotspos = 0
replace banksriotspos=1 if banksriots>0&banksriots<.
replace banksriotspos=. if banksriots==.
gen banksrevpos = 0
replace banksrevpos=1 if banksrev>0&banksrev<.
replace banksrevpos=. if banksrev==.

gen f3lead = f3.leaderturn
gen f2lead = f2.leaderturn
gen f1lead = f.leaderturn
gen lead = leaderturn
gen l1lead = l.leaderturn
gen l2lead = l2.leaderturn
gen l3lead = l3.leaderturn

reg banksagd f3lead f2lead f1lead lead l1lead l2lead l3lead i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
margins, at(f3lead==0 f2lead==0 f1lead==0 lead==0 l1lead==0 l2lead==0 l3lead==0)
margins, at(f3lead==1)
margins, at(f2lead==1 )
margins, at(f1lead==1 )
margins, at(lead==1)
margins, at(l1lead==1 )
margins, at(l2lead==1)
margins, at(l3lead==1)

reg banksstrikes f3lead f2lead f1lead lead l1lead l2lead l3lead i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
margins, at(f3lead==0 f2lead==0 f1lead==0 lead==0 l1lead==0 l2lead==0 l3lead==0)
margins, at(f3lead==1)
margins, at(f2lead==1 )
margins, at(f1lead==1 )
margins, at(lead==1)
margins, at(l1lead==1 )
margins, at(l2lead==1)
margins, at(l3lead==1)

reg banksriots f3lead f2lead f1lead lead l1lead l2lead l3lead i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
margins, at(f3lead==0 f2lead==0 f1lead==0 lead==0 l1lead==0 l2lead==0 l3lead==0)
margins, at(f3lead==1)
margins, at(f2lead==1 )
margins, at(f1lead==1 )
margins, at(lead==1)
margins, at(l1lead==1 )
margins, at(l2lead==1)
margins, at(l3lead==1)

reg banksrev f3lead f2lead f1lead lead l1lead l2lead l3lead i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
margins, at(f3lead==0 f2lead==0 f1lead==0 lead==0 l1lead==0 l2lead==0 l3lead==0)
margins, at(f3lead==1)
margins, at(f2lead==1 )
margins, at(f1lead==1 )
margins, at(lead==1)
margins, at(l1lead==1 )
margins, at(l2lead==1)
margins, at(l3lead==1)

gen f3reg = f3.regular
gen f2reg = f2.regular
gen f1reg = f.regular
gen reg = regular
gen l1reg = l.regular
gen l2reg = l2.regular
gen l3reg = l3.regular
gen l4reg = l4.regular
gen f3nat = f3.natcauses
gen f2nat = f2.natcauses
gen f1nat = f.natcauses
gen nat = natcauses
gen l1nat = l.natcauses
gen l2nat = l2.natcauses
gen l3nat = l3.natcauses
gen l4nat = l4.natcauses

reg banksagd f3reg f2reg f1reg reg l1reg l2reg l3reg l4reg i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
margins, at(f3reg==0 f2reg==0 f1reg==0 reg==0 l1reg==0 l2reg==0 l3reg==0 l4reg=0)
margins, at(f3reg==1)
margins, at(f2reg==1 )
margins, at(f1reg==1 )
margins, at(reg==1)
margins, at(l1reg==1 )
margins, at(l2reg==1)
margins, at(l3reg==1)
margins, at(l4reg==1)

reg banksagd f3nat f2nat f1nat nat l1nat l2nat l3nat l4nat i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
margins, at(f3nat==0 f2nat==0 f1nat==0 nat==0 l1nat==0 l2nat==0 l3nat==0 l4nat=0)
margins, at(f3nat==1)
margins, at(f2nat==1 )
margins, at(f1nat==1 )
margins, at(nat==1)
margins, at(l1nat==1 )
margins, at(l2nat==1)
margins, at(l3nat==1)
margins, at(l4nat==1)


*SELECTION VS CHANGE OF INDIVIDUALS

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen lpol2norm = l.pol2norm
gen llngdpturn1 = l.leaderturn*llngdppc
gen termld = year(eout2) - year(ein2)
replace termld = l.termld if leaderturn==1&polity2~=l.polity2&ltfirst2==0
gen tenld = year - year(ein2)
replace tenld=. if ccode==245&year>1871
replace tenld=. if ccode==564&year>1910
replace tenld = . if year>2004
replace tenld = l.tenld if leaderturn==1&polity2~=l.polity2&ltfirst2==0
*I adjusted these vars to pick up tenure characteristics of previous year if it is leaderturnover year and there was some polity change, but it came under the old leader
gen termldlln = termld*llngdppc
gen tenldlln = tenld*llngdppc
gen tenldtermld = tenld*termld
gen tenldtermldlln = tenldtermld*llngdppc
gen llead=l.leaderturn

reg pol2norm lpol2norm i.tenld##c.termld##c.llngdppc i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
*margins at median income if polity2<6, lninc = 7.2
margins,  at(lpol2norm==0 llngdppc=7.2 termld=5 tenld=(0(1)5)) at(lpol2norm==0 llngdppc=7.2 termld=10 tenld=(0(1)10)) at(lpol2norm==0  llngdppc=7.2 termld=20 tenld=(0(1)15))  at(lpol2norm==0 llngdppc=7.2 termld=30 tenld=(0(1)15)) 
marginsplot, recast(line) noci title("Figure 2: Selection effects: Predicted change in Polity2, non-democracies," "1875-2004, GDP per capita $5,000, starting from Polity2 = 0", size(medium))   ytitle("Change in Polity2, 0-1 scale") xtitle("Leader's current year in office") note("Source: See Table A18." ) legend(label(1 "leader will serve 5 years") label(2 "leader will serve 10 years") label(3 "leader will serve 20 years") label(4 "leader will serve 30 years"))
graph save Graph "C:\Democracy\AJPS\Revision Mar 2013\Figure 2.gph", replace

margins, dydx(llngdppc) at(lpol2norm==0 tenld=1 termld=(1(1)20))
marginsplot, recast(line) title("Figure 3: Selection effects: Marginal effect of Ln GDP per capita on Polity2" "in the leader's first year, by leader's total term, non-democracies, 1875-2004", size(medium))   ytitle("Change in Polity2, 0-1 scale") xtitle("Leader's total years in office") note("Source: See Table A15; calculated from estimates in Table ??." )
graph save Graph "C:\Democracy\AJPS\Revision Mar 2013\Figure 3.gph", replace

margins, dydx(llngdppc) at(lpol2norm==0 termld=5 tenld=(1(1)5))
marginsplot, recast(line) title("Figure A4.A: Change over time: Marginal effect of Ln GDP per capita on" "Polity2 for a leader who exited after 5 years, non-democracies, 1875-2004", size(medium))   ytitle("Change in Polity2, 0-1 scale") xtitle("Leader's current year in office") note("Source: See Table A18; 95% confidence intervals." ) 
graph save Graph "C:\Democracy\AJPS\Final files\Figure A4A.gph", replace

margins, dydx(llngdppc) at(lpol2norm==0 termld=8 tenld=(1(1)8))
marginsplot, recast(line) title("Figure A4B: Change over time: Marginal effect of Ln GDP per capita on" "Polity2 for a leader who exited after 8 years, non-democracies, 1875-2004", size(medium))   ytitle("Change in Polity2, 0-1 scale") xtitle("Leader's current year in office") note("Source: See Table A18; 95% confidence intervals." ) 
graph save Graph "C:\Democracy\AJPS\Final files\Figure A4B.gph", replace

margins, dydx(llngdppc) at(lpol2norm==0 termld=15 tenld=(1(1)15))
marginsplot, recast(line) title("Figure A4.C: Change over time: Marginal effect of Ln GDP per capita on" "Polity2 for a leader who exited after 15 years, non-democracies, 1875-2004", size(medium))   ytitle("Change in Polity2, 0-1 scale") xtitle("Leader's current year in office") note("Source: See Table A18; 95% confidence intervals." ) 
graph save Graph "C:\Democracy\AJPS\Final files\Figure A4C.gph", replace


*Education*

*Need to adjust vars to be sure that when, in a year of leaderturnover and polity2 change, the change in Polity2 came BEFORE*
*leader change, the education level refers to the leader at the start of the year (i.e. before the leader*
*change).*

gen coll= collegedegree
replace coll = l.coll if leaderturn==1&polity2~=l.polity2&ltfirst2==0
gen collln = coll*llngdppc

reg collegedegree i.tenld i.year i.ccode if polity2<6&year>1874&year<2005, rob cluster(ccode)
margins, at(tenld=(1(1)30))

*does more education increase the odds of democratization, conditional on income? 

reg pol2norm lpol2norm coll llngdppc collln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
nlcom(_b[coll]+_b[collln]*6.9)/(1-_b[lpol2norm])
nlcom(_b[coll]+_b[collln]*8.5)/(1-_b[lpol2norm])
nlcom(_b[coll]+_b[collln]*9.2)/(1-_b[lpol2norm])
predict res, resid
xtfisher res
drop res

*GDP per capita when leader was 20 (to pick up socialization)

sort leadid2 year
bysort leadid2: carryforward yrborn, replace
sort ccode year
replace yrborn = . if year>2004
xtset ccode year
gen yrborn2 = yrborn
replace yrborn2 = l.yrborn if pol2norm~=l.pol2norm&leaderturn==1&ltfirst2==0
gen yr20 = yrborn2+20
gen yrgap = year - yr20
gen gdpyoung = gdppc[_n-yrgap]/1000
gen lngdpyoung = ln(gdpyoung)

reg gdpyoung i.tenld i.year i.ccode llngdppc if polity2<6&year>1874&year<2005, rob cluster(ccode)
margins, at(tenld=(1(1)30))

gen lngdpyounglln =lngdpyoung*llngdppc

reg pol2norm lpol2norm lngdpyoung llngdppc lngdpyounglln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
nlcom(_b[lngdpyoung]+_b[lngdpyounglln]*6.9)/(1-_b[lpol2norm])
nlcom(_b[lngdpyoung]+_b[lngdpyounglln]*8.5)/(1-_b[lpol2norm])
nlcom(_b[lngdpyoung]+_b[lngdpyounglln]*9.2)/(1-_b[lpol2norm])
predict res, resid
xtfisher res
drop res



*REGIME TYPES
reg gwf_military i.tenld i.year i.ccode if polity2<6&year>1874&year<2005, rob cluster(ccode)
margins, at(tenld=(1(1)20))

gen lgwfmil = l.gwf_military
gen lgwfmisc = l.gwfmisc
gen lgwfparty = l.gwf_party
gen lgwfpers = l.gwf_personal

gen lgwfmillln = llngdppc*lgwfmil
gen lgwfmisclln = llngdppc*lgwfmisc
gen lgwfpartylln = llngdppc*lgwfparty
gen lgwfperslln = llngdppc*lgwfpers

reg pol2norm lpol2norm llngdppc lgwfmil lgwfmillln i.year i.ccode if l.polity2<6&year>1874&year<2005, rob cluster(ccode)
nlcom(_b[lgwfmil]+_b[lgwfmillln]*6.9)/(1-_b[lpol2norm])
nlcom(_b[lgwfmil]+_b[lgwfmillln]*8.5)/(1-_b[lpol2norm])
nlcom(_b[lgwfmil]+_b[lgwfmillln]*9.2)/(1-_b[lpol2norm])
predict res, resid
xtfisher res
drop res

*ARE NEW LEADERS MORE ACTIVIST?*

use "C:\Democracy\April 13 2011 Version\RussetOnealwork.dta", clear
by ccodeayear: egen tradesum = total(trade)
gen tradegdp = tradesum/gdpcountrya
collapse (mean) ccodea year tradegdp, by(ccodeayear)
drop if year>1992
gen cyear = ccodeayear
sort cyear
save "C:\Democracy\tradegdp.dta", replace
use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear
drop _merge
merge cyear using "C:\Democracy\tradegdp.dta", sort
save "C:\Democracy\AJPS\democworki.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc
gen lnantigov = ln(1+ banksagd)
gen tenld1 = year-year(ein2)
replace tenld1=. if ccode==245&year>1871
replace tenld1=. if ccode==564&year>1910
replace tenld1 = . if year>2004
gen ten1pol2 = tenld1*lpol2norm
xtset ccode year
bysort ccode: gen suminwaryrs = sum(inwar)
gen inwarrate = suminwaryrs/(year-sss)
replace inwarrate = . if year<sss

xtset ccode year
gen tenld = year - year(ein2)
replace tenld=. if ccode==245&year>1871
replace tenld=. if ccode==564&year>1910
replace tenld = . if year>2004
replace tenld = l.tenld if leaderturn==1&polity2~=l.polity2&ltfirst2==0
gen tenpol2 = tenld*lpol2norm
xtset ccode year
gen polupdummy = 0
replace polupdummy = 1 if pol2norm>l.pol2norm
replace polupdummy=. if pol2norm==.|l.pol2norm==.
gen poldowndummy = 0
replace poldowndummy = 1 if pol2norm<l.pol2norm
replace poldowndummy=. if pol2norm==.|l.pol2norm==.
gen pol2n6andup = 0
replace pol2n6andup = 1 if polity2>=6
replace pol2n6andup=. if polity2==.
gen lpol2n6andup = l.pol2n6andup
replace lpol2n6andup=. if ccode~=l.ccode
gen tenld1l6nup = lpol2n6andup*tenld1 

gen linmonth = month(eindate)
gen linday= day(eindate)
gen linyear = year(eindate)
gen ltbeforewar = 0
replace ltbeforewar=1 if inwar==1&leaderturn==1&linyear==wstartyear1&linmonth<wstartmonth1
replace ltbeforewar=1 if inwar==1&leaderturn==1&linyear==wstartyear1&linmonth==wstartmonth1&linday<wstartday1
replace ltbeforewar=. if leaderturn==.|inwar==.|ein2==.|wstartyear==.

gen tenldwar = tenld1 
replace tenldwar = l.tenld1+ 1 if inwar==1 & leaderturn==1&ltbeforewar==0
gen tenldwarl6nup = tenldwar*pol2n6andup
gen termldwar = year(eout2) - year(ein2)
replace termldwar = l.termld+ 1 if inwar==1 & leaderturn==1&ltbeforewar==0
gen agenew2 = agenew
replace agenew2 = l.agenew+1 if inwar==1&leaderturn==1&ltbeforewar==0
gen tenldl6nup = lpol2n6andup*tenld

replace banksconch=1 if banksconch>1&banksconch<.
label var banksconch "At least one major change of constitution"
gen termld = year(eout2) - year(ein2)
replace termld = l.termld if leaderturn==1&polity2~=l.polity2&ltfirst2==0
gen agenew1 = agenew
replace agenew1 = l.agenew+1 if pol2norm~=l.pol2norm&leaderturn==1&ltfirst2==0


xtlogit polupdummy      c.tenld##i.lpol2n6andup agenew1 llngdppc oneyrgrowth l.lnantigov i.year if l.polity2<10&year>1874&year<2005, fe
xtlogit poldowndummy c.tenld##i.lpol2n6andup agenew1 llngdppc oneyrgrowth l.lnantigov i.year if l.polity2>-10&year>1874&year<2005, fe
xtlogit banksconch        c.tenld1##i.lpol2n6andup agenew llngdppc oneyrgrowth l.lnantigov i.year if year>1874&year<2005, fe
xtlogit mid                       c.tenld1##i.lpol2n6andup agenew2 llngdppc oneyrgrowth l.lnantigov l.pastmidfreq l.cinc l.tradegdp militaryregime  i.year if year>1874&year<2005,  fe


*linear probability models, continuous and with tenure broken down into year effects

reg polupdummy      c.tenld##i.lpol2n6andup agenew1 llngdppc oneyrgrowth l.lnantigov i.year i.ccode if l.polity2<10&year>1874&year<2005, robust cluster(ccode)
predict res, resid
xtfisher res
drop res

reg poldowndummy c.tenld##i.lpol2n6andup agenew1 llngdppc oneyrgrowth l.lnantigov i.year i.ccode if l.polity2>-10&year>1874&year<2005, robust cluster(ccode)
predict res, resid
xtfisher res
drop res

reg banksconch c.tenld1##i.lpol2n6andup agenew llngdppc oneyrgrowth l.lnantigov i.year i.ccode if year>1874&year<2005, robust cluster(ccode)
predict res, resid
xtfisher res
drop res

reg mid c.tenld1##i.lpol2n6andup agenew2 llngdppc oneyrgrowth l.lnantigov l.pastmidfreq l.cinc l.tradegdp militaryregime i.year i.ccode if year>1874&year<2005, rob cluster(ccode)
predict res, resid
xtfisher res
drop res
