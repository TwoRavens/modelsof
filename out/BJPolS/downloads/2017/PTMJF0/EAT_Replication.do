% Replication file for "The Strategic Origins of Electoral Authoritarianism" in British Journal of Political Science
% Written by Michael K. Miller, George Washington University



% Main specification (Table 2, Model 1)

global base0 "d_cubdur1-d_cubdur7 regiondemx regioneax bmr_prevauth easpelltotx loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year"
global base "$base0"
global se "r cluster(ccode)"
global cond "if rtxfix==1 & regtrans!=-66 & regtrans!=-77 & regtrans!=96 & regtrans!=98"

eststo clear

version 10: eststo: quietly mlogit frtxfix $base $cond, base(1) $se

esttab, drop(d_c*)



% Added controls (Table 2, Model 2; Table 3)

global base "gini2 resourcesdep_hm $base0"

global base "eax_trade2 demx_trade2 $base0"
global base "eax_alliance demx_alliance $base0"
global base "igodem_interp igoea_interp $base0"
global base "aiddem_ext $base0"
global base "igo kof_social trade $base0"
global base "aid2 $base0"
global base "hdi $base0"
global base "education university $base0"
global base "d_svolfound3 svol_party_priorruler svol_legexists $base0"
global base "d_geddes2 d_geddes5 $base0"
global base "cow_military $base0"
global base "Capacity $base0"
global base "violence_domestic antigovtpeace $base0"



% Robustness checks

global cond2 "& regtrans!=-66 & regtrans!=-77 & regtrans!=96 & regtrans!=98"

% Failed EA trans included (Table A2/A3, Model 1)
version 10: eststo: quietly mlogit frtx_addedea2 $base if rtx_addedea2==1 $cond2, base(1) $se

% Requires recent election (Table A2/A3, Model 2)
global base0 "d_cubdur1-d_cubdur7 regiondemx regioneax_alt bmr_prevauth easpelltotx_alt loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year"
version 10: eststo: quietly mlogit frtxalt $base if rtxalt==1 $cond2, base(1) $se

% Requires 5 years as new regime (Table A2/A3, Model 3)
version 10: eststo: quietly mlogit frtxfix $base if rtxfix==1 & (F.rtxfix==1 | (F.rtxfix==F2.rtxfix & F.rtxfix==F3.rtxfix & F.rtxfix==F4.rtxfix & F.rtxfix==F5.rtxfix)) $cond2, base(1) $se

% Multiple parties outside front (Table A2/A3, Model 4)
version 10: eststo: quietly mlogit frtxfixb $base if rtxfixb==1 $cond2, base(1) $se

% Include state failure (Table A4, Model 1)
version 10: eststo: quietly mlogit frtxfix $base if rtxfix==1, base(1) $se

% 5-year lagged EVs (Table A4, Model 2)
global base0 "d_cubdur1-d_cubdur7 regiondemx regioneax bmr_prevauth easpelltotx loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year"
global base "$base0"
version 10: eststo: quietly mlogit f5rtxfix $base if rtxfix==1 $cond2, base(1) $se

global base0 "d_cubdur1-d_cubdur7 regiondemx regioneax bmr_prevauth easpelltotx loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year"
global base "l4gini2 l4resourcesdep_hm $base0"
global base "l4eax_trade2 l4demx_trade2 $base0"
global base "l4eax_alliance l4demx_alliance $base0"
global base "l4igodem_interp l4igoea_interp $base0"
global base "l4aiddem_ext $base0"
global base "l4aid2 $base0"
global base "l4aiddem_ext_cap l4aidnondem_ext_cap $base0"
global base "l4d_svolfound3 l4svol_party_priorruler l4svol_legexists $base0"
global base "l4Capacity $base0"
version 10: eststo: quietly mlogit frtxfix $base if rtxfix==1 $cond2, base(1) $se

% Duration measure alternative
global base "d_geddesdur1-d_geddesdur7 regiondem regionea boix_prevauth easpelltot loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year"



% Post-Cold War control + interactions (Table A5)

version 10: eststo: quietly mlogit frtxfix pcw $base if rtxfix==1 $cond2, base(1) $se
version 10: eststo: quietly mlogit frtxfix $base if rtxfix==1 $cond2 & pcw==0, base(1) $se
version 10: eststo: quietly mlogit frtxfix $base if rtxfix==1 $cond2 & pcw==1, base(1) $se
version 10: eststo: quietly logit frtxfix_ea $base if rtxfix==1 $cond2 & pcw==0, $se
version 10: eststo: quietly logit frtxfix_ea $base if rtxfix==1 $cond2 & pcw==1, $se

