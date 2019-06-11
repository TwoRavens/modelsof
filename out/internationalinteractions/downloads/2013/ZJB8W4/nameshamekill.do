clear 
clear matrix

log using "nameshamekill.log", replace

**************************************************************************
**************************************************************************
* PROJECT: IOs and Government Killing: Does Naming & Shaming Save Lives? *
* AUTHOR: Jacqueline HR Demeritt										 *
* CREATED ON: 23 January 2010											 *
* LAST EDITED ON: 26 March 2012										 	 *
**************************************************************************
**************************************************************************

set seed 082281
set more off
use "nameshamekill.dta"
tsset ccode year
***********
* Generate necessary terms, leads & lags
***********
*quietly{
gen l1_vncdum=vncdum[_n-1]
replace l1_vncdum=. if ccode~=ccodel1
gen l1_lnvnc=lnvnc[_n-1]
replace l1_lnvnc=. if ccode~=ccodel1
*gen l1_capacity=capacity_new[_n-1]
*replace l1_capacity=. if ccode~=ccodel1
gen l1_physint2=physint2[_n-1]
replace l1_physint2=. if ccode~=ccodel1
gen l1_hroshame=hroshame[_n-1]
replace l1_hroshame=. if ccode~=ccodel1
gen l1_avmdia2=avmdia2[_n-1]
replace l1_avmdia2=. if ccode~=ccodel1
gen l1_undefeat=undefeat[_n-1]
replace l1_undefeat=. if ccode~=ccodel1
gen l1_unadopt=unadopt[_n-1]
replace l1_unadopt=. if ccode~=ccodel1
gen l1_unadvis=unadvis[_n-1]
replace l1_unadvis=. if ccode~=ccodel1
gen l1_unres=unres[_n-1]
replace l1_unres=. if ccode~=ccodel1
gen l1_unact=unact[_n-1]
replace l1_unact=. if ccode~=ccodel1
gen l1_undiscuss=undiscuss[_n-1]
replace l1_undiscuss=. if ccode~=ccodel1
gen l1_ron_ai_nr=ron_ai_nr[_n-1]
replace l1_ron_ai_nr=. if ccode~=ccodel1
gen l1_ron_ai_br=ron_ai_br[_n-1]
replace l1_ron_ai_br=. if ccode~=ccodel1
gen l1_milex=milex_gdp[_n-1]
replace l1_milex=. if ccode~=ccodel1
gen l1_milex2=milex_exp[_n-1]
replace l1_milex2=. if ccode~=ccodel1
*}


***MAIN MODELS***

***Stage 1 (heckman)
quietly{
*drop p1 
*drop invmills
*drop  phi capphi 
}
probit vncdum priowar violdiss nonvioldiss polity2 polity2sq l1_vncdum, cluster(ccode)
*gen nonvioldiss=genstrike+agdems
*gen violdiss=guerrilla+govcrises
estat sum
predict p1, xb
generate phi = (1/sqrt(2*_pi))*exp(-(p1^2/2))  
/*standardize it*/
generate capphi = normal(p1)
generate invmills= phi/capphi


***Stage 2 (Influences on Pr(kill))***
probit vncdum l1_hroshame aidpcw capacityv3 l1_physint2 invmills, cluster(ccode) nolog
probit vncdum l1_avmdia2 aidpcw capacityv3 l1_physint2 invmills, cluster(ccode) nolog
probit vncdum l1_unact aidpcw capacityv3 l1_physint2 invmills, cluster(ccode) nolog


***Stage 2 (Influences on E(death toll)***
reg lnvnc l1_hroshame aidpcw capacityv3 l1_physint2 lpop invmills, cluster(ccode)
reg lnvnc l1_avmdia2 aidpcw capacityv3 l1_physint2 lpop invmills, cluster(ccode)
reg lnvnc l1_unact aidpcw capacityv3 l1_physint2 lpop invmills, cluster(ccode)



*** SUBSTANTIVE EFFECTS ***

** Effects of HRO Shaming on Pr(Kill) **
#delimit ;
quietly logit vncdum l1_hroshame aidpcw capacityv3 l1_physint2 invmills, cluster(ccode) nolog;

local a=0;
while `a' <= 12 {;
	{;	
		gen p = _b[vncdum:_cons] 
			+ _b[vncdum:l1_hroshame]*`a' 
			+ _b[vncdum:aidpcw]*aidpcw 
			+ _b[vncdum:capacityv3]*capacityv3 
			+ _b[vncdum:l1_physint2]*l1_physint2 
			+ _b[vncdum:invmills]*invmills;		

		gen pr=exp(p)/(1+exp(p));
		ci pr;
	};

drop p pr;
local a=`a'+1;
display "." _c;
};

 
** Effects of HRO Shaming on ln(E(death toll)) **
#delimit ;
quietly reg lnvnc l1_hroshame aidpcw capacityv3 l1_physint2 lpop invmills, cluster(ccode);

local a=0;
while `a' <= 12 {;
	{;	
		gen ln = _b[_cons] 
			+ _b[l1_hroshame]*`a' 
			+ _b[aidpcw]*aidpcw 
			+ _b[capacityv3]*capacityv3 
			+ _b[l1_physint2]*l1_physint2 
			+ _b[lpop]*lpop
			+ _b[invmills]*invmills;		

		ci ln;
	};

drop ln;
local a=`a'+1;
display "." _c;
};


** Effects of UN Shaming on Pr(Kill) **
#delimit ;
quietly logit vncdum l1_unact aidpcw capacityv3 l1_physint2 invmills, cluster(ccode) nolog;

