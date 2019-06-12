**************************REPLICATION MATERIALS FOR ***************************************
**"Transnational Climate Governance and the Global 500: 
**Examining Private Actor Participation by Firm-level Factors and Dynamics"
**
**Lily Hsueh 
**April 18, 2016
**
**
**Unless stated otherwise, the data source for all tables and figures is "data_tcg_global500.dta"
*********************************************************************************************

use data_tcg_global500, clear
 
*********************************TABLE 1**********************************************

*Firm level variables 
summarize ///
      policy_supporter_analyst-policy_supporter_cso ///
	  mission_value esg website_sus ///
	///
	 lnemployees lnrevenues lnassets ///
	 iso14001_any env_rd gov ///
	 sector_consumer_discretionary-sector_utilities 
	 
*Country level variables 
summarize gdp_pc co2_emissions ///
	civil_lib  pol_rights polity ///
    federal ///
	pollution ///
	epi ///
	lniso14001_country 

*********************************TABLE 2**********************************************

*Participation in Voluntary Climate Action 
melogit Participation_Climate_Action || country_code:
estat icc 

*Participation in Voluntary Carbon Disclosure
melogit Participation_Carbon_Disclosure || country_code:
estat icc 

*Carbon Disclosure Quality 
mixed Carbon_Disclosure_Score || country_code:
estat icc 

*********************************TABLE 3**********************************************

*Model 1 (FIRM LEVEL)
melogit Participation_Climate_Action ///
     policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///
 	|| country_code: , or vce(robust)

*Impact calculations for stat sign coefficients
display (exp(_b[policy_supporter_analyst])-1)*100
display (exp(_b[policy_supporter_vp])-1)*100
display (exp(_b[policy_supporter_cso])-1)*100
display (exp(_b[mission_values])-1)*100
display (exp(_b[esg])-1)*100
display (exp(_b[lnemployees])-1)*100
display (exp(_b[lnassets])-1)*100
display (exp(_b[gov])-1)*100	
display (exp(_b[sector_consumer_staples])-1)*100	
display (exp(_b[sector_it])-1)*100	
 
*Model 2 (FIRM AND COUNTRY LEVELS)
melogit Participation_Climate_Action ///
     policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///
   gdp_pc co2_emissions ///
   civil_lib ///
   federal ///
   pollution ///
   epi ///
   lniso14001_country ///
	|| country_code: , or 
	
*Impact calculations for stat sign coefficients
display (exp(_b[policy_supporter_analyst])-1)*100
display (exp(_b[policy_supporter_vp])-1)*100
display (exp(_b[policy_supporter_cso])-1)*100
display (exp(_b[mission_values])-1)*100
display (exp(_b[esg])-1)*100
display (exp(_b[lnemployees])-1)*100
display (exp(_b[lnrevenues])-1)*100
display (exp(_b[lnassets])-1)*100
display (exp(_b[sector_financials])-1)*100	
display (exp(_b[sector_it])-1)*100		
display (exp(_b[gdp_pc])-1)*100		
display (exp(_b[co2_emissions])-1)*100		
display (exp(_b[civil_lib])-1)*100	

*********************************TABLE 4**********************************************

*Model 1 (FIRM LEVEL)
  melogit Participation_Carbon_Disclosure ///
    policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///
 	|| country_code: , or vce(robust)
	
*Impact calculations for stat sign coefficients
display (exp(_b[policy_supporter_analyst])-1)*100
display (exp(_b[policy_supporter_vp])-1)*100
display (exp(_b[policy_supporter_cso])-1)*100
display (exp(_b[esg])-1)*100
display (exp(_b[lnemployees])-1)*100
display (exp(_b[lnassets])-1)*100
display (exp(_b[iso14001_any])-1)*100
display (exp(_b[gov])-1)*100	
display (exp(_b[sector_consumer_staples])-1)*100	
display (exp(_b[sector_financials])-1)*100		
	
 *Model 2 (FIRM AND COUNTRY LEVELS)
 melogit Participation_Carbon_Disclosure ///
     policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///
   gdp_pc co2_emissions ///
   civil_lib ///
   federal ///
   pollution ///
   epi ///
   lniso14001_country ///
	|| country_code: , or vce(robust)
	
