use "$repos/data/cow/dyadic_trade_3.0.dta", clear

drop if year < 1980 //| year > 2004
drop bel_lux_alt_flow* china_alt_flow*
drop source*

rename importer1 country

drop if country == "Germany" & year == 1990
drop if importer2 == "Germany" & year == 1990
replace country   = "Germany" if country   == "German Federal Republic"
replace importer2 = "Germany" if importer2 == "German Federal Republic"

local countries Austria Belgium Denmark Finland France Germany Greece Ireland Italy Netherlands Portugal Spain Sweden "United Kingdom"
gen euctry1 = .
gen euctry2 = .
foreach ctry in `countries' {
  replace euctry1 = 1 if country == "`ctry'"
  replace euctry2 = 1 if importer2 == "`ctry'"
}
drop if euctry1 != 1 | euctry2 != 1
drop euctry* version

sort country year importer2

expand 2

sort country year importer2
gen obcopy = 0
by country year importer2: replace obcopy = 1 if _n == 2

gen tmpctry = country
replace country = importer2 if obcopy == 1
replace importer2 = tmpctry if obcopy == 1
drop tmpctry obcopy

sort country year importer2

merge m:1 country year using "$repos/data/worldbank/worlddevelopmentindicators/WDI2009_small.dta", keepusing(NY_GDP_MKTP_CD SP_POP_TOTL) nogen
drop if ccode1 == .
replace flow1 = . if flow1 == -9
replace flow2 = . if flow2 == -9

rename SP_POP_TOTL pop1

gen dyadopen = ((flow1 + flow2)*10^6) / NY_GDP_MKTP_CD

rename country country1
rename importer2 country
merge m:1 country year using "$repos/data/worldbank/worlddevelopmentindicators/WDI2009_small.dta", keepusing(NY_GDP_MKTP_CD SP_POP_TOTL) nogen
drop if ccode1 == .
rename SP_POP_TOTL pop2

replace country  = "UK" if country  == "United Kingdom"
replace country1 = "UK" if country1 == "United Kingdom"

replace pop1 = pop1/(10^6)
replace pop2 = pop2/(10^6)

sort country year country1
merge m:1 country year using "$repos/data/privatizationbarometer/country_aggregates.dta", keepusing(priv_rev) nogen keep(match)

merge m:1 year using "$repos/data/bea/gdpdeflator.dta", nogen
rename gdpdeflator dollardeflator
// Proportion not percentage!
replace dollardeflator = dollardeflator/100

rename country foreign
rename country1 country
sort country year foreign

gen pc_priv_rev2 = priv_rev/(pop2)
gen pcd_priv_rev2 = pc_priv_rev2*dollardeflator

gen spatial_pop   = pcd_priv_rev2*pop2/1000
gen spatial_trade = pcd_priv_rev2*dyadopen

collapse (sum) spatial_pop spatial_trade, by(country year)

merge 1:1 country year using "$repos/data/privatizationbarometer/country_aggregates.dta", keepusing(priv_rev) nogen keep(match)


replace country  = "United Kingdom" if country  == "UK"

merge m:1 country year using "$repos/data/worldbank/worlddevelopmentindicators/WDI2009_small.dta", keepusing(SP_POP_TOTL) nogen keep(match)
rename SP_POP_TOTL pop1
replace pop1 = pop1/(10^6)

replace country  = "UK" if country  == "United Kingdom"

merge m:1 year using "$repos/data/bea/gdpdeflator.dta", nogen
rename gdpdeflator dollardeflator
// Proportion not percentage!
replace dollardeflator = dollardeflator/100

// Define some dependent variables
gen pc_priv_rev = (priv_rev)/(pop1)
gen pcd_priv_rev = pc_priv_rev/dollardeflator

encode country, gen(ctry)
sort ctry year
tsset ctry year

by ctry: gen pc_cum_rev = 0
by ctry: replace pc_cum_rev = pc_cum_rev[_n-1] + pc_priv_rev if pc_cum_rev[_n-1] != .

by ctry: gen pcd_cum_rev = 0
by ctry: replace pcd_cum_rev = pcd_cum_rev[_n-1] + pcd_priv_rev if pcd_cum_rev[_n-1] != .

