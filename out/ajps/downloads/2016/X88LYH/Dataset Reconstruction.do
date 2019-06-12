** Run a Find and Replace: Find ~ and replace with the folder location where you have saved all relevant replication files - add / after folder location 
** Be sure to have saved all work; do-file starts with clear command

** Be sure to save the following files individually in original file formats (not .tab):
** Base.dta
** egroupsrepdata.dta
** es_data-v2_0_1.csv
** EUGene original dataset.xlsx
** ineq_data.dta
** NMC_v4_0.csv
** Replication Dataset.dta

** Base Dataset
** Provides our original triad-year structure (irredentist/group/host/year) 
** Provides unique identification code for each observation (obcode). 
** Triadcode identifies each unique triad
** Irredentism identifies each unique act of irredentism; see Coding Irredentism.xls
** Specifies peace years, peace years squared, and peace years cubed
** Provides unique observation IDs enabling merges with each dataset detailed below

** See Data Source Information.pdf for full bibliographic information on all data sources.


** Bormann and Golder 2013. “Democratic Electoral Systems Around the World.” Version 2_0; Downloaded June 2015.
** Instructions for merging our Base.dta file with Borman and Golder
** Merged on unique identifier elec_id
** Each year in our base dataset is coded as the next forthcoming election 
** For years exceeding last coded election, used most recent election observation
** Resaves Base.dta as Replication Data.dta 
clear
insheet using "~es_data-v2_0_1.csv"
gen legislative_type_n = real(legislative_type)
drop legislative_type
rename legislative_type_n legislative_type
keep elec_id legislative_type
sort elec_id
save "~Bormann and Golder.dta", replace
use "~Base.dta"
sort elec_id
merge m:1 elec_id using "~Bormann and Golder.dta"
tab _merge
drop if _merge == 2
** Variable Creation; code for creating of our variables from Bormann and Golder data
gen irrMajoritarianALL = 1 if legislative_type == 1 | legislative_type == 3
replace irrMajoritarianALL = 0 if irrMajoritarianALL == .
gen irrMajoritarian2 = 1 if legislative_type == 1
replace irrMajoritarian2 = 0 if irrMajoritarian2 == .
save "~Replication Dataset.dta", replace


** Cederman et al. 2011. “Horizontal Inequalities and Ethnonationalist Civil War: A Global Comparison.” Downloaded October 2014.
** Instructions for merging our Replication Dataset.dta with Cederman et al. 
** Merged on created unique identifier cowgroupidyear 
use "~ineq_data.dta"
gen str20 cowgroupidyear = string(cowgroupid, "%20.0f") + string(year)
keep cowgroupidyear dispersed discrim high low anocl democl
sort cowgroupidyear
save "~Cederman et al.dta", replace
** Cederman et al. (Irredentist); merge irredentist/group specific data
use "~Replication Dataset.dta"
drop _merge
gen str20 cowgroupidyear = string(irrcowgroupid, "%20.0f") + string(year)
sort cowgroupidyear
merge m:1 cowgroupidyear using "~Cederman et al.dta"
tab _merge
drop if _merge == 2
*** Variable Creation; code for creation of irredentist/group-specific variables from Cederman et al. data
rename anocl irranocl
rename democl irrdemocl
rename high irrhigh
rename low irrlow
drop dispersed discrim
rename cowgroupidyear irrcowgroupidyear
save "~Replication Dataset.dta", replace
** Cederman et al. (Host); merge host/group specific data
use "~Replication Dataset.dta"
drop _merge
gen str20 cowgroupidyear = string(hostcowgroupid, "%20.0f") + string(year)
sort cowgroupidyear
merge m:1 cowgroupidyear using "~Cederman et al.dta"
tab _merge
drop if _merge == 2
*** Variable Creation; code for creation of host/group-specific variables from Cederman et al. data
rename dispersed hostdispersed
rename discrim hostdiscrim
rename anocl hostanocl
rename democl hostdemocl
rename high hosthigh
rename low hostlow
rename cowgroupidyear hostcowgroupidyear
save "~Replication Dataset.dta", replace


