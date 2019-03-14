*******************************************************************************
*** Description: 	This document provides the code for preparing the 		***
***					Democratic Accountability and Linkages Project (DALP) 	***
***					data for use in the replication of "Compulsory Voting 	***
***					and Parties’ Vote Seeking Strategies," which is 		***
***					authored by Shane P. Singh and appears in the American 	***
***					Journal of Political Science. 							***			
*******************************************************************************

**************
**************
*Set the Version                                                                                                                         
**************
**************
version 13.1



**************
**************
*Open the Party-Level Democratic Accountability and Linkages Project Data (Version 20130907)                                                                                                                        
**************
**************
use "partylevel_20130907.dta"


**************
**************
*Rename and Relabel Some Variables to Have Intuitive Names and Rescale                                                                                                                      
**************
**************
gen vote_share = partysize
label var vote_share "percentage of the vote party received in previous TWO elections"

gen	lr_placement	=	dw
label	var lr_placement	 "Overall Left-Right Placement"


gen	gen_programmatic_struc 	=	cosalpo_4
label	var gen_programmatic_struc	 "General Programmatic Structuration"


gen	mobilize_positions	=	e2
label	var mobilize_positions	 "To what extent do parties seek to mobilize voters based on Policy Positions"



**************
************** 
*Constrain the Programmatism Scale to Vary from 0 to 10
**************
**************  
sum gen_programmatic_struc
gen gen_programmatic_struc_0_10 = ((gen_programmatic_struc - r(min))/(r(max) - r(min))) * 10
label var gen_programmatic_struc_0_10 "General Programmatic Structuration, 0 to 10 scale"



**************
************** 
*Constrain the Policy Emphasis Scale to Vary from 0 to 10
**************
**************  
sum mobilize_positions
gen mobilize_positions_0_10 = ((mobilize_positions - r(min))/(r(max) - r(min))) * 10
label var mobilize_positions_0_10 "To what extent do parties seek to mobilize voters based on Policy Positions, 0 to 10 scale"



**************
**************
*Rename Some Countries and Create Variables That Identify Country-Years to Help with Merging in Data from Other Sources
**************
**************
replace country = "Dominican Republic" if country == "Dom. Rep."
replace country = "Czech Republic" if country == "Czech Rep."
replace country = "South Africa" if country == "S. Africa"
replace country = "United States" if country == "USA"
replace country = "United Kingdom" if country == "UK"
replace country = "South Korea" if country == "ROK"

label var country "country"


**************
**************
*Create Variables That Identify Country-Years to Help with Merging in Data from Other Sources
**************
**************
*most countries assessed in 2008
gen year = 2008

*but the following were assessed in 2009:
replace year = 2009 if ///
	  country == "Australia" | country == "Canada" | country == "France" | country == "Italy" | country == "New Zealand" | country == "Sweden" ///
	| country == "United Kingdom" | country == "Albania" | country == "Slovakia" | country == "Slovenia" | country == "Dominican Republic" ///  
	| country == "Jamaica" | country == "Mauritius" | country == "South Africa" | country == "Turkey" | country == "Morocco" /// 
	| country == "Lebanon" | country == "Bangladesh" | country == "India" | country == "Indonesia" | country == "Philippines" | country == "Thailand"
label var year "year of expert survey"

tostring year, replace
gen countryandyear = country+"_"+year
destring year, replace



**************
**************
*Add a numerical identifier for countries
**************
**************
encode country, gen(cntrynum)
label var cntrynum "numerical country identifier"

	
	
	
**************
**************
*Merge in Compulsory Voting, Rule of Law, and Freedom House Data from V-Dem
**************
**************
merge m:1 countryandyear using "V-Dem_AJPS_Replication.dta" , ///
	keepusing(v2elcomvot_any v2elcomvot  v2cltrnslw e_fh_status)

*label variables
label var 	v2elcomvot_any "Compulsory voting binary indicator from V-Dem"
label var 	v2elcomvot "Compulsory voting scale from V-Dem"
label var 	v2cltrnslw "transparent laws with predictable enforcement rating from V-Dem"
label var 	e_fh_status_numeric "numerical freedom house status"

