*Polity IV data
insheet using "C:\Democracy\April 13 2011 Version\Copy of p4v2009.txt", clear
save "C:\Democracy\AJPS\democworki.dta", replace
xtset ccode year
replace ccode = 347 if country=="Kosovo"
*remove duplicate Yugoslavia 1991 entry
drop if cyear==3451991
*combine Yugoslavia pre 2003 with Serbia and Montenegro 2003-2006
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

*drop missing values
replace democ = . if democ<-10
replace autoc = . if autoc <-10
replace xrreg = . if xrreg <-10
replace xrcomp = . if xrcomp <-10
replace xropen = . if xropen <-10
replace xconst = . if xconst <-10
replace parreg = . if parreg <-10
replace parcomp = . if parcomp <-10
replace exrec = . if exrec <-10
replace exconst = . if exconst <-10
replace polcomp = . if polcomp<-10
replace polity2=. if polity<-10

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

*make measure of absolute value of past decreases in Polity score as in Epstein et al. 2006. Their “Previous Transitions” is for country i in year t the cumulative sum of the absolute values of negative changes*
*in the Polity score for country i from 1960 up to and including year t. My version will go back as far as the Polity data and will normalize by the number of years for which there are Polity data.
xtset ccode year
gen poldown = 0
replace poldown = . if polity2==.
replace poldown = -(polity2-l.polity2) if polity2-l.polity2<0
gen polpresent = 1
replace polpresent = 0 if polity2==.&polity~=-66 
sort ccode
by ccode: gen sumpoldown = sum(poldown)
by ccode: gen sumyears = sum(polpresent)
gen prevtrans = sumpoldown/sumyears
save "C:\Democracy\AJPS\democworki.dta", replace

*cleanup
drop if ccode == 265&year<1945
*extend observations for 265 back to 1800
insheet using "C:\Democracy\AJPS\backto1800.txt", clear
save "C:\Democracy\AJPS\backto1800.dta", replace
use "C:\Democracy\AJPS\democworki.dta", clear
append using "C:\Democracy\AJPS\backto1800.dta"
*this adds observations for E Germany 1800 on
tsset ccode year
tsfill, full
gen int negyear = -year
bysort ccode (negyear): carryforward scode, replace back carryalong (country)
replace cyear = ccode*10000+year
drop negyear

*make marker for start of data--i.e. independence or entry to the dataset
gen polyear = year
replace polyear=. if polity==.
bysort ccode: egen minyear=min(polyear)
gen indep=0
replace indep=1 if year>minyear-1
save "C:\Democracy\AJPS\democworki.dta", replace

*Boix Miller Rosato data
use "C:\Democracy\Final data\updated Boix Miller Rosato data to 2007.dta", clear
save "C:\Democracy\AJPS\BMRworking.dta", replace
*adjust to my country codings* 
drop if ccode==260&year==1945
*not to have both Germany and FRG in 1945*
drop if ccode==260&year==1990
*not to have both Germany and FRG in 1990*
drop if ccode==347&year==1991
*345 and 347 both for Yugoslavia in that year*
replace ccode = 530 if ccode==529
*both are Ethiopia*
replace ccode=255 if ccode==260
*combine Germany with FRG*
replace ccode=345 if ccode==347
*345 for Yugoslavia up to 2006* 
replace ccode=770 if ccode==769
*combine pre and post-1971 Pakistan*
drop if ccode==365&year==1922
replace ccode=365 if ccode==364
*combine Russia with USSR*
replace ccode=403 if country==161
*Sao Tome misccoded*
save "C:\Democracy\AJPS\BMRworking.dta", replace
rename democracy brosdembmr12
gen long cyear = ccode*10000+year
drop country
sort cyear
save "C:\Democracy\AJPS\BMRworking.dta", replace
use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear 
merge 1:1 cyear using "C:\Democracy\AJPS\BMRworking.dta" 
drop _merge
drop if ccode==.
save "C:\Democracy\AJPS\democworki.dta", replace



*Maddison 2009 data
insheet using "C:\Democracy\April 13 2011 Version\Maddison wide.txt", clear
reshape long gdppc, i(country) j(year)
gen ccode = .
replace ccode = 700 if country=="Afghanistan"
replace ccode = 339 if country=="Albania"
replace ccode = 615 if country=="Algeria"
replace ccode = 540 if country=="Angola"
replace ccode = 160 if country=="Argentina"
replace ccode = 371 if country=="Armenia"
replace ccode = 900 if country=="Australia"
replace ccode = 305 if country=="Austria"
replace ccode = 373 if country=="Azerbaijan"
replace ccode = 692 if country=="Bahrain"
replace ccode = 771 if country=="Bangladesh"
replace ccode = 370 if country=="Belarus"
replace ccode = 211 if country=="Belgium"
replace ccode = 434 if country=="Benin"
replace ccode = 145 if country=="Bolivia"
replace ccode = 346 if country=="Bosnia"
replace ccode = 571 if country=="Botswana"
replace ccode = 140 if country=="Brazil"
replace ccode = 355 if country=="Bulgaria"
replace ccode = 439 if country=="Burkina Faso"
replace ccode = 775 if country=="Burma"
replace ccode = 516 if country=="Burundi"
replace ccode = 811 if country=="Cambodia"
replace ccode = 471 if country=="Cameroon"
replace ccode = 20 if country=="Canada"
replace ccode = 402 if country=="Cape Verde"
replace ccode = 482 if country=="Central African Republic"
replace ccode = 483 if country=="Chad"
replace ccode = 155 if country=="Chile"
replace ccode = 710 if country=="China"
replace ccode = 100 if country=="Colombia"
replace ccode = 581 if country=="Comoro Islands"
replace ccode = 484 if country=="Congo 'Brazzaville'"
replace ccode = 94 if country=="Costa Rica"
replace ccode = 437 if country=="Côte d'Ivoire"
replace ccode = 437 if country=="Cote d'Ivoire"
replace ccode = 344 if country=="Croatia"
replace ccode = 40 if country=="Cuba"
replace ccode = 316 if country=="Czech Republic"
replace ccode = 315 if country=="Czechoslovakia"
replace ccode = 390 if country=="Denmark"
replace ccode = 522 if country=="Djibouti"
replace ccode = 42 if country=="Dominican Republic"
replace ccode = 130 if country=="Ecuador"
replace ccode = 651 if country=="Egypt"
replace ccode = 92 if country=="El Salvador"
replace ccode = 411 if country=="Equatorial Guinea"
replace ccode = 531 if country=="Eritrea"
replace ccode = 530 if country=="Ethiopia"
replace ccode = 366 if country=="Estonia"
replace ccode = 375 if country=="Finland"
replace ccode = 220 if country=="France"
replace ccode = 481 if country=="Gabon"
replace ccode = 420 if country=="Gambia"
replace ccode = 372 if country=="Georgia"
replace ccode = 255 if country=="Germany"
replace ccode = 452 if country=="Ghana"
replace ccode = 350 if country=="Greece"
replace ccode = 90 if country=="Guatemala"
replace ccode = 438 if country=="Guinea"
replace ccode = 404 if country=="Guinea Bissau"
replace ccode = 110 if country=="Guyana"
replace ccode = 41 if country=="Haïti"
replace ccode = 41 if country=="Haiti"
replace ccode = 91 if country=="Honduras"
replace ccode = 1001 if country=="Hong Kong"
replace ccode = 310 if country=="Hungary"
replace ccode = 750 if country=="India"
replace ccode = 850 if country=="Indonesia (including Timor until 1999)"
replace ccode = 630 if country=="Iran"
replace ccode = 645 if country=="Iraq"
replace ccode = 205 if country=="Ireland"
replace ccode = 666 if country=="Israel"
replace ccode = 325 if country=="Italy"
replace ccode = 51 if country=="Jamaica"
replace ccode = 740 if country=="Japan"
replace ccode = 663 if country=="Jordan"
replace ccode = 705 if country=="Kazakhstan"
replace ccode = 501 if country=="Kenya"
replace ccode = 347 if country=="Kosovo"
replace ccode = 690 if country=="Kuwait"
replace ccode = 703 if country=="Kyrgyzstan"
replace ccode = 812 if country=="Laos"
replace ccode = 367 if country=="Latvia"
replace ccode = 660 if country=="Lebanon"
replace ccode = 570 if country=="Lesotho"
replace ccode = 450 if country=="Liberia"
replace ccode = 620 if country=="Libya"
replace ccode = 368 if country=="Lithuania"
replace ccode = 343 if country=="Macedonia"
replace ccode = 580 if country=="Madagascar"
replace ccode = 553 if country=="Malawi"
replace ccode = 820 if country=="Malaysia"
replace ccode = 432 if country=="Mali"
replace ccode = 435 if country=="Mauritania"
replace ccode = 590 if country=="Mauritius"
replace ccode = 70 if country=="Mexico"
replace ccode = 359 if country=="Moldova"
replace ccode = 712 if country=="Mongolia"
replace ccode = 341 if country=="Montenegro"
replace ccode = 600 if country=="Morocco"
replace ccode = 541 if country=="Mozambique"
replace ccode = 565 if country=="Namibia"
replace ccode = 790 if country=="Nepal"
replace ccode = 210 if country=="Netherlands"
replace ccode = 920 if country=="New Zealand"
replace ccode = 93 if country=="Nicaragua"
replace ccode = 436 if country=="Niger"
replace ccode = 475 if country=="Nigeria"
replace ccode = 731 if country=="North Korea"
replace ccode = 385 if country=="Norway"
replace ccode = 698 if country=="Oman"
replace ccode = 770 if country=="Pakistan"
replace ccode = 95 if country=="Panama"
replace ccode = 150 if country=="Paraguay"
replace ccode = 135 if country=="Peru"
replace ccode = 840 if country=="Philippines"
replace ccode = 290 if country=="Poland"
replace ccode = 235 if country=="Portugal"
replace ccode = 1002 if country=="Puerto Rico"
replace ccode = 694 if country=="Qatar"
replace ccode = 360 if country=="Romania"
replace ccode = 365 if country=="Russian Federation"&year>1991
replace ccode = 517 if country=="Rwanda"
replace ccode = 403 if country=="São Tomé and Principe"
replace ccode = 403 if country=="Sao Tome and Principe"
replace ccode = 670 if country=="Saudi Arabia"
replace ccode = 433 if country=="Senegal"
replace ccode = 342 if country=="Serbia"
replace ccode = 348 if country=="Serbia and Montenegro"
replace ccode=345 if country=="Serbia and Montenegro"&year>2002&year<2007
replace ccode = 591 if country=="Seychelles"
replace ccode = 451 if country=="Sierra Leone"
replace ccode = 830 if country=="Singapore"
replace ccode = 317 if country=="Slovakia"
replace ccode = 349 if country=="Slovenia"
replace ccode = 520 if country=="Somalia"
replace ccode = 560 if country=="South Africa"
replace ccode = 732 if country=="South Korea"
replace ccode = 730 if country=="Korea"
replace ccode = 230 if country=="Spain"
replace ccode = 780 if country=="Sri Lanka"
replace ccode = 625 if country=="Sudan"
replace ccode = 572 if country=="Swaziland"
replace ccode = 380 if country=="Sweden"
replace ccode = 225 if country=="Switzerland"
replace ccode = 652 if country=="Syria"
replace ccode = 713 if country=="Taiwan"
replace ccode = 702 if country=="Tajikistan"
replace ccode = 510 if country=="Tanzania"
replace ccode = 800 if country=="Thailand"
replace ccode = 461 if country=="Togo"
replace ccode = 365 if country=="Total Former USSR"&year<1992
replace ccode = 52 if country=="Trinidad and Tobago"
replace ccode = 616 if country=="Tunisia"
replace ccode = 640 if country=="Turkey"
replace ccode = 701 if country=="Turkmenistan"
replace ccode = 500 if country=="Uganda"
replace ccode = 369 if country=="Ukraine"
replace ccode = 696 if country=="United Arab Emirates"
replace ccode = 200 if country=="United Kingdom"
replace ccode = 2 if country=="United States"
replace ccode = 165 if country=="Uruguay"
replace ccode = 704 if country=="Uzbekistan"
replace ccode = 101 if country=="Venezuela"
replace ccode = 818 if country=="Vietnam"
replace ccode = 816 if country=="Vietnam North"
replace ccode = 817 if country=="Vietnam South"
replace ccode = 1005 if country=="West Bank and Gaza"
replace ccode = 679 if country=="Yemen"
replace ccode = 678 if country=="Yemen North"
replace ccode = 680 if country=="Yemen South"
replace ccode = 345 if country=="Yugoslavia"&year~=2003&year~=2004&year~=2005&year~=2006
replace ccode = 490 if country=="Zaire (Congo Kinshasa)"
replace ccode = 551 if country=="Zambia"
replace ccode = 552 if country=="Zimbabwe"
gen gdppcnoti = gdppc
sort ccode
by ccode: ipolate gdppc year, gen(gdppci)
drop gdppc
rename gdppci gdppc
gen cyear = ccode*10000+year
rename country countrymad
drop if ccode==.
sort cyear
save "C:\Democracy\AJPS\Maddison longi.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear 
merge cyear using "C:\Democracy\AJPS\Maddison longi.dta"
save "C:\Democracy\AJPS\democworki.dta", replace
xtset ccode year
gen oneyrgrowth = ((gdppc/l.gdppc)-1)*100
replace oneyrgrowth = . if l.ccode~=ccode
replace oneyrgrowth=. if ccode==365&year==1992
*change in measure from USSR to Russia
gen fiveyrgrowth = ((gdppc/l5.gdppc)-1)*100
gen lfiveyrgrow = l.fiveyrgrowth
gen lngdppc = ln(gdppc)
drop if ccode==.
drop _merge
save "C:\Democracy\AJPS\democworki.dta", replace

*Archigos data
*You must have already run the leader data prep file
use "C:\Democracy\edreynal work1.dta", clear
replace ccode=365 if leader=="Yeltsin"
replace ccode=365 if ccode==364
*complete cyear*
replace cyear = ccode*10000+year
*drop Besley Reynal cases that are not in Archigos--lack info about turnover
drop if leadid==""
gen leaderturn = 1 
sort cyear eindate
drop case
gen case=_n
tsset case
gen lastleader = leader[_n-1]
replace eoutdate = . if year(eoutdate)==2004&exit==-888
*i.e. if still in office give outdate of .

*Note the exit type variables focus on the type of exit of PREVIOUS leader. This is what potentially triggers political change.
gen irregular = 0
replace irregular = 1 if l.exit==3&l.ccode==ccode
gen natcauses = 0
replace natcauses = 1 if l.exit==2&l.ccode==ccode
gen deposed = 0
replace deposed = 1 if l.exit==4&l.ccode==ccode
gen suicide = 0
replace suicide = 1 if l.exit==2.2&l.ccode==ccode
gen retired = 0
replace retired = 1 if l.exit==2.1&l.ccode==ccode
gen assassinate = 0
replace assassinate = 1 if l.exitcode==11&l.ccode==ccode
gen regular = 0
replace regular = 1 if l.exit==1&l.ccode==ccode
*Lithuania was not an independent state until 1918
replace regular = . if ccode==368&year==1917
replace irregular = . if ccode==368&year==1917
replace natcauses = . if ccode==368&year==1917
replace deposed = . if ccode==368&year==1917
replace suicide = . if ccode==368&year==1917
replace retired = . if ccode==368&year==1917
replace assassinate = . if ccode==368&year==1917
gen leaderfalls = 0
replace leaderfalls = 1 if regular==1|irregular==1|deposed==1|assassinate==1
replace leaderfalls=. if leaderturn==.
*Note: leaderturn records that leader was replaced by any means; leaderfalls records if leader was replaced by regular, irregular, or external state action--excluding death of nat causes, retirement due to illhealth, and suicide
*Yeltsin follows Lenin in 'Russia'--must adjust
replace natcauses=0 if ccode==365&year==1991
replace regular=1 if ccode==365&year==1991
replace leaderfalls=1 if ccode==365&year==1991
*Jump from 1940 to 1991 in Estonia,must adjust
replace deposed=0 if ccode==366&year==1991
replace regular=1 if ccode==366&year==1991
*Jump from 1934 to 1990 in Latvia,must adjust
replace deposed=0 if ccode==367&year==1990
replace regular=1 if ccode==367&year==1990
*Jump in Lithuania,must adjust
replace deposed=0 if ccode==368&year==1990
replace regular=1 if ccode==368&year==1990
*Jump from 1889 to 1945 in Vietnam, must adjust
replace deposed=0 if ccode==818&year==1945
replace irregular=1 if ccode==818&year==1945
*Jump from 1864 to 1960 in Madagascar, adjust
replace regular=1 if ccode==580&year==1960
replace deposed=0 if ccode==580&year==1960
*Huge jump in Tunisia, adjust
replace regular=1 if ccode==616&year==1943
replace natcauses=0 if ccode==616&year==1943
*huge jump Myanmar, adjust
replace regular=1 if ccode==775&year==1948
replace deposed=0 if ccode==775&year==1948
*Morocco discontinuity
replace irregular=1 if ccode==600&year==1956
replace leaderturn=1 if ccode==600&year==1956
replace leaderfalls=1 if ccode==600&year==1956

*Generate a variable for the percentage of previous leaderturnovers that were irregular
sort ccode
by ccode: gen sumirr = sum(irregular)
by ccode: gen turnovers= sum(leaderturn)
gen pctirreg = sumirr/turnovers
sort ccode

*generate variable for number of turnovers in given year. 
bysort cyear: egen ltnumber = sum(leaderturn)
save "C:\Democracy\AJPS\archigoswork.dta", replace

*Need to turn this file into one with just one observation per country/year, regardless how many changes of leadership occurred within given year
*I go by the last leader change within a given year
sort ccode year eindate
drop case
gen case=_n
tsset case
sort cyear
by cyear: keep if _n==_N
*Note that "leader" gives the name of leader at end of the year
sort cyear
save "C:\Democracy\AJPS\archigoswork.dta", replace
use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear
merge cyear using "C:\Democracy\AJPS\archigoswork.dta"
save "C:\Democracy\AJPS\democworki.dta", replace


*add some country labels
replace country = "Cape Verde" if ccode==402
replace country = "Guyana" if ccode==110
replace country = "Portugal" if ccode==235
replace country = "Rwanda" if ccode==517
replace country = "Sierra Leone" if ccode==451
replace country = "West Bank and Gaza" if ccode==1005
replace country = "Hong Kong" if ccode==1001

sort ccode
*fill in gaps
xtset ccode year
by ccode: gen sumcase = sum(leadno)
replace leaderturn=0 if leaderturn==.&sumcase>0&year<2005
replace regular =0 if regular ==.&sumcase>0&year<2005
replace irregular =0 if irregular ==.&sumcase>0&year<2005
replace natcauses =0 if natcauses ==.&sumcase>0&year<2005
replace deposed =0 if deposed ==.&sumcase>0&year<2005
replace suicide =0 if suicide ==.&sumcase>0&year<2005
replace retired =0 if retired ==.&sumcase>0&year<2005
replace assassinate =0 if assassinate ==.&sumcase>0&year<2005
replace leaderfalls =0 if leaderfalls ==.&sumcase>0&year<2005
replace ltnumber =0 if ltnumber ==. &sumcase>0&year<2005

gen ltnum5yr = l.ltnumber+l2.ltnumber+l3.ltnumber+l4.ltnumber+l5.ltnumber
gen ltnum10yr = l.ltnumber+l2.ltnumber+l3.ltnumber+l4.ltnumber+l5.ltnumber+l6.ltnumber+l7.ltnumber+l8.ltnumber+l9.ltnumber+l10.ltnumber
gen ltnum15yr = l.ltnumber+l2.ltnumber+l3.ltnumber+l4.ltnumber+l5.ltnumber+l6.ltnumber+l7.ltnumber+l8.ltnumber+l9.ltnumber+l10.ltnumber+l11.ltnumber+l12.ltnumber+l13.ltnumber+l14.ltnumber+l15.ltnumber
gen ltnum20yr = l.ltnumber+l2.ltnumber+l3.ltnumber+l4.ltnumber+l5.ltnumber+l6.ltnumber+l7.ltnumber+l8.ltnumber+l9.ltnumber+l10.ltnumber+l11.ltnumber+l12.ltnumber+l13.ltnumber+l14.ltnumber+l15.ltnumber+l16.ltnumber+l17.ltnumber+l18.ltnumber+l19.ltnumber+l20.ltnumber

sort ccode
bysort ccode: carryforward pctirreg, gen(pctirreg1) 
drop pctirreg
rename pctirreg1 pctirreg

sort ccode
bysort ccode: carryforward turnovers, gen(turns1) 
drop turnovers
rename turns1 turnovers

sort ccode
bysort ccode: carryforward graduatedegree, gen(x1) 
drop graduatedegree
rename x1 graduatedegree
sort ccode
bysort ccode: carryforward collegedegree, gen(x1) 
drop collegedegree
rename x1 collegedegree
sort ccode
bysort ccode: carryforward edindex, gen(x1) 
drop edindex
rename x1 edindex
sort ccode
bysort ccode: carryforward edgap, gen(x1) 
drop edgap
rename x1 edgap
sort ccode year
by ccode: carryforward leadid, gen (leadid2)
sort ccode year
by ccode: carryforward age0, gen (age02)
sort ccode year
by ccode: carryforward eindate, gen (ein2)
replace ein2 = . if ccode==342&year>1915
replace ein2 = . if ccode==366&year>1940&year<1991
replace ein2 = . if ccode==367&year>1940&year<1990
replace ein2 = . if ccode==368&year>1940&year<1990
replace ein2 = . if ccode==520&year>1991
replace ein2 = . if ccode==520&year>1991
replace ein2 = . if ccode==580&year>1895&year<1960
replace ein2 = . if ccode==600&year>1908&year<1956
replace ein2 = . if ccode==616&year>1882&year<1943
replace ein2 = . if ccode==775&year>1886&year<1948
replace ein2 = . if ccode==818&year>1908&year<1945
replace ein2 = . if year>2004
gen agenew = age02+year-year(ein2) 
sort ccode

bysort leadid2: egen leadnofull = min(leadno)
replace leadnofull=. if year>2004
xtset ccode year
by ccode: carryforward eoutdate , gen (eout2)
xtset ccode year
replace eout2 = . if year(eout2)>2004
replace eout2=. if year>year(eout2)
replace eout2=. if leadnofull~=l.leadnofull&eoutdate==.
replace eout2 = . if ccode==342&year>1915
replace eout2 = . if ccode==366&year>1940&year<1991
replace eout2 = . if ccode==367&year>1940&year<1990
replace eout2 = . if ccode==368&year>1940&year<1990
replace eout2 = . if ccode==520&year>1991
replace eout2 = . if ccode==520&year>1991
replace eout2 = . if ccode==580&year>1895&year<1960
replace eout2 = . if ccode==600&year>1908&year<1956
replace eout2 = . if ccode==616&year>1882&year<1943
replace eout2 = . if ccode==775&year>1886&year<1948
replace eout2 = . if ccode==818&year>1908&year<1945
replace ein2=. if year(eout2)==.&polity==-66

replace leaderturn = . if ccode==342&year>1915
replace leaderturn = . if ccode==366&year>1940&year<1991
replace leaderturn = . if ccode==367&year>1940&year<1990
replace leaderturn = . if ccode==368&year>1940&year<1990
replace leaderturn = . if ccode==520&year>1991
replace leaderturn = . if ccode==580&year>1895&year<1960
replace leaderturn = . if ccode==600&year>1908&year<1956
replace leaderturn = . if ccode==616&year>1882&year<1943
replace leaderturn = . if ccode==775&year>1886&year<1948
replace leaderturn = . if ccode==818&year>1908&year<1945
replace irregular=. if leaderturn==.
replace regular=. if leaderturn==.
replace natcauses=. if leaderturn==.
replace deposed=. if leaderturn==.
replace suicide=. if leaderturn==.
replace retired=. if leaderturn==.
replace assassinate=. if leaderturn==.
replace leaderfalls=. if leaderturn==.
replace age02=. if leaderturn==.
replace irregular=. if leaderturn==1&l.leaderturn==.
replace natcauses=. if leaderturn==1&l.leaderturn==.
replace deposed=. if leaderturn==1&l.leaderturn==.
replace retired=. if leaderturn==1&l.leaderturn==.
replace suicide=. if leaderturn==1&l.leaderturn==.
replace regular=. if leaderturn==1&l.leaderturn==.
*these represent the first year of the first leader: we do not know how the previous leader left. 
replace irregular=0 if leaderturn==0
replace natcauses=0 if leaderturn==0
replace deposed=0 if leaderturn==0
replace retired=0 if leaderturn==0
replace suicide=0 if leaderturn==0
replace regular=0 if leaderturn==0
sort ccode
by ccode: carryforward prevtimesinoffice, gen (prevtimesinoffice2)
drop prevtimesinoffice
rename prevtimesinoffice2 prevtimesinoffice

sort ccode
by ccode: carryforward leader, gen (leader2)
replace leader2 = "" if ccode==342&year>1915
replace leader2 = "" if ccode==366&year>1940&year<1991
replace leader2 = "" if ccode==367&year>1940&year<1990
replace leader2 = "" if ccode==368&year>1940&year<1990
replace leader2 = "" if ccode==520&year>1991
replace leader2 = "" if ccode==580&year>1895&year<1960
replace leader2 = "" if ccode==600&year>1908&year<1956
replace leader2 = "" if ccode==616&year>1882&year<1943
replace leader2 = "" if ccode==775&year>1886&year<1948
replace leader2 = "" if ccode==818&year>1908&year<1945
replace leader2 = "" if year>2004

save "C:\Democracy\AJPS\democworki.dta", replace

*Gleditsch new

insheet using "C:\Democracy\gleditsch polity4d.txt", clear
rename startdate politystartdate
rename startyear year
gen cyear = ccode*10000+year
drop if ccode==.
sort cyear
keep ccode cyear scode politystartdate year
save "C:\Democracy\AJPS\gleditschdwork.dta", replace

*There are some years in which two polity changes occur. For my purposes, this does not matter if no leader change occurred that year*
merge cyear using "C:\Democracy\AJPS\archigoswork.dta", sort uniqusing
drop if scode==""
drop if leadid==""
sort cyear
drop case
gen case = _n
tsset case
drop if cyear==l.cyear&leaderturn==0
list ccode ccname year if cyear==l.cyear&leaderturn==1

*for the remaining cases, to be conservative, use the earliest polity change date*
gen dateno = date(politystartdate, "DMY")
gen long ccodedateno = ccode*1000000+dateno
sort ccodedateno
drop case
gen case = _n
tsset case
drop if cyear==l.cyear&leaderturn==1&l.dateno<dateno
drop _merge
save "C:\Democracy\AJPS\gleditschdwork.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear 
drop _merge
merge cyear using "C:\Democracy\AJPS\gleditschdwork.dta", sort
save "C:\Democracy\AJPS\democworki.dta", replace
xtset ccode year
drop _merge
save "C:\Democracy\AJPS\democworki.dta", replace