** Fearon, 2003. “Ethnic and Cultural Diversity by Country.” Zipped Stata 7.0 Dataset. Downloaded October 2014
** Instructions for merging our Replication Dataset.dta with Fearon
** Merged on created unique identifier ccodegroup
use "~egroupsrepdata.dta"
gen ccodegroup = string(ccode) + group
keep ccodegroup gpro second ef plural cdiv numgrps
sort ccodegroup
save "~Fearon.dta", replace
** Fearon (Irredentist); merge irredentist/group-specific data
use "~Replication Dataset.dta"
drop _merge
gen ccodegroup = string(irrccode) + FearonGroupIrr
sort ccodegroup
merge m:1 ccodegroup using "~Fearon.dta"
tab _merge
drop if _merge == 2
*** Variable Creation; coding for creation of irredentist/group-specific variables, other variables, from Fearon data
rename gpro irrgpro
rename ef irref
rename plural irrplural
rename second irrsecond
rename cdiv irrcdiv
rename numgrps irrnumgrps
gen irrmargin = irrgpro - irrsecond
gen irrmarginXirrMajoritarianALL = irrmargin * irrMajoritarianALL
gen irrmargin_hostdispersed = irrmargin * hostdispersed 
gen irrmarginXirrMajoritarian2 = irrmargin * irrMajoritarian2
gen irrmarginsquared = irrmargin ^ 2
gen irrgprosquared = irrgpro ^ 2
gen irrefXirrMajoritarianALL = irref * irrMajoritarianALL
gen irrgproXirrMajoritarianALL = irrgpro * irrMajoritarianALL
gen irrpluralXirrMajoritarianALL = irrplural * irrMajoritarianALL
gen irrcdivXirrMajoritarianALL = irrcdiv * irrMajoritarianALL
gen irrnumgrpsXirrMajoritarianALL = irrnumgrps * irrMajoritarianALL
rename ccodegroup irrccodegroup
save "~Replication Dataset.dta", replace
*** Fearon (Host); merge host/group-specific data
use "~Replication Dataset.dta"
drop _merge
gen ccodegroup = string(hostccode) + FearonGroupHost
sort ccodegroup
merge m:1 ccodegroup using "~Fearon.dta"
tab _merge
drop if _merge == 2
** Variable Creation; coding for creation of host/group specific variables from Fearon data
rename gpro hostgpro
rename ef hostef
rename plural hostplural
rename second hostsecond
rename cdiv hostcdiv
rename numgrps hostnumgrps
rename ccodegroup hostccodegroup
save "~Replication Dataset.dta", replace


** Gleditsch 2002. “Expanded Trade and GDP data.”  Version 6.0 Beta. Downloaded October 2014
** Instructions for merging our Replication Dataset.dta with Gleditsch
** Merged on created unique identifier stateidyear
clear
insheet using "~gdpv6.txt"
gen stateidyear = string(statenum) + string(year)
keep stateidyear rgdppc
sort stateidyear
save "~Gleditsch.dta", replace
*** Gleditsch (Irredentist); merge irredentist-specific data
use "~Replication Dataset.dta"
drop _merge
gen stateidyear = string(irrstatenum) + string(year)
sort stateidyear
merge m:1 stateidyear using "~Gleditsch.dta"
tab _merge
drop if _merge == 2
rename stateidyear irrstateidyear
** Variable Creation; coding for creation of irredentist-specific variables from Gleditsch
rename rgdppc irrrgdppc
save "~Replication Dataset.dta", replace
*** Gleditsch (Host); merge host-specific data 
use "~Replication Dataset.dta"
drop _merge
gen stateidyear = string(hoststatenum) + string(year)
sort stateidyear
merge m:1 stateidyear using "~Gleditsch.dta"
tab _merge
drop if _merge == 2
rename stateidyear hoststateidyear
** Variable Creation; coding for creation of host-specific variables, other variables, from Gleditsch
rename rgdppc hostrgdppc
gen countryGDPRATIO = hostrgdppc / irrrgdppc
gen hostgroupGDP = hostrgdppc * (1/hostlow)
replace hostgroupGDP = hostrgdppc * hosthigh if hostgroupGDP == .
gen irrgroupGDP = irrrgdppc * (1/irrlow)
replace irrgroupGDP = irrrgdppc * irrhigh if irrgroupGDP == .
gen groupGDPRATIO = hostgroupGDP/irrgroupGDP
save "~Replication Dataset.dta", replace


