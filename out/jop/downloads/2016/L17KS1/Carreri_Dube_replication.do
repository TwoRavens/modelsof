


	**************************************
	*                                    *
	*        Replication code for        *
	*             Tables in              *
	*       Carreri and Dube, JOP        *
	*                                    *
	**************************************
	

	
//////  Table 2
	use "Carreri_Dube_replication_main.dta", clear
	* column 1
	xi: xtivreg2  para_mayor oilrevnp93xlop _R* i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 2
	xi: xtivreg2  para_mayor  oilrevnp93xlop lnnewpop  _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 3
	xi: xtivreg2  para_mayor  oilrevnp93xlop    lnnewpop  heightxlop   _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column4
	xi: xtivreg2  cou_sh_propara oilrevnp93xlop _R* i.year if ele_year==1 & year>=1997 & year<=2003, cluster(origmun) fe first
	* column 5
	xi: xtivreg2  cou_sh_propara  oilrevnp93xlop lnnewpop  _R*   i.year if ele_year==1 & year>=1997 & year<=2003, cluster(origmun) fe first
	* column 6
	xi: xtivreg2  cou_sh_propara  oilrevnp93xlop    lnnewpop  heightxlop   _R*   i.year if ele_year==1 & year>=1997 & year<=2003, cluster(origmun) fe first
	
	

		
//////  Table 3
	use "Carreri_Dube_replication_main.dta", clear
	* columns 1-4
	foreach var of varlist  nmbr_candidates   num_para_cand2  nmbr_nonpar_cand    molinar   { 
	xi: xtivreg2 `var'  oilrevnp93xlop    lnnewpop        heightxlop    _R*   i.year if ele_year==1 &  year>=1997 & year<=2007, cluster(origmun) fe first
	}
	* columns 5-7
	foreach var of varlist    marginv   winner_share runnerup_share  { 
	xi: xtivreg2 `var'  oilrevnp93xlop    lnnewpop        heightxlop     _R*   i.year if marginvsamp==1 & winnersamp ==1 & ele_year==1 &  year>=1997 & year<=2007, cluster(origmun) fe first
	}
	* column 8
	xi: xtivreg2  para_share  oilrevnp93xlop    lnnewpop        heightxlop     _R*   i.year if ele_year==1 &  year>=1997 & year<=2007, cluster(origmun) fe first

	
	