global base0 "d_cubdur1-d_cubdur7 regiondemx regioneax bmr_prevauth easpelltotx loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year"
global base "$base0"
global base "pcw pcw_loggdp $base0"
global base "pcw pcw_urban_cow $base0"
global base "pcw pcw_regiondemx pcw_regioneax $base0"
global base "pcw eax_trade2 demx_trade2 pcw_demx_trade2 $base0"
global base "pcw eax_alliance demx_alliance pcw_demx_alliance $base0"
global base "pcw igodem_interp igoea_interp pcw_igodem_interp $base0"
global base "pcw aiddem_ext pcw_aiddem_ext $base0"
global base "pcw aid2 pcw_aid2 $base0"

eststo clear
version 10: eststo: quietly mlogit frtxfix $base if rtxfix==1 $cond2, base(1) $se
esttab, drop(d_c*)



% Stratify by new leader or regime (Table A6)

global base0 "d_cubdur1-d_cubdur7 regiondemx regioneax bmr_prevauth easpelltotx loggdp urban_cow ELF gdp_grow lnpop year"
global base $base0
version 10: eststo: quietly mlogit frtxfix $base if rtxfix==1 $cond2 & regime_duration > 10 & regime_duration!=., base(1) $se
version 10: eststo: quietly mlogit frtxfix $base if rtxfix==1 $cond2 & regime_duration <= 10, base(1) $se



% Leader turnover

global ldrbase ""
global ldrbase "dd_tenure gdp_grow year"
global ldrbase "dd_tenure resourcesdep_hm gdp_grow year"
global ldrbase "durable dd_tenure resourcesdep_hm regiondemx regioneax gdp_grow year"
global cond "if rtxfix==1 & regtrans!=-66 & regtrans!=-77 & regtrans!=96 & regtrans!=98"
global cond "if rtxfix==3 & regtrans!=-66 & regtrans!=-77 & regtrans!=96 & regtrans!=98"
global se "r cluster(ccode)"

eststo clear
version 10: eststo: quietly probit turn loggdp $ldrbase $cond, $se
version 10: eststo: quietly probit turn gini2 loggdp $ldrbase $cond, $se
margins, at(loggdp=(6.57 9.19)) vsquish






% Figures

% Regimes by year (Figure 1)

by year, sort: gen yearid=_n
by year, sort: egen CA_year = total(d_rtx1)
by year, sort: egen EA_year = total(d_rtx3)
by year, sort: egen Dem_year = total(d_rtx2)
gen pc_year = CA_year + EA_year + Dem_year
gen CA_p = CA_year/pc_year
gen EA_p = EA_year/pc_year + CA_p
gen Dem_p = Dem_year/pc_year + EA_p

set scheme s1color
tw area Dem_p EA_p CA_p year if yearid==1 & year>=1946 & year <= 2010


% Aid/IGO around transitions (Figure 2)

sort eatime demtime
by eatime, sort: egen eatime_USeconmil = mean(USeconmil) if eatime!=.
by demtime, sort: egen demtime_USeconmil = mean(USeconmil) if demtime!=.
by eatime, sort: egen eatime_igo = mean(igo) if eatime!=.
by demtime, sort: egen demtime_igo = mean(igo) if demtime!=.
gen demtime_USeconmil_normed = demtime_USeconmil/14.42
gen eatime_USeconmil_normed = eatime_USeconmil/10.12
gen demtime_igo_normed = demtime_igo/46.02
gen eatime_igo_normed = eatime_igo/42.29

set scheme s1color
tw conn demtime_USeconmil_normed demtime || conn eatime_USeconmil_normed eatime
tw conn demtime_igo_normed demtime || conn eatime_igo_normed eatime


% Trade dependence + alliances (Figure 3)

set scheme s1color
global base "eax_alliance demx_alliance durable dur2 dur3 regiondemx regioneax bmr_prevauth easpelltotx loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year"
global base "eax_trade2 demx_trade2 durable dur2 dur3 regiondemx regioneax bmr_prevauth easpelltotx loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year"
global base "igodem_interp igoea_interp durable dur2 dur3 regiondemx regioneax bmr_prevauth easpelltotx loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year"
global base "aiddem_ext durable dur2 dur3 regiondemx regioneax bmr_prevauth easpelltotx loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year"
global atvar "demx_alliance"
global atvar "demx_trade2"
global atvar "igodem_interp"
global atvar "aiddem_ext"
global se "r cluster(ccode)"
global cond "if rtxfix==1 & regtrans!=-66 & regtrans!=-77 & regtrans!=96 & regtrans!=98"

