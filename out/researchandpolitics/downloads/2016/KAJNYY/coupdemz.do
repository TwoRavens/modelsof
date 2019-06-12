	
	egen caseid = group(gwf_casename)
	merge ccode year using Demz.dta, keep(arch_tenure)
    gen ld  = ln(arch_tenure)
	tab year, gen(d_year)
	tab caseid, gen(d_case)
	gen regimecoup = 1*(gwf_fail==1 & pt_anycoupS==1)
	gen caseidb = caseid
	replace caseidb = L.caseid if L.regimecoup==1
	replace caseidb = L.caseidb if L2.regimecoup==1
	tab caseidb, gen(db_case)
	replace caseidc = caseid
    replace caseidc = L.caseidc if L.regimecoup==1
	replace caseidc = L.caseidc if L.caseidc!=caseid & L.caseidc!=. & L.gwf_fail!=1
	tab caseidc, gen(dc_case)
	gen caseidd = caseid
	replace caseidd = L.caseidd if L.pt_anycoupS==1
	replace caseidd = L.caseidd if L2.pt_anycoupS==1
	tab caseidd, gen(dd_case)
	gen caseidfived = caseid
	replace caseidfived = L.caseidfived if L.pt_anycoupS==1
	replace caseidfived = L.caseidfived if L2.pt_anycoupS==1
	replace caseidfived = L.caseidfived if L3.pt_anycoupS==1
	replace caseidfived = L.caseidfived if L4.pt_anycoupS==1
	tab caseidfived, gen(dfived_case)
	gen caseide = caseid
	tab caseide, gen(de_case)
	gen lpt = L.pt_anycoupS
	gen l2pt = L2.pt_anycoupS
	gen lcaseide = L.caseide
	gen l2caseide = L2.caseide
	forvalues i = 1/285{
	replace de_case`i' = 1 if lpt==1 & lcaseide==`i'
	replace de_case`i' = 1 if l2pt==1 & l2caseide==`i'
	}
	gen caseidfivee = caseid
	tab caseidfivee, gen(dfivee_case)
	gen l3pt = L3.pt_anycoupS
	gen l4pt = L4.pt_anycoupS
	gen l3caseidfivee = L3.caseidfivee
	gen l4caseidfivee = L4.caseidfivee
	forvalues i = 1/285{
	replace dfivee_case`i' = 1 if lpt==1 & lcaseidfivee==`i'
	replace dfivee_case`i' = 1 if l2pt==1 & l2caseidfivee==`i'
	replace dfivee_case`i' = 1 if l3pt==1 & l3caseidfivee==`i'
	replace dfivee_case`i' = 1 if l4pt==1 & l4caseidfivee==`i'
	}
	
    tab cow, gen(d_cow)
	gen decade = 10*floor(year/10)
    gen cowdecade = cow*10000 + decade
	tab cowdecade, gen(d_cowdec)
	gen twodecade = 20*floor((year)/20)
    gen cowtwodecade = cowcode*10000 + twodecade
	tab cowtwodecade, gen(d_twocowdec)
	
	gen gwfregc = 1 if gwf_regimetype!=.
	replace gwfregc = 2 if gwf_military==1
	replace gwfregc = 3 if gwf_monarch==1
	replace gwfregc = 4 if gwf_party==1
	gen gwfregcodec = cowcode*100 + gwfregc
	tab gwfregcodec, gen(d_gwfregcodec)
	
	tssmooth ma coupMS5_ma = pt_anycoupS, window(4 1 0)
	tssmooth ma coupMA5_ma = pt_anycoupA, window(4 1 0)
	gen coupMA5 = coupMA5_ma>0 if coupMA5_ma~=.
	gen coupMS5 = coupMS5_ma>0 if coupMS5_ma~=.
	local i = "coupMA5 coupMS5"
	foreach t of local i {
			gen pcw`t' = `t'
			replace pcw`t'=0 if year<1990
			gen cw`t' = `t'
			replace cw`t'=0 if year>1989
		}
	gen pcw = 1*(year >= 1990)

	gen pt_anycoup_nodem = pt_anycoup
	gen pt_anycoupS_nodem = pt_anycoupS
	replace pt_anycoup_nodem = 0 if gdem==.
	replace pt_anycoupS_nodem = 0 if gdem==.
	tssmooth ma coupMA_ma_nodem = pt_anycoup_nodem, window(2 1 0)
	gen coupMA_nodem = coupMA_ma_nodem>0 if coupMA_ma_nodem~=.
	tssmooth ma coupMS_ma_nodem = pt_anycoupS_nodem, window(2 1 0)
	gen coupMS_nodem = coupMS_ma_nodem>0 if coupMS_ma_nodem~=.
	local i = "coupMA_nodem coupMS_nodem"
		foreach t of local i {
			gen pcw`t' = `t'
			replace pcw`t'=0 if year<1990
			gen cw`t' = `t'
			replace cw`t'=0 if year>1989
		}
	
	
	global coups "cwcoupMS pcwcoupMS"	
	global coups "cwcoupMA pcwcoupMA"	
	global coups "cwcoupMS5 pcwcoupMS5"	
	global coups "cwcoupMA5 pcwcoupMA5"
	global coups "cwcoupMS_nodem pcwcoupMS_nodem"	
	global coups "cwcoupMA_nodem pcwcoupMA_nodem"
	global gtime "gtime gtime2 gtime3"
	global cond "if gdict==0"
	
	eststo clear
	
	% Original
	eststo: quietly reg gdem d_case* d_year* $gtime ld $coups $cond, cluster(caseid)
	
	% Extend regime id two years if regimecoup=1
	eststo: quietly reg gdem db_case* d_year* $gtime ld $coups $cond, cluster(caseidb)
	
	% Extend regime id two or five years if coup=1
	eststo: quietly reg gdem dd_case* d_year* $gtime ld $coups $cond, cluster(caseidd)
	eststo: quietly reg gdem dfived_case* d_year* $gtime ld $coups $cond, cluster(caseidfived)

	% Overlapping regime dummies if coup=1
	eststo: quietly reg gdem de_case* d_year* $gtime ld $coups $cond, cluster(caseide)
	eststo: quietly reg gdem dfivee_case* d_year* $gtime ld $coups $cond, cluster(caseidfivee)

	% Extend regime indefinitely
	eststo: quietly reg gdem dc_case* d_year* $gtime ld $coups $cond, cluster(caseidc)
	
	% Country-regime FE
	eststo: quietly reg gdem d_gwfregcodec* d_year* $gtime ld $coups $cond, cluster(gwfregcodec)

	% Country FE
	eststo: quietly reg gdem d_cow2-d_cow133 d_year* $gtime ld $coups $cond, cluster(cowcode)	
	
	% Country-decade + country-two decade FE
	matsize 2000
	eststo: quietly reg gdem d_cowdec* d_year* $gtime ld $coups $cond, cluster(cowdecade)
	eststo: quietly reg gdem d_twocowdec* d_year* $gtime ld $coups $cond, cluster(cowtwodecade)
	
        esttab, keep(ld cw* pcw*)	
	

	
	% List
	global cond "if gdict==0"
	eststo clear
	eststo: quietly reg gdem d_case* d_year* $gtime ld $coups $cond, cluster(caseid)
	eststo: quietly reg gdem dd_case* d_year* $gtime ld $coups $cond, cluster(caseidd)	
	eststo: quietly reg gdem dc_case* d_year* $gtime ld $coups $cond, cluster(caseidc)
	eststo: quietly reg gdem d_cow2-d_cow133 d_year* $gtime ld $coups $cond, cluster(cowcode)	
	eststo: quietly reg gdem d_gwfregcodec* d_year* $gtime ld $coups $cond, cluster(gwfregcodec)
	eststo: quietly reg gdem d_twocowdec* d_year* $gtime ld $coups $cond, cluster(cowtwodecade)
	esttab, keep(ld cw* pcw*)
	
	eststo clear
	eststo: quietly reg gdem d_case* d_year* $gtime ld $coups $cond, cluster(caseid)
	eststo: quietly reg gdem dfived_case* d_year* $gtime ld $coups $cond, cluster(caseidfived)	
	eststo: quietly reg gdem dc_case* d_year* $gtime ld $coups $cond, cluster(caseidc)
	eststo: quietly reg gdem d_cow2-d_cow133 d_year* $gtime ld $coups $cond, cluster(cowcode)	
	eststo: quietly reg gdem d_gwfregcodec* d_year* $gtime ld $coups $cond, cluster(gwfregcodec)
	eststo: quietly reg gdem d_twocowdec* d_year* $gtime ld $coups $cond, cluster(cowtwodecade)
	esttab, keep(ld cw* pcw*)	
	
	
	
	
	% Tabs	
	
	tab pt_anycoupS if gwf_fail!=.
	tab pt_anycoupS gdict if gwf_fail!=.

	
	tab gdem coupMS, column
	tab gdem coupMS if pcw==0, column
	tab gdem coupMS if pcw==1, column

	tab gdem coupMS if gdict==0, column
	tab gdem coupMA, column
	tab gdem coupMA if gdict==0, column
	tab gdem coupMS5, column
	tab gdem coupMS5 if gdict==0, column
	
	set scheme s1color
	graph bar gdem if gwf_fail!=., over(coupMS) by(pcw)
	graph bar gdem if gdict==0, over(coupMS) by(pcw)
	
	
	
	
	% Figures

	global coups "cwcoupMS pcwcoupMS"	
	quietly reg gdem d_case* d_year* $gtime ld $coups $cond, cluster(caseid)
	est store fe1
	quietly reg gdem dd_case* d_year* $gtime ld $coups $cond, cluster(caseidd)	
	est store fe2
	quietly reg gdem dc_case* d_year* $gtime ld $coups $cond, cluster(caseidc)
	est store fe3
	quietly reg gdem d_cow2-d_cow133 d_year* $gtime ld $coups $cond, cluster(cowcode)
	est store fe4
	quietly reg gdem d_gwfregcodec* d_year* $gtime ld $coups $cond, cluster(gwfregcodec)
	est store fe5
	quietly reg gdem d_twocowdec* d_year* $gtime ld $coups $cond, cluster(cowtwodecade)
	est store fe6
	
	global coups "cwcoupMA pcwcoupMA"	
	quietly reg gdem d_case* d_year* $gtime ld $coups $cond, cluster(caseid)
	est store fe7
	quietly reg gdem dd_case* d_year* $gtime ld $coups $cond, cluster(caseidd)	
	est store fe8
	quietly reg gdem dc_case* d_year* $gtime ld $coups $cond, cluster(caseidc)
	est store fe9
	quietly reg gdem d_cow2-d_cow133 d_year* $gtime ld $coups $cond, cluster(cowcode)
	est store fe10
	quietly reg gdem d_gwfregcodec* d_year* $gtime ld $coups $cond, cluster(gwfregcodec)
	est store fe11
	quietly reg gdem d_twocowdec* d_year* $gtime ld $coups $cond, cluster(cowtwodecade)
	est store fe12
	

	set scheme s1color
	label var cwcoupMA "{bf:Cold War Coup}"
	label var pcwcoupMA "{bf:Post-CW Coup}"
	label var cwcoupMS "{bf:Cold War Coup}"
	label var pcwcoupMS "{bf:Post-CW Coup}"

	
	coefplot fe1, bylabel(Original) || fe2, bylabel(Regime FE Extended) || fe3, bylabel(Regime FE Combined) || fe4, bylabel(Country FE) || fe5, bylabel(Country-Regime FE) || fe6, bylabel(Country-Two Decade FE) ||, drop(_cons gtime* d_year* d_case* d* ld) xline(0, lpattern(dash)) grid(glcolor(gs15)) mfcolor(white) levels (95 90) ciopts(lwidth(*1 *3)) ysize(2) xsize(3.5)  mlabel format(%9.2f) mlabposition(4) mlabgap(*1) saving (t1, replace) 
	
	coefplot fe7, bylabel(Original) || fe8, bylabel(Regime FE Extended) || fe9, bylabel(Regime FE Combined) || fe10, bylabel(Country FE) || fe11, bylabel(Country-Regime FE) || fe12, bylabel(Country-Two Decade FE) ||, drop(_cons gtime* d_year* d_case* d* ld) xline(0, lpattern(dash)) grid(glcolor(gs15)) mfcolor(white) levels (95 90) ciopts(lwidth(*1 *3)) ysize(2) xsize(3.5)  mlabel format(%9.2f) mlabposition(4) mlabgap(*1) saving (t2, replace) 

	
	global coups "cwcoupMS5 pcwcoupMS5"	
	quietly reg gdem d_case* d_year* $gtime ld $coups $cond, cluster(caseid)
	est store fe13
	quietly reg gdem dfived_case* d_year* $gtime ld $coups $cond, cluster(caseidfived)	
	est store fe14
	quietly reg gdem dc_case* d_year* $gtime ld $coups $cond, cluster(caseidc)
	est store fe15
	quietly reg gdem d_cow2-d_cow133 d_year* $gtime ld $coups $cond, cluster(cowcode)
	est store fe16
	quietly reg gdem d_gwfregcodec* d_year* $gtime ld $coups $cond, cluster(gwfregcodec)
	est store fe17
	quietly reg gdem d_twocowdec* d_year* $gtime ld $coups $cond, cluster(cowtwodecade)
	est store fe18
	
	global coups "cwcoupMA5 pcwcoupMA5"	
	quietly reg gdem d_case* d_year* $gtime ld $coups $cond, cluster(caseid)
	est store fe19
	quietly reg gdem dfived_case* d_year* $gtime ld $coups $cond, cluster(caseidfived)	
	est store fe20
	quietly reg gdem dc_case* d_year* $gtime ld $coups $cond, cluster(caseidc)
	est store fe21
	quietly reg gdem d_cow2-d_cow133 d_year* $gtime ld $coups $cond, cluster(cowcode)
	est store fe22
	quietly reg gdem d_gwfregcodec* d_year* $gtime ld $coups $cond, cluster(gwfregcodec)
	est store fe23
	quietly reg gdem d_twocowdec* d_year* $gtime ld $coups $cond, cluster(cowtwodecade)
	est store fe24

	set scheme s1color
	label var cwcoupMA5 "{bf:Cold War Coup}"
	label var pcwcoupMA5 "{bf:Post-CW Coup}"
	label var cwcoupMS5 "{bf:Cold War Coup}"
	label var pcwcoupMS5 "{bf:Post-CW Coup}"
        coefplot fe13, bylabel(Original) || fe14, bylabel(Regime FE Extended) || fe15, bylabel(Regime FE Combined) || fe16, bylabel(Country FE) || fe17, bylabel(Country-Regime FE) || fe18, bylabel(Country-Two Decade FE) ||, drop(_cons gtime* d_year* d_case* d* ld) xline(0, lpattern(dash)) grid(glcolor(gs15)) mfcolor(white) levels (95 90) ciopts(lwidth(*1 *3)) ysize(2) xsize(3.5)  mlabel format(%9.2f) mlabposition(4) mlabgap(*1) saving (t3, replace) 	
	coefplot fe19, bylabel(Original) || fe20, bylabel(Regime FE Extended) || fe21, bylabel(Regime FE Combined) || fe22, bylabel(Country FE) || fe23, bylabel(Country-Regime FE) || fe24, bylabel(Country-Two Decade FE) ||, drop(_cons gtime* d_year* d_case* d* ld) xline(0, lpattern(dash)) grid(glcolor(gs15)) mfcolor(white) levels (95 90) ciopts(lwidth(*1 *3)) ysize(2) xsize(3.5)  mlabel format(%9.2f) mlabposition(4) mlabgap(*1) saving (t4, replace) 

	
	global coups "cwcoupMS_nodem pcwcoupMS_nodem"	
	quietly reg gdem d_case* d_year* $gtime ld $coups $cond, cluster(caseid)
	est store fe25
	quietly reg gdem dd_case* d_year* $gtime ld $coups $cond, cluster(caseidd)	
	est store fe26
	quietly reg gdem dc_case* d_year* $gtime ld $coups $cond, cluster(caseidc)
	est store fe27
	quietly reg gdem d_cow2-d_cow133 d_year* $gtime ld $coups $cond, cluster(cowcode)
	est store fe28
	quietly reg gdem d_gwfregcodec* d_year* $gtime ld $coups $cond, cluster(gwfregcodec)
	est store fe29
	quietly reg gdem d_twocowdec* d_year* $gtime ld $coups $cond, cluster(cowtwodecade)
	est store fe30
	
	global coups "cwcoupMA_nodem pcwcoupMA_nodem"	
	quietly reg gdem d_case* d_year* $gtime ld $coups $cond, cluster(caseid)
	est store fe31
	quietly reg gdem dd_case* d_year* $gtime ld $coups $cond, cluster(caseidd)	
	est store fe32
	quietly reg gdem dc_case* d_year* $gtime ld $coups $cond, cluster(caseidc)
	est store fe33
	quietly reg gdem d_cow2-d_cow133 d_year* $gtime ld $coups $cond, cluster(cowcode)
	est store fe34
	quietly reg gdem d_gwfregcodec* d_year* $gtime ld $coups $cond, cluster(gwfregcodec)
	est store fe35
	quietly reg gdem d_twocowdec* d_year* $gtime ld $coups $cond, cluster(cowtwodecade)
	est store fe36

	label var cwcoupMA_nodem "{bf:Cold War Coup}"
	label var pcwcoupMA_nodem "{bf:Post-CW Coup}"
	label var cwcoupMS_nodem "{bf:Cold War Coup}"
	label var pcwcoupMS_nodem "{bf:Post-CW Coup}"
	coefplot fe25, bylabel(Original) || fe26, bylabel(Regime FE Extended) || fe27, bylabel(Regime FE Combined) || fe28, bylabel(Country FE) || fe29, bylabel(Country-Regime FE) || fe30, bylabel(Country-Two Decade FE) ||, drop(_cons gtime* d_year* d_case* d* ld) xline(0, lpattern(dash)) grid(glcolor(gs15)) mfcolor(white) levels (95 90) ciopts(lwidth(*1 *3)) ysize(2) xsize(3.5)  mlabel format(%9.2f) mlabposition(4) mlabgap(*1) saving (t5, replace) 	
	coefplot fe31, bylabel(Original) || fe32, bylabel(Regime FE Extended) || fe33, bylabel(Regime FE Combined) || fe34, bylabel(Country FE) || fe35, bylabel(Country-Regime FE) || fe36, bylabel(Country-Two Decade FE) ||, drop(_cons gtime* d_year* d_case* d* ld) xline(0, lpattern(dash)) grid(glcolor(gs15)) mfcolor(white) levels (95 90) ciopts(lwidth(*1 *3)) ysize(2) xsize(3.5)  mlabel format(%9.2f) mlabposition(4) mlabgap(*1) saving (t6, replace) 
	
	

	
	