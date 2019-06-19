

clear all
set matsize 2000
global path = "H:\DNB\met Rick Dutch FDI\REStat replication" 
*global path = "[a path]\REStat replication\" 

log using "$path\output", replace

version
update 

run "$path\spatreg2.ado"

capture noisily ssc inst vincenty
capture noisily ssc inst subsave
capture noisily net inst http://www.stata.com/stb/stb60/sg162
capture noisily net inst http://www.stata.com/users/vwiggins/grc1leg
capture noisily ssc inst pescadf
capture noisily net inst http://www.ats.ucla.edu/stat/stata/ado/analysis/hilo
capture noisily net inst http://www.stata-journal.com/software/sj5-4/dm88_1

capture noisily which spatreg2
capture noisily which vincenty
capture noisily which subsave
capture noisily which spatwmat
capture noisily which grc1leg
capture noisily which pescadf
capture noisily which hilo
capture noisily which renvars

use "$path\data.dta"


// create resource variables 
	egen restotdum= rowtotal(bauxite copper lead nickel phosphate tin zinc gold silver ironore hardcoal browncoal oil naturalgas)
	replace restotdum=1 if restotdum>0 & restotdum!=.
	egen restotval= rowtotal(bauxite copper lead nickel phosphate tin zinc gold silver ironore hardcoal browncoal oil naturalgas)
	label var restotdum "Reserves dummy, total (WB2000)"
	label var restotval "Reserves value, total (WB2000)"
	gen lnrestotval=ln(restotval)
	label var lnrestotval "log Reserves value, total (WB2000)"

	egen resnotendum= rowtotal(bauxite copper lead nickel phosphate tin zinc gold silver ironore)
	egen resnotenval= rowtotal(bauxite copper lead nickel phosphate tin zinc gold silver ironore)
	replace resnotendum=1 if resnotendum>0 & resnotendum!=.
	label var resnotendum "Reserves dummy, total net of oil, gas & coal (WB2000)"
	label var resnotenval "Reserves value, total net of oil, gas & coal (WB2000)"
	gen lnresnotenval=ln(resnotenval)
	label var lnresnotenval "log Reserves value, total net of oil, gas & coal (WB2000)"

	egen resendum= rowtotal(hardcoal browncoal oil naturalgas)
	replace resendum=1 if resendum>0 &resendum!=.
	label var resendum "Reserves dummy, oil, gas & coal (WB2000)"
	egen resenval= rowtotal(hardcoal browncoal oil naturalgas)
	label var resenval "Reserves value, oil, gas & coal (WB2000)"
	gen lnresenval=ln(resenval)
	label var lnresenval "log Reserves value, oil, gas & coal (WB2000)"

	egen resenbpval=rowtotal(oilres gasres coalres)
	label var resenbpval "Oil, gas & coal reserve BTU (BP/EIA, rowtotal)"
	gen lnresenbpval=ln(resenbpval)
	label var lnresenbpval "log Oil, gas & coal reserve BTU (BP/EIA, rowtotal)"

	sort idcode year
	qui foreach var of varlist resendum restotdum resnotendum resenbpval restotval resenval resnotenval lnresenbpval lnrestotval lnresenval lnresnotenval {
		gen l1`var' =l.`var'
	}

	label var l1restotdum "Total resource dummy (t-1)"
	label var l1resendum "Hydrocarbon resource dummy (t-1)"
	label var l1resnotendum "Other mineral resource dummy (t-1)"
	label var l1lnresenval "ln Hydrocarbon resource rents (t-1)" 
	label var l1lnresnotenval "ln Other mineral resource rents (t-1)"
	label var l1lnresenbpval "ln Hydrocarbon reserves in BTU (t-1)"
	label var oilprice_usd2008 "Oil Price (constant 2008 USD)"