** Marshall et al. 2014. “Polity IV Project: Dataset Users’ Manual.” p4v2013. Downloaded November 2014 
** Instructions for merging our Replication Dataset.dta with Marshall et al.
** Merged on cyear
import excel "~p4v2013.xls", sheet("p4v2013") firstrow clear
keep cyear polity2
sort cyear
save "~Marshall et al.dta", replace
** Marshall (Irredentist); merge irredentist-specific data
use "~Replication Dataset.dta"
drop _merge
rename irrPolityIVcyear cyear
sort cyear
merge m:1 cyear using "~Marshall et al.dta"
tab _merge
drop if _merge == 2
rename cyear irrPolityIVcyear
**Variable Construction; coding for creation of irredentist-specific variables
rename polity2 irrpolity2
save "~Replication Dataset.dta", replace
** Marshall (Host); merge host-specific data
use "~Replication Dataset.dta"
drop _merge
rename hostPolityIVcyear cyear
sort cyear
merge m:1 cyear using "~Marshall et al.dta"
tab _merge
drop if _merge == 2
rename cyear hostPolityIVcyear
**Variable Construction; instructions for creation of irredentist-specific variables
** Instructions for coding post 2005 democl/anocl measures from Cederman et al. based on Polity IV values; countries not covered by Cederman et al.
rename polity2 hostpolity2
gen nocedermanregime = 1 if irredentist == "Germany" | irredentist == "Andorra" | irredentist == "Ireland" | irredentist == "Italy" | irredentist == "Libya" | irredentist == "Morocco" | irredentist == "North Korea" | irredentist == "Somalia" | irredentist == "Sweden"
replace irrdemocl = 1 if irrpolity2 >=8 & irrpolity2 <= 10 & irrdemocl == . & year >= 2006 
replace irrdemocl = 0 if irrpolity2 >=1 & irrpolity2 <= 7 & irrdemocl == . & year >= 2006 
replace irrdemocl = 0 if irrpolity2 >=-10 & irrpolity2 <= 0 & irrdemocl == . & year >= 2006 
replace irranocl = 0 if irrpolity2 >=8 & irrpolity2 <= 10 & irranocl == . & year >= 2006 
replace irranocl = 1 if irrpolity2 >=1 & irrpolity2 <= 7 & irranocl == . & year >= 2006 
replace irranocl = 0 if irrpolity2 >=-10 & irrpolity2 <= 0 & irranocl == . & year >= 2006 
replace hostdemocl = 1 if hostpolity2 >=8 & hostpolity2 <= 10 & hostdemocl == . & year >= 2006 replace hostdemocl = 0 if hostpolity2 >=1 & hostpolity2 <= 7 & hostdemocl == . & year >= 2006 replace hostdemocl = 0 if hostpolity2 >=-10 & hostpolity2 <= 0 & hostdemocl == . & year >= 2006 replace hostanocl = 0 if hostpolity2 >=8 & hostpolity2 <= 10 & hostanocl == . & year >= 2006 replace hostanocl = 1 if hostpolity2 >=1 & hostpolity2 <= 7 & hostanocl == . & year >= 2006 replace hostanocl = 0 if hostpolity2 >=-10 & hostpolity2 <= 0 & hostanocl == . & year >= 2006 
replace irrdemocl = 1 if irrpolity2 >=8 & irrpolity2 <= 10 & irrdemocl == . & nocedermanregime == 1 
replace irrdemocl = 0 if irrpolity2 >=1 & irrpolity2 <= 7 & irrdemocl == . & nocedermanregime == 1
replace irrdemocl = 0 if irrpolity2 >=-10 & irrpolity2 <= 0 & irrdemocl == . & nocedermanregime == 1
replace irranocl = 0 if irrpolity2 >=8 & irrpolity2 <= 10 & irranocl == . & nocedermanregime == 1
replace irranocl = 1 if irrpolity2 >=1 & irrpolity2 <= 7 & irranocl == . & nocedermanregime == 1
replace irranocl = 0 if irrpolity2 >=-10 & irrpolity2 <= 0 & irranocl == . & nocedermanregime == 1
replace hostdemocl = 1 if hostpolity2 >=8 & hostpolity2 <= 10 & hostdemocl == . & nocedermanregime == 1replace hostdemocl = 0 if hostpolity2 >=1 & hostpolity2 <= 7 & hostdemocl == . & nocedermanregime == 1replace hostdemocl = 0 if hostpolity2 >=-10 & hostpolity2 <= 0 & hostdemocl == . & nocedermanregime == 1replace hostanocl = 0 if hostpolity2 >=8 & hostpolity2 <= 10 & hostanocl == . & nocedermanregime == 1replace hostanocl = 1 if hostpolity2 >=1 & hostpolity2 <= 7 & hostanocl == . & nocedermanregime == 1replace hostanocl = 0 if hostpolity2 >=-10 & hostpolity2 <= 0 & hostanocl == . & nocedermanregime == 1
gen irrautocl = 1 if irrdemocl == 0 & irranocl == 0
replace irrautocl = 0 if irrdemocl == 1 | irranocl == 1
gen hostautocl = 1 if hostdemocl == 0 & hostanocl == 0
replace hostautocl = 0 if hostdemocl == 1 | hostanocl == 1
*** Instructions for coding categorical dyadic anocracy measures
gen anoano = 1 if hostanocl == 1 & irranocl == 1
gen anono = 0 if hostanocl == 1 & irranocl == 1
gen noano = 0 if hostanocl == 1 & irranocl == 1
gen nono = 0 if hostanocl == 1 & irranocl == 1
replace anoano = 0 if hostanocl == 1 & irranocl == 0
replace anono = 1 if hostanocl == 1 & irranocl == 0
replace noano = 0 if hostanocl == 1 & irranocl == 0
replace nono = 0 if hostanocl == 1 & irranocl == 0
replace anoano = 0 if hostanocl == 0 & irranocl == 1
replace anono = 0 if hostanocl == 0 & irranocl == 1
replace noano = 1 if hostanocl == 0 & irranocl == 1
replace nono = 0 if hostanocl == 0 & irranocl == 1
replace anoano = 0 if hostanocl == 0 & irranocl == 0
replace anono = 0 if hostanocl == 0 & irranocl == 0
replace noano = 0 if hostanocl == 0 & irranocl == 0
replace nono = 1 if hostanocl == 0 & irranocl == 0
save "~Replication Dataset.dta", replace