*create ltfirst2 for leaderturnover in the given year, coding as 0 those countries that in a year with polity2 change had leader turnover AFTER or SIMULTANEOUSLY WITH change in Polity2 score (Gleditsch's timings from Polity 4d)*
rename startdate leaderstartdate
gen ltfirst2 = 0
replace ltfirst2 = 1 if leaderturn==1&polity2~=l.polity2&eindate<dateno&eindate~=.&dateno~=.&polity2~=.&l.polity2~=.
replace ltfirst2=1 if leaderturn==1&polity2==l.polity2&polity2~=.&l.polity2~=.
replace ltfirst2=. if polity2==.|l.polity2==.
label var ltfirst2 "leader changed and IF polity2 also changed, l ch. strictly before p2 change"
save "C:\Democracy\AJPS\democworki.dta", replace

*Make leadership turnover in last 5,10,15,20 years vars.
*Note, the leadership turnover variables are defined as: A) 1 if it is known that at least one leader has been replaced during the relevant period; B) 0 if data exist for all years during the relevant period and no leader was replaced; C) . if data are missing for some or all of the years in the period and no leader was replaced in the remaining years.
xtset ccode year
gen lturn5yr = 0
replace lturn5yr = . if l.leaderturn==.|l2.leaderturn==.|l3.leaderturn==.|l4.leaderturn==.|l5.leaderturn==.
replace lturn5yr = 1 if l.leaderturn==1 
replace lturn5yr = 1 if l2.leaderturn==1 
replace lturn5yr = 1 if l3.leaderturn==1 
replace lturn5yr = 1 if l4.leaderturn==1 
replace lturn5yr = 1 if l5.leaderturn==1 
gen lturn10yr = 0
replace lturn10yr = . if l.leaderturn==.|l2.leaderturn==.|l3.leaderturn==.|l4.leaderturn==.|l5.leaderturn==.|l6.leaderturn==.|l7.leaderturn==.|l8.leaderturn==.|l9.leaderturn==.|l10.leaderturn==.
replace lturn10yr = 1 if lturn5yr==1|l6.leaderturn==1|l7.leaderturn==1|l8.leaderturn==1|l9.leaderturn==1|l10.leaderturn==1 
gen lturn15yr = 0
replace lturn15yr = . if l.leaderturn==.|l2.leaderturn==.|l3.leaderturn==.|l4.leaderturn==.|l5.leaderturn==.|l6.leaderturn==.|l7.leaderturn==.|l8.leaderturn==.|l9.leaderturn==.|l10.leaderturn==.|l11.leaderturn==.|l12.leaderturn==.|l13.leaderturn==.|l14.leaderturn==.|l15.leaderturn==.
replace lturn15yr = 1 if lturn10yr==1|l11.leaderturn==1|l12.leaderturn==1|l13.leaderturn==1|l14.leaderturn==1|l15.leaderturn==1 
gen lturn20yr = 0
replace lturn20yr = . if l.leaderturn==.|l2.leaderturn==.|l3.leaderturn==.|l4.leaderturn==.|l5.leaderturn==.|l6.leaderturn==.|l7.leaderturn==.|l8.leaderturn==.|l9.leaderturn==.|l10.leaderturn==.|l11.leaderturn==.|l12.leaderturn==.|l13.leaderturn==.|l14.leaderturn==.|l15.leaderturn==.|l16.leaderturn==.|l17.leaderturn==.|l18.leaderturn==.|l19.leaderturn==.|l20.leaderturn==.
replace lturn20yr = 1 if lturn15yr==1|l16.leaderturn==1|l17.leaderturn==1|l18.leaderturn==1|l19.leaderturn==1|l20.leaderturn==1 

gen sumlt10=l.leaderturn+l2.leaderturn+l3.leaderturn+l4.leaderturn+l5.leaderturn+l6.leaderturn+l7.leaderturn+l8.leaderturn+l9.leaderturn+l10.leaderturn
gen sumlt5=l.leaderturn+l2.leaderturn+l3.leaderturn+l4.leaderturn+l5.leaderturn

*Create parallel variables adjusted to exclude leader turnover that is simultaneous with or after any net polity2 increase*
*If there is no net increase in Polity2 over the period, then ltdiffx records whether or not there was at least one leader change. If there is a net increase in Polity over the period, 
*then ltdiffx records whether or not there was at least one leader change that was followed by a net increase in Polity2 over the remainder of the period. Thus, it codes as zero cases 
*in which there was both an increase in Polity2 and change in leader, but in which the change in leader came only simultaneously with or after the net increase in Polity2. 

gen ltdiff5 = lturn5yr
replace ltdiff5=0 if pol2norm>l5.pol2norm&lturn5yr~=.
replace ltdiff5 = 1 if l5.leaderturn==1& pol2norm>l5.pol2norm
replace ltdiff5 = 1 if l5.leaderturn==1&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1& pol2norm>l6.pol2norm
*i.e. there was leader turnover in period t-5, and also polity increase in period t-5, and polity increase came after the leader turnover, and the polity2 score in year t is still higher than before that polity change
replace ltdiff5 = 1 if l4.leaderturn==1& pol2norm>l4.pol2norm 
replace ltdiff5 = 1 if l4.leaderturn==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1
replace ltdiff5 = 1 if l3.leaderturn==1& pol2norm>l3.pol2norm
replace ltdiff5 = 1 if l3.leaderturn==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1
replace ltdiff5 = 1 if l2.leaderturn==1& pol2norm>l2.pol2norm 
replace ltdiff5 = 1 if l2.leaderturn==1& pol2norm>l3.pol2norm&l2.pol2norm>l3.pol2norm&l2.ltfirst2==1
replace ltdiff5 = 1 if l.leaderturn==1& pol2norm>l.pol2norm 
replace ltdiff5 = 1 if l.leaderturn==1& pol2norm>l2.pol2norm&l.pol2norm>l2.pol2norm&l.ltfirst2==1

gen ltdiff10 = lturn10yr
replace ltdiff10=0 if pol2norm>l10.pol2norm&lturn10yr~=.
replace ltdiff10 = 1 if l10.leaderturn==1& pol2norm>l10.pol2norm
replace ltdiff10 = 1 if l10.leaderturn==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1
replace ltdiff10 = 1 if l9.leaderturn==1& pol2norm>l9.pol2norm 
replace ltdiff10 = 1 if l9.leaderturn==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1
replace ltdiff10 = 1 if l8.leaderturn==1& pol2norm>l8.pol2norm
replace ltdiff10 = 1 if l8.leaderturn==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1
replace ltdiff10 = 1 if l7.leaderturn==1& pol2norm>l7.pol2norm 
replace ltdiff10 = 1 if l7.leaderturn==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1
replace ltdiff10 = 1 if l6.leaderturn==1& pol2norm>l6.pol2norm 
replace ltdiff10 = 1 if l6.leaderturn==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1
replace ltdiff10 = 1 if l5.leaderturn==1& pol2norm>l5.pol2norm
replace ltdiff10 = 1 if l5.leaderturn==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1
replace ltdiff10 = 1 if l4.leaderturn==1& pol2norm>l4.pol2norm 
replace ltdiff10 = 1 if l4.leaderturn==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1
replace ltdiff10 = 1 if l3.leaderturn==1& pol2norm>l3.pol2norm
replace ltdiff10 = 1 if l3.leaderturn==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1
replace ltdiff10 = 1 if l2.leaderturn==1& pol2norm>l2.pol2norm 
replace ltdiff10 = 1 if l2.leaderturn==1& pol2norm>l3.pol2norm&l2.pol2norm>l3.pol2norm&l2.ltfirst2==1
replace ltdiff10 = 1 if l.leaderturn==1& pol2norm>l.pol2norm 
replace ltdiff10 = 1 if l.leaderturn==1& pol2norm>l2.pol2norm&l.pol2norm>l2.pol2norm&l.ltfirst2==1

gen ltdiff15 = lturn15yr
replace ltdiff15=0 if pol2norm>l15.pol2norm&ltdiff15~=.
replace ltdiff15 = 1 if l15.leaderturn==1& pol2norm>l15.pol2norm
replace ltdiff15 = 1 if l15.leaderturn==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1
replace ltdiff15 = 1 if l14.leaderturn==1& pol2norm>l14.pol2norm 
replace ltdiff15 = 1 if l14.leaderturn==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1
replace ltdiff15 = 1 if l13.leaderturn==1& pol2norm>l13.pol2norm
replace ltdiff15 = 1 if l13.leaderturn==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1
replace ltdiff15 = 1 if l12.leaderturn==1& pol2norm>l12.pol2norm 
replace ltdiff15 = 1 if l12.leaderturn==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1
replace ltdiff15 = 1 if l11.leaderturn==1& pol2norm>l11.pol2norm 
replace ltdiff15 = 1 if l11.leaderturn==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1
replace ltdiff15 = 1 if l10.leaderturn==1& pol2norm>l10.pol2norm
replace ltdiff15 = 1 if l10.leaderturn==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1
replace ltdiff15 = 1 if l9.leaderturn==1& pol2norm>l9.pol2norm 
replace ltdiff15 = 1 if l9.leaderturn==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1
replace ltdiff15 = 1 if l8.leaderturn==1& pol2norm>l8.pol2norm
replace ltdiff15 = 1 if l8.leaderturn==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1
replace ltdiff15 = 1 if l7.leaderturn==1& pol2norm>l7.pol2norm 
replace ltdiff15 = 1 if l7.leaderturn==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1
replace ltdiff15 = 1 if l6.leaderturn==1& pol2norm>l6.pol2norm 
replace ltdiff15 = 1 if l6.leaderturn==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1
replace ltdiff15 = 1 if l5.leaderturn==1& pol2norm>l5.pol2norm
replace ltdiff15 = 1 if l5.leaderturn==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1
replace ltdiff15 = 1 if l4.leaderturn==1& pol2norm>l4.pol2norm 
replace ltdiff15 = 1 if l4.leaderturn==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1
replace ltdiff15 = 1 if l3.leaderturn==1& pol2norm>l3.pol2norm
replace ltdiff15 = 1 if l3.leaderturn==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1
replace ltdiff15 = 1 if l2.leaderturn==1& pol2norm>l2.pol2norm 
replace ltdiff15 = 1 if l2.leaderturn==1& pol2norm>l3.pol2norm&l2.pol2norm>l3.pol2norm&l2.ltfirst2==1
replace ltdiff15 = 1 if l.leaderturn==1& pol2norm>l.pol2norm 
replace ltdiff15 = 1 if l.leaderturn==1& pol2norm>l2.pol2norm&l.pol2norm>l2.pol2norm&l.ltfirst2==1

gen ltdiff20 = lturn20yr
replace ltdiff20=0 if pol2norm>l20.pol2norm&ltdiff20~=.
replace ltdiff20 = 1 if l20.leaderturn==1& pol2norm>l20.pol2norm
replace ltdiff20 = 1 if l20.leaderturn==1& pol2norm>l21.pol2norm&l20.pol2norm>l21.pol2norm&l20.ltfirst2==1
replace ltdiff20 = 1 if l19.leaderturn==1& pol2norm>l19.pol2norm 
replace ltdiff20 = 1 if l19.leaderturn==1& pol2norm>l20.pol2norm&l19.pol2norm>l20.pol2norm&l19.ltfirst2==1
replace ltdiff20 = 1 if l18.leaderturn==1& pol2norm>l18.pol2norm
replace ltdiff20 = 1 if l18.leaderturn==1& pol2norm>l19.pol2norm&l18.pol2norm>l19.pol2norm&l18.ltfirst2==1
replace ltdiff20 = 1 if l17.leaderturn==1& pol2norm>l17.pol2norm 
replace ltdiff20 = 1 if l17.leaderturn==1& pol2norm>l18.pol2norm&l17.pol2norm>l18.pol2norm&l17.ltfirst2==1
replace ltdiff20 = 1 if l16.leaderturn==1& pol2norm>l16.pol2norm 
replace ltdiff20 = 1 if l16.leaderturn==1& pol2norm>l17.pol2norm&l16.pol2norm>l17.pol2norm&l16.ltfirst2==1
replace ltdiff20 = 1 if l15.leaderturn==1& pol2norm>l15.pol2norm
replace ltdiff20 = 1 if l15.leaderturn==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1
replace ltdiff20 = 1 if l14.leaderturn==1& pol2norm>l14.pol2norm 
replace ltdiff20 = 1 if l14.leaderturn==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1
replace ltdiff20 = 1 if l13.leaderturn==1& pol2norm>l13.pol2norm
replace ltdiff20 = 1 if l13.leaderturn==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1
replace ltdiff20 = 1 if l12.leaderturn==1& pol2norm>l12.pol2norm 
replace ltdiff20 = 1 if l12.leaderturn==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1
replace ltdiff20 = 1 if l11.leaderturn==1& pol2norm>l11.pol2norm 
replace ltdiff20 = 1 if l11.leaderturn==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1
replace ltdiff20 = 1 if l10.leaderturn==1& pol2norm>l10.pol2norm
replace ltdiff20 = 1 if l10.leaderturn==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1
replace ltdiff20 = 1 if l9.leaderturn==1& pol2norm>l9.pol2norm 
replace ltdiff20 = 1 if l9.leaderturn==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1
replace ltdiff20 = 1 if l8.leaderturn==1& pol2norm>l8.pol2norm
replace ltdiff20 = 1 if l8.leaderturn==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1
replace ltdiff20 = 1 if l7.leaderturn==1& pol2norm>l7.pol2norm 
replace ltdiff20 = 1 if l7.leaderturn==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1
replace ltdiff20 = 1 if l6.leaderturn==1& pol2norm>l6.pol2norm 
replace ltdiff20 = 1 if l6.leaderturn==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1
replace ltdiff20 = 1 if l5.leaderturn==1& pol2norm>l5.pol2norm
replace ltdiff20 = 1 if l5.leaderturn==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1
replace ltdiff20 = 1 if l4.leaderturn==1& pol2norm>l4.pol2norm 
replace ltdiff20 = 1 if l4.leaderturn==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1
replace ltdiff20 = 1 if l3.leaderturn==1& pol2norm>l3.pol2norm
replace ltdiff20 = 1 if l3.leaderturn==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1
replace ltdiff20 = 1 if l2.leaderturn==1& pol2norm>l2.pol2norm 
replace ltdiff20 = 1 if l2.leaderturn==1& pol2norm>l3.pol2norm&l2.pol2norm>l3.pol2norm&l2.ltfirst2==1
replace ltdiff20 = 1 if l.leaderturn==1& pol2norm>l.pol2norm 
replace ltdiff20 = 1 if l.leaderturn==1& pol2norm>l2.pol2norm&l.pol2norm>l2.pol2norm&l.ltfirst2==1
save "C:\Democracy\AJPS\democworki.dta", replace

*Make irregular, regular, natcauses, deposed, suicide, retired, leadership turnover in last 5,10,15,20 years vars.
*Note that I require that a turnover of the type occurred AND WAS THE LAST TURNOVER IN THE PANEL PERIOD
*As for leader turnover, if we lack information about a certain year within the given period, and it might have had a leader exit of the given kind, code period as missing, not zero
*however, if a leader exit of the given kind occurs later in period and is the last leader exit of period, code as 1 for that type of exit.
use "C:\Democracy\AJPS\democworki.dta", clear
xtset ccode year
gen irreg5yr = 0
replace irreg5yr = . if l.irregular==.|l2.irregular==.|l3.irregular==.|l4.irregular==.|l5.irregular==.
replace irreg5yr= 1 if l.irregular==1
replace irreg5yr= 1 if l2.irregular==1&l.leaderturn==0 
replace irreg5yr= 1 if l3.irregular==1&l2.leaderturn==0 &l.leaderturn==0  
replace irreg5yr= 1 if l4.irregular==1&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irreg5yr= 1 if l5.irregular==1&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
gen irreg10yr = 0
replace irreg10yr = . if l.irregular==.|l2.irregular==.|l3.irregular==.|l4.irregular==.|l5.irregular==.|l6.irregular==.|l7.irregular==.|l8.irregular==.|l9.irregular==.|l10.irregular==.
replace irreg10yr = 1 if irreg5yr==1 
replace irreg10yr = 1 if l6.irregular==1&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0   
replace irreg10yr = 1 if l7.irregular==1&l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace irreg10yr = 1 if l8.irregular==1 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irreg10yr = 1 if l9.irregular==1 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irreg10yr = 1 if l10.irregular==1 &l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen irreg15yr = 0
replace irreg15yr = . if l.irregular==.|l2.irregular==.|l3.irregular==.|l4.irregular==.|l5.irregular==.|l6.irregular==.|l7.irregular==.|l8.irregular==.|l9.irregular==.|l10.irregular==.|l11.irregular==.|l12.irregular==.|l13.irregular==.|l14.irregular==.|l15.irregular==.
replace irreg15yr = 1 if irreg10yr==1
replace irreg15yr = 1 if l11.irregular==1&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace irreg15yr = 1 if l12.irregular==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace irreg15yr = 1 if l13.irregular==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irreg15yr = 1 if l14.irregular==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irreg15yr = 1 if l15.irregular==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen irreg20yr = 0
replace irreg20yr = . if l.irregular==.|l2.irregular==.|l3.irregular==.|l4.irregular==.|l5.irregular==.|l6.irregular==.|l7.irregular==.|l8.irregular==.|l9.irregular==.|l10.irregular==.|l11.irregular==.|l12.irregular==.|l13.irregular==.|l14.irregular==.|l15.irregular==.|l16.irregular==.|l17.irregular==.|l18.irregular==.|l19.irregular==.|l20.irregular==.
replace irreg20yr= 1 if irreg15yr==1
replace irreg20yr= 1 if l16.irregular==1&l15.irregular==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace irreg20yr= 1 if l17.irregular==1&l16.irregular==0&l15.irregular==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace irreg20yr= 1 if l18.irregular==1&l17.irregular==0&l16.irregular==0&l15.irregular==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace irreg20yr= 1 if l19.irregular==1&l18.irregular==0&l17.irregular==0&l16.irregular==0&l15.irregular==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace irreg20yr= 1 if l20.irregular==1&l19.irregular==0&l18.irregular==0&l17.irregular==0&l16.irregular==0&l15.irregular==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 

gen reg5yr = 0
replace reg5yr = . if l.regular==.|l2.regular==.|l3.regular==.|l4.regular==.|l5.regular==.
replace reg5yr= 1 if l.regular==1
replace reg5yr= 1 if l2.regular==1&l.leaderturn==0 
replace reg5yr= 1 if l3.regular==1&l2.leaderturn==0 &l.leaderturn==0  
replace reg5yr= 1 if l4.regular==1&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace reg5yr= 1 if l5.regular==1&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
gen reg10yr = 0
replace reg10yr = . if l.regular==.|l2.regular==.|l3.regular==.|l4.regular==.|l5.regular==.|l6.regular==.|l7.regular==.|l8.regular==.|l9.regular==.|l10.regular==.
replace reg10yr = 1 if reg5yr==1 
replace reg10yr = 1 if l6.regular==1&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0   
replace reg10yr = 1 if l7.regular==1&l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace reg10yr = 1 if l8.regular==1 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace reg10yr = 1 if l9.regular==1 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace reg10yr = 1 if l10.regular==1 &l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen reg15yr = 0
replace reg15yr = . if l.regular==.|l2.regular==.|l3.regular==.|l4.regular==.|l5.regular==.|l6.regular==.|l7.regular==.|l8.regular==.|l9.regular==.|l10.regular==.|l11.regular==.|l12.regular==.|l13.regular==.|l14.regular==.|l15.regular==.
replace reg15yr = 1 if reg10yr==1
replace reg15yr = 1 if l11.regular==1&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace reg15yr = 1 if l12.regular==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace reg15yr = 1 if l13.regular==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace reg15yr = 1 if l14.regular==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace reg15yr = 1 if l15.regular==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen reg20yr = 0
replace reg20yr = . if l.regular==.|l2.regular==.|l3.regular==.|l4.regular==.|l5.regular==.|l6.regular==.|l7.regular==.|l8.regular==.|l9.regular==.|l10.regular==.|l11.regular==.|l12.regular==.|l13.regular==.|l14.regular==.|l15.regular==.|l16.regular==.|l17.regular==.|l18.regular==.|l19.regular==.|l20.regular==.
replace reg20yr= 1 if reg15yr==1
replace reg20yr= 1 if l16.regular==1&l15.regular==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace reg20yr= 1 if l17.regular==1&l16.regular==0&l15.regular==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace reg20yr= 1 if l18.regular==1&l17.regular==0&l16.regular==0&l15.regular==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace reg20yr= 1 if l19.regular==1&l18.regular==0&l17.regular==0&l16.regular==0&l15.regular==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace reg20yr= 1 if l20.regular==1&l19.regular==0&l18.regular==0&l17.regular==0&l16.regular==0&l15.regular==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 

gen natcauses5yr = 0
replace natcauses5yr = . if l.natcauses==.|l2.natcauses==.|l3.natcauses==.|l4.natcauses==.|l5.natcauses==.
replace natcauses5yr= 1 if l.natcauses==1
replace natcauses5yr= 1 if l2.natcauses==1&l.leaderturn==0 
replace natcauses5yr= 1 if l3.natcauses==1&l2.leaderturn==0 &l.leaderturn==0  
replace natcauses5yr= 1 if l4.natcauses==1&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcauses5yr= 1 if l5.natcauses==1&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
gen natcauses10yr = 0
replace natcauses10yr = . if l.natcauses==.|l2.natcauses==.|l3.natcauses==.|l4.natcauses==.|l5.natcauses==.|l6.natcauses==.|l7.natcauses==.|l8.natcauses==.|l9.natcauses==.|l10.natcauses==.
replace natcauses10yr = 1 if natcauses5yr==1 
replace natcauses10yr = 1 if l6.natcauses==1&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0   
replace natcauses10yr = 1 if l7.natcauses==1&l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace natcauses10yr = 1 if l8.natcauses==1 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcauses10yr = 1 if l9.natcauses==1 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcauses10yr = 1 if l10.natcauses==1 &l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen natcauses15yr = 0
replace natcauses15yr = . if l.natcauses==.|l2.natcauses==.|l3.natcauses==.|l4.natcauses==.|l5.natcauses==.|l6.natcauses==.|l7.natcauses==.|l8.natcauses==.|l9.natcauses==.|l10.natcauses==.|l11.natcauses==.|l12.natcauses==.|l13.natcauses==.|l14.natcauses==.|l15.natcauses==.
replace natcauses15yr = 1 if natcauses10yr==1
replace natcauses15yr = 1 if l11.natcauses==1&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace natcauses15yr = 1 if l12.natcauses==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace natcauses15yr = 1 if l13.natcauses==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcauses15yr = 1 if l14.natcauses==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcauses15yr = 1 if l15.natcauses==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen natcauses20yr = 0
replace natcauses20yr = . if l.natcauses==.|l2.natcauses==.|l3.natcauses==.|l4.natcauses==.|l5.natcauses==.|l6.natcauses==.|l7.natcauses==.|l8.natcauses==.|l9.natcauses==.|l10.natcauses==.|l11.natcauses==.|l12.natcauses==.|l13.natcauses==.|l14.natcauses==.|l15.natcauses==.|l16.natcauses==.|l17.natcauses==.|l18.natcauses==.|l19.natcauses==.|l20.natcauses==.
replace natcauses20yr= 1 if natcauses15yr==1
replace natcauses20yr= 1 if l16.natcauses==1&l15.natcauses==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace natcauses20yr= 1 if l17.natcauses==1&l16.natcauses==0&l15.natcauses==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace natcauses20yr= 1 if l18.natcauses==1&l17.natcauses==0&l16.natcauses==0&l15.natcauses==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace natcauses20yr= 1 if l19.natcauses==1&l18.natcauses==0&l17.natcauses==0&l16.natcauses==0&l15.natcauses==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace natcauses20yr= 1 if l20.natcauses==1&l19.natcauses==0&l18.natcauses==0&l17.natcauses==0&l16.natcauses==0&l15.natcauses==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 

gen dep5yr = 0
replace dep5yr = . if l.deposed==.|l2.deposed==.|l3.deposed==.|l4.deposed==.|l5.deposed==.
replace dep5yr= 1 if l.deposed==1
replace dep5yr= 1 if l2.deposed==1&l.leaderturn==0 
replace dep5yr= 1 if l3.deposed==1&l2.leaderturn==0 &l.leaderturn==0  
replace dep5yr= 1 if l4.deposed==1&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace dep5yr= 1 if l5.deposed==1&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
gen dep10yr = 0
replace dep10yr = . if l.deposed==.|l2.deposed==.|l3.deposed==.|l4.deposed==.|l5.deposed==.|l6.deposed==.|l7.deposed==.|l8.deposed==.|l9.deposed==.|l10.deposed==.
replace dep10yr = 1 if dep5yr==1 
replace dep10yr = 1 if l6.deposed==1&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0   
replace dep10yr = 1 if l7.deposed==1&l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace dep10yr = 1 if l8.deposed==1 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace dep10yr = 1 if l9.deposed==1 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace dep10yr = 1 if l10.deposed==1 &l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen dep15yr = 0
replace dep15yr = . if l.deposed==.|l2.deposed==.|l3.deposed==.|l4.deposed==.|l5.deposed==.|l6.deposed==.|l7.deposed==.|l8.deposed==.|l9.deposed==.|l10.deposed==.|l11.deposed==.|l12.deposed==.|l13.deposed==.|l14.deposed==.|l15.deposed==.
replace dep15yr = 1 if dep10yr==1
replace dep15yr = 1 if l11.deposed==1&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace dep15yr = 1 if l12.deposed==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace dep15yr = 1 if l13.deposed==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace dep15yr = 1 if l14.deposed==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace dep15yr = 1 if l15.deposed==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen dep20yr = 0
replace dep20yr = . if l.deposed==.|l2.deposed==.|l3.deposed==.|l4.deposed==.|l5.deposed==.|l6.deposed==.|l7.deposed==.|l8.deposed==.|l9.deposed==.|l10.deposed==.|l11.deposed==.|l12.deposed==.|l13.deposed==.|l14.deposed==.|l15.deposed==.|l16.deposed==.|l17.deposed==.|l18.deposed==.|l19.deposed==.|l20.deposed==.
replace dep20yr= 1 if dep15yr==1
replace dep20yr= 1 if l16.deposed==1&l15.deposed==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace dep20yr= 1 if l17.deposed==1&l16.deposed==0&l15.deposed==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace dep20yr= 1 if l18.deposed==1&l17.deposed==0&l16.deposed==0&l15.deposed==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace dep20yr= 1 if l19.deposed==1&l18.deposed==0&l17.deposed==0&l16.deposed==0&l15.deposed==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace dep20yr= 1 if l20.deposed==1&l19.deposed==0&l18.deposed==0&l17.deposed==0&l16.deposed==0&l15.deposed==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 