// Fix up Germany
replace country = "Germany" if country == "German Federal Republic"
merge country year using "$repos/data/armingeon/CPDSISPSS1960-2010UPDATE_ger.dta", sort
drop _merge

drop if year < 1979

rename gov_left govleft

sort ctry year

by ctry: gen pcd_cum_rev_left = 0
by ctry: replace pcd_cum_rev_left = pcd_cum_rev_left[_n-1] + pcd_priv_rev*govleft/100 if pcd_cum_rev_left[_n-1] != .


// Setup the merge variable for the Armingeon data
gen int ctrycode = .
replace ctrycode = 40  if country == "Austria"
replace ctrycode = 56  if country == "Belgium"
replace ctrycode = 208 if country == "Denmark"
replace ctrycode = 246 if country == "Finland"
replace ctrycode = 250 if country == "France"
replace ctrycode = 276 if country == "Germany"
replace ctrycode = 300 if country == "Greece"
replace ctrycode = 372 if country == "Ireland"
replace ctrycode = 380 if country == "Italy"
replace ctrycode = 528 if country == "Netherlands"
replace ctrycode = 620 if country == "Portugal"
replace ctrycode = 724 if country == "Spain"
replace ctrycode = 752 if country == "Sweden"
replace ctrycode = 826 if country == "UK"

local countries Austria Belgium Denmark Finland France Germany Greece Ireland Italy Netherlands Portugal Spain Sweden UK
foreach ctry in `countries' {
  gen `ctry' = 1 if country == "`ctry'"
  replace `ctry' = 0 if `ctry' == .
}

drop if ctrycode == .
sort ctrycode year
tsset ctrycode year

gen auth = 1 if (Greece & year < 1976) | (Portugal & year < 1977) | (Spain & year < 1979)
replace auth = 0 if auth == .
drop if auth

merge country year using "$repos/data/kim_fording/govtideology.dta", sort
drop if _merge == 2
drop _merge
*drop if govleft == .
sort ctrycode year
rename govid2006_1 govideo
gen ideoyear = year if govideo != .
by ctrycode: egen finalideoyear = max(ideoyear)
by ctrycode: gen ideoelectyear = year if year > finalideoyear & elect != .
by ctrycode: egen postideoelectyear = min(ideoelectyear)
by ctrycode: replace govideo = l.govideo if govideo == . & l.govideo != . & year <= postideoelectyear


// Indicator for the sample of countries I have privatization revenue data for
gen priv_ctry = 1 if  Austria | Belgium | Denmark | Finland | France | Germany | Greece | Ireland | Italy | Netherlands | Portugal | Spain | Sweden | UK
replace priv_ctry = 0 if priv_ctry == .
drop if !priv_ctry

tsset ctrycode year

replace country = "FRG/Germany" if country == "Germany"
rename country countryname
sort countryname year
merge 1:1 countryname year using "$repos/data/worldbank/databasepoliticalinstitutions/DPI2010_stata9.dta", 
drop if countryn == .
drop _merge
rename countryname country
replace country = "Germany" if country == "FRG/Germany"
sort country year

rename ud udx
rename ctry ctryx
rename auth authx
merge 1:1 country year using "$repos/data/visser_jelle/ICTWSS_Database_30.dta"
rename ctry ctryvisser
rename ctryx ctry
rename auth authvisser
rename authx auth
drop _merge

merge country year using "$repos/data/globalfinancialdata/Global_financial_statistics.dta", sort
drop if countryn == .
drop _merge

drop if !priv_ctry

rename ccode ccode2
encode country, generate(ccode)

sort ccode year
tsset ccode year

// Fix up all the values that are strings because they contain commas.
destring ttl_labf civ_labf, generate(ttllabf civlabf) ignore(",") force

sort ccode year
tsset ccode year


// Rename a few variables for historical reasons.
rename debt pubdebt
rename openc impexp

tsset ccode year

gen maastricht = 1 if year > 1993
replace maastricht = 0 if maastricht == .
replace maastricht = 0 if (Austria | Finland | Sweden) & year < 1995

gen gfd_mkcap_pc = gfd_mkcap/(pop1*1000) // (pop*1000)
gen gfd_valtraded_pc = gfd_valtraded/(pop1*1000) // (pop*1000)

rename ud uden
rename unemp unempl

gen loglevel = log(level)
gen logwcoord = log(wcoord)

