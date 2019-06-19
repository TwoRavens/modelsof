/*=========================================
Title:  ccregs.do
Author: Mitchell Hoffman
Purpose: Cross-country regressions for paper on Jewish rescue
=========================================*/

clear
set more off

global logpath = "C:\Users\Mitch"
cd "$logpath"
capture log close
log using CCRegs.log, append

************************************************************************************
********************* Read in data

global datapath = "C:\Users\Mitch\"
cd "$datapath"
insheet using ccregs.csv

label var rescuers "Number of rescuers"
label var killed "Jews killed"
label var pwjews "Prewar Jews"
label var pwtotpop "Prewar total population"
label var geography "Geographic region"
label var illit1930 "Illiteracy rate in 1930"
label var students1933 "Secondary school students in 1933"
label var god "% Believe in God, World Values Survey"
label var polity36 "Polity score for 1936"
label var antisemlaw "Passed an anti-Semitic law"
label var antisempop "Population described as anti-Semitic"
label var nolikjewneb "% Would not want Jewish neighbors, World Values Survey"
label var intermarraw "Raw prewar intermarriage rate"
label var intermaryrrg "Year range for raw intermarriage rate"
label var intermaryr "Midpoint of raw intermarriage rate year range"
label var gdp1937 "GDP per capita in 1937"
label var mntns "Percentage mountainous"
label var forest "Percentage covered by forest"
label var coal1937 "Coal production in 1937"
label var syb39denom "Statesman's Yearbook Denomination"
label var syb39c "Percent or Number of Catholics, Statesman's Yearbook"
label var syb39p "Percent or Number of Protestants, Statesman's Yearbook"
label var syb39o "Percent or Number of Orthodox, Statesman's Yearbook"
label var ciadenom "CIA Factbook Denomination"
label var ciac "Percent Catholic, CIA Factbook"
label var ciap "Percent Protestant, CIA Factbook"
label var ciao "Percent Orthodox, CIA Factbook"
label var xcoord "Longitude"
label var ycoord "Latitude"



* Will adjust pwtotpop below.  Also create pwtotpop within a country's prewar borders.
* Use this in defining prewar coal production and schooling.
gen pwtotpop_unadj = pwtotpop          

gen unadjustedmort = killed/1000
gen unadjustedjpop = pwjews/1000
gen unadjustedtpop = pwtotpop/1000

* Generate Soviet dummy for Ukraine, Belarus, and Russia.
gen prewarsoviet = (country=="Ukraine" | country=="Belarus" | country=="Russia")
label var prewarsoviet "Prewar Soviet country"
* Yugoslavia dummy for Serbia, Croatia, Bosnia, and Macedonia 
gen yugoslavia=(country=="Serbia" | country=="Croatia" | country=="Bosnia" |  country=="Macedonia")
label var yugoslavia "Part of Yugoslavia"
* Kingdom of Romania
gen kingromania = (country=="Romania" | country=="Moldova")
label var kingromania "Part of Kingdom of Romania"
* Czechoslovakia
gen czechoslovakia = (country=="Czech Republic" | country=="Slovakia")
label var czechoslovakia "Part of Czechoslovakia"

* Share of Jews from Bessarabia killed of those from Bessarabia & Bukovina
scalar bessarab_share_gilbert = 200000 / (200000 + 124632)

* Share of population from Czech Republic and from Slovakia. From Kirk (1946).
scalar share_cz = (7109 + 3565)/14730
scalar share_slov = 1-share_cz

scalar pwtotpop_dunavska =  2387000 
scalar pwtotpop_moravska =  1436000  
scalar pwtotpop_belgrad =   289000 
scalar pwtotpop_primorska = 902000 
scalar pwtotpop_savska =    2704000 
scalar pwtotpop_drinska =   1535000 
scalar pwtotpop_vrbaska =   1037000 
scalar pwtotpop_vardarska = 1574000 

scalar pwtotpop_serbia = pwtotpop_dunavska + pwtotpop_moravska  + pwtotpop_belgrad 
scalar pwtotpop_croatia = pwtotpop_primorska + pwtotpop_savska 
scalar pwtotpop_bosnia = pwtotpop_drinska + pwtotpop_vrbaska 
scalar pwtotpop_macedonia = pwtotpop_vardarska