drop if _merge == 2
drop _merge




**************
************** 
*Bring in GDP Per Capita Data, Obtained from http://databank.worldbank.org/data/reports.aspx?source=world-development-indicators in May of 2016
**************
************** 
gen GDP_percapita = .
label var GDP_percapita "GDP per capita (constant 2005 thousands$)"
replace GDP_percapita = 	3.457942	if country == "Albania"
replace GDP_percapita = 	6.596583	if country == "Argentina"
replace GDP_percapita = 	36.05044	if country == "Australia"
replace GDP_percapita = 	41.12037	if country == "Austria"
replace GDP_percapita = 	0.5891413	if country == "Bangladesh"
replace GDP_percapita = 	38.61866	if country == "Belgium"
replace GDP_percapita = 	0.6186198	if country == "Benin"
replace GDP_percapita = 	1.157019	if country == "Bolivia"
replace GDP_percapita = 	6.291199	if country == "Botswana"
replace GDP_percapita = 	5.305307	if country == "Brazil"
replace GDP_percapita = 	4.833433	if country == "Bulgaria"
replace GDP_percapita = 	35.67058	if country == "Canada"
replace GDP_percapita = 	8.475597	if country == "Chile"
replace GDP_percapita = 	3.855164	if country == "Colombia"
replace GDP_percapita = 	5.436606	if country == "Costa Rica"
replace GDP_percapita = 	11.51597	if country == "Croatia"
replace GDP_percapita = 	15.17015	if country == "Czech Republic"
replace GDP_percapita = 	50.03626	if country == "Denmark"
replace GDP_percapita = 	4.350985	if country == "Dominican Republic"
replace GDP_percapita = 	3.259995	if country == "Ecuador"
replace GDP_percapita = 	1.392242	if country == "Egypt"
replace GDP_percapita = 	3.111083	if country == "El Salvador"
replace GDP_percapita = 	11.77153	if country == "Estonia"
replace GDP_percapita = 	42.41509	if country == "Finland"
replace GDP_percapita = 	34.70633	if country == "France"
replace GDP_percapita = 	2.000105	if country == "Georgia"
replace GDP_percapita = 	37.72007	if country == "Germany"
replace GDP_percapita = 	0.5625979	if country == "Ghana"
replace GDP_percapita = 	24.32359	if country == "Greece"
replace GDP_percapita = 	2.23179	if country == "Guatemala"
replace GDP_percapita = 	1.571495	if country == "Honduras"
replace GDP_percapita = 	11.78463	if country == "Hungary"
replace GDP_percapita = 	0.9289775	if country == "India"
replace GDP_percapita = 	1.491862	if country == "Indonesia"
replace GDP_percapita = 	51.68764	if country == "Ireland"
replace GDP_percapita = 	22.61705	if country == "Israel"
replace GDP_percapita = 	30.36399	if country == "Italy"
replace GDP_percapita = 	4.138199	if country == "Jamaica"
replace GDP_percapita = 	36.71392	if country == "Japan"
replace GDP_percapita = 	0.5586953	if country == "Kenya"
replace GDP_percapita = 	9.208959	if country == "Latvia"
replace GDP_percapita = 	6.809324	if country == "Lebanon"
replace GDP_percapita = 	10.00266	if country == "Lithuania"
replace GDP_percapita = 	3.59536	if country == "Macedonia"
replace GDP_percapita = 	6.209408	if country == "Malaysia"
replace GDP_percapita = 	0.4445093	if country == "Mali"
replace GDP_percapita = 	6.028646	if country == "Mauritius"
replace GDP_percapita = 	8.275465	if country == "Mexico"
replace GDP_percapita = 	0.974326	if country == "Moldova"
replace GDP_percapita = 	1.250699	if country == "Mongolia"
replace GDP_percapita = 	2.258155	if country == "Morocco"
replace GDP_percapita = 	0.4236407	if country == "Mozambique"
replace GDP_percapita = 	4.021864	if country == "Namibia"
replace GDP_percapita = 	45.04326	if country == "Netherlands"
replace GDP_percapita = 	27.76757	if country == "New Zealand"
replace GDP_percapita = 	1.274392	if country == "Nicaragua"
replace GDP_percapita = 	0.2699525	if country == "Niger"
replace GDP_percapita = 	0.9125151	if country == "Nigeria"
replace GDP_percapita = 	68.50118	if country == "Norway"
replace GDP_percapita = 	0.7600347	if country == "Pakistan"
replace GDP_percapita = 	5.870084	if country == "Panama"
replace GDP_percapita = 	1.697429	if country == "Paraguay"
replace GDP_percapita = 	3.332578	if country == "Peru"
replace GDP_percapita = 	1.329513	if country == "Philippines"
replace GDP_percapita = 	9.445778	if country == "Poland"
replace GDP_percapita = 	19.48927	if country == "Portugal"
replace GDP_percapita = 	6.07956	if country == "Romania"
replace GDP_percapita = 	6.612632	if country == "Russia"
replace GDP_percapita = 	0.7936971	if country == "Senegal"
replace GDP_percapita = 	4.180312	if country == "Serbia"
replace GDP_percapita = 	13.92936	if country == "Slovakia"
replace GDP_percapita = 	19.1776	if country == "Slovenia"
replace GDP_percapita = 	5.820682	if country == "South Africa"
replace GDP_percapita = 	20.92845	if country == "South Korea"
replace GDP_percapita = 	27.52704	if country == "Spain"
replace GDP_percapita = 	42.70459	if country == "Sweden"
replace GDP_percapita = 	59.03655	if country == "Switzerland"
replace GDP_percapita = 	0.4875855	if country == "Tanzania"
replace GDP_percapita = 	3.179149	if country == "Thailand"
replace GDP_percapita = 	7.264632	if country == "Turkey"
replace GDP_percapita = 	2.205582	if country == "Ukraine"
replace GDP_percapita = 	39.00944	if country == "United Kingdom"
replace GDP_percapita = 	44.86139	if country == "United States"
replace GDP_percapita = 	6.159285	if country == "Uruguay"
replace GDP_percapita = 	6.510388	if country == "Venezuela"
replace GDP_percapita = 	0.8005284	if country == "Zambia"