quietly mlogit frtxfix $base $cond, base(1) $se
margins, at($atvar = (0(.05)1)) predict(outcome(2)) vsquish saving(demdem, replace)
margins, at($atvar = (0(.05)1)) predict(outcome(3)) vsquish saving(demea, replace)
combomarginsplot demdem demea, recast(line) recastci(rline)

quietly mlogit frtxfix $base $cond, base(1) $se
margins, at($atvar = (0(.05)1)) predict(outcome(2)) vsquish post
mat t=J(21,3,.)
mat a = (0\.05\.1\.15\.2\.25\.3\.35\.4\.45\.5\.55\.6\.65\.7\.75\.8\.85\.9\.95\1) 
forvalues i=1/21 {
  mat t[`i',1] = _b[`i'._at]                       
  mat t[`i',2] = max(_b[`i'._at] - 1.96*_se[`i'._at],0)
  mat t[`i',3] = _b[`i'._at] + 1.96*_se[`i'._at]  
}
mat t=t,a                                          
mat colnames t = prob ll ul at                     
svmat t, names(col)

quietly mlogit frtxfix $base $cond, base(1) $se
margins, at($atvar = (0(.05)1)) predict(outcome(3)) vsquish post
mat t2=J(21,3,.)
mat a2 = (0\.05\.1\.15\.2\.25\.3\.35\.4\.45\.5\.55\.6\.65\.7\.75\.8\.85\.9\.95\1) 
forvalues i=1/21 {
  mat t2[`i',1] = _b[`i'._at]                       
  mat t2[`i',2] = max(_b[`i'._at] - 1.96*_se[`i'._at],0)
  mat t2[`i',3] = _b[`i'._at] + 1.96*_se[`i'._at]  
}
mat t2=t2,a2                                          
mat colnames t2 = prob2 ll2 ul2 at2                     
svmat t2, names(col)
twoway (rarea ll ul at)(line prob at)(rline ll2 ul2 at2)(line prob2 at2)

drop prob ll ul at prob2 ll2 ul2 at2


% Regional EA + democracy (Figure 4)

global base "durable dur2 dur3 regiondemx regioneax bmr_prevauth easpelltotx loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year"
quietly mlogit frtxfix $base $cond, base(1) $se

set scheme s1color
margins, at(regiondemx=(0(.05)1)) predict(outcome(2)) vsquish saving(demdem, replace)
margins, at(regiondemx=(0(.05)1)) predict(outcome(3)) vsquish saving(demea, replace)
combomarginsplot demdem demea, recast(line) recastci(rline)

margins, at(regioneax=(0(.05)1)) predict(outcome(2)) vsquish saving(eadem, replace)
margins, at(regioneax=(0(.05)1)) predict(outcome(3)) vsquish saving(eaea, replace)
combomarginsplot eadem eaea, recast(line) recastci(rline)



% Summary stats (Table A1)

sutex igodem_interp igoea_interp aiddem_ext regioneax regiondemx loggdp gdp_grow irreggov5_c irregnongov5_c reg5_c urban_cow ELF lnpop easpelltotx bmr_prevauth resourcesdep_hm gini2 eax_trade2 demx_trade2 eax_alliance demx_alliance igo aid2 d_svolfound3 svol_party_priorruler svol_legexists year if rtxfix==1 & regtrans!=-66 & regtrans!=-77 & regtrans!=96 & regtrans!=98, minmax labels file("EATsum.tex") replace


% IIA test

mlogit frtxfix durable regiondemx regioneax bmr_prevauth easpelltotx loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year
mlogtest, iia








% Coding

xtset ccode year

global var "d_rtx1"
by region year, sort: egen rc_$var = count($var) if $var!=.
by region year, sort: egen reg_$var = mean($var)
gen rx_$var = (rc_$var*reg_$var - $var)/(rc_$var - 1)
drop rc_$var reg_$var