** Singer et al. 1972. “Capability Distribution, Uncertainty, and Major Power War, 1820-1965.”NMC_v4. Downloaded November 2014
**** Instructions for merging our Replication Dataset.dta with Singer et al.
** Merged on ccodeyear 
clear
insheet using "~NMC_v4_0.csv"
gen ccodeyear = string(ccode) + string(year)
keep ccodeyear cinc tpop
sort ccodeyear
save "~Singer.dta", replace
** Singer (Irredentist); merge irredentist-specific variables
use "~Replication Dataset.dta"
drop _merge
gen ccodeyear = string(SingerccodeIrr) + string(year)
sort ccodeyear
merge m:1 ccodeyear using "~Singer.dta"
tab _merge
drop if _merge == 2
rename ccodeyear irrccodeyear
**Variable Construction; coding for creating irredentist-specific variables
rename tpop irrtpop
rename cinc irrcinc
save "~Replication Dataset.dta", replace
** Marshall (Host); merge host-specific variables
use "~Replication Dataset.dta"
drop _merge
gen ccodeyear = string(hostccode) + string(year)
sort ccodeyear
merge m:1 ccodeyear using "~Singer.dta"
tab _merge
drop if _merge == 2
rename ccodeyear hostccodeyear
**Variable Construction; coding for creating host-specific variables, other variables
rename tpop hosttpop
rename cinc hostcinc
gen powerdisparity = hostcinc/irrcinc
gen logpowerdisparity = log(powerdisparity)
save "~Replication Dataset.dta", replace
gen originalobv = 1 if irrmargin != . & irrMajoritarianALL != . & irrmarginXirrMajoritarianALL != . &  hostdispersed != . & irrhigh != . & irrlow != . & hostdiscrim != . & countryGDPRATIO != . & anoano != . & anono != . & noano != . & hosttpop != . & irrtpop != . & logpowerdisparity != .
save "~Replication Dataset.dta", replace


****Bennett and Stam 2000a. “EUGene” – Version 3.204; Downloaded January 2016
** Download EUGENE copyrighted freeware on PC (does not function on mac): 
*http://eugenesoftware.org/download.asp
*Unit of analysis is directed-dyad-year
* Download variables ccode ccode2 year eqSacqa eqSacqb eqSnego eqSwara eqSsq
** Merged on created ddyear 
clear
import excel "~EUGene original dataset.xlsx", sheet("temp2") firstrow
gen str20 ddyear = string(ccode1) + "_" + string(ccode2) + "_" + string(year)
keep ddyear eqSacqa eqSacqb eqSnego eqSwara eqSsq
sort ddyear
save "~EUGene original dataset.dta", replace
use "~Replication Dataset.dta"
drop _merge
gen str20 ddyear = string(ccode1) + "_" + string(ccode2) + "_" + string(year)
sort ddyear
merge m:1 ddyear using "~EUGene original dataset.dta"
tab _merge
drop if _merge == 2
save "~Replication Dataset.dta", replace


*** Missing Variable Values
*** Fill in hostdispersed; irrhigh/irrlow missing 2005 data allowing 2006 - 2014 to fill-in with automated procedure
** Values are modes of values previously in triad
tsset triadcode year
replace hostdispersed = 0 if triadcode ==15 & year == 2006
replace hostdispersed = 0 if triadcode == 45 & year == 2006
replace hostdispersed = 1 if triadcode == 94 & year == 2006
replace hostdispersed = 0 if triadcode == 102 & year == 2006
replace irrhigh = 0 if triadcode == 45 & year == 2006
replace irrlow = 1.00595 if triadcode == 45 & year == 2006
replace hostdiscrim = 0 if triadcode ==15 & year == 2006
replace hostdiscrim = 0 if triadcode == 45 & year == 2006
replace hostdiscrim = 1 if triadcode == 94 & year == 2006
replace hostdiscrim = 1 if triadcode == 102 & year == 2006
** Fill forward missing data years
** Automated procedure for filling in missing Cederman et al. values
*** Fill in missing values with modal value; post 2005 values with most recent value
egen modehostdispersed = mode(hostdispersed), by(triadcode)
egen modehostdiscrim = mode(hostdiscrim), by(triadcode)
egen modeirrhigh = mode(irrhigh), by(triadcode)
egen modeirrlow = mode(irrlow), by(triadcode)
egen modehosthigh = mode(hosthigh), by(triadcode)
egen modehostlow = mode(hostlow), by(triadcode)
replace hostdispersed = modehostdispersed if hostdispersed == . & year <= 2005
replace hostdiscrim = modehostdiscrim if hostdiscrim == . & year <= 2005
replace irrhigh = modeirrhigh if irrhigh == . & year <= 2005
replace irrlow = modeirrlow if irrlow == . & year <= 2005
replace hosthigh = modehosthigh if hosthigh == . & year <= 2005
replace hostlow = modehostlow if hostlow == . & year <= 2005
replace hostdispersed = L.hostdispersed if hostdispersed >=. & year >= 2006
replace hostdiscrim = L.hostdiscrim if hostdiscrim >=. & year >= 2006
replace irrhigh = L.irrhigh if irrhigh >=. & year >= 2006
replace irrlow = L.irrlow if irrlow >=. & year >= 2006
replace hosthigh = L.hosthigh if hosthigh >=. & year >= 2006
replace hostlow = L.hostlow if hostlow >=. & year >= 2006
** Automated procedure for filling in missing Gleditsch values
** Fill in missing post 2012 values with most recent value
replace irrrgdppc = L.irrrgdppc if irrrgdppc >=. & year >= 2012
replace hostrgdppc = L.hostrgdppc if hostrgdppc >=. & year >= 2012
** Automated procedure for filling in missing Singer et al. through interpolation of 1991-2007 values
bysort triadcode: ipolate irrtpop year if year >= 1991, gen(irrtpop2) epolate
replace irrtpop = irrtpop2 if year >= 2008
replace irrtpop = irrtpop2 if irrtpop >= . & year <= 1992 & year <= 1991
bysort triadcode: ipolate hosttpop year if year >= 1991, gen(hosttpop2) epolate
replace hosttpop = hosttpop2 if year >= 2008
bysort triadcode: ipolate irrcinc year if year >= 1991, gen(irrcinc2) epolate
replace irrcinc = irrcinc2 if year >= 2008
replace irrcinc = irrcinc2 if irrcinc >= . & year <= 1992 & year <= 1991
bysort triadcode: ipolate hostcinc year if year >= 1991, gen(hostcinc2) epolate
replace hostcinc = hostcinc2 if year >= 2008
** Automated procedure for filling in missing 2014
** Fill in regime for 2014 with 2013 value
replace irrdemocl = L.irrdemocl if irrdemocl >= . & year >= 2014
replace irranocl = L.irranocl if irranocl >= . & year >= 2014
replace irrautocl = L.irrautocl if irrautocl >= . & year >= 2014
replace hostdemocl = L.hostdemocl if hostdemocl >= . & year >= 2014
replace hostanocl = L.hostanocl if hostanocl >= . & year >= 2014
replace hostautocl = L.hostautocl if hostautocl >= . & year >= 2014
replace anoano = L.anoano if anoano >= . & year >= 2014
replace anono = L.anono if anono >= . & year >= 2014
replace noano = L.noano if noano >= . & year >= 2014
replace nono = L.nono if nono >= . & year >= 2014
sort obcode
** recreate variables to reflect updated observations
replace countryGDPRATIO = hostrgdppc / irrrgdppc
replace hostgroupGDP = hostrgdppc * (1/hostlow)
replace powerdisparity = hostcinc/irrcinc
replace logpowerdisparity = log(powerdisparity)
*** Fill backwards missing years
** Fill in gdp and regime data for pre-1950 observations; missing 1991 and 1992 observations 
gen yearbackward = 0 - year
tsset triadcode yearbackward
replace countryGDPRATIO = L.countryGDPRATIO if countryGDPRATIO >=. & yearbackward >= -1950
replace irrdemocl = L.irrdemocl if irrdemocl >=. & yearbackward >= -1950
replace irranocl = L.irranocl if irranocl >=. & yearbackward >= -1950
replace hostdemocl = L.hostdemocl if hostdemocl >= . & yearbackward >= -1950
replace hostanocl = L.hostanocl if hostanocl >=. & yearbackward >= -1950
replace irrdemocl = L.irrdemocl if irrdemocl >=. & yearbackward >= -1992 & yearbackward <= -1991
replace irranocl = L.irranocl if irranocl >=. & yearbackward >= -1992 & yearbackward <= -1991
replace hostdemocl = L.hostdemocl if hostdemocl >= . & yearbackward >= -1992 & yearbackward <= -1991
replace hostanocl = L.hostanocl if hostanocl >=. & yearbackward >= -1992 & yearbackward <= -1991
* recreate variables to reflect updated observations
replace anoano = 1 if hostanocl == 1 & irranocl == 1
replace anono = 0 if hostanocl == 1 & irranocl == 1
replace noano = 0 if hostanocl == 1 & irranocl == 1
replace nono = 0 if hostanocl == 1 & irranocl == 1
replace anoano = 0 if hostanocl == 1 & irranocl == 0
replace anono = 1 if hostanocl == 1 & irranocl == 0
replace noano = 0 if hostanocl == 1 & irranocl == 0
replace nono = 0 if hostanocl == 1 & irranocl == 0
replace anoano = 0 if hostanocl == 0 & irranocl == 1
replace anono = 0 if hostanocl == 0 & irranocl == 1
replace noano = 1 if hostanocl == 0 & irranocl == 1
replace nono = 0 if hostanocl == 0 & irranocl == 1
replace anoano = 0 if hostanocl == 0 & irranocl == 0
replace anono = 0 if hostanocl == 0 & irranocl == 0
replace noano = 0 if hostanocl == 0 & irranocl == 0
replace nono = 1 if hostanocl == 0 & irranocl == 0
tsset triadcode year
sort obcode
** For triads with missing observations
replace countryGDPRATIO = 1.467 if triadcode == 2 & year >= 2007
replace countryGDPRATIO = .575 if triadcode == 27 & year >= 2007
replace countryGDPRATIO = .547 if triadcode == 47 & year >= 2007
replace countryGDPRATIO = .733 if triadcode == 97 & year >= 2007
replace countryGDPRATIO = 1.74 if triadcode == 98 & year >= 2007
replace countryGDPRATIO = .852 if triadcode == 99 & year >= 2007
replace countryGDPRATIO = 2.511 if triadcode == 100 & year >= 2007
** Missing gpro Fearon Fill-IN (irredentist/groups not covered by Fearon)
** See See Data Source Information.pdf for further information
replace irrgpro = .29 if irredentist == "Andorra"
replace irrsecond = .29 if irredentist == "Andorra"
replace irrmargin = irrgpro-irrsecond
replace irrmarginXirrMajoritarianALL = irrmargin * irrMajoritarianALL
replace irrgpro = .475 if irredentist == "Ghana"
replace irrsecond = .166 if irredentist == "Ghana"
replace irrmargin = irrgpro-irrsecond
replace irrmarginXirrMajoritarianALL = irrmargin * irrMajoritarianALL
replace irrgpro = .999 if irredentist == "North Korea"
replace irrsecond = .001 if irredentist == "North Korea"
replace irrmargin = irrgpro-irrsecond
replace irrmarginXirrMajoritarianALL = irrmargin * irrMajoritarianALL
replace irrgpro = .91 if irredentist == "Somalia"
replace irrsecond = .07 if irredentist == "Somalia"
replace irrmargin = irrgpro-irrsecond
replace irrmarginXirrMajoritarianALL = irrmargin * irrMajoritarianALL
replace irrgpro = .78 if irredentist == "Iraq"
replace irrsecond = .19 if irredentist == "Iraq"
replace irrmargin = irrgpro-irrsecond
replace irrmarginXirrMajoritarianALL = irrmargin * irrMajoritarianALL
replace irrmarginXirrMajoritarian2 = irrmargin * irrMajoritarian2
** Missing group proportion information for groups not covered by Fearon
** See Data Source Information.pdf for further information
replace hostgpro = 0.01 if host == "Belgium" & group == "Germans"
replace hostgpro = 0.001 if host == "China" & group == "Kazakhs"
replace hostgpro = .0001 if host == "China" & group == "Kirgiz"
replace hostgpro = .001 if host == "China" & group == "Koreans"
replace hostgpro = .004 if host == "China" & group == "Mongolians"
replace hostgpro = .00001 if host == "China" & group == "Russians"
replace hostgpro = .00003 if host == "China" & group == "Tajiks"
replace hostgpro = 8.000e-06 if host == "China" & group == "Uzbeks"
replace hostgpro = .0004 if host == "Croatia" & group == "Italians"
replace hostgpro = .003 if host == "France" & group == "Corsicans"
replace hostgpro = .0175 if host == "Georgia" & group == "Russians (and Russian speakers in Abkhazia)"
replace hostgpro = .032 if host == "Georgia" & group == "Russians (and Russian speakers in Ossetia)"
replace hostgpro = .002 if host == "Iran" & group == "Armenians"
replace hostgpro = .02 if host == "Pakistan" & group == "Hindus"
replace hostgpro = .006 if host == "Poland" & group == "Byelorussians"
replace hostgpro = .006 if host == "Poland" & group == "Ukrainians"
replace hostgpro = .002 if host == "Russia" & group == "Azerbaijanis"
replace hostgpro = .0006 if host == "Russia" & group == "Finns"
replace hostgpro = .0057 if host == "Russia" & group == "Germans"
replace hostgpro = .0006 if host == "Russia" & group == "Karelians"
replace hostgpro = .0006 if host == "Russia" & group == "Turks (Circassians)"
replace hostgpro = .0175 if host == "Slovenia" & group == "Italians"
replace hostgpro = .003 if host == "Ukraine" & group == "Hungarians"
replace hostgpro = .005 if host == "Ukraine" & group == "Russians (and Russian speakers in Crimea)"
replace hostgpro = .1 if host == "Ukraine" & group == "Russians (and Russian speakers in NovoRossiya—Donbas and Dn)"
replace hostgpro = .165 if host == "Yugoslavia" & group == "Albanians"
* recreate variables to reflect updated observations
replace irrmargin = irrgpro - irrsecond
replace irrmarginXirrMajoritarianALL = irrmargin * irrMajoritarianALL
replace irrmargin_hostdispersed = irrmargin * hostdispersed 
replace irrmarginXirrMajoritarian2 = irrmargin * irrMajoritarian2
replace irrmarginsquared = irrmargin ^ 2
replace irrgprosquared = irrgpro ^ 2
replace irrefXirrMajoritarianALL = irref * irrMajoritarianALL
replace irrgproXirrMajoritarianALL = irrgpro * irrMajoritarianALL
replace irrpluralXirrMajoritarianALL = irrplural * irrMajoritarianALL
replace irrcdivXirrMajoritarianALL = irrcdiv * irrMajoritarianALL
replace irrnumgrpsXirrMajoritarianALL = irrnumgrps * irrMajoritarianALL
** Manual Coding Fearon Country-Specific Variables
** For host states whose information is provided in Fearon, but without a group to merge with
** Enter these values manually from Fearon
replace hostef = .567 if host == "Belgium" 
replace hostef = .1536 if host == "China" 
replace hostef = .375155 if host == "Croatia" 
replace hostef = .272074 if host == "France" 
replace hostef = .4901258 if host == "Georgia" 
replace hostef = .6688 if host == "Iran" 
replace hostef = .5321 if host == "Pakistan" 
replace hostef = .047255 if host == "Poland" 
replace hostef = .332998 if host == "Russia" 
replace hostef = .231123 if host == "Slovenia" 
replace hostef = .4186 if host == "Ukraine" 
replace hostef = .5747164 if host == "Yugoslavia"
replace hostplural = .58 if host == "Belgium" 
replace hostplural = .92 if host == "China" 
replace hostplural = .781 if host == "Croatia" 
replace hostplural = .85 if host == "France" 
replace hostplural = .701 if host == "Georgia" 
replace hostplural = .51 if host == "Iran" 
replace hostplural = .66 if host == "Pakistan" 
replace hostplural = .976 if host == "Poland" 
replace hostplural = .815 if host == "Russia" 
replace hostplural = .876 if host == "Slovenia" 
replace hostplural = .73 if host == "Ukraine" 
replace hostplural = .626 if host == "Yugoslavia"
replace hostcdiv = .4617581 if host == "Belgium" 
replace hostcdiv = .1536 if host == "China" 
replace hostcdiv = .184591 if host == "Croatia" 
replace hostcdiv = .250566 if host == "France" 
replace hostcdiv = .4037951 if host == "Georgia" 
replace hostcdiv = .5416988 if host == "Iran" 
replace hostcdiv = .2894967 if host == "Pakistan" 
replace hostcdiv = .0407029 if host == "Poland" 
replace hostcdiv = .3107963 if host == "Russia" 
replace hostcdiv = .1695916 if host == "Slovenia" 
replace hostcdiv = .2583873 if host == "Ukraine" 
replace hostcdiv = .3923852 if host == "Yugoslavia"
replace hostnumgrps = 4 if host == "Belgium" 
replace hostnumgrps = 1 if host == "China" 
replace hostnumgrps = 2 if host == "Croatia" 
replace hostnumgrps = 3 if host == "France" 
replace hostnumgrps = 7 if host == "Georgia" 
replace hostnumgrps = 9 if host == "Iran" 
replace hostnumgrps = 5 if host == "Pakistan" 
replace hostnumgrps = 2 if host == "Poland" 
replace hostnumgrps = 5 if host == "Russia" 
replace hostnumgrps = 4 if host == "Slovenia" 
replace hostnumgrps = 3 if host == "Ukraine" 
replace hostnumgrps = 7 if host == "Yugoslavia"
** Recreate variables to reflect updated observations
replace hostgroupGDP = hostrgdppc * (1/hostlow)
replace hostgroupGDP = hostrgdppc * hosthigh if hostgroupGDP == .
replace irrgroupGDP = irrrgdppc * (1/irrlow)
replace irrgroupGDP = irrrgdppc * irrhigh if irrgroupGDP == .
replace groupGDPRATIO = hostgroupGDP/irrgroupGDP


