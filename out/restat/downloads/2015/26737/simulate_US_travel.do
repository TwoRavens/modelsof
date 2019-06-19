*Code to simulate US elasticities of travel w.r.t xrate
*Goal is to use US driving distance and population by census tract, along with
*estimates model coefficients (derived using Canadian data) to calculate implied elasticities
*Written by AC. Started May 23, 2012
 
clear all
set more off
tempfile temp1 temp2
*set directory to \data

use ITS_regdata, clear
keep if sameday==1
gen log_rer=log(rer)
gen log_drive_dist = ln(dd_min_wtmed)
*use real prices of gas and real incomes (2002 cnst cad)
replace lpg = lpg - ln(cpi_ca/100)
replace lnW = lnW - ln(cpi_ca/100)
gen post911=(year>2001 | (year==2001 & month>8))

************ FIRST USING CANADIAN CENSUS-DIVISION DISTANCES AND POPULATION **************

*Working with the specification of column 1 of Table 6 in the paper.
glm cross_prob log_rer c.log_rer#c.log_rer log_drive_dist i.month ///
, vce(cluster cd_id) family(binomial) link(probit) 
mat b1=e(b)
mat mthfes1=b1[1,4..15] //jan is 1st element, equal to zero
predict cross_prob_predicted
gen cars_col1=cross_prob_predicted*pop_for_depvar*car_own_rate*30
*Now we want the prediction when the loonie is 10% stronger
predict xb_col1, xb
gen shock=-log(1.1)*b1[1,1] + (log(1.1)^2)*b1[1,2]-2*log(1.1)*log_rer*b1[1,2]
gen xb_col1_new=xb_col1+shock
sum shock xb_col1_new
gen cross_prob_counter=normal(xb_col1_new)
gen cars_counter_col1=cross_prob_counter*pop_for_depvar*car_own_rate*30
drop shock cross_prob_counter cross_prob_predicted xb_col1 xb_col1_new

*Now working with the specification of column 2 (add gas price, income) 
glm cross_prob log_rer c.log_rer#c.log_rer log_drive_dist lpg lnW i.month  ///
, vce(cluster cd_id) family(binomial) link(probit)
mat b2=e(b)
mat mthfes2=b2[1,6..17] //jan is 1st element, equal to zero
predict cross_prob_predicted
gen cars_col2=cross_prob_predicted*pop_for_depvar*car_own_rate*30
*Now we want the prediction when the loonie is 10% stronger
predict xb_col2, xb
gen shock=-log(1.1)*b2[1,1] + (log(1.1)^2)*b2[1,2]-2*log(1.1)*log_rer*b2[1,2]
gen xb_col2_new=xb_col2+shock
sum shock xb_col2_new
gen cross_prob_counter=normal(xb_col2_new)
gen cars_counter_col2=cross_prob_counter*pop_for_depvar*car_own_rate*30
drop shock cross_prob_counter cross_prob_predicted xb_col2 xb_col2_new

*Now working with the spec. of column 3 (add prov FEs, post-911)
glm cross_prob log_rer c.log_rer#c.log_rer log_drive_dist lpg lnW post911 ///
ib59.prov_id i.month , vce(cluster cd_id) family(binomial) link(probit)
mat b3=e(b)
mat provfes=b3[1,7..13] //east to west, BC is last element and equal to zero
mat mthfes3=b3[1,14..25] //jan is 1st element, equal to zero
predict cross_prob_predicted
gen cars_col3=cross_prob_predicted*pop_for_depvar*car_own_rate*30
*Now we want the prediction when the loonie is 10% stronger
predict xb_col3, xb
gen shock=-log(1.1)*b3[1,1] + (log(1.1)^2)*b3[1,2]-2*log(1.1)*log_rer*b3[1,2]
gen xb_col3_new=xb_col3+shock
sum shock xb_col3_new
gen cross_prob_counter=normal(xb_col3_new)
gen cars_counter_col3=cross_prob_counter*pop_for_depvar*car_own_rate*30
drop shock cross_prob_counter cross_prob_predicted xb_col3 xb_col3_new



collapse (sum) cars_col1 cars_counter_col1 cars_col2 cars_counter_col2 cars_col3 cars_counter_col3 (mean) rer, by(year)
gen pct_change_col1=(cars_counter_col1-cars_col1)/cars_col1*100
gen pct_change_col2=(cars_counter_col2-cars_col2)/cars_col2*100
gen pct_change_col3=(cars_counter_col3-cars_col3)/cars_col3*100
qui log using US_simulation.txt, text replace
table year if (year==2002|year==2005|year==2010), c(mean pct_change_col1 mean pct_change_col2 mean pct_change_col3) format(%9.2f)
qui log off

