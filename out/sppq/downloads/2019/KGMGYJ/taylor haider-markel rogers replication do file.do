
use "C:\taylor haider markel rogers replication dataset.dta", clear


*TABLE REPLICATION

*CREATE TABLE 1
*Table 1 provides a cross section of per capita asset and revenue data from both datasets (which are contained in the single replication file). Table 1 presents the figures in dollars (rounded).
use "taylor haider markel rogers replication dataset", clear
list State realastpercap_smallno234 realincpercap_smallno234 realastpercapall realincpercapall if Year==2015, mean

*CREATE TABLE 2
*Table 2 provides a correlation analysis.
use "taylor haider markel rogers replication dataset", clear
corr sqrt_smallassetsperk sqrt_realperkrevsmal sqrt_realperkassetslarge sqrt_realperkincall sphh2varying2per percentlgbtcomp2per

*CREATE TABLE 3
*Table 3 provides the results from a cross-sectional regression analysis with a dependent variable derived from the Human Rights Campaign's 2015 State Equality Index. 
*We will need to transform our time series data by using the mean values. 
*Because the ideology measures from Fording (2015) are extrapolated beyond 2013 for citizen ideology and 2015 for the nominate ideology measure, we change that state/year data to missing values prior to computing mean ideology measures for those two variables.
use "taylor haider markel rogers replication dataset", clear
replace citi6013=. if Year==2014
replace citi6013=. if Year==2015
replace inst6014_nom=. if Year==2015
*Collapse data to the means
collapse (mean) citi6013 inst6014_nom realastpercap_smallno234 realastpercapall realincpercap_smallno234 realincpercapall evangldsper south directdem hrc2015indexgood jobslax percapitaincome1995dol, by (State)
*Generate square root variables
gen sqrt_perkassets_small=sqrt(realastpercap_smallno234)
gen  sqrt_perkassets_large=sqrt(realastpercapall)
gen sqrt_perkrev_small=sqrt(realincpercap_smallno234)
gen sqrt_perkrev_large=sqrt(realincpercapall)
*Regression models
regress hrc2015indexgood sqrt_perkassets_small citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome, robust
regress hrc2015indexgood sqrt_perkassets_large citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome, robust
regress hrc2015indexgood sqrt_perkrev_small citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome, robust
regress hrc2015indexgood sqrt_perkrev_large citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome, robust
*Save file to create Table A1
save "taylor haider-markel and rogers table a1 replication.dta"

*CREATE TABLE A1
use "taylor haider-markel and rogers table a1 replication.dta", clear
*Following replication of Table 3, we check how sensitive the results are to the presence of an outlier. 
*Using the dataset saved after completion of Table 3 replication, we drop Colorado and then rerun the analyses from Table 3. 
drop if State=="Colorado"
regress hrc2015indexgood sqrt_perkassets_small citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome, robust
regress hrc2015indexgood sqrt_perkassets_large citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome, robust
regress hrc2015indexgood sqrt_perkrev_small citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome, robust
regress hrc2015indexgood sqrt_perkrev_large citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome, robust

*CREATE TABLE 4
*Table 4 provides an event history analysis where the dependent variable passage of a gay inclusive employment nondiscrimination law.
use "taylor haider markel rogers replication dataset", clear
stset Year, id(State) failure(gayempnondisc==1) origin(Year==1995)
stcox sqrt_smallassetsperk citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome1995dol gayempdiff
stcox sqrt_realperkassetslarge citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome1995dol gayempdiff
stcox sqrt_realperkrevsmal citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome1995dol gayempdiff
stcox sqrt_realperkincall citi6013 inst6014_nom directdem south evangldsper jobslax percapitaincome1995dol gayempdiff

use "C:\taylor haider markel rogers replication dataset.dta", clear

*FIGURES 1-3 REPLICATION to create data used for maps in figures
*Figures 1 and 2 are derived from time series variables for real per capita group assets and real per capita group revenue (both from the small dataset) that are transformed by taking the square root of the mean for each.  
*CREATE DATA FOR FIGURE 1 (sqrt_perkassets_small)
preserve
collapse (mean) realastpercap_smallno234, by (State)
gen sqrt_perkassets_small= sqrt(realastpercap_smallno234)
restore

*CREATE DATA FOR FIGURE 2(sqrtincome_small)
preserve
collapse (mean) realincpercap_smallno234, by (State)
gen sqrtincome_small=sqrt(realincpercap_smallno234)
restore

*CREATE DATA FOR FIGURE 3
preserve 
collapse (mean) ssphh2010per, by (State)
restore
*Note: Because same-sex partner households from the 2010 census was kept constant in the dataset, one can either collapse the data at the mean or copy and paste from any given year.

Created data can then be used in other software to create maps





