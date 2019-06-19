
* Created: 6/13/2004 6:49:58 AM
*                                                        
* Modify the path below to point to your data file.      
* The specified subdirectory was not created on          
* your computer. You will need to do this.               
*                                                        
* The stat program must be run against the specified     
* data file. This file is specified in the program       
* and must be saved separately.                          
*                                                        
* This program does not provide tab or summarize for all 
* variables.                                             
*                                                        
* There may be missing data for some institutions due    
* to the merge used to create this file.                 
*                                                        
* This program does not include reserved values in its   
* calculations for missing values.                       
*                                                        
* You may need to adjust your memory settings depending  
* upon the number of variables and records.              
*                                                        
* The save command may need to be modified per user      
* requirements.                                          
*                                                        
* For long lists of value labels, the titles may be      
* shortened per program requirements. 
*                                                        
insheet using "../Raw Data/ic1991_hdr_data_stata.csv", comma clear
label data "dct_ic1991_hdr"
label variable unitid "unitid"
label variable city "City location of institution"
label variable stabbr "Post Office state abbreviation code"
label variable fips "FIPS state code"
label variable obereg "OBE region code"
label variable fice "FICE code"
label variable rstatus "Respondent status code"
label variable unitidx "UNITID of parent institution reporting full-year enrollment"
label variable sector "Sector of institution"
label variable iclevel "Level of institution"
label variable control "Control of institution"
label variable affil "Affiliation of institution"
label variable hloffer "Highest level of offering"
label variable fpoffer "First-professional offering"
label variable formrt "IC survey form submitted by institution"
label variable resplast "Respondent status last year"
label variable respstat "Respondent status this year"
label variable addr "Street address or post office box"
label variable zip "ZIP + four"
label variable countynm "County name"
label variable congdist "Congressional district"
label variable gentele "General information telephone number"
label variable chfnm "Name of Chief Administrator"
label variable chftitle "Title of Chief Administrator"
label define label_fips 1 "Alabama" 
label define label_fips 10 "Delaware", add 
label define label_fips 11 "District of Columbia", add 
label define label_fips 12 "Florida", add 
label define label_fips 13 "Georgia", add 
label define label_fips 15 "Hawaii", add 
label define label_fips 16 "Idaho", add 
label define label_fips 17 "Illinois", add 
label define label_fips 18 "Indiana", add 
label define label_fips 19 "Iowa", add 
label define label_fips 2 "Alaska", add 
label define label_fips 20 "Kansas", add 
label define label_fips 21 "Kentucky", add 
label define label_fips 22 "Louisiana", add 
label define label_fips 23 "Maine", add 
label define label_fips 24 "Maryland", add 
label define label_fips 25 "Massachusetts", add 
label define label_fips 26 "Michigan", add 
label define label_fips 27 "Minnesota", add 
label define label_fips 28 "Mississippi", add 
label define label_fips 29 "Missouri", add 
label define label_fips 30 "Montana", add 
label define label_fips 31 "Nebraska", add 
label define label_fips 32 "Nevada", add 
label define label_fips 33 "New Hampshire", add 
label define label_fips 34 "New Jersey", add 
label define label_fips 35 "New Mexico", add 
label define label_fips 36 "New York", add 
label define label_fips 37 "North Carolina", add 
label define label_fips 38 "North Dakota", add 
label define label_fips 39 "Ohio", add 
label define label_fips 4 "Arizona", add 
label define label_fips 40 "Oklahoma", add 
label define label_fips 41 "Oregon", add 
label define label_fips 42 "Pennsylvania", add 
label define label_fips 44 "Rhode Island", add 
label define label_fips 45 "South Carolina", add 
label define label_fips 46 "South Dakota", add 
label define label_fips 47 "Tennessee", add 
label define label_fips 48 "Texas", add 
label define label_fips 49 "Utah", add 
label define label_fips 5 "Arkansas", add 
label define label_fips 50 "Vermont", add 
label define label_fips 51 "Virginia", add 
label define label_fips 53 "Washington", add 
label define label_fips 54 "West Virginia", add 
label define label_fips 55 "Wisconsin", add 
label define label_fips 56 "Wyoming", add 
label define label_fips 6 "California", add 
label define label_fips 60 "American Samoa", add 
label define label_fips 64 "Federated States of Micronesia", add 
label define label_fips 66 "Guam", add 
label define label_fips 68 "Marshall Islands", add 
label define label_fips 69 "Northern Mariana Island", add 
label define label_fips 70 "Palau", add 
label define label_fips 72 "Puerto Rico", add 
label define label_fips 78 "Virgin Islands", add 
label define label_fips 8 "Colorado", add 
label define label_fips 9 "Connecticut", add 
label values fips label_fips
label define label_obereg 0 "U.S. Service schools" 
label define label_obereg 1 "New England-CT ME MA NH RI VT", add 
label define label_obereg 2 "Mid East-DE DC MD NJ NY PA", add 
label define label_obereg 3 "Great Lakes-IL IN MI OH WI", add 
label define label_obereg 4 "Plains-IA KS MN MO NE ND SD", add 
label define label_obereg 5 "Southeast-AL AR FL GA KY LA MS NC SC TN VA WV", add 
label define label_obereg 6 "Southwest-AZ NM OK TX", add 
label define label_obereg 7 "Rocky Mountains-CO ID MT UT WY", add 
label define label_obereg 8 "Far West-AK CA HI NV OR WA", add 
label define label_obereg 9 "Outlying Areas-AS GU CM PR TT VI", add 
label values obereg label_obereg
label define label_sector 0 "Central, system or corporate offices" 
label define label_sector 1 "Public, 4-year or above", add 
label define label_sector 2 "Private, nonprofit, 4-year or above", add 
label define label_sector 3 "Private, for profit, 4-year or above", add 
label define label_sector 4 "Public, 2-year", add 
label define label_sector 5 "Private, nonprofit, 2-year", add 
label define label_sector 6 "Private, for profit, 2-year", add 
label define label_sector 7 "Public, less-than-2-year", add 
label define label_sector 8 "Private, nonprofit, less-than-2-year", add 
label define label_sector 9 "Private, for profit, less-than-2-year", add 
label values sector label_sector
label define label_iclevel 0 "No reponse" 
label define label_iclevel 1 "4 or more years (Baccalaureate or higher degree)", add 
label define label_iclevel 2 "At least 2 but less than 4 years (below the Baccalaureate)", add 
label define label_iclevel 3 "Less than 2 years (below Associates Degree)", add 
label values iclevel label_iclevel
label define label_control 0 "No response" 
label define label_control 1 "Public", add 
label define label_control 2 "Private, nonprofit", add 
label define label_control 3 "Private for profit", add 
label values control label_control
label define label_affil 1 "Public" 
label define label_affil 2 "Private, for profit", add 
label define label_affil 3 "Private, nonprofit, no religious affiliation", add 
label define label_affil 4 "Private, nonprofit, Catholic", add 
label define label_affil 5 "Private, nonprofit, Jewish", add 
label define label_affil 6 "Private, nonprofit, Protestant", add 
label define label_affil 7 "Private, nonprofit, Other religious affiliation", add 
label values affil label_affil
label define label_hloffer 0 "Other" 
label define label_hloffer 1 "Postsecondary award, certificate or diploma of less than one academic year", add 
label define label_hloffer 2 "Postsecondary award, certificate or diploma of at least one but less than two academic years", add 
label define label_hloffer 3 "Associates Degree", add 
label define label_hloffer 4 "Postsecondary award, certificate or diploma of at least two but less than four academic years", add 
label define label_hloffer 5 "Bachelors Degree", add 
label define label_hloffer 6 "Postbaccalaureate Certificate", add 
label define label_hloffer 7 "Masters Degree", add 
label define label_hloffer 8 "Post-masters Certificate", add 
label define label_hloffer 9 "Doctors Degree", add 
label values hloffer label_hloffer
label define label_formrt 1 "Form IC1" 
label define label_formrt 2 "Form IC2", add 
label define label_formrt 3 "Form IC3", add 
label values formrt label_formrt
label define label_resplast 1 "Respondent" 
label define label_resplast 3 "Nonrespondent, not imputed", add 
label values resplast label_resplast
label define label_respstat 1 "Respondent" 
label define label_respstat 3 "Nonrespondent, not imputed", add 
label define label_respstat 5 "Combined data respondent", add 
label values respstat label_respstat
tab stabbr
tab fips
tab obereg
tab rstatus
tab sector
tab iclevel
tab control
tab affil
tab hloffer
tab fpoffer
tab formrt
tab resplast
tab respstat
summarize fice
summarize unitidx
summarize congdist
save dct_ic1991_hdr