scalar pwtotpop_russia = (147028 - 4984 - 29018 - 5862 - 2315 - 880 - 2666)*1000
scalar pwtotpop_czechoslovakia =   14730000
scalar pwtotpop_yugoslavia =       13934000 
scalar pwtotpop_kingdomofromania = 18057000 


************************************************************************************
********************* Adjusting Jewish prewar population and mortality, and total population
********************* in regions.

********************* Adjust for ethnic minorities in Central and Eastern Europe

scalar killed_bukovina = (1-bessarab_share_gilbert)*262500 
scalar killed_bessarabia = bessarab_share_gilbert*262500 
scalar killed_ntransylvania = 141000
scalar killed_ruthenia = 60000
scalar killed_sslovakia = 52000
scalar killed_backa = 14000

scalar pwjews_bukovina =      killed_bukovina 
scalar pwjews_bessarabia =    204858
scalar pwjews_ntransylvania = 150000
scalar pwjews_ruthenia =      82124
scalar pwjews_sslovakia =     67876
scalar pwjews_backa =         16000

scalar pwtotpop_bukovina =      853000
scalar pwtotpop_bessarabia =    2864000
scalar pwtotpop_ntransylvania = 2395146 
scalar pwtotpop_ruthenia =      725357
scalar pwtotpop_sslovakia =     895000
scalar pwtotpop_backa =         784896

**** Poland
total killed pwjews
scalar pol_mrate = 2.95/3.3

* Adjust killed
scalar s_bialystok_bel = 16.3/(66.7+16.3)
replace killed = killed - s_bialystok_bel*1263300*.123*pol_mrate if country=="Poland" 
replace killed = killed + s_bialystok_bel*1263300*.123*pol_mrate if country=="Belarus" 

scalar s_lwow_ukr= 34.1/(54.2+34.1)
replace killed = killed - s_lwow_ukr*3126300*.11*pol_mrate if country=="Poland" 
replace killed = killed + s_lwow_ukr*3126300*.11*pol_mrate if country=="Ukraine" 

scalar s_nowogrodek_bel = 39.1/(51.9+39.1)
replace killed = killed - s_nowogrodek_bel*1057200*.078*pol_mrate if country=="Poland" 
replace killed = killed + s_nowogrodek_bel*1057200*.078*pol_mrate if country=="Belarus"

scalar s_polesie_bel = 6.6/(14.4+6.6)
replace killed = killed - s_polesie_bel*1132200*.101*pol_mrate if country=="Poland" 
replace killed = killed + s_polesie_bel*1132200*.101*pol_mrate if country=="Belarus"

scalar s_stanislawow_ukr = 68.9/(20.3+68.9)
replace killed = killed - s_stanislawow_ukr*1480300*.095*pol_mrate if country=="Poland" 
replace killed = killed + s_stanislawow_ukr*1480300*.095*pol_mrate if country=="Ukraine"

scalar s_tranopol_ukr = 45.5/(49.3+45.5)
replace killed = killed - s_tranopol_ukr*1600400*.084*pol_mrate if country=="Poland" 
replace killed = killed + s_tranopol_ukr*1600400*.084*pol_mrate if country=="Ukraine"

scalar s_wilno_bel = 22.7/(59.5+22.7)
replace killed = killed - s_wilno_bel*1276000*.087*pol_mrate if country=="Poland" 
replace killed = killed + s_wilno_bel*1276000*.087*pol_mrate if country=="Belarus"

scalar s_wolyn_ukr = 68.4/(16.5+68.4)
replace killed = killed - s_wolyn_ukr*2085600*.10*pol_mrate if country=="Poland" 
replace killed = killed + s_wolyn_ukr*2085600*.10*pol_mrate if country=="Ukraine"

* Adjust pwjews
replace pwjews = pwjews - s_bialystok_bel*1263300*.123 if country=="Poland" 
replace pwjews = pwjews + s_bialystok_bel*1263300*.123 if country=="Belarus" 