foreach var in socexp_t_pmp almp_pmp govleft pc_cum_rev pcd_cum_rev unempl pubdebt deficit uden gfd_mkcap_pc wcoord logwcoord level loglevel spatial_pop spatial_trade {
  gen `var'_l1 = l.`var'
}

// Get rid of some superfluous variables
//drop y1* y2* y7* y8* y9* ar_* delta* var0* country_*
//drop  c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20 c21 c22 c23

replace oppfrac = . if oppfrac < 0
replace govfrac = . if govfrac < 0
// Re-scale for more efficient coeffient display in regression tables.
replace govfrac = 100 * govfrac


destring uden, replace
gen gl_x_uden = govleft*uden
gen gl_x_udenl1 = govleft *l.uden
gen prgal = 100-dis_gall
gen gl_x_prgal = govleft * prgal
gen gl_x_singmemd = govleft * singmemd
gen gl_x_effparleg = govleft * effpar_leg
gen gl_x_level = govleft * level
gen gl_x_levell1 = govleft * l.level
gen gl_x_loglevel = govleft * loglevel
gen gl_x_loglevell1 = govleft * l.loglevel
gen gl_x_wcoord = govleft * wcoord
gen gl_x_wcoordl1 = govleft * l.wcoord
gen gl_x_logwcoord = govleft * logwcoord
gen gl_x_logwcoordl1 = govleft * l.logwcoord
gen gl_x_govfrac = govleft*govfrac
gen gl_x_socexp = govleft*socexp_t_pmp
gen gl_x_socexpl1 = govleft*l.socexp_t_pmp
gen gl_x_almp = govleft*almp_pmp 
gen gl_x_almpl1 = govleft*l.almp_pmp 
gen gl_x_cent = govleft*cent 

replace mdmh = . if mdmh == -999
gen logmdmh = log(mdmh)
gen gl_x_logmdmh = govleft*logmdmh

gen prrel = -dis_rel
gen gl_x_prrel = govleft*prrel
gen prabso = -dis_abso
gen gl_x_prabso = govleft*prabso

gen gi_x_udenl1 = govideo*l.uden
gen gi_x_prgal = govideo * prgal
gen gi_x_singmemd = govideo * singmemd
gen gi_x_effparleg = govideo * effpar_leg
gen gi_x_wcoord = govideo * wcoord
gen gi_x_wcoordl1 = govideo * l.wcoord
gen gi_x_level = govideo * level
gen gi_x_levell1 = govideo * l.level

gen gl_x_year = govleft * year

foreach var in prgal effpar_leg uden_l1 unempl_l1 pubdebt_l1 deficit_l1 gfd_mkcap_pc_l1 govfrac govleft wcoord wcoord_l1 level level_l1 gl_x_udenl1 gl_x_prgal gl_x_singmemd gl_x_effparleg gl_x_wcoord gl_x_wcoordl1 gl_x_level gl_x_levell1 allhouse govideo gi_x_prgal gi_x_singmemd gi_x_effparleg gi_x_wcoordl1 gi_x_levell1 gi_x_udenl1 {
  by ccode: egen `var'_m = mean(`var')
  by ccode:  gen `var'_md = `var'-`var'_m
}


// Label variables so that they get nicely formatted when we export to Latex.
label var pcd_priv_rev			"$ PrivRevPC_{i,t} $"
label var pcd_cum_rev			"$ CumPrivPC_{i,t} $"
label var pcd_cum_rev_l1		"$ CumPrivPC_{i,t-1} $"
label var pcd_cum_rev_l1		"$ \sum_{\tau=0}^{t-1} {PrivRevPC_{i,\tau}} $"
label var spatial_pop			"$ Diffuse^{Pop}_{i,t} $"
label var spatial_pop_l1		"$ Diffuse^{Pop}_{i,t-1} $"
label var spatial_trade			"$ Diffuse^{Trade}_{i,t} $"
label var spatial_trade_l1		"$ Diffuse^{Trade}_{i,t-1} $"

label var maastricht			"$ Maastricht_{i,t} $"
label var year					"$ Year_{t} $"
label var gl_x_year				"$ GovLeft \cdot Year_{t} $"