gen rt_x = rt
replace rt_x = L.rt_x if year > 2008
replace rt_x = 2 if bmr==1 & year > 2008
replace rt_x = 3 if ccode==91 & year==2009
replace rt_x = 3 if ccode==780 & year==2010
replace rt_x = 1 if ccode==580 & year==2009
replace rt_x = 3 if ccode==580 & year==2010
replace rt_x = 1 if ccode==436 & year==2009
replace rt_x = 1 if ccode==436 & year==2010
replace rt_x = 1 if ccode==435 & year==2006
replace rt_x = 1 if ccode==435 & year==2008
replace rt_x = 3 if ccode==435 & year>=2009
replace rt_x = 3 if ccode==660 & year>=2009
tab rt_x, gen(d_rtx)
gen frtx = F.rt_x
gen regiondemx = rx_d_rtx2
gen regioneax = rx_d_rtx3

gen easpellx = 0
replace easpellx=1 if L.rt_x==3 & rt_x!=3
gen easpelltotx = 0
replace easpelltotx = L.easpelltotx + easpellx if easpellx!=. & L.easpelltotx!=.
replace easpellx = . if year < 1946
replace easpelltotx = . if year < 1946

gen regime_agex = 1 if year == 1946 | L.rt_x==. | (L.rt_x != rt_x & rt_x!=.)
replace regime_agex = L.regime_agex + 1 if L.rt_x==rt_x & L.rt_x!=. & rt_x!=.

gen rtxfix = rt_x
replace rtxfix = 1 if ccode==90 & year==1985
replace rtxfix = 1 if ccode==91 & year==1981
replace rtxfix = 1 if ccode==101 & year==1958
replace rtxfix = 1 if ccode==155 & year==1989
replace rtxfix = 1 if ccode==310 & year==1989
replace rtxfix = 1 if ccode==360 & year==1990
replace rtxfix = 1 if ccode==402 & year==1990
replace rtxfix = 1 if ccode==434 & year==1990
replace rtxfix = 1 if ccode==452 & year==1969
replace rtxfix = 1 if ccode==553 & year==1993
replace rtxfix = 1 if ccode==790 & year==1990
replace rtxfix = 1 if ccode==100 & year==1948
replace rtxfix = 3 if ccode==339 & (year==1990 | year==1991)
replace rtxfix = 3 if ccode==404 & (year>=1991 & year <=1993)
replace rtxfix = 3 if ccode==450 & (year>=2003 & year <=2005)
replace rtxfix = 3 if ccode==541 & (year>=1991 & year <=1993)
gen frtxfix = F.rtxfix
gen f5rtxfix = F5.rtxfix

gen frtxfix_ea = 1*(frtxfix==3)
replace frtxfix_ea=. if frtxfix==.
gen frtxfix_dem = 1*(frtxfix==2)
replace frtxfix_dem=. if frtxfix==.
gen frtxfix_ca = 1*(frtxfix==1)
replace frtxfix_ca=. if frtxfix==.
gen rtxfixb = 2 if bmr==1
replace rtxfixb = 3 if ea2b==1
replace rtxfixb = 1 if ea2b==0 & bmr==0
gen frtxfixb = F.rtxfixb

gen rtxalt = rtxfix
replace rtxalt = 1 if rtxalt==3 & (lnlegany5==0)
gen frtxalt = F.rtxalt
tab rtxalt, gen(d_rtxalt)

gen easpellx_alt = 0
replace easpellx_alt=1 if L.rt_x==3 & rt_x!=3
gen easpelltotx_alt = 0
replace easpelltotx_alt = L.easpelltotx_alt + easpellx_alt if easpellx_alt!=. & L.easpelltotx_alt!=.
gen regioneax_alt = rx_d_rtxalt3

% Recode cases in which ruling party runs hoping to win, but unintentionally loses + democratizes
gen rtx_addedea = rtxfix
replace rtx_addedea = 3 if ccode==90 & year==1966
replace rtx_addedea = 3 if ccode==92 & year==1984
replace rtx_addedea = 3 if ccode==372 & year==2004
replace rtx_addedea = 3 if ccode==402 & year==1991
replace rtx_addedea = 3 if ccode==553 & year==1994
gen frtx_addedea = F.rtx_addedea
tab rtx_addedea, gen(d_rtx_addedea)

% Recode cases in which autocrat wins election, which is judged democratic
gen rtx_addedea2 = rtx_addedea
replace rtx_addedea2 = 3 if ccode==90 & year==1958
replace rtx_addedea2 = 3 if ccode==712 & year==1990
replace rtx_addedea2 = 3 if ccode==775 & year==1960
gen frtx_addedea2 = F.rtx_addedea2
tab rtx_addedea2, gen(d_rtx_addedea2)