replace pwjews = pwjews - s_lwow_ukr*3126300*.11 if country=="Poland" 
replace pwjews = pwjews + s_lwow_ukr*3126300*.11 if country=="Ukraine" 

replace pwjews = pwjews - s_nowogrodek_bel*1057200*.078 if country=="Poland" 
replace pwjews = pwjews + s_nowogrodek_bel*1057200*.078 if country=="Belarus"

replace pwjews = pwjews - s_polesie_bel*1132200*.101 if country=="Poland" 
replace pwjews = pwjews + s_polesie_bel*1132200*.101 if country=="Belarus"

replace pwjews = pwjews - s_stanislawow_ukr*1480300*.095 if country=="Poland" 
replace pwjews = pwjews + s_stanislawow_ukr*1480300*.095 if country=="Ukraine"

replace pwjews = pwjews - s_tranopol_ukr*1600400*.084 if country=="Poland" 
replace pwjews = pwjews + s_tranopol_ukr*1600400*.084 if country=="Ukraine"

replace pwjews = pwjews - s_wilno_bel*1276000*.087 if country=="Poland" 
replace pwjews = pwjews + s_wilno_bel*1276000*.087 if country=="Belarus"

replace pwjews = pwjews - s_wolyn_ukr*2085600*.10 if country=="Poland" 
replace pwjews = pwjews + s_wolyn_ukr*2085600*.10 if country=="Ukraine"

* Adjust pwtotpop
replace pwtotpop = pwtotpop - s_bialystok_bel*1263300 if country=="Poland" 
replace pwtotpop = pwtotpop + s_bialystok_bel*1263300 if country=="Belarus" 

replace pwtotpop = pwtotpop - s_lwow_ukr*3126300 if country=="Poland" 
replace pwtotpop = pwtotpop + s_lwow_ukr*3126300 if country=="Ukraine" 

replace pwtotpop = pwtotpop - s_nowogrodek_bel*1057200 if country=="Poland" 
replace pwtotpop = pwtotpop + s_nowogrodek_bel*1057200 if country=="Belarus"

replace pwtotpop = pwtotpop - s_polesie_bel*1132200 if country=="Poland" 
replace pwtotpop = pwtotpop + s_polesie_bel*1132200 if country=="Belarus"

replace pwtotpop = pwtotpop - s_stanislawow_ukr*1480300 if country=="Poland" 
replace pwtotpop = pwtotpop + s_stanislawow_ukr*1480300 if country=="Ukraine"

replace pwtotpop = pwtotpop - s_tranopol_ukr*1600400 if country=="Poland" 
replace pwtotpop = pwtotpop + s_tranopol_ukr*1600400 if country=="Ukraine"

replace pwtotpop = pwtotpop - s_wilno_bel*1276000 if country=="Poland" 
replace pwtotpop = pwtotpop + s_wilno_bel*1276000 if country=="Belarus"

replace pwtotpop = pwtotpop - s_wolyn_ukr*2085600 if country=="Poland" 
replace pwtotpop = pwtotpop + s_wolyn_ukr*2085600 if country=="Ukraine"

**** Territories from Romania

* Adjust killed
scalar s_bukovina_ukr = 29.2/(29.2+44.5)
replace killed = killed - s_bukovina_ukr*killed_bukovina if country=="Romania" 
replace killed = killed + s_bukovina_ukr*killed_bukovina if country=="Ukraine"

scalar s_bessarabia_ukr = 11/(11+56.2)
replace killed = killed - s_bessarabia_ukr*killed_bessarabia if country=="Moldova" 
replace killed = killed + s_bessarabia_ukr*killed_bessarabia if country=="Ukraine"

scalar s_ntransylvania_hun = 38.06/(38.06+49.12)
replace killed = killed - s_ntransylvania_hun*killed_ntransylvania if country=="Romania" 
replace killed = killed + s_ntransylvania_hun*killed_ntransylvania if country=="Hungary"

* Adjust pwjews
replace pwjews = pwjews - s_bukovina_ukr*pwjews_bukovina if country=="Romania" 
replace pwjews = pwjews + s_bukovina_ukr*pwjews_bukovina if country=="Ukraine"

