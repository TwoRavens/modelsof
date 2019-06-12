******************************************************************************************************                                                                  *
*    National Policies and Transnational Governance of Climate Change: Substitutes or Complements?   * 
*							Liliana Andonova, Thomas Hale & Charles Roger   				         *                  *
*						            International Studies Quarterly									 *
*																									 *	
*	                                   ***Replication File***                                        *
****************************************************************************************************** 

set more off 

use "AHR TCG data ISQ.dta"

******Figure 1: Crossnational Participation in Transnational Climate Governance in 2012

*ssc install spmap
*ssc install shp2dta 
*download and extract http://thematicmapping.org/downloads/TM_WORLD_BORDERS-0.3.zip

shp2dta using TM_WORLD_BORDERS-0.3.shp, database(worldmap) coordinates(worldcoord) genid(id)
merge 1:1 id using worldmap.dta
spmap tcg using worldcoord.dta, id(id) fcolor(Blues) clmethod(custom) clbreaks(0 1 50 100 500 1000 2000 3000)

******Table 1: Descriptive Statistics

sum tcg tcgadj tcghi tcglo federal civil_lib epiclimate iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions voice_acc pol_rights polity epi pollution greenaid fdi gdp 

******Table 2: Regression Results (Negative Binomial)

*Model 1 (TCG)
nbreg tcg civil_lib federal epiclimate iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions

*Model 2 (TCG Adjusted)
nbreg tcgadj civil_lib federal epiclimate iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions

*Model 3 (TCG High Civil Liberties)
nbreg tcghi federal epiclimate iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions

*Model 4 (TCG Low Civil Liberties)
nbreg tcglo federal epiclimate iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions

 
******Table 3: Alternative Specifications of the Baseline Model (Negative Binomial)

*Model 1 (Substituting Air Pollution Variable)
nbreg tcg civil_lib federal iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions pollution

*Model 2 (Substituting Environmental Performance Index, EPI)
nbreg tcg civil_lib federal iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions epi

*Model 3 (Substituting Polity)
nbreg tcg federal epiclimate iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions polity

*Model 4 (Substituting Voice and Accountability Variable)
nbreg tcg federal epiclimate iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions voice_acc

*Model 5 (Substituting Political Rights Variable)
nbreg tcg federal epiclimate iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions pol_rights

*Model 6 (Substituting Gross Domestic Product, GDP)
nbreg tcg civil_lib federal epiclimate iea_rats gdp_pc itrade iso14001 ngo_number gdp

*Model 7 (Adding Foreign Direct Investment, FDI)
nbreg tcg civil_lib federal epiclimate iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions fdi

*Model 8 (Adding Green Aid Variable)
nbreg tcg civil_lib federal epiclimate iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions greenaid



**************Appendix**************

******Table 4: Correlation Matrix

mkcorr civil_lib federal epiclimate iea_rats itrade iso14001 ngo_number gdp_pc co2_emissions, log(corrtable.xls) replace

******Table 5: Collinearity Diagnostics

collin civil_lib federal epiclimate iea_rats itrade iso14001 ngo_number gdp_pc co2_emissions

******Table 6: Alternative Specifications of Split-Sample Models (Negative Binomial)

*Model 1 (TCG High Civil Liberties, with EPI Variable)
nbreg tcghi federal iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions epi

*Model 2 (TCG Low Civil Liberties, with EPI Variable)
nbreg tcglo federal iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions epi

*Model 3 (TCG High Civil Liberties, with Air Pollution Variable)
nbreg tcghi federal iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions pollution

*Model 4 (TCG Low Civil Liberties, with Air Pollution Variable)
nbreg tcglo federal iea_rats gdp_pc itrade iso14001 ngo_number co2_emissions pollution