// FTA with Netherlands
	gen ftaned=0
	label var ftaned "FTA with Netherlands, Baier Bergstrand JIE 2007"

	*EU & EFTA
	replace ftaned=1 if year>=1958 & wbcode=="BEL"
	replace ftaned=1 if year>=1958 & wbcode=="LUX"
	replace ftaned=1 if year>=1958 & wbcode=="FRA"
	replace ftaned=1 if year>=1958 & wbcode=="ITA"
	replace ftaned=1 if year>=1958 & wbcode=="DEU"
	replace ftaned=1 if year>=1960 & wbcode=="DNK"
	replace ftaned=1 if year>=1973 & wbcode=="IRL"
	replace ftaned=1 if year>=1960 & wbcode=="GBR"
	replace ftaned=1 if year>=1981 & wbcode=="GRC"
	replace ftaned=1 if year>=1960 & wbcode=="PRT"
	replace ftaned=1 if year>=1986 & wbcode=="ESP"
	replace ftaned=1 if year>=1960 & wbcode=="AUT"
	replace ftaned=1 if year>=1986 & wbcode=="FIN"
	replace ftaned=1 if year>=1960 & wbcode=="SWE"
	replace ftaned=1 if year>=1960 & wbcode=="NOR"
	replace ftaned=1 if year>=1960 & wbcode=="CHE"

	replace ftaned=1 if year>=1993 & wbcode=="ISR"
	replace ftaned=1 if year>=1993 & wbcode=="BGR"
	replace ftaned=1 if year>=1994 & wbcode=="HUN"
	replace ftaned=1 if year>=1994 & wbcode=="POL"
	replace ftaned=1 if year>=1993 & wbcode=="ROM"

	replace ftaned=1 if year>=2000 & wbcode=="MEX"
	label var ftaned "FTA with Netherlands"	

// real exchange rate with NL
	gen temp=pwt_p if wbcode=="NLD"
	bys t: egen pwt_pNL= max(temp)
	drop temp
	gen rernlgdp = pwt_p/pwt_pNL
	drop pwt_pNL
	label var rernlgdp "Real exchange rate with NL based on GDP price level



// Figure 1

		preserve
		sort t
		by t: egen totaloutres =total(fdires/1000)
		label var totaloutres "Total Outward Resource FDI"
		by t: egen totaloutnores =total(fdinores/1000)
		label var totaloutnores "Total Outward Non-Resource FDI"
		#delimit ;
		twoway 	(line totaloutres t, lpattern(dash) lcolor(black) lwidth(medthick)) 
				(line totaloutnores t, lpattern(dot) lcolor(black) lwidth(medthick)) 
				(line gdp t, lpattern(solid) lcolor(black) lwidth(medthick))
				if country=="Netherlands" & t>=1984
				, legend(cols(1) label(3 "GDP, The Netherlands"))
				xtitle(Year) ytitle("$ bn, 2000")
				;
		graph save "$path\figure1" , asis replace ;
		restore;
		# delimit cr


// Table 1

		table region year if (year==1984 | year==2002) & fdires>0 , c(sum fdires ) format(%9.0f) row

		table region year if (year==1984 | year==2002) & fdinores>0 , c(sum fdinores ) format(%9.0f) row



// Tables 2 to 4

		global lhs="lnfdinores"
		global extra= ""
		global clus =""

		global rhs1 ="ln_poptot   lnhumanav   ln_dist  trend llngdppc lngdp_smp  rernlgdp govshare  "
		global w=1
		global ldv= "llnfdinores"


		*** panel unit root tests
	preserve
		qui reg $lhs $rhs1  l1lnresenval
		keep if e(sample)
		tsreport, report panel list
			drop if idcode==15
			drop if idcode==17 & t>=2001
			drop if idcode==24 & t<1987
			drop if idcode==33
			drop if idcode==88
			drop if idcode==102 & t>=2002
			drop if idcode==131 & t<1991
			drop if idcode==158 & t>=1998
			drop if idcode==203 & t<1990

		sort idcode 
		by idcode: egen x = count(t)
		tab x
			drop if x<=5
		sort idcode year

		qui do "$path\weight matrix calculation rowst.do"
		subsave dij* using "$path\w.dta", replace
		spatwmat using "$path\w.dta", name(w)
		matrix eigenvalues re im = w
		matrix e = re'
		mkmat $lhs, mat(y)
		matrix yw=w*y
		svmat yw