**************
************** 
*Bring in Polity Data, Obtained from http://www.systemicpeace.org/polity/polity4.htm in September of 2013
**************
************** 
gen polity2 = .
label var polity2 " Polity revised combined score"
replace polity2 = 	9	if country == "Albania"
replace polity2 = 	-2	if country == "Angola"
replace polity2 = 	8	if country == "Argentina"
replace polity2 = 	10	if country == "Australia"
replace polity2 = 	10	if country == "Austria"
replace polity2 = 	5	if country == "Bangladesh"
replace polity2 = 	8	if country == "Belgium"
replace polity2 = 	7	if country == "Benin"
replace polity2 = 	8	if country == "Bolivia"
replace polity2 = 	8	if country == "Botswana"
replace polity2 = 	8	if country == "Brazil"
replace polity2 = 	9	if country == "Bulgaria"
replace polity2 = 	10	if country == "Canada"
replace polity2 = 	10	if country == "Chile"
replace polity2 = 	7	if country == "Colombia"
replace polity2 = 	10	if country == "Costa Rica"
replace polity2 = 	9	if country == "Croatia"
replace polity2 = 	8	if country == "Czech Republic"
replace polity2 = 	10	if country == "Denmark"
replace polity2 = 	8	if country == "Dominican Republic"
replace polity2 = 	5	if country == "Ecuador"
replace polity2 = 	-3	if country == "Egypt"
replace polity2 = 	7	if country == "El Salvador"
replace polity2 = 	9	if country == "Estonia"
replace polity2 = 	10	if country == "Finland"
replace polity2 = 	9	if country == "France"
replace polity2 = 	6	if country == "Georgia"
replace polity2 = 	10	if country == "Germany"
replace polity2 = 	8	if country == "Ghana"
replace polity2 = 	10	if country == "Greece"
replace polity2 = 	8	if country == "Guatemala"
replace polity2 = 	7	if country == "Honduras"
replace polity2 = 	10	if country == "Hungary"
replace polity2 = 	9	if country == "India"
replace polity2 = 	8	if country == "Indonesia"
replace polity2 = 	10	if country == "Ireland"
replace polity2 = 	10	if country == "Israel"
replace polity2 = 	10	if country == "Italy"
replace polity2 = 	9	if country == "Jamaica"
replace polity2 = 	10	if country == "Japan"
replace polity2 = 	7	if country == "Kenya"
replace polity2 = 	8	if country == "Latvia"
replace polity2 = 	7	if country == "Lebanon"
replace polity2 = 	10	if country == "Lithuania"
replace polity2 = 	9	if country == "Macedonia"
replace polity2 = 	6	if country == "Malaysia"
replace polity2 = 	7	if country == "Mali"
replace polity2 = 	10	if country == "Mauritius"
replace polity2 = 	8	if country == "Mexico"
replace polity2 = 	8	if country == "Moldova"
replace polity2 = 	10	if country == "Mongolia"
replace polity2 = 	-6	if country == "Morocco"
replace polity2 = 	5	if country == "Mozambique"
replace polity2 = 	6	if country == "Namibia"
replace polity2 = 	10	if country == "Netherlands"
replace polity2 = 	10	if country == "New Zealand"
replace polity2 = 	9	if country == "Nicaragua"
replace polity2 = 	6	if country == "Niger"
replace polity2 = 	4	if country == "Nigeria"
replace polity2 = 	10	if country == "Norway"
replace polity2 = 	5	if country == "Pakistan"
replace polity2 = 	9	if country == "Panama"
replace polity2 = 	8	if country == "Paraguay"
replace polity2 = 	9	if country == "Peru"
replace polity2 = 	8	if country == "Philippines"
replace polity2 = 	10	if country == "Poland"
replace polity2 = 	10	if country == "Portugal"
replace polity2 = 	9	if country == "Romania"
replace polity2 = 	4	if country == "Russia"
replace polity2 = 	7	if country == "Senegal"
replace polity2 = 	8	if country == "Serbia"
replace polity2 = 	10	if country == "Slovakia"
replace polity2 = 	10	if country == "Slovenia"
replace polity2 = 	9	if country == "South Africa"
replace polity2 = 	8	if country == "South Korea"
replace polity2 = 	10	if country == "Spain"
replace polity2 = 	10	if country == "Sweden"
replace polity2 = 	10	if country == "Switzerland"
replace polity2 = 	10	if country == "Taiwan"
replace polity2 = 	-1	if country == "Tanzania"
replace polity2 = 	4	if country == "Thailand"
replace polity2 = 	7	if country == "Turkey"
replace polity2 = 	7	if country == "Ukraine"
replace polity2 = 	10	if country == "United Kingdom"
replace polity2 = 	10	if country == "United States"
replace polity2 = 	10	if country == "Uruguay"
replace polity2 = 	5	if country == "Venezuela"
replace polity2 = 	7	if country == "Zambia"


