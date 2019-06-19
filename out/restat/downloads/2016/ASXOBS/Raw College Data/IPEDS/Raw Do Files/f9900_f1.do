* Created: 6/12/2004 11:23:55 PM
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
insheet using "../Raw Data/f9900_f1_data_stata.csv", comma clear
label data "dct_f9900_f1"
label variable unitid "unitid"
label variable xa013 "Imputation field for A013 - Tuition and fees"
label variable a013 "Tuition and fees"
label variable xa023 "Imputation field for A023 - Federal appropriations"
label variable a023 "Federal appropriations"
label variable xa043 "Imputation field for A043 - State appropriations"
label variable a043 "State appropriations"
label variable xa053 "Imputation field for A053 - Local appropriations"
label variable a053 "Local appropriations"
label variable xa063 "Imputation field for A063 - Federal grants and contracts"
label variable a063 "Federal grants and contracts"
label variable xa073 "Imputation field for A073 - State grants and contracts"
label variable a073 "State grants and contracts"
label variable xa083 "Imputation field for A083 - Local grants and contracts"
label variable a083 "Local grants and contracts"
label variable xa093 "Imputation field for A093 - Private gifts, grants and contracts"
label variable a093 "Private gifts, grants and contracts"
label variable xa103 "Imputation field for A103 - Endowment income"
label variable a103 "Endowment income"
label variable xa113 "Imputation field for A113 - Sales and services of educational activiti"
label variable a113 "Sales and services of educational activiti"
label variable xa123 "Imputation field for A123 - Auxiliary enterprises"
label variable a123 "Auxiliary enterprises"
label variable xa133 "Imputation field for A133 - Hospital revenues"
label variable a133 "Hospital revenues"
label variable xa143 "Imputation field for A143 - Other sources"
label variable a143 "Other sources"
label variable xa153 "Imputation field for A153 - Independent operations"
label variable a153 "Independent operations"
label variable xa163 "Imputation field for A163 - Total current funds revenues"
label variable a163 "Total current funds revenues"
label variable xj013 "Imputation field for J013 - Total federal revenues"
label variable j013 "Total federal revenues"
label variable xj023 "Imputation field for J023 - Total state revenues"
label variable j023 "Total state revenues"
label variable xj033 "Imputation field for J033 - Total local revenues"
label variable j033 "Total local revenues"
label variable xj043 "Imputation field for J043 - Total sales and services"
label variable j043 "Total sales and services"
label variable xj053 "Imputation field for J053 - Total gifts, grants, contracts"
label variable j053 "Total gifts, grants, contracts"
label variable xj063 "Imputation field for J063 - Total endowment income"
label variable j063 "Total endowment income"
label variable xj073 "Imputation field for J073 - Total other sources"
label variable j073 "Total other sources"
label variable xj083 "Imputation field for J083 - Total all revenues"
label variable j083 "Total all revenues"
label variable xb013 "Imputation field for B013 - Instruction"
label variable b013 "Instruction"
label variable xb023 "Imputation field for B023 - Research"
label variable b023 "Research"
label variable xb033 "Imputation field for B033 - Public service"
label variable b033 "Public service"
label variable xb043 "Imputation field for B043 - Academic support"
label variable b043 "Academic support"
label variable xb063 "Imputation field for B063 - Student services"
label variable b063 "Student services"
label variable xb073 "Imputation field for B073 - Institutional support"
label variable b073 "Institutional support"
label variable xb083 "Imputation field for B083 - Operation and maintenance of plant"
label variable b083 "Operation and maintenance of plant"
label variable xb093 "Imputation field for B093 - Scholarships and fellowships"
label variable b093 "Scholarships and fellowships"
label variable xb103 "Imputation field for B103 - Mandatory transfers"
label variable b103 "Mandatory transfers"
label variable xb113 "Imputation field for B113 - Nonmandatory transfers"
label variable b113 "Nonmandatory transfers"
label variable xb123 "Imputation field for B123 - Total educational and general expenditures"
label variable b123 "Total educational and general expenditures"
label variable xb133 "Imputation field for B133 - Auxiliary enterprises"
label variable b133 "Auxiliary enterprises"
label variable xbline15 "Imputation field for BLINE15 - Auxiliary enterprises (nonmandatory)"
label variable bline15 "Auxiliary enterprises (nonmandatory)"
label variable xb163 "Imputation field for B163 - Hospital expenditures"
label variable b163 "Hospital expenditures"
label variable xbline18 "Imputation field for BLINE18 - Hospitals (nonmandatory)"
label variable bline18 "Hospitals (nonmandatory)"
label variable xb193 "Imputation field for B193 - Independent operations"
label variable b193 "Independent operations"
label variable xbline21 "Imputation field for BLINE21 - Independent operations (nonmandatory)"
label variable bline21 "Independent operations (nonmandatory)"
label variable xbother "Imputation field for BOTHER - Other current funds expenditure"
label variable bother "Other current funds expenditure"
label variable xb223 "Imputation field for B223 - Total current funds expenditures and trans"
label variable b223 "Total current funds expenditures and trans"
label variable xb234 "Imputation field for B234 - Amnt salaries and wages total E and G expend"
label variable b234 "Amnt salaries and wages total E and G expend"
label variable xb244 "Imputation field for B244 - Employee fringe benefits-institutional"
label variable b244 "Employee fringe benefits-institutional"
label variable xb254 "Imputation field for B254 - E and G employee fringe benefits paid from noninstitutional accounts"
label variable b254 "E and G employee fringe benefits paid from noninstitutional accounts"
label variable xb274 "Imputation field for B274 - Total E and G employee compensation"
label variable b274 "Total E and G employee compensation"
label variable xe013 "Imputation field for E013 - Pell Grants"
label variable e013 "Pell Grants"
label variable xe023 "Imputation field for E023 - Other federal government"
label variable e023 "Other federal government"
label variable xe033 "Imputation field for E033 - State government"
label variable e033 "State government"
label variable xe043 "Imputation field for E043 - Local government"
label variable e043 "Local government"
label variable xe053 "Imputation field for E053 - Private"
label variable e053 "Private"
label variable xe063 "Imputation field for E063 - Institutional"
label variable e063 "Institutional"
label variable xe073 "Imputation field for E073 - Total scholarship and fellowship"
label variable e073 "Total scholarship and fellowship"
label variable xg01 "Imputation field for G01 - Balance owed on principal at begin of year"
label variable g01 "Balance owed on principal at begin of year"
label variable xg02 "Imputation field for G02 - Additional principal borrowed during year"
label variable g02 "Additional principal borrowed during year"
label variable xg03 "Imputation field for G03 - Payments made on principal during year"
label variable g03 "Payments made on principal during year"
label variable xg04 "Imputation field for G04 - Balance owed on principal at end of year"
label variable g04 "Balance owed on principal at end of year"
label variable xg05 "Imputation field for G05 - Intrst paymnts on physical plant indebtd"
label variable g05 "Intrst paymnts on physical plant indebtd"
label variable fha "Institution owns endowment assets"
label variable xh011 "Imputation field for H011 - Beginning value of endowment assets-book"
label variable h011 "Beginning value of endowment assets-book"
label variable xh012 "Imputation field for H012 - Beginning value of endowment assets-market"
label variable h012 "Beginning value of endowment assets-market"
label variable xh021 "Imputation field for H021 - Ending value of endowment assets-book"
label variable h021 "Ending value of endowment assets-book"
label variable xh022 "Imputation field for H022 - Ending value of endowment assets-market"
label variable h022 "Ending value of endowment assets-market"
label variable xk014 "Imputation field for K014 - Ending book value - land"
label variable k014 "Ending book value - land"
label variable xk025 "Imputation field for K025 - Current replacement value - buildings"
label variable k025 "Current replacement value - buildings"
label variable xk035 "Imputation field for K035 - Current replacement value - equipment"
label variable k035 "Current replacement value - equipment"
label define label_xa013 10 "Reported" 
label define label_xa013 11 "Analyst corrected reported value", add 
label define label_xa013 12 "Data generated from other data values", add 
label define label_xa013 13 "Implied zero", add 
label define label_xa013 20 "Imputed using Carry Forward procedure", add 
label define label_xa013 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa013 30 "Not applicable", add 
label define label_xa013 31 "Institution left item blank", add 
label define label_xa013 32 "Do not know", add 
label define label_xa013 40 "Suppressed to protect confidentiality", add 
label values xa013 label_xa013
label define label_xa023 10 "Reported" 
label define label_xa023 11 "Analyst corrected reported value", add 
label define label_xa023 12 "Data generated from other data values", add 
label define label_xa023 13 "Implied zero", add 
label define label_xa023 20 "Imputed using Carry Forward procedure", add 
label define label_xa023 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa023 30 "Not applicable", add 
label define label_xa023 31 "Institution left item blank", add 
label define label_xa023 32 "Do not know", add 
label define label_xa023 40 "Suppressed to protect confidentiality", add 
label values xa023 label_xa023
label define label_xa043 10 "Reported" 
label define label_xa043 11 "Analyst corrected reported value", add 
label define label_xa043 12 "Data generated from other data values", add 
label define label_xa043 13 "Implied zero", add 
label define label_xa043 20 "Imputed using Carry Forward procedure", add 
label define label_xa043 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa043 30 "Not applicable", add 
label define label_xa043 31 "Institution left item blank", add 
label define label_xa043 32 "Do not know", add 
label define label_xa043 40 "Suppressed to protect confidentiality", add 
label values xa043 label_xa043
label define label_xa053 10 "Reported" 
label define label_xa053 11 "Analyst corrected reported value", add 
label define label_xa053 12 "Data generated from other data values", add 
label define label_xa053 13 "Implied zero", add 
label define label_xa053 20 "Imputed using Carry Forward procedure", add 
label define label_xa053 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa053 30 "Not applicable", add 
label define label_xa053 31 "Institution left item blank", add 
label define label_xa053 32 "Do not know", add 
label define label_xa053 40 "Suppressed to protect confidentiality", add 
label values xa053 label_xa053
label define label_xa063 10 "Reported" 
label define label_xa063 11 "Analyst corrected reported value", add 
label define label_xa063 12 "Data generated from other data values", add 
label define label_xa063 13 "Implied zero", add 
label define label_xa063 20 "Imputed using Carry Forward procedure", add 
label define label_xa063 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa063 30 "Not applicable", add 
label define label_xa063 31 "Institution left item blank", add 
label define label_xa063 32 "Do not know", add 
label define label_xa063 40 "Suppressed to protect confidentiality", add 
label values xa063 label_xa063
label define label_xa073 10 "Reported" 
label define label_xa073 11 "Analyst corrected reported value", add 
label define label_xa073 12 "Data generated from other data values", add 
label define label_xa073 13 "Implied zero", add 
label define label_xa073 20 "Imputed using Carry Forward procedure", add 
label define label_xa073 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa073 30 "Not applicable", add 
label define label_xa073 31 "Institution left item blank", add 
label define label_xa073 32 "Do not know", add 
label define label_xa073 40 "Suppressed to protect confidentiality", add 
label values xa073 label_xa073
label define label_xa083 10 "Reported" 
label define label_xa083 11 "Analyst corrected reported value", add 
label define label_xa083 12 "Data generated from other data values", add 
label define label_xa083 13 "Implied zero", add 
label define label_xa083 20 "Imputed using Carry Forward procedure", add 
label define label_xa083 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa083 30 "Not applicable", add 
label define label_xa083 31 "Institution left item blank", add 
label define label_xa083 32 "Do not know", add 
label define label_xa083 40 "Suppressed to protect confidentiality", add 
label values xa083 label_xa083
label define label_xa093 10 "Reported" 
label define label_xa093 11 "Analyst corrected reported value", add 
label define label_xa093 12 "Data generated from other data values", add 
label define label_xa093 13 "Implied zero", add 
label define label_xa093 20 "Imputed using Carry Forward procedure", add 
label define label_xa093 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa093 30 "Not applicable", add 
label define label_xa093 31 "Institution left item blank", add 
label define label_xa093 32 "Do not know", add 
label define label_xa093 40 "Suppressed to protect confidentiality", add 
label values xa093 label_xa093
label define label_xa103 10 "Reported" 
label define label_xa103 11 "Analyst corrected reported value", add 
label define label_xa103 12 "Data generated from other data values", add 
label define label_xa103 13 "Implied zero", add 
label define label_xa103 20 "Imputed using Carry Forward procedure", add 
label define label_xa103 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa103 30 "Not applicable", add 
label define label_xa103 31 "Institution left item blank", add 
label define label_xa103 32 "Do not know", add 
label define label_xa103 40 "Suppressed to protect confidentiality", add 
label values xa103 label_xa103
label define label_xa113 10 "Reported" 
label define label_xa113 11 "Analyst corrected reported value", add 
label define label_xa113 12 "Data generated from other data values", add 
label define label_xa113 13 "Implied zero", add 
label define label_xa113 20 "Imputed using Carry Forward procedure", add 
label define label_xa113 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa113 30 "Not applicable", add 
label define label_xa113 31 "Institution left item blank", add 
label define label_xa113 32 "Do not know", add 
label define label_xa113 40 "Suppressed to protect confidentiality", add 
label values xa113 label_xa113
label define label_xa123 10 "Reported" 
label define label_xa123 11 "Analyst corrected reported value", add 
label define label_xa123 12 "Data generated from other data values", add 
label define label_xa123 13 "Implied zero", add 
label define label_xa123 20 "Imputed using Carry Forward procedure", add 
label define label_xa123 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa123 30 "Not applicable", add 
label define label_xa123 31 "Institution left item blank", add 
label define label_xa123 32 "Do not know", add 
label define label_xa123 40 "Suppressed to protect confidentiality", add 
label values xa123 label_xa123
label define label_xa133 10 "Reported" 
label define label_xa133 11 "Analyst corrected reported value", add 
label define label_xa133 12 "Data generated from other data values", add 
label define label_xa133 13 "Implied zero", add 
label define label_xa133 20 "Imputed using Carry Forward procedure", add 
label define label_xa133 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa133 30 "Not applicable", add 
label define label_xa133 31 "Institution left item blank", add 
label define label_xa133 32 "Do not know", add 
label define label_xa133 40 "Suppressed to protect confidentiality", add 
label values xa133 label_xa133
label define label_xa143 10 "Reported" 
label define label_xa143 11 "Analyst corrected reported value", add 
label define label_xa143 12 "Data generated from other data values", add 
label define label_xa143 13 "Implied zero", add 
label define label_xa143 20 "Imputed using Carry Forward procedure", add 
label define label_xa143 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa143 30 "Not applicable", add 
label define label_xa143 31 "Institution left item blank", add 
label define label_xa143 32 "Do not know", add 
label define label_xa143 40 "Suppressed to protect confidentiality", add 
label values xa143 label_xa143
label define label_xa153 10 "Reported" 
label define label_xa153 11 "Analyst corrected reported value", add 
label define label_xa153 12 "Data generated from other data values", add 
label define label_xa153 13 "Implied zero", add 
label define label_xa153 20 "Imputed using Carry Forward procedure", add 
label define label_xa153 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa153 30 "Not applicable", add 
label define label_xa153 31 "Institution left item blank", add 
label define label_xa153 32 "Do not know", add 
label define label_xa153 40 "Suppressed to protect confidentiality", add 
label values xa153 label_xa153
label define label_xa163 10 "Reported" 
label define label_xa163 11 "Analyst corrected reported value", add 
label define label_xa163 12 "Data generated from other data values", add 
label define label_xa163 13 "Implied zero", add 
label define label_xa163 20 "Imputed using Carry Forward procedure", add 
label define label_xa163 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xa163 30 "Not applicable", add 
label define label_xa163 31 "Institution left item blank", add 
label define label_xa163 32 "Do not know", add 
label define label_xa163 40 "Suppressed to protect confidentiality", add 
label values xa163 label_xa163
label define label_xj013 10 "Reported" 
label define label_xj013 11 "Analyst corrected reported value", add 
label define label_xj013 12 "Data generated from other data values", add 
label define label_xj013 13 "Implied zero", add 
label define label_xj013 20 "Imputed using Carry Forward procedure", add 
label define label_xj013 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xj013 30 "Not applicable", add 
label define label_xj013 31 "Institution left item blank", add 
label define label_xj013 32 "Do not know", add 
label define label_xj013 40 "Suppressed to protect confidentiality", add 
label values xj013 label_xj013
label define label_xj023 10 "Reported" 
label define label_xj023 11 "Analyst corrected reported value", add 
label define label_xj023 12 "Data generated from other data values", add 
label define label_xj023 13 "Implied zero", add 
label define label_xj023 20 "Imputed using Carry Forward procedure", add 
label define label_xj023 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xj023 30 "Not applicable", add 
label define label_xj023 31 "Institution left item blank", add 
label define label_xj023 32 "Do not know", add 
label define label_xj023 40 "Suppressed to protect confidentiality", add 
label values xj023 label_xj023
label define label_xj033 10 "Reported" 
label define label_xj033 11 "Analyst corrected reported value", add 
label define label_xj033 12 "Data generated from other data values", add 
label define label_xj033 13 "Implied zero", add 
label define label_xj033 20 "Imputed using Carry Forward procedure", add 
label define label_xj033 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xj033 30 "Not applicable", add 
label define label_xj033 31 "Institution left item blank", add 
label define label_xj033 32 "Do not know", add 
label define label_xj033 40 "Suppressed to protect confidentiality", add 
label values xj033 label_xj033
label define label_xj043 10 "Reported" 
label define label_xj043 11 "Analyst corrected reported value", add 
label define label_xj043 12 "Data generated from other data values", add 
label define label_xj043 13 "Implied zero", add 
label define label_xj043 20 "Imputed using Carry Forward procedure", add 
label define label_xj043 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xj043 30 "Not applicable", add 
label define label_xj043 31 "Institution left item blank", add 
label define label_xj043 32 "Do not know", add 
label define label_xj043 40 "Suppressed to protect confidentiality", add 
label values xj043 label_xj043
label define label_xj053 10 "Reported" 
label define label_xj053 11 "Analyst corrected reported value", add 
label define label_xj053 12 "Data generated from other data values", add 
label define label_xj053 13 "Implied zero", add 
label define label_xj053 20 "Imputed using Carry Forward procedure", add 
label define label_xj053 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xj053 30 "Not applicable", add 
label define label_xj053 31 "Institution left item blank", add 
label define label_xj053 32 "Do not know", add 
label define label_xj053 40 "Suppressed to protect confidentiality", add 
label values xj053 label_xj053
label define label_xj063 10 "Reported" 
label define label_xj063 11 "Analyst corrected reported value", add 
label define label_xj063 12 "Data generated from other data values", add 
label define label_xj063 13 "Implied zero", add 
label define label_xj063 20 "Imputed using Carry Forward procedure", add 
label define label_xj063 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xj063 30 "Not applicable", add 
label define label_xj063 31 "Institution left item blank", add 
label define label_xj063 32 "Do not know", add 
label define label_xj063 40 "Suppressed to protect confidentiality", add 
label values xj063 label_xj063
label define label_xj073 10 "Reported" 
label define label_xj073 11 "Analyst corrected reported value", add 
label define label_xj073 12 "Data generated from other data values", add 
label define label_xj073 13 "Implied zero", add 
label define label_xj073 20 "Imputed using Carry Forward procedure", add 
label define label_xj073 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xj073 30 "Not applicable", add 
label define label_xj073 31 "Institution left item blank", add 
label define label_xj073 32 "Do not know", add 
label define label_xj073 40 "Suppressed to protect confidentiality", add 
label values xj073 label_xj073
label define label_xj083 10 "Reported" 
label define label_xj083 11 "Analyst corrected reported value", add 
label define label_xj083 12 "Data generated from other data values", add 
label define label_xj083 13 "Implied zero", add 
label define label_xj083 20 "Imputed using Carry Forward procedure", add 
label define label_xj083 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xj083 30 "Not applicable", add 
label define label_xj083 31 "Institution left item blank", add 
label define label_xj083 32 "Do not know", add 
label define label_xj083 40 "Suppressed to protect confidentiality", add 
label values xj083 label_xj083
label define label_xb013 10 "Reported" 
label define label_xb013 11 "Analyst corrected reported value", add 
label define label_xb013 12 "Data generated from other data values", add 
label define label_xb013 13 "Implied zero", add 
label define label_xb013 20 "Imputed using Carry Forward procedure", add 
label define label_xb013 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb013 30 "Not applicable", add 
label define label_xb013 31 "Institution left item blank", add 
label define label_xb013 32 "Do not know", add 
label define label_xb013 40 "Suppressed to protect confidentiality", add 
label values xb013 label_xb013
label define label_xb023 10 "Reported" 
label define label_xb023 11 "Analyst corrected reported value", add 
label define label_xb023 12 "Data generated from other data values", add 
label define label_xb023 13 "Implied zero", add 
label define label_xb023 20 "Imputed using Carry Forward procedure", add 
label define label_xb023 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb023 30 "Not applicable", add 
label define label_xb023 31 "Institution left item blank", add 
label define label_xb023 32 "Do not know", add 
label define label_xb023 40 "Suppressed to protect confidentiality", add 
label values xb023 label_xb023
label define label_xb033 10 "Reported" 
label define label_xb033 11 "Analyst corrected reported value", add 
label define label_xb033 12 "Data generated from other data values", add 
label define label_xb033 13 "Implied zero", add 
label define label_xb033 20 "Imputed using Carry Forward procedure", add 
label define label_xb033 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb033 30 "Not applicable", add 
label define label_xb033 31 "Institution left item blank", add 
label define label_xb033 32 "Do not know", add 
label define label_xb033 40 "Suppressed to protect confidentiality", add 
label values xb033 label_xb033
label define label_xb043 10 "Reported" 
label define label_xb043 11 "Analyst corrected reported value", add 
label define label_xb043 12 "Data generated from other data values", add 
label define label_xb043 13 "Implied zero", add 
label define label_xb043 20 "Imputed using Carry Forward procedure", add 
label define label_xb043 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb043 30 "Not applicable", add 
label define label_xb043 31 "Institution left item blank", add 
label define label_xb043 32 "Do not know", add 
label define label_xb043 40 "Suppressed to protect confidentiality", add 
label values xb043 label_xb043
label define label_xb063 10 "Reported" 
label define label_xb063 11 "Analyst corrected reported value", add 
label define label_xb063 12 "Data generated from other data values", add 
label define label_xb063 13 "Implied zero", add 
label define label_xb063 20 "Imputed using Carry Forward procedure", add 
label define label_xb063 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb063 30 "Not applicable", add 
label define label_xb063 31 "Institution left item blank", add 
label define label_xb063 32 "Do not know", add 
label define label_xb063 40 "Suppressed to protect confidentiality", add 
label values xb063 label_xb063
label define label_xb073 10 "Reported" 
label define label_xb073 11 "Analyst corrected reported value", add 
label define label_xb073 12 "Data generated from other data values", add 
label define label_xb073 13 "Implied zero", add 
label define label_xb073 20 "Imputed using Carry Forward procedure", add 
label define label_xb073 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb073 30 "Not applicable", add 
label define label_xb073 31 "Institution left item blank", add 
label define label_xb073 32 "Do not know", add 
label define label_xb073 40 "Suppressed to protect confidentiality", add 
label values xb073 label_xb073
label define label_xb083 10 "Reported" 
label define label_xb083 11 "Analyst corrected reported value", add 
label define label_xb083 12 "Data generated from other data values", add 
label define label_xb083 13 "Implied zero", add 
label define label_xb083 20 "Imputed using Carry Forward procedure", add 
label define label_xb083 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb083 30 "Not applicable", add 
label define label_xb083 31 "Institution left item blank", add 
label define label_xb083 32 "Do not know", add 
label define label_xb083 40 "Suppressed to protect confidentiality", add 
label values xb083 label_xb083
label define label_xb093 10 "Reported" 
label define label_xb093 11 "Analyst corrected reported value", add 
label define label_xb093 12 "Data generated from other data values", add 
label define label_xb093 13 "Implied zero", add 
label define label_xb093 20 "Imputed using Carry Forward procedure", add 
label define label_xb093 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb093 30 "Not applicable", add 
label define label_xb093 31 "Institution left item blank", add 
label define label_xb093 32 "Do not know", add 
label define label_xb093 40 "Suppressed to protect confidentiality", add 
label values xb093 label_xb093
label define label_xb103 10 "Reported" 
label define label_xb103 11 "Analyst corrected reported value", add 
label define label_xb103 12 "Data generated from other data values", add 
label define label_xb103 13 "Implied zero", add 
label define label_xb103 20 "Imputed using Carry Forward procedure", add 
label define label_xb103 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb103 30 "Not applicable", add 
label define label_xb103 31 "Institution left item blank", add 
label define label_xb103 32 "Do not know", add 
label define label_xb103 40 "Suppressed to protect confidentiality", add 
label values xb103 label_xb103
label define label_xb113 10 "Reported" 
label define label_xb113 11 "Analyst corrected reported value", add 
label define label_xb113 12 "Data generated from other data values", add 
label define label_xb113 13 "Implied zero", add 
label define label_xb113 20 "Imputed using Carry Forward procedure", add 
label define label_xb113 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb113 30 "Not applicable", add 
label define label_xb113 31 "Institution left item blank", add 
label define label_xb113 32 "Do not know", add 
label define label_xb113 40 "Suppressed to protect confidentiality", add 
label values xb113 label_xb113
label define label_xb123 10 "Reported" 
label define label_xb123 11 "Analyst corrected reported value", add 
label define label_xb123 12 "Data generated from other data values", add 
label define label_xb123 13 "Implied zero", add 
label define label_xb123 20 "Imputed using Carry Forward procedure", add 
label define label_xb123 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb123 30 "Not applicable", add 
label define label_xb123 31 "Institution left item blank", add 
label define label_xb123 32 "Do not know", add 
label define label_xb123 40 "Suppressed to protect confidentiality", add 
label values xb123 label_xb123
label define label_xb133 10 "Reported" 
label define label_xb133 11 "Analyst corrected reported value", add 
label define label_xb133 12 "Data generated from other data values", add 
label define label_xb133 13 "Implied zero", add 
label define label_xb133 20 "Imputed using Carry Forward procedure", add 
label define label_xb133 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb133 30 "Not applicable", add 
label define label_xb133 31 "Institution left item blank", add 
label define label_xb133 32 "Do not know", add 
label define label_xb133 40 "Suppressed to protect confidentiality", add 
label values xb133 label_xb133
label define label_xbline15 10 "Reported" 
label define label_xbline15 11 "Analyst corrected reported value", add 
label define label_xbline15 12 "Data generated from other data values", add 
label define label_xbline15 13 "Implied zero", add 
label define label_xbline15 20 "Imputed using Carry Forward procedure", add 
label define label_xbline15 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xbline15 30 "Not applicable", add 
label define label_xbline15 31 "Institution left item blank", add 
label define label_xbline15 32 "Do not know", add 
label define label_xbline15 40 "Suppressed to protect confidentiality", add 
label values xbline15 label_xbline15
label define label_xb163 10 "Reported" 
label define label_xb163 11 "Analyst corrected reported value", add 
label define label_xb163 12 "Data generated from other data values", add 
label define label_xb163 13 "Implied zero", add 
label define label_xb163 20 "Imputed using Carry Forward procedure", add 
label define label_xb163 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb163 30 "Not applicable", add 
label define label_xb163 31 "Institution left item blank", add 
label define label_xb163 32 "Do not know", add 
label define label_xb163 40 "Suppressed to protect confidentiality", add 
label values xb163 label_xb163
label define label_xbline18 10 "Reported" 
label define label_xbline18 11 "Analyst corrected reported value", add 
label define label_xbline18 12 "Data generated from other data values", add 
label define label_xbline18 13 "Implied zero", add 
label define label_xbline18 20 "Imputed using Carry Forward procedure", add 
label define label_xbline18 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xbline18 30 "Not applicable", add 
label define label_xbline18 31 "Institution left item blank", add 
label define label_xbline18 32 "Do not know", add 
label define label_xbline18 40 "Suppressed to protect confidentiality", add 
label values xbline18 label_xbline18
label define label_xb193 10 "Reported" 
label define label_xb193 11 "Analyst corrected reported value", add 
label define label_xb193 12 "Data generated from other data values", add 
label define label_xb193 13 "Implied zero", add 
label define label_xb193 20 "Imputed using Carry Forward procedure", add 
label define label_xb193 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb193 30 "Not applicable", add 
label define label_xb193 31 "Institution left item blank", add 
label define label_xb193 32 "Do not know", add 
label define label_xb193 40 "Suppressed to protect confidentiality", add 
label values xb193 label_xb193
label define label_xbline21 10 "Reported" 
label define label_xbline21 11 "Analyst corrected reported value", add 
label define label_xbline21 12 "Data generated from other data values", add 
label define label_xbline21 13 "Implied zero", add 
label define label_xbline21 20 "Imputed using Carry Forward procedure", add 
label define label_xbline21 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xbline21 30 "Not applicable", add 
label define label_xbline21 31 "Institution left item blank", add 
label define label_xbline21 32 "Do not know", add 
label define label_xbline21 40 "Suppressed to protect confidentiality", add 
label values xbline21 label_xbline21
label define label_xbother 10 "Reported" 
label define label_xbother 11 "Analyst corrected reported value", add 
label define label_xbother 12 "Data generated from other data values", add 
label define label_xbother 13 "Implied zero", add 
label define label_xbother 20 "Imputed using Carry Forward procedure", add 
label define label_xbother 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xbother 30 "Not applicable", add 
label define label_xbother 31 "Institution left item blank", add 
label define label_xbother 32 "Do not know", add 
label define label_xbother 40 "Suppressed to protect confidentiality", add 
label values xbother label_xbother
label define label_xb223 10 "Reported" 
label define label_xb223 11 "Analyst corrected reported value", add 
label define label_xb223 12 "Data generated from other data values", add 
label define label_xb223 13 "Implied zero", add 
label define label_xb223 20 "Imputed using Carry Forward procedure", add 
label define label_xb223 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb223 30 "Not applicable", add 
label define label_xb223 31 "Institution left item blank", add 
label define label_xb223 32 "Do not know", add 
label define label_xb223 40 "Suppressed to protect confidentiality", add 
label values xb223 label_xb223
label define label_xb234 10 "Reported" 
label define label_xb234 11 "Analyst corrected reported value", add 
label define label_xb234 12 "Data generated from other data values", add 
label define label_xb234 13 "Implied zero", add 
label define label_xb234 20 "Imputed using Carry Forward procedure", add 
label define label_xb234 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb234 30 "Not applicable", add 
label define label_xb234 31 "Institution left item blank", add 
label define label_xb234 32 "Do not know", add 
label define label_xb234 40 "Suppressed to protect confidentiality", add 
label values xb234 label_xb234
label define label_xb244 10 "Reported" 
label define label_xb244 11 "Analyst corrected reported value", add 
label define label_xb244 12 "Data generated from other data values", add 
label define label_xb244 13 "Implied zero", add 
label define label_xb244 20 "Imputed using Carry Forward procedure", add 
label define label_xb244 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb244 30 "Not applicable", add 
label define label_xb244 31 "Institution left item blank", add 
label define label_xb244 32 "Do not know", add 
label define label_xb244 40 "Suppressed to protect confidentiality", add 
label values xb244 label_xb244
label define label_xb254 10 "Reported" 
label define label_xb254 11 "Analyst corrected reported value", add 
label define label_xb254 12 "Data generated from other data values", add 
label define label_xb254 13 "Implied zero", add 
label define label_xb254 20 "Imputed using Carry Forward procedure", add 
label define label_xb254 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb254 30 "Not applicable", add 
label define label_xb254 31 "Institution left item blank", add 
label define label_xb254 32 "Do not know", add 
label define label_xb254 40 "Suppressed to protect confidentiality", add 
label values xb254 label_xb254
label define label_xb274 10 "Reported" 
label define label_xb274 11 "Analyst corrected reported value", add 
label define label_xb274 12 "Data generated from other data values", add 
label define label_xb274 13 "Implied zero", add 
label define label_xb274 20 "Imputed using Carry Forward procedure", add 
label define label_xb274 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xb274 30 "Not applicable", add 
label define label_xb274 31 "Institution left item blank", add 
label define label_xb274 32 "Do not know", add 
label define label_xb274 40 "Suppressed to protect confidentiality", add 
label values xb274 label_xb274
label define label_xe013 10 "Reported" 
label define label_xe013 11 "Analyst corrected reported value", add 
label define label_xe013 12 "Data generated from other data values", add 
label define label_xe013 13 "Implied zero", add 
label define label_xe013 20 "Imputed using Carry Forward procedure", add 
label define label_xe013 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xe013 30 "Not applicable", add 
label define label_xe013 31 "Institution left item blank", add 
label define label_xe013 32 "Do not know", add 
label define label_xe013 40 "Suppressed to protect confidentiality", add 
label values xe013 label_xe013
label define label_xe023 10 "Reported" 
label define label_xe023 11 "Analyst corrected reported value", add 
label define label_xe023 12 "Data generated from other data values", add 
label define label_xe023 13 "Implied zero", add 
label define label_xe023 20 "Imputed using Carry Forward procedure", add 
label define label_xe023 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xe023 30 "Not applicable", add 
label define label_xe023 31 "Institution left item blank", add 
label define label_xe023 32 "Do not know", add 
label define label_xe023 40 "Suppressed to protect confidentiality", add 
label values xe023 label_xe023
label define label_xe033 10 "Reported" 
label define label_xe033 11 "Analyst corrected reported value", add 
label define label_xe033 12 "Data generated from other data values", add 
label define label_xe033 13 "Implied zero", add 
label define label_xe033 20 "Imputed using Carry Forward procedure", add 
label define label_xe033 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xe033 30 "Not applicable", add 
label define label_xe033 31 "Institution left item blank", add 
label define label_xe033 32 "Do not know", add 
label define label_xe033 40 "Suppressed to protect confidentiality", add 
label values xe033 label_xe033
label define label_xe043 10 "Reported" 
label define label_xe043 11 "Analyst corrected reported value", add 
label define label_xe043 12 "Data generated from other data values", add 
label define label_xe043 13 "Implied zero", add 
label define label_xe043 20 "Imputed using Carry Forward procedure", add 
label define label_xe043 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xe043 30 "Not applicable", add 
label define label_xe043 31 "Institution left item blank", add 
label define label_xe043 32 "Do not know", add 
label define label_xe043 40 "Suppressed to protect confidentiality", add 
label values xe043 label_xe043
label define label_xe053 10 "Reported" 
label define label_xe053 11 "Analyst corrected reported value", add 
label define label_xe053 12 "Data generated from other data values", add 
label define label_xe053 13 "Implied zero", add 
label define label_xe053 20 "Imputed using Carry Forward procedure", add 
label define label_xe053 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xe053 30 "Not applicable", add 
label define label_xe053 31 "Institution left item blank", add 
label define label_xe053 32 "Do not know", add 
label define label_xe053 40 "Suppressed to protect confidentiality", add 
label values xe053 label_xe053
label define label_xe063 10 "Reported" 
label define label_xe063 11 "Analyst corrected reported value", add 
label define label_xe063 12 "Data generated from other data values", add 
label define label_xe063 13 "Implied zero", add 
label define label_xe063 20 "Imputed using Carry Forward procedure", add 
label define label_xe063 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xe063 30 "Not applicable", add 
label define label_xe063 31 "Institution left item blank", add 
label define label_xe063 32 "Do not know", add 
label define label_xe063 40 "Suppressed to protect confidentiality", add 
label values xe063 label_xe063
label define label_xe073 10 "Reported" 
label define label_xe073 11 "Analyst corrected reported value", add 
label define label_xe073 12 "Data generated from other data values", add 
label define label_xe073 13 "Implied zero", add 
label define label_xe073 20 "Imputed using Carry Forward procedure", add 
label define label_xe073 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xe073 30 "Not applicable", add 
label define label_xe073 31 "Institution left item blank", add 
label define label_xe073 32 "Do not know", add 
label define label_xe073 40 "Suppressed to protect confidentiality", add 
label values xe073 label_xe073
label define label_xg01 10 "Reported" 
label define label_xg01 11 "Analyst corrected reported value", add 
label define label_xg01 12 "Data generated from other data values", add 
label define label_xg01 13 "Implied zero", add 
label define label_xg01 20 "Imputed using Carry Forward procedure", add 
label define label_xg01 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xg01 30 "Not applicable", add 
label define label_xg01 31 "Institution left item blank", add 
label define label_xg01 32 "Do not know", add 
label define label_xg01 40 "Suppressed to protect confidentiality", add 
label values xg01 label_xg01
label define label_xg02 10 "Reported" 
label define label_xg02 11 "Analyst corrected reported value", add 
label define label_xg02 12 "Data generated from other data values", add 
label define label_xg02 13 "Implied zero", add 
label define label_xg02 20 "Imputed using Carry Forward procedure", add 
label define label_xg02 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xg02 30 "Not applicable", add 
label define label_xg02 31 "Institution left item blank", add 
label define label_xg02 32 "Do not know", add 
label define label_xg02 40 "Suppressed to protect confidentiality", add 
label values xg02 label_xg02
label define label_xg03 10 "Reported" 
label define label_xg03 11 "Analyst corrected reported value", add 
label define label_xg03 12 "Data generated from other data values", add 
label define label_xg03 13 "Implied zero", add 
label define label_xg03 20 "Imputed using Carry Forward procedure", add 
label define label_xg03 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xg03 30 "Not applicable", add 
label define label_xg03 31 "Institution left item blank", add 
label define label_xg03 32 "Do not know", add 
label define label_xg03 40 "Suppressed to protect confidentiality", add 
label values xg03 label_xg03
label define label_xg04 10 "Reported" 
label define label_xg04 11 "Analyst corrected reported value", add 
label define label_xg04 12 "Data generated from other data values", add 
label define label_xg04 13 "Implied zero", add 
label define label_xg04 20 "Imputed using Carry Forward procedure", add 
label define label_xg04 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xg04 30 "Not applicable", add 
label define label_xg04 31 "Institution left item blank", add 
label define label_xg04 32 "Do not know", add 
label define label_xg04 40 "Suppressed to protect confidentiality", add 
label values xg04 label_xg04
label define label_xg05 10 "Reported" 
label define label_xg05 11 "Analyst corrected reported value", add 
label define label_xg05 12 "Data generated from other data values", add 
label define label_xg05 13 "Implied zero", add 
label define label_xg05 20 "Imputed using Carry Forward procedure", add 
label define label_xg05 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xg05 30 "Not applicable", add 
label define label_xg05 31 "Institution left item blank", add 
label define label_xg05 32 "Do not know", add 
label define label_xg05 40 "Suppressed to protect confidentiality", add 
label values xg05 label_xg05
label define label_fha 1 "Yes" 
label define label_fha 2 "No", add 
label values fha label_fha
label define label_xh011 10 "Reported" 
label define label_xh011 11 "Analyst corrected reported value", add 
label define label_xh011 12 "Data generated from other data values", add 
label define label_xh011 13 "Implied zero", add 
label define label_xh011 20 "Imputed using Carry Forward procedure", add 
label define label_xh011 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xh011 30 "Not applicable", add 
label define label_xh011 31 "Institution left item blank", add 
label define label_xh011 32 "Do not know", add 
label define label_xh011 40 "Suppressed to protect confidentiality", add 
label values xh011 label_xh011
label define label_xh012 10 "Reported" 
label define label_xh012 11 "Analyst corrected reported value", add 
label define label_xh012 12 "Data generated from other data values", add 
label define label_xh012 13 "Implied zero", add 
label define label_xh012 20 "Imputed using Carry Forward procedure", add 
label define label_xh012 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xh012 30 "Not applicable", add 
label define label_xh012 31 "Institution left item blank", add 
label define label_xh012 32 "Do not know", add 
label define label_xh012 40 "Suppressed to protect confidentiality", add 
label values xh012 label_xh012
label define label_xh021 10 "Reported" 
label define label_xh021 11 "Analyst corrected reported value", add 
label define label_xh021 12 "Data generated from other data values", add 
label define label_xh021 13 "Implied zero", add 
label define label_xh021 20 "Imputed using Carry Forward procedure", add 
label define label_xh021 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xh021 30 "Not applicable", add 
label define label_xh021 31 "Institution left item blank", add 
label define label_xh021 32 "Do not know", add 
label define label_xh021 40 "Suppressed to protect confidentiality", add 
label values xh021 label_xh021
label define label_xh022 10 "Reported" 
label define label_xh022 11 "Analyst corrected reported value", add 
label define label_xh022 12 "Data generated from other data values", add 
label define label_xh022 13 "Implied zero", add 
label define label_xh022 20 "Imputed using Carry Forward procedure", add 
label define label_xh022 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xh022 30 "Not applicable", add 
label define label_xh022 31 "Institution left item blank", add 
label define label_xh022 32 "Do not know", add 
label define label_xh022 40 "Suppressed to protect confidentiality", add 
label values xh022 label_xh022
label define label_xk014 10 "Reported" 
label define label_xk014 11 "Analyst corrected reported value", add 
label define label_xk014 12 "Data generated from other data values", add 
label define label_xk014 13 "Implied zero", add 
label define label_xk014 20 "Imputed using Carry Forward procedure", add 
label define label_xk014 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xk014 30 "Not applicable", add 
label define label_xk014 31 "Institution left item blank", add 
label define label_xk014 32 "Do not know", add 
label define label_xk014 40 "Suppressed to protect confidentiality", add 
label values xk014 label_xk014
label define label_xk025 10 "Reported" 
label define label_xk025 11 "Analyst corrected reported value", add 
label define label_xk025 12 "Data generated from other data values", add 
label define label_xk025 13 "Implied zero", add 
label define label_xk025 20 "Imputed using Carry Forward procedure", add 
label define label_xk025 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xk025 30 "Not applicable", add 
label define label_xk025 31 "Institution left item blank", add 
label define label_xk025 32 "Do not know", add 
label define label_xk025 40 "Suppressed to protect confidentiality", add 
label values xk025 label_xk025
label define label_xk035 10 "Reported" 
label define label_xk035 11 "Analyst corrected reported value", add 
label define label_xk035 12 "Data generated from other data values", add 
label define label_xk035 13 "Implied zero", add 
label define label_xk035 20 "Imputed using Carry Forward procedure", add 
label define label_xk035 21 "Imputed using Group Median or Nearest Neighbor procedure", add 
label define label_xk035 30 "Not applicable", add 
label define label_xk035 31 "Institution left item blank", add 
label define label_xk035 32 "Do not know", add 
label define label_xk035 40 "Suppressed to protect confidentiality", add 
label values xk035 label_xk035
tab xa013
tab xa023
tab xa043
tab xa053
tab xa063
tab xa073
tab xa083
tab xa093
tab xa103
tab xa113
tab xa123
tab xa133
tab xa143
tab xa153
tab xa163
tab xj013
tab xj023
tab xj033
tab xj043
tab xj053
tab xj063
tab xj073
tab xj083
tab xb013
tab xb023
tab xb033
tab xb043
tab xb063
tab xb073
tab xb083
tab xb093
tab xb103
tab xb113
tab xb123
tab xb133
tab xbline15
tab xb163
tab xbline18
tab xb193
tab xbline21
tab xbother
tab xb223
tab xb234
tab xb244
tab xb254
tab xb274
tab xe013
tab xe023
tab xe033
tab xe043
tab xe053
tab xe063
tab xe073
tab xg01
tab xg02
tab xg03
tab xg04
tab xg05
tab fha
tab xh011
tab xh012
tab xh021
tab xh022
tab xk014
tab xk025
tab xk035
summarize a013
summarize a023
summarize a043
summarize a053
summarize a063
summarize a073
summarize a083
summarize a093
summarize a103
summarize a113
summarize a123
summarize a133
summarize a143
summarize a153
summarize a163
summarize j013
summarize j023
summarize j033
summarize j043
summarize j053
summarize j063
summarize j073
summarize j083
summarize b013
summarize b023
summarize b033
summarize b043
summarize b063
summarize b073
summarize b083
summarize b093
summarize b103
summarize b113
summarize b123
summarize b133
summarize bline15
summarize b163
summarize bline18
summarize b193
summarize bline21
summarize bother
summarize b223
summarize b234
summarize b244
summarize b254
summarize b274
summarize e013
summarize e023
summarize e033
summarize e043
summarize e053
summarize e063
summarize e073
summarize g01
summarize g02
summarize g03
summarize g04
summarize g05
summarize h011
summarize h012
summarize h021
summarize h022
summarize k014
summarize k025
summarize k035
save dct_f9900_f1