label var unempl_l1	 			"$ Unemployment_{i,t-1} $"
label var unempl_l1_m 			"$ Unemployment_i^B $"
label var unempl_l1_md 			"$ Unemployment_{i,t-1} $"
label var pubdebt_l1	 		"$ PublicDebt_{i,t-1} $"
label var pubdebt_l1_m 			"$ PublicDebt_i^B $"
label var pubdebt_l1_md 		"$ PublicDebt_{i,t-1} $"
label var deficit_l1	 		"$ PublicDeficit_{i,t-1} $"
label var deficit_l1_m 			"$ PublicDeficit_i^B $"
label var deficit_l1_md 		"$ PublicDeficit_{i,t-1} $"
label var gfd_mkcap_pc_l1 		"$ MktCapPC_{i,t-1} $"
label var gfd_mkcap_pc_l1_m 	"$ MktCapPC_i^B $"
label var gfd_mkcap_pc_l1_md 	"$ MktCapPC_{i,t-1} $"
label var govfrac	 			"$ GovFrac_{i,t} $"
label var govfrac_m 			"$ GovFrac_i^B $"
label var govfrac_md 			"$ GovFrac_{i,t} $"

label var govleft				"$ GovLeft_{i,t} $"
label var govleft_m				"$ GovLeft_i^B $"
label var govleft_md			"$ GovLeft_{i,t} $"
label var prgal	 				"$ PR_{i,t} $"
label var prgal_m 				"$ PR_i^B $"
label var prgal_md 				"$ PR_{i,t} $"
label var gl_x_prgal			"$ GovLeft_{i,t} \cdot PR_{i,t} $"
label var gl_x_prgal_m			"$ (GovLeft_{i,t} \cdot PR_{i,t})_i^B $"
label var gl_x_prgal_md			"$ (GovLeft_{i,t} \cdot PR_{i,t}) $"
label var singmemd				"$ SMD_{i,t} $"
label var gl_x_singmemd			"$ Left_{i,t} \cdot SMD_{i,t} $"
label var prrel					"$ PR^{Rel}_{i,t} $"
label var gl_x_prrel			"$ Left_{i,t} \cdot PR^{Rel}_{i,t} $"
label var prabso				"$ PR^{Abs}_{i,t} $"
label var gl_x_prabso			"$ Left_{i,t} \cdot PR^{Abs}_{i,t} $"
label var logmdmh				"$ \log(DistMag)_{i,t} $"
label var gl_x_logmdmh			"$ Left_{i,t} \cdot \log(DistMag)_{i,t} $"
label var effpar_leg			"$ Parties_{i,t} $"
label var effpar_leg_m 			"$ Parties_i^B $"
label var effpar_leg_md 		"$ Parties_{i,t} $"
label var gl_x_effparleg		"$ GovLeft_{i,t} \cdot Parties_{i,t} $"
label var gl_x_effparleg_m		"$ (GovLeft_{i,t} \cdot Parties_{i,t})_i^B $"
label var gl_x_effparleg_md		"$ (GovLeft_{i,t} \cdot Parties_{i,t}) $"
label var uden_l1 				"$ UDen_{i,t-1} $"
label var uden_l1_m				"$ UDen_i^B $"
label var uden_l1_md 			"$ UDen_{i,t-1} $"
label var gl_x_udenl1			"$ GovLeft_{i,t} \cdot UDen_{i,t-1} $"
label var gl_x_udenl1_m			"$ (GovLeft_{i,t} \cdot UDen_{i,t-1})_i^B $"
label var gl_x_udenl1_md		"$ (GovLeft_{i,t} \cdot UDen_{i,t-1}) $"
label var level					"$ BargLevel_{i,t} $"
label var level_l1				"$ BargLevel_{i,t-1} $"
label var level_l1_m			"$ BargLevel_i^B $"
label var level_l1_md 			"$ BargLevel_{i,t-1} $"
label var gl_x_level			"$ GovLeft_{i,t} \cdot BargLevel_{i,t} $"
label var gl_x_levell1			"$ GovLeft_{i,t} \cdot BargLevel_{i,t-1} $"
label var gl_x_levell1_m		"$ (GovLeft_{i,t} \cdot BargLevel_{i,t-1})_i^B $"
label var gl_x_levell1_md		"$ (GovLeft_{i,t} \cdot BargLevel_{i,t-1}) $"
label var almp_pmp				"$ ALMP_{i,t} $"
label var almp_pmp_l1			"$ ALMP_{i,t-1} $"
label var gl_x_almp				"$ GovLeft_{i,t} \cdot ALMP_{i,t} $"
label var gl_x_almpl1			"$ GovLeft_{i,t} \cdot ALMP_{i,t-1} $"
label var socexp_t_pmp			"$ SocExp_{i,t} $"
label var gl_x_socexp			"$ GovLeft_{i,t} \cdot SocExp_{i,t} $"
label var socexp_t_pmp_l1		"$ SocExp_{i,t-1} $"
label var gl_x_socexpl1			"$ GovLeft_{i,t} \cdot SocExp_{i,t-1} $"
label var cent					"$ WageCent_{i,t} $"
label var gl_x_cent				"$ GovLeft_{i,t} \cdot WageCent_{i,t} $"