**************
************** 
*Make a Dummy for Majoritarian Electoral Systems and Fill in Missing Values on the Indicator in V-Dem
**************
**************  
gen majoritarian = 0
label var majoritarian "1 if majoritarian electoral system for lower house"
replace majoritarian = 	0	if country == "Albania"
replace majoritarian = 	0	if country == "Angola"
replace majoritarian = 	0	if country == "Argentina"
replace majoritarian = 	1	if country == "Australia"
replace majoritarian = 	0	if country == "Austria"
replace majoritarian = 	1	if country == "Bangladesh"
replace majoritarian = 	0	if country == "Belgium"
replace majoritarian = 	0	if country == "Benin"
replace majoritarian = 	0	if country == "Bolivia"
replace majoritarian = 	1	if country == "Botswana"
replace majoritarian = 	0	if country == "Brazil"
replace majoritarian = 	0	if country == "Bulgaria"
replace majoritarian = 	1	if country == "Canada"
replace majoritarian = 	0	if country == "Chile"
replace majoritarian = 	0	if country == "Colombia"
replace majoritarian = 	0	if country == "Costa Rica"
replace majoritarian = 	0	if country == "Croatia"
replace majoritarian = 	0	if country == "Czech Republic"
replace majoritarian = 	0	if country == "Denmark"
replace majoritarian = 	0	if country == "Dominican Republic"
replace majoritarian = 	0	if country == "Ecuador"
replace majoritarian = 	1	if country == "Egypt"
replace majoritarian = 	0	if country == "El Salvador"
replace majoritarian = 	0	if country == "Estonia"
replace majoritarian = 	0	if country == "Finland"
replace majoritarian = 	1	if country == "France"
replace majoritarian = 	0	if country == "Georgia"
replace majoritarian = 	0	if country == "Germany"
replace majoritarian = 	1	if country == "Ghana"
replace majoritarian = 	0	if country == "Greece"
replace majoritarian = 	0	if country == "Guatemala"
replace majoritarian = 	0	if country == "Honduras"
replace majoritarian = 	0	if country == "Hungary"
replace majoritarian = 	1	if country == "India"
replace majoritarian = 	0	if country == "Indonesia"
replace majoritarian = 	0	if country == "Ireland"
replace majoritarian = 	0	if country == "Israel"
replace majoritarian = 	0	if country == "Italy"
replace majoritarian = 	1	if country == "Jamaica"
replace majoritarian = 	0	if country == "Japan"
replace majoritarian = 	1	if country == "Kenya"
replace majoritarian = 	0	if country == "Latvia"
replace majoritarian = 	1	if country == "Lebanon"
replace majoritarian = 	0	if country == "Lithuania"
replace majoritarian = 	0	if country == "Macedonia"
replace majoritarian = 	1	if country == "Malaysia"
replace majoritarian = 	1	if country == "Mali"
replace majoritarian = 	1	if country == "Mauritius"
replace majoritarian = 	0	if country == "Mexico"
replace majoritarian = 	0	if country == "Moldova"
replace majoritarian = 	1	if country == "Mongolia"
replace majoritarian = 	0	if country == "Morocco"
replace majoritarian = 	0	if country == "Mozambique"
replace majoritarian = 	0	if country == "Namibia"
replace majoritarian = 	0	if country == "Netherlands"
replace majoritarian = 	0	if country == "New Zealand"
replace majoritarian = 	0	if country == "Nicaragua"
replace majoritarian = 	0	if country == "Niger"
replace majoritarian = 	1	if country == "Nigeria"
replace majoritarian = 	0	if country == "Norway"
replace majoritarian = 	1	if country == "Pakistan"
replace majoritarian = 	0	if country == "Panama"
replace majoritarian = 	0	if country == "Paraguay"
replace majoritarian = 	0	if country == "Peru"
replace majoritarian = 	0	if country == "Philippines"
replace majoritarian = 	0	if country == "Poland"
replace majoritarian = 	0	if country == "Portugal"
replace majoritarian = 	0	if country == "Romania"
replace majoritarian = 	0	if country == "Russia"
replace majoritarian = 	0	if country == "Senegal"
replace majoritarian = 	0	if country == "Serbia"
replace majoritarian = 	0	if country == "Slovakia"
replace majoritarian = 	0	if country == "Slovenia"
replace majoritarian = 	0	if country == "South Africa"
replace majoritarian = 	0	if country == "South Korea"
replace majoritarian = 	0	if country == "Spain"
replace majoritarian = 	0	if country == "Sweden"
replace majoritarian = 	0	if country == "Switzerland"
replace majoritarian = 	0	if country == "Taiwan"
replace majoritarian = 	1	if country == "Tanzania"
replace majoritarian = 	0	if country == "Thailand"
replace majoritarian = 	0	if country == "Turkey"
replace majoritarian = 	0	if country == "Ukraine"
replace majoritarian = 	1	if country == "United Kingdom"
replace majoritarian = 	1	if country == "United States"
replace majoritarian = 	0	if country == "Uruguay"
replace majoritarian = 	0	if country == "Venezuela"
replace majoritarian = 	1	if country == "Zambia"