// Table 3(a)

		spatreg2 $lhs  $rhs1  l1lnresenval , robust w(w) e(e) model(lag)
		mat res=e(resid)
		svmat res, n(u)

		gen cadfvar=""
		gen cadfz0=.
		gen cadfp0=.
		gen cadfz1=.
		gen cadfp1=.

// Table 2
		** in levels
		local i=1
		qui foreach var of varlist $lhs  $rhs1 l1lnresenval yw1 {
		replace cadfvar="`var'" in `i'
		pescadf `var' , lags(0)
		replace cadfz0=r(Ztbar) in `i'
		replace cadfp0=r(pval) in `i'
		pescadf `var' , lags(1)
		replace cadfz1=r(Ztbar) in `i'
		replace cadfp1=r(pval) in `i'
		local i=`i'+1
		}
		list cadf* if cadfvar!="", clean

		** in levels with a linear trend
		local i=1
		qui foreach var of varlist $lhs $ldv $rhs1 l1lnresenval yw1 {
		replace cadfvar="`var'" in `i'
		pescadf `var' , lags(0) trend
		replace cadfz0=r(Ztbar) in `i'
		replace cadfp0=r(pval) in `i'
		pescadf `var' , lags(1) trend
		replace cadfz1=r(Ztbar) in `i'
		replace cadfp1=r(pval) in `i'
		local i=`i'+1
		}
		list cadf* if cadfvar!="", clean

		** in first difference
		local i=1
		qui foreach var of varlist $lhs $ldv $rhs1 l1lnresenval  yw1 {
		replace cadfvar="`var'" in `i'
		pescadf d.`var' , lags(0)
		replace cadfz0=r(Ztbar) in `i'
		replace cadfp0=r(pval) in `i'
		pescadf d.`var' , lags(1)
		replace cadfz1=r(Ztbar) in `i'
		replace cadfp1=r(pval) in `i'
		local i=`i'+1
		}
		list cadf* if cadfvar!="", clean

// Table 4

		xtunitroot ips u1, lags(0)
		xtunitroot ips u1, lags(1)
		xtunitroot llc u1 if x==19, lags(0) nocons
		xtunitroot llc u1 if x==19, lags(1) nocons

		
		
// Table 3(b)

		*** DOLS, or D-SAR
		sort idcode year
		foreach var of varlist ln_poptot lnhumanav  llngdppc lngdp_smp  rernlgdp govshare  l1lnresenval yw1 { 
		gen d1l1`var'=dl.`var'
		gen d1f1`var'=df.`var'
		}


		qui reg $lhs $rhs1  l1lnresenval d1l* d1f* yw1
		keep if e(sample)

		sort idcode year

		qui do "$path\weight matrix calculation rowst.do"
		subsave dij* using "$path\w.dta", replace
		spatwmat using "$path\w.dta", name(w)
		matrix eigenvalues re im = w
		matrix e = re'
		spatreg2 $lhs  $rhs1  l1lnresenval d1f1* d1l1*, robust w(w) e(e) model(lag)
				
	restore