*** Construction of Regional Controls
gen WEuropeAM = 0
gen EEurope = 0
gen CenAsiaNAfrica = 0
gen Asia = 0
gen SubSahAfrica = 0
** Western Europe/Americasreplace WEuropeAM = 1 if irredentist == "Andorra" | irredentist == "Finland" | irredentist == "France" | irredentist == "Germany" | irredentist == "Greece" | irredentist == "Ireland" | irredentist == "Italy" | irredentist == "Netherlands" | irredentist == "Poland" | irredentist == "Sweden" | irredentist == "Mexico"** Eastern Europe replace EEurope = 1 if irredentist == "Albania" | irredentist ==  "Armenia" | irredentist ==  "Azerbaijan" | irredentist ==  "Belarus" | irredentist ==  "Croatia" | irredentist ==  "Hungary" | irredentist ==  "Russia" | irredentist ==  "Serbia" | irredentist ==  "Slovenia" | irredentist ==  "Turkey" | irredentist ==  "Ukraine"** Central Asia/Middle East/North Africareplace CenAsiaNAfrica = 1 if irredentist == "Kazakhstan" | irredentist ==  "Kyrgyzstan" | irredentist ==  "Mongolia" | irredentist ==  "Pakistan" | irredentist ==  "Tajikistan" | irredentist ==  "Turkmenistan" | irredentist ==  "Uzbekistan" | irredentist ==  "Iraq" | irredentist ==  "Egypt" | irredentist ==  "Morocco" | irredentist ==  "Sudan" | irredentist ==  "Libya"** Asiareplace Asia = 1 if irredentist == "Bangladesh" | irredentist ==  "Cambodia" | irredentist ==  "China" | irredentist ==  "India" | irredentist ==  "Malaysia" | irredentist ==  "North Korea"** SubSaharan Africareplace SubSahAfrica = 1 if irredentist == "Benin" | irredentist ==  "CAR" | irredentist ==  "Burundi" | irredentist ==  "Congo" | irredentist ==  "Cote d'Ivoire" | irredentist ==  "Eritrea" | irredentist ==  "Ghana" | irredentist ==  "Guinea" | irredentist ==  "Mali" | irredentist ==  "Niger" | irredentist ==  "Nigeria" | irredentist ==  "Rwanda" | irredentist ==  "Somalia" | irredentist ==  "Togo"
save "~Replication Dataset.dta", replace