replace pwjews = pwjews - s_bessarabia_ukr*pwjews_bessarabia if country=="Moldova" 
replace pwjews = pwjews + s_bessarabia_ukr*pwjews_bessarabia if country=="Ukraine"

replace pwjews = pwjews - s_ntransylvania_hun*pwjews_ntransylvania if country=="Romania" 
replace pwjews = pwjews + s_ntransylvania_hun*pwjews_ntransylvania if country=="Hungary"

* Adjust pwtotpop
replace pwtotpop = pwtotpop - s_bukovina_ukr*pwtotpop_bukovina if country=="Romania" 
replace pwtotpop = pwtotpop + s_bukovina_ukr*pwtotpop_bukovina if country=="Ukraine"

replace pwtotpop = pwtotpop - s_bessarabia_ukr*pwtotpop_bessarabia if country=="Moldova" 
replace pwtotpop = pwtotpop + s_bessarabia_ukr*pwtotpop_bessarabia if country=="Ukraine"

replace pwtotpop = pwtotpop - s_ntransylvania_hun*pwtotpop_ntransylvania if country=="Romania" 
replace pwtotpop = pwtotpop + s_ntransylvania_hun*pwtotpop_ntransylvania if country=="Hungary"

**** Territories from Czechoslovakia

*** Adjust killed
* Carpatho-Ruthenia, though controlled by Czechoslovakia, was almost
* entirely Ukrainian and Hungarian populated.
scalar s_ruthenia_ukr = 62.17/(15.96+62.17)
scalar s_ruthenia_hun = 15.96/(15.96+62.17)
replace killed = killed + s_ruthenia_ukr*killed_ruthenia if country=="Ukraine"
replace killed = killed + s_ruthenia_hun*killed_ruthenia if country=="Hungary"
replace killed = killed - killed_ruthenia if country=="Slovakia"

* Southern Slovakia
scalar s_sslovakia_hun = 17.79/(17.79+71.27)
replace killed = killed - s_sslovakia_hun*killed_sslovakia if country=="Slovakia" 
replace killed = killed + s_sslovakia_hun*killed_sslovakia if country=="Hungary"

*** Adjust pwjews
* Ruthenia
replace pwjews = pwjews + s_ruthenia_ukr*pwjews_ruthenia if country=="Ukraine"
replace pwjews = pwjews + s_ruthenia_hun*pwjews_ruthenia if country=="Hungary"
replace pwjews = pwjews - pwjews_ruthenia if country=="Slovakia"

* Southern Slovakia
replace pwjews = pwjews - s_sslovakia_hun*pwjews_sslovakia if country=="Slovakia" 
replace pwjews = pwjews + s_sslovakia_hun*pwjews_sslovakia if country=="Hungary"

*** Adjust pwtotpop
* Ruthenia
replace pwtotpop = pwtotpop + s_ruthenia_ukr*pwtotpop_ruthenia if country=="Ukraine"
replace pwtotpop = pwtotpop + s_ruthenia_hun*pwtotpop_ruthenia if country=="Hungary"
replace pwtotpop = pwtotpop - pwtotpop_ruthenia if country=="Slovakia"

* Southern Slovakia
replace pwtotpop = pwtotpop - s_sslovakia_hun*pwtotpop_sslovakia if country=="Slovakia" 
replace pwtotpop = pwtotpop + s_sslovakia_hun*pwtotpop_sslovakia if country=="Hungary"

**** Territory from Yugoslavia
scalar s_backa_hun = 34.24/(24.05 + 34.24)

replace killed = killed - s_backa_hun*killed_backa if country=="Serbia" 
replace killed = killed + s_backa_hun*killed_backa if country=="Hungary"

replace pwjews = pwjews - s_backa_hun*pwjews_backa if country=="Serbia" 
replace pwjews = pwjews + s_backa_hun*pwjews_backa if country=="Hungary"

replace pwtotpop = pwtotpop - s_backa_hun*pwtotpop_backa if country=="Serbia" 
replace pwtotpop = pwtotpop + s_backa_hun*pwtotpop_backa if country=="Hungary"