***************** NOW USING US CENSUS TRACT DISTANCES AND POPULATION ****************
clear
tempfile temp1

insheet using driving_distancesUS_ctracts.csv, clear

gen prov1= (port_prov=="NB")
gen prov2= (port_prov=="QP")
gen prov3= (port_prov=="ON")
gen prov4= (port_prov=="MB")
gen prov5= (port_prov=="SK")
gen prov6= (port_prov=="AB")
*no need for a BC dummy since its coefficient is zero

gen prov_id=59
replace prov_id=13 if (port_prov=="NB")
replace prov_id=24 if (port_prov=="QP")
replace prov_id=35 if (port_prov=="ON")
replace prov_id=46 if (port_prov=="MB")
replace prov_id=47 if (port_prov=="SK")
replace prov_id=48 if (port_prov=="AB")

drop if ctract_port_driv_dist>200 //drop if driving dist>200 km
drop if ctract_port_euc_dist> ctract_port_driv_dist

rename ctract_id id
rename ctract_port_driv_dist drivedist
rename ctract_port_driv_time  drivetime
rename ctract_pop_2000 pop
 
keep id drivedist pop prov*
gen ln_dist=ln(drivedist)
drop drivedist
sort prov_id
save `temp1'

*getting a rer dataset for each month in 1990-2010
use ITS_regdata, clear
keep if sameday==1
gen log_rer=log(rer)
replace lpg = lpg - ln(cpi_ca/100)
replace lnW = lnW - ln(cpi_ca/100)
collapse (mean) car_own_rate log_rer lpg lnW, by(year month prov_id)
gen post911=(year>2001 | (year==2001 & month>8))
sort prov_id year month

joinby prov_id using `temp1'
ta month, gen(m)
drop month m1

gen xb_col3_provfe=0
forvalues prov=1/6 {
replace xb_col3_provfe=xb_col3_provfe+ provfes[1,`prov']*prov`prov'
}

gen xb_col1_part1=b1[1,1]*log_rer + b1[1,2]*log_rer*log_rer + b1[1,3]*ln_dist + b1[1,16]
gen xb_col2_part1=b2[1,1]*log_rer + b2[1,2]*log_rer*log_rer + b2[1,3]*ln_dist + b2[1,4]*lpg + b2[1,5]*lnW +b2[1,18]
gen xb_col3_part1=b3[1,1]*log_rer + b3[1,2]*log_rer*log_rer + b3[1,3]*ln_dist + b3[1,4]*lpg + b3[1,5]*lnW +b3[1,6]*post911 ///
+ b3[1,26] + xb_col3_provfe

forvalues i=1/3 {
gen xb_col`i'_monthfe=0
forvalues mth=2/12 {
replace xb_col`i'_monthfe=xb_col`i'_monthfe+ mthfes`i'[1,`mth']*m`mth'
}
gen xb_col`i'=xb_col`i'_part1+xb_col`i'_monthfe
drop xb_col`i'_part1 xb_col`i'_monthfe
gen cross_prob_col`i'=normal(xb_col`i')

*Now getting prediction when loonie is 10% stronger. New rer is old rer divided by 1.1
*Generating the shock term
gen shock_col`i'=-log(1.1)*b`i'[1,1] + (log(1.1)^2)*b`i'[1,2]-2*log(1.1)*log_rer*b`i'[1,2]
gen xb_col`i'_new=xb_col`i'+shock_col`i'
gen cross_prob_counter_col`i'=normal(xb_col`i'_new)

gen cars_predicted_col`i'=cross_prob_col`i'*pop*car_own_rate*30
gen cars_counter_col`i'=cross_prob_counter_col`i'*pop*car_own_rate*30
}

*Doing the country as a whole
preserve
collapse (sum) cars_predicted_col1 cars_counter_col1 cars_predicted_col2 cars_counter_col2 cars_predicted_col3 cars_counter_col3, by(year)
gen pct_change_col1=(cars_counter_col1-cars_predicted_col1)/cars_predicted_col1*100
gen pct_change_col2=(cars_counter_col2-cars_predicted_col2)/cars_predicted_col2*100
gen pct_change_col3=(cars_counter_col3-cars_predicted_col3)/cars_predicted_col3*100

qui log on
table year if (year==2002|year==2005|year==2010), c(mean pct_change_col1 mean pct_change_col2 mean pct_change_col3) format(%9.2f)
qui log off
log close
restore

