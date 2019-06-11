
* **************************************************************************************************
*
* Replication file for "The political economy of labor market deregulation during IMF interventions"
* --------------------------------------------------------------------------------------------------
*
* Bernhard Reinsberg, Thomas Stubbs, Alexander Kentikelenis, and Lawrence King
* Contact: bernhard.reinsberg@glasgow.ac.uk
*
* **************************************************************************************************

/* 	Table of contents
	* Data preparation	
	* Figures
	* Unconditional effects
	* Conditional effects  
	* Supplemental regressions
	* Descriptive statistics
*/


* Data preparation
* *****************************************

  use "GINI-2018-1482.dta", clear
  xtset cid year 

* Past IMF programs  
  g IMFCum=0
  forvalues i=1980/2014{
    g cum=0
	replace cum=IMFnn if year<=`i'
    egen Cum=sum(cum), by(cid)
	replace IMFCum=Cum if year==`i'
	drop cum Cum
  }  
  lab var IMFCum "Cumulative number of years under IMF program"
  
* Logged variables
  g lngdppc=ln(gdppc_WDI)
  g lnpop=ln(unna_pop)
  g lntrade=ln(trade_WDI)
  g lnfdi=ln(fdi_gdp_WDI)
  replace lnfdi=-ln(abs(fdi_gdp_WDI)) if fdi_gdp<0
  
  egen ilofc=rowmax(fc087 fc098)
  lab var ilofc "ILO Ratification"
  g leftexec=(dpi_erlc_QOG==3 | dpi_gprlc1_QOG==3)
  g commonlaw=(lp_legor==1)
  egen domestic2=mean(domestic2_BANKS), by(cid)
  
* Instrumental-variable components  
  egen meanBA2LAB=mean(BA2LAB), by(cid)
  forvalues l=0/3{
	gen iv`l'BA2LAB=l`l'.nUnder*meanBA2LAB
	lab var iv`l'BA2LAB "Compound IV lag `l'"
	}
    
* Fixed effects 
  qui xi:reg idx i.cid i.regid i.incid i.year 
  
  cmp setup 
  set matsize 800
  vers 14.1
 
    
* *************************************************************
* Figures
* *************************************************************

* Figure 1: The differential impact of IMF program exposure on labor rights
  preserve
  
  egen i=sum(IMFnn), by(cid)
  g ig1=(i>0)
  qui su i if i>0, d
  g ig2=(i>`r(p50)')
  collapse (mean)idx *_idx idx_*, by(ig1 ig2 year)
  drop if ig1==0	
  reshape wide *idx*, i(year) j(ig2)
  local j=0
  foreach var in idx_ilr idx_clr{
    local j=`j'+1
    g diff`j'=`var'1-`var'0
  }  
  twoway (line diff1 diff2 year), yline(0) scheme(s1mono)
  graph export "Figure_1.png", width(2000) replace 
  
  restore 

  