********************* 
* Create # of survivors and percent survivors
gen survivors = pwjews - killed
summ survivors
gen survper = survivors / pwjews

total killed pwjews
gen adjustedmort = killed/1000
gen adjustedjpop = pwjews/1000
gen adjustedtpop = pwtotpop/1000

************************************************************************************
********************* Define Gentiles and Measures of Rescue

gen gentiles = pwtotpop - pwjews
gen killedXgentiles = killed*gentiles
* Get percentage of prewar population that was Jewish
gen percjew = pwjews / pwtotpop

* Gen measure of rescue, given available rescuing population and need
gen propresc = rescuers / (gentiles * killed)

gen rescperkilled = rescuers / killed
gen rescperjews = rescuers / pwjews
gen rescpergent = rescuers / gentiles
gen killedpergent = killed / gentiles

************************************************************************************
********************* Geography, country classification

* From American Holocaust Museum map

gen east = (geography=="Eastern") 
gen central = (geography=="Central") 
gen south = (geography=="Southern") 
gen northwest = (geography=="Northwest") 

label var east "Eastern"
label var central "Central"
label var south "Southern"
label var northwest "Northwest"

************************************************************************************
********************* Education data

* Illiteracy rate in 1930, from Kirk 'Europe's Population in the Interwar Years'

replace illit1930 = (pwtotpop_dunavska / pwtotpop_serbia)*29 + (pwtotpop_moravska / pwtotpop_serbia)*62 +(pwtotpop_belgrad / pwtotpop_serbia)*11 if country=="Serbia"
replace illit1930 = (pwtotpop_primorska / pwtotpop_croatia)*58 + (pwtotpop_savska / pwtotpop_croatia)*28 if country=="Croatia"
replace illit1930 = (pwtotpop_drinska / pwtotpop_bosnia)*62 + (pwtotpop_vrbaska / pwtotpop_bosnia)*73 if country=="Bosnia"
replace illit1930 = 71 if country=="Macedonia"

gen share_bessarabia = pwtotpop_bessarabia / pwtotpop_kingdomofromania 
replace illit1930 = (43 - share_bessarabia*62)/(1-share_bessarabia) if country=="Romania"
replace illit1930 = (3330/(3330+725))*8 + (725/(3330+725))*31 if country=="Slovakia" 
gen share_russia = pwtotpop_russia / 147028000
replace illit1930 = (50 - (47*4984/147028)-(42*29018/147028)-(63*5862/147028)-(75*2315/147028)-(65*880/147028)-(52*2666/147028)) / share_russia if country=="Russia"

gen literacy = 100 - illit1930
label var literacy "% Literacy"

* University students per capita from Mitchell (1975).

* Proportionalize students1937 for Czech Republic and Slovakia
replace students1933 = students1933 * share_slov if country=="Slovakia"
replace students1933 = students1933 * share_cz if country=="Czech Republic"

gen students = 1000* students1933 / pwtotpop_unadj if yugoslavia==0 & kingromania==0
replace students = 16132 / pwtotpop_yugoslavia if yugoslavia==1
replace students = 40903 / pwtotpop_kingdomofromania if kingromania==1

************************************************************************************
********************* Religiosity data

* god = Percenntage of people that believe in God from all years of European Values Study

************************************************************************************
********************* GDP data

* GDP per capita, measured in 1937
gen basegdp = gdp1937
* Impute Luxembourg GDP based on comparison in 1950
* GDP per hour ratio of Luxembourg and Switzerland, than multiply by 1937 Swiss GDP
replace basegdp= 7046 if country=="Luxembourg"

* For GDP var in practice, have it reflect variation in income
* in USSR (including Baltic countries, which joined USSR
* after World War II).  I create income ratios using the
* 1973 GDP per capita data for the Soviet countries and the
* 1990 GDP per capita data for Czech Rep. and Slovakia.

gen gdp = basegdp
* Compare each country's 1973 GDP to mean 1973 USSR GDP
gen rat_lit = 7593 / 6059
gen rat_lat = 7846 / 6059
gen rat_est = 8657 / 6059
gen rat_bel = 5233 / 6059
gen rat_ukr = 4924 / 6059
gen rat_rus = 6582 / 6059