// Table 5

	preserve

		qui reg $lhs $rhs1 l1lnresenval
		keep if e(sample)

		qui do "$path\weight matrix calculation rowst.do"
		subsave dij* using "$path\w.dta", replace
		spatwmat using "$path\w.dta", name(w)
		matrix eigenvalues re im = w
		matrix e = re'
		mkmat $lhs, mat(y)
		matrix yw=w*y
		svmat yw
		sort idcode year
		foreach var of varlist ln_poptot lnhumanav  ln_dist trend llngdppc lngdp_smp  rernlgdp govshare  l1lnresenval yw1 { 
		gen d1`var'=d1.`var'
		gen l1`var'=l1.`var'
		} 
		gen d1$lhs=d1.$lhs
		gen l1$lhs=l1.$lhs
		gen d1l1$lhs=d1l1.$lhs

		qui reg d1lnfdinores d1ln_poptot   d1lnhumanav   d1llngdppc d1lngdp_smp  d1rernlgdp d1govshare d1l1lnresenval  l1lnfdinores l1ln_poptot   l1lnhumanav   l1ln_dist  l1trend l1llngdppc l1lngdp_smp  l1rernlgdp l1govshare l1l1lnresenval l1yw1 d1l1lnfdinores
		keep if e(sample)

		sort idcode year
		qui do "$path\weight matrix calculation rowst.do"
		subsave dij* using "$path\w.dta", replace
		spatwmat using "$path\w.dta", name(w)
		matrix eigenvalues re im = w
		matrix e = re'

		capture drop cid* fid*
			xi, pre(f) i.idcode
			xi, pre(c) i.idcode
			qui foreach var of varlist cid* {
			replace `var'=`var'*trend
			}

	// Table 5a
		spatreg2 d1lnfdinores d1ln_poptot   d1lnhumanav   d1llngdppc d1lngdp_smp  d1rernlgdp d1govshare d1l1lnresenval  l1lnfdinores l1ln_poptot   l1lnhumanav   l1ln_dist  l1trend l1llngdppc l1lngdp_smp  l1rernlgdp l1govshare l1l1lnresenval l1yw1 d1l1lnfdinores, robust w(w) e(e) model(lag)
	// Table 5b
		spatreg2 d1lnfdinores d1ln_poptot   d1lnhumanav   d1llngdppc d1lngdp_smp  d1rernlgdp d1govshare d1l1lnresenval  l1lnfdinores l1ln_poptot   l1lnhumanav   l1ln_dist  l1trend l1llngdppc l1lngdp_smp  l1rernlgdp l1govshare l1l1lnresenval l1yw1 d1l1lnfdinores, robust w(w) e(e) model(lag) vce(cluster idcode)
		drop  fidcode_72 fidcode_44
	// Table 5c
		spatreg2 d1lnfdinores d1ln_poptot   d1lnhumanav   d1llngdppc d1lngdp_smp  d1rernlgdp d1govshare d1l1lnresenval  l1lnfdinores l1ln_poptot   l1lnhumanav     l1trend l1llngdppc l1lngdp_smp  l1rernlgdp l1govshare l1l1lnresenval l1yw1 d1l1lnfdinores fid* cid*, robust w(w) e(e) model(lag)
	restore

// Table 6

	global lhs="lnfdinores"
	global clus =""
	global ldv= "llnfdinores"
	global rhs1 ="ln_poptot  openness  lnhumanav   ln_dist  trend  llngdppc lngdp_smp ftaned  rernlgdp govshare instm5i l1lnrestotval"

	do "$path\regression program.do"
	
	global rhs1 ="ln_poptot  openness  lnhumanav   ln_dist  trend  llngdppc lngdp_smp ftaned  rernlgdp govshare instm5i l1lnresenval l1lnresnotenval"
	do "$path\regression program.do"

	global rhs1 ="ln_poptot  lnhumanav   ln_dist  llngdppc lngdp_smp  rernlgdp govshare l1lnresenval l1lnresnotenval"
	do "$path\regression program.do"

	global rhs1 ="ln_poptot  lnhumanav   ln_dist  llngdppc lngdp_smp  rernlgdp govshare l1lnresenval "
	do "$path\regression program.do"

	global rhs1 ="ln_poptot  lnhumanav   ln_dist  llngdppc lngdp_smp  rernlgdp govshare l1lnresenbpval oilprice_usd2008 "
	do "$path\regression program.do"

	