* Figure 2: The differential impact of IMF labor conditions exposure on labor rights
  preserve
  egen lb1=sum(BA1LAB), by(cid)
  egen imf1=sum(IMFnn), by(cid)
  g imflab=2
  replace imflab=1 if imf1>0 & lb1>0
  replace imflab=0 if imf1>0 & lb1==0
  collapse (mean)idx *_idx idx_*, by(imflab year)
  reshape wide idx *_idx idx_*, i(year) j(imflab)
  order *idx* fe_* wt_* dm_* er_* ia_*
  local j=0
  foreach var in idx_ilr idx_clr{
    local j=`j'+1
    g diff`j'=`var'1-`var'0
  }
  
  twoway (line diff1 diff2 year) if year>=1991 & year<=2014, yline(0 5) scheme(s1mono) 
  graph export "Figure_2.png", width(2000) replace 
  
  restore 


* Unconditional effects 
* *************************************************************

forvalues l=0/3{

  mat Mstat`l'=J(5,3,0)

  local k=`l'+1
  di "lag `l'..."
  global X  l`l'.lngdppc l`l'.lnpop l`l'.lntrade l`l'.lnfdi l`l'.p_polity2 l`l'.leftexec l`l'.ilofc l`l'.civwar_UCDP
  global Z  l`k'.IMFCum l`k'.nUnder l`k'.s_unga3g7 l`k'.leftexec commonlaw _Iregid* _Iyear*
  
  local m=1

  foreach y in idx idx_ilr idx_clr{
  
	qui cmp (`y'=l`l'.BA2LAB l`l'.IMFnn $X _Icid* _Iyear*) (L`l'BA2LAB: L`l'.BA2LAB=iv`l'BA2LAB $X _Icid* _Iyear*) (l`l'.IMFnn=$Z), indicators($cmp_cont $cmp_cont $cmp_probit) cl(cid) iterate(100)
	est store a`l'`y'
	mat B=e(b)
	mat S=e(V)
	qui test [L`l'BA2LAB]iv`l'BA2LAB
	mat Mstat`l'[3,`m']=r(chi2)
    mat Mstat`l'[5,`m']=e(N1)
	qui xtreg `y' iv`l'BA2LAB l`l'.IMFnn $X _Iyear* if e(sample), fe
	mat Mstat`l'[1,`m']=e(r2_w)
	qui xtreg l`l'.BA2LAB iv`l'BA2LAB $X _Iyear* if e(sample), fe
	mat Mstat`l'[2,`m']=e(r2_w)
	qui probit l`l'.IMFnn $Z if e(sample)
	mat Mstat`l'[4,`m']=e(r2_p)
	
	local m=`m'+1
	}	
}


* Table 1
  estout a1*, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) drop(_I* _cons) order(*LAB* *IMF*) keep()
  di "Table 1: Diagnostics:"
  mat li Mstat1

      
  
* Conditional effects
* *************************************************************
  
foreach z in pop_urb domestic2{

  qui su `z', d
  qui g zhigh=`z'>`r(p50)'
  qui g ziv=(idx!=.)
  qui g zout=(idx!=.)
  
  mat M`z'stat=J(5,6,0)
  

forvalues a=0/1{

  replace zout=(zhigh==`a')

  local l=1
  local k=`l'+1
  global X  l`l'.lngdppc l`l'.lnpop l`l'.lntrade l`l'.lnfdi l`l'.p_polity2 l`l'.leftexec l`l'.ilofc l`l'.civwar_UCDP
  global Z  l`k'.IMFCum l`k'.nUnder l`k'.s_unga3g7 l`k'.leftexec commonlaw _Iregid* _Iyear*

  local m=1
  
  foreach y in idx idx_ilr idx_clr{
  
    di "Outcome `y' at `z'=`a'..."
	qui cmp (`y'=L`l'.BA2LAB l`l'.IMFnn $X _Icid* _Iyear*) (L`l'BA2LAB: L`l'.BA2LAB=iv`l'BA2LAB $X _Icid* _Iyear*) (l`l'.IMFnn=$Z) if zhigh==`a', indicators(zout ziv ziv) cl(cid) iterate(100)
	est store b`z'`y'`a'
	qui test [L`l'BA2LAB]iv`l'BA2LAB
	mat M`z'stat[3,3*`a'+`m']=r(chi2)
	mat M`z'stat[5,3*`a'+`m']=e(N1)
	qui xtreg `y' iv`l'BA2LAB l`l'.IMFnn $X _Iyear* if zout, fe
	mat M`z'stat[1,3*`a'+`m']=e(r2_w)
	qui xtreg l`l'.BA2LAB iv`l'BA2LAB $X _Iyear* if ziv, fe
	mat M`z'stat[2,3*`a'+`m']=e(r2_w)
	qui probit l`l'.IMFnn $Z if ziv 
	mat M`z'stat[4,3*`a'+`m']=e(r2_p)
	
	local m=`m'+1
	}	
  }
  drop zhigh
  drop ziv zout
}

* Table 2
  estout bpop_urb*, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) drop(_I* _cons) 
  mat li Mpop_urbstat
  
* Table 3
  estout bdomestic2*, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) drop(_I* _cons)
  mat li Mdomestic2stat

  

* Supplemental analyses
* *************************************************************