* Compare each country's 1990 GDP to mean 1990 Czechoslovakia GDP
gen rat_cz = 8895 / 8513
gen rat_sl = 7763 / 8513

* Compare each country's 1990 GDP to mean 1990 Yugoslavia GDP
gen rat_serb = 5160 / 5720
gen rat_crot = 7351 / 5720
gen rat_bosn = 3737 / 5720
gen rat_macd = 3972 / 5720
gen rat_slov = 10860 / 5720

* Compare each country's 
replace gdp = basegdp * rat_lit if country=="Lithuania"
replace gdp = basegdp * rat_lat if country=="Latvia"
replace gdp = basegdp * rat_est if country=="Estonia"
replace gdp = basegdp * rat_bel if country=="Belarus"
replace gdp = basegdp * rat_ukr if country=="Ukraine"
replace gdp = basegdp * rat_rus if country=="Russia"

replace gdp = basegdp * rat_cz if country=="Czech Rebpulic"
replace gdp = basegdp * rat_sl if country=="Slovakia"

replace gdp = basegdp * rat_serb if country=="Serbia"
replace gdp = basegdp * rat_crot if country=="Croatia"
replace gdp = basegdp * rat_bosn if country=="Bosnia"
replace gdp = basegdp * rat_macd if country=="Macedonia"
replace gdp = basegdp * rat_slov if country=="Slovenia"

gen lgdp=log(gdp)
label var lgdp "Log (GDP per capita)"

************************************************************************************
********************* Anti-semitism data

* variable is antisemlaw.  From Dawidowicz, Appendix.
* Whether country had passed its own anti-Semitic laws in decade prior to 
* the outbreak of World War II, September, 1939.  The country had to pass its own
* anti-Semitic laws, not while occupied by Germany.
 
* Antisempop measures whether there was significant, some, or substantial anti-Semitism 
* in different countries as described by Dawidowicz in her Appendix.

* nolikjewneb is the share in all years of European Values Study that does 
* not want Jews for neighbors. 


************************************************************************************
********************* Intermarriage data

* We have a few countries with intermarriage data for around 1900, but
* this seems too early for measuring pre-World War II intermarriage.

gen intermar = intermarraw
gen yearintermar = intermaryr
replace intermar = . if intermaryr <1920
label var intermar "Intermarriage rate"

*********************************************************************************************************
********************* Geography data
* It seems unlikely that forests or mountains affected cross-country rescue
* but mountains is significant in a regression of survival on mountains
* and geographic dummies

* forest is percent forest cover from "State of the World's Forests"
* from Food and Agriculture Organization Organization (FAO) of the United Nations (1995)
* Annex 2: European forests and forestry, http://www.fao.org/docrep/003/X6953E/X6953E00.HTM

* mntns is percent country mountainous and is from Fearon and Laitin (2003),
* "Ethnicity, Insurgency, and Civil War" and downloaded apsr03repdata.zip from Fearon's website. 

* Divide coal production among Soviet states by population
* 170,467,000 is Russian population in 1939 from B. Mitchell, p.23
* Assign same coal production to Slovakia and to Czech Republic.
* replace coal1937 = (pwtotpop_unadj / 170467000) * 127968 if prewarsoviet==1 
replace coal1937 = (pwtotpop_unadj / 147028000) * 127968 if prewarsoviet==1 
replace coal1937 = share_slov* 34673 if country =="Slovakia"
replace coal1937 = share_cz * 34673 if country =="Czech Republic"
gen coal = coal1937 / pwtotpop_unadj if yugoslav==0 & kingromania==0
replace coal = 5002/pwtotpop_yugoslavia  if yugoslav==1
replace coal = 2183/pwtotpop_kingdomofromania  if kingromania==1

* replace coal = 5002/13934038 if yugoslav==1
* replace coal = 2183/19535398 if kingromania==1
* replace coal = .0001117 if country=="Moldova"


