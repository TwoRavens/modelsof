* Created: 6/13/2004 3:17:03 AM
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
insheet using "../Raw Data/ic9798_hdr_data_stata.csv", comma clear
label data "dct_ic9798_hdr"
label variable unitid "unitid"
label variable city "City location of institution"
label variable stabbr "Post Office State abbreviation code"
label variable fips "FIPS State code"
label variable obereg "OBE region code"
label variable fice "FICE code"
label variable rstatus "Respondent status to IC survey Part E ONLY"
label variable imptype "Type of Imputation part E only"
label variable parchild "Parent/child institution indicator"
label variable idx "UNITID of parent institution reporting full-year enrollment"
label variable sector "Sector of institution"
label variable iclevel "Level of institution"
label variable control "Control of institution"
label variable affil "Affiliation of institution"
label variable hloffer "Highest level of offering"
label variable fpoffer "First-professional offering"
label variable locale "Degree of Urbanization"
label variable pctmin1 "Percent Black, non-Hispanic"
label variable pctmin2 "Percent American Indian/Alaskan Native"
label variable pctmin3 "Percent Asian/Pacific Islander"
label variable pctmin4 "Percent Hispanic"
label variable hbcu "Historically Black College or University"
label variable hospital "Institution has hospital"
label variable medical "Institution grants a medical degree"
label variable tribal "Tribal college"
label variable carnegie "Carnegie Classification Code"
label variable source "Data source"
label variable opeid "Office of Postsecondary Education id"
label variable opeind "OPE eligibility indicator code"
label variable hdegoffr "Highest Degree offered"
label variable ncesedit "Status of data edit process"
label variable formrt "IC survey form received by institution"
label variable cntygeo "3-digit county fips code"
label variable resplast "Respondent status last year"
label variable respstat "Respondent status this year"
label variable addr "Street address or post office box"
label variable zip "ZIP + four"
label variable countynm "County name"
label variable congdist "Congressional district"
label variable gentele "General information telephone number"
label variable fintele "Financial Aid Office telephone number"
label variable admtele "Admissions office telephone number"
label variable ein "Employer Identification Number"
label variable chfnm "Name of Chief Administrator"
label variable chftitle "Title of Chief Administrator"
/*
label define label_stabbr AK "Alaska" 
label define label_stabbr AL "Alabama", add 
label define label_stabbr AR "Arkansas", add 
label define label_stabbr AS "American Samoa", add 
label define label_stabbr AZ "Arizona", add 
label define label_stabbr CA "California", add 
label define label_stabbr CO "Colorado", add 
label define label_stabbr CT "Connecticut", add 
label define label_stabbr DC "District of Columbia", add 
label define label_stabbr DE "Delaware", add 
label define label_stabbr FL "Florida", add 
label define label_stabbr FM "Federated States of Micronesia", add 
label define label_stabbr GA "Georgia", add 
label define label_stabbr GU "Guam", add 
label define label_stabbr HI "Hawaii", add 
label define label_stabbr IA "Iowa", add 
label define label_stabbr ID "Idaho", add 
label define label_stabbr IL "Illinois", add 
label define label_stabbr IN "Indiana", add 
label define label_stabbr KS "Kansas", add 
label define label_stabbr KY "Kentucky", add 
label define label_stabbr LA "Louisiana", add 
label define label_stabbr MA "Massachusetts", add 
label define label_stabbr MD "Maryland", add 
label define label_stabbr ME "Maine", add 
label define label_stabbr MH "Marshall Islands", add 
label define label_stabbr MI "Michigan", add 
label define label_stabbr MN "Minnesota", add 
label define label_stabbr MO "Missouri", add 
label define label_stabbr MP "Northern Marianas", add 
label define label_stabbr MS "Mississippi", add 
label define label_stabbr MT "Montana", add 
label define label_stabbr NC "North Carolina", add 
label define label_stabbr ND "North Dakota", add 
label define label_stabbr NE "Nebraska", add 
label define label_stabbr NH "New Hampshire", add 
label define label_stabbr NJ "New Jersey", add 
label define label_stabbr NM "New Mexico", add 
label define label_stabbr NV "Nevada", add 
label define label_stabbr NY "New York", add 
label define label_stabbr OH "Ohio", add 
label define label_stabbr OK "Oklahoma", add 
label define label_stabbr OR "Oregon", add 
label define label_stabbr PA "Pennsylvania", add 
label define label_stabbr PR "Puerto Rico", add 
label define label_stabbr PW "Palau", add 
label define label_stabbr RI "Rhode Island", add 
label define label_stabbr SC "South Carolina", add 
label define label_stabbr SD "South Dakota", add 
label define label_stabbr TN "Tennessee", add 
label define label_stabbr TX "Texas", add 
label define label_stabbr UT "Utah", add 
label define label_stabbr VA "Virginia", add 
label define label_stabbr VI "Virgin Islands", add 
label define label_stabbr VT "Vermont", add 
label define label_stabbr WA "Washington", add 
label define label_stabbr WI "Wisconsin", add 
label define label_stabbr WV "West Virginia", add 
label define label_stabbr WY "Wyoming", add 
label values stabbr label_stabbr
*/
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
label define label_fips 4 "Ariizona", add 
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
label define label_fips 69 "Northern Marianas", add 
label define label_fips 70 "Palau", add 
label define label_fips 72 "Puerto Rico", add 
label define label_fips 78 "Virgin Islands", add 
label define label_fips 8 "Colorado", add 
label define label_fips 9 "Connecticut", add 
label values fips label_fips
label define label_obereg 0 "US Service schools" 
label define label_obereg 1 "New England CT ME MA NH RI VT", add 
label define label_obereg 2 "Mid East DE DC MD NJ NY PA", add 
label define label_obereg 3 "Great Lakes IL IN MI OH WI", add 
label define label_obereg 4 "Plains IA KS MN MO NE ND SD", add 
label define label_obereg 5 "Southeast AL AR FL GA KY LA MS NC SC TN VA WV", add 
label define label_obereg 6 "Southwest AZ NM OK TX", add 
label define label_obereg 7 "Rocky Mountains CO ID MT UT WY", add 
label define label_obereg 8 "Far West AK CA HI NV OR WA", add 
label define label_obereg 9 "Outlying Areas AS FM GU MH MP PR PW VI", add 
label values obereg label_obereg
label define label_rstatus 1 "Respondent to Part E" 
label define label_rstatus 3 "Nonrespondent to Part E not imputed", add 
label define label_rstatus 4 "Nonrespondent to Part E imputed", add 
label values rstatus label_rstatus
label define label_imptype 1 "Imputed current year mean average method" 
label define label_imptype 2 "Imputed previous years data", add 
label define label_imptype 9 "Partial imputation", add 
label values imptype label_imptype
label define label_parchild 1 "Parent record" 
label define label_parchild 2 "Child record", add 
label values parchild label_parchild
label define label_sector 0 "Administrative unit" 
label define label_sector 1 "Public 4-year or above", add 
label define label_sector 2 "Private nonprofit 4-year or above", add 
label define label_sector 3 "Private for-profit 4-year or above", add 
label define label_sector 4 "Public 2-year", add 
label define label_sector 5 "Private nonprofit 2-year", add 
label define label_sector 6 "Private for-profit 2-year", add 
label define label_sector 7 "Public less-than-2-year", add 
label define label_sector 8 "Private nonprofit less-than-2-year", add 
label define label_sector 9 "Private for-profit less-than-2-year", add 
label values sector label_sector
label define label_iclevel 1 "Baccalaureate or higher degree" 
label define label_iclevel 2 "Below the Baccalaureate", add 
label define label_iclevel 3 "Below Associates Degree", add 
label values iclevel label_iclevel
label define label_control 1 "Public" 
label define label_control 2 "Private nonprofit", add 
label define label_control 3 "Private for-profit", add 
label values control label_control
label define label_affil 1 "Public" 
label define label_affil 2 "Private for-profit", add 
label define label_affil 3 "Private nonprofit independent", add 
label define label_affil 4 "Private nonprofit Catholic", add 
label define label_affil 5 "Private nonprofit Jewish", add 
label define label_affil 6 "Private nonprofit Protestant", add 
label define label_affil 7 "Private nonprofit other religious", add 
label values affil label_affil
label define label_hloffer 0 "Other" 
label define label_hloffer 1 "Less than one academic year", add 
label define label_hloffer 2 "At least one but less than two academic years", add 
label define label_hloffer 3 "Associates Degree", add 
label define label_hloffer 4 "At least two but less than four academic year", add 
label define label_hloffer 5 "Bachelors Degree", add 
label define label_hloffer 6 "Postbaccalaureate Certificate", add 
label define label_hloffer 7 "Masters Degree", add 
label define label_hloffer 8 "Post-Masters Certificate", add 
label define label_hloffer 9 "Doctors Degree", add 
label values hloffer label_hloffer
label define label_locale 1 "Large City" 
label define label_locale 2 "Mid-size City", add 
label define label_locale 3 "Urban Fringe of Large City", add 
label define label_locale 4 "Urban Fringe of Mid-size City", add 
label define label_locale 5 "Large Town", add 
label define label_locale 6 "Small Town", add 
label define label_locale 7 "Rural", add 
label define label_locale 9 "Not Assigned", add 
label values locale label_locale
label define label_carnegie 11 "Research universities I" 
label define label_carnegie 12 "Research universities II", add 
label define label_carnegie 13 "Doctoral universities I", add 
label define label_carnegie 14 "Doctoral universities II", add 
label define label_carnegie 21 "Masters comprehensive I", add 
label define label_carnegie 22 "Masters comprehensive II", add 
label define label_carnegie 31 "BA liberal arts colleges I", add 
label define label_carnegie 32 "Baccalaureate colleges II", add 
label define label_carnegie 40 "Associate of arts colleges", add 
label define label_carnegie 51 "Theological seminaries", add 
label define label_carnegie 52 "Medical schools", add 
label define label_carnegie 53 "Other health profession schools", add 
label define label_carnegie 54 "Schools of engineering and technology", add 
label define label_carnegie 55 "Schools of business and management", add 
label define label_carnegie 56 "Schools of art, music, and design", add 
label define label_carnegie 57 "Schools of law", add 
label define label_carnegie 58 "Teachers colleges", add 
label define label_carnegie 59 "Other specialized institutions", add 
label define label_carnegie 60 "Tribal colleges", add 
label values carnegie label_carnegie
label define label_source 4 "Form" 
label define label_source 6 "PETS", add 
label values source label_source
label define label_opeind 1 "Institution is eligible" 
label define label_opeind 2 "Branch campus of eligible", add 
label define label_opeind 3 "Not Eligible in 1997, eligible in 1996", add 
label define label_opeind 9 "On OPE file, not eligible", add 
label values opeind label_opeind
label define label_hdegoffr 0 "Non-degree granting" 
label define label_hdegoffr 1 "First-professional degrees only", add 
label define label_hdegoffr 10 "Doctoral", add 
label define label_hdegoffr 11 "Doctoral and First-professional", add 
label define label_hdegoffr 20 "Masters", add 
label define label_hdegoffr 21 "Masters and First-professional", add 
label define label_hdegoffr 30 "Bachelors", add 
label define label_hdegoffr 31 "Bachelors and First-professional", add 
label define label_hdegoffr 40 "Associates", add 
label values hdegoffr label_hdegoffr
label define label_ncesedit 1 "Edited no critical errors remain" 
label define label_ncesedit 2 "Edited corrected/accepted errors", add 
label define label_ncesedit 3 "Edited errors not resolved", add 
label values ncesedit label_ncesedit
/*
label define label_formrt IC1 "IC1" 
label define label_formrt IC3 "IC3", add 
label define label_formrt IC4 "IC4", add 
label define label_formrt ICA "IC ADD form", add 
label values formrt label_formrt
*/
label define label_resplast 1 "Respondent" 
label define label_resplast 3 "Nonrespondent not imputed", add 
label values resplast label_resplast
label define label_respstat 1 "Respondent" 
label define label_respstat 3 "Nonrespondent used last year", add 
label values respstat label_respstat
tab stabbr
tab fips
tab obereg
tab rstatus
tab imptype
tab parchild
tab sector
tab iclevel
tab control
tab affil
tab hloffer
tab fpoffer
tab locale
tab hbcu
tab hospital
tab medical
tab tribal
tab carnegie
tab source
tab opeind
tab hdegoffr
tab ncesedit
tab formrt
tab resplast
tab respstat
summarize fice
summarize idx
summarize pctmin1
summarize pctmin2
summarize pctmin3
summarize pctmin4
summarize cntygeo
summarize congdist
save dct_ic9798_hdr