*Impact calculations for stat sign coefficients
display (exp(_b[policy_supporter_vp])-1)*100
display (exp(_b[policy_supporter_cso])-1)*100
display (exp(_b[lnemployees])-1)*100
display (exp(_b[lnassets])-1)*100
display (exp(_b[iso14001_any])-1)*100
display (exp(_b[gov])-1)*100
display (exp(_b[sector_consumer_staples])-1)*100	
display (exp(_b[sector_financials])-1)*100	
display (exp(_b[co2_emissions])-1)*100		
display (exp(_b[civil_lib])-1)*100	
display (exp(_b[lniso14001_country])-1)*100	
	
*********************************TABLE 5**********************************************

*Model 1 (FIRM LEVEL)
mixed Carbon_Disclosure_Score  ///
   policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities  ///
   ///
	|| country_code:, vce(robust)
 
 *Model 2 (FIRM AND COUNTRY LEVELS)
 mixed Carbon_Disclosure_Score ///
   policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities  ///
   ///
   gdp_pc co2_emissions ///
   civil_lib ///
   federal ///
   pollution ///
   epi ///
   lniso14001_country ///
	|| country_code:, vce(robust)
 

***********************CALCULATIONS THROUGHOUT THE PAPER***********************

/*"Of the over 2000 corporations that participate in voluntary climate action, 267 companies (~13%) 
are a part of the Global 500."*/
display 267/2000*100

/*"In 2015, 22 (~7%) of the 323 Global 500 companies that have disclose to the CDP have 
made this request; over half of these firms are based in China.*/
tabulate company country_code if Participation_Carbon_Disclosure ==1 & Carbon_Disclosure_Score ==0
display 22/323*100

/*Footnote 24: "The remaining companies are based in the United States (5), UK (1), Canada (1), 
Chile (1), and Germany (1)."*/
tabulate company country_code if Participation_Carbon_Disclosure ==1 & Carbon_Disclosure_Score ==0

/*Altogether, there are 301 companies (60 percent) that have a Carbon_Disclosure_Score greater than
 “0” in the main analysis."*/
 display 301/500*100

/*"In 2015, close to 92 percent of the companies that voluntarily disclosed to the CDP
 achieved a score of 50 or higher; the average performance score was 94.4 out of 100."*/
 tabulate Carbon_Disclosure_Score if Carbon_Disclosure_Score > 50
display 296/323
summarize Carbon_Disclosure_Score if Carbon_Disclosure_Score > 50

/*"For example, 77 percent of companies originating from the EU engage in voluntary climate action, 
while 70 percent of Asian headquartered firms are not participants of TCG."*/
tabulate eu Participation_Climate_Action 
display 98/127*100
tabulate asia Participation_Climate_Action 
display 132/188*100

/*Footnote 27: "...there were 10 companies that disclosed their carbon emissions to the CDP in 2014 
but not in 2015: Alstrom, China Telecom, Hindustan Petroleum, Lotte Shopping, Shanghai Pudong 
Development Bank, Surgutneftegas, among others."*/
 list company v_disclosure_2014 Participation_Carbon_Disclosure if v_disclosure_2014 ==1 & Participation_Carbon_Disclosure ==0

/*"Companies belonging to the Consumer Staples industry sector include Wal-Mart Stores, Inc., 
CVS Caremark Corporation, Costco Wholesale, Heineken, Nestle, among others. Information Technology 
companies include Vodafone Group, Apple Inc., Google, Intel Corporation, Telstra Corporation, 
Huawei Investment & Holding, BT Group, China Telecom, Ericsson, Avent, NEC, Nokia, among others."*/  
list company if sector_consumer_staples ==1
list company if sector_it ==1 


*******************************ONLINE APPENDIX**********************************************

*********************************FIGURE A1**********************************************
*Pie chart is created in Excel using the following summary data

summarize sector_consumer_discretionary-sector_utilities 


*********************************FIGURE A2**********************************************
*Pie chart is created in Excel using the following tabulated data 

tabulate country_code 
tabulate eu 