* Create measure of distance from German to every country
* Germany's coordinates are 10.388231	51.169894
* xcoord is longitude, ycoord is latitude
* Distance given in thousands of miles.

scalar d2rad = 2*_pi/ 360
gen dist = (1/1000)*(1/d2rad)*acos( sin(ycoord*d2rad)*sin(51.169894*d2rad) + cos(ycoord*d2rad)*cos(51.169894*d2rad)*cos((xcoord-10.388231)*d2rad) )*69.16  
label var dist "Distance from Germany"

* Create a dummy variable for part of the Axis
gen axis = (country=="Germany" | country=="Austria" | country=="Romania" | country=="Moldova" | country=="Hungary" | country=="Italy" | country=="Bulgaria")
label var axis "Axis country"

* Create a dummy variable for being a Communist country after the war
gen comm = (east==1 | czechoslovakia==1 | country=="Hungary" | kingromania==1 | country=="Bulgaria" | yugoslav==1)
label var comm "Communist country after the war"

*********************************************************************************************************
********************* Religious Denomination  data
* Use Statesman's Yearbook (1939), and fill in missing data with CIA Factbook

gen catholic=1 if syb39denom=="Catholic"
replace catholic=0 if (syb39denom=="Protestant" | syb39denom=="Orthodox" | syb39denom=="Muslim")
replace catholic =1 if catholic==. & ciadenom=="Catholic"
replace catholic=0 if catholic==. & (ciadenom=="Protestant"  | ciadenom=="Orthodox"  | ciadenom=="Muslim")
label var catholic "Catholic country"

gen orthodox=1 if syb39denom=="Orthodox"
replace orthodox=0 if (syb39denom=="Protestant" | syb39denom=="Catholic" | syb39denom=="Muslim")
replace orthodox =1 if orthodox==. & ciadenom=="Orthodox"
replace orthodox=0 if orthodox==. & (ciadenom=="Protestant"  | ciadenom=="Catholic"  | ciadenom=="Muslim")
label var orthodox "Orthodox country"

gen rdenom = "Protestant"
replace rdenom = "Catholic" if catholic==1
replace rdenom = "Orthodox" if orthodox==1 
replace rdenom = "Muslim" if country=="Bosnia"

*********************************************************************************************************

* Effective rescue by geography
gen region = geography

* Standardize rescue measures.  Make per 1,000,000 Gentiles, per 1,000 Jews killed.
 
gen rpk = 1000 * rescperkilled
gen rpj = 1000 * rescperjews
gen rpkg = 1000000000 * propresc
gen rpg = 1000000 * rescpergent

gen lrpk = log(rescuers / killed)
gen lrpj = log(rescuers / pwjews)
gen lrpkg = log(rescuers / (killed*gentiles))
gen lrpg = log(rescuers / gentiles)

label var lrpk "Log(Resucers per Jew Killed)"
label var lrpj "Log(Resucers per prewar Jew)"
label var lrpkg "Log(Resucers per Jew killed per prewar Gentile)"
label var lrpg "Log(Resucers per prewar Gentile)"

gen lr = log(rescuers)
gen lk = log(killed)

*********************************************** Table 1, Rank countries by rescue measures

******** List countries by Rescue variables  
gsort - rpk
format rpk rpj rpkg rpg  %12.2f
* log:  C:\Users\Mitch\Documents\Old_Docs\Economics General\Research\In progress\P and E\Holocaust and Social Preferences\Data\Analysis\Analyzing Yad Vashem Data\Logs\7-11-08.log
capture log close
log using Table1.log, replace
list country rescuers rpk rpj rpkg rpg region
log close

********  Analyze rescue variables by region
log using Table1Bottom.log, replace
format rpk rpj rpkg rpg  %12.2f
tabstat rpk [aw=killed], by(region) f(%6.2f)
tabstat rpj [aw=pwjews], by(region) f(%6.2f)
tabstat rpkg [aw=killedXgentiles],  by(region) f(%6.2f)
tabstat rpg [aw=gentiles], by(region) f(%6.2f)
total rescuers 
sum rpk [aw=killed] 
sum rpj [aw=pwjews]
sum rpkg [aw=killedXgentiles]
sum rpg [aw=gentiles]
* tabstat rescuers rpk rpj rpkg rpg [aw=killed], by(region) f(%6.2f)
log close

