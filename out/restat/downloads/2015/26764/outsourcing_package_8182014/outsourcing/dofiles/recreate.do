
global masterpath "PATH TO BE INSERTED HERE" //insert path for outsourcing folder


********************
* Computer use rate
********************

do computeruse.do

*************************************************************************
* CPS preparation file (this creates extracts but only run on our server)
*************************************************************************
*do morg_data.do

********************
* Trade data
********************

do trade_data.do

********************
* CEW data
********************

do cew_data.do

******************************************************
* Analyze premiums and create industry-level averages 
******************************************************

do premium_man7090.do
do premium_ind7090.do
do premium_educ_man7090.do

***************************************************
* Merge individual data from CPS with industry info 
***************************************************

do merge_data_ind7090.do
do merge_data_man7090.do
do merge_data_educ_man7090.do

********************
* Prices by industry 
********************

do concordance
capture noisily do prices_man7090		
capture noisily do premium_occ8090_mfg	
capture noisily do premium_occ8090_all

capture noisily do premium_prices_1digit
capture noisily do premium_prices_2digit
capture noisily do premium_prices_3digit
*do price_data_all

****************************
* Main occupational data set 
****************************

capture noisily do offshore_exposure.do

capture noisily do match_madrian.do

  
capture noisily do figure1data
capture noisily do figure_wageprem
* where did we make scatter_penmod?

capture noisily do table1_r1.do
capture noisily do table2_ind_r1.do
capture noisily do table2_occ_r1.do
capture noisily do table3_r1.do
capture noisily do table4_ind_r1.do
capture noisily do table4_occ_r1.do

capture noisily do table5_r1.do
capture noisily do table6_r1.do
// capture noisily do table7_occ_prems.do
// capture noisily do table7_r1.do
capture noisily do apptable1


