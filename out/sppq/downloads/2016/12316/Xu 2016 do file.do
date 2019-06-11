
* SPPQ: Compensation or Retrenchment? The Paradox of Immigration and Public Welfare Spending in the American States
* Author: Ping Xu
* Replication data analyses do file
* Last Updated: 05-12-2016


*******************************************************************************
*                                                                              *
*                Do File for the Main Document                                 *
*                                                                              *
******************************************************************************** 

*---------------------Figure 1------------------------*
** use dataset "Xu 2016 data_2.dta"
sort year state
sort welfarexpper2008
gen ranking_w=_n      
twoway (dropline welfarexpper ranking_w, msymbol(diamond) lwidth(medium) lpattern(dash))/*
		*/(dropline welfarexpper2008 ranking_w, msymbol(circle) lwidth(medium) lpattern(solid)), /*
       */xsize(12) ysize(6.5) scheme(tufte) /*
       */ytitle("Public Welfare Spending as a % of GSP")/*
       */ytitle(, size(vsmall)) ylabel(0(2)8, nogrid labsize(small) angle(vertical))/*
       */yline(0, lpattern(shortdash) lcolor(gs10))/*
       */xlabel(, labsize(vsmall) angle(vertical)) /*
       */xlabel(, grid glwidth(vthin) glcolor(black) glpattern(tight_dot))/*
       */plotregion(lcolor(black)) /*
       */xlabel( 1	"	CO	" 2	"	VA	" 3	"	WY	" 4	"	UT	" 5	"	TX	" 6	"	SD	" 7	"	WA	" 8	"	OR	" 9	"	GA	" 10	"	HI	" 11	"	FL	" 12	"	NE	"/*
 */13	"	ND	" 14	"	DE	" 15	"	MD	" 16	"	KS	" 17	"	CT	" 18	"	MT	" 19	"	NJ	" 20	"	MO	" 21	"	NH	" 22	"	AL	" 23	"	IL	"/*
 */24	"	WI	" 25	"	NC	" 26	"	ID	" 27	"	IA	" 28	"	LA	" 29	"	AZ	" 30	"	IN	" 31	"	CA	" 32	"	OK	" 33	"	AK	" 34	"	MN	"/*
 */35	"	OH	" 36	"	SC	" 37	"	TN	" 38	"	MA	" 39	"	PA	" 40	"	MI	" 41	"	AR	" 42	"	KY	" 43	"	NY	" 44	"	WV	" 45	"	MS	"/*
 */46	"	RI	" 47	"	NM	" 48	"	ME	" 49	"	VT	" 50	"	NV	") /*
       */xtitle("") graphregion(color(white))   
	      
*---------------------Figure 2------------------------*
sort foreign2008
gen ranking=_n
label var foreign "%Foreign-Born Population 1999"
label var foreign2008 "%Foreign-Born Population 2008"
twoway (dropline foreign ranking, msymbol(diamond) lwidth(medium) lpattern(dash))/*
		*/(dropline foreign2008 ranking, msymbol(circle) lwidth(medium) lpattern(solid)), /*
       */xsize(12) ysize(6.5) scheme(tufte) /*
       */ytitle("% Foreign-Born Population")/*
       */ytitle(, size(vsmall)) ylabel(0(4)36, nogrid labsize(small) angle(vertical))/*
       */yline(0, lpattern(shortdash) lcolor(gs10))/*
       */xlabel(, labsize(vsmall) angle(vertical)) /*
       */xlabel(, grid glwidth(vthin) glcolor(black) glpattern(tight_dot))/*
       */plotregion(lcolor(black)) /*
       */xlabel( 1	"	WV	" 2	"	MT	" 3	"	ND	" 4	"	MS	" 5	"	WY	" 6	"	ME	"7	"	SD	" 8	"	KY	" 9	"	LA	" /*
       */10	"	VT	" 11	"	MO	" 12	"	AL	" 13	"	OH	" 14	"	IN	" 15	"	SC	" 16	"	AR	" 17	"	OK	" /*
	   */18	"	TN	" 19	"	PA	" 20	"	WI	" 21	"	NH	" 22	"	ID	" 23	"	IA	" 24	"	KS	"/*
		*/25	"	NE	" 26	"	AK	" 27	"	NC	" 28	"	MI	" 29	"	MN	" 30	"	OR	" 31	"	UT	" 32	"	NM	"/*
		*/33	"	GA	" 34	"	CO	" 35	"	DE	" 36	"	VA	" 37	"	WA	" 38	"	RI	" 39	"	CT	" 40	"	IL	"/*
		*/41	"	MA	" 42	"	MD	" 43	"	AZ	" 44	"	TX	" 45	"	HI	" 46	"	NV	" 47	"	FL	" 48	"	NY	" 49	"	NJ	"50	"	CA	") /*
       */xtitle("") graphregion(color(white)) 

	   