**************
************** 
*Create an Indicator for Presidentialism
**************
**************  
gen presidential = 0
label var presidential "1 if presidential system, 0 for semi-prez and parliamentary"
replace presidential = 	0	if country == "Albania"
replace presidential = 	0	if country == "Angola"
replace presidential = 	1	if country == "Argentina"
replace presidential = 	0	if country == "Australia"
replace presidential = 	0	if country == "Austria"
replace presidential = 	0	if country == "Bangladesh"
replace presidential = 	0	if country == "Belgium"
replace presidential = 	1	if country == "Benin"
replace presidential = 	1	if country == "Bolivia"
replace presidential = 	0	if country == "Botswana"
replace presidential = 	1	if country == "Brazil"
replace presidential = 	0	if country == "Bulgaria"
replace presidential = 	0	if country == "Canada"
replace presidential = 	1	if country == "Chile"
replace presidential = 	1	if country == "Colombia"
replace presidential = 	1	if country == "Costa Rica"
replace presidential = 	0	if country == "Croatia"
replace presidential = 	0	if country == "Czech Republic"
replace presidential = 	0	if country == "Denmark"
replace presidential = 	1	if country == "Dominican Republic"
replace presidential = 	1	if country == "Ecuador"
replace presidential = 	0	if country == "Egypt"
replace presidential = 	1	if country == "El Salvador"
replace presidential = 	0	if country == "Estonia"
replace presidential = 	0	if country == "Finland"
replace presidential = 	0	if country == "France"
replace presidential = 	0	if country == "Georgia"
replace presidential = 	0	if country == "Germany"
replace presidential = 	1	if country == "Ghana"
replace presidential = 	0	if country == "Greece"
replace presidential = 	1	if country == "Guatemala"
replace presidential = 	1	if country == "Honduras"
replace presidential = 	0	if country == "Hungary"
replace presidential = 	0	if country == "India"
replace presidential = 	1	if country == "Indonesia"
replace presidential = 	0	if country == "Ireland"
replace presidential = 	0	if country == "Israel"
replace presidential = 	0	if country == "Italy"
replace presidential = 	0	if country == "Jamaica"
replace presidential = 	0	if country == "Japan"
replace presidential = 	1	if country == "Kenya"
replace presidential = 	0	if country == "Latvia"
replace presidential = 	0	if country == "Lebanon"
replace presidential = 	0	if country == "Lithuania"
replace presidential = 	0	if country == "Macedonia"
replace presidential = 	0	if country == "Malaysia"
replace presidential = 	0	if country == "Mali"
replace presidential = 	0	if country == "Mauritius"
replace presidential = 	1	if country == "Mexico"
replace presidential = 	0	if country == "Moldova"
replace presidential = 	0	if country == "Mongolia"
replace presidential = 	0	if country == "Morocco"
replace presidential = 	0	if country == "Mozambique"
replace presidential = 	0	if country == "Namibia"
replace presidential = 	0	if country == "Netherlands"
replace presidential = 	0	if country == "New Zealand"
replace presidential = 	1	if country == "Nicaragua"
replace presidential = 	0	if country == "Niger"
replace presidential = 	1	if country == "Nigeria"
replace presidential = 	0	if country == "Norway"
replace presidential = 	0	if country == "Pakistan"
replace presidential = 	1	if country == "Panama"
replace presidential = 	1	if country == "Paraguay"
replace presidential = 	1	if country == "Peru"
replace presidential = 	1	if country == "Philippines"
replace presidential = 	0	if country == "Poland"
replace presidential = 	0	if country == "Portugal"
replace presidential = 	0	if country == "Romania"
replace presidential = 	0	if country == "Russia"
replace presidential = 	0	if country == "Senegal"
replace presidential = 	0	if country == "Serbia"
replace presidential = 	0	if country == "Slovakia"
replace presidential = 	0	if country == "Slovenia"
replace presidential = 	0	if country == "South Africa"
replace presidential = 	1	if country == "South Korea"
replace presidential = 	0	if country == "Spain"
replace presidential = 	0	if country == "Sweden"
replace presidential = 	0	if country == "Switzerland"
replace presidential = 	0	if country == "Taiwan"
replace presidential = 	0	if country == "Tanzania"
replace presidential = 	0	if country == "Thailand"
replace presidential = 	0	if country == "Turkey"
replace presidential = 	0	if country == "Ukraine"
replace presidential = 	0	if country == "United Kingdom"
replace presidential = 	1	if country == "United States"
replace presidential = 	1	if country == "Uruguay"
replace presidential = 	1	if country == "Venezuela"
replace presidential = 	1	if country == "Zambia"