gen ret5yr = 0
replace ret5yr = . if l.retired==.|l2.retired==.|l3.retired==.|l4.retired==.|l5.retired==.
replace ret5yr= 1 if l.retired==1
replace ret5yr= 1 if l2.retired==1&l.leaderturn==0 
replace ret5yr= 1 if l3.retired==1&l2.leaderturn==0 &l.leaderturn==0  
replace ret5yr= 1 if l4.retired==1&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace ret5yr= 1 if l5.retired==1&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
gen ret10yr = 0
replace ret10yr = . if l.retired==.|l2.retired==.|l3.retired==.|l4.retired==.|l5.retired==.|l6.retired==.|l7.retired==.|l8.retired==.|l9.retired==.|l10.retired==.
replace ret10yr = 1 if ret5yr==1 
replace ret10yr = 1 if l6.retired==1&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0   
replace ret10yr = 1 if l7.retired==1&l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace ret10yr = 1 if l8.retired==1 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace ret10yr = 1 if l9.retired==1 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace ret10yr = 1 if l10.retired==1 &l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen ret15yr = 0
replace ret15yr = . if l.retired==.|l2.retired==.|l3.retired==.|l4.retired==.|l5.retired==.|l6.retired==.|l7.retired==.|l8.retired==.|l9.retired==.|l10.retired==.|l11.retired==.|l12.retired==.|l13.retired==.|l14.retired==.|l15.retired==.
replace ret15yr = 1 if ret10yr==1
replace ret15yr = 1 if l11.retired==1&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace ret15yr = 1 if l12.retired==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace ret15yr = 1 if l13.retired==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace ret15yr = 1 if l14.retired==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace ret15yr = 1 if l15.retired==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen ret20yr = 0
replace ret20yr = . if l.retired==.|l2.retired==.|l3.retired==.|l4.retired==.|l5.retired==.|l6.retired==.|l7.retired==.|l8.retired==.|l9.retired==.|l10.retired==.|l11.retired==.|l12.retired==.|l13.retired==.|l14.retired==.|l15.retired==.|l16.retired==.|l17.retired==.|l18.retired==.|l19.retired==.|l20.retired==.
replace ret20yr= 1 if ret15yr==1
replace ret20yr= 1 if l16.retired==1&l15.retired==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace ret20yr= 1 if l17.retired==1&l16.retired==0&l15.retired==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace ret20yr= 1 if l18.retired==1&l17.retired==0&l16.retired==0&l15.retired==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace ret20yr= 1 if l19.retired==1&l18.retired==0&l17.retired==0&l16.retired==0&l15.retired==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace ret20yr= 1 if l20.retired==1&l19.retired==0&l18.retired==0&l17.retired==0&l16.retired==0&l15.retired==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 

gen sui5yr = 0
replace sui5yr = . if l.suicide==.|l2.suicide==.|l3.suicide==.|l4.suicide==.|l5.suicide==.
replace sui5yr= 1 if l.suicide==1
replace sui5yr= 1 if l2.suicide==1&l.leaderturn==0 
replace sui5yr= 1 if l3.suicide==1&l2.leaderturn==0 &l.leaderturn==0  
replace sui5yr= 1 if l4.suicide==1&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace sui5yr= 1 if l5.suicide==1&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
gen sui10yr = 0
replace sui10yr = . if l.suicide==.|l2.suicide==.|l3.suicide==.|l4.suicide==.|l5.suicide==.|l6.suicide==.|l7.suicide==.|l8.suicide==.|l9.suicide==.|l10.suicide==.
replace sui10yr = 1 if sui5yr==1 
replace sui10yr = 1 if l6.suicide==1&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0   
replace sui10yr = 1 if l7.suicide==1&l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace sui10yr = 1 if l8.suicide==1 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace sui10yr = 1 if l9.suicide==1 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace sui10yr = 1 if l10.suicide==1 &l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen sui15yr = 0
replace sui15yr = . if l.suicide==.|l2.suicide==.|l3.suicide==.|l4.suicide==.|l5.suicide==.|l6.suicide==.|l7.suicide==.|l8.suicide==.|l9.suicide==.|l10.suicide==.|l11.suicide==.|l12.suicide==.|l13.suicide==.|l14.suicide==.|l15.suicide==.
replace sui15yr = 1 if sui10yr==1
replace sui15yr = 1 if l11.suicide==1&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace sui15yr = 1 if l12.suicide==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace sui15yr = 1 if l13.suicide==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace sui15yr = 1 if l14.suicide==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace sui15yr = 1 if l15.suicide==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
gen sui20yr = 0
replace sui20yr = . if l.suicide==.|l2.suicide==.|l3.suicide==.|l4.suicide==.|l5.suicide==.|l6.suicide==.|l7.suicide==.|l8.suicide==.|l9.suicide==.|l10.suicide==.|l11.suicide==.|l12.suicide==.|l13.suicide==.|l14.suicide==.|l15.suicide==.|l16.suicide==.|l17.suicide==.|l18.suicide==.|l19.suicide==.|l20.suicide==.
replace sui20yr= 1 if sui15yr==1
replace sui20yr= 1 if l16.suicide==1&l15.suicide==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace sui20yr= 1 if l17.suicide==1&l16.suicide==0&l15.suicide==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace sui20yr= 1 if l18.suicide==1&l17.suicide==0&l16.suicide==0&l15.suicide==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace sui20yr= 1 if l19.suicide==1&l18.suicide==0&l17.suicide==0&l16.suicide==0&l15.suicide==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace sui20yr= 1 if l20.suicide==1&l19.suicide==0&l18.suicide==0&l17.suicide==0&l16.suicide==0&l15.suicide==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 