*---------------------Table 2------------------------*
** use dataset "Xu 2016 data.dta"
*Model 1
xtset state year	
xtpcse  d.welfarexpper l.welfarexpper  d.foreign l.foreign  d.index l.index d.unemploy l.unemploy d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce ///
l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty
*Model 2
gen foreignindex=foreign*index
gen dforeignindex=d.foreign*d.index
gen foreignunemp=foreign*unemploy
gen dforeignunemp=d.foreign*d.unemploy 
gen lfui=l.foreign*l.index*l.unemploy
gen dfui=d.foreign*l.index*d.unemploy

xtpcse  d.welfarexpper l.welfarexpper  d.foreign l.foreign  d.index l.index dforeignindex  l.foreignindex  d.unemploy l.unemploy dforeignunemp l.foreignunemp dfui lfui  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce ///
l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty


*---------------------Figure 3------------------------*	
xtpcse  d.welfarexpper  l.foreign l.index l.unemploy  l.foreignindex l.foreignunemp lfui  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce ///
l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 l.welfarexpper  d.foreign  d.index dforeignindex d.unemploy  dforeignunemp dfui d.poverty l.poverty

generate MV=_n-1
replace  MV=. if _n>9

matrix b=e(b)
matrix V=e(V)

scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]
scalar b4=b[1,4]
scalar b5=b[1,5]
scalar b6=b[1,6]

scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]
scalar varb4=V[4,4]
scalar varb5=V[5,5]
scalar varb6=V[6,6]

scalar covb1b4=V[1,4]
scalar covb1b5=V[1,5]
scalar covb1b6=V[1,6]
scalar covb4b5=V[4,5]
scalar covb4b6=V[4,6]
scalar covb5b6=V[5,6]

scalar list b1 b2 b3 b4 b5 b6 varb1 varb2 varb3 varb4 varb5 varb6 covb1b4 covb1b5 covb1b6 covb4b6 covb5b6

gen conb1=b1+b4*MV+b5*6.2+b6*(6.2*MV) if _n<10
gen conb2=b1+b4*MV+b5*3.2+b6*(3.2*MV) if _n<10

gen conse1=sqrt(varb1+varb4*(MV^2)+ varb5*(6.2^2)+varb6*MV^2*(6.2^2)+ 2*MV*covb1b4 + 2*6.2*covb1b5 + 2*6.2*MV*covb1b6+2*6.2*MV*covb4b5 + 2*(6.2^2)*MV*covb4b6+ 2*(6.2^2)*MV*covb5b6)  if _n<10
gen conse2=sqrt(varb1+varb4*(MV^2)+ varb5*(3.2^2)+varb6*MV^2*(3.2^2)+ 2*MV*covb1b4 + 2*3.2*covb1b5 + 2*3.2*MV*covb1b6+2*3.2*MV*covb4b5 + 2*(MV^2)*3.2*covb4b6+ 2*(3.2^2)*MV*covb5b6)  if _n<10

gen a1=1.64*conse1
gen upper1=conb1+a1
gen lower1=conb1-a1

