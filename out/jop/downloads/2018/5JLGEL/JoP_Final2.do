** Figure 1
*  Figure 1(a)
	  
use "JoP.Final2.dta"

gen party_inc=1 if gwf_party==1 & direction==1
gen party_dec=1 if gwf_party==1 & direction==-1
gen party_count=1 if gwf_party==1

	  
gen mil_inc=1 if gwf_military==1 & direction==1
gen mil_dec=1 if gwf_military==1 & direction==-1
gen mil_count=1 if gwf_military==1

	  
gen mon_inc=1 if gwf_monarchy==1 & direction==1
gen mon_dec=1 if gwf_monarchy==1 & direction==-1
gen mon_count=1 if gwf_monarchy==1

	  
gen per_inc=1 if gwf_personal==1 & direction==1
gen per_dec=1 if gwf_personal==1 & direction==-1
gen per_count=1 if gwf_personal==1

gen increase=1 if direction==1 
gen decrease=1 if direction==-1

drop if gwf_democracy==1|gwf_democracy==.


collapse (count) direction (mean)lvaw_garriga (sum) reform increase decrease party_inc party_dec party_count mil_inc mil_dec ///
         mil_count mon_inc mon_dec mon_count per_inc per_dec per_count, by (yyear)
		 


replace decrease= decrease*(-1)

twoway (bar increase yyear, sort) (bar decrease yyear, sort), ytitle(Number of reforms) ///
		 xtitle(Year) legend(order(1 "Increases" 2 "Decreases")) title(All autocracies)legend (off) graphregion(fcolor (white))

twoway (bar increase yyear, sort) (bar decrease  yyear, sort) (line lvaw_garriga ///
        yyear, sort yaxis(2) lwidth(medthick)), ytitle(Number of reforms) ytitle(CBI sample average, axis(2)) ///
		yscale(range(0(.1).6) axis(2)) xtitle(Year) legend(order(1 "Increases" 2 "Decreases" 3 "CBI") rows (1)) title(All autocracies) graphregion(fcolor (white))
		

*  Figure 1(b)

replace party_dec= party_dec*(-1)
replace mil_dec= mil_dec*(-1)
replace mon_dec= mon_dec*(-1)
replace per_dec= per_dec*(-1)

    
twoway (bar party_inc yyear,fcolor(teal)  barwidth(.75) sort) (bar party_dec  yyear, fcolor(cranberry)  barwidth(.75) sort) (line party_count ///
        yyear, sort yaxis(2) lcolor(black) lwidth(medthick)), ytitle(Number of reforms) ytitle(Number of observations, axis(2)) ///
		yscale(range(0(.1).6) axis(2)) xtitle(Year) legend(order(1 "Increases" 2 "Decreases" 3 "Observations")) title(Dominant party) legend(off) graphregion(fcolor (white))
		
twoway (bar mil_inc yyear,fcolor(teal)  barwidth(.75) sort) (bar mil_dec  yyear, fcolor(cranberry)  barwidth(.75) sort) (line mil_count ///
        yyear, sort yaxis(2) lcolor(black) lwidth(medthick)), ytitle(Number of reforms) ytitle(Number of observations, axis(2)) ///
		yscale(range(-1 (1) 2) axis(1)) yscale(range(-10 (5) 20) axis(2)) xtitle(Year) legend(order(1 "Increases" 2 "Decreases" 3 "Observations")) title(Military) legend(off) graphregion(fcolor (white))
		
twoway (bar mon_inc yyear,fcolor(teal)  barwidth(.75) sort) (bar mon_dec  yyear, fcolor(cranberry)  barwidth(.75) sort) (line mon_count ///
        yyear, sort yaxis(2) lcolor(black) lwidth(medthick)), ytitle(Number of reforms) ytitle(Number of observations, axis(2)) ///
		yscale(range(-1 (1) 2) axis(1)) yscale(range(-6 (4) 12) axis(2)) xtitle(Year) legend(order(1 "Increases" 2 "Decreases" 3 "Observations")) title(Monarchy) graphregion(fcolor (white))
		