gen irregdiff5 = irreg5yr
*i.e. start from variable in which irreg5 = 1 only if there was irreg turnover in the period followed by no further years of leader turnover
replace irregdiff5=0 if pol2norm>l5.pol2norm&irregdiff5~=.
*If no net increase in pol2norm during period, leave irreg5 as it is. If there was a net increase in pol2norm during period, need to recode, so start by setting it at 0 (unless it was . in which case leave it as .
replace irregdiff5 = 1 if l5.irregular==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
*1 if there was irregular turnover in l5 and the net change in pol2norm after that in the period is positive AND no further leader change in period
replace irregdiff5 = 1 if l5.irregular==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
*1 if there was irregular turnover in l5 and there's net increase in pol2norm between l6 and present and pol2norm rose between l6 and l5 and the irregular leader change came in period l5 BEFORE the polity2 increase that yearAND no further leader change in period
replace irregdiff5 = 1 if l4.irregular==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff5 = 1 if l4.irregular==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff5 = 1 if l3.irregular==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff5 = 1 if l3.irregular==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff5 = 1 if l2.irregular==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace irregdiff5 = 1 if l2.irregular==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace irregdiff5 = 1 if l.irregular==1& pol2norm>l.pol2norm 
replace irregdiff5 = 1 if l.irregular==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen irregdiff10 = irreg10yr
replace irregdiff10=0 if pol2norm>l10.pol2norm&irregdiff10~=.
replace irregdiff10 = 1 if l10.irregular==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff10 = 1 if l10.irregular==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff10 = 1 if l9.irregular==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff10 = 1 if l9.irregular==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff10 = 1 if l8.irregular==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff10 = 1 if l8.irregular==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff10 = 1 if l7.irregular==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff10 = 1 if l7.irregular==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff10 = 1 if l6.irregular==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff10 = 1 if l6.irregular==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff10 = 1 if l5.irregular==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff10 = 1 if l5.irregular==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff10 = 1 if l4.irregular==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff10 = 1 if l4.irregular==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff10 = 1 if l3.irregular==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff10 = 1 if l3.irregular==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff10 = 1 if l2.irregular==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace irregdiff10 = 1 if l2.irregular==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace irregdiff10 = 1 if l.irregular==1& pol2norm>l.pol2norm 
replace irregdiff10 = 1 if l.irregular==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen irregdiff15 = irreg15yr
replace irregdiff15=0 if pol2norm>l15.pol2norm&irregdiff15~=.
replace irregdiff15 = 1 if l15.irregular==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff15 = 1 if l15.irregular==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l14.irregular==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff15 = 1 if l14.irregular==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l13.irregular==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff15 = 1 if l13.irregular==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l12.irregular==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff15 = 1 if l12.irregular==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l11.irregular==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace irregdiff15 = 1 if l11.irregular==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l10.irregular==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff15 = 1 if l10.irregular==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l9.irregular==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff15 = 1 if l9.irregular==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l8.irregular==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff15 = 1 if l8.irregular==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l7.irregular==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff15 = 1 if l7.irregular==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l6.irregular==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff15 = 1 if l6.irregular==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l5.irregular==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l5.irregular==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l4.irregular==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l4.irregular==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l3.irregular==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l3.irregular==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff15 = 1 if l2.irregular==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace irregdiff15 = 1 if l2.irregular==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace irregdiff15 = 1 if l.irregular==1& pol2norm>l.pol2norm 
replace irregdiff15 = 1 if l.irregular==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen irregdiff20 = irreg20yr
replace irregdiff20=0 if pol2norm>l20.pol2norm&irregdiff20~=.
replace irregdiff20 = 1 if l20.irregular==1& pol2norm>l20.pol2norm&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l20.irregular==1& pol2norm>l21.pol2norm&l20.pol2norm>l21.pol2norm&l20.ltfirst2==1&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l19.irregular==1& pol2norm>l19.pol2norm&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace irregdiff20 = 1 if l19.irregular==1& pol2norm>l20.pol2norm&l19.pol2norm>l20.pol2norm&l19.ltfirst2==1&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l18.irregular==1& pol2norm>l18.pol2norm&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l18.irregular==1& pol2norm>l19.pol2norm&l18.pol2norm>l19.pol2norm&l18.ltfirst2==1&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l17.irregular==1& pol2norm>l17.pol2norm&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l17.irregular==1& pol2norm>l18.pol2norm&l17.pol2norm>l18.pol2norm&l17.ltfirst2==1&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l16.irregular==1& pol2norm>l16.pol2norm&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace irregdiff20 = 1 if l16.irregular==1& pol2norm>l17.pol2norm&l16.pol2norm>l17.pol2norm&l16.ltfirst2==1&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l15.irregular==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l15.irregular==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l14.irregular==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l14.irregular==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l13.irregular==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l13.irregular==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l12.irregular==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l12.irregular==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l11.irregular==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace irregdiff20 = 1 if l11.irregular==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l10.irregular==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l10.irregular==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l9.irregular==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l9.irregular==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l8.irregular==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l8.irregular==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l7.irregular==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l7.irregular==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l6.irregular==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace irregdiff20 = 1 if l6.irregular==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l5.irregular==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l5.irregular==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l4.irregular==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l4.irregular==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l3.irregular==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l3.irregular==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace irregdiff20 = 1 if l2.irregular==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace irregdiff20 = 1 if l2.irregular==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace irregdiff20 = 1 if l.irregular==1& pol2norm>l.pol2norm 
replace irregdiff20 = 1 if l.irregular==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen regdiff5 = reg5yr
replace regdiff5=0 if pol2norm>l5.pol2norm&regdiff5~=.
replace regdiff5 = 1 if l5.regular==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff5 = 1 if l5.regular==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff5 = 1 if l4.regular==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff5 = 1 if l4.regular==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff5 = 1 if l3.regular==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff5 = 1 if l3.regular==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff5 = 1 if l2.regular==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace regdiff5 = 1 if l2.regular==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace regdiff5 = 1 if l.regular==1& pol2norm>l.pol2norm 
replace regdiff5 = 1 if l.regular==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen regdiff10 = reg10yr
replace regdiff10=0 if pol2norm>l10.pol2norm&regdiff10~=.
replace regdiff10 = 1 if l10.regular==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff10 = 1 if l10.regular==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff10 = 1 if l9.regular==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff10 = 1 if l9.regular==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff10 = 1 if l8.regular==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff10 = 1 if l8.regular==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff10 = 1 if l7.regular==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff10 = 1 if l7.regular==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff10 = 1 if l6.regular==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff10 = 1 if l6.regular==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff10 = 1 if l5.regular==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff10 = 1 if l5.regular==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff10 = 1 if l4.regular==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff10 = 1 if l4.regular==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff10 = 1 if l3.regular==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff10 = 1 if l3.regular==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff10 = 1 if l2.regular==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace regdiff10 = 1 if l2.regular==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace regdiff10 = 1 if l.regular==1& pol2norm>l.pol2norm 
replace regdiff10 = 1 if l.regular==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen regdiff15 = reg15yr
replace regdiff15=0 if pol2norm>l15.pol2norm&regdiff15~=.
replace regdiff15 = 1 if l15.regular==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff15 = 1 if l15.regular==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l14.regular==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff15 = 1 if l14.regular==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l13.regular==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff15 = 1 if l13.regular==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l12.regular==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff15 = 1 if l12.regular==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l11.regular==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace regdiff15 = 1 if l11.regular==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l10.regular==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff15 = 1 if l10.regular==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l9.regular==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff15 = 1 if l9.regular==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l8.regular==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff15 = 1 if l8.regular==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l7.regular==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff15 = 1 if l7.regular==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l6.regular==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff15 = 1 if l6.regular==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l5.regular==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l5.regular==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l4.regular==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l4.regular==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l3.regular==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l3.regular==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff15 = 1 if l2.regular==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace regdiff15 = 1 if l2.regular==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace regdiff15 = 1 if l.regular==1& pol2norm>l.pol2norm 
replace regdiff15 = 1 if l.regular==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen regdiff20 = reg20yr
replace regdiff20=0 if pol2norm>l20.pol2norm&regdiff20~=.
replace regdiff20 = 1 if l20.regular==1& pol2norm>l20.pol2norm&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l20.regular==1& pol2norm>l21.pol2norm&l20.pol2norm>l21.pol2norm&l20.ltfirst2==1&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l19.regular==1& pol2norm>l19.pol2norm&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace regdiff20 = 1 if l19.regular==1& pol2norm>l20.pol2norm&l19.pol2norm>l20.pol2norm&l19.ltfirst2==1&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l18.regular==1& pol2norm>l18.pol2norm&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l18.regular==1& pol2norm>l19.pol2norm&l18.pol2norm>l19.pol2norm&l18.ltfirst2==1&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l17.regular==1& pol2norm>l17.pol2norm&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l17.regular==1& pol2norm>l18.pol2norm&l17.pol2norm>l18.pol2norm&l17.ltfirst2==1&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l16.regular==1& pol2norm>l16.pol2norm&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace regdiff20 = 1 if l16.regular==1& pol2norm>l17.pol2norm&l16.pol2norm>l17.pol2norm&l16.ltfirst2==1&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l15.regular==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l15.regular==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l14.regular==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l14.regular==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l13.regular==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l13.regular==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l12.regular==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l12.regular==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l11.regular==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace regdiff20 = 1 if l11.regular==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l10.regular==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l10.regular==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l9.regular==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l9.regular==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l8.regular==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l8.regular==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l7.regular==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l7.regular==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l6.regular==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace regdiff20 = 1 if l6.regular==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l5.regular==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l5.regular==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l4.regular==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l4.regular==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l3.regular==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l3.regular==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace regdiff20 = 1 if l2.regular==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace regdiff20 = 1 if l2.regular==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace regdiff20 = 1 if l.regular==1& pol2norm>l.pol2norm 
replace regdiff20 = 1 if l.regular==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen natcausesdiff5 = natcauses5yr
replace natcausesdiff5=0 if pol2norm>l5.pol2norm&natcausesdiff5~=.
replace natcausesdiff5 = 1 if l5.natcauses==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff5 = 1 if l5.natcauses==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff5 = 1 if l4.natcauses==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff5 = 1 if l4.natcauses==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff5 = 1 if l3.natcauses==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff5 = 1 if l3.natcauses==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff5 = 1 if l2.natcauses==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace natcausesdiff5 = 1 if l2.natcauses==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace natcausesdiff5 = 1 if l.natcauses==1& pol2norm>l.pol2norm 
replace natcausesdiff5 = 1 if l.natcauses==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen natcausesdiff10 = natcauses10yr
replace natcausesdiff10=0 if pol2norm>l10.pol2norm&natcausesdiff10~=.
replace natcausesdiff10 = 1 if l10.natcauses==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff10 = 1 if l10.natcauses==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff10 = 1 if l9.natcauses==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff10 = 1 if l9.natcauses==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff10 = 1 if l8.natcauses==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff10 = 1 if l8.natcauses==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff10 = 1 if l7.natcauses==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff10 = 1 if l7.natcauses==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff10 = 1 if l6.natcauses==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff10 = 1 if l6.natcauses==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff10 = 1 if l5.natcauses==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff10 = 1 if l5.natcauses==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff10 = 1 if l4.natcauses==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff10 = 1 if l4.natcauses==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff10 = 1 if l3.natcauses==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff10 = 1 if l3.natcauses==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff10 = 1 if l2.natcauses==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace natcausesdiff10 = 1 if l2.natcauses==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace natcausesdiff10 = 1 if l.natcauses==1& pol2norm>l.pol2norm 
replace natcausesdiff10 = 1 if l.natcauses==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen natcausesdiff15 = natcauses15yr
replace natcausesdiff15=0 if pol2norm>l15.pol2norm&natcausesdiff15~=.
replace natcausesdiff15 = 1 if l15.natcauses==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff15 = 1 if l15.natcauses==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l14.natcauses==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff15 = 1 if l14.natcauses==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l13.natcauses==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff15 = 1 if l13.natcauses==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l12.natcauses==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff15 = 1 if l12.natcauses==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l11.natcauses==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace natcausesdiff15 = 1 if l11.natcauses==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l10.natcauses==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff15 = 1 if l10.natcauses==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l9.natcauses==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff15 = 1 if l9.natcauses==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l8.natcauses==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff15 = 1 if l8.natcauses==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l7.natcauses==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff15 = 1 if l7.natcauses==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l6.natcauses==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff15 = 1 if l6.natcauses==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l5.natcauses==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l5.natcauses==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l4.natcauses==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l4.natcauses==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l3.natcauses==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l3.natcauses==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff15 = 1 if l2.natcauses==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace natcausesdiff15 = 1 if l2.natcauses==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace natcausesdiff15 = 1 if l.natcauses==1& pol2norm>l.pol2norm 
replace natcausesdiff15 = 1 if l.natcauses==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen natcausesdiff20 = natcauses20yr
replace natcausesdiff20=0 if pol2norm>l20.pol2norm&natcausesdiff20~=.
replace natcausesdiff20 = 1 if l20.natcauses==1& pol2norm>l20.pol2norm&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l20.natcauses==1& pol2norm>l21.pol2norm&l20.pol2norm>l21.pol2norm&l20.ltfirst2==1&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l19.natcauses==1& pol2norm>l19.pol2norm&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace natcausesdiff20 = 1 if l19.natcauses==1& pol2norm>l20.pol2norm&l19.pol2norm>l20.pol2norm&l19.ltfirst2==1&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l18.natcauses==1& pol2norm>l18.pol2norm&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l18.natcauses==1& pol2norm>l19.pol2norm&l18.pol2norm>l19.pol2norm&l18.ltfirst2==1&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l17.natcauses==1& pol2norm>l17.pol2norm&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l17.natcauses==1& pol2norm>l18.pol2norm&l17.pol2norm>l18.pol2norm&l17.ltfirst2==1&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l16.natcauses==1& pol2norm>l16.pol2norm&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace natcausesdiff20 = 1 if l16.natcauses==1& pol2norm>l17.pol2norm&l16.pol2norm>l17.pol2norm&l16.ltfirst2==1&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l15.natcauses==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l15.natcauses==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l14.natcauses==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l14.natcauses==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l13.natcauses==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l13.natcauses==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l12.natcauses==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l12.natcauses==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l11.natcauses==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace natcausesdiff20 = 1 if l11.natcauses==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l10.natcauses==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l10.natcauses==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l9.natcauses==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l9.natcauses==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l8.natcauses==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l8.natcauses==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l7.natcauses==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l7.natcauses==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l6.natcauses==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace natcausesdiff20 = 1 if l6.natcauses==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l5.natcauses==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l5.natcauses==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l4.natcauses==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l4.natcauses==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l3.natcauses==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l3.natcauses==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace natcausesdiff20 = 1 if l2.natcauses==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace natcausesdiff20 = 1 if l2.natcauses==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace natcausesdiff20 = 1 if l.natcauses==1& pol2norm>l.pol2norm 
replace natcausesdiff20 = 1 if l.natcauses==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen depdiff5 = dep5yr
replace depdiff5=0 if pol2norm>l5.pol2norm&depdiff5~=.
replace depdiff5 = 1 if l5.deposed==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff5 = 1 if l5.deposed==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff5 = 1 if l4.deposed==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff5 = 1 if l4.deposed==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff5 = 1 if l3.deposed==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff5 = 1 if l3.deposed==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff5 = 1 if l2.deposed==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace depdiff5 = 1 if l2.deposed==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace depdiff5 = 1 if l.deposed==1& pol2norm>l.pol2norm 
replace depdiff5 = 1 if l.deposed==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen depdiff10 = dep10yr
replace depdiff10=0 if pol2norm>l10.pol2norm&depdiff10~=.
replace depdiff10 = 1 if l10.deposed==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff10 = 1 if l10.deposed==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff10 = 1 if l9.deposed==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff10 = 1 if l9.deposed==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff10 = 1 if l8.deposed==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff10 = 1 if l8.deposed==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff10 = 1 if l7.deposed==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff10 = 1 if l7.deposed==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff10 = 1 if l6.deposed==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff10 = 1 if l6.deposed==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff10 = 1 if l5.deposed==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff10 = 1 if l5.deposed==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff10 = 1 if l4.deposed==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff10 = 1 if l4.deposed==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff10 = 1 if l3.deposed==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff10 = 1 if l3.deposed==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff10 = 1 if l2.deposed==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace depdiff10 = 1 if l2.deposed==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace depdiff10 = 1 if l.deposed==1& pol2norm>l.pol2norm 
replace depdiff10 = 1 if l.deposed==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen depdiff15 = dep15yr
replace depdiff15=0 if pol2norm>l15.pol2norm&depdiff15~=.
replace depdiff15 = 1 if l15.deposed==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff15 = 1 if l15.deposed==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l14.deposed==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff15 = 1 if l14.deposed==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l13.deposed==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff15 = 1 if l13.deposed==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l12.deposed==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff15 = 1 if l12.deposed==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l11.deposed==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace depdiff15 = 1 if l11.deposed==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l10.deposed==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff15 = 1 if l10.deposed==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l9.deposed==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff15 = 1 if l9.deposed==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l8.deposed==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff15 = 1 if l8.deposed==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l7.deposed==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff15 = 1 if l7.deposed==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l6.deposed==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff15 = 1 if l6.deposed==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l5.deposed==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l5.deposed==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l4.deposed==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l4.deposed==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l3.deposed==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l3.deposed==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff15 = 1 if l2.deposed==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace depdiff15 = 1 if l2.deposed==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace depdiff15 = 1 if l.deposed==1& pol2norm>l.pol2norm 
replace depdiff15 = 1 if l.deposed==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen depdiff20 = dep20yr
replace depdiff20=0 if pol2norm>l20.pol2norm&depdiff20~=.
replace depdiff20 = 1 if l20.deposed==1& pol2norm>l20.pol2norm&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l20.deposed==1& pol2norm>l21.pol2norm&l20.pol2norm>l21.pol2norm&l20.ltfirst2==1&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l19.deposed==1& pol2norm>l19.pol2norm&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace depdiff20 = 1 if l19.deposed==1& pol2norm>l20.pol2norm&l19.pol2norm>l20.pol2norm&l19.ltfirst2==1&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l18.deposed==1& pol2norm>l18.pol2norm&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l18.deposed==1& pol2norm>l19.pol2norm&l18.pol2norm>l19.pol2norm&l18.ltfirst2==1&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l17.deposed==1& pol2norm>l17.pol2norm&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l17.deposed==1& pol2norm>l18.pol2norm&l17.pol2norm>l18.pol2norm&l17.ltfirst2==1&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l16.deposed==1& pol2norm>l16.pol2norm&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace depdiff20 = 1 if l16.deposed==1& pol2norm>l17.pol2norm&l16.pol2norm>l17.pol2norm&l16.ltfirst2==1&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l15.deposed==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l15.deposed==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l14.deposed==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l14.deposed==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l13.deposed==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l13.deposed==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l12.deposed==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l12.deposed==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l11.deposed==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace depdiff20 = 1 if l11.deposed==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l10.deposed==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l10.deposed==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l9.deposed==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l9.deposed==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l8.deposed==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l8.deposed==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l7.deposed==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l7.deposed==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l6.deposed==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace depdiff20 = 1 if l6.deposed==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l5.deposed==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l5.deposed==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l4.deposed==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l4.deposed==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l3.deposed==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l3.deposed==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace depdiff20 = 1 if l2.deposed==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace depdiff20 = 1 if l2.deposed==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace depdiff20 = 1 if l.deposed==1& pol2norm>l.pol2norm 
replace depdiff20 = 1 if l.deposed==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen retdiff5 = ret5yr
replace retdiff5=0 if pol2norm>l5.pol2norm&retdiff5~=.
replace retdiff5 = 1 if l5.retired==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff5 = 1 if l5.retired==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff5 = 1 if l4.retired==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff5 = 1 if l4.retired==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff5 = 1 if l3.retired==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff5 = 1 if l3.retired==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff5 = 1 if l2.retired==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace retdiff5 = 1 if l2.retired==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace retdiff5 = 1 if l.retired==1& pol2norm>l.pol2norm 
replace retdiff5 = 1 if l.retired==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen retdiff10 = ret10yr
replace retdiff10=0 if pol2norm>l10.pol2norm&retdiff10~=.
replace retdiff10 = 1 if l10.retired==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff10 = 1 if l10.retired==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff10 = 1 if l9.retired==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff10 = 1 if l9.retired==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff10 = 1 if l8.retired==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff10 = 1 if l8.retired==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff10 = 1 if l7.retired==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff10 = 1 if l7.retired==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff10 = 1 if l6.retired==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff10 = 1 if l6.retired==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff10 = 1 if l5.retired==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff10 = 1 if l5.retired==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff10 = 1 if l4.retired==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff10 = 1 if l4.retired==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff10 = 1 if l3.retired==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff10 = 1 if l3.retired==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff10 = 1 if l2.retired==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace retdiff10 = 1 if l2.retired==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace retdiff10 = 1 if l.retired==1& pol2norm>l.pol2norm 
replace retdiff10 = 1 if l.retired==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen retdiff15 = ret15yr
replace retdiff15=0 if pol2norm>l15.pol2norm&retdiff15~=.
replace retdiff15 = 1 if l15.retired==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff15 = 1 if l15.retired==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l14.retired==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff15 = 1 if l14.retired==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l13.retired==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff15 = 1 if l13.retired==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l12.retired==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff15 = 1 if l12.retired==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l11.retired==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace retdiff15 = 1 if l11.retired==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l10.retired==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff15 = 1 if l10.retired==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l9.retired==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff15 = 1 if l9.retired==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l8.retired==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff15 = 1 if l8.retired==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l7.retired==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff15 = 1 if l7.retired==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l6.retired==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff15 = 1 if l6.retired==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l5.retired==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l5.retired==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l4.retired==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l4.retired==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l3.retired==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l3.retired==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff15 = 1 if l2.retired==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace retdiff15 = 1 if l2.retired==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace retdiff15 = 1 if l.retired==1& pol2norm>l.pol2norm 
replace retdiff15 = 1 if l.retired==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen retdiff20 = ret20yr
replace retdiff20=0 if pol2norm>l20.pol2norm&retdiff20~=.
replace retdiff20 = 1 if l20.retired==1& pol2norm>l20.pol2norm&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l20.retired==1& pol2norm>l21.pol2norm&l20.pol2norm>l21.pol2norm&l20.ltfirst2==1&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l19.retired==1& pol2norm>l19.pol2norm&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace retdiff20 = 1 if l19.retired==1& pol2norm>l20.pol2norm&l19.pol2norm>l20.pol2norm&l19.ltfirst2==1&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l18.retired==1& pol2norm>l18.pol2norm&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l18.retired==1& pol2norm>l19.pol2norm&l18.pol2norm>l19.pol2norm&l18.ltfirst2==1&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l17.retired==1& pol2norm>l17.pol2norm&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l17.retired==1& pol2norm>l18.pol2norm&l17.pol2norm>l18.pol2norm&l17.ltfirst2==1&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l16.retired==1& pol2norm>l16.pol2norm&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace retdiff20 = 1 if l16.retired==1& pol2norm>l17.pol2norm&l16.pol2norm>l17.pol2norm&l16.ltfirst2==1&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l15.retired==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l15.retired==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l14.retired==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l14.retired==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l13.retired==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l13.retired==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l12.retired==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l12.retired==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l11.retired==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace retdiff20 = 1 if l11.retired==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l10.retired==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l10.retired==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l9.retired==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l9.retired==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l8.retired==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l8.retired==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l7.retired==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l7.retired==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l6.retired==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace retdiff20 = 1 if l6.retired==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l5.retired==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l5.retired==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l4.retired==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l4.retired==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l3.retired==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l3.retired==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace retdiff20 = 1 if l2.retired==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace retdiff20 = 1 if l2.retired==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace retdiff20 = 1 if l.retired==1& pol2norm>l.pol2norm 
replace retdiff20 = 1 if l.retired==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen suidiff5 = sui5yr
replace suidiff5=0 if pol2norm>l5.pol2norm&suidiff5~=.
replace suidiff5 = 1 if l5.suicide==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff5 = 1 if l5.suicide==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff5 = 1 if l4.suicide==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff5 = 1 if l4.suicide==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff5 = 1 if l3.suicide==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff5 = 1 if l3.suicide==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff5 = 1 if l2.suicide==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace suidiff5 = 1 if l2.suicide==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace suidiff5 = 1 if l.suicide==1& pol2norm>l.pol2norm 
replace suidiff5 = 1 if l.suicide==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen suidiff10 = sui10yr
replace suidiff10=0 if pol2norm>l10.pol2norm&suidiff10~=.
replace suidiff10 = 1 if l10.suicide==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff10 = 1 if l10.suicide==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff10 = 1 if l9.suicide==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff10 = 1 if l9.suicide==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff10 = 1 if l8.suicide==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff10 = 1 if l8.suicide==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff10 = 1 if l7.suicide==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff10 = 1 if l7.suicide==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff10 = 1 if l6.suicide==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff10 = 1 if l6.suicide==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff10 = 1 if l5.suicide==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff10 = 1 if l5.suicide==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff10 = 1 if l4.suicide==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff10 = 1 if l4.suicide==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff10 = 1 if l3.suicide==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff10 = 1 if l3.suicide==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff10 = 1 if l2.suicide==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace suidiff10 = 1 if l2.suicide==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace suidiff10 = 1 if l.suicide==1& pol2norm>l.pol2norm 
replace suidiff10 = 1 if l.suicide==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen suidiff15 = sui15yr
replace suidiff15=0 if pol2norm>l15.pol2norm&suidiff15~=.
replace suidiff15 = 1 if l15.suicide==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff15 = 1 if l15.suicide==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l14.suicide==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff15 = 1 if l14.suicide==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l13.suicide==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff15 = 1 if l13.suicide==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l12.suicide==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff15 = 1 if l12.suicide==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l11.suicide==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace suidiff15 = 1 if l11.suicide==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l10.suicide==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff15 = 1 if l10.suicide==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l9.suicide==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff15 = 1 if l9.suicide==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l8.suicide==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff15 = 1 if l8.suicide==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l7.suicide==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff15 = 1 if l7.suicide==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l6.suicide==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff15 = 1 if l6.suicide==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l5.suicide==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l5.suicide==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l4.suicide==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l4.suicide==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l3.suicide==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l3.suicide==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff15 = 1 if l2.suicide==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace suidiff15 = 1 if l2.suicide==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace suidiff15 = 1 if l.suicide==1& pol2norm>l.pol2norm 
replace suidiff15 = 1 if l.suicide==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  

gen suidiff20 = sui20yr
replace suidiff20=0 if pol2norm>l20.pol2norm&suidiff20~=.
replace suidiff20 = 1 if l20.suicide==1& pol2norm>l20.pol2norm&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l20.suicide==1& pol2norm>l21.pol2norm&l20.pol2norm>l21.pol2norm&l20.ltfirst2==1&l19.leaderturn==0&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l19.suicide==1& pol2norm>l19.pol2norm&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace suidiff20 = 1 if l19.suicide==1& pol2norm>l20.pol2norm&l19.pol2norm>l20.pol2norm&l19.ltfirst2==1&l18.leaderturn==0&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l18.suicide==1& pol2norm>l18.pol2norm&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l18.suicide==1& pol2norm>l19.pol2norm&l18.pol2norm>l19.pol2norm&l18.ltfirst2==1&l17.leaderturn==0&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l17.suicide==1& pol2norm>l17.pol2norm&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l17.suicide==1& pol2norm>l18.pol2norm&l17.pol2norm>l18.pol2norm&l17.ltfirst2==1&l16.leaderturn==0&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l16.suicide==1& pol2norm>l16.pol2norm&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace suidiff20 = 1 if l16.suicide==1& pol2norm>l17.pol2norm&l16.pol2norm>l17.pol2norm&l16.ltfirst2==1&l15.leaderturn==0&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l15.suicide==1& pol2norm>l15.pol2norm&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l15.suicide==1& pol2norm>l16.pol2norm&l15.pol2norm>l16.pol2norm&l15.ltfirst2==1&l14.leaderturn==0&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l14.suicide==1& pol2norm>l14.pol2norm &l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l14.suicide==1& pol2norm>l15.pol2norm&l14.pol2norm>l15.pol2norm&l14.ltfirst2==1&l13.leaderturn==0&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l13.suicide==1& pol2norm>l13.pol2norm&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l13.suicide==1& pol2norm>l14.pol2norm&l13.pol2norm>l14.pol2norm&l13.ltfirst2==1&l12.leaderturn==0&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l12.suicide==1& pol2norm>l12.pol2norm &l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l12.suicide==1& pol2norm>l13.pol2norm&l12.pol2norm>l13.pol2norm&l12.ltfirst2==1&l11.leaderturn==0&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l11.suicide==1& pol2norm>l11.pol2norm&l10.leaderturn==0&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0 
replace suidiff20 = 1 if l11.suicide==1& pol2norm>l12.pol2norm&l11.pol2norm>l12.pol2norm&l11.ltfirst2==1&l10.leaderturn==0&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l10.suicide==1& pol2norm>l10.pol2norm&l9.leaderturn==0 &l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l10.suicide==1& pol2norm>l11.pol2norm&l10.pol2norm>l11.pol2norm&l10.ltfirst2==1&l9.leaderturn==0 & l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l9.suicide==1& pol2norm>l9.pol2norm& l8.leaderturn==0 &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l9.suicide==1& pol2norm>l10.pol2norm&l9.pol2norm>l10.pol2norm&l9.ltfirst2==1& l8.leaderturn==0&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l8.suicide==1& pol2norm>l8.pol2norm &l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l8.suicide==1& pol2norm>l9.pol2norm&l8.pol2norm>l9.pol2norm&l8.ltfirst2==1&l7.leaderturn==0 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l7.suicide==1& pol2norm>l7.pol2norm &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l7.suicide==1& pol2norm>l8.pol2norm&l7.pol2norm>l8.pol2norm&l7.ltfirst2==1 &l6.leaderturn==0 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l6.suicide==1& pol2norm>l6.pol2norm&l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0
replace suidiff20 = 1 if l6.suicide==1& pol2norm>l7.pol2norm&l6.pol2norm>l7.pol2norm&l6.ltfirst2==1 &l5.leaderturn==0 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l5.suicide==1& pol2norm>l5.pol2norm&l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l5.suicide==1& pol2norm>l6.pol2norm&l5.pol2norm>l6.pol2norm&l5.ltfirst2==1 &l4.leaderturn==0 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l4.suicide==1& pol2norm>l4.pol2norm&l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l4.suicide==1& pol2norm>l5.pol2norm&l4.pol2norm>l5.pol2norm&l4.ltfirst2==1 &l3.leaderturn==0 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l3.suicide==1& pol2norm>l3.pol2norm &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l3.suicide==1& pol2norm>l4.pol2norm&l3.pol2norm>l4.pol2norm&l3.ltfirst2==1 &l2.leaderturn==0 &l.leaderturn==0  
replace suidiff20 = 1 if l2.suicide==1& pol2norm>l2.pol2norm &l.leaderturn==0  
replace suidiff20 = 1 if l2.suicide==1& pol2norm>l3.pol2norm& l2.pol2norm>l3.pol2norm&l2.ltfirst2==1  &l.leaderturn==0  
replace suidiff20 = 1 if l.suicide==1& pol2norm>l.pol2norm 
replace suidiff20 = 1 if l.suicide==1& pol2norm>l2.pol2norm& l.pol2norm>l2.pol2norm&l.ltfirst2==1  
  
replace regdiff5 = 0 if regdiff5==.&irregdiff5==1|suidiff5==1|depdiff5==1|retdiff5==1|natcausesdiff5==1
replace regdiff10 = 0 if regdiff10==.&irregdiff10==1|suidiff10==1|depdiff10==1|retdiff10==1|natcausesdiff10==1
replace regdiff15 = 0 if regdiff15==.&irregdiff15==1|suidiff15==1|depdiff15==1|retdiff15==1|natcausesdiff15==1
replace regdiff20 = 0 if regdiff20==.&irregdiff20==1|suidiff20==1|depdiff20==1|retdiff20==1|natcausesdiff20==1

replace irregdiff5 = 0 if irregdiff5==.&regdiff5==1|suidiff5==1|depdiff5==1|retdiff5==1|natcausesdiff5==1
replace irregdiff10 = 0 if irregdiff10==.&regdiff10==1|suidiff10==1|depdiff10==1|retdiff10==1|natcausesdiff10==1
replace irregdiff15 = 0 if irregdiff15==.&regdiff15==1|suidiff15==1|depdiff15==1|retdiff15==1|natcausesdiff15==1
replace irregdiff20 = 0 if irregdiff20==.&regdiff20==1|suidiff20==1|depdiff20==1|retdiff20==1|natcausesdiff20==1

replace suidiff5 = 0 if suidiff5==.&regdiff5==1| irregdiff5 ==1|depdiff5==1|retdiff5==1|natcausesdiff5==1
replace suidiff10 = 0 if suidiff10==.&regdiff10==1| irregdiff10 ==1|depdiff10==1|retdiff10==1|natcausesdiff10==1
replace suidiff15 = 0 if suidiff15==.&regdiff15==1| irregdiff15 ==1|depdiff15==1|retdiff15==1|natcausesdiff15==1
replace suidiff20 = 0 if suidiff20==.&regdiff20==1| irregdiff20 ==1|depdiff20==1|retdiff20==1|natcausesdiff20==1

replace depdiff5 = 0 if depdiff5==.&regdiff5==1|suidiff5==1| irregdiff5 ==1|retdiff5==1|natcausesdiff5==1
replace depdiff10 = 0 if depdiff10==.&regdiff10==1|suidiff10==1| irregdiff10 ==1|retdiff10==1|natcausesdiff10==1
replace depdiff15 = 0 if depdiff15==.&regdiff15==1|suidiff15==1| irregdiff15 ==1|retdiff15==1|natcausesdiff15==1
replace depdiff20 = 0 if depdiff20==.&regdiff20==1|suidiff20==1| irregdiff20 ==1|retdiff20==1|natcausesdiff20==1

replace retdiff5 = 0 if retdiff5==.&regdiff5==1|suidiff5==1|depdiff5==1| irregdiff5 ==1|natcausesdiff5==1
replace retdiff10 = 0 if retdiff10==.&regdiff10==1|suidiff10==1|depdiff10==1| irregdiff10 ==1|natcausesdiff10==1
replace retdiff15 = 0 if retdiff15==.&regdiff15==1|suidiff15==1|depdiff15==1| irregdiff15 ==1|natcausesdiff15==1
replace retdiff20 = 0 if retdiff20==.&regdiff20==1|suidiff20==1|depdiff20==1| irregdiff20 ==1|natcausesdiff20==1

replace natcausesdiff5 = 0 if natcausesdiff5==.&regdiff5==1|suidiff5==1|depdiff5==1|retdiff5==1| irregdiff5 ==1
replace natcausesdiff10 = 0 if natcausesdiff10==.&regdiff10==1|suidiff10==1|depdiff10==1|retdiff10==1| irregdiff10 ==1
replace natcausesdiff15 = 0 if natcausesdiff15==.&regdiff15==1|suidiff15==1|depdiff15==1|retdiff15==1| irregdiff15 ==1
replace natcausesdiff20 = 0 if natcausesdiff20==.&regdiff20==1|suidiff20==1|depdiff20==1|retdiff20==1| irregdiff20 ==1
 
gen miscdiff5 = 0
replace miscdiff5=. if irregdiff5==.|regdiff5==.|natcauses5==.|depdiff5==.|retdiff5==.|suidiff5==.
replace miscdiff5=1 if irregdiff5==0&regdiff5==0&natcauses5==0&depdiff5==0&retdiff5==0&suidiff5==0&lturn5yr==1
gen miscdiff10 = 0
replace miscdiff10=. if irregdiff10==.|regdiff10==.|natcauses10==.|depdiff10==.|retdiff10==.|suidiff10==.
replace miscdiff10=1 if irregdiff10==0&regdiff10==0&natcauses10==0&depdiff10==0&retdiff10==0&suidiff10==0&lturn10yr==1
gen miscdiff15 = 0
replace miscdiff15=. if irregdiff15==.|regdiff15==.|natcauses15==.|depdiff15==.|retdiff15==.|suidiff15==.
replace miscdiff15=1 if irregdiff15==0&regdiff15==0&natcauses15==0&depdiff15==0&retdiff15==0&suidiff15==0&lturn15yr==1
gen miscdiff20 = 0
replace miscdiff20=. if irregdiff20==.|regdiff20==.|natcauses20==.|depdiff20==.|retdiff20==.|suidiff20==.
replace miscdiff20=1 if irregdiff20==0&regdiff20==0&natcauses20==0&depdiff20==0&retdiff20==0&suidiff20==0&lturn20yr==1
 
*make turnover rate
gen lyear = year if leadid2~=""
bysort ccode: egen mmm = min(lyear)
gen turnrate = turnovers/(year-mmm)
by ccode: gen turnovers20 = turnovers - l20.turnovers if l20.turnovers~=.
replace turnovers20= turnovers if l20.turnovers==.
gen turnrate20 = turnovers20/20 if year-mmm>19
replace turnrate20 = turnovers/(year-mmm) if year-mmm<20
by ccode: gen turnovers10 = turnovers - l10.turnovers if l10.turnovers~=.
replace turnovers10= turnovers if l10.turnovers==.
gen turnrate10 = turnovers10/10 if year-mmm>9
replace turnrate10 = turnovers/(year-mmm) if year-mmm<10
by ccode: gen turnovers5 = turnovers-l5.turnovers if l5.turnovers~=.
replace turnovers5= turnovers if l5.turnovers==.
gen turnrate5 = turnovers5/5 if year-mmm>4
replace turnrate5 = turnovers/(year-mmm) if year-mmm<5
save "C:\Democracy\AJPS\democworki.dta", replace

*Persson and TAbellini data*
use "C:\Democracy\Persson Tabellini democ data\demcap_tables2_3.dta", clear
save "C:\Democracy\AJPS\Persson Tabellini working.dta", replace 
gen ccode=.
replace ccode = 700 if countryname=="Afghanistan"
replace ccode = 339 if countryname=="Albania"
replace ccode = 615 if countryname=="Algeria"
replace ccode = 540 if countryname=="Angola"
replace ccode = 160 if countryname=="Argentina"
replace ccode = 371 if countryname=="Armenia"
replace ccode = 900 if countryname=="Australia"
replace ccode = 305 if countryname=="Austria"
replace ccode = 373 if countryname=="Azerbaijan"
replace ccode = 692 if countryname=="Bahrain"
replace ccode = 771 if countryname=="Bangladesh"
replace ccode = 370 if countryname=="Belarus"
replace ccode = 211 if countryname=="Belgium"
replace ccode = 434 if countryname=="Benin"
replace ccode = 145 if countryname=="Bolivia"
replace ccode = 346 if countryname=="Bosnia"
replace ccode = 346 if countryname=="Bosnia and Herzegovina"
replace ccode = 571 if countryname=="Botswana"
replace ccode = 140 if countryname=="Brazil"
replace ccode = 355 if countryname=="Bulgaria"
replace ccode = 439 if countryname=="Burkina Faso"
replace ccode = 775 if countryname=="Burma"
replace ccode = 775 if countryname=="Myanmar"
replace ccode = 775 if countryname=="Myanmar (Burma)"
replace ccode = 516 if countryname=="Burundi"
replace ccode = 811 if countryname=="Cambodia"
replace ccode = 471 if countryname=="Cameroon"
replace ccode = 20 if countryname=="Canada"
replace ccode = 402 if countryname=="Cape Verde"
replace ccode = 482 if countryname=="Central African Republic"
replace ccode = 483 if countryname=="Chad"
replace ccode = 155 if countryname=="Chile"
replace ccode = 710 if countryname=="China"
replace ccode = 100 if countryname=="Colombia"
replace ccode = 581 if countryname=="Comoro Islands"
replace ccode = 581 if countryname=="Comoros"
replace ccode = 484 if countryname=="Congo 'Brazzaville'"
replace ccode = 484 if countryname=="Congo, Rep."
replace ccode = 484 if countryname=="Congo"
replace ccode = 94 if countryname=="Costa Rica"
replace ccode = 437 if countryname=="Côte d'Ivoire"
replace ccode = 437 if countryname=="Cote d'Ivoire"
replace ccode = 437 if countryname=="Ivory Coast"
replace ccode = 344 if countryname=="Croatia"
replace ccode = 40 if countryname=="Cuba"
replace ccode = 316 if countryname=="Czech Republic"
replace ccode = 315 if countryname=="Czechoslovakia"
replace ccode = 390 if countryname=="Denmark"
replace ccode = 522 if countryname=="Djibouti"
replace ccode = 42 if countryname=="Dominican Republic"
replace ccode = 42 if countryname=="Dominican Rep"
replace ccode = 130 if countryname=="Ecuador"
replace ccode = 651 if countryname=="Egypt"
replace ccode = 651 if countryname=="Egypt, Arab Rep."
replace ccode = 92 if countryname=="El Salvador"
replace ccode = 411 if countryname=="Equatorial Guinea"
replace ccode = 531 if countryname=="Eritrea"
replace ccode = 530 if countryname=="Ethiopia"
replace ccode = 530 if countryname=="Ethiopia 1993-"
replace ccode = 530 if countryname=="Ethiopia -pre 1993"
replace ccode = 366 if countryname=="Estonia"
replace ccode = 375 if countryname=="Finland"
replace ccode = 220 if countryname=="France"
replace ccode = 481 if countryname=="Gabon"
replace ccode = 420 if countryname=="Gambia"
replace ccode = 420 if countryname=="Gambia, The"
replace ccode = 372 if countryname=="Georgia"
replace ccode = 255 if countryname=="Germany"
replace ccode = 452 if countryname=="Ghana"
replace ccode = 350 if countryname=="Greece"
replace ccode = 90 if countryname=="Guatemala"
replace ccode = 438 if countryname=="Guinea"
replace ccode = 404 if countryname=="Guinea Bissau"
replace ccode = 404 if countryname=="Guinea-Bissau"
replace ccode = 110 if countryname=="Guyana"
replace ccode = 41 if countryname=="Haïti"
replace ccode = 91 if countryname=="Honduras"
replace ccode = 1001 if countryname=="Hong Kong"
replace ccode = 310 if countryname=="Hungary"
replace ccode = 750 if countryname=="India"
replace ccode = 850 if countryname=="Indonesia (including Timor until 1999)"
replace ccode = 850 if countryname=="Indonesia"
replace ccode = 630 if countryname=="Iran"
replace ccode = 645 if countryname=="Iraq"
replace ccode = 205 if countryname=="Ireland"
replace ccode = 666 if countryname=="Israel"
replace ccode = 325 if countryname=="Italy"
replace ccode = 51 if countryname=="Jamaica"
replace ccode = 740 if countryname=="Japan"
replace ccode = 663 if countryname=="Jordan"
replace ccode = 705 if countryname=="Kazakhstan"
replace ccode = 501 if countryname=="Kenya"
replace ccode = 347 if countryname=="Kosovo"
replace ccode = 690 if countryname=="Kuwait"
replace ccode = 703 if countryname=="Kyrgyzstan"
replace ccode = 703 if countryname=="Kyrgyz Republic"
replace ccode = 812 if countryname=="Laos"
replace ccode = 812 if countryname=="Lao PDR"
replace ccode = 367 if countryname=="Latvia"
replace ccode = 660 if countryname=="Lebanon"
replace ccode = 570 if countryname=="Lesotho"
replace ccode = 450 if countryname=="Liberia"
replace ccode = 620 if countryname=="Libya"
replace ccode = 368 if countryname=="Lithuania"
replace ccode = 343 if countryname=="Macedonia"
replace ccode = 343 if countryname=="Macedonia, FYR"
replace ccode = 580 if countryname=="Madagascar"
replace ccode = 553 if countryname=="Malawi"
replace ccode = 820 if countryname=="Malaysia"
replace ccode = 432 if countryname=="Mali"
replace ccode = 435 if countryname=="Mauritania"
replace ccode = 590 if countryname=="Mauritius"
replace ccode = 70 if countryname=="Mexico"
replace ccode = 359 if countryname=="Moldova"
replace ccode = 712 if countryname=="Mongolia"
replace ccode = 341 if countryname=="Montenegro"
replace ccode = 600 if countryname=="Morocco"
replace ccode = 541 if countryname=="Mozambique"
replace ccode = 565 if countryname=="Namibia"
replace ccode = 790 if countryname=="Nepal"
replace ccode = 210 if countryname=="Netherlands"
replace ccode = 920 if countryname=="New Zealand"
replace ccode = 93 if countryname=="Nicaragua"
replace ccode = 436 if countryname=="Niger"
replace ccode = 475 if countryname=="Nigeria"
replace ccode = 731 if countryname=="North Korea"
replace ccode = 385 if countryname=="Norway"
replace ccode = 698 if countryname=="Oman"
replace ccode = 770 if countryname=="Pakistan"
replace ccode = 770 if countryname=="Pakistan-pre-1972"
replace ccode = 770 if countryname=="Pakistan-post-1972"
replace ccode = 95 if countryname=="Panama"
replace ccode = 150 if countryname=="Paraguay"
replace ccode = 135 if countryname=="Peru"
replace ccode = 840 if countryname=="Philippines"
replace ccode = 290 if countryname=="Poland"
replace ccode = 235 if countryname=="Portugal"
replace ccode = 1002 if countryname=="Puerto Rico"
replace ccode = 694 if countryname=="Qatar"
replace ccode = 360 if countryname=="Romania"
replace ccode = 365 if countryname=="Russian Federation"
replace ccode = 365 if countryname=="Russia"
replace ccode = 517 if countryname=="Rwanda"
replace ccode = 403 if countryname=="São Tomé and Principe"
replace ccode = 670 if countryname=="Saudi Arabia"
replace ccode = 433 if countryname=="Senegal"
replace ccode = 342 if countryname=="Serbia"
replace ccode = 348 if countryname=="Serbia and Montenegro"
replace ccode = 591 if countryname=="Seychelles"
replace ccode = 451 if countryname=="Sierra Leone"
replace ccode = 830 if countryname=="Singapore"
replace ccode = 317 if countryname=="Slovakia"
replace ccode = 317 if countryname=="Slovak Republic"
replace ccode = 349 if countryname=="Slovenia"
replace ccode = 520 if countryname=="Somalia"
replace ccode = 560 if countryname=="South Africa"
replace ccode = 732 if countryname=="South Korea"
replace ccode = 732 if countryname=="Korea, Rep."
replace ccode = 731 if countryname=="Korea, Dem. Rep."
replace ccode = 730 if countryname=="Korea"
replace ccode = 230 if countryname=="Spain"
replace ccode = 780 if countryname=="Sri Lanka"
replace ccode = 625 if countryname=="Sudan"
replace ccode = 572 if countryname=="Swaziland"
replace ccode = 380 if countryname=="Sweden"
replace ccode = 225 if countryname=="Switzerland"
replace ccode = 652 if countryname=="Syria"
replace ccode = 652 if countryname=="Syrian Arab Republic"
replace ccode = 713 if countryname=="Taiwan"
replace ccode = 702 if countryname=="Tajikistan"
replace ccode = 510 if countryname=="Tanzania"
replace ccode = 800 if countryname=="Thailand"
replace ccode = 461 if countryname=="Togo"
replace ccode = 364 if countryname=="Total Former USSR"
replace ccode = 364 if countryname=="USSR"
replace ccode = 52 if countryname=="Trinidad and Tobago"
replace ccode = 52 if countryname=="Trinidad & Tobago"
replace ccode = 616 if countryname=="Tunisia"
replace ccode = 640 if countryname=="Turkey"
replace ccode = 701 if countryname=="Turkmenistan"
replace ccode = 500 if countryname=="Uganda"
replace ccode = 369 if countryname=="Ukraine"
replace ccode = 696 if countryname=="United Arab Emirates"
replace ccode = 200 if countryname=="United Kingdom"
replace ccode = 2 if countryname=="United States"
replace ccode = 165 if countryname=="Uruguay"
replace ccode = 704 if countryname=="Uzbekistan"
replace ccode = 101 if countryname=="Venezuela"
replace ccode = 101 if countryname=="Venezuela, RB"
replace ccode = 818 if countryname=="Vietnam"
replace ccode = 816 if countryname=="Vietnam North"
replace ccode = 817 if countryname=="Vietnam South"
replace ccode = 816 if countryname=="Vietnam, North"
replace ccode = 817 if countryname=="Vietnam, South"
replace ccode = 1005 if countryname=="West Bank and Gaza"
replace ccode = 679 if countryname=="Yemen"
replace ccode = 678 if countryname=="Yemen North"
replace ccode = 678 if countryname=="Yemen, N.Arab"
replace ccode = 680 if countryname=="Yemen South"
replace ccode = 680 if countryname=="Yemen, South"
replace ccode = 345 if countryname=="Yugoslavia"
replace ccode = 345 if countryname== "Yugoslavia - post 1991"
replace ccode = 345 if countryname== "Yugoslavia-pre 1991"
replace ccode = 490 if countryname=="Zaire (Congo Kinshasa)"
replace ccode = 490 if countryname=="Zaire"
replace ccode = 490 if countryname=="Congo, Dem. Rep."
replace ccode = 551 if countryname=="Zambia"
replace ccode = 552 if countryname=="Zimbabwe"
replace ccode = 232 if countryname=="Andorra"
replace ccode = 58 if countryname=="Antigua"
replace ccode = 31 if countryname=="Bahamas"
replace ccode = 53 if countryname=="Barbados"
replace ccode = 80 if countryname=="Belize"
replace ccode = 760 if countryname=="Bhutan"
replace ccode = 835 if countryname=="Brunei"
replace ccode = 352 if countryname=="Cyprus"
replace ccode = 54 if countryname=="Dominica"
replace ccode = 860 if countryname=="East Timor"
replace ccode = 950 if countryname=="Fiji"
replace ccode = 265 if countryname=="Germany, East"
replace ccode = 55 if countryname=="Grenada"
replace ccode = 41 if countryname=="Haiti"
replace ccode = 212 if countryname=="Luxembourg"
replace ccode = 781 if countryname=="Maldives"
replace ccode = 338 if countryname=="Malta"
replace ccode = 910 if countryname=="Papua New Guinea"
replace ccode = 403 if countryname=="Sao Tome and Principe"
replace ccode = 940 if countryname=="Solomon Islands"
replace ccode = 60 if countryname=="St. Kitts and Nevis"
replace ccode = 60 if countryname=="St. Kitts & Nevis"
replace ccode = 56 if countryname=="St. Lucia"
replace ccode = 57 if countryname=="St. Vincent and the Grenadines"
replace ccode = 57 if countryname=="St. Vincent & Grenadines"
replace ccode = 57 if countryname=="St. Vicent & Grenadines"
replace ccode = 115 if countryname=="Suriname"
replace ccode = 955 if countryname=="Tonga"
replace ccode = 115 if countryname=="Suriname"
replace ccode = 935 if countryname=="Vanuatu"
replace ccode = 990 if countryname=="Western Samoa"
replace ccode = 990 if countryname=="Samoa (Western)"
drop if ccode==.
keep year ctycode countryname closdem_cont_dist   demcap_delta94 ccode
gen cyear = ccode*10000 + year
sort cyear
save "C:\Democracy\AJPS\Persson Tabellini working.dta", replace 

use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear
merge cyear using "C:\Democracy\AJPS\Persson Tabellini working.dta" 
save "C:\Democracy\AJPS\democworki.dta", replace

*Wright Geddes Frantz authoritarian type data*

use "C:\Democracy\Wright data\gwf_global.dta", clear
rename cowcode ccode
replace ccode = 342 if gwf_country=="Serbia"&year>2006
replace ccode = 679 if gwf_country=="Yemen"&year>1990
replace ccode = 818 if gwf_country=="Vietnam"&year>1975
replace ccode = 345 if gwf_country=="Serbia"&year>1990&year<2006
gen cyear = ccode*10000+year
sort cyear
save "C:\Democracy\AJPS\geddes.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear
drop _merge 
merge cyear using "C:\Democracy\AJPS\geddes.dta", sort
drop _merge
gen gwfmisc = .
replace gwfmisc= 1 if polity2<6& gwf_party+ gwf_military+ gwf_monarchy+ gwf_personal==0
replace gwfmisc=0 if polity2>5
replace gwfmisc=0 if gwf_party+ gwf_military+ gwf_monarchy+ gwf_personal>0
*gwfmisc is regimes with Polity2<6 but not classified by GWF as milit, mon, party, or personalistic*
save "C:\Democracy\AJPS\democworki.dta", replace

*Banks data*
insheet using "C:\Democracy\AJPS\banks.txt", clear
save "C:\Democracy\bankswork.dta", replace
gen ccode=.
replace ccode = 700 if country=="Afghanistan"
replace ccode = 339 if country=="Albania"
replace ccode = 615 if country=="Algeria"
replace ccode = 540 if country=="Angola"
replace ccode = 160 if country=="Argentina"
replace ccode = 371 if country=="Armenia"
replace ccode = 900 if country=="Australia"
replace ccode = 305 if country=="Austria"
replace ccode = 373 if country=="Azerbaijan"
replace ccode = 692 if country=="Bahrain"
replace ccode = 771 if country=="Bangladesh"
replace ccode = 370 if country=="Belarus"
replace ccode = 211 if country=="Belgium"
replace ccode = 434 if country=="Benin"
replace ccode = 145 if country=="Bolivia"
replace ccode = 346 if country=="Bosnia"
replace ccode = 346 if country=="Bosnia and Herzegovina"
replace ccode = 571 if country=="Botswana"
replace ccode = 140 if country=="Brazil"
replace ccode = 355 if country=="Bulgaria"
replace ccode = 439 if country=="Burkina Faso"
replace ccode = 775 if country=="Burma"
replace ccode = 775 if country=="Myanmar"
replace ccode = 775 if country=="Myanmar (Burma)"
replace ccode = 516 if country=="Burundi"
replace ccode = 811 if country=="Cambodia"
replace ccode = 471 if country=="Cameroon"
replace ccode = 20 if country=="Canada"
replace ccode = 402 if country=="Cape Verde"
replace ccode = 482 if country=="Central African Republic"
replace ccode = 483 if country=="Chad"
replace ccode = 155 if country=="Chile"
replace ccode = 710 if country=="China"
replace ccode = 100 if country=="Colombia"
replace ccode = 581 if country=="Comoro Islands"
replace ccode = 581 if country=="Comoros"
replace ccode = 484 if country=="Congo Brazzaville"
replace ccode = 484 if country=="Congo, Rep."
replace ccode = 484 if country=="Republic of the Congo"
replace ccode = 94 if country=="Costa Rica"
replace ccode = 437 if country=="Côte d'Ivoire"
replace ccode = 437 if country=="Cote d'Ivoire"
replace ccode = 437 if country=="Ivory Coast"
replace ccode = 344 if country=="Croatia"
replace ccode = 40 if country=="Cuba"
replace ccode = 316 if country=="Czech Republic"
replace ccode = 315 if country=="Czechoslovakia"
replace ccode = 390 if country=="Denmark"
replace ccode = 522 if country=="Djibouti"
replace ccode = 42 if country=="Dominican Republic"
replace ccode = 42 if country=="Dominican Rep"
replace ccode = 130 if country=="Ecuador"
replace ccode = 651 if country=="Egypt"
replace ccode = 651 if country=="Egypt, Arab Rep."
replace ccode = 92 if country=="El Salvador"
replace ccode = 411 if country=="Equatorial Guinea"
replace ccode = 531 if country=="Eritrea"
replace ccode = 530 if country=="Ethiopia"
replace ccode = 530 if country=="Ethiopia 1993-"
replace ccode = 530 if country=="Ethiopia -pre 1993"
replace ccode = 366 if country=="Estonia"
replace ccode = 375 if country=="Finland"
replace ccode = 220 if country=="France"
replace ccode = 481 if country=="Gabon"
replace ccode = 420 if country=="Gambia"
replace ccode = 420 if country=="Gambia, The"
replace ccode = 372 if country=="Georgia"
replace ccode = 255 if country=="Germany"
replace ccode = 452 if country=="Ghana"
replace ccode = 350 if country=="Greece"
replace ccode = 90 if country=="Guatemala"
replace ccode = 438 if country=="Guinea"
replace ccode = 404 if country=="Guinea Bissau"
replace ccode = 404 if country=="Guinea-Bissau"
replace ccode = 110 if country=="Guyana"
replace ccode = 41 if country=="Haïti"
replace ccode = 91 if country=="Honduras"
replace ccode = 1001 if country=="Hong Kong"
replace ccode = 310 if country=="Hungary"
replace ccode = 750 if country=="India"
replace ccode = 850 if country=="Indonesia (including Timor until 1999)"
replace ccode = 850 if country=="Indonesia"
replace ccode = 630 if country=="Iran"
replace ccode = 645 if country=="Iraq"
replace ccode = 205 if country=="Ireland"
replace ccode = 666 if country=="Israel"
replace ccode = 325 if country=="Italy"
replace ccode = 51 if country=="Jamaica"
replace ccode = 740 if country=="Japan"
replace ccode = 663 if country=="Jordan"
replace ccode = 705 if country=="Kazakhstan"
replace ccode = 501 if country=="Kenya"
replace ccode = 347 if country=="Kosovo"
replace ccode = 690 if country=="Kuwait"
replace ccode = 703 if country=="Kyrgyzstan"
replace ccode = 703 if country=="Kyrgyz Republic"
replace ccode = 812 if country=="Laos"
replace ccode = 812 if country=="Lao PDR"
replace ccode = 367 if country=="Latvia"
replace ccode = 660 if country=="Lebanon"
replace ccode = 570 if country=="Lesotho"
replace ccode = 450 if country=="Liberia"
replace ccode = 620 if country=="Libya"
replace ccode = 368 if country=="Lithuania"
replace ccode = 343 if country=="Macedonia"
replace ccode = 343 if country=="Macedonia, FYR"
replace ccode = 580 if country=="Madagascar"
replace ccode = 553 if country=="Malawi"
replace ccode = 820 if country=="Malaysia"
replace ccode = 432 if country=="Mali"
replace ccode = 435 if country=="Mauritania"
replace ccode = 590 if country=="Mauritius"
replace ccode = 70 if country=="Mexico"
replace ccode = 359 if country=="Moldova"
replace ccode = 712 if country=="Mongolia"
replace ccode = 341 if country=="Montenegro"
replace ccode = 600 if country=="Morocco"
replace ccode = 541 if country=="Mozambique"
replace ccode = 565 if country=="Namibia"
replace ccode = 790 if country=="Nepal"
replace ccode = 210 if country=="Netherlands"
replace ccode = 920 if country=="New Zealand"
replace ccode = 93 if country=="Nicaragua"
replace ccode = 436 if country=="Niger"
replace ccode = 475 if country=="Nigeria"
replace ccode = 731 if country=="Korea North"
replace ccode = 385 if country=="Norway"
replace ccode = 698 if country=="Oman"
replace ccode = 770 if country=="Pakistan"
replace ccode = 770 if country=="Pakistan-pre-1972"
replace ccode = 770 if country=="Pakistan-post-1972"
replace ccode = 95 if country=="Panama"
replace ccode = 150 if country=="Paraguay"
replace ccode = 135 if country=="Peru"
replace ccode = 840 if country=="Philippines"
replace ccode = 290 if country=="Poland"
replace ccode = 235 if country=="Portugal"
replace ccode = 1002 if country=="Puerto Rico"
replace ccode = 694 if country=="Qatar"
replace ccode = 360 if country=="Romania"
replace ccode = 365 if country=="Russian Federation"
replace ccode = 365 if country=="Russia"
replace ccode = 517 if country=="Rwanda"
replace ccode = 403 if country=="São Tomé and Principe"
replace ccode = 670 if country=="Saudi Arabia"
replace ccode = 433 if country=="Senegal"
replace ccode = 342 if country=="Serbia"
replace ccode = 348 if country=="Serbia and Montenegro"
replace ccode = 591 if country=="Seychelles"
replace ccode = 451 if country=="Sierra Leone"
replace ccode = 830 if country=="Singapore"
replace ccode = 317 if country=="Slovakia"
replace ccode = 317 if country=="Slovak Republic"
replace ccode = 349 if country=="Slovenia"
replace ccode = 520 if country=="Somalia"
replace ccode = 560 if country=="South Africa"
replace ccode = 732 if country=="Korea South"
replace ccode = 732 if country=="Korea, Rep."
replace ccode = 731 if country=="Korea, Dem. Rep."
replace ccode = 730 if country=="Korea"
replace ccode = 230 if country=="Spain"
replace ccode = 780 if country=="Sri Lanka"
replace ccode = 625 if country=="Sudan"
replace ccode = 572 if country=="Swaziland"
replace ccode = 380 if country=="Sweden"
replace ccode = 225 if country=="Switzerland"
replace ccode = 652 if country=="Syria"
replace ccode = 652 if country=="Syrian Arab Republic"
replace ccode = 713 if country=="Taiwan"
replace ccode = 702 if country=="Tajikistan"
replace ccode = 510 if country=="Tanzania"
replace ccode = 800 if country=="Thailand"
replace ccode = 461 if country=="Togo"
replace ccode = 365 if country=="USSR"&year>1921&year<1992
replace ccode = 52 if country=="Trinidad and Tobago"
replace ccode = 52 if country=="Trinidad"
replace ccode = 616 if country=="Tunisia"
replace ccode = 640 if country=="Turkey"
replace ccode = 701 if country=="Turkmenistan"
replace ccode = 500 if country=="Uganda"
replace ccode = 369 if country=="Ukraine"
replace ccode = 696 if country=="United Arab Emirates"
replace ccode = 200 if country=="United Kingdom"
replace ccode = 2 if country=="United States of America"
replace ccode = 165 if country=="Uruguay"
replace ccode = 704 if country=="Uzbekistan"
replace ccode = 101 if country=="Venezuela"
replace ccode = 101 if country=="Venezuela, RB"
replace ccode = 818 if country=="Vietnam"
replace ccode = 816 if country=="Vietnam North"
replace ccode = 817 if country=="Vietnam South"
replace ccode = 816 if country=="Vietnam, North"
replace ccode = 817 if country=="Vietnam, South"
replace ccode = 1005 if country=="West Bank and Gaza"
replace ccode = 679 if country=="Yemen"
replace ccode = 678 if country=="Yemen North"
replace ccode = 678 if country=="Yemen Arab Republic"
replace ccode = 680 if country=="Yemen South"
replace ccode = 680 if country=="Yemen, South"
replace ccode = 345 if country=="Yugoslavia"
replace ccode = 345 if country== "Yugoslavia - post 1991"
replace ccode = 345 if country== "Yugoslavia-pre 1991"
replace ccode = 490 if country=="Congo Kinshasa"
replace ccode = 490 if country=="Democratic Republic of the Congo"
replace ccode = 490 if country=="Congo, Dem. Rep."
replace ccode = 551 if country=="Zambia"
replace ccode = 552 if country=="Zimbabwe"
replace ccode = 232 if country=="Andorra"
replace ccode = 58 if country=="Antigua"
replace ccode = 31 if country=="Bahamas"
replace ccode = 53 if country=="Barbados"
replace ccode = 80 if country=="Belize"
replace ccode = 760 if country=="Bhutan"
replace ccode = 835 if country=="Brunei"
replace ccode = 352 if country=="Cyprus"
replace ccode = 54 if country=="Dominica"
replace ccode = 860 if country=="East Timor"
replace ccode = 950 if country=="Fiji"
replace ccode = 265 if country=="Germany, East"
replace ccode = 55 if country=="Grenada"
replace ccode = 41 if country=="Haiti"
replace ccode = 212 if country=="Luxembourg"
replace ccode = 781 if country=="Maldives"
replace ccode = 338 if country=="Malta"
replace ccode = 910 if country=="Papua New Guinea"
replace ccode = 403 if country=="Sao Tome and Principe"
replace ccode = 940 if country=="Solomon Islands"
replace ccode = 60 if country=="St. Kitts and Nevis"
replace ccode = 60 if country=="Saint Kitts and Nevis"
replace ccode = 56 if country=="Saint Lucia"
replace ccode = 57 if country=="St. Vincent and the Grenadines"
replace ccode = 57 if country=="St. Vincent & Grenadines"
replace ccode = 57 if country=="Saint Vincent and the Grenadines"
replace ccode = 115 if country=="Suriname"
replace ccode = 955 if country=="Tonga"
replace ccode = 115 if country=="Suriname"
replace ccode = 935 if country=="Vanuatu"
replace ccode = 990 if country=="Samoa"
replace ccode = 990 if country=="Samoa (Western)"
replace ccode = 58 if country=="Antigua and Barbuda"
replace ccode = 32 if country=="Aruba"
replace ccode = 33 if country=="Bermuda"
replace ccode = 395 if country=="Iceland"
replace ccode = 946 if country=="Kiribati"
replace ccode = 212 if country=="Luxembourg"
replace ccode = 223 if country=="Liechtenstein"
replace ccode = 711 if country=="Macao"
replace ccode = 983 if country=="Marshall Islands"
replace ccode = 987 if country=="Micronesia"
replace ccode = 970 if country=="Nauru"
replace ccode = 986 if country=="Palau"
replace ccode = 1005 if country=="Palestinian Territory"
replace ccode = 331 if country=="San Marino"
replace ccode = 947 if country=="Tuvalu"
drop if ccode==.
gen cyear = ccode*10000+ year
sort cyear
save "C:\Democracy\bankswork.dta", replace
use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear
merge cyear using "C:\Democracy\bankswork.dta", sort
save "C:\Democracy\AJPS\democworki.dta", replace

gen militaryregime = 0
replace militaryregime = 1 if polit05==3
replace militaryregime=. if polit05==.
gen monarchy=0
replace monarchy=1 if polit05==1
replace monarchy=. if polit05==.
gen exelbanks = 0
replace exelbanks=1 if polit08==1|polit08==2
replace exelbanks=. if polit08==.
label var exelbanks "exec elected directly or by elected leg: banks"
gen legelbanks = 0
replace legelbanks=1 if polit14==2
replace legelbanks=. if polit14==.
label var legelbanks "legislature elected: banks"
gen banksagd = domestic8
gen banksriots=domestic6
gen banksrev=domestic7
gen banksstrikes=domestic2
rename domestic3 gwar
rename domestic4 crisis
rename polit04 banksconch
drop delta* domestic* economics* electoral* energy* indprod* industry* instat* legis*  mail* media* military1 military2 military3 military4 phone* physician* polit0* railroad* pop1 pop2 pop3 pop4 revexp* school* telegraph* trade1 trade2 trade3 trade4 trade5 urban* vehicle*
save "C:\Democracy\AJPS\democworki.dta", replace

*import COW data on wars*
insheet using "C:\Democracy\Final data\COW intrastate war v4.0.txt", clear
save "C:\Democracy\AJPS\COWintrastatework.dta", replace
* First, I include in civil wars only states where the conflict is known to have caused at least 1,000 deaths. *
gen totaldeaths = sideadeaths+sidebdeaths
drop if totaldeaths<1000
drop if totaldeaths==.
*Second, need to create a ccode variable without missing cases. *
gen ccode = ccodea
replace ccode = 305 if ccodea==300
replace ccode =651  if warnum==521
replace ccode = 660 if warnum==535
replace ccode = 660 if warnum==543
replace ccode = 660 if warnum==566
replace ccode = 2 if warnum==577
replace ccode = 255 if warnum==682
replace ccode = 325 if warnum==688
replace ccode = 660 if warnum==807
*correct a data error*
replace endyear1=1919 if warnum==682
*give endyear for Colombian FARC, war ongoing, of 2009*
replace endyear1=2009 if warnum==856
gen waryears = endyear1-startyear1
expand (waryears+1)
sort warnum ccode startyear1
gen case = _n
tsset case
gen year = startyear1
replace year = l.year+1 if warnum==l.warnum&ccode==l.ccode&startyear1==l.startyear1
gen warnumccode = warnum*10000+ccode
sort warnum ccode year
drop case
gen case = _n
tsset case
gen lastyearofcwar = 0
replace lastyearofcwar=1 if year==endyear1
gen firstyearofcwar = 0
replace firstyearofcwar=1 if year==startyear1
gen woncwarthisyr = 0
replace woncwarthisyr=1 if lastyearofcwar==1&outcome==1
gen lostcwarthisyr = 0
replace lostcwarthisyr=1 if lastyearofcwar==1&outcome==2
gen civilwar = 1
gen cyear = ccode*10000 + year
save "C:\Democracy\AJPS\COWintrastatework.dta", replace

*deal with some doubling up of war years*
drop if warnum==577
drop if warnum==673&year==1914
drop if warnum==701&year==1929
drop if warnum==608&year==1880
drop if cyear==3001848&warnum==550
drop if cyear==3001848&warnum==551
drop if warnum==511&year==1831
drop if warnum==686&year==1920
drop if warnum==686&year==1921
drop if warnum==690&year==1921
drop if warnum==691&year==1921
drop if warnum==843&year==1986
drop if warnum==798&year==1976
drop if warnum==798&year==1977
drop if warnum==808&year==1978
drop if warnum==506&year==1826
drop if warnum==518&year==1831
drop if warnum==812&year==1978
drop if warnum==711&year==1931
drop if warnum==711&year==1932
drop if warnum==710&year==1933
drop if warnum==710&year==1934
drop if warnum==725&year==1947
drop if warnum==931&year==2003
drop if warnum==790&year==1972
drop if warnum==786&year==1973
drop if warnum==790&year==1974
drop if warnum==790&year==1975
drop if warnum==786&year==1976
drop if warnum==786&year==1977
drop if warnum==786&year==1978
drop if warnum==786&year==1979
drop if warnum==786&year==1980
drop if warnum==790&year==1981
replace lostcwar=0 if warnum==682
replace lostcwar=0 if warnum==535
replace lostcwar=0 if warnum==543
replace lostcwar=0 if warnum==566
replace lostcwar=0 if warnum==807
replace lostcwar=0 if warnum==521
replace lostcwar=0 if warnum==682
sort cyear
save "C:\Democracy\AJPS\COWintrastatework.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear 
sort cyear
drop _merge 
merge cyear using "C:\Democracy\AJPS\COWintrastatework.dta" 
save "C:\Democracy\AJPS\democworki.dta", replace
sort ccode year
drop case
gen case = _n
tsset case
replace civilwar=0 if civilwar==. &indep==1&year>1815
gen lostcwarlastyr = 0
replace lostcwarlastyr = 1 if l.ccode==ccode&l.lastyearofcwar==1&l.outcome==2
gen woncwarlastyr = 0
replace woncwarlastyr = 1 if l.ccode==ccode&l.lastyearofcwar==1&l.outcome==1
replace woncwarthisyr=0 if woncwarthisyr==.
replace lostcwarthisyr=0 if lostcwarthisyr==.
save "C:\Democracy\AJPS\democworki.dta", replace

insheet using "C:\Democracy\Final data\COW interstate war data_v4.0.txt", clear
save "C:\Democracy\AJPS\COWinterstatework.dta", replace
replace ccode=305 if ccode==300
*deal with the strange coding of France: one war from 1939 to 1940, then another from 1940-41. Consolidate the two as one war 1939-45*
drop if ccode==220&startyear1==1940&batdeath==700
*to avoid duplication of years 1940 and 1941*
replace endyear1=1945 if ccode==220&startyear1==1939
gen waryears = endyear1-startyear1
expand (waryears+1)
sort warnum ccode startyear1
gen case = _n
tsset case
gen year = startyear1
replace year = l.year+1 if warnum==l.warnum&ccode==l.ccode&startyear1==l.startyear1
gen warnumccode = warnum*10000+ccode
sort warnum ccode year
drop case
gen case = _n
tsset case
gen lastyearofwar = 0
replace lastyearofwar=1 if year==endyear1
gen firstyearofwar = 0
replace firstyearofwar=1 if year==startyear1
gen wonwarthisyr = 0
replace wonwarthisyr=1 if lastyearofwar==1&outcome==1
gen lostwarthisyr = 0
replace lostwarthisyr=1 if lastyearofwar==1&outcome==2
gen interstatewar = 1
gen cyear = ccode*10000 + year
rename initiator initiatewar
replace initiatewar = 0 if initiatewar==2
gen lwthisdidntinitiate = 0
replace lwthisdidntinitiate=1 if lostwarthisyr==1&initiatewar==0
save "C:\Democracy\AJPS\COWinterstatework.dta", replace

*deal with some doubling up of cyear*
drop if warnum==170&year==1968&ccode==2
drop if warnum==170&year==1969&ccode==2
drop if warnum==170&year==1970&ccode==2
drop if warnum==176&year==1970&ccode==2
drop if warnum==170&year==1971&ccode==2
drop if warnum==176&year==1971&ccode==2
drop if warnum==170&year==1972&ccode==2
drop if warnum==170&year==1973&ccode==2
drop if warnum==25&year==1856&ccode==200
drop if warnum==145&year==1940&ccode==220
drop if warnum==145&year==1941&ccode==220
drop if warnum==117&year==1920&ccode==290
drop if warnum==37&year==1860&ccode==325
drop if warnum==103&year==1913&ccode==350
drop if warnum==83&year==1900&ccode==365
drop if warnum==107&year==1918&ccode==365
drop if warnum==107&year==1919&ccode==365
drop if warnum==108&year==1919&ccode==365
drop if warnum==107&year==1920&ccode==365
drop if warnum==108&year==1920&ccode==365
drop if warnum==136&year==1939&ccode==365
drop if warnum==108&year==1919&ccode==366
drop if warnum==108&year==1920&ccode==366
drop if warnum==100&year==1912&ccode==640
drop if warnum==100&year==1913&ccode==640
drop if warnum==116&year==1919&ccode==640
drop if warnum==116&year==1920&ccode==640
drop if warnum==116&year==1921&ccode==640
drop if warnum==82&year==1900&ccode==710
drop if warnum==139&year==1941&ccode==710
drop if warnum==130&year==1938&ccode==740
drop if warnum==130&year==1939&ccode==740
drop if warnum==139&year==1941&ccode==740
drop if warnum==170&year==1970&ccode==800
drop if warnum==170&year==1971&ccode==800
drop if warnum==170&year==1972&ccode==800
drop if warnum==170&year==1973&ccode==800
drop if warnum==176&year==1970&ccode==811
drop if warnum==176&year==1971&ccode==811
drop if warnum==170&year==1968&ccode==816
drop if warnum==170&year==1969&ccode==816
drop if warnum==170&year==1970&ccode==816
drop if warnum==170&year==1971&ccode==816
drop if warnum==176&year==1970&ccode==816
drop if warnum==176&year==1971&ccode==816
drop if warnum==170&year==1972&ccode==816
drop if warnum==163&year==1973&ccode==816
drop if warnum==189&year==1979&ccode==816
drop if warnum==176&year==1970&ccode==817
drop if warnum==176&year==1971&ccode==817
drop if warnum==108&year==1918&ccode==255
drop if ccode==220&year==1940&batdeath==2500
drop if ccode==220&year==1941&batdeath==2500
drop if ccode==255&year==1919&batdeath==450
drop if ccode==325&year==1943&batdeath==52400
drop if ccode==355&year==1944&batdeath==1000
drop if ccode==360&year==1944&batdeath==10000
rename outcome outcomeintl
rename warnum warnumint
sort cyear
rename startday1 wstartday1
rename startmonth1 wstartmonth1
rename startyear1 wstartyear1
save "C:\Democracy\AJPS\COWinterstatework.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear 
sort cyear
drop _merge 
merge cyear using "C:\Democracy\AJPS\COWinterstatework.dta"
save "C:\Democracy\AJPS\democworki.dta", replace
sort ccode year
drop case
gen case = _n
tsset case
replace interstatewar=0 if interstatewar==.&indep==1&year>1815
gen lostwarlastyr = 0
replace lostwarlastyr = 1 if l.ccode==ccode&l.lastyearofwar==1&l.outcomeintl==2
gen wonwarlastyr = 0
replace wonwarlastyr = 1 if l.ccode==ccode&l.lastyearofwar==1&l.outcomeintl==1
replace wonwarthisyr=0 if wonwarthisyr==.
replace lostwarthisyr=0 if lostwarthisyr==.
gen lwlastdidntinitiate = 0
replace lwlastdidntinitiate=1 if l.ccode==ccode&l.lastyearofwar==1&l.outcomeintl==2&l.initiatewar==0
gen inwar = 0
replace inwar = 1 if initiatewar==1
replace inwar=. if interstatewar==.
replace inwar=. if l.batdeath==batdeath&l.batdeath~=.&batdeath~=.
drop if ccode==365&year==1917&totaldeaths==1350
drop if ccode==260
drop if warnum==551
drop if warnum==554&year==1848
drop if country=="France"&year==1939&inwar==.
drop if country=="Bulgaria"&year==1944&side==1
drop if country=="Romania"&year==1944&side==1
drop if country=="Germany"&year==1919&side==1
drop if country=="Bulgaria"&year==1941&inwar==.
drop if country=="Bulgaria"&year==1942&l.year==1942
drop if country=="Romania"&year==1941&inwar==.
drop if country=="Italy"&year==1943&batdeath==52400 
drop if country=="Italy"&year==1940&inwar==.

*more duplication issues*
*this is to code as . years that are not the first of a given war that the country initiated*
xtset ccode year
bysort ccode: gen sumwaryears = sum(interstatewar)
bysort ccode: egen stt = min(year) if indep==1
bysort ccode: egen sss = min(stt)
replace sss = 1816 if sss<1816
gen warrate = sumwaryears/(year-sss)
replace warrate = . if year<sss
save "C:\Democracy\AJPS\democworki.dta", replace

gen sovcontrol = 0
replace sovcontrol = 1 if ccode==315&year>1944&year<1990
replace sovcontrol = 1 if ccode==316&year>1944&year<1990
replace sovcontrol = 1 if ccode==317&year>1944&year<1990
replace sovcontrol = 1 if ccode==701&year>1917&year<1992
replace sovcontrol = 1 if ccode==702&year>1917&year<1992
replace sovcontrol = 1 if ccode==703&year>1917&year<1992
replace sovcontrol = 1 if ccode==704&year>1917&year<1992
replace sovcontrol = 1 if ccode==705&year>1917&year<1992
replace sovcontrol = 1 if ccode==712&year>1921&year<1991
replace sovcontrol = 1 if ccode==339&year>1948&year<1991
replace sovcontrol = 1 if ccode==355&year>1944&year<1990
replace sovcontrol = 1 if ccode==359&year>1944&year<1992
replace sovcontrol = 1 if ccode==360&year>1944&year<1990
replace sovcontrol = 1 if ccode==364&year>1917&year<1992
replace sovcontrol = 1 if ccode==365&year>1917&year<1992
replace sovcontrol = 1 if ccode==366&year>1939&year<1992
replace sovcontrol = 1 if ccode==367&year>1939&year<1992
replace sovcontrol = 1 if ccode==368&year>1939&year<1992
replace sovcontrol = 1 if ccode==369&year>1917&year<1992
replace sovcontrol = 1 if ccode==370&year>1917&year<1992
replace sovcontrol = 1 if ccode==371&year>1917&year<1992
replace sovcontrol = 1 if ccode==372&year>1917&year<1992
replace sovcontrol = 1 if ccode==373&year>1917&year<1992
replace sovcontrol = 1 if ccode==265&year>1944&year<1990
replace sovcontrol = 1 if ccode==310&year>1944&year<1990
replace sovcontrol = 1 if ccode==290&year>1944&year<1990
save "C:\Democracy\AJPS\democworki.dta", replace

*Preparing the Cheibub, Gandhi, Vreeland updated ACLP data:*
use "C:\world statistics\ddrevisited_data_v1 Cheibub et al.dta", clear
save "C:\Democracy\AJPS\Cheibubworking.dta", replace
rename cowcode ccode
*combine Germany, W Germany*
replace ccode = 255 if ccode==260
replace ccode=348 if ctryname== "Serbia and Montenegro"
replace ccode = 342 if ctryname== "Serbia"
replace ccode = 818 if ctryname== "Viet Nam" 
replace ccode = 947 if ctryname== "Tuvalu"
gen cyear = ccode*10000+year
sort cyear
save "C:\Democracy\AJPS\Cheibubworking.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear
drop _merge
merge cyear using "C:\Democracy\AJPS\Cheibubworking.dta"
save "C:\Democracy\AJPS\democworki.dta", replace

insheet using "C:\Democracy\Final data\Morrisson Murtin schooling working.txt", clear
save "C:\Democracy\AJPS\Morrissonworking.txt", replace
gen ccode=.
replace ccode = 700 if country=="Afghanistan"
replace ccode = 339 if country=="Albania"
replace ccode = 615 if country=="Algeria"
replace ccode = 540 if country=="Angola"
replace ccode = 160 if country=="Argentina"
replace ccode = 371 if country=="Armenia"
replace ccode = 900 if country=="Australia"
replace ccode = 305 if country=="Austria"
replace ccode = 373 if country=="Azerbaijan"
replace ccode = 692 if country=="Bahrain"
replace ccode = 771 if country=="Bangladesh"
replace ccode = 370 if country=="Belarus"
replace ccode = 211 if country=="Belgium"
replace ccode = 434 if country=="Benin"
replace ccode = 145 if country=="Bolivia"
replace ccode = 346 if country=="Bosnia"
replace ccode = 346 if country=="Bosnia and Herzegovina"
replace ccode = 571 if country=="Botswana"
replace ccode = 140 if country=="Brazil"
replace ccode = 355 if country=="Bulgaria"
replace ccode = 439 if country=="Burkina Faso"
replace ccode = 775 if country=="Burma"
replace ccode = 775 if country=="Myanmar"
replace ccode = 775 if country=="Myanmar (Burma)"
replace ccode = 516 if country=="Burundi"
replace ccode = 811 if country=="Cambodia"
replace ccode = 471 if country=="Cameroon"
replace ccode = 20 if country=="Canada"
replace ccode = 402 if country=="Cape Verde"
replace ccode = 482 if country=="Central African Republic"
replace ccode = 483 if country=="Chad"
replace ccode = 155 if country=="Chile"
replace ccode = 710 if country=="China"
replace ccode = 100 if country=="Colombia"
replace ccode = 581 if country=="Comoro Islands"
replace ccode = 581 if country=="Comoros"
replace ccode = 484 if country=="Congo 'Brazzaville'"
replace ccode = 484 if country=="Congo, Rep."
replace ccode = 484 if country=="Congo"
replace ccode = 94 if country=="Costa Rica"
replace ccode = 437 if country=="Côte d'Ivoire"
replace ccode = 437 if country=="Cote d'Ivoire"
replace ccode = 437 if country=="Ivory Coast"
replace ccode = 344 if country=="Croatia"
replace ccode = 40 if country=="Cuba"
replace ccode = 316 if country=="Czech Republic"
replace ccode = 315 if country=="Czechoslovakia"
replace ccode = 390 if country=="Denmark"
replace ccode = 522 if country=="Djibouti"
replace ccode = 42 if country=="Dominican Republic"
replace ccode = 42 if country=="Dominican Rep"
replace ccode = 130 if country=="Ecuador"
replace ccode = 651 if country=="Egypt"
replace ccode = 651 if country=="Egypt, Arab Rep."
replace ccode = 92 if country=="El Salvador"
replace ccode = 411 if country=="Equatorial Guinea"
replace ccode = 531 if country=="Eritrea"
replace ccode = 530 if country=="Ethiopia"
replace ccode = 530 if country=="Ethiopia 1993-"
replace ccode = 530 if country=="Ethiopia -pre 1993"
replace ccode = 366 if country=="Estonia"
replace ccode = 375 if country=="Finland"
replace ccode = 220 if country=="France"
replace ccode = 481 if country=="Gabon"
replace ccode = 420 if country=="Gambia"
replace ccode = 420 if country=="Gambia, The"
replace ccode = 372 if country=="Georgia"
replace ccode = 255 if country=="Germany"
replace ccode = 452 if country=="Ghana"
replace ccode = 350 if country=="Greece"
replace ccode = 90 if country=="Guatemala"
replace ccode = 438 if country=="Guinea"
replace ccode = 404 if country=="Guinea Bissau"
replace ccode = 404 if country=="Guinea-Bissau"
replace ccode = 110 if country=="Guyana"
replace ccode = 41 if country=="Haïti"
replace ccode = 91 if country=="Honduras"
replace ccode = 1001 if country=="Hong Kong"
replace ccode = 310 if country=="Hungary"
replace ccode = 750 if country=="India"
replace ccode = 850 if country=="Indonesia (including Timor until 1999)"
replace ccode = 850 if country=="Indonesia"
replace ccode = 630 if country=="Iran"
replace ccode = 645 if country=="Iraq"
replace ccode = 205 if country=="Ireland"
replace ccode = 666 if country=="Israel"
replace ccode = 325 if country=="Italy"
replace ccode = 51 if country=="Jamaica"
replace ccode = 740 if country=="Japan"
replace ccode = 663 if country=="Jordan"
replace ccode = 705 if country=="Kazakhstan"
replace ccode = 501 if country=="Kenya"
replace ccode = 347 if country=="Kosovo"
replace ccode = 690 if country=="Kuwait"
replace ccode = 703 if country=="Kyrgyzstan"
replace ccode = 703 if country=="Kyrgyz Republic"
replace ccode = 812 if country=="Laos"
replace ccode = 812 if country=="Lao PDR"
replace ccode = 367 if country=="Latvia"
replace ccode = 660 if country=="Lebanon"
replace ccode = 570 if country=="Lesotho"
replace ccode = 450 if country=="Liberia"
replace ccode = 620 if country=="Libya"
replace ccode = 368 if country=="Lithuania"
replace ccode = 343 if country=="Macedonia"
replace ccode = 343 if country=="Macedonia, FYR"
replace ccode = 580 if country=="Madagascar"
replace ccode = 553 if country=="Malawi"
replace ccode = 820 if country=="Malaysia"
replace ccode = 432 if country=="Mali"
replace ccode = 435 if country=="Mauritania"
replace ccode = 590 if country=="Mauritius"
replace ccode = 70 if country=="Mexico"
replace ccode = 359 if country=="Moldova"
replace ccode = 712 if country=="Mongolia"
replace ccode = 341 if country=="Montenegro"
replace ccode = 600 if country=="Morocco"
replace ccode = 541 if country=="Mozambique"
replace ccode = 565 if country=="Namibia"
replace ccode = 790 if country=="Nepal"
replace ccode = 210 if country=="Netherlands"
replace ccode = 920 if country=="New Zealand"
replace ccode = 93 if country=="Nicaragua"
replace ccode = 436 if country=="Niger"
replace ccode = 475 if country=="Nigeria"
replace ccode = 731 if country=="North Korea"
replace ccode = 385 if country=="Norway"
replace ccode = 698 if country=="Oman"
replace ccode = 770 if country=="Pakistan"
replace ccode = 770 if country=="Pakistan-pre-1972"
replace ccode = 770 if country=="Pakistan-post-1972"
replace ccode = 95 if country=="Panama"
replace ccode = 150 if country=="Paraguay"
replace ccode = 135 if country=="Peru"
replace ccode = 840 if country=="Philippines"
replace ccode = 290 if country=="Poland"
replace ccode = 235 if country=="Portugal"
replace ccode = 1002 if country=="Puerto Rico"
replace ccode = 694 if country=="Qatar"
replace ccode = 360 if country=="Romania"
replace ccode = 365 if country=="Russian Federation"
replace ccode = 365 if country=="Russia"
replace ccode = 517 if country=="Rwanda"
replace ccode = 403 if country=="São Tomé and Principe"
replace ccode = 670 if country=="Saudi Arabia"
replace ccode = 433 if country=="Senegal"
replace ccode = 342 if country=="Serbia"
replace ccode = 348 if country=="Serbia and Montenegro"
replace ccode = 591 if country=="Seychelles"
replace ccode = 451 if country=="Sierra Leone"
replace ccode = 830 if country=="Singapore"
replace ccode = 317 if country=="Slovakia"
replace ccode = 317 if country=="Slovak Republic"
replace ccode = 349 if country=="Slovenia"
replace ccode = 520 if country=="Somalia"
replace ccode = 560 if country=="South Africa"
replace ccode = 732 if country=="South Korea"
replace ccode = 732 if country=="Korea, Rep."
replace ccode = 731 if country=="Korea, Dem. Rep."
replace ccode = 730 if country=="Korea"
replace ccode = 230 if country=="Spain"
replace ccode = 780 if country=="Sri Lanka"
replace ccode = 625 if country=="Sudan"
replace ccode = 572 if country=="Swaziland"
replace ccode = 380 if country=="Sweden"
replace ccode = 225 if country=="Switzerland"
replace ccode = 652 if country=="Syria"
replace ccode = 652 if country=="Syrian Arab Republic"
replace ccode = 713 if country=="Taiwan"
replace ccode = 702 if country=="Tajikistan"
replace ccode = 510 if country=="Tanzania"
replace ccode = 800 if country=="Thailand"
replace ccode = 461 if country=="Togo"
replace ccode = 365 if country=="Total Former USSR"
replace ccode = 365 if country=="USSR"
replace ccode = 52 if country=="Trinidad and Tobago"
replace ccode = 52 if country=="Trinidad & Tobago"
replace ccode = 616 if country=="Tunisia"
replace ccode = 640 if country=="Turkey"
replace ccode = 701 if country=="Turkmenistan"
replace ccode = 500 if country=="Uganda"
replace ccode = 369 if country=="Ukraine"
replace ccode = 696 if country=="United Arab Emirates"
replace ccode = 200 if country=="United Kingdom"
replace ccode = 2 if country=="United States"
replace ccode = 165 if country=="Uruguay"
replace ccode = 704 if country=="Uzbekistan"
replace ccode = 101 if country=="Venezuela"
replace ccode = 101 if country=="Venezuela, RB"
replace ccode = 818 if country=="Vietnam"
replace ccode = 816 if country=="Vietnam North"
replace ccode = 817 if country=="Vietnam South"
replace ccode = 816 if country=="Vietnam, North"
replace ccode = 817 if country=="Vietnam, South"
replace ccode = 1005 if country=="West Bank and Gaza"
replace ccode = 679 if country=="Yemen"
replace ccode = 678 if country=="Yemen North"
replace ccode = 678 if country=="Yemen, N.Arab"
replace ccode = 680 if country=="Yemen South"
replace ccode = 680 if country=="Yemen, South"
replace ccode = 345 if country=="Yugoslavia"
replace ccode = 345 if country== "Yugoslavia - post 1991"
replace ccode = 345 if country== "Yugoslavia-pre 1991"
replace ccode = 490 if country=="Zaire (Congo Kinshasa)"
replace ccode = 490 if country=="Zaire"
replace ccode = 490 if country=="Congo, Dem. Rep."
replace ccode = 551 if country=="Zambia"
replace ccode = 552 if country=="Zimbabwe"
replace ccode = 232 if country=="Andorra"
replace ccode = 58 if country=="Antigua"
replace ccode = 31 if country=="Bahamas"
replace ccode = 53 if country=="Barbados"
replace ccode = 80 if country=="Belize"
replace ccode = 760 if country=="Bhutan"
replace ccode = 835 if country=="Brunei"
replace ccode = 352 if country=="Cyprus"
replace ccode = 54 if country=="Dominica"
replace ccode = 860 if country=="East Timor"
replace ccode = 950 if country=="Fiji"
replace ccode = 265 if country=="Germany, East"
replace ccode = 55 if country=="Grenada"
replace ccode = 41 if country=="Haiti"
replace ccode = 395 if country=="Iceland"
replace ccode = 946 if country=="Kiribati"
replace ccode = 212 if country=="Luxembourg"
replace ccode = 223 if country=="Liechtenstein"
replace ccode = 781 if country=="Maldives"
replace ccode = 338 if country=="Malta"
replace ccode = 910 if country=="Papua New Guinea"
replace ccode = 403 if country=="Sao Tome and Principe"
replace ccode = 940 if country=="Solomon Islands"
replace ccode = 60 if country=="St. Kitts and Nevis"
replace ccode = 60 if country=="St. Kitts & Nevis"
replace ccode = 56 if country=="St. Lucia"
replace ccode = 57 if country=="St. Vincent and the Grenadines"
replace ccode = 57 if country=="St. Vincent & Grenadines"
replace ccode = 57 if country=="St. Vicent & Grenadines"
replace ccode = 115 if country=="Suriname"
replace ccode = 955 if country=="Tonga"
replace ccode = 115 if country=="Suriname"
replace ccode = 935 if country=="Vanuatu"
replace ccode = 990 if country=="Western Samoa"
replace ccode = 990 if country=="Samoa (Western)"
drop if ccode==.
gen cyear = ccode*10000+ year
rename country countrymm
sort cyear
save "C:\Democracy\AJPS\Morrissonworking.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear
drop _merge
sort cyear
merge cyear using "C:\Democracy\AJPS\Morrissonworking.dta"
save "C:\Democracy\AJPS\democworki.dta", replace

*FH press data*
insheet using "C:\Democracy\fhpress.txt", clear
reshape long fhpress, i(country) j(year)
gen ccode=.
replace ccode = 700 if country=="Afghanistan"
replace ccode = 339 if country=="Albania"
replace ccode = 615 if country=="Algeria"
replace ccode = 540 if country=="Angola"
replace ccode = 160 if country=="Argentina"
replace ccode = 371 if country=="Armenia"
replace ccode = 900 if country=="Australia"
replace ccode = 305 if country=="Austria"
replace ccode = 373 if country=="Azerbaijan"
replace ccode = 692 if country=="Bahrain"
replace ccode = 771 if country=="Bangladesh"
replace ccode = 370 if country=="Belarus"
replace ccode = 211 if country=="Belgium"
replace ccode = 434 if country=="Benin"
replace ccode = 145 if country=="Bolivia"
replace ccode = 346 if country=="Bosnia"
replace ccode = 346 if country=="Bosnia-Herzegovina"
replace ccode = 571 if country=="Botswana"
replace ccode = 140 if country=="Brazil"
replace ccode = 355 if country=="Bulgaria"
replace ccode = 439 if country=="Burkina Faso"
replace ccode = 775 if country=="Burma"
replace ccode = 775 if country=="Myanmar"
replace ccode = 775 if country=="Burma (Myanmar)"
replace ccode = 516 if country=="Burundi"
replace ccode = 811 if country=="Cambodia"
replace ccode = 471 if country=="Cameroon"
replace ccode = 20 if country=="Canada"
replace ccode = 402 if country=="Cape Verde"
replace ccode = 482 if country=="Central African Republic"
replace ccode = 483 if country=="Chad"
replace ccode = 155 if country=="Chile"
replace ccode = 710 if country=="China"
replace ccode = 100 if country=="Colombia"
replace ccode = 581 if country=="Comoro Islands"
replace ccode = 581 if country=="Comoros"
replace ccode = 484 if country=="Congo 'Brazzaville'"
replace ccode = 484 if country=="Congo, Republic of (Brazzaville)"
replace ccode = 484 if country=="Congo"
replace ccode = 94 if country=="Costa Rica"
replace ccode = 437 if country=="Côte d'Ivoire"
replace ccode = 437 if country=="Cote d'Ivoire"
replace ccode = 437 if country=="Ivory Coast"
replace ccode = 344 if country=="Croatia"
replace ccode = 40 if country=="Cuba"
replace ccode = 316 if country=="Czech Republic"
replace ccode = 315 if country=="Czechoslovakia"
replace ccode = 390 if country=="Denmark"
replace ccode = 522 if country=="Djibouti"
replace ccode = 42 if country=="Dominican Republic"
replace ccode = 42 if country=="Dominican Rep"
replace ccode = 130 if country=="Ecuador"
replace ccode = 651 if country=="Egypt"
replace ccode = 651 if country=="Egypt, Arab Rep."
replace ccode = 92 if country=="El Salvador"
replace ccode = 411 if country=="Equatorial Guinea"
replace ccode = 531 if country=="Eritrea"
replace ccode = 530 if country=="Ethiopia"
replace ccode = 530 if country=="Ethiopia 1993-"
replace ccode = 530 if country=="Ethiopia -pre 1993"
replace ccode = 366 if country=="Estonia"
replace ccode = 375 if country=="Finland"
replace ccode = 220 if country=="France"
replace ccode = 481 if country=="Gabon"
replace ccode = 420 if country=="Gambia"
replace ccode = 420 if country=="Gambia, The"
replace ccode = 372 if country=="Georgia"
replace ccode = 255 if country=="Germany"
replace ccode = 452 if country=="Ghana"
replace ccode = 350 if country=="Greece"
replace ccode = 90 if country=="Guatemala"
replace ccode = 438 if country=="Guinea"
replace ccode = 404 if country=="Guinea Bissau"
replace ccode = 404 if country=="Guinea-Bissau"
replace ccode = 110 if country=="Guyana"
replace ccode = 41 if country=="Haïti"
replace ccode = 91 if country=="Honduras"
replace ccode = 1001 if country=="Hong Kong (China)"
replace ccode = 310 if country=="Hungary"
replace ccode = 750 if country=="India"
replace ccode = 850 if country=="Indonesia (including Timor until 1999)"
replace ccode = 850 if country=="Indonesia"
replace ccode = 630 if country=="Iran"
replace ccode = 645 if country=="Iraq"
replace ccode = 205 if country=="Ireland"
replace ccode = 666 if country=="Israel"
replace ccode = 325 if country=="Italy"
replace ccode = 51 if country=="Jamaica"
replace ccode = 740 if country=="Japan"
replace ccode = 663 if country=="Jordan"
replace ccode = 705 if country=="Kazakhstan"
replace ccode = 501 if country=="Kenya"
replace ccode = 347 if country=="Kosovo"
replace ccode = 690 if country=="Kuwait"
replace ccode = 703 if country=="Kyrgyzstan"
replace ccode = 703 if country=="Kyrgyz Republic"
replace ccode = 812 if country=="Laos"
replace ccode = 812 if country=="Lao PDR"
replace ccode = 367 if country=="Latvia"
replace ccode = 660 if country=="Lebanon"
replace ccode = 570 if country=="Lesotho"
replace ccode = 450 if country=="Liberia"
replace ccode = 620 if country=="Libya"
replace ccode = 368 if country=="Lithuania"
replace ccode = 343 if country=="Macedonia"
replace ccode = 343 if country=="Macedonia, FYR"
replace ccode = 580 if country=="Madagascar"
replace ccode = 553 if country=="Malawi"
replace ccode = 820 if country=="Malaysia"
replace ccode = 432 if country=="Mali"
replace ccode = 435 if country=="Mauritania"
replace ccode = 590 if country=="Mauritius"
replace ccode = 70 if country=="Mexico"
replace ccode = 359 if country=="Moldova"
replace ccode = 712 if country=="Mongolia"
replace ccode = 341 if country=="Montenegro"
replace ccode = 600 if country=="Morocco"
replace ccode = 541 if country=="Mozambique"
replace ccode = 565 if country=="Namibia"
replace ccode = 790 if country=="Nepal"
replace ccode = 210 if country=="Netherlands"
replace ccode = 920 if country=="New Zealand"
replace ccode = 93 if country=="Nicaragua"
replace ccode = 436 if country=="Niger"
replace ccode = 475 if country=="Nigeria"
replace ccode = 731 if country=="North Korea"
replace ccode = 385 if country=="Norway"
replace ccode = 698 if country=="Oman"
replace ccode = 770 if country=="Pakistan"
replace ccode = 770 if country=="Pakistan-pre-1972"
replace ccode = 770 if country=="Pakistan-post-1972"
replace ccode = 95 if country=="Panama"
replace ccode = 150 if country=="Paraguay"
replace ccode = 135 if country=="Peru"
replace ccode = 840 if country=="Philippines"
replace ccode = 290 if country=="Poland"
replace ccode = 235 if country=="Portugal"
replace ccode = 1002 if country=="Puerto Rico"
replace ccode = 694 if country=="Qatar"
replace ccode = 360 if country=="Romania"
replace ccode = 365 if country=="Russian Federation"
replace ccode = 365 if country=="Russia"
replace ccode = 517 if country=="Rwanda"
replace ccode = 403 if country=="São Tomé and Principe"
replace ccode = 670 if country=="Saudi Arabia"
replace ccode = 433 if country=="Senegal"
replace ccode = 342 if country=="Serbia"
replace ccode = 348 if country=="Serbia and Montenegro"
replace ccode = 591 if country=="Seychelles"
replace ccode = 451 if country=="Sierra Leone"
replace ccode = 830 if country=="Singapore"
replace ccode = 317 if country=="Slovakia"
replace ccode = 317 if country=="Slovak Republic"
replace ccode = 349 if country=="Slovenia"
replace ccode = 520 if country=="Somalia"
replace ccode = 560 if country=="South Africa"
replace ccode = 732 if country=="South Korea"
replace ccode = 732 if country=="Korea, Rep."
replace ccode = 731 if country=="Korea, Dem. Rep."
replace ccode = 730 if country=="Korea"
replace ccode = 230 if country=="Spain"
replace ccode = 780 if country=="Sri Lanka"
replace ccode = 625 if country=="Sudan"
replace ccode = 572 if country=="Swaziland"
replace ccode = 380 if country=="Sweden"
replace ccode = 225 if country=="Switzerland"
replace ccode = 652 if country=="Syria"
replace ccode = 652 if country=="Syrian Arab Republic"
replace ccode = 713 if country=="Taiwan"
replace ccode = 702 if country=="Tajikistan"
replace ccode = 510 if country=="Tanzania"
replace ccode = 800 if country=="Thailand"
replace ccode = 461 if country=="Togo"
replace ccode = 52 if country=="Trinidad and Tobago"
replace ccode = 52 if country=="Trinidad & Tobago"
replace ccode = 616 if country=="Tunisia"
replace ccode = 640 if country=="Turkey"
replace ccode = 701 if country=="Turkmenistan"
replace ccode = 500 if country=="Uganda"
replace ccode = 369 if country=="Ukraine"
replace ccode = 696 if country=="United Arab Emirates"
replace ccode = 200 if country=="United Kingdom"
replace ccode = 2 if country=="United States"
replace ccode = 165 if country=="Uruguay"
replace ccode = 704 if country=="Uzbekistan"
replace ccode = 101 if country=="Venezuela"
replace ccode = 101 if country=="Venezuela, RB"
replace ccode = 818 if country=="Vietnam"
replace ccode = 816 if country=="Vietnam North"
replace ccode = 817 if country=="Vietnam South"
replace ccode = 816 if country=="Vietnam, North"
replace ccode = 817 if country=="Vietnam, South"
replace ccode = 1005 if country=="West Bank"
replace ccode = 679 if country=="Yemen"
replace ccode = 678 if country=="Yemen North"
replace ccode = 678 if country=="Yemen, N.Arab"
replace ccode = 680 if country=="Yemen South"
replace ccode = 680 if country=="Yemen, South"
replace ccode = 345 if country=="Yugoslavia, Fed. Rep."
replace ccode = 345 if country== "Yugoslavia - post 1991"
replace ccode = 345 if country== "Yugoslavia-pre 1991"
replace ccode = 490 if country=="Zaire (Congo Kinshasa)"
replace ccode = 490 if country=="Zaire"
replace ccode = 490 if country=="Congo, Democratic Republic of (Kinshasa)"
replace ccode = 551 if country=="Zambia"
replace ccode = 552 if country=="Zimbabwe"
replace ccode = 232 if country=="Andorra"
replace ccode = 58 if country=="Antigua and Barbuda"
replace ccode = 31 if country=="Bahamas"
replace ccode = 53 if country=="Barbados"
replace ccode = 80 if country=="Belize"
replace ccode = 760 if country=="Bhutan"
replace ccode = 835 if country=="Brunei"
replace ccode = 352 if country=="Cyprus (Greek)"
replace ccode = 54 if country=="Dominica"
replace ccode = 860 if country=="East Timor"
replace ccode = 950 if country=="Fiji"
replace ccode = 265 if country=="Germany, East"
replace ccode = 55 if country=="Grenada"
replace ccode = 41 if country=="Haiti"
replace ccode = 395 if country=="Iceland"
replace ccode = 946 if country=="Kiribati"
replace ccode = 212 if country=="Luxembourg"
replace ccode = 223 if country=="Liechtenstein"
replace ccode = 781 if country=="Maldives"
replace ccode = 338 if country=="Malta"
replace ccode = 910 if country=="Papua New Guinea"
replace ccode = 403 if country=="Sao Tome and Principe"
replace ccode = 940 if country=="Solomon Islands"
replace ccode = 60 if country=="St. Kitts and Nevis"
replace ccode = 60 if country=="Saint Kitts and Nevis"
replace ccode = 56 if country=="Saint Lucia"
replace ccode = 57 if country=="Saint Vincent and the Grenadines"
replace ccode = 57 if country=="St. Vincent & Grenadines"
replace ccode = 57 if country=="St. Vicent & Grenadines"
replace ccode = 115 if country=="Suriname"
replace ccode = 955 if country=="Tonga"
replace ccode = 115 if country=="Suriname"
replace ccode = 935 if country=="Vanuatu"
replace ccode = 990 if country=="Western Samoa"
replace ccode = 990 if country=="Samoa"
drop if ccode==.
save "C:\Democracy\fhpresswork.dta", replace
gen cyear = ccode*10000+ year
sort cyear
save "C:\Democracy\fhpresswork.dta", replace
use "C:\Democracy\AJPS\democworki.dta", clear
drop _merge
sort cyear
merge cyear using "C:\Democracy\fhpresswork.dta", sort
save "C:\Democracy\AJPS\democworki.dta", replace


*Ross oil and gas data
insheet using "C:\Democracy\Ross Oil & Gas 1932-2009 public.txt", clear
save "C:\Democracy\Rosswork.dta", replace
rename cty_name country
gen ccode=.
replace ccode = 700 if country=="Afghanistan"
replace ccode = 339 if country=="Albania"
replace ccode = 615 if country=="Algeria"
replace ccode = 540 if country=="Angola"
replace ccode = 160 if country=="Argentina"
replace ccode = 371 if country=="Armenia"
replace ccode = 900 if country=="Australia"
replace ccode = 305 if country=="Austria"
replace ccode = 373 if country=="Azerbaijan"
replace ccode = 692 if country=="Bahrain"
replace ccode = 771 if country=="Bangladesh"
replace ccode = 370 if country=="Belarus"
replace ccode = 211 if country=="Belgium"
replace ccode = 434 if country=="Benin"
replace ccode = 145 if country=="Bolivia"
replace ccode = 346 if country=="Bosnia"
replace ccode = 346 if country=="Bosnia and Herzegovina"
replace ccode = 571 if country=="Botswana"
replace ccode = 140 if country=="Brazil"
replace ccode = 355 if country=="Bulgaria"
replace ccode = 439 if country=="Burkina Faso"
replace ccode = 775 if country=="Burma"
replace ccode = 775 if country=="Myanmar"
replace ccode = 775 if country=="Myanmar (Burma)"
replace ccode = 516 if country=="Burundi"
replace ccode = 811 if country=="Cambodia"
replace ccode = 471 if country=="Cameroon"
replace ccode = 20 if country=="Canada"
replace ccode = 402 if country=="Cape Verde"
replace ccode = 482 if country=="Central African Republic"
replace ccode = 483 if country=="Chad"
replace ccode = 155 if country=="Chile"
replace ccode = 710 if country=="China"
replace ccode = 100 if country=="Colombia"
replace ccode = 581 if country=="Comoro Islands"
replace ccode = 581 if country=="Comoros"
replace ccode = 484 if country=="Congo 'Brazzaville'"
replace ccode = 484 if country=="Congo, Rep."
replace ccode = 484 if country=="Congo"
replace ccode = 94 if country=="Costa Rica"
replace ccode = 437 if country=="Côte d'Ivoire"
replace ccode = 437 if country=="Cote d'Ivoire"
replace ccode = 437 if country=="Ivory Coast"
replace ccode = 344 if country=="Croatia"
replace ccode = 40 if country=="Cuba"
replace ccode = 316 if country=="Czech Republic"
replace ccode = 315 if country=="Czechoslovakia"
replace ccode = 390 if country=="Denmark"
replace ccode = 522 if country=="Djibouti"
replace ccode = 42 if country=="Dominican Republic"
replace ccode = 42 if country=="Dominican Rep"
replace ccode = 130 if country=="Ecuador"
replace ccode = 651 if country=="Egypt"
replace ccode = 651 if country=="Egypt, Arab Rep."
replace ccode = 92 if country=="El Salvador"
replace ccode = 411 if country=="Equatorial Guinea"
replace ccode = 531 if country=="Eritrea"
replace ccode = 530 if country=="Ethiopia"
replace ccode = 530 if country=="Ethiopia 1993-"
replace ccode = 530 if country=="Ethiopia -pre 1993"
replace ccode = 366 if country=="Estonia"
replace ccode = 375 if country=="Finland"
replace ccode = 220 if country=="France"
replace ccode = 481 if country=="Gabon"
replace ccode = 420 if country=="Gambia"
replace ccode = 420 if country=="Gambia, The"
replace ccode = 372 if country=="Georgia"
replace ccode = 255 if country=="Germany"
replace ccode = 452 if country=="Ghana"
replace ccode = 350 if country=="Greece"
replace ccode = 90 if country=="Guatemala"
replace ccode = 438 if country=="Guinea"
replace ccode = 404 if country=="Guinea Bissau"
replace ccode = 404 if country=="Guinea-Bissau"
replace ccode = 110 if country=="Guyana"
replace ccode = 41 if country=="Haïti"
replace ccode = 91 if country=="Honduras"
replace ccode = 1001 if country=="Hong Kong SAR, China"
replace ccode = 310 if country=="Hungary"
replace ccode = 750 if country=="India"
replace ccode = 850 if country=="Indonesia (including Timor until 1999)"
replace ccode = 850 if country=="Indonesia"
replace ccode = 630 if country=="Iran, Islamic Rep."
replace ccode = 645 if country=="Iraq"
replace ccode = 205 if country=="Ireland"
replace ccode = 666 if country=="Israel"
replace ccode = 325 if country=="Italy"
replace ccode = 51 if country=="Jamaica"
replace ccode = 740 if country=="Japan"
replace ccode = 663 if country=="Jordan"
replace ccode = 705 if country=="Kazakhstan"
replace ccode = 501 if country=="Kenya"
replace ccode = 347 if country=="Kosovo"
replace ccode = 690 if country=="Kuwait"
replace ccode = 703 if country=="Kyrgyzstan"
replace ccode = 703 if country=="Kyrgyz Republic"
replace ccode = 812 if country=="Laos"
replace ccode = 812 if country=="Lao PDR"
replace ccode = 367 if country=="Latvia"
replace ccode = 660 if country=="Lebanon"
replace ccode = 570 if country=="Lesotho"
replace ccode = 450 if country=="Liberia"
replace ccode = 620 if country=="Libya"
replace ccode = 368 if country=="Lithuania"
replace ccode = 343 if country=="Macedonia"
replace ccode = 343 if country=="Macedonia, FYR"
replace ccode = 580 if country=="Madagascar"
replace ccode = 553 if country=="Malawi"
replace ccode = 820 if country=="Malaysia"
replace ccode = 432 if country=="Mali"
replace ccode = 435 if country=="Mauritania"
replace ccode = 590 if country=="Mauritius"
replace ccode = 70 if country=="Mexico"
replace ccode = 359 if country=="Moldova"
replace ccode = 712 if country=="Mongolia"
replace ccode = 341 if country=="Montenegro"
replace ccode = 600 if country=="Morocco"
replace ccode = 541 if country=="Mozambique"
replace ccode = 565 if country=="Namibia"
replace ccode = 790 if country=="Nepal"
replace ccode = 210 if country=="Netherlands"
replace ccode = 920 if country=="New Zealand"
replace ccode = 93 if country=="Nicaragua"
replace ccode = 436 if country=="Niger"
replace ccode = 475 if country=="Nigeria"
replace ccode = 731 if country=="North Korea"
replace ccode = 385 if country=="Norway"
replace ccode = 698 if country=="Oman"
replace ccode = 770 if country=="Pakistan"
replace ccode = 770 if country=="Pakistan-pre-1972"
replace ccode = 770 if country=="Pakistan-post-1972"
replace ccode = 95 if country=="Panama"
replace ccode = 150 if country=="Paraguay"
replace ccode = 135 if country=="Peru"
replace ccode = 840 if country=="Philippines"
replace ccode = 290 if country=="Poland"
replace ccode = 235 if country=="Portugal"
replace ccode = 1002 if country=="Puerto Rico"
replace ccode = 694 if country=="Qatar"
replace ccode = 360 if country=="Romania"
replace ccode = 365 if country=="Russian Federation"
replace ccode = 365 if country=="Russia"
replace ccode = 517 if country=="Rwanda"
replace ccode = 403 if country=="São Tomé and Principe"
replace ccode = 670 if country=="Saudi Arabia"
replace ccode = 433 if country=="Senegal"
replace ccode = 342 if country=="Serbia"
replace ccode = 348 if country=="Serbia and Montenegro"
replace ccode = 591 if country=="Seychelles"
replace ccode = 451 if country=="Sierra Leone"
replace ccode = 830 if country=="Singapore"
replace ccode = 317 if country=="Slovakia"
replace ccode = 317 if country=="Slovak Republic"
replace ccode = 349 if country=="Slovenia"
replace ccode = 520 if country=="Somalia"
replace ccode = 560 if country=="South Africa"
replace ccode = 732 if country=="South Korea"
replace ccode = 732 if country=="Korea, Rep."
replace ccode = 731 if country=="Korea, Dem. Rep."
replace ccode = 730 if country=="Korea"
replace ccode = 230 if country=="Spain"
replace ccode = 780 if country=="Sri Lanka"
replace ccode = 625 if country=="Sudan"
replace ccode = 572 if country=="Swaziland"
replace ccode = 380 if country=="Sweden"
replace ccode = 225 if country=="Switzerland"
replace ccode = 652 if country=="Syria"
replace ccode = 652 if country=="Syrian Arab Republic"
replace ccode = 713 if country=="Taiwan"
replace ccode = 702 if country=="Tajikistan"
replace ccode = 510 if country=="Tanzania"
replace ccode = 800 if country=="Thailand"
replace ccode = 461 if country=="Togo"
drop if country=="U.S.S.R."
*this doubles with Russia
replace ccode = 52 if country=="Trinidad and Tobago"
replace ccode = 52 if country=="Trinidad & Tobago"
replace ccode = 616 if country=="Tunisia"
replace ccode = 640 if country=="Turkey"
replace ccode = 701 if country=="Turkmenistan"
replace ccode = 500 if country=="Uganda"
replace ccode = 369 if country=="Ukraine"
replace ccode = 696 if country=="United Arab Emirates"
replace ccode = 200 if country=="United Kingdom"
replace ccode = 2 if country=="United States"
replace ccode = 165 if country=="Uruguay"
replace ccode = 704 if country=="Uzbekistan"
replace ccode = 101 if country=="Venezuela"
replace ccode = 101 if country=="Venezuela, RB"
replace ccode = 818 if country=="Vietnam"
replace ccode = 816 if country=="Vietnam North"
replace ccode = 817 if country=="Vietnam South"
replace ccode = 816 if country=="Vietnam, North"
replace ccode = 817 if country=="Vietnam, South"
replace ccode = 1005 if country=="West Bank and Gaza"
replace ccode = 679 if country=="Yemen, Rep."
replace ccode = 678 if country=="Yemen North"
replace ccode = 678 if country=="Yemen, N.Arab"
replace ccode = 680 if country=="Yemen South"
replace ccode = 680 if country=="Yemen, South"
replace ccode = 345 if country=="Yugoslavia, Fed. Rep."
replace ccode = 345 if country== "Yugoslavia - post 1991"
replace ccode = 345 if country== "Yugoslavia-pre 1991"
replace ccode = 490 if country=="Zaire (Congo Kinshasa)"
replace ccode = 490 if country=="Zaire"
replace ccode = 490 if country=="Congo, Dem. Rep."
replace ccode = 551 if country=="Zambia"
replace ccode = 552 if country=="Zimbabwe"
replace ccode = 232 if country=="Andorra"
replace ccode = 58 if country=="Antigua and Barbuda"
replace ccode = 31 if country=="Bahamas, The"
replace ccode = 53 if country=="Barbados"
replace ccode = 80 if country=="Belize"
replace ccode = 760 if country=="Bhutan"
replace ccode = 835 if country=="Brunei"
replace ccode = 352 if country=="Cyprus"
replace ccode = 54 if country=="Dominica"
replace ccode = 860 if country=="East Timor"
replace ccode = 950 if country=="Fiji"
replace ccode = 265 if country=="Germany, East"
replace ccode = 55 if country=="Grenada"
replace ccode = 41 if country=="Haiti"
replace ccode = 212 if country=="Luxembourg"
replace ccode = 223 if country=="Liechtenstein"
replace ccode = 781 if country=="Maldives"
replace ccode = 338 if country=="Malta"
replace ccode = 910 if country=="Papua New Guinea"
replace ccode = 403 if country=="Sao Tome and Principe"
replace ccode = 940 if country=="Solomon Islands"
replace ccode = 60 if country=="St. Kitts and Nevis"
replace ccode = 60 if country=="St. Kitts & Nevis"
replace ccode = 56 if country=="St. Lucia"
replace ccode = 57 if country=="St. Vincent and the Grenadines"
replace ccode = 57 if country=="St. Vincent & Grenadines"
replace ccode = 57 if country=="St. Vicent & Grenadines"
replace ccode = 115 if country=="Suriname"
replace ccode = 955 if country=="Tonga"
replace ccode = 115 if country=="Suriname"
replace ccode = 935 if country=="Vanuatu"
replace ccode = 990 if country=="Western Samoa"
replace ccode = 990 if country=="Samoa (Western)"
drop if ccode==.
gen cyear = ccode*10000+ year
sort cyear

save "C:\Democracy\Rosswork.dta", replace
use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear
drop _merge
merge cyear using "C:\Democracy\Rosswork.dta", sort
save "C:\Democracy\AJPS\democworki.dta", replace

*if country had no oil and gas income in first year it enters Ross database, assume that it had no oil and gas income in preceding years
*Otherwise, big loss of data due to fact that Ross data starts only in 1930s.
xtset ccode year
gen lnoil = ln(1+oil_gas_valuepop_2000)
by ccode: gen firstlnoil = lnoil if l.lnoil==.
by ccode: egen firstav = mean(firstlnoil)
replace lnoil = 0 if lnoil==.&firstav==0
drop if ccode==348
drop cyear
gen cyear= ccode*10000+year
save "C:\Democracy\AJPS\democworki.dta", replace

*Chenoweth data*

use "C:\Democracy\Final data\chenoweth\WCRWreplication.dta" , clear
save "C:\Democracy\Final data\chenoweth\chenwork.dta" , replace
gen ccode=.
replace ccode = 700 if location=="Afghanistan"
replace ccode = 339 if location=="Albania"
replace ccode = 615 if location=="Algeria"
replace ccode = 540 if location=="Angola"
replace ccode = 160 if location=="Argentina"
replace ccode = 371 if location=="Armenia"
replace ccode = 900 if location=="Australia"
replace ccode = 305 if location=="Austria"
replace ccode = 373 if location=="Azerbaijan"
replace ccode = 692 if location=="Bahrain"
replace ccode = 771 if location=="Bangladesh"
replace ccode = 370 if location=="Belarus"
replace ccode = 211 if location=="Belgium"
replace ccode = 434 if location=="Benin"
replace ccode = 145 if location=="Bolivia"
replace ccode = 346 if location=="Bosnia"
replace ccode = 346 if location=="Bosnia and Herzegovina"
replace ccode = 346 if location=="Bosnia-Herzegovina"
replace ccode = 571 if location=="Botswana"
replace ccode = 140 if location=="Brazil"
replace ccode = 355 if location=="Bulgaria"
replace ccode = 439 if location=="Burkina Faso"
replace ccode = 775 if location=="Burma"
replace ccode = 775 if location=="Myanmar"
replace ccode = 775 if location=="Myanmar (Burma)"
replace ccode = 516 if location=="Burundi"
replace ccode = 811 if location=="Cambodia"
replace ccode = 471 if location=="Cameroon"
replace ccode = 20 if location=="Canada"
replace ccode = 402 if location=="Cape Verde"
replace ccode = 482 if location=="CAR"
replace ccode = 483 if location=="Chad"
replace ccode = 155 if location=="Chile"
replace ccode = 710 if location=="China"
replace ccode = 710 if location=="Tibet"
replace ccode = 100 if location=="Colombia"
replace ccode = 581 if location=="Comoro Islands"
replace ccode = 581 if location=="Comoros"
replace ccode = 484 if location=="Congo-Brazzaville (ROC)"
replace ccode = 484 if location=="Congo, Republic of"
replace ccode = 484 if location=="Congo, Rep."
replace ccode = 484 if location=="Republic of the Congo"
replace ccode = 94 if location=="Costa Rica"
replace ccode = 437 if location=="Côte d'Ivoire"
replace ccode = 437 if location=="Cote d'Ivoire"
replace ccode = 437 if location=="Ivory Coast"
replace ccode = 344 if location=="Croatia"
replace ccode = 40 if location=="Cuba"
replace ccode = 316 if location=="Czech Republic"
replace ccode = 315 if location=="Czechoslovakia"
replace ccode = 390 if location=="Denmark"
replace ccode = 522 if location=="Djibouti"
replace ccode = 42 if location=="Dominican Republic"
replace ccode = 42 if location=="Dominican Rep"
replace ccode = 130 if location=="Ecuador"
replace ccode = 651 if location=="Egypt"
replace ccode = 651 if location=="Egypt, Arab Rep."
replace ccode = 92 if location=="El Salvador"
replace ccode = 411 if location=="Equatorial Guinea"
replace ccode = 531 if location=="Eritrea"
replace ccode = 530 if location=="Ethiopia"
replace ccode = 530 if location=="Ethiopia 1993-"
replace ccode = 530 if location=="Ethiopia -pre 1993"
replace ccode = 366 if location=="Estonia"
replace ccode = 375 if location=="Finland"
replace ccode = 220 if location=="France"
replace ccode = 481 if location=="Gabon"
replace ccode = 420 if location=="Gambia"
replace ccode = 420 if location=="Gambia, The"
replace ccode = 372 if location=="Georgia"
replace ccode = 255 if location=="Germany"
replace ccode = 452 if location=="Ghana"
replace ccode = 350 if location=="Greece"
replace ccode = 90 if location=="Guatemala"
replace ccode = 438 if location=="Guinea"
replace ccode = 404 if location=="Guinea Bissau"
replace ccode = 404 if location=="Guinea-Bissau"
replace ccode = 404 if location=="Guinea-Biaasu"
replace ccode = 110 if location=="Guyana"
replace ccode = 41 if location=="Haïti"
replace ccode = 91 if location=="Honduras"
replace ccode = 1001 if location=="Hong Kong"
replace ccode = 310 if location=="Hungary"
replace ccode = 750 if location=="India"
replace ccode = 850 if location=="Indonesia (including Timor until 1999)"
replace ccode = 850 if location=="Indonesia"
replace ccode = 630 if location=="Iran"
replace ccode = 645 if location=="Iraq"
replace ccode = 205 if location=="Ireland"
replace ccode = 666 if location=="Israel"
replace ccode = 325 if location=="Italy"
replace ccode = 51 if location=="Jamaica"
replace ccode = 740 if location=="Japan"
replace ccode = 663 if location=="Jordan"
replace ccode = 705 if location=="Kazakhstan"
replace ccode = 501 if location=="Kenya"
replace ccode = 347 if location=="Kosovo"
replace ccode = 690 if location=="Kuwait"
replace ccode = 703 if location=="Kyrgyzstan"
replace ccode = 703 if location=="Kyrgyz Republic"
replace ccode = 812 if location=="Laos"
replace ccode = 812 if location=="Lao PDR"
replace ccode = 367 if location=="Latvia"
replace ccode = 660 if location=="Lebanon"
replace ccode = 570 if location=="Lesotho"
replace ccode = 450 if location=="Liberia"
replace ccode = 620 if location=="Libya"
replace ccode = 368 if location=="Lithuania"
replace ccode = 343 if location=="Macedonia"
replace ccode = 343 if location=="Macedonia, FYR"
replace ccode = 580 if location=="Madagascar"
replace ccode = 553 if location=="Malawi"
replace ccode = 820 if location=="Malaysia"
replace ccode = 432 if location=="Mali"
replace ccode = 435 if location=="Mauritania"
replace ccode = 590 if location=="Mauritius"
replace ccode = 70 if location=="Mexico"
replace ccode = 359 if location=="Moldova"
replace ccode = 712 if location=="Mongolia"
replace ccode = 341 if location=="Montenegro"
replace ccode = 600 if location=="Morocco"
replace ccode = 541 if location=="Mozambique"
replace ccode = 565 if location=="Namibia/South West Africa"
replace ccode = 790 if location=="Nepal"
replace ccode = 210 if location=="Netherlands"
replace ccode = 920 if location=="New Zealand"
replace ccode = 93 if location=="Nicaragua"
replace ccode = 436 if location=="Niger"
replace ccode = 475 if location=="Nigeria"
replace ccode = 731 if location=="North Korea"
replace ccode = 385 if location=="Norway"
replace ccode = 698 if location=="Oman"
replace ccode = 770 if location=="Pakistan"
replace ccode = 770 if location=="Pakistan-pre-1972"
replace ccode = 770 if location=="Pakistan-post-1972"
replace ccode = 95 if location=="Panama"
replace ccode = 150 if location=="Paraguay"
replace ccode = 135 if location=="Peru"
replace ccode = 840 if location=="Phillipines"
replace ccode = 840 if location=="Philippines"
replace ccode = 290 if location=="Poland"
replace ccode = 235 if location=="Portugal"
replace ccode = 1002 if location=="Puerto Rico"
replace ccode = 694 if location=="Qatar"
replace ccode = 360 if location=="Romania"
replace ccode = 365 if location=="Russian Federation"
replace ccode = 365 if location=="Russia"
replace ccode = 517 if location=="Rwanda"
replace ccode = 403 if location=="Sao Tome e Principe"
replace ccode = 403 if location=="São Tomé and Principe"
replace ccode = 670 if location=="Saudi Arabia"
replace ccode = 433 if location=="Senegal"
replace ccode = 342 if location=="Serbia"
replace ccode = 348 if location=="Serbia and Montenegro"
replace ccode = 591 if location=="Seychelles"
replace ccode = 451 if location=="Sierra Leone"
replace ccode = 830 if location=="Singapore"
replace ccode = 317 if location=="Slovakia"
replace ccode = 317 if location=="Slovak Republic"
replace ccode = 349 if location=="Slovenia"
replace ccode = 520 if location=="Somalia"
replace ccode = 560 if location=="South Africa"
replace ccode = 560 if location=="Natal"
replace ccode = 732 if location=="South Korea"
replace ccode = 732 if location=="Korea, Rep."
replace ccode = 731 if location=="Korea, Dem. Rep."
replace ccode = 730 if location=="Korea"
replace ccode = 230 if location=="Spain"
replace ccode = 780 if location=="Sri Lanka"
replace ccode = 625 if location=="Sudan"
replace ccode = 572 if location=="Swaziland"
replace ccode = 380 if location=="Sweden"
replace ccode = 225 if location=="Switzerland"
replace ccode = 652 if location=="Syria"
replace ccode = 652 if location=="Syrian Arab Republic"
replace ccode = 713 if location=="Taiwan"
replace ccode = 702 if location=="Tajikistan"
replace ccode = 510 if location=="Tanzania/German East Africa"
replace ccode = 800 if location=="Thailand"
replace ccode = 461 if location=="Togo"
replace ccode = 364 if location=="Total Former USSR"
replace ccode = 364 if location=="USSR"
replace ccode = 52 if location=="Trinidad and Tobago"
replace ccode = 52 if location=="Trinidad & Tobago"
replace ccode = 616 if location=="Tunisia"
replace ccode = 640 if location=="Turkey"
replace ccode = 701 if location=="Turkmenistan"
replace ccode = 640 if location=="Ottoman Empire"
replace ccode = 500 if location=="Uganda"
replace ccode = 369 if location=="Ukraine"
replace ccode = 696 if location=="United Arab Emirates"
replace ccode = 200 if location=="United Kingdom"
replace ccode = 200 if location=="Northern Ireland"
replace ccode = 2 if location=="United States"
replace ccode = 165 if location=="Uruguay"
replace ccode = 704 if location=="Uzbekistan"
replace ccode = 101 if location=="Venezuela"
replace ccode = 101 if location=="Venezuela, RB"
replace ccode = 818 if location=="Vietnam"
replace ccode = 816 if location=="Vietnam North"
replace ccode = 817 if location=="Vietnam South"
replace ccode = 816 if location=="Vietnam, North"
replace ccode = 817 if location=="Vietnam, South"
replace ccode = 1005 if location=="West Bank and Gaza"
replace ccode = 679 if location=="Yemen"
replace ccode = 678 if location=="Yemen North"
replace ccode = 678 if location=="Yemen Arab Republic"
replace ccode = 678 if location=="Yemen, N.Arab"
replace ccode = 680 if location=="Yemen South"
replace ccode = 680 if location=="Yemen People's Republic"
replace ccode = 345 if location=="Yugoslavia"
replace ccode = 345 if location== "Yugoslavia - post 1991"
replace ccode = 345 if location== "Yugoslavia-pre 1991"
replace ccode = 490 if location=="Zaire/DRC"
replace ccode = 490 if location=="Congo, Dem. Rep. of"
replace ccode = 490 if location=="Democratic Republic of the Congo"
replace ccode = 490 if location=="Congo, Dem. Rep."
replace ccode = 551 if location=="Zambia"
replace ccode = 552 if location=="Zimbabwe"
replace ccode = 232 if location=="Andorra"
replace ccode = 58 if location=="Antigua"
replace ccode = 31 if location=="Bahamas"
replace ccode = 53 if location=="Barbados"
replace ccode = 80 if location=="Belize"
replace ccode = 760 if location=="Bhutan"
replace ccode = 835 if location=="Brunei"
replace ccode = 352 if location=="Cyprus"
replace ccode = 54 if location=="Dominica"
replace ccode = 860 if location=="East Timor"
replace ccode = 950 if location=="Fiji"
replace ccode = 265 if location=="Germany, East"
replace ccode = 265 if location=="East Germany"
replace ccode = 55 if location=="Grenada"
replace ccode = 41 if location=="Haiti"
replace ccode = 212 if location=="Luxembourg"
replace ccode = 781 if location=="Maldives"
replace ccode = 338 if location=="Malta"
replace ccode = 910 if location=="Papua New Guinea"
replace ccode = 910 if location=="West Papua"
replace ccode = 403 if location=="Sao Tome and Principe"
replace ccode = 940 if location=="Solomon Islands"
replace ccode = 60 if location=="St. Kitts and Nevis"
replace ccode = 56 if location=="St. Lucia"
replace ccode = 56 if location=="Saint Lucia"
replace ccode = 57 if location=="St. Vincent & Grens."
replace ccode = 57 if location=="St. Vincent and the Grenadines"
replace ccode = 57 if location=="St. Vincent & Grenadines"
replace ccode = 57 if location=="Saint Vincent and the Grenadines"
replace ccode = 115 if location=="Suriname"
replace ccode = 955 if location=="Tonga"
replace ccode = 115 if location=="Suriname"
replace ccode = 935 if location=="Vanuatu"
replace ccode = 990 if location=="Samoa"
replace ccode = 990 if location=="Samoa (Western)"
replace ccode = 58 if location=="Antigua and Barbuda"
replace ccode = 58 if location=="Antigua"
replace ccode = 32 if location=="Aruba"
replace ccode = 33 if location=="Bermuda"
replace ccode = 395 if location=="Iceland"
replace ccode = 946 if location=="Kiribati"
replace ccode = 212 if location=="Luxembourg"
replace ccode = 223 if location=="Liechtenstein"
replace ccode = 711 if location=="Macao"
replace ccode = 983 if location=="Marshall Islands"
replace ccode = 987 if location=="Micronesia"
replace ccode = 970 if location=="Nauru"
replace ccode = 986 if location=="Palau"
replace ccode = 1005 if location=="Palestinian Territory"
replace ccode = 1005 if location=="Palestinian Territories"
replace ccode = 1005 if location=="Palestine"
replace ccode = 331 if location=="San Marino"
replace ccode = 947 if location=="Tuvalu"
drop if ccode==.
*dropped Western Sahara, Tibet = China
gen long cyear = ccode*10000+ byear
*when two in same country/year, I keep the one with largest peak number
sort cyear
gen case=_n
tsset case
drop if cyear==921979&l.cyear==921979
drop if cyear==1011958&l.cyear==1011958
drop if cyear==4321989&l.cyear==4321989
drop if cyear==7101956&l.cyear==7101956 
drop if cyear==8181958&l.cyear==8181958  
rename byear byearchen 
rename eyear eyearchen
sort cyear
save "C:\Democracy\Final data\chenoweth\chenwork.dta" , replace

use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear
drop _merge
merge cyear using "C:\Democracy\Final data\chenoweth\chenwork.dta", sort
drop _merge
save "C:\Democracy\AJPS\democworki.dta", replace

xtset ccode year
bysort ccode:  carryforward eyearchen, replace carryalong(byearchen peakmember nonviol viol  secession target campaign regchange)
sort cyear
replace eyearchen=0 if year>eyearchen
replace byearchen=0 if eyearchen==.
replace peakmember=0 if eyearchen==0
replace nonviol=0 if eyearchen==0
replace viol=0 if eyearchen==0
replace secession=0 if eyearchen==0
replace target= "" if eyearchen==0
replace campaign="" if eyearchen==0
replace regchange=0 if eyearchen==0

replace eyearchen=. if year<1899|year>2006
replace byearchen=. if year<1899|year>2006
replace peakmember=. if year<1899|year>2006
replace nonviol=. if year<1899|year>2006
replace viol=. if year<1899|year>2006
replace secession=. if year<1899|year>2006
replace target= "" if year<1899|year>2006
replace campaign="" if year<1899|year>2006
replace regchange=. if year<1899|year>2006

gen chenviol = 0
replace chenviol=1 if viol==1
gen chennonviol = 0
replace chennonviol=1 if nonviol==1
replace chennonviol=. if year<1899|year>2006
replace chenviol=. if year<1899|year>2006

gen chenviolnosec = chenviol
replace chenviolnosec=0 if secession==1
gen chennonviolnosec = chennonviol
replace chennonviolnosec=0 if secession==1

xtset ccode year
gen lpol2norm = l.pol2norm
gen llngdppc = .
replace llngdppc = l.lngdppc if l.ccode==ccode
gen llngdpturn1 = l.leaderturn*llngdppc

xtset ccode year
gen lchennonlln  = l.chennonviolnosec*llngdppc
gen lchennonturn = l.chennonviolnosec*l.leaderturn
gen lchennonturnlln = lchennonturn*llngdppc 
gen lchenviollln  = l.chenviolnosec*llngdppc
gen lchenviolturn = l.chenviolnosec*l.leaderturn
gen lchenviolturnlln = lchenviolturn*llngdppc

drop llngdppc lpol2norm llngdpturn1
*need to not have these in the different year panels
save "C:\Democracy\AJPS\democworki.dta", replace

*Import COW data on military capabilities of states NMC_v4_0.csv"

insheet using "C:\Democracy\Final data\cow military capability data.txt", clear
save "C:\Democracy\revision dec 2011\militcap.dta", replace
replace ccode=255 if ccode==260
replace ccode=364 if ccode==365&year>1917&year<1992
drop if ccode==395
drop if ccode==781
replace ccode=818 if ccode==816&year>1975
drop if ccode==947
drop if ccode==946
drop if ccode==987|ccode==983
gen cyear = ccode*10000+year
drop if ccode==.
sort cyear
save "C:\Democracy\revision dec 2011\militcap.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear 
merge cyear using "C:\Democracy\revision dec 2011\militcap.dta"
drop if stateabb=="GFR"&year==1990
drop if ccode==525&year==1993
save "C:\Democracy\AJPS\democworki.dta", replace

*IMPORT COW DATA ON MIDS*
insheet using "C:\Democracy\Final data\COW MID data B version 3.1.txt", clear
save "C:\Democracy\revision dec 2011\mid.dta", replace

*DROP ALL NON-INITIATORS*

drop if sidea==0
rename sidea midsidea
replace ccode=255 if ccode==260
replace ccode=364 if ccode==365&styear>1917&styear<1992
drop if ccode==395
drop if ccode==781
replace ccode=818 if ccode==816&styear>1975
drop if ccode==947
drop if ccode==946
drop if ccode==987|ccode==983
gen cyear = ccode*10000+styear
drop if ccode==.
sort cyear

*There are sometimes multiple disputes in same year. Need to reduce to one observation per year. Will focus on the longest lasting*
bysort cyear: egen maxyear = max(endyear)
keep if endyear==maxyear

*still multiple cases per year: keep just the first*
bysort cyear: egen firststmon=min(stmon)
keep if firststmon==stmon
bysort cyear: egen minday = min(stday)
keep if stday==minday
sort cyear
gen case=_n
bysort cyear: egen mincase = min(case)
keep if case==mincase
drop case
save "C:\Democracy\revision dec 2011\mid.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear
sort cyear 
drop _merge
merge cyear using "C:\Democracy\revision dec 2011\mid.dta", 
drop if stateabb=="GFR"&year==1990
drop if ccode==525&year==1993
save "C:\Democracy\AJPS\democworki.dta", replace

gen mid = 0
replace mid=1 if year==styear
replace mid = . if year<1816|year>2001
replace mid = . if year<sss
drop case
sort cyear
gen case=_n
tsset case
drop if cyear==2551990&l.cyear==2551990
*Need to code as "." years in which a mid is continuing*
xtset ccode year
replace mid = . if mid==0&year==l.maxyear
replace mid = . if mid==0&year==l2.maxyear
replace mid = . if mid==0&year==l3.maxyear
replace mid = . if mid==0&year==l4.maxyear
replace mid = . if mid==0&year==l5.maxyear
replace mid = . if mid==0&year==l6.maxyear
replace mid = . if mid==0&year==l7.maxyear
replace mid = . if mid==0&year==l8.maxyear
replace mid = . if mid==0&year==l9.maxyear
replace mid = . if mid==0&year==l10.maxyear

sort ccode year
bysort ccode: gen pastmidyears = sum(mid)
bysort ccode: gen pastmidfreq = pastmidyears/(year-sss+1)
replace pastmidyears=. if year<sss|year>2001
replace pastmidfreq=. if year<sss|year>2001
save "C:\Democracy\AJPS\democworki.dta", replace

*creating the instrument for growth*
use "C:\Democracy\Russet Oneal data\trade.dta", clear
*Note: I use 1938 trade weights for 1939-1945 (no trade data) and 1913 trade weights for 1914-1919 (no trade data)*
*In this dataset, dyadid for states a and b = COWcodea*1000 + COWcodeb*
*To get COW code of a: *
gen ccodea = int((dyadid/1000))
gen ccodeb = dyadid - (ccodea*1000)
gen trade = exp(lntrade) - 0.1
gen ccodeayear = ccodea*10000+year
destring ccodeayear, replace
sort ccodeayear ccodeb
save "C:\Democracy\April 13 2011 Version\RussetOnealwork.dta", replace

*The data do not repeat dyad j:i when it already had dyad i:j. We need it to do this if we are to calculate trade shares for all country a's. *
gen reversedyid = ccodeb*1000 + ccodea
save "C:\Democracy\April 13 2011 Version\revid.dta", replace
drop dyadid
rename reversedyid dyadid
rename ccodea ccodea1
rename ccodeb ccodea
rename ccodea1 ccodeb
drop ccodeayear
gen ccodeayear = ccodea*10000+ year
save "C:\Democracy\April 13 2011 Version\revid.dta", replace

*now need to append*
use "C:\Democracy\April 13 2011 Version\RussetOnealwork.dta", clear
append using "C:\Democracy\April 13 2011 Version\revid.dta", 
save "C:\Democracy\April 13 2011 Version\RussetOnealwork.dta", replace

*to make ccodea (from COW) compatible with countrycode in the other data:*
*combine W Germany (260) with Germany (255)*
replace ccodea = 255 if ccodea==260
replace ccodeb = 255 if ccodeb==260
drop ccodeayear
gen ccodeayear = ccodea*10000+ year
save "C:\Democracy\April 13 2011 Version\RussetOnealwork.dta", replace

sort year ccodea ccodeb
gen ccodebyear = ccodeb*10000+ year
save "C:\Democracy\April 13 2011 Version\RussetOnealwork.dta", replace

*expand to include years after 1992*
sort year ccodea ccodeb
gen case = _n
tsset case
* replace case = 1361152 in 839873*
moreobs
replace case = 1361152 if _n==839873
tsfill
replace year = l32580.year + 1 if case>839872
replace ccodea = l32580.ccodea if case>839872
replace ccodeb= l32580.ccodeb if case>839872
drop ccodeayear ccodebyear
gen ccodeayear = ccodea*10000+ year
gen ccodebyear = ccodeb*10000+ year
save "C:\Democracy\April 13 2011 Version\RussetOnealwork.dta", replace

*Now need to calculate the trade weights; I use the previous year's trade weight.*
*First prepare the Maddison data on gdp*
insheet using "C:\Democracy\Final data\mad gdp.txt", clear
destring gdp1865, replace
reshape long gdp, i(country) j(year)
gen ccode = .
replace ccode = 700 if country=="Afghanistan"
replace ccode = 339 if country=="Albania"
replace ccode = 615 if country=="Algeria"
replace ccode = 540 if country=="Angola"
replace ccode = 160 if country=="Argentina"
replace ccode = 371 if country=="Armenia"
replace ccode = 900 if country=="Australia"
replace ccode = 300 if country=="Austria-Hungary"
replace ccode = 305 if country=="Austria"
replace ccode = 373 if country=="Azerbaijan"
replace ccode = 692 if country=="Bahrain"
replace ccode = 771 if country=="Bangladesh"
replace ccode = 370 if country=="Belarus"
replace ccode = 211 if country=="Belgium"
replace ccode = 434 if country=="Benin"
replace ccode = 145 if country=="Bolivia"
replace ccode = 346 if country=="Bosnia"
replace ccode = 571 if country=="Botswana"
replace ccode = 140 if country=="Brazil"
replace ccode = 355 if country=="Bulgaria"
replace ccode = 439 if country=="Burkina Faso"
replace ccode = 775 if country=="Burma"
replace ccode = 516 if country=="Burundi"
replace ccode = 811 if country=="Cambodia"
replace ccode = 471 if country=="Cameroon"
replace ccode = 20 if country=="Canada"
replace ccode = 402 if country=="Cape Verde"
replace ccode = 482 if country=="Central African Republic"
replace ccode = 483 if country=="Chad"
replace ccode = 155 if country=="Chile"
replace ccode = 710 if country=="China"
replace ccode = 100 if country=="Colombia"
replace ccode = 581 if country=="Comoro Islands"
replace ccode = 484 if country=="Congo 'Brazzaville'"
replace ccode = 94 if country=="Costa Rica"
replace ccode = 437 if country=="Côte d'Ivoire"
replace ccode = 437 if country=="Cote d'Ivoire"
replace ccode = 344 if country=="Croatia"
replace ccode = 40 if country=="Cuba"
replace ccode = 316 if country=="Czech Republic"
replace ccode = 315 if country=="Czechoslovakia"
replace ccode = 390 if country=="Denmark"
replace ccode = 522 if country=="Djibouti"
replace ccode = 42 if country=="Dominican Republic"
replace ccode = 130 if country=="Ecuador"
replace ccode = 651 if country=="Egypt"
replace ccode = 92 if country=="El Salvador"
replace ccode = 411 if country=="Equatorial Guinea"
replace ccode = 531 if country=="Eritrea"
replace ccode = 530 if country=="Ethiopia"
replace ccode = 366 if country=="Estonia"
replace ccode = 375 if country=="Finland"
replace ccode = 220 if country=="France"
replace ccode = 481 if country=="Gabon"
replace ccode = 420 if country=="Gambia"
replace ccode = 372 if country=="Georgia"
replace ccode = 255 if country=="Germany"
replace ccode = 452 if country=="Ghana"
replace ccode = 350 if country=="Greece"
replace ccode = 90 if country=="Guatemala"
replace ccode = 438 if country=="Guinea"
replace ccode = 404 if country=="Guinea Bissau"
replace ccode = 110 if country=="Guyana"
replace ccode = 41 if country=="Haïti"
replace ccode = 41 if country=="Haiti"
replace ccode = 91 if country=="Honduras"
replace ccode = 1001 if country=="Hong Kong"
replace ccode = 310 if country=="Hungary"
replace ccode = 750 if country=="India"
replace ccode = 850 if country=="Indonesia (including Timor until 1999)"
replace ccode = 630 if country=="Iran"
replace ccode = 645 if country=="Iraq"
replace ccode = 205 if country=="Ireland"
replace ccode = 666 if country=="Israel"
replace ccode = 325 if country=="Italy"
replace ccode = 51 if country=="Jamaica"
replace ccode = 740 if country=="Japan"
replace ccode = 663 if country=="Jordan"
replace ccode = 705 if country=="Kazakhstan"
replace ccode = 501 if country=="Kenya"
replace ccode = 347 if country=="Kosovo"
replace ccode = 690 if country=="Kuwait"
replace ccode = 703 if country=="Kyrgyzstan"
replace ccode = 812 if country=="Laos"
replace ccode = 367 if country=="Latvia"
replace ccode = 660 if country=="Lebanon"
replace ccode = 570 if country=="Lesotho"
replace ccode = 450 if country=="Liberia"
replace ccode = 620 if country=="Libya"
replace ccode = 368 if country=="Lithuania"
replace ccode = 343 if country=="Macedonia"
replace ccode = 580 if country=="Madagascar"
replace ccode = 553 if country=="Malawi"
replace ccode = 820 if country=="Malaysia"
replace ccode = 432 if country=="Mali"
replace ccode = 435 if country=="Mauritania"
replace ccode = 590 if country=="Mauritius"
replace ccode = 70 if country=="Mexico"
replace ccode = 359 if country=="Moldova"
replace ccode = 712 if country=="Mongolia"
replace ccode = 341 if country=="Montenegro"
replace ccode = 600 if country=="Morocco"
replace ccode = 541 if country=="Mozambique"
replace ccode = 565 if country=="Namibia"
replace ccode = 790 if country=="Nepal"
replace ccode = 210 if country=="Netherlands"
replace ccode = 920 if country=="New Zealand"
replace ccode = 93 if country=="Nicaragua"
replace ccode = 436 if country=="Niger"
replace ccode = 475 if country=="Nigeria"
replace ccode = 731 if country=="North Korea"
replace ccode = 385 if country=="Norway"
replace ccode = 698 if country=="Oman"
replace ccode = 770 if country=="Pakistan"
replace ccode = 95 if country=="Panama"
replace ccode = 150 if country=="Paraguay"
replace ccode = 135 if country=="Peru"
replace ccode = 840 if country=="Philippines"
replace ccode = 290 if country=="Poland"
replace ccode = 235 if country=="Portugal"
replace ccode = 1002 if country=="Puerto Rico"
replace ccode = 694 if country=="Qatar"
replace ccode = 360 if country=="Romania"
replace ccode = 365 if country=="Russian Federation"&year>1990
replace ccode = 517 if country=="Rwanda"
replace ccode = 403 if country=="São Tomé and Principe"
replace ccode = 403 if country=="Sao Tome and Principe"
replace ccode = 670 if country=="Saudi Arabia"
replace ccode = 433 if country=="Senegal"
replace ccode = 342 if country=="Serbia"
replace ccode = 348 if country=="Serbia and Montenegro"
replace ccode = 591 if country=="Seychelles"
replace ccode = 451 if country=="Sierra Leone"
replace ccode = 830 if country=="Singapore"
replace ccode = 317 if country=="Slovakia"
replace ccode = 349 if country=="Slovenia"
replace ccode = 520 if country=="Somalia"
replace ccode = 560 if country=="South Africa"
replace ccode = 732 if country=="South Korea"
replace ccode = 730 if country=="Korea"
replace ccode = 230 if country=="Spain"
replace ccode = 780 if country=="Sri Lanka"
replace ccode = 625 if country=="Sudan"
replace ccode = 572 if country=="Swaziland"
replace ccode = 380 if country=="Sweden"
replace ccode = 225 if country=="Switzerland"
replace ccode = 652 if country=="Syria"
replace ccode = 713 if country=="Taiwan"
replace ccode = 702 if country=="Tajikistan"
replace ccode = 510 if country=="Tanzania"
replace ccode = 800 if country=="Thailand"
replace ccode = 461 if country=="Togo"
replace ccode = 365 if country=="Total Former USSR"&year<1991
replace ccode = 52 if country=="Trinidad and Tobago"
replace ccode = 616 if country=="Tunisia"
replace ccode = 640 if country=="Turkey"
replace ccode = 701 if country=="Turkmenistan"
replace ccode = 500 if country=="Uganda"
replace ccode = 369 if country=="Ukraine"
replace ccode = 696 if country=="United Arab Emirates"
replace ccode = 200 if country=="United Kingdom"
replace ccode = 2 if country=="United States"
replace ccode = 165 if country=="Uruguay"
replace ccode = 704 if country=="Uzbekistan"
replace ccode = 101 if country=="Venezuela"
replace ccode = 818 if country=="Vietnam"
replace ccode = 816 if country=="Vietnam North"
replace ccode = 817 if country=="Vietnam South"
replace ccode = 1005 if country=="West Bank and Gaza"
replace ccode = 679 if country=="Yemen"
replace ccode = 678 if country=="Yemen North"
replace ccode = 680 if country=="Yemen South"
replace ccode = 345 if country=="Yugoslavia"
replace ccode = 490 if country=="Zaire (Congo Kinshasa)"
replace ccode = 551 if country=="Zambia"
replace ccode = 552 if country=="Zimbabwe"
drop if country=="Austria-Hungary"
drop if ccode==.
sort ccode
by ccode: ipolate gdp year, gen(gdpi)
drop gdp
rename gdpi gdp
gen cyear = ccode*10000+ year
rename country countrymad
save "C:\Democracy\April 13 2011 Version\Madgdplongi.dta", replace

gen ccodeayear = cyear
gen ccodea = ccode
gen gdpcountrya = gdp
keep countrymad year ccode cyear ccodea ccodeayear gdpcountrya
sort ccodeayear
save "C:\Democracy\April 13 2011 Version\Madcountrya", replace

use "C:\Democracy\April 13 2011 Version\Madgdplongi.dta", clear
gen ccodebyear = cyear
gen ccodeb = ccode
gen gdpcountryb = gdp
keep countrymad year ccode cyear ccodebyear ccodeb gdpcountryb
sort ccodebyear
save "C:\Democracy\April 13 2011 Version\Madcountryb", replace

use "C:\Democracy\April 13 2011 Version\RussetOnealwork.dta", clear
sort ccodeayear
merge ccodeayear using "C:\Democracy\April 13 2011 Version\Madcountrya", uniqusing
drop _merge
sort ccodebyear
merge ccodebyear using "C:\Democracy\April 13 2011 Version\Madcountryb", uniqusing
drop _merge

drop if ccodea==.
drop if ccodeb==.
save "C:\Democracy\April 13 2011 Version\RussetOnealwork.dta", replace

replace dyadid = ccodea*10000+ccodeb
replace trade = exp(lntrade) - 0.1
xtset dyadid year
gen omegabt = trade/gdpcountrya
gen lomegabt = l.omegabt
sort year ccodea ccodeb
replace case = _n
tsset case 
replace omegabt = l32580.omegabt if case>839872
replace lomegabt = l32580.lomegabt if case>839872
*this applies the omegas from 1992 to all subsequent years up to 2008, since trade data not available for those years*

*Now calculate the estimated Y:* 
xtset dyadid year
gen dgdpcountryb = gdpcountryb/l.gdpcountryb
gen dgdpcountrybpres = 0
replace dgdpcountrybpres = 1 if dgdpcountryb~=. 
by ccodeayear, sort: egen  a = sum(lomegabt*dgdpcountryb)
by ccodeayear, sort: egen  b = sum(lomegabt*dgdpcountrybpres)
gen growthinst = a/b
by ccodeayear, sort: egen  f = sum(dgdpcountryb)
by ccodeayear, sort: egen  g = sum(dgdpcountrybpres)
gen growthinstunwtd = f/g
save "C:\Democracy\April 13 2011 Version\RussetOnealwork.dta", replace

sort ccodeayear
collapse (median) growthinst growthinstunwtd, by(ccodeayear)
rename ccodeayear cyear
sort cyear
save "C:\Democracy\April 13 2011 Version\incinst.dta", replace

use "C:\Democracy\AJPS\democworki.dta", clear
drop _merge
sort cyear
merge cyear using "C:\Democracy\April 13 2011 Version\incinst.dta"
save "C:\Democracy\AJPS\democworki.dta", replace

*Make 5, 10, 15, 20-year datasets*
keep if year/5==int(year/5)
save "C:\Democracy\AJPS\merge5yeari.dta", replace
use "C:\Democracy\AJPS\democworki.dta", clear
keep if year/10==int(year/10)
save "C:\Democracy\AJPS\merge10yeari.dta", replace
use "C:\Democracy\AJPS\democworki.dta", clear
keep if (year-1820)/15==int((year-1820)/15)
save "C:\Democracy\AJPS\merge15yeari.dta", replace
*NOTE THAT FOR CONSISTENCY I START THE 15-YEAR PANEL ALSO IN 1820 AND THEN USE EVERY 15TH YEAR FROM THEN ON*
use "C:\Democracy\AJPS\democworki.dta", clear
keep if year/20==int(year/20)
save "C:\Democracy\AJPS\merge20yeari.dta", replace