gen a2=1.64*conse2
gen upper2=conb2+a2
gen lower2=conb2-a2

*Figure 3(a)
graph twoway line conb1 MV, clpattern(solid) clwidth(thin)||line upper1 MV, clpattern(dash) clwidth(thin) clcolor(black) /*
        */||line lower1 MV, clpattern(dash) clwidth(thin) clcolor(black)||,xlabel(0(1)8, labsize(2.5)) ylabel(-0.04(0.01)0.04, labsize(2.5)) /*
		*/yscale(noline) xscale(noline) legend(col(1) order(1 2) label(1 "Marginal Effect of Immigration") label(2 "90% Confidence Interval") /*
			  */label(3 " ")) yline(0, lcolor(black)) title(Marginal Effect of Immigration in States with Bleak Job Markets, size(4)) xtitle(Immigrant Welfare Policy(Exclusive->Inclusive), size(3))/*
			  */ytitle(Marginal Effect of Immigration, size(3)) xsca(titlegap(2)) ysca(titlegap(4)) scheme(s2mono) graphregion(fcolor(white)) graphregion(margin(r=18)) name(marginal1, replace)
        
*Figure 3(b)		
graph twoway line conb2 MV, clpattern(solid) clwidth(thin)||line upper2 MV, clpattern(dash) clwidth(thin) clcolor(black) /*
        */||line lower2 MV, clpattern(dash) clwidth(thin) clcolor(black)||,xlabel(0(1)8, labsize(2.5)) ylabel(-0.04(0.01)0.04, labsize(2.5)) /*
		*/yscale(noline) xscale(noline) legend(col(1) order(1 2) label(1 "Marginal Effect of Immigration") label(2 "90% Confidence Interval") /*
			  */label(3 " ")) yline(0, lcolor(black)) title(Marginal Effect of Immigration in States with Good Job Markets, size(4)) xtitle(Immigrant Welfare Policy(Exclusive->Inclusive), size(3))/*
			  */ytitle(Marginal Effect of Immigration, size(3)) xsca(titlegap(2)) ysca(titlegap(4)) scheme(s2mono) graphregion(fcolor(white)) graphregion(margin(r=18)) name(marginal2, replace)
	
drop MV-lower2	



*---------------------Figure 4------------------------*	
** in order to use the estsimp_pcse and simqi_pcse commands to generate figure 4, please (1) use stata 12; (2)install the following two ado files (available with the replication data package): estsimp_pcse.ado   simqi_pcse.ado
sort state year
estsimp_pcse xtpcse  d.welfarexpper l.welfarexpper  d.foreign l.foreign  d.index l.index dforeignindex  l.foreignindex  d.unemploy l.unemploy dforeignunemp l.foreignunemp dfui lfui  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce ///
l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty
generate huhi_lower = .   
generate huhi_upper = .
generate huhi_mean=.
generate huli_lower = .
generate huli_upper = .
generate huli_mean =.
generate luhi_lower = .   
generate luhi_upper = .
generate luhi_mean=.
generate luli_lower = .
generate luli_upper = .
generate luli_mean =.

generate vectaxis = .  