* Aggregate effect of IMF programs

  forvalues l=0/3{

  mat Mstatimf`l'=J(3,3,0)

  local k=`l'+1
  di "lag `l'..."
  global X  l`l'.lngdppc l`l'.lnpop l`l'.lntrade l`l'.lnfdi l`l'.p_polity2 l`l'.leftexec l`l'.ilofc l`l'.civwar_UCDP
  global Z  l`k'.IMFCum l`k'.nUnder l`k'.s_unga3g7 l`k'.leftexec commonlaw _Iregid* _Iyear*
  
  local m=1

  foreach y in idx idx_ilr idx_clr{
  
    qui treatreg `y' l`l'.IMFnn $X _Icid* _Iyear*, treat(l`l'.IMFnn=$Z) twostep hazard(imr)
	est store imf`l'`y'
	drop imr
	mat B=e(b)
	mat S=e(V)
	qui xtreg `y' l`l'.IMFnn $X _Iyear* if e(sample), fe
	mat Mstatimf`l'[1,`m']=e(r2_w)
	mat Mstatimf`l'[3,`m']=e(N)
	qui probit l`l'.IMFnn $Z if e(sample)
	mat Mstatimf`l'[2,`m']=e(r2_p)
	
	local m=`m'+1
	}	
  }
  
* Table A1
  estout imf1*, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) drop(_I* _cons *lambda*)
  di "Table A1: Diagnostics:"
  mat li Mstatimf1



* Different control variables (Davies & Vadlamannati 2013)

  g fhindex=14-fh_cl-fh_pr
  mat DV=J(6,8,0)
  mat DVDiag=J(5,8,0)

  forvalues l=0/3{  
  
  local k=`l'+1
  global X  l`l'.lngdppc l`l'.gdp_growth l`l'.lntrade l`l'.va_ind_gdp l`l'.lfpr l`l'.fhindex l`l'.leftexec l`l'.ilofc 
  global Z  l`k'.IMFCum l`k'.nUnder l`k'.s_unga3g7 l`k'.fhindex l`k'.leftexec commonlaw _Iregid* _Iyear*
  
  local m=0
  
  foreach y in idx_ilr idx_clr{
    di "Outcome `y', lag `l'"
  
    * Aggregate effect
    qui treatreg `y' l`l'.IMFnn $X _Icid* _Iyear*, treat(l`l'.IMFnn=$Z) twostep hazard(imr)
	mat B=e(b)
	mat S=e(V)
	drop imr 
	mat DV[1,4*`m'+`l'+1]=B[1,1]
	mat DV[2,4*`m'+`l'+1]=sqrt(S[1,1])
	qui xtreg `y' l`l'.IMFnn $X _Iyear*, fe
	mat DVDiag[1,4*`m'+`l'+1]=e(N)
	mat DVDiag[2,4*`m'+`l'+1]=e(r2_w)
	qui probit l`l'.IMFnn $Z
	mat DVDiag[3,4*`m'+`l'+1]=e(r2_p)
	
	* Labor conditions
	qui cmp (`y'=l`l'.BA2LAB l`l'.IMFnn $X _Icid* _Iyear*) (l`l'BA2LAB: l`l'.BA2LAB=iv`l'BA2LAB _Icid* _Iyear*) (l`l'.IMFnn=$Z), indicators($cmp_cont $cmp_cont $cmp_probit) cl(cid) iterate(100)
	mat B=e(b)
	mat S=e(V)
	mat DV[3,4*`m'+`l'+1]=B[1,1]
	mat DV[4,4*`m'+`l'+1]=sqrt(S[1,1])
	mat DV[5,4*`m'+`l'+1]=B[1,2]
	mat DV[6,4*`m'+`l'+1]=sqrt(S[2,2])
	qui test [l`l'BA2LAB]iv`l'BA2LAB
	mat DVDiag[5,4*`m'+`l'+1]=r(chi2)
	qui xtreg `y' iv`l'BA2LAB l`l'.IMFnn $X _Iyear*, fe
	mat DVDiag[4,4*`m'+`l'+1]=e(r2_w)
 	local m=`m'+1
    }
  }
    
* Table A2
  di "Coefficient matrix (with standard errors in even lines):"
  mat li DV
  di "Diagnostics:"
  mat li DVDiag


  
* Extended control variables in the first stage

  local l=1
  local k=2
  
  global X  l`l'.lngdppc l`l'.lnpop l`l'.lntrade l`l'.lnfdi l`l'.p_polity2 l`l'.leftexec l`l'.ilofc l`l'.civwar_UCDP
  global Z2  l`k'.IMFCum l`k'.nUnder l`k'.s_unga3g7 l`k'.p_polity2 l`k'.leftexec l`k'.dpi_exelec l`k'.lngdppc l`k'.gdp_growth_WDI l`k'.reserves_WDI l`k'.cab_gdp commonlaw _Iregid* _Iyear*
  
  local m=0
  mat MZstat=J(5,6,0)

  foreach y in idx idx_ilr idx_clr{
    di "Outcome `y'..."
  
    * Aggregate effect
    qui treatreg `y' l`l'.IMFnn $X _Icid* _Iyear*, treat(l`l'.IMFnn=$Z2) twostep hazard(imr)
	est store MZ1`y'
	drop imr
	qui xtreg `y' l`l'.IMFnn $X _Iyear*, fe
	mat MZstat[1,2*`m'+1]=e(N)
	mat MZstat[2,2*`m'+1]=e(r2_w)
	qui probit l`l'.IMFnn $Z2 if e(sample)
	mat MZstat[3,2*`m'+1]=e(r2_p)
	mat MZstat[3,2*`m'+2]=e(r2_p)
	
	* Labor conditions
	qui cmp (`y'=l`l'.BA2LAB l`l'.IMFnn $X _Icid* _Iyear*) (l`l'BA2LAB: l`l'.BA2LAB=iv`l'BA2LAB $X _Icid* _Iyear*) (l`l'.IMFnn=$Z2), indicators($cmp_cont $cmp_cont $cmp_probit) cl(cid) iterate(100)
	est store MZ2`y'
	qui test [l`l'BA2LAB]iv`l'BA2LAB
	mat MZstat[5,2*`m'+2]=r(chi2)
	qui xtreg `y' iv`l'BA2LAB l`l'.IMFnn $X _Iyear* if e(sample), fe
	mat MZstat[2,2*`m'+2]=e(r2_w)
	mat MZstat[1,2*`m'+2]=e(N)
	qui xtreg l`l'.BA2LAB iv`l'BA2LAB _Iyear*, fe 
	mat MZstat[4,2*`m'+2]=e(r2_w)

	local m=`m'+1
  }
    
* Table A3
  estout MZ1*, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) drop(_I* _cons *lambda*)
  estout MZ2*, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) drop(_I* _cons) 
  mat li MZstat
  
  
* Different instrumentation in first stage 
  
  mat VL=J(6,7,0)
  mat VLDiag=J(5,7,0)
 
  g vxCum=l2.IMFCum*l2.imf_liq
  global Z  l2.IMFCum l2.imf_liq vxCum l2.s_unga3g7 l2.leftexec commonlaw _Iregid* _Iyear*
  
  local m=1
  
  foreach y in idx_ilr idx_clr fe_idx wt_idx dm_idx er_idx ia_idx{
  
    * Aggregate effect
    qui treatreg `y' l.IMFnn $X _Icid* _Iyear*, treat(l.IMFnn=$Z) twostep hazard(imr)
    qui test [L_IMFnn]vxCum
    mat B=e(b)
    mat S=e(V)
	mat VL[1,`m']=B[1,1]
	mat VL[2,`m']=sqrt(S[1,1])
	drop imr
	qui xtreg `y' l.IMFnn $X _Iyear*, fe
	mat VLDiag[1,`m']=e(N)
	mat VLDiag[2,`m']=e(r2_w)
	qui probit l.IMFnn $Z if e(sample)
	mat VLDiag[3,`m']=e(r2_p)
	
	g vxBA2LAB=meanBA2LAB*l.imf_liq
	
	* Labor conditions
	qui cmp (`y'=l.BA2LAB l.IMFnn $X _Icid* _Iyear*) (lBA2LAB: l.BA2LAB=vxBA2LAB $X _Icid* _Iyear*) (l.IMFnn=$Z), indicators($cmp_cont $cmp_cont $cmp_probit) cl(cid) iterate(100)
	mat B=e(b)
	mat S=e(V)
	mat VL[3,`m']=B[1,1]
	mat VL[4,`m']=sqrt(S[1,1])
	mat VL[5,`m']=B[1,2]
	mat VL[6,`m']=sqrt(S[2,2])
	qui test [lBA2LAB]vxBA2LAB
	mat VLDiag[5,`m']=r(chi2)
	qui xtreg idx_ilr vxBA2LAB l.IMFnn $X _Iyear*, fe
	mat VLDiag[4,`m']=e(r2_w)
	drop vxBA2LAB
   
	local m=`m'+1
	}

* Table A4
  di "Coefficient matrix:"
  mat li VL
  di "Diagnostics:"
  mat li VLDiag  



* Assessing reverse causality

** Can conditions be predicted?
  foreach var in idx idx_ilr idx_clr{
    g l1`var'=l.`var'
  }
  qui reg BA2LAB l1idx iv0BA2LAB $X _Icid* _Iyear*, cl(cid)
  est store c11
  qui reg BA2LAB l1idx_ilr iv0BA2LAB $X _Icid* _Iyear*, cl(cid)
  est store c12
  qui reg BA2LAB l1idx_clr iv0BA2LAB $X _Icid* _Iyear*, cl(cid)
  est store c13

* Table A5
  estout c1*, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) stats(r2_a N, fmt(%7.2f %7.0f)) drop(_I* _cons) order(*idx*)   
    

** Are IMF countries the ones with higher labor rights? (t-tests)
  mat DIF=J(8,6,0)

  di "IMF observations"
  local m=0
  foreach y in idx fe_idx wt_idx dm_idx er_idx ia_idx{
  local m=`m'+1
  di "`y'"
  qui ttest `y', by(IMFnn) 
  mat DIF[1,`m']=`r(mu_2)'-`r(mu_1)'
  mat DIF[2,`m']=`r(p)'
  }

  di "Long exposure (>25%)"
  local m=0
  su IMFCum, d
  g long25=(IMFCum>`r(p25)')
  foreach y in idx fe_idx wt_idx dm_idx er_idx ia_idx{
  local m=`m'+1
  di "`y'"
  qui ttest `y', by(long25) 
  mat DIF[3,`m']=`r(mu_2)'-`r(mu_1)'
  mat DIF[4,`m']=`r(p)'
  }

  di "Long exposure (>50%)"
  su IMFCum, d
  g long50=(IMFCum>`r(p50)')
  local m=0
  foreach y in idx fe_idx wt_idx dm_idx er_idx ia_idx{
  di "`y'"
  local m=`m'+1
  qui ttest `y', by(long50) 
  mat DIF[5,`m']=`r(mu_2)'-`r(mu_1)'
  mat DIF[6,`m']=`r(p)'
  }

  di "Exposure to BA2LAB (>25%)"
  su BA2LAB if long25==1, d
  g long25lab=(BA2LAB>`r(p25)')
  local m=0  
  foreach y in idx fe_idx wt_idx dm_idx er_idx ia_idx{
  di "`y'"
  local m=`m'+1
  qui ttest `y' if long25==1, by(long25lab) 
  mat DIF[7,`m']=`r(mu_2)'-`r(mu_1)'
  mat DIF[8,`m']=`r(p)'
  }

  drop long*
  
* t-tests
  di "Odd line: Group mean differences for LRI, A, B, C, D, E, F"
  di "Even line: p-value (column 1 -- specifically)"
  mat li DIF

  
 
* Individual sub-indices of LRI

  mat M=J(6,5,0)
  mat Mstat=J(5,5,0)
  local m=1
  
  local l=1
  local k=2
  global X  l`l'.lngdppc l`l'.lnpop l`l'.lntrade l`l'.lnfdi l`l'.p_polity2 l`l'.leftexec l`l'.ilofc l`l'.civwar_UCDP
  global Z  l`k'.IMFCum l`k'.nUnder l`k'.s_unga3g7 l`k'.leftexec commonlaw _Iregid* _Iyear*
  
  foreach y in fe_idx wt_idx dm_idx er_idx ia_idx{
    di "`y'"
  
    * Aggregate effect
    qui treatreg `y' l`l'.IMFnn $X _Icid* _Iyear*, treat(l`l'.IMFnn=$Z) twostep hazard(imr)
	est store all1`y'
	drop imr
	mat B=e(b)
	mat S=e(V)
	mat M[1,`m']=B[1,1]
	mat M[2,`m']=sqrt(S[1,1])
	mat Mstat[1,`m']=e(N)
	qui xtreg `y' l`l'.IMFnn $X _Iyear*, fe
	mat Mstat[2,`m']=e(r2_w)
	qui probit l`l'.IMFnn $Z if e(sample)
	mat Mstat[3,`m']=e(r2_p)
	
	* Labor conditions
	qui cmp (`y'=l`l'.BA2LAB l`l'.IMFnn $X _Icid* _Iyear*) (l`l'BA2LAB: l`l'.BA2LAB=iv`l'BA2LAB $X _Icid* _Iyear*) (l`l'.IMFnn=$Z), indicators($cmp_cont $cmp_cont $cmp_probit) cl(cid) iterate(100)
	est store all2`y'
	mat B=e(b)
	mat S=e(V)
	mat M[3,`m']=B[1,1]
	mat M[4,`m']=sqrt(S[1,1])
	mat M[5,`m']=B[1,2]
	mat M[6,`m']=sqrt(S[2,2])
	qui test [l`l'BA2LAB]iv`l'BA2LAB
	mat Mstat[5,`m']=r(chi2)
	qui xtreg `y' iv`l'BA2LAB l`l'.IMFnn $X _Iyear*, fe
	mat Mstat[4,`m']=e(r2_w)

	local m=`m'+1
	}

* Table A6
  di "Coefficient matrix with standard errors in odd lines:"
  mat li M
  di "Diagnostics:"
  mat li Mstat
  

  
* Alternative outcomes
  mat ALT=J(6,5,0)
  mat ALTstat=J(4,5,0)
  local m=1

  local l=1
  local k=2
 
  global POLS  commonlaw _Iregid* _Iincid*
  global X  l`l'.lngdppc l`l'.lnpop l`l'.lntrade l`l'.lnfdi l`l'.p_polity2 l`l'.leftexec l`l'.ilofc l`l'.civwar_UCDP
  global Z  l`k'.IMFCum l`k'.nUnder l`k'.s_unga3g7 l`k'.fhindex l`k'.leftexec commonlaw _Iregid* _Iyear*

  ** CIRI outcomes (probit regression)
  qui cmp (worker2=l.IMFnn l.worker2 $X $POLS _Iyear*) (l.IMFnn=$Z), indicators($cmp_probit $cmp_probit) cl(cid) 
  est store altciri11
  mat B=e(b)
  mat S=e(V)
  mat ALT[1,1]=B[1,1]
  mat ALT[2,1]=sqrt(S[1,1])
  qui probit worker2 l.worker2 l`l'.IMFnn $X $POLS _Iyear*
  mat ALTstat[2,1]=e(r2_p)
  mat ALTstat[1,1]=e(N)
  qui probit l`l'.IMFnn $Z if e(sample)
  
  qui cmp (worker2=l.BA2LAB l.IMFnn l.worker2 $X $POLS _Iyear*) (lBA2LAB: l.BA2LAB=l.iv1BA2LAB $POLS $X _Iyear*) (l.IMFnn=$Z), indicators($cmp_probit $cmp_cont $cmp_probit) cl(cid) 
  est store altciri12
  mat B=e(b)
  mat S=e(V)
  mat ALT[3,1]=B[1,1]
  mat ALT[4,1]=sqrt(S[1,1])
  mat ALT[5,1]=B[1,2]
  mat ALT[6,1]=sqrt(S[2,2])
  qui test [lBA2LAB]l.iv1BA2LAB
  mat ALTstat[4,1]=r(chi2)
  qui probit worker2 l.worker2 l`l'.BA2LAB l`l'.IMFnn $X $POLS _Iyear*
  mat ALTstat[3,1]=e(r2_p)
  qui probit l`l'.IMFnn $Z if e(sample)
  
  g worker12=(worker==1 |worker==2)
  
  qui cmp (worker12=l.IMFnn l.worker12 $X $POLS _Iyear*) (l.IMFnn=$Z), indicators($cmp_probit $cmp_probit) cl(cid) 
  est store altciri21
  mat ALT[1,2]=B[1,1]
  mat ALT[2,2]=sqrt(S[1,1])
  qui probit worker12 l.worker12 l`l'.IMFnn $X $POLS _Iyear*
  mat ALTstat[2,2]=e(r2_p)
  mat ALTstat[1,2]=e(N)
  qui probit l`l'.IMFnn $Z if e(sample)

  qui cmp (worker12=l.BA2LAB l.IMFnn l.worker12 $X $POLS _Iyear*) (lBA2LAB: l.BA2LAB=l.iv1BA2LAB $POLS $X _Iyear*) (l.IMFnn=$Z), indicators($cmp_probit $cmp_cont $cmp_probit) cl(cid) 
  est store altciri22
  mat B=e(b)
  mat S=e(V)
  mat ALT[3,2]=B[1,1]
  mat ALT[4,2]=sqrt(S[1,1])
  mat ALT[5,2]=B[1,2]
  mat ALT[6,2]=sqrt(S[2,2])
  qui test [lBA2LAB]l.iv1BA2LAB
  mat ALTstat[4,2]=r(chi2)
  qui probit worker12 l.worker12 l`l'.BA2LAB l`l'.IMFnn $X $POLS _Iyear* if e(sample)
  mat ALTstat[3,2]=e(r2_p)
  qui probit l`l'.IMFnn $Z if e(sample)
  
  ** Other outcomes (linear regression)
  foreach y in lr_col lfpr_tot shadow{
    di "Outcome `y'"

    * Aggregate effect
    qui treatreg `y' l`l'.IMFnn $X _Icid* _Iyear*, treat(l`l'.IMFnn=$Z) twostep hazard(imr)
	est store alt1`l'`y'
	drop imr
	mat B=e(b)
	mat S=e(V)
	mat ALT[1,2+`m']=B[1,1]
	mat ALT[2,2+`m']=sqrt(S[1,1])
	mat ALTstat[1,2+`m']=e(N)
	qui xtreg `y' l`l'.IMFnn $X _Iyear*, fe
	mat ALTstat[2,2+`m']=e(r2_w)
	qui probit l`l'.IMFnn $Z if e(sample)
	
	* Labor conditions
	qui cmp (`y'=l`l'.BA2LAB l`l'.IMFnn $X _Icid* _Iyear*) (l`l'BA2LAB: l`l'.BA2LAB=iv`l'BA2LAB _Icid* _Iyear*) (l`l'.IMFnn=$Z), indicators($cmp_cont $cmp_cont $cmp_probit) cl(cid) iterate(100)
	est store alt2`l'`y'
	mat B=e(b)
	mat S=e(V)
	mat ALT[3,2+`m']=B[1,1]
	mat ALT[4,2+`m']=sqrt(S[1,1])
	mat ALT[5,2+`m']=B[1,2]
	mat ALT[6,2+`m']=sqrt(S[2,2])
	qui test [l`l'BA2LAB]iv`l'BA2LAB
	mat ALTstat[4,2+`m']=r(chi2)
	qui xtreg `y' iv`l'BA2LAB l`l'.IMFnn $X _Iyear*, fe
	mat ALTstat[3,2+`m']=e(r2_w)
	
	local m=`m'+1
  }
  
* Table A7
  di "Coefficient matrix with standard errors in odd lines:"
  mat li ALT
  di "Diagnostics:"
  mat li ALTstat 
   
  
  
  
* Further analyses (Appendix B)
******************************************************************************    
  
* Interaction effects 

  global X  l.lngdppc l.lnpop l.lntrade l.lnfdi l.p_polity2 l.leftexec l.ilofc l.civwar_UCDP
  global Z  l2.IMFCum l2.nUnder l2.s_unga3g7 l2.leftexec commonlaw _Iregid* _Iyear*

  g lBA2LAB=l.BA2LAB
  g lIMFnn=l.IMFnn
  g IV=l.nUnder*meanBA2LAB
  
  g urbX1=l.pop_urb*lIMFnn
  g urbX2=l.pop_urb*lBA2LAB
  g lpopurb=l.pop_urb
  qui cmp (idx_clr=lBA2LAB urbX2 lIMFnn urbX1 lpopurb $X _Icid* _Iyear*) (lBA2LAB=IV $X _Icid* _Iyear*) (lIMFnn=$Z), indicators($cmp_cont $cmp_cont $cmp_probit) cl(cid) iterate(50)

* Figure A1
  grinter lIMFnn, inter(urbX1) cons(lpopurb) dep(idx_clr) eq(idx_clr) cl(95) kdensity scheme(s1mono) yline(0)
  graph export "Figure_A1.png", width(2000) replace 
    
  
  g uX1=udens*lIMFnn
  g uX2=udens*lBA2LAB
  qui cmp (idx_clr=lBA2LAB uX2 lIMFnn uX1 udens $X _Icid* _Iyear*) (lBA2LAB=IV $X _Icid* _Iyear*) (lIMFnn=$Z), indicators($cmp_cont $cmp_cont $cmp_probit) cl(cid) iterate(50)

* Figure A2  
  grinter lBA2LAB, inter(uX2) cons(udens) dep(idx_clr) eq(idx_clr) cl(95) kdensity scheme(s1mono) yline(0)
  graph export "Figure_A2.png", width(2000) replace

  
* Lag structure 

* Table B2

  ** Panel A
  estout imf0idx_ilr imf1idx_ilr imf2idx_ilr imf3idx_ilr imf0idx_clr imf1idx_clr imf2idx_clr imf3idx_clr, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) keep(*IMFnn)
  mat li Mstatimf0
  mat li Mstatimf1
  mat li Mstatimf2
  mat li Mstatimf3
  di "(disregard the first two columns and second line in the diagnostics)"

  ** Panel B 
  * estout a0idx_ilr a1idx_ilr a2idx_ilr a3idx_ilr a0idx_clr a1idx_clr a2idx_clr a3idx_clr, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) order(*LAB* *IMF*) keep(*LAB* *IMFnn)
  * (only four at a time due to matrix size limits can be displayed)
  di "Columns 1-3:"
  estout a0idx_ilr a1idx_ilr a2idx_ilr, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) order(*LAB* *IMF*) keep(*LAB* *IMFnn)
  di "Columns 4-5:"
  estout a3idx_ilr a0idx_clr, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) order(*LAB* *IMF*) keep(*LAB* *IMFnn)
  di "Columns 6-8:"
  estout a1idx_clr a2idx_clr a3idx_clr, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) order(*LAB* *IMF*) keep(*LAB* *IMFnn)
  mat li Mstat0
  mat li Mstat1 
  mat li Mstat2
  mat li Mstat3 
  di "(disregard the first two columns in the diagnostics)"


  
* Other policy conditions
  
  mat O=J(3,4,0)
  local l=1 
  local k=2
  local t=1
  global X  l`l'.lngdppc l`l'.lnpop l`l'.lntrade l`l'.lnfdi l`l'.p_polity2 l`l'.leftexec l`l'.ilofc l`l'.civwar_UCDP
  global Z  l`k'.IMFCum l`k'.nUnder l`k'.s_unga3g7 l`k'.leftexec commonlaw _Iregid* _Iyear*

  foreach x in BA2EXT BA2SOE BA2FP BA2RTP{
  di "Condition #`t'"
  qui g x=`x'
  qui egen meanx=mean(x), by(cid)
  qui g ivx=meanx*l.nUnder
  
  qui cmp (idx_ilr=l.x l.IMFnn $X _Iyear* _Icid*) (l.IMFnn=$Z) (l.x=ivx $X _Iyear* _Icid*), indicators($cmp_cont $cmp_probit $cmp_cont) ro cl(cid) iterate(60)
  est store op`x'
  qui test [lx]ivx
  mat O[3,`t']=r(chi2)
  qui xtreg idx_ilr ivx l.IMFnn $X _Iyear*, fe 
  mat O[1,`t']=e(N)
  mat O[2,`t']=e(r2_w)
  local t=`t'+1
  drop ivx meanx x
  }

* Table B3
  estout op*, starlevels(* .1 ** .05 *** .01) cells(b(star fmt(2)) se(par fmt(2))) keep(L.x L.IMFnn) 
  di "Diagnostics:"
  mat li O
    
  
  
* Descriptive statistics 
* *************************************************************

* Table C1
  corr idx idx_ilr idx_clr IMFnn BA2LAB gdppc_WDI gdp_growth trade_WDI fdi_gdp p_polity2 leftexec ilofc civwar_UCDP  BA2EXT BA2SOE  worker2 *MOSLEY shadow lfpr  

  
* Table C3
  estpost summarize idx idx_ilr idx_clr fe_idx wt_idx dm_idx er_idx ia_idx IMFnn BA2LAB gdppc_WDI gdp_growth trade_WDI fdi_gdp p_polity2 leftexec ilofc civwar_UCDP  BA2EXT BA2SOE  worker2 *MOSLEY shadow lfpr
  esttab, cells("count mean sd min max") noobs replace label  
  
  