gen svol_party_priorruler = d_svolfound2 + d_svolfound4
gen svol_party = d_svolfound2 + d_svolfound3 + d_svolfound4
gen partyexists = 1 - d_ddparties1
tab svol_found, gen(d_svolfound)
tab svol_leg, gen(d_svolleg)
gen svol_legexists = 1 - d_svolleg1

tab dd_parties, gen(d_ddparties)
gen antigovtpeace = protests + strikes
gen antigovtpeace2 = (antigovtpeace + L.antigovtpeace)/2
gen antigovtpeace5 = (antigovtpeace + L.antigovtpeace + L2.antigovtpeace + L3.antigovtpeace + L4.antigovtpeace)/5
gen violence2 = (violence_domestic + L.violence_domestic)/2
gen violence5 = (violence_domestic + L.violence_domestic + L2.violence_domestic + L3.violence_domestic + L4.violence_domestic)/5
gen pcw = 1*(year > 1989)

bspline, xvar(durable) knots(0 3 11 24 110) p(3) gen(d_cubdur)
bspline, xvar(regime_duration) knots(1 5 12 24 266) p(3) gen(d_geddesdur)

tab geddes_type2, gen(d_geddes)
gen loggdp = log(gdp)
tab region, gen(d_region)
gen lnpop = log(population)

tab year, gen(d_year)
tab ccode, gen(d_ccode)

gen eax_totaltrade = eax_trade2*trade
gen demx_totaltrade = demx_trade2*trade

gen l4aidnondem_ext_cap = L4.aidnondem_ext_cap
gen l4aiddem_ext_cap = L4.aiddem_ext_cap
gen l4gini2 = L4.gini2
gen l4resourcesdep_hm = L4.resourcesdep_hm
gen l4eax_trade2 = L4.eax_trade2
gen l4demx_trade2 = L4.demx_trade2
gen l4eax_alliance = L4.eax_alliance
gen l4demx_alliance = L4.demx_alliance
gen l4igodem_interp = L4.igodem_interp
gen l4igoea_interp = L4.igoea_interp
gen l4aiddem_ext = L4.aiddem_ext
gen l4d_svolfound3 = L4.d_svolfound3
gen l4svol_party_priorruler = L4.svol_party_priorruler
gen l4svol_legexists = L4.svol_legexists
gen l4Capacity = L4.Capacity

local i = "gini2 resourcesdep_hm violence_domestic antigovtpeace Capacity cow_military d_geddes2 d_geddes5 d_svolfound3 svol_party_priorruler svol_legexists education university hdi aid2 igo kof_social trade aiddem_ext igodem_interp igoea_interp eax_alliance demx_alliance eax_trade2 demx_trade2 regiondemx regioneax loggdp irreggov5_c irregnongov5_c reg5_c urban_cow"
local i = "eax_alliance demx_alliance eax_trade2 demx_trade2 regiondemx regioneax loggdp irreggov5_c irregnongov5_c reg5_c urban_cow"
foreach t of local i {
	gen pcw_`t' = `t'
	replace pcw_`t'=0 if year<1990
	gen cw_`t' = `t'
	replace cw_`t'=0 if year>1989
	}

end

% After mlogit
predict p1 p2 p3


keep d_cubdur1-d_cubdur7 regiondemx regioneax bmr_prevauth easpelltotx loggdp irreggov5_c irregnongov5_c reg5_c urban_cow ELF gdp_grow lnpop year ccode rtxfix regtrans frtxfix gini2 resourcesdep_hm eax_trade2 demx_trade2 eax_alliance demx_alliance igodem_interp igoea_interp aiddem_ext igo kof_social trade aid2 hdi education university d_svolfound3 svol_party_priorruler svol_legexists d_geddes2 d_geddes5 cow_military Capacity violence_domestic antigovtpeace frtx_addedea2 rtx_addedea2 regioneax_alt easpelltotx_alt frtxalt rtxalt frtxfixb rtxfixb l4* d_geddesdur1-d_geddesdur7 pcw pcw_* regime_duration dd_tenure durable dur2 dur3 turn yearid CA_year d_rtx1 EA_year d_rtx3 Dem_year d_rtx2 pc_year CA_year EA_year Dem_year CA_p EA_p Dem_p eatime demtime USeconmil demtime_USeconmil_normed eatime_USeconmil_normed demtime_igo_normed eatime_igo_normed rt_x frtx regime_agex f5rtxfix frtxfix_ea frtxfix_dem frtxfix_ca lnlegany5 protests strikes antigovtpeace2 antigovtpeace5 violence2 violence5 region eax_totaltrade demx_totaltrade trade p1 p2 p3