** Make final data presentable
keep irredentist group host year triadcode obcode irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed hostgpro hostef hostplural hostcdiv hostnumgrps hostdemocl irrgpro irref irrplural irrcdiv irrnumgrps irranocl irrdemocl groupGDPRATIO hostautocl irrmarginsquared nono irrautocl WEuropeAM EEurope CenAsiaNAfrica SubSahAfrica Asia eqSsq eqSnego eqSacqa eqSacqb eqSwara irrmargin_hostdispersed irrgproXirrMajoritarianALL irrefXirrMajoritarianALL irrcdivXirrMajoritarianALL irrpluralXirrMajoritarianALL irrnumgrpsXirrMajoritarianALL irrmarginXirrMajoritarian2 irrgprosquared irrMajoritarian2
order obcode irredentist group host year triadcode irredentism irrmargin irrMajoritarianALL irrmarginXirrMajoritarianALL hostdispersed irrhigh irrlow hostdiscrim countryGDPRATIO anoano anono noano hosttpop irrtpop logpowerdisparity IrrFSoviet HostFSoviet peaceyrs peaceyrssquared peaceyrscubed 
sort obcode

*** Variable Labels
label variable obcode "unique observation identifier"
label variable irredentist "irredentist state"
label variable group "ethnic group"
label variable host "host country"
label variable year "year"
label variable triadcode "triadcode"
label variable irredentism "case of irredentism (primary DV)"
label variable irrmargin "irredentist state: margin of largest ethnci group over second largest"
label variable irrMajoritarianALL "irredentist state: majoritarian electoral system"
label variable irrmarginXirrMajoritarianALL "margin/majoritarian interaction"
label variable hostdispersed "ethnic dispersion"
label variable irrhigh "asymmetric inequality high"
label variable irrlow "asymmetric inequality low"
label variable hostdiscrim "enclave discriminated"
label variable countryGDPRATIO "country wealth ratio"
label variable anoano "anocratic/anocratic"
label variable anono "anocratic/not anocratic"
label variable noano "not anocratic/anocratic"
label variable hosttpop "population (host)"
label variable irrtpop "population (irredentist)"
label variable logpowerdisparity "power disparity (natural log)"
label variable IrrFSoviet "former Soviet (irr)"
label variable HostFSoviet "former Soviet (host)"
label variable peaceyrs "peace years"
label variable peaceyrssquared "peace years squared"
label variable peaceyrscubed "peace years cubed"
label variable eqSsq "expected utility of status quo"
label variable eqSnego "expected utility of negotiation"
label variable eqSacqa "expected utility irredentist state acquiesces"
label variable eqSacqb "expected utility host state acquiesces"
label variable eqSwara "expected utility of war started by irredentist state"
label variable irrMajoritarian2 "stricter Majoritarian measure"
label variable irranocl "irredentist anocratic"
label variable irrdemocl "irredentist democratic"
label variable hostdemocl "host democratic"
label variable irrgpro "group proportion of irredentist state population"
label variable irref "ethnic fractionalization of irredentist state"
label variable irrplural "population share of largest group in irredentist state"
label variable irrcdiv "cultural fractionalization of irredentist state"
label variable irrnumgrps "number of groups in irredentist state"
label variable irrmargin_hostdispersed "margin/diespersion interaction"
label variable irrmarginXirrMajoritarian2 "margin/majoritarian interaction"
label variable irrmarginsquared "margin squared"
label variable irrgprosquared "group proportion squared"
label variable irrefXirrMajoritarianALL "ethnic fractionalization/majoritarian interaction"
label variable irrgproXirrMajoritarianALL "group proportion/majoritarian interaction"
label variable irrpluralXirrMajoritarianALL "largest group population share/majoritarian interaction"
label variable irrcdivXirrMajoritarianALL "cultural fractionalization/majoritarian interaction"
label variable irrnumgrpsXirrMajoritarianALL "number of groups/majoritarian interaction"
label variable hostgpro "group proportion of host state population"
label variable hostef "ethnic fractionalization of host state"
label variable hostplural "population share of largest group in host state"
label variable hostcdiv "cultural fractionalization of host state"
label variable hostnumgrps "number of groups in host state"
label variable groupGDPRATIO "enclave wealth ratio"
label variable irrautocl "irredentist autocratic"
label variable hostautocl "host autocratic"
label variable nono "not anocratic/not anocratic"
label variable WEuropeAM "Western Europe"
label variable EEurope "Eeastern Europe"
label variable CenAsiaNAfrica "Central Asia/North Africa/Middle East"
label variable SubSahAfrica "Sub-Saharan Africa"
label variable Asia "Asia"
save "~Replication Dataset.dta", replace