label var loglevel				"$ \log BargLevel_{i,t} $"
label var loglevel_l1			"$ \log BargLevel_{i,t-1} $"
label var gl_x_loglevel			"$ GovLeft_{i,t} \cdot \log BargLevel_{i,t} $"
label var gl_x_loglevell1		"$ GovLeft_{i,t} \cdot \log BargLevel_{i,t-1} $"

label var wcoord				"$ WageCoord_{i,t} $"
label var wcoord_l1				"$ WageCoord_{i,t-1} $"
label var wcoord_l1_m			"$ WageCoord_i^B $"
label var wcoord_l1_md 			"$ WageCoord_{i,t-1} $"
label var gl_x_wcoord			"$ GovLeft_{i,t} \cdot WageCoord_{i,t} $"
label var gl_x_wcoordl1			"$ GovLeft_{i,t} \cdot WageCoord_{i,t-1} $"
label var gl_x_wcoordl1_m		"$ (Left_{i,t} \cdot WageCoord_{i,t-1})_i^B $"
label var gl_x_wcoordl1_md		"$ (Left_{i,t} \cdot WageCoord_{i,t-1}) $"

label var logwcoord				"$ \log WageCoord_{i,t} $"
label var logwcoord_l1			"$ \log WageCoord_{i,t-1} $"
label var gl_x_logwcoord		"$ GovLeft_{i,t} \cdot \log WageCoord_{i,t} $"
label var gl_x_logwcoordl1		"$ GovLeft_{i,t} \cdot \log WageCoord_{i,t-1} $"

label var govideo				"$ GovIdeo_{i,t} $"
label var govideo_m				"$ GovIdeo_i^B $"
label var govideo_md			"$ GovIdeo_{i,t} $"

label var gi_x_level			"$ GovIdeo_{i,t} \cdot BargLevel_{i,t} $"
label var gi_x_levell1			"$ GovIdeo_{i,t} \cdot BargLevel_{i,t-1} $"
label var gi_x_levell1_m		"$ (GovIdeo_{i,t} \cdot BargLevel_{i,t-1})_i^B $"
label var gi_x_levell1_md		"$ (GovIdeo_{i,t} \cdot BargLevel_{i,t-1}) $"

label var gi_x_wcoord			"$ GovIdeo_{i,t} \cdot WageCoord_{i,t} $"
label var gi_x_wcoordl1			"$ GovIdeo_{i,t} \cdot WageCoord_{i,t-1} $"
label var gi_x_wcoordl1_m		"$ (GovIdeo_{i,t} \cdot WageCoord_{i,t-1})_i^B $"
label var gi_x_wcoordl1_md		"$ (GovIdeo_{i,t} \cdot WageCoord_{i,t-1}) $"

label var gi_x_prgal			"$ GovIdeo_{i,t} \cdot PR_{i,t} $"
label var gi_x_prgal_m			"$ (GovIdeo_{i,t} \cdot PR_{i,t})_i^B $"
label var gi_x_prgal_md			"$ (GovIdeo_{i,t} \cdot PR_{i,t}) $"

label var gi_x_udenl1			"$ GovIdeo_{i,t} \cdot UDen_{i,t-1} $"
label var gi_x_udenl1_m			"$ (GovIdeo_{i,t} \cdot UDen_{i,t-1})_i^B $"
label var gi_x_udenl1_md		"$ (GovIdeo_{i,t} \cdot UDen_{i,t-1}) $"