local a=0;
while `a' <= 4 {;
	{;	
		gen p = _b[vncdum:_cons] 
			+ _b[vncdum:l1_unact]*`a' 
			+ _b[vncdum:aidpcw]*aidpcw 
			+ _b[vncdum:capacityv3]*capacityv3 
			+ _b[vncdum:l1_physint2]*l1_physint2 
			+ _b[vncdum:invmills]*invmills;		

		gen pr=exp(p)/(1+exp(p));
		ci pr;
	};

drop p pr;
local a=`a'+1;
display "." _c;
};

** Effects of UN Shaming on ln(E(death toll)) **

#delimit ;
quietly reg lnvnc l1_unact aidpcw capacityv3 l1_physint2 lpop invmills, cluster(ccode);

local a=0;
while `a' <= 4 {;
	{;	
		gen ln = _b[_cons] 
			+ _b[l1_unact]*`a' 
			+ _b[aidpcw]*aidpcw 
			+ _b[capacityv3]*capacityv3 
			+ _b[l1_physint2]*l1_physint2 
			+ _b[lpop]*lpop
			+ _b[invmills]*invmills;		

		ci ln;
	};

drop ln;
local a=`a'+1;
display "." _c;
};

#delimit cr
***ROBUSTNESS CHECKS FOR APPENDIX:***

**Results are robust to excluding Banks data from Stage 1 (and therefore exploding the N by 4 years):
quietly{
drop p1 
drop invmills
drop  phi capphi 
}
probit vncdum priowar polity2 polity2sq l1_vncdum, cluster(ccode)
estat sum
predict p1, xb
generate phi = (1/sqrt(2*_pi))*exp(-(p1^2/2))  
/*standardize it*/
generate capphi = normal(p1)
generate invmills= phi/capphi

probit vncdum l1_hroshame aidpcw capacityv3 l1_physint2 invmills, cluster(ccode) nolog
probit vncdum l1_avmdia2 aidpcw capacityv3 l1_physint2 invmills, cluster(ccode) nolog
probit vncdum l1_unact aidpcw capacityv3 l1_physint2 invmills, cluster(ccode) nolog

reg lnvnc l1_hroshame aidpcw capacityv3 l1_physint2 lpop invmills, cluster(ccode)
reg lnvnc l1_avmdia2 aidpcw capacityv3 l1_physint2 lpop invmills, cluster(ccode)
reg lnvnc l1_unact aidpcw capacityv3 l1_physint2 lpop invmills, cluster(ccode)


*Results are robust to logging N&S variables:
quietly{
gen hroshame2=l1_hroshame+.001
gen lnhroshame=ln(hroshame2)
gen avmdia22=l1_avmdia2+.001
gen lnmedia=ln(avmdia22)
gen unact2=l1_unact+.001
gen lnunact=ln(unact2)
}

probit vncdum lnhroshame aidpcw capacityv3 l1_physint2 invmills, cluster(ccode) nolog
probit vncdum lnmedia aidpcw capacityv3 l1_physint2 invmills, cluster(ccode) nolog
probit vncdum lnunact aidpcw capacityv3 l1_physint2 invmills, cluster(ccode) nolog

reg lnvnc lnhroshame aidpcw capacityv3 l1_physint2 lpop invmills, cluster(ccode)
reg lnvnc lnmedia aidpcw capacityv3 l1_physint2 lpop invmills, cluster(ccode)
reg lnvnc lnunact aidpcw capacityv3 l1_physint2 lpop invmills, cluster(ccode)


*Results are robust to using military spending (% of all spending) to proxy monitoring and sanctioning:
***Stage 1 (heckman)
quietly{
drop p1 
drop invmills
drop  phi capphi 
probit vncdum priowar violdiss nonvioldiss polity2 polity2sq l1_vncdum, cluster(ccode)

estat sum
predict p1, xb
generate phi = (1/sqrt(2*_pi))*exp(-(p1^2/2))  
/*standardize it*/
generate capphi = normal(p1)
generate invmills= phi/capphi
}
probit vncdum l1_hroshame aidpcw milex_exp invmills, cluster(ccode) nolog
probit vncdum l1_avmdia2 aidpcw milex_exp invmills, cluster(ccode) nolog
probit vncdum l1_unact aidpcw milex_exp invmills, cluster(ccode) nolog

reg lnvnc l1_hroshame aidpcw milex_exp lpop invmills, cluster(ccode)
reg lnvnc l1_avmdia2 aidpcw milex_exp lpop invmills, cluster(ccode)
reg lnvnc l1_unact aidpcw milex_exp lpop invmills, cluster(ccode)

*Results are robust to simple panel data respecification: 
*ChangeDeaths=b0+b1(lagged deaths)+b2(lagged shaming)+b3(change shaming)
quietly{
gen l1_vnc=vnc[_n-1]
replace l1_vnc=. if ccode~=ccodel1
*gen l1_lnvnc=lnvnc[_n-1]
*replace l1_lnvnc=. if ccode~=ccodel1
gen l2_hroshame=hroshame[_n-2]
replace l2_hroshame=. if ccode~=ccodel1
gen l2_avmdia2=avmdia2[_n-2]
replace l2_avmdia2=. if ccode~=ccodel1
gen l2_unact=unact[_n-2]
replace l2_unact=. if ccode~=ccodel1
gen changevnc=vnc-l1_vnc
gen changelnvnc=lnvnc-l1_lnvnc
gen changehroshame=l1_hroshame-l2_hroshame
gen changemedia=l1_avmdia2-l2_avmdia2
gen changeun=l1_unact-l2_unact
}

***Stage 2 (Influences on E(death toll)***
reg changevnc l1_vnc l1_hroshame changehroshame, robust
reg changevnc l1_vnc l1_avmdia2 changemedia, robust
reg changevnc l1_vnc l1_unact changeun, robust

log close