recast float vectaxis  	   
local a=0
local b=1							 
while `a' <= 34{                            
setx l.foreign `a' l.unemploy 6.2 l.foreignunemp `a'*6.2  dforeignunemp 0.25*0.13  l.index 7  l.foreignindex `a'*7   dforeignindex 0.25*0.52  lfui `a'*6.2*7  dfui 0.25*0.13*0.52  ///
	 (l.welfarexpper  d.foreign  d.unemploy  d.index d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap  d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///
                              					   
simqi_pcse, ev genev(p1)       
	_pctile p1, p(5, 50, 95)       
	display `a'
	replace huhi_lower = r(r1) in `b'   
	replace huhi_mean = r(r2) in `b'  
	replace huhi_upper = r(r3) in `b'  
	
setx l.foreign `a' l.unemploy 6.2  l.foreignunemp `a'*6.2  dforeignunemp 0.25*0.13  l.index 1  l.foreignindex `a'*1   dforeignindex 0.25*0.52  lfui `a'*6.2*1  dfui 0.25*0.13*0.52   ///
	 (l.welfarexpper  d.foreign  d.unemploy d.index  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap  d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///

simqi_pcse, ev genev(p2)   
_pctile p2, p(5, 50, 95)      
	display `a'
	replace huli_lower = r(r1) in `b'   
	replace huli_mean = r(r2) in `b'  
	replace huli_upper = r(r3) in `b'
	
	  
setx l.foreign `a' l.unemploy 3.2  l.foreignunemp `a'*3.2  dforeignunemp 0.25*0.13   l.index 7  l.foreignindex `a'*7   dforeignindex 0.25*0.52  lfui `a'*3.2*7  dfui 0.25*0.13*0.52  ///
	 (l.welfarexpper l.index  d.foreign  d.unemploy d.index  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap  d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///				   
				   
simqi_pcse, ev genev(p3)        
	_pctile p3, p(5, 50, 95)       
	display `a'
	replace luhi_lower = r(r1) in `b'   
	replace luhi_mean = r(r2) in `b'  
	replace luhi_upper = r(r3) in `b'
	
setx l.foreign `a' l.unemploy 3.2  l.foreignunemp `a'*3.2  dforeignunemp 0.25*0.13   l.index 1  l.foreignindex `a'*1   dforeignindex 0.25*0.52  lfui `a'*3.2*1  dfui 0.25*0.13*0.52  ///
	 (l.welfarexpper l.index  d.foreign  d.unemploy d.index d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap  d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///				   
				   
simqi_pcse, ev genev(p4)        
	_pctile p4, p(5, 50, 95)      
	display `a'
	replace luli_lower = r(r1) in `b'   
	replace luli_mean = r(r2) in `b'  
	replace luli_upper = r(r3) in `b'	
		
	replace vectaxis = `a' in `b'      
	drop p1
	drop p2
	drop p3
	drop p4
	local a = `a' + 1           
	local b=`b'+ 1          
}
*****

*Figure 4 (A)
twoway (rcap huhi_low huhi_upper vectaxis, lcolor(gs2)) /*
	   */ (line huhi_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-0.3(0.1)0.6,labsize(small)) /*
       */ xtitle("Foreign-born Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Bleak Job Market and Inclusive Policy" 2 "Mean Prediction, States with A Bleak Job Market and Inclusive Policy") /*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(huhi, replace)
	   
*Figure 4 (B)
twoway (rcap huli_low huli_upper vectaxis, lcolor(gs2)) /*
	   */ (line huli_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-0.3(0.1)1.4,  labsize(small)) /*
       */ xtitle("Foreign-born Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Bleak Job Market and Exclusive Policy" 2 "Mean Prediction, States with A Bleak Job Market and Exclusive Policy") /*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(huli, replace)
	   

*Figure 4 (C)
twoway (rcap luhi_low luhi_upper vectaxis, lcolor(gs2)) /*
	   */ (line luhi_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-0.6(0.1)0.6,labsize(small)) /*
       */ xtitle("Foreign Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Good Job Markets and Inclusive Policy" 2 "Mean Prediction, States with A Good Job Markets and Inclusive Policy")/*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(luhi, replace)

*Figure 4 (D)
twoway (rcap luli_low luli_upper vectaxis, lcolor(gs2)) /*
	   */ (line luli_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-.8(0.1).8,labsize(small)) /*
       */ xtitle("Foreign Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Good Job Market and Exclusive Policy" 2 "Mean Prediction, States with A Good Job Markets and Exclusive Policy") /*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(luli, replace)

drop b1-b32
drop b33- vectaxis
drop p1 p2
drop esample


     
*******************************************************************************
*                                                                             *
*                Do File for the Supplemental Information                     *
*                                                                             *
******************************************************************************* 

     
*---------------------1.(1) OLS, Fixed Effects and Random Effects Model Diagnostics-------------------------*
** use dataset "Xu 2016 data.dta"
** Figure 1
xtset statenm year
xtline welfarexpper if year<2010&year>1998

** Table 1
reg welfarexpper foreign unemploy index inst6010_adacope lib union flabforce pblack dpercap000 gdpercap gini_faminc1 poverty
xtreg welfarexpper foreign unemploy index inst6010_adacope lib union flabforce pblack dpercap000 gdpercap gini_faminc1 poverty i.state
xtreg welfarexpper foreign unemploy index inst6010_adacope lib union flabforce pblack dpercap000 gdpercap gini_faminc1 poverty,re

** Diagnoses numbers reported in section 1(1)
xtreg welfarexpper foreign unemploy index inst6010_adacope lib union flabforce pblack dpercap000 gdpercap gini_faminc1 poverty,fe 
est store fe
xtreg welfarexpper foreign unemploy index inst6010_adacope lib union flabforce pblack dpercap000 gdpercap gini_faminc1 poverty,re
est store re
hausman fe 


*---------------------1. (2) Stionary and Cointegration Tests-------------------------*
* check the stationarity of DV, turns out that welfarexpper is non-stationary.
xtunitroot fisher welfarexpper, dfuller lag(0)
xtunitroot fisher welfarexpper, dfuller lag(1)
xtunitroot fisher welfarexpper, dfuller lag(2)
xtunitroot fisher welfarexpper, dfuller lag(0) trend
xtunitroot fisher welfarexpper, dfuller lag(1) trend
xtunitroot fisher welfarexpper, dfuller lag(2) trend

* check cointegration by using xtwest 
help xtwest
*install xtwest.ado file
xtset state year
xtwest welfarexpper index, lags(1 1) constant trend
xtwest welfarexpper unemploy, lags(1 3) leads(0 3) lrwindow(3) constant trend


*---------------------1. (3) Characteristics of the error term-------------------------*
reg welfarexpper foreign unemploy index inst6010_adacope lib union flabforce pblack dpercap000 gdpercap gini_faminc1 poverty
hettest

xtreg welfarexpper foreign unemploy index inst6010_adacope lib union flabforce pblack dpercap000 gdpercap gini_faminc1 poverty, fe
findit xttest3
*click st0004.pkg to install xttest3.ado file
xttest3
findit xtcsd
*click st0113.pkg to install xtcsd.ado file
xtcsd, frees 
findit xtserial
*click st0039 to install xtserial.ado file
xtserial welfarexpper foreign unemploy index inst6010_adacope lib union flabforce pblack dpercap000 gdpercap gini_faminc1 poverty 
xtset state year
gen dwelfarexpper=d.welfarexpper
xtserial dwelfarexpper foreign unemploy index inst6010_adacope lib union flabforce pblack dpercap000 gdpercap gini_faminc1 poverty 


*---------------------2. TANF Cash Benefits as an Alternative DV-------------------------*
xtpcse  d. benefit l.benefit  d.foreign l.foreign  d.index l.index dforeignindex  l.foreignindex  d.unemploy l.unemploy dforeignunemp l.foreignunemp dfui lfui  d.inst6010_adacope l.inst6010_adacope  ///
d.lib l.lib d.union l.union d.flabforce l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap  d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty


*---------------------3. Conditional Effect Figures by Setting Policy and Unemployment at Different Levels-------------------------*
xtset state year
xtpcse  d.welfarexpper l.welfarexpper  d.foreign l.foreign  d.index l.index dforeignindex  l.foreignindex  d.unemploy l.unemploy dforeignunemp l.foreignunemp dfui lfui  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce ///
l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty
gen esample=e(sample)
su l.index if esample==1, detail
*  (mean-/+ SD: 3.04; 7.19)  (10% 90%: 1; 7)  (25% 75%: 4; 7)  
su l.unemploy if esample==1, detail
*  (mean-/+ SD: 3.55; 5.83)  (10% 90%: 3.2; 6.2)  (25% 75%: 3.8; 5.5)  

*---------------------3.1. Set Policy and Unemployment at Mean-Standard Deviation and Mean + Standard Deviation------------------------*
** Note: in order to use the estsimp_pcse and simqi_pcse commands to generate figure 4, please (1) use stata 12; (2)install the following two ado files (available with the replication data package): estsimp_pcse.ado   simqi_pcse.ado
estsimp_pcse xtpcse  d.welfarexpper l.welfarexpper  d.foreign l.foreign  d.index l.index dforeignindex  l.foreignindex  d.unemploy l.unemploy dforeignunemp l.foreignunemp dfui lfui  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce ///
l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty
generate huhi_lower = .   
generate huhi_upper = .
generate huhi_mean=.
generate huli_lower = .
generate huli_upper = .
generate huli_mean =.
generate luhi_lower = .   
generate luhi_upper = .
generate luhi_mean=.
generate luli_lower = .
generate luli_upper = .
generate luli_mean =.

generate vectaxis = .  

recast float vectaxis  	   
local a=0
local b=1							 
while `a' <= 34{                            
setx l.foreign `a' l.unemploy 5.83 l.foreignunemp `a'*5.83  dforeignunemp 0.25*0.13  l.index 7.19  l.foreignindex `a'*7.19   dforeignindex 0.25*0.52  lfui `a'*5.83*7.19  dfui 0.25*0.13*0.52  ///
	 (l.welfarexpper  d.foreign  d.unemploy  d.index d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///
                              					   
simqi_pcse, ev genev(p1)       
	_pctile p1, p(5, 50, 95)       
	display `a'
	replace huhi_lower = r(r1) in `b'   
	replace huhi_mean = r(r2) in `b'  
	replace huhi_upper = r(r3) in `b'  
	
setx l.foreign `a' l.unemploy 5.83  l.foreignunemp `a'*5.83  dforeignunemp 0.25*0.13  l.index 3.04  l.foreignindex `a'*3.04   dforeignindex 0.25*0.52  lfui `a'*5.83*3.04  dfui 0.25*0.13*0.52   ///
	 (l.welfarexpper  d.foreign  d.unemploy d.index  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///

simqi_pcse, ev genev(p2)   
_pctile p2, p(5, 50, 95)      
	display `a'
	replace huli_lower = r(r1) in `b'   
	replace huli_mean = r(r2) in `b'  
	replace huli_upper = r(r3) in `b'
	
	  
setx l.foreign `a' l.unemploy 3.55  l.foreignunemp `a'*3.55  dforeignunemp 0.25*0.13   l.index 7.19  l.foreignindex `a'*7.19   dforeignindex 0.25*0.52  lfui `a'*3.55*7.19  dfui 0.25*0.13*0.52  ///
	 (l.welfarexpper l.index  d.foreign  d.unemploy d.index  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///				   
				   
simqi_pcse, ev genev(p3)        
	_pctile p3, p(5, 50, 95)       
	display `a'
	replace luhi_lower = r(r1) in `b'   
	replace luhi_mean = r(r2) in `b'  
	replace luhi_upper = r(r3) in `b'
	
setx l.foreign `a' l.unemploy 3.55  l.foreignunemp `a'*3.55  dforeignunemp 0.25*0.13   l.index 3.04  l.foreignindex `a'*3.04   dforeignindex 0.25*0.52  lfui `a'*3.55*3.04  dfui 0.25*0.13*0.52  ///
	 (l.welfarexpper l.index  d.foreign  d.unemploy d.index d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///				   
				   
simqi_pcse, ev genev(p4)        
	_pctile p4, p(5, 50, 95)      
	display `a'
	replace luli_lower = r(r1) in `b'   
	replace luli_mean = r(r2) in `b'  
	replace luli_upper = r(r3) in `b'	
		
	replace vectaxis = `a' in `b'      
	drop p1
	drop p2
	drop p3
	drop p4
	local a = `a' + 1           
	local b=`b'+ 1          
}
***** The commands below generate Figure 2 in the SI
*Figure 2 (a) 
twoway (rcap huhi_low huhi_upper vectaxis, lcolor(gs2)) /*
	   */ (line huhi_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-0.3(0.1)0.6,labsize(small)) /*
       */ xtitle("Foreign-born Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Bleak Job Market and Inclusive Policy" 2 "Mean Prediction, States with A Bleak Job Market and Inclusive Policy") /*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(huhi, replace)
	   
*Figure 2 (b) 	   
twoway (rcap huli_low huli_upper vectaxis, lcolor(gs2)) /*
	   */ (line huli_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-0.3(0.1)1.4,  labsize(small)) /*
       */ xtitle("Foreign-born Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Bleak Job Market and Exclusive Policy" 2 "Mean Prediction, States with A Bleak Job Market and Exclusive Policy") /*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(huli, replace)

*Figure 2 (c) 
twoway (rcap luhi_low luhi_upper vectaxis, lcolor(gs2)) /*
	   */ (line luhi_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-0.6(0.1)0.6,labsize(small)) /*
       */ xtitle("Foreign Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Good Job Markets and Inclusive Policy" 2 "Mean Prediction, States with A Good Job Markets and Inclusive Policy")/*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(luhi, replace)

*Figure 2 (d)   
twoway (rcap luli_low luli_upper vectaxis, lcolor(gs2)) /*
	   */ (line luli_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-.8(0.1).8,labsize(small)) /*
       */ xtitle("Foreign Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Good Job Market and Exclusive Policy" 2 "Mean Prediction, States with A Good Job Markets and Exclusive Policy") /*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(luli, replace)

drop b1-b32
drop b33- vectaxis

*---------------------3.2. Set Policy and Unemployment at 25th and 75th percentile values------------------------*
estsimp_pcse xtpcse  d.welfarexpper l.welfarexpper  d.foreign l.foreign  d.index l.index dforeignindex  l.foreignindex  d.unemploy l.unemploy dforeignunemp l.foreignunemp dfui lfui  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce ///
l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty
generate huhi_lower = .   
generate huhi_upper = .
generate huhi_mean=.
generate huli_lower = .
generate huli_upper = .
generate huli_mean =.
generate luhi_lower = .   
generate luhi_upper = .
generate luhi_mean=.
generate luli_lower = .
generate luli_upper = .
generate luli_mean =.
generate vectaxis = .  
recast float vectaxis  	   
local a=0
local b=1							 
while `a' <= 34{                            
setx l.foreign `a' l.unemploy 5.5 l.foreignunemp `a'*5.5  dforeignunemp 0.25*0.13  l.index 7  l.foreignindex `a'*7   dforeignindex 0.25*0.52  lfui `a'*5.5*7  dfui 0.25*0.13*0.52  ///
	 (l.welfarexpper  d.foreign  d.unemploy  d.index d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///
                              					   
simqi_pcse, ev genev(p1)       
	_pctile p1, p(5, 50, 95)       
	display `a'
	replace huhi_lower = r(r1) in `b'   
	replace huhi_mean = r(r2) in `b'  
	replace huhi_upper = r(r3) in `b'  
	
setx l.foreign `a' l.unemploy 5.5  l.foreignunemp `a'*5.5  dforeignunemp 0.25*0.13  l.index 4  l.foreignindex `a'*4   dforeignindex 0.25*0.52  lfui `a'*5.5*4  dfui 0.25*0.13*0.52   ///
	 (l.welfarexpper  d.foreign  d.unemploy d.index  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///

simqi_pcse, ev genev(p2)   
_pctile p2, p(5, 50, 95)      
	display `a'
	replace huli_lower = r(r1) in `b'   
	replace huli_mean = r(r2) in `b'  
	replace huli_upper = r(r3) in `b'
	
	  
setx l.foreign `a' l.unemploy 3.8  l.foreignunemp `a'*3.8  dforeignunemp 0.25*0.13   l.index 7  l.foreignindex `a'*7   dforeignindex 0.25*0.52  lfui `a'*3.8*7  dfui 0.25*0.13*0.52  ///
	 (l.welfarexpper l.index  d.foreign  d.unemploy d.index  d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///				   
				   
simqi_pcse, ev genev(p3)        
	_pctile p3, p(5, 50, 95)       
	display `a'
	replace luhi_lower = r(r1) in `b'   
	replace luhi_mean = r(r2) in `b'  
	replace luhi_upper = r(r3) in `b'
	
setx l.foreign `a' l.unemploy 3.8  l.foreignunemp `a'*3.8  dforeignunemp 0.25*0.13   l.index 4  l.foreignindex `a'*4   dforeignindex 0.25*0.52  lfui `a'*3.8*4  dfui 0.25*0.13*0.52  ///
	 (l.welfarexpper l.index  d.foreign  d.unemploy d.index d.inst6010_adacope l.inst6010_adacope  d.lib l.lib d.union l.union d.flabforce  ///
     l.flabforce  d.pblack l.pblack d.dpercap000 l.dpercap000 d.gdpercap l.gdpercap d.gini_faminc1 l.gini_faminc1 d.poverty l.poverty) mean ///				   
				   
simqi_pcse, ev genev(p4)        
	_pctile p4, p(5, 50, 95)      
	display `a'
	replace luli_lower = r(r1) in `b'   
	replace luli_mean = r(r2) in `b'  
	replace luli_upper = r(r3) in `b'	
		
	replace vectaxis = `a' in `b'      
	drop p1
	drop p2
	drop p3
	drop p4
	local a = `a' + 1           
	local b=`b'+ 1          
}
***** The commands below generate Figure 2 in the SI
*Figure 3 (a)
twoway (rcap huhi_low huhi_upper vectaxis, lcolor(gs2)) /*
	   */ (line huhi_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-0.3(0.1)0.6,labsize(small)) /*
       */ xtitle("Foreign-born Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Bleak Job Market and Inclusive Policy" 2 "Mean Prediction, States with A Bleak Job Market and Inclusive Policy") /*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(huhi, replace)
   
*Figure 3 (b)
twoway (rcap huli_low huli_upper vectaxis, lcolor(gs2)) /*
	   */ (line huli_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-0.3(0.1)1.4,  labsize(small)) /*
       */ xtitle("Foreign-born Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Bleak Job Market and Exclusive Policy" 2 "Mean Prediction, States with A Bleak Job Market and Exclusive Policy") /*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(huli, replace)

*Figure 3 (c)
twoway (rcap luhi_low luhi_upper vectaxis, lcolor(gs2)) /*
	   */ (line luhi_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-0.6(0.1)0.6,labsize(small)) /*
       */ xtitle("Foreign Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Good Job Markets and Inclusive Policy" 2 "Mean Prediction, States with A Good Job Markets and Inclusive Policy")/*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(luhi, replace)

*Figure 3 (d)
twoway (rcap luli_low luli_upper vectaxis, lcolor(gs2)) /*
	   */ (line luli_mean vectaxis, lcolor(gs2)), /*
	   */ ytitle(Predicted Change of % Welfare Spending) /*
       */ ytitle(,size(small)) ylabel(-.8(0.1).8,labsize(small)) /*
       */ xtitle("Foreign Population in Previous Year", size(small)) /*
       */ xlabel(0(2)34, labsize(small))/*
       */ legend(on order(1 "90% CI, States with A Good Job Market and Exclusive Policy" 2 "Mean Prediction, States with A Good Job Markets and Exclusive Policy") /*
       */ size(vsmall) lcolor(black) ring(0) position(2) cols(1)) /* 
       */ yline(0, lpattern(dot) lcolor(red)) /*
       */ graphregion(color(white)) scheme(lean1) xsize(8)  ysize(8) /*
       */ name(luli, replace)
drop b1-b32
drop b33- vectaxis


