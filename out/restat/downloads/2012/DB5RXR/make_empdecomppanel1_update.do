The following list of do files produces a plant panel based on Norwegian manufactuing statstics
Containing various variables for the estimation of productivity
A documentation of the manufacturing statistics with variables can be found in 
the pdf document: Indsutristatistikken etter 1995 by Jarle Møen



* 1.
do ${empdecomp}check_entrydefinitions1_update.do
	* Extended to incl. additional years, including 2002-2005
	* Small changes in earlier code to accommodate this.
	* Simplified: cleaning on isic change, drop procedures for 
	* small plants and investment plants.
	* Definitions of reentry simplified
	* Saves 2 datasets: 
	* 1. All plants, years and investment variables:
	* capitalpanel.dta - used to generate capital values in 
	* gen_capital_update.do
	* 2. ${industri}entrycheck_update.dta, from 1990: basic panel for 
	* analysis. Without investment variables.

* 2.
do ${empdecomp}NA_capitaldata.do
	* This do-file reads aggregate capital data for around 60
	* manufactoring sectors (cap_gr)from 1970-2005. Make index
	* with base year 2001 and gen. a deflated measure of
	* sectoral capital. Save in {industri}NAcapitaldata.dta
	* To be merged onto industry data using aar and cap_gr.
	* Correspondence list from NA-sectors to isic at end of file

* 3.
do ${empdecomp}gen_capital_update.do
	* Point of do-file is to generate capital variables based 
	* on investment information in the manufacturing statistics. 
	* Thus avoid using the fire insurance values that disappear
	* in 1996 and thus would create a break in capitalvalues. 
	* One measure only based on investment info, 2 other measures
	* using aggregate capital stock data from National Accounts
	* in the entry year for a plant. Agg. data distributed acc.
	* to employment or energy use.
	* Save deflated capital values in ${industri}k_inv_update.dta. 
	* Can be merged back to the main panel: entrycheck_update.dta
	* Use price index from NA for new investments in machinery, 
	* buildings and transport eq
	* erase capitalpanel.dta made in check_entrydefinitions1_update.do

* 4.
do ${empdecomp}generate_variables_update.do
	* Combination of dropping procedures in check_entrydef2.do
	* (dropping plants with many missing values)
	* and generate_variables.do
	* Previous versions merged in kapitaldatabasen and also a
	* lot of work on other capital variables. Given up on that
	* here. Use only cap. vars based on investment from: 
	* gen_capital_update.do
	* 1. Drop procedures
	* 2. Generate variables, save data
	* 3. Merge in price indexes, for deflating output and input, 
	* Replace entrycheck_update.dta, erase other data files.


* 5. 
do ${empdecomp}productivity_measures_update.do
	* Generate productivity measures, 
	* Save new panel: empdecomppanel1_update 

* 6A.
*do ${empdecomp}levpet_estimation_update.do
	* Levinsohn-Petrin prod fct estimation to obtain a TFP measure
	* Energy share in intermediates is used as instrument
	* justid, 1000 boot strap replications panel from (including) 1990 
	* The levpet estimations is done for different capital measures
	* Saves all levpet residuals in 
	* {industri}tfp_lp_i2_empdecomp_update.dta
	* the levpet measures using hours seem to do best, maybe
	* connected to the issue of rented labour, included here, but not
	* in number of employees measure in next do-file.

* 6B.
*do ${empdecomp}levpet_estimation_employees.do
	* Based on levpet_estimation_update.do
	* Makes just one levpet measure: based on 
	* k3 capital measure, and uses # of employees 
	* instead of hours worked in the plant.
	* Saves residual in {industri}tfp_lp_i2_employees.dta


* 7. 
do ${empdecomp}norwegianMNEdummy.do
	* Based on 2 dofiles from mobility paper, with additional 
	* do file from Sissel Jensen which includes new year files
	* Turns out nothing new in the files from 2003-2005
	* The do file here only saves an MNE dummy in 
	* ${empdecomp}mnedummy and merges this onto
	* ${industri}empdecomppanel1_update.dta, after defining
	* dummy for domestic mnes. Replace *1_update.dta 


* 8.
do ${empdecomp}define_plantgroups.do
	* Some cleaning on change of firm numbers and totstor 
	* (foreign ownership var). 
	* Define x3: 10 categories of plants entry exit survivors
	* dom acq and dom-for acq based on total foreign ownership
	* Define x4, as x3 but based on largest foreign owner.
	* Additional x5 and x6 based on 50% threshold
	* Replace ${industri}empdecomppanel1_update.dta 
	* Compare x3 and x4 with domestic mne definitions.


* 9.
do ${empdecomp}estimate_productivity.do
	* TFP estimations similar to Melitz and Polanec (2008)


* Drop variables not to be used in the following
#delimit ;
drop  initialn initialN indirutenl stindirutenl stutenl utenl 
tfp1_rel tfp1_rel50 tfp1_relcrs tfp2_rel tfp2_rel50 
tfp2_relcrs tfp3_rel tfp3_rel50 tfp3_relcrs tfp_harrk1 tfp_harrk1_emp 
tfp_harrk2 tfp_harrk2_emp MNE20 dommne50 dommne_stor formne_stor entrycount exitcount;
#delimit cr
sort bnr aar
save ${industri}empdecomppanel1_update.dta, replace
