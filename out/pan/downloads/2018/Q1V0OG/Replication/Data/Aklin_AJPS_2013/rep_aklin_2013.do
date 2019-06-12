clear all
set more off


cd "~/Dropbox (MIT)/interaction paper/Data/Included/Aklin_AJPS_2013/" 
use "AklinUrpelainenPositive_coded.dta", clear

*	************************************************************************
* 	3. Analysis
*		Table 2
*		Claims made in the main text
*	************************************************************************

*	************************************************************************
* 	Table 1
*	************************************************************************

xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year

xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year year_dummy*

/* model (3) is the key*/
xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share

keep if e(sample)==1
saveold rep_aklin_2013.dta, replace

/*
xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share year_dummy*

xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share gdpcapk kg ki openk income_growth

xtpcse drenew_capacity_nh_share left_to_right right_to_left linnovation_x_oil oilcrude_price2007dollar_bp lrenewpc left_executive right_executive election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share gdpcapk kg ki openk income_growth year_dummy*
*/

*	************************************************************************
* 	B. Marginal Effects. Based on Brambor et al (2006)'s code.
*	************************************************************************

*	************************************************************************
* 	i. Simulation for Model (3)
*	************************************************************************

xtset ccode year

*	1. Running Model (1)
xtpcse drenew_capacity_nh_share lrenewpc oilcrude_price2007dollar_bp linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share

*	2. Generating the range of the modifying variable (here oil price, from 0 to 100)
generate MV=((_n-1))
replace  MV=. if _n>100

*	3. Capturing the matrices (coefficient and VC matrix) to get the estimates
matrix b=e(b)
matrix V=e(V)
 
*	4. Getting the coefficient of interest
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

*	5. Getting the variance of interest (remember: these are the variance, while
*		the regression table shows the s.e. (i.e. the root of the variance)
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]

*	6. Getting the covariance
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

*	7. Listing the coefficients/variance/covariance to check that everything corresponds
*		to the regression output
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*	8. Estimating the marginal effect
gen conb=b1+b3*MV if _n<100

*	9. Estimating the standard error of the marginal effect
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<100

*	10. Generating the confidence interval for 95%
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

*	11. Graphing
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ||,  yscale(noline) xscale(noline) legend(col(1) order(1 2) label(1 "Marginal Effect of Positive Reinf.") label(2 "95% Confidence Interval") label(3 " ")) yline(0, lcolor(black)) title("Marginal Effect of Pos. Reinf.", size(4)) subtitle(" " "Dependent Variable: Renewable Share (First Diff.)" " ", size(3)) xtitle( "Oil Prices", size(3)  ) xsca(titlegap(2)) ysca(titlegap(2)) ytitle("Marginal Effect of Positive Reinforcement", size(3)) scheme(s2mono) graphregion(fcolor(white)) saving(graph3, replace)
graph export "graph3.pdf", replace as(pdf)

*	12. Dropping the newly created variables
drop MV conb conse a upper lower


*	************************************************************************
* 	ii. Simulation for Model (4), oil and innovation inversed
*	************************************************************************

xtset ccode year

*	1. Running Model (1)
xtpcse drenew_capacity_nh_share oilcrude_price2007dollar_bp lrenewpc linnovation_x_oil left_executive right_executive left_to_right right_to_left election_year renewablecapacity_3yr_average hydronuclear_3yr year traditional_electricity_share


*	2. Generating the range of the modifying variable (here innovations; now,
*		innovation goes to 10, but the vast majority is at 1 and below - 
*		the variable is innovation per 1m people). Hence, I bound it at 1.
generate MV=((_n-1)/10)
replace  MV=. if _n>30

*	3. Capturing the matrices (coefficient and VC matrix) to get the estimates
matrix b=e(b)
matrix V=e(V)
 
*	4. Getting the coefficient of interest
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

*	5. Getting the variance of interest (remember: these are the variance, while
*		the regression table shows the s.e. (i.e. the root of the variance)
scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]

*	6. Getting the covariance
scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

*	7. Listing the coefficients/variance/covariance to check that everything corresponds
*		to the regression output
scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

*	8. Estimating the marginal effect
gen conb=b1+b3*MV if _n<30

*	9. Estimating the standard error of the marginal effect
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<30

*	10. Generating the confidence interval for 95%
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

*	11. Graphing
graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black) ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black) ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black) ||,  yscale(noline) xscale(noline) legend(col(1) order(1 2) label(1 "Marginal Effect of Intern. Shocks") label(2 "95% Confidence Interval") label(3 " ")) yline(0, lcolor(black)) title("Marginal Effect of Intern. Shocks (Oil Prices)", size(4)) subtitle(" " "Dependent Variable: Renewable Share (First Diff.)" " ", size(3)) xtitle( "Positive Reinforcement (Innovations per m.)", size(3)  ) xsca(titlegap(2)) ysca(titlegap(2)) ytitle("Marginal Effect of International Shock (Oil Prices)", size(3)) scheme(s2mono) graphregion(fcolor(white))  saving(graph4, replace)
graph export "graph4.pdf", replace as(pdf)