twoway (bar per_inc yyear,fcolor(teal)  barwidth(.75) sort) (bar per_dec  yyear, fcolor(cranberry)  barwidth(.75) sort) (line per_count ///
        yyear, sort yaxis(2) lcolor(black) lwidth(medthick)), ytitle(Number of reforms) ytitle(Number of observations, axis(2)) ///
		yscale(range(-2 (1) 4) axis(1)) yscale(range(-15 (5) 30) axis(2)) xtitle(Year) legend(order(1 "Increases" 2 "Decreases" 3 "Observations")) title(Personalist) legend(off) graphregion(fcolor (white))
		
** Figure 2: K Density

* Figure 2a
use "JoP.Final2.dta"

kdensity gwf_duration if gwf_party==1 & gwf_fail[_n+1]==1 

* Figure 2b
kdensity gwf_duration if gwf_party==1 & gwf_fail[_n+1]==1 & lvaw_garriga>0.44, plot (kdensity gwf_duration if gwf_party==1 & gwf_fail[_n+1]==1 & lvaw_garriga<=0.44)

** Table 1
* Model 1
#delimit 
probit gwf_fail l.lvaw_garriga l.gwf_party 
l.log_gdp l.log_pop l.log_oil l.tradeopenness l.neighbor_polity2 year3 year5 year6 year7
year8 year9 year11 year12 year13 year14 year15 year16 year17 year18 year19 year20 year21
year22 year23 year24 year25 year26 year31 year32 year33 year34 year36 time_ab _spline1ab 
_spline2ab _spline3ab eeurope lamerica ssafrica asia if l.gwf_democracy==0, cluster(cow) ; 

#delimit cr; 

* Model 2
#delimit 
probit gwf_fail l.lvaw_garriga l.gwf_party l.lvaw_party  
l.log_gdp l.log_pop l.log_oil l.tradeopenness l.neighbor_polity2 year3 year5 year6 year7
year8 year9 year11 year12 year13 year14 year15 year16 year17 year18 year19 year20 year21
year22 year23 year24 year25 year26 year31 year32 year33 year34 year36 time_ab _spline1ab 
_spline2ab _spline3ab eeurope lamerica ssafrica asia if l.gwf_democracy==0, cluster(cow) ; 

#delimit cr;

* Model 3
#delimit 
probit gwf_fail c.l.lvaw_garriga##c.l.gwf_party 
l.log_gdp l.log_pop l.log_oil l.tradeopenness l.neighbor_polity2 year3 year5 year6 year7
year8 year9 year11 year12 year13 year14 year15 year16 year17 year18 year19 year20 year21
year22 year23 year24 year25 year26 year31 year32 year33 year34 year36 time_ab _spline1ab 
_spline2ab _spline3ab eeurope lamerica ssafrica asia av_tradeopenness av_log_gdp av_log_pop
av_log_oil av_neighbor_polity av_lvaw_party av_gwf_party av_lvaw_garriga if l.gwf_democracy==0,
cluster(cow) ; 

#delimit cr;  

* Figure 3
#delimit 
margins, at(l.gwf_party=1 l.lvaw_garriga=(0(0.1)1)) level(95); 

#delimit cr; 
marginsplot, addplot(histogram lvaw_garriga if gwf_democracy==0, frequency fcolor(none) lcolor(gs11) yscale(alt) yaxis(2)) xlabel(0(0.1)1) ylabel(0.00(.05)0.55) ytitle(Probability of Autocratic Breakdown) xtitle(Central Bank Independence) recast(line) recastci(rconnected) level(95) 

* Model 4
#delimit 
probit gwf_fail l6.lvaw_garriga l.gwf_party  l6_lvaw_party
l.log_gdp l.log_pop l.log_oil l.tradeopenness l.neighbor_polity2 year3 year5 year6 year7
year8 year9 year11 year12 year13 year14 year15 year16 year17 year18 year19 year20 year21
year22 year23 year24 year25 year26 year31 year32 year33 year34 year36 time_ab _spline1ab 
_spline2ab _spline3ab eeurope lamerica ssafrica asia if l.gwf_democracy==0, cluster(cow) ; 

#delimit cr;