**************
**************
*Make Regional Identifier for Latin America
**************
************** 
gen latin = 0
label var latin "country speaks Span. or Port. or French and is in S. or Cent. Am."
replace latin = 1 if country == "Argentina"
replace latin = 1 if country == "Bolivia"
replace latin = 1 if country == "Brazil"
replace latin = 1 if country == "Chile"
replace latin = 1 if country == "Colombia"
replace latin = 1 if country == "Costa Rica"
replace latin = 1 if country == "Dominican Republic"
replace latin = 1 if country == "Ecuador"
replace latin = 1 if country == "El Salvador"
replace latin = 1 if country == "Guatemala"
replace latin = 1 if country == "Honduras"
replace latin = 1 if country == "Mexico"
replace latin = 1 if country == "Nicaragua"
replace latin = 1 if country == "Panama"
replace latin = 1 if country == "Paraguay"
replace latin = 1 if country == "Peru"
replace latin = 1 if country == "Uruguay"
replace latin = 1 if country == "Venezuela"
replace latin = 1 if country == "Cuba"
replace latin = 1 if country == "Haiti"



**************
************** 
*Make Identifier for Federal Countries
**************
**************  
gen federal = 0
label var federal "Is the country a Federation? 0 if no, 1 if yes"
replace federal = 1 if country == "Argentina"
replace federal = 1 if country == "Australia"
replace federal = 1 if country == "Austria"
replace federal = 1 if country == "Belgium"
replace federal = 1 if country == "Bosnia and Herzegovina"
replace federal = 1 if country == "Brazil"
replace federal = 1 if country == "Canada"
replace federal = 1 if country == "Comoros"
replace federal = 1 if country == "Ethiopia"
replace federal = 1 if country == "Germany"
replace federal = 1 if country == "India"
replace federal = 1 if country == "Malaysia"
replace federal = 1 if country == "Mexico"
replace federal = 1 if country == "Micronesia"
replace federal = 1 if country == "Nepal"
replace federal = 1 if country == "Nigeria"
replace federal = 1 if country == "Pakistan"
replace federal = 1 if country == "Russia"
replace federal = 1 if country == "South Africa"
replace federal = 1 if country == "Spain"
replace federal = 1 if country == "St. Kitts and Nevis"
replace federal = 1 if country == "Switzerland"
replace federal = 1 if country == "United Arab Emirates"
replace federal = 1 if country == "United States"
replace federal = 1 if country == "Venezuela"



**************
************** 
*Drop Variables Not Used in the Analyses and Reorder Them
**************
************** 
keep country e_fh_status_numeric  mobilize_positions mobilize_positions_0_10  gen_programmatic_struc gen_programmatic_struc_0_10 v2elcomvot v2elcomvot_any vote_share  GDP_percapita polity v2cltrnslw majoritarian presidential federal latin cntrynum  year

order country cntrynum year v2elcomvot* mobilize_positions* gen_programmatic_struc*  vote_share year country cntrynum, first
order v2cltrnslw, last

**************
************** 
*Save the Data
**************
**************  
save "DALP_AJPS_Replication.dta", replace
	