*********************************************** Table 2, Explanatory Variables Summary Statistics
 

* Variables: Income (GDP), Literacy, Religiosity (god), Religious Denom (catholic, orthodox),
* Anti-Semitism (anti-Semitic law, Don't Like Jewish Neighbors), Axis, Geographic Dummies  
log using Table2.log, replace
format gdp literacy god catholic orthodox antisemlaw nolikjewneb axis  northwest east central south  %12.2f
sum gdp literacy god catholic orthodox antisemlaw nolikjewneb axis  northwest east central south, format
log close

*********************************************** Table 3: WLS and Weighted 2SLS Regression results
cd "$logpath"
log using CCRegs.log, append
move antisemlaw orthodox
move antisempop antisemlaw
move northwest antisempop
move east northwest
move central east

cd "$datapath"

reg lrpk lgdp [aw=killed]
outreg using Table3_CCREgs, se 3aster bdec(3) rdec(2) replace
reg lrpk lgdp literacy [aw=killed]
outreg using Table3_CCREgs, se 3aster bdec(3) rdec(2) append
reg lrpk lgdp god [aw=killed]
outreg using Table3_CCREgs, se 3aster bdec(3) rdec(2) append
reg lrpk lgdp cath orthodox [aw=killed]
outreg using Table3_CCREgs, se 3aster bdec(3) rdec(2) append
reg lrpk lgdp antisemlaw [aw=killed]
outreg using Table3_CCREgs, se 3aster bdec(3) rdec(2) append
reg lrpk lgdp nolikjewneb [aw=killed]
outreg using Table3_CCREgs, se 3aster bdec(3) rdec(2) append
reg lrpk lgdp axis [aw=killed]
outreg using Table3_CCREgs, se 3aster bdec(3) rdec(2) append
reg lrpk lgdp northwest east central [aw=killed]
outreg using Table3_CCREgs, se 3aster bdec(3) rdec(2) append
ivreg lrpk (lgdp=coal)[aw=killed], first  
outreg using Table3_CCREgs, se 3aster bdec(3) rdec(2) append
ivreg lrpk (lgdp=coal)northwest east central [aw=killed], first 
outreg using Table3_CCREgs, se 3aster bdec(3) rdec(2) append


*********************************************** Table 6, Estimate social preferences

gen sigma1 =.1
gen sigma2 =.2
gen p = .5
gen p_lo = .4
gen p_hi = .6

gen hipc=.
replace hipc=1 if country=="Italy" | country=="Norway" | country=="Netherlands" | country=="Belgium" | country=="France"
replace hipc=0 if hipc==.

gen mu1 = 1-p - (sigma1*invnormal(1-rescperkilled))
gen mu2 = 1-p - (sigma2*invnormal(1-rescperkilled))
gen mu3=.
replace mu3 = 1-p_hi - (sigma1*invnormal(1-rescperkilled)) if hipc==1
replace mu3 = 1-p_lo - (sigma1*invnormal(1-rescperkilled)) if hipc==0

gen mu4=.
replace mu4 = 1-p_hi - (sigma2*invnormal(1-rescperkilled)) if hipc==1
replace mu4 = 1-p_lo - (sigma2*invnormal(1-rescperkilled)) if hipc==0

gsort - mu1
capture log close  
log using Table6.log, replace
format mu1 mu2 mu3 mu4  %12.2f
list country rescuers mu1 mu2 mu3 mu4 region
log close

*********************************************** Figure 1, GDP and Rescue, WLS Regression

reg lrpk lgdp [aw=killed] 
gen alpha=_b[_cons]
gen beta = _b[lgdp]
gen zz = alpha + beta*lgdp

scatter lrpk lgdp, ylabel(-8(2)-2) yscale(range(-9 -2))  legend(off) xtitle(Log GDP per Capita) ytitle(Log Rescuers per Jew Killed) title("Figure 1: GDP and Rescue, WLS Regression") mlabel(country)  || line zz lgdp