* Model 5
#delimit 
ivprobit gwf_fail l.gwf_party 
l.log_gdp l.log_pop l.log_oil l.tradeopenness l.neighbor_polity2 l.neighbor_mean_fail year3 year5 year6 year7
year8 year9 year11 year12 year13 year14 year15 year16 year17 year18 year19 year20 year21
year22 year23 year24 year25 year26 year31 year32 year33 year34 year36 time_ab _spline1ab 
_spline2ab _spline3ab eeurope lamerica ssafrica asia
(l.lvaw_garriga l.lvaw_party = l.neighbor_cbi l.neighbor_cbi_party l6.neighbor_cbi l6.neighbor_cbi_party )  
if l.gwf_democracy==0, vce(cluste cowcode) first ; 

#delimit cr; 

* Model 6
#delimit 
ivreg2 gwf_fail l.gwf_party 
l.log_gdp l.log_pop l.log_oil l.tradeopenness l.neighbor_polity2 l.neighbor_mean_fail year3 year5 year6 year7
year8 year9 year11 year12 year13 year14 year15 year16 year17 year18 year19 year20 year21
year22 year23 year24 year25 year26 year31 year32 year33 year34 year36 time_ab _spline1ab 
_spline2ab _spline3ab eeurope lamerica ssafrica asia (l.lvaw_garriga l.lvaw_party = 
l.neighbor_cbi l.neighbor_cbi_party l6.neighbor_cbi l6.neighbor_cbi_party)  
if l.gwf_democracy==0, gmm2s robust savefirst first ; 

#delimit cr; 

** Table 2
* Model 7
#delimit 
xtreg  fiscal_expenditure l.fiscal_expenditure l.lvaw_garriga l.gwf_party  elections l.gwf_democracy l.gwf_personal 
l.gwf_monarchy l.log_gdp l.gdpgrowth l.oil_gasvaluepercapita_2000 l.kaopen l.tradeopenness l.popover65 l.fixedER year*, cluster(cow) fe; 
#delimit cr; 

* Model 8
#delimit 
xtreg  fiscal_expenditure l.lvaw_garriga l.gwf_party l.lvaw_party l.fiscal_expenditure elections l.gwf_democracy l.lvaw_democracy 
l.gwf_personal l.lvaw_personal 
l.gwf_monarchy l.lvaw_monarchy l.log_gdp l.gdpgrowth l.oil_gasvaluepercapita_2000 l.kaopen l.tradeopenness l.popover65 l.fixedER year*, cluster(cow) fe; 
#delimit cr; 

*Figure 4a: from CBI
use "Party.dta"
drop dydx C_x_xz vardydx sedydx sedydx LBdydx UBdydx
generate dydx =  2.225105 - 5.648294*z
matrix V = get(VCE)
gen C_x_xz = V[3,1]
gen vardydx = (2.00418)^2 + (z*z)*(2.408667)^2+2*z*C_x_xz
generate sedydx=sqrt(vardydx)
gen LBdydx = dydx - invttail(3196, .05)*sedydx
gen UBdydx = dydx + invttail(3196, .05)*sedydx
twoway rcap LBdydx UBdydx z || scatter dydx z 
save "Party.dta", replace

#delimit 
xtreg  fiscal_expenditure l.gwf_party l.lvaw_garriga l.lvaw_party l.fiscal_expenditure elections l.gwf_democracy l.lvaw_democracy 
l.gwf_personal l.lvaw_personal 
l.gwf_monarchy l.lvaw_monarchy l.log_gdp l.gdpgrowth l.oil_gasvaluepercapita_2000 l.kaopen l.tradeopenness l.popover65 l.fixedER year*, cluster(cow) fe; 

#delimit cr; 

*Figure 4b: from party
use "CBI_marginal.dta"
drop dydx C_x_xz vardydx sedydx sedydx LBdydx UBdydx
generate dydx =  2.948213 - 5.648294*z
matrix V = get(VCE)
gen C_x_xz = V[3,1]
gen vardydx = (1.228279)^2 + (z*z)*(2.408667)^2+2*z*C_x_xz
generate sedydx=sqrt(vardydx)
gen LBdydx = dydx - invttail(3196, .05)*sedydx
gen UBdydx = dydx + invttail(3196, .05)*sedydx
graph twoway bar obs z, barwidth(0.1) yaxis(1) || connected dydx LBdydx UBdydx z, yaxis(2) 
save "CBI_marginal.dta", replace