//////  Table 4  
	use "Carreri_Dube_replication_main.dta", clear
	* column 1
	xi: xtivreg2   lnrdnprevregalias    oilrevnp93xlop  lnnewpop   heightxlop   _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	* column 2-6
	foreach var of varlist  lnrdnprevtot    PAR_any   GUER_any  pparatt   pgueratt { 
	xi: xtivreg2 `var'  oilrevnp93xlop    lnnewpop      heightxlop     _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	}	
	* column 7
	xi: xtivreg2  lnrdnprevtax   oilrevnp93xlop    lnnewpop      heightxlop     _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	* column 8-9
	foreach var of varlist lnrdnpspendtot  lnrdnpspendperson   { 
	xi: xtivreg2 `var'  oilrevnp93xlop    lnnewpop      heightxlop     _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	}
	* column 10
	xi: xtivreg2  incumbent  oilrevnp93xlop    lnnewpop      heightxlop     _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
  	
	
	

//////  Table 5
	* column 1
	use "Carreri_Dube_replication_wage.dta", clear
	xi: ivreg2   lrwmonkindinc1 i.year i.origmun   gender  age agesq  married  edyrs  lnnewpop oilrevnp93xlop     heightxlop     _R*   if olrwmonkindinc114==0 &  age>=14   &  year>=1998 & year<=2005 [pw=pweight], cluster(origmun) 
	* column2
	use "Carreri_Dube_replication_wageinequality.dta", clear
	tsset origmun year, yearly
	xi: xtivreg2   p90_10lwage1_14no i.year    gender  age agesq  married  edyrs   oilrevnp93xlop       heightxlop    _R* lnnewpop  if  year>=1998 & year<=2005 , cluster(origmun) fe
	* column 3
	xi: xtivreg2   p75_25lwage1_14no i.year    gender  age agesq  married  edyrs   oilrevnp93xlop       heightxlop    _R*  lnnewpop if  year>=1998 & year<=2005 , cluster(origmun) fe
	* column 4
	use "Carreri_Dube_replication_main.dta", clear
	xi: xtivreg2 green_mayor  oilrevnp93xlop    lnnewpop        heightxlop     _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 5-7
	foreach var of varlist   cenright_mayor  cenleft_mayor  left_mayor {
	xi: xtivreg2  `var'   oilrevnp93xlop    lnnewpop        heightxlop     _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}



	
//////  Table 6 
	use "Carreri_Dube_replication_main.dta", clear
	* column 1
	xi: xtivreg2  para_mayor    oilrevnp93xlop pipelenxlop    lnnewpop        heightxlop     _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 2
	xi: xtivreg2 lnrdnprevtot  oilrevnp93xlop  pipelenxlop   lnnewpop      heightxlop     _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	* column 3
	xi: xtivreg2 para_mayor  oilrevnp93xlop  o93xpxswing_8894  o93xpxright_8894  ///
	left_8894xp  swing_8894xp  right_8894xp  ///
	lnnewpop  heightxlop  _R*  i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 4		
	xi: xtivreg2 lnturnout oilrevnp93xlop       o93xpxswing_8894  	o93xpxright_8894  ///
	left_8894xp	swing_8894xp 		right_8894xp  ///
	lnnewpop       heightxlop   _R*   i.year  if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 5
	xi: xtivreg2  para_mayor   oilrevnp93xlop   o93xpxpost2003  o93xpost2003 lnnewpop        heightxlop     _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 6	
	xi: xtivreg2  para_mayor  oilrevnp93xlop   o93xpxparagov_lag  paragov_lagxp o93xparagov_lag  paragov_lag  ///
	lnnewpop  heightxlop  _R*  i.year if  ele_year==1 & year>=2000 & year<=2007, cluster(origmun) fe first
	* column 7
	xi: xtivreg2  para_mayor  oilrevnp93xlop   o93xpxam_paragov  am_paragovxp  o93xam_paragov  am_paragov ///
	lnnewpop  heightxlop  _R*  i.year  if  ele_year==1 & year>=2000 & year<=2007, cluster(origmun) fe first


	
	
//////  Table A.3 
	use "Carreri_Dube_replication_main.dta", clear
	* columns 1 & 5
	local split "gpt8892_meani  gpt8805_meani"
	foreach l of local split {
	xi: xtivreg2  para_mayor  oilrevnp93xlop  lnnewpop  heightxlop   _R*  i.year if ele_year==1 &  year>=1997 & year<=2007 & `l'==0, cluster(origmun) fe first
	* columns 2 & 6
	xi: xtivreg2  para_mayor  oilrevnp93xlop  lnnewpop  heightxlop   _R*  i.year if ele_year==1 &  year>=1997 & year<=2007 & `l'==1, cluster(origmun) fe first
	* columns 3 & 7
	xi: xtivreg2  cou_sh_propara  oilrevnp93xlop  lnnewpop  heightxlop  _R*  i.year if   ele_year==1 &  year>=1997 & year<=2003 & `l'==0, cluster(origmun) fe first
	* columns 4 & 8
	xi: xtivreg2  cou_sh_propara  oilrevnp93xlop  lnnewpop  heightxlop   _R*  i.year if ele_year==1 &  year>=1997 & year<=2003 & `l'==1, cluster(origmun) fe first
	}	
	
	
	
	
//////  Table A.4
	use "Carreri_Dube_replication_main.dta", clear
	* columns 1-3
	foreach var of varlist   golosov  golosov_party molinar_party  { 
	xi: xtivreg2 `var'  oilrevnp93xlop    lnnewpop   heightxlop   _R*  i.year if ele_year==1 &  year>=1997 & year<=2007, cluster(origmun) fe first
	}
	* column 4
	xi: xtivreg2  lnturnout  oilrevnp93xlop   lnnewpop   heightxlop  _R*  i.year ///
	if zero_votes_all ==0 &  ele_year==1 &  year>=1997 & year<=2007, cluster(origmun) fe first
	
	
	
		
//////  Table A.5
	use "Carreri_Dube_replication_main.dta", clear
	* column 1
	xi: xtivreg2  para_mayor  (lnrdnprevtot = oilrevnp93xlop)  lnnewpop heightxlop  _R*  i.year if ele_year==1 & year>=1997 & year<=2005, cluster(origmun) fe first
	* column 2
	xi: xtivreg2  cou_sh_propara  (lnrdnprevtot = oilrevnp93xlop) lnnewpop  heightxlop  _R*  i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	* columns 3-4
	foreach var of varlist   marginv  nmbr_candidates  { 
	xi: xtivreg2 `var'  (lnrdnprevtot = oilrevnp93xlop) lnnewpop  heightxlop _R*  i.year if ele_year==1 &  year>=1997 & year<=2005, cluster(origmun) fe first
	}
  	* column 5
	xi: xtivreg2  PAR_any  (lnrdnprevtot = oilrevnp93xlop) lnnewpop  heightxlop  _R*  i.year if   year>=1997 & year<=2005, cluster(origmun) fe first
	
	
//////  Table A.6A
	use "Carreri_Dube_replication_main.dta", clear
	* Panel 1
	foreach x of numlist 88/97  {
	xi: xtivreg2 pparatt  pparatt`x'con1xlop     oilrevnp93xlop   heightxlop    lnnewpop     _R*   i.year if year>=19`x' & year<=2005, cluster(origmun) fe first
	}	
	* Panel 2
	foreach x of numlist 88/97  {
	xi: xtivreg2 pgueratt  pgueratt`x'con1xlop     oilrevnp93xlop   heightxlop    lnnewpop     _R*   i.year if year>=19`x' & year<=2005, cluster(origmun) fe first
	}	
	* Panel 3
	foreach x of numlist 88/97  {
	xi: xtivreg2  pparatt  pparatt`x'con1xlop    gini_land0mxlop   gini_mixlop  oilrevnp93xlop   heightxlop    lnnewpop     _R*   i.year if year>=19`x' & year<=2005, cluster(origmun) fe first
	}	
	* Panel 4	
	foreach x of numlist 88/97  {
	xi: xtivreg2  pgueratt  pgueratt`x'con1xlop    gini_land0mxlop   gini_mixlop  oilrevnp93xlop   heightxlop    lnnewpop     _R*   i.year if year>=19`x' & year<=2005, cluster(origmun) fe first
	}	
			

			
	
//////  Table A.6B
	use "Carreri_Dube_replication_main.dta", clear
	* Panel 1
	foreach x of numlist 88/97  {
	xi: xtivreg2  paratt  paratt`x'con1xlop      oilrevnp93xlop   heightxlop    lnnewpop     _R*   i.year if year>=19`x' & year<=2005, cluster(origmun) fe first
	}
	* Panel 2
	foreach x of numlist 88/97  {
	xi: xtivreg2  gueratt  gueratt`x'con1xlop      oilrevnp93xlop   heightxlop    lnnewpop     _R*   i.year if year>=19`x' & year<=2005, cluster(origmun) fe first
	}
	* Panel 3
	foreach x of numlist 88/97  {
	xi: xtivreg2  paratt  paratt`x'con1xlop  gini_land0mxlop   gini_mixlop  oilrevnp93xlop   heightxlop    lnnewpop     _R*   i.year if year>=19`x' & year<=2005, cluster(origmun) fe first
	}	
	* Panel 4
	foreach x of numlist 88/97  {
	xi: xtivreg2  gueratt  gueratt`x'con1xlop  gini_land0mxlop   gini_mixlop  oilrevnp93xlop   heightxlop    lnnewpop     _R*   i.year if year>=19`x' & year<=2005, cluster(origmun) fe first
	}		
		

		
			
//////  Table A.7A
	use "Carreri_Dube_replication_main.dta", clear
	* Panel 1
	foreach v in  pre_cenright_winner pre_cenleft_winner pre_left_winner {			
	xi: xtivreg2  `v'    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	}
	forvalues v=1(1)2 {			
	xi: xtivreg2  party_w_a`v'    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	}
	xi: xtivreg2  party_w_a3    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first		
	xi: xtivreg2  party_w_a4    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	forvalues v=5(1)6 {			
	xi: xtivreg2  party_w_a`v'    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	}
	xi: xtivreg2  party_w_a7    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first	
	* Panel 2
	forvalues v=8(1)9 {			
	xi: xtivreg2  party_w_a`v'    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	}
	forvalues v=10(1)12 {			
	xi: xtivreg2  party_w_a`v'    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	}
	forvalues v=13(1)14 {			
	xi: xtivreg2  party_w_a`v'    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	}
	forvalues v=15(1)16 {			
	xi: xtivreg2  party_w_a`v'    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	}
	xi: xtivreg2  party_w_a17   ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	* Panel 3
	forvalues v=18(1)19 {			
	xi: xtivreg2  party_w_a`v'    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	}
	forvalues v=20(1)21 {			
	xi: xtivreg2  party_w_a`v'    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	}
	forvalues v=22(1)24 {			
	xi: xtivreg2  party_w_a`v'    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	}
	forvalues v=25(1)26 {			
	xi: xtivreg2  party_w_a`v'    ornp93xpreyear   lnnewpop  heightxlop    _R*   i.year if ele_year==1 & year>=1988 & year<=1994, cluster(origmun) fe first
	}

	
		
		
//////  Table A.7C
	use "Carreri_Dube_replication_main.dta", clear
	* column 1
	xi: xtivreg2  para_mayor oilrevnp93xlop _R* i.year if ele_year==1 & year>=1997 & year<=2007 & pre_significant_party!=1, cluster(origmun) fe first
	* column 2
	xi: xtivreg2  para_mayor  oilrevnp93xlop lnnewpop  _R*   i.year if ele_year==1 & year>=1997 & year<=2007 & pre_significant_party!=1, cluster(origmun) fe first
	* column 3
	xi: xtivreg2  para_mayor  oilrevnp93xlop    lnnewpop  heightxlop   _R*   i.year if ele_year==1 & year>=1997 & year<=2007 & pre_significant_party!=1, cluster(origmun) fe first
	* column 4
	xi: xtivreg2  cou_sh_propara oilrevnp93xlop _R* i.year if ele_year==1 & year>=1997 & year<=2003 & pre_significant_party!=1, cluster(origmun) fe first
	* column 5
	xi: xtivreg2  cou_sh_propara  oilrevnp93xlop lnnewpop  _R*   i.year if ele_year==1 & year>=1997 & year<=2003 & pre_significant_party!=1, cluster(origmun) fe first
	* column 6
	xi: xtivreg2  cou_sh_propara  oilrevnp93xlop    lnnewpop  heightxlop   _R*   i.year if ele_year==1 & year>=1997 & year<=2003 & pre_significant_party!=1, cluster(origmun) fe first

	
	
		
/////  Table A8
	use "Carreri_Dube_replication_main.dta", clear
	* columns 1-2
	foreach var of varlist para_mayor_acemoglu      para_share_acemoglu  {
	xi: xtivreg2 `var'  oilrevnp93xlop    lnnewpop      heightxlop     _R*   i.year if  ele_year==1 &  year>=1997 & year<=2007, cluster(origmun) fe first
	}
	* columns 3-4
	foreach var of varlist  cou_sh_para_acemoglu   para_share_acemoglu_c {
	xi: xtivreg2 `var'  oilrevnp93xlop    lnnewpop    heightxlop     _R*   i.year if  ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	}
	* columns 5-6
	foreach var of varlist  para_mayor_acemoglu2   para_share_acemoglu2  {
	xi: xtivreg2 `var'  oilrevnp93xlop    lnnewpop    heightxlop     _R*   i.year if  ele_year==1 &  year>=1997 & year<=2007, cluster(origmun) fe first
	}
	* columns 7-8
	foreach var of varlist   cou_sh_para_acemoglu2  para_share_acemoglu_c2 {
	xi: xtivreg2 `var'  oilrevnp93xlop    lnnewpop   heightxlop     _R*   i.year if  ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	}	
				


/////  Table A.9
	use "Carreri_Dube_replication_main.dta", clear
	* column 1
	xi: xtivreg2  para_mayor   oilrevnp93xlop  ornp93xyear  lnnewpop   _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 2
	xi: xtivreg2  cou_sh_propara  oilrevnp93xlop  ornp93xyear lnnewpop  _R*   i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	* columns 3-4
	foreach v in   marginv  nmbr_candidates  {
	xi: xtivreg2  `v' oilrevnp93xlop  ornp93xyear    lnnewpop  _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}								
	* column 5
	xi: xtivreg2  PAR_any  oilrevnp93xlop  ornp93xyear  lnnewpop  _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	* column 6
	xi: xtivreg2  para_mayor   oilrevnp93xlop  ornp93xyear  lnnewpop  heightxlop  _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 7
	xi: xtivreg2  cou_sh_propara  oilrevnp93xlop  ornp93xyear lnnewpop  heightxlop _R*   i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	* columns 8-9
	foreach v in   marginv  nmbr_candidates  {
	xi: xtivreg2  `v' oilrevnp93xlop  ornp93xyear    lnnewpop  heightxlop _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}								
	* column 10
	xi: xtivreg2  PAR_any  oilrevnp93xlop  ornp93xyear  lnnewpop  heightxlop _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first


	
					

/////  Table A.10
	use "Carreri_Dube_replication_main.dta", clear
	* column 1
	xi: xtivreg2  para_mayor oilrevnp93xlop  PAR_any_8892xlop  heightxlop  lnnewpop   _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 2
	xi: xtivreg2 cou_sh_propara oilrevnp93xlop  PAR_any_8892xlop  heightxlop  lnnewpop  _R*   i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	* columns 3-4
	foreach v in  marginv  nmbr_candidates {
	xi: xtivreg2  `v'  oilrevnp93xlop  PAR_any_8892xlop  heightxlop  lnnewpop  _R*  i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}
	* column 5
	xi: xtivreg2  PAR_any  oilrevnp93xlop  PAR_any_8892xlop  heightxlop  lnnewpop  _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	* column 6
	xi: xtivreg2  para_mayor  oilrevnp93xlop  PAR_any_8892xlop   GUER_any_8892xlop heightxlop  lnnewpop  _R*  i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 7
	xi: xtivreg2  cou_sh_propara oilrevnp93xlop  PAR_any_8892xlop   GUER_any_8892xlop  heightxlop  lnnewpop  _R*   i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	* columns 8-9
	foreach v in   marginv  nmbr_candidates   {
	xi: xtivreg2  `v'  oilrevnp93xlop  PAR_any_8892xlop   GUER_any_8892xlop heightxlop  lnnewpop   _R*  i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}						
	* column 10
	xi: xtivreg2  PAR_any  oilrevnp93xlop  PAR_any_8892xlop   GUER_any_8892xlop  heightxlop    lnnewpop     _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	
	
	
			
/////  Table A.11
	use "Carreri_Dube_replication_main.dta", clear
	* column 1
	xi: xtivreg2  para_mayor  oilrevnp93xlop    _D*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 2
	xi: xtivreg2  cou_sh_propara  oilrevnp93xlop   _D*   i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	* columns 3-5
	foreach v in  marginv  nmbr_candidates  nmbr_nonpar_cand  {
	xi: xtivreg2  `v'  oilrevnp93xlop   _D*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}								
	* column 6
	xi: xtivreg2  PAR_any  oilrevnp93xlop   _D*  i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	* column 7
	xi: xtivreg2  para_mayor  oilrevnp93xlop  lnnewpop heightxlop  _D*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	* column 8
	xi: xtivreg2  cou_sh_propara  oilrevnp93xlop  lnnewpop  heightxlop  _D*   i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	* columns 9-11
	foreach v in    marginv  nmbr_candidates   nmbr_nonpar_cand {
	xi: xtivreg2  `v'  oilrevnp93xlop  ornp93xyear  lnnewpop  heightxlop  _D*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}
	* column 12
	xi: xtivreg2  PAR_any  oilrevnp93xlop    lnnewpop  heightxlop   _D*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first


	

/////  Table A.12
	use "Carreri_Dube_replication_main.dta", clear
	rename lnrdnprevregalias lrd
	* Panel 1
	foreach v in  para_mayor  para_share marginv  nmbr_candidates nmbr_nonpar_cand  molinar   {
	xi: xtivreg2     `v'    `v'97con1xlop `v'97o93xyear  oilrevnp93xlop    heightxlop  lnnewpop        _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}	
	foreach v in cou_sh_propara    {
	xi: xtivreg2     `v'   `v'97con1xlop `v'97o93xyear   oilrevnp93xlop   heightxlop  lnnewpop   _R*   i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	}	
	foreach v in lrd   lnrdnprevtot    PAR_any   pparatt  paratt {
	xi: xtivreg2   `v'  `v'97con1xlop `v'97o93xyear   oilrevnp93xlop   heightxlop    lnnewpop     _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	}		
	* Panel 2
	foreach v in  para_mayor  para_share marginv  nmbr_candidates nmbr_nonpar_cand  molinar   {
	xi: xtivreg2     `v'    `v'97con1xlop `v'97o93xyear  PAR_any_8892xlop GUER_any_8892xlop oilrevnp93xlop    heightxlop  lnnewpop        _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}	
	foreach v in cou_sh_propara     {
	xi: xtivreg2     `v'   `v'97con1xlop `v'97o93xyear  PAR_any_8892xlop GUER_any_8892xlop oilrevnp93xlop  heightxlop  lnnewpop   _R*   i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	}	
	foreach v in lrd   lnrdnprevtot    PAR_any     pparatt    paratt  {
	xi: xtivreg2   `v'  `v'97con1xlop `v'97o93xyear PAR_any_8892xlop GUER_any_8892xlop  oilrevnp93xlop  heightxlop    lnnewpop     _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	}
	* Panel 3							
	foreach v in  para_mayor  para_share marginv  nmbr_candidates nmbr_nonpar_cand molinar   {
	xi: xtivreg2     `v'    `v'97con1xlop `v'97o93xyear  PAR_any_8892xlop GUER_any_8892xlop oilrevnp93xlop  gini_landxlop   gini_landxyear  heightxlop  lnnewpop        _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}		
	foreach v in cou_sh_propara    {
	xi: xtivreg2     `v'   `v'97con1xlop `v'97o93xyear  PAR_any_8892xlop GUER_any_8892xlop oilrevnp93xlop  gini_landxlop   gini_landxyear   heightxlop  lnnewpop   _R*   i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	}	
	foreach v in lrd   lnrdnprevtot    PAR_any    pparatt     paratt  {
	xi: xtivreg2   `v'  `v'97con1xlop `v'97o93xyear PAR_any_8892xlop GUER_any_8892xlop  oilrevnp93xlop  gini_landxlop   gini_landxyear   heightxlop    lnnewpop     _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	}
	* Panel 4			
	foreach v in  para_mayor  para_share marginv  nmbr_candidates nmbr_nonpar_cand molinar   {
	xi: xtivreg2     `v'    `v'97con1xlop `v'97o93xyear  PAR_any_8892xlop GUER_any_8892xlop oilrevnp93xlop  gini_land0mxlop   gini_land0mxyear gini_mixlop gini_mixyear heightxlop  lnnewpop        _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}		
	foreach v in cou_sh_propara    {
	xi: xtivreg2     `v'   `v'97con1xlop `v'97o93xyear  PAR_any_8892xlop GUER_any_8892xlop oilrevnp93xlop  gini_land0mxlop   gini_land0mxyear   gini_mixlop gini_mixyear heightxlop  lnnewpop   _R*   i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	}	
	foreach v in lrd   lnrdnprevtot    PAR_any    pparatt     paratt  {
	xi: xtivreg2   `v'  `v'97con1xlop `v'97o93xyear PAR_any_8892xlop GUER_any_8892xlop  oilrevnp93xlop  gini_land0mxlop   gini_land0mxyear   gini_mixlop gini_mixyear heightxlop    lnnewpop     _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	}								
	foreach v in   PAR_any    pparatt       {
	xi: xtivreg2   `v'  `v'97con1xlop `v'97o93xyear PAR_any_8892xlop GUER_any_8892xlop  oilrevnp93xlop  gini_land0mxlop   gini_land0mxyear   gini_mixlop gini_mixyear heightxlop    lnnewpop     _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	}
				
		
		
		
/////  Table A.12
	use "Carreri_Dube_replication_main.dta", clear
	* column 1
	xi: xtivreg2  cou_sh_propara  oilrevnp8896xlop       heightxlop      lnnewpop   _R*   i.year if ele_year==1 &  year>=1997 & year<=2003, cluster(origmun) fe first
	* columns 2-5
	foreach v in  para_mayor  para_share marginv  nmbr_candidates nmbr_nonpar_cand molinar  {
	xi: xtivreg2  `v'  oilrevnp8896xlop        heightxlop     lnnewpop        _R*   i.year if ele_year==1 & year>=1997 & year<=2007, cluster(origmun) fe first
	}
	* columns 6-10
	foreach v in   lnrdnprevregalias lnrdnprevtot  PAR_any  pparatt  paratt {
	xi: xtivreg2   `v'   oilrevnp8896xlop        lnnewpop       heightxlop     _R*   i.year if year>=1997 & year<=2005, cluster(origmun) fe first
	}					
					