// Table 7

		global lhs="lnfdinores"
		global rhs1 ="ln_poptot   lnhumanav   ln_dist  trend  llngdppc lngdp_smp  rernlgdp govshare  "
		global ldv= "llnfdinores"
		global sel = "openness  landlock "
	preserve
		gen s= .
		replace s =1 if fdinores!=0 & fdinores!=.
		replace s =0 if fdinores==0 
		qui probit s $rhs1 $sel l1restotdum, robust
		keep if e(sample)
		sort t idcode
		outsheet s $rhs1 $sel l1restotdum using "$path\matlab programs\mdata.txt" , replace comma
		sort t idcode
		qui do "$path\weight matrix calculation rowst.do"
		outsheet dij* using "$path\Matlab programs\W.txt", replace comma
		save "$path\temp.dta", replace
		set more on
		more 
		** run spatialprobit.m in matlab to create yhatar.txt, the predicted probabilities of the first stage (or use the file provided and continue)
		** Note: install Le Sage's spatial econometrics package first
		** spatialprobit.m uses sarp_g.m version 4 August 2009.
		
		clear all
		insheet using "$path\Matlab programs\yhatar.txt",  comma
		mkmat v1, mat(yhatar)
		use "$path\temp.dta", clear
		svmat yhatar, n(p)
		generate phi = (1/sqrt(2*_pi))*exp(-(p1^2/2))  /*standardize it*/
		generate capphi = normal(p1)
		generate invmills = phi/capphi
		label var invmills "Inverse Mill's ratio"
		qui reg $lhs $ldv $rhs1 $sel invmills l1lnresenval
		keep if e(sample)
		sort t idcode
		qui do "$path\weight matrix calculation rowst.do"
		subsave dij* using "$path\w.dta", replace
		spatwmat using "$path\w.dta", name(w)
		matrix eigenvalues re im = w
		matrix e = re'
		capture run "$path\spatreg2.ado"
		spatreg2 $lhs $ldv $rhs1 $sel l1lnresenval, robust w(w) e(e) model(lag)
		spatreg2 $lhs $ldv $rhs1  invmills 		l1lnresenval, robust w(w) e(e) model(lag)
		gen p12=p1^2
		gen p13=p1^3
		gen p14=p1^4
		bootstrap, reps(200): spatreg2 $lhs $ldv $rhs1  invmills p1 p12 p13	l1lnresenval	, robust w(w) e(e) model(lag)

	restore


// Table 8

	global lhs="lnfdires"
	global clus =""
	global ldv= "llnfdires"
	global rhs1 ="ln_poptot     lnhumanav   ln_dist   llngdppc lngdp_smp    rernlgdp govshare instm5i  l1lnresenval l1lnresnotenval "
	do "$path\regression program.do"

	global rhs1 ="ln_poptot     lnhumanav   ln_dist   llngdppc     rernlgdp   instm5i  l1lnresenval  "
	reg $lhs $ldv $rhs1, robust 

	global rhs1 ="ln_poptot    lnhumanav   ln_dist   llngdppc lngdp_smp    rernlgdp   instm5i  l1lnresenbpval oilprice_usd2008 "
	reg $lhs $ldv $rhs1, robust 

// Figure 2 & 3

	do "$path\simulation.do"

// Table A2

		global rhs1 ="ln_poptot   lnhumanav   ln_dist  trend  llngdppc lngdp_smp  rernlgdp govshare  "
		global sel = "openness  landlock "
	preserve
		gen s= .
		replace s =1 if fdinores!=0 & fdinores!=.
		replace s =0 if fdinores==0 
		qui probit s $rhs1 $sel l1restotdum, robust

		sum lnfdinores lnfdires ln_poptot openness lnhumanav   ln_dist  llngdppc lngdp_smp ftaned gattwtodum landlock l1restotdum l1resendum l1resnotendum l1lnresenval l1lnresnotenval l1lnresenbpval oilprice_usd2008 instm5i rernlgdp govshare if e(sample)
	restore



// PPML estimates

	gen fdinores0pos = .
	replace fdinores0pos=fdinores if lnfdinores!=.
	replace fdinores0pos=0 if fdinores!=. & lnfdinores==.
	global rhs1 ="ln_poptot    lnhumanav   ln_dist trend llngdppc lngdp_smp   rernlgdp govshare  "
	glm fdinores0pos $rhs1 l1lnresenval ,robust family(poisson) link(log) irls mu(fdinores0pos)
	global rhs1 ="ln_poptot  openness  lnhumanav   ln_dist  trend  llngdppc lngdp_smp ftaned gattwtodum landlock rernlgdp govshare instm5i l1restotdum"
	glm fdinores0pos $rhs1 ,robust family(poisson) link(log) irls mu(fdinores0pos)





log close