*********************************FIGURE A3**********************************************

histogram Carbon_Disclosure_Score_Alt1, frequency kdensity kdenopts(lcolor(black) lwidth(thick) lpattern(solid)) ///
ytitle(Frequency) ytitle(, size(large) color(black)) ylabel(, labsize(large) tlcolor(black)) ///
xtitle(CDP Disclosure Scores) xtitle(, size(large) color(black)) xlabel(, labsize(large) labcolor(black)) legend(off)

*********************************TABLE A1 AND A2, A3***********************************
*See Online Appendix (not tables generated in Stata)

*********************************TABLE A4**********************************************

corr policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
mission_value esg website_sus ///
lnemployees lnrevenues lnassets ///
iso14001_any env_rd ///
gov ///
gdp_pc co2_emissions ///
	civil_lib  pol_rights polity ///
    federal ///
	pollution ///
	epi ///
	lniso14001_country 
	
*********************************TABLE A5**********************************************

collin policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
mission_value esg website_sus ///
lnemployees lnrevenues lnassets ///
iso14001_any env_rd ///
gov 

*********************************TABLE A6**********************************************
*ALTERNATIVE SPECIFICATIONS ON DEPENDENT VARIABLES

*Model 1
  mixed Carbon_Disclosure_Score_Alt1 ///
  policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///
   gdp_pc co2_emissions ///
   civil_lib ///
   federal ///
   pollution ///
   epi ///
   lniso14001_country ///
	|| country_code:, vce(robust)
 
 *Model 2
 mixed Carbon_Disclosure_Score_Alt2 ///
  policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///
   gdp_pc co2_emissions ///
   civil_lib ///
   federal ///
   pollution ///
   epi ///
   lniso14001_country ///
	|| country_code:, vce(robust) 
	
*Model 3
 mixed Carbon_Disclosure_Score_Alt3 ///
 policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///
   gdp_pc co2_emissions ///
   civil_lib ///
   federal ///
   pollution ///
   epi ///
   lniso14001_country ///
	|| country_code:, vce(robust)


*********************************TABLE A6**********************************************
*ALTERNATIVE SPECIFICATIONS ON CIVIL LIBERTIES 

*Model 1
melogit Participation_Climate_Action ///
     policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///  
   gdp_pc co2_emissions ///
   pol_rights ///
   federal ///
   pollution ///
   epi ///
   lniso14001_country ///
	|| country_code: , or 

*Model 2	
melogit Participation_Climate_Action ///
     policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///
   gdp_pc co2_emissions ///
   polity ///
   federal ///
   pollution ///
   epi ///
   lniso14001_country ///
	|| country_code: , or 

*Model 3
melogit Participation_Carbon_Disclosure ///
     policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///
   gdp_pc co2_emissions ///
   pol_right ///
   federal ///
   pollution ///
   epi ///
   lniso14001_country ///
	|| country_code: , or vce(robust)

*Model 4
melogit Participation_Carbon_Disclosure ///
     policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///
   gdp_pc co2_emissions ///
   polity ///
   federal ///
   pollution ///
   epi ///
   lniso14001_country ///
	|| country_code: , or vce(robust)	
	
*Model 5
mixed Carbon_Disclosure_Score ///
  policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
	 mission_values esg  website_sus ///
   ///
   lnemployees lnrevenues lnassets ///
   iso14001_any env_rd ///
   gov sector_consumer_staples-sector_utilities ///
   ///
   gdp_pc co2_emissions ///
   pol_right ///
   federal ///
   pollution ///
   epi ///
   lniso14001_country ///
	|| country_code:, vce(robust)
	
*Model 6
mixed Carbon_Disclosure_Score ///
  policy_supporter_analyst policy_supporter_vp policy_supporter_cso ///
  mission_values esg  website_sus ///
   ///
  lnemployees lnrevenues lnassets ///
  iso14001_any env_rd ///
  gov sector_consumer_staples-sector_utilities ///
   ///
  gdp_pc co2_emissions ///
  polity ///
  federal ///
  pollution ///
  epi ///
  lniso14001_country ///
  || country_code:, vce(robust)



