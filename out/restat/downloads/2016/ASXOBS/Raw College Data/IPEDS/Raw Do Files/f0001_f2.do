* Created: 6/12/2004 10:11:37 PM
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
insheet using "../Raw Data/f0001_f2_data_stata.csv", comma clear
label data "dct_f0001_f2"
label variable unitid "unitid"
label variable xf2a01 "Imputation field for F2A01 - Long-term investments"
label variable f2a01 "Long-term investments"
label variable xf2a02 "Imputation field for F2A02 - Total assets"
label variable f2a02 "Total assets"
label variable xf2a03 "Imputation field for F2A03 - Total liabilities"
label variable f2a03 "Total liabilities"
label variable xf2a04 "Imputation field for F2A04 - Total unrestricted net assets"
label variable f2a04 "Total unrestricted net assets"
label variable xf2a05 "Imputation field for F2A05 - Total restricted net assets"
label variable f2a05 "Total restricted net assets"
label variable xf2a06 "Imputation field for F2A06 - Total net assets"
label variable f2a06 "Total net assets"
label variable xf2a11 "Imputation field for F2A11 - Land and land improvements-end of year"
label variable f2a11 "Land and land improvements-end of year"
label variable xf2a12 "Imputation field for F2A12 - Buildings-end of year"
label variable f2a12 "Buildings-end of year"
label variable xf2a13 "Imputation field for F2A13 - Equipment, including art and library collections-end of year"
label variable f2a13 "Equipment, including art and library collections-end of year"
label variable xf2a14 "Imputation field for F2A14 - Property obtained under capital leases-end of year"
label variable f2a14 "Property obtained under capital leases-end of year"
label variable xf2b01 "Imputation field for F2B01 - Total revenues and investment return (from Part A, line A17, column 1)"
label variable f2b01 "Total revenues and investment return (from Part A, line A17, column 1)"
label variable xf2b02 "Imputation field for F2B02 - Total expenses (from Part B, line B12, column 1)"
label variable f2b02 "Total expenses (from Part B, line B12, column 1)"
label variable xf2b03 "Imputation field for F2B03 - Other specific changes in net assets"
label variable f2b03 "Other specific changes in net assets"
label variable xf2b04 "Imputation field for F2B04 - Change in net assets"
label variable f2b04 "Change in net assets"
label variable xf2b05 "Imputation field for F2B05 - Net assets, beginning of the year"
label variable f2b05 "Net assets, beginning of the year"
label variable xf2b06 "Imputation field for F2B06 - Adjustments to beginning net assets"
label variable f2b06 "Adjustments to beginning net assets"
label variable xf2b07 "Imputation field for F2B07 - Net assets, end of the year"
label variable f2b07 "Net assets, end of the year"
label variable xf2c01 "Imputation field for F2C01 - Total Pell grants"
label variable f2c01 "Total Pell grants"
label variable xf2c02 "Imputation field for F2C02 - Total other federal grants"
label variable f2c02 "Total other federal grants"
label variable xf2c03 "Imputation field for F2C03 - Total state grants"
label variable f2c03 "Total state grants"
label variable xf2c04 "Imputation field for F2C04 - Total local grants"
label variable f2c04 "Total local grants"
label variable xf2c05 "Imputation field for F2C05 - Total institutional grants (funded)"
label variable f2c05 "Total institutional grants (funded)"
label variable xf2c06 "Imputation field for F2C06 - Total institutional grants (unfunded)"
label variable f2c06 "Total institutional grants (unfunded)"
label variable xf2c07 "Imputation field for F2C07 - Total student aid"
label variable f2c07 "Total student aid"
label variable xf2c08 "Imputation field for F2C08 - Total-allowance applied to tuition and fees"
label variable f2c08 "Total-allowance applied to tuition and fees"
label variable xf2c09 "Imputation field for F2C09 - Total-allowance applied to auxiliary enterprise revenues"
label variable f2c09 "Total-allowance applied to auxiliary enterprise revenues"
label variable xf2d01 "Imputation field for F2D01 - Total tuition and fees"
label variable f2d01 "Total tuition and fees"
label variable xf2d02 "Imputation field for F2D02 - Total federal appropriations"
label variable f2d02 "Total federal appropriations"
label variable xf2d03 "Imputation field for F2D03 - Total state appropriations"
label variable f2d03 "Total state appropriations"
label variable xf2d04 "Imputation field for F2D04 - Total local appropriations"
label variable f2d04 "Total local appropriations"
label variable xf2d05 "Imputation field for F2D05 - Total federal grants and contracts"
label variable f2d05 "Total federal grants and contracts"
label variable xf2d06 "Imputation field for F2D06 - Total state grants and contracts"
label variable f2d06 "Total state grants and contracts"
label variable xf2d07 "Imputation field for F2D07 - Total local grants and contracts"
label variable f2d07 "Total local grants and contracts"
label variable xf2d08 "Imputation field for F2D08 - Total private gifts, grants, and contracts"
label variable f2d08 "Total private gifts, grants, and contracts"
label variable xf2d09 "Imputation field for F2D09 - Total contributions from affiliated entities"
label variable f2d09 "Total contributions from affiliated entities"
label variable xf2d10 "Imputation field for F2D10 - Total investment return (income, gains, and losses)"
label variable f2d10 "Total investment return (income, gains, and losses)"
label variable xf2d11 "Imputation field for F2D11 - Total sales and services of educational activities"
label variable f2d11 "Total sales and services of educational activities"
label variable xf2d12 "Imputation field for F2D12 - Total sales and services of auxiliary enterprises"
label variable f2d12 "Total sales and services of auxiliary enterprises"
label variable xf2d13 "Imputation field for F2D13 - Total hospital revenue"
label variable f2d13 "Total hospital revenue"
label variable xf2d14 "Imputation field for F2D14 - Total independent operations revenue"
label variable f2d14 "Total independent operations revenue"
label variable xf2d15 "Imputation field for F2D15 - Total other revenue"
label variable f2d15 "Total other revenue"
label variable xf2d16 "Imputation field for F2D16 - Total revenues and investment return"
label variable f2d16 "Total revenues and investment return"
label variable xf2e011 "Imputation field for F2E011 - Instruction-total"
label variable f2e011 "Instruction-total"
label variable xf2e012 "Imputation field for F2E012 - Instruction-salaries and wages"
label variable f2e012 "Instruction-salaries and wages"
label variable xf2e021 "Imputation field for F2E021 - Research-total"
label variable f2e021 "Research-total"
label variable xf2e022 "Imputation field for F2E022 - Research-salaries and wages"
label variable f2e022 "Research-salaries and wages"
label variable xf2e031 "Imputation field for F2E031 - Public service-total"
label variable f2e031 "Public service-total"
label variable xf2e032 "Imputation field for F2E032 - Public service-salaries and wages"
label variable f2e032 "Public service-salaries and wages"
label variable xf2e041 "Imputation field for F2E041 - Academic support-total"
label variable f2e041 "Academic support-total"
label variable xf2e042 "Imputation field for F2E042 - Academic support-salaries and wages"
label variable f2e042 "Academic support-salaries and wages"
label variable xf2e051 "Imputation field for F2E051 - Student services-total"
label variable f2e051 "Student services-total"
label variable xf2e052 "Imputation field for F2E052 - Student services-salaries and wages"
label variable f2e052 "Student services-salaries and wages"
label variable xf2e061 "Imputation field for F2E061 - Institutional support-total"
label variable f2e061 "Institutional support-total"
label variable xf2e062 "Imputation field for F2E062 - Institutional support-salaries and wages"
label variable f2e062 "Institutional support-salaries and wages"
label variable xf2e071 "Imputation field for F2E071 - Auxiliary enterprises-total"
label variable f2e071 "Auxiliary enterprises-total"
label variable xf2e072 "Imputation field for F2E072 - Auxiliary enterprises-salaries and wages"
label variable f2e072 "Auxiliary enterprises-salaries and wages"
label variable xf2e081 "Imputation field for F2E081 - Net grant aid to students-total"
label variable f2e081 "Net grant aid to students-total"
label variable xf2e082 "Imputation field for F2E082 - Net grant aid to students-salaries and wages"
label variable f2e082 "Net grant aid to students-salaries and wages"
label variable xf2e091 "Imputation field for F2E091 - Hospital services-total"
label variable f2e091 "Hospital services-total"
label variable xf2e092 "Imputation field for F2E092 - Hospital services-salaries and wages"
label variable f2e092 "Hospital services-salaries and wages"
label variable xf2e101 "Imputation field for F2E101 - Independent operations-total"
label variable f2e101 "Independent operations-total"
label variable xf2e102 "Imputation field for F2E102 - Independent operations-salaries and wages"
label variable f2e102 "Independent operations-salaries and wages"
label variable xf2e111 "Imputation field for F2E111 - Other expenditures-total"
label variable f2e111 "Other expenditures-total"
label variable xf2e112 "Imputation field for F2E112 - Other expenditures-salaries and wages"
label variable f2e112 "Other expenditures-salaries and wages"
label variable xf2e121 "Imputation field for F2E121 - Total expenses-total"
label variable f2e121 "Total expenses-total"
label variable xf2e122 "Imputation field for F2E122 - Total expenses-salaries and wages"
label variable f2e122 "Total expenses-salaries and wages"
label variable xf2e141 "Imputation field for F2E141 - Total expenses-benefits"
label variable f2e141 "Total expenses-benefits"
label variable xf2e151 "Imputation field for F2E151 - Total expenses-depreciation"
label variable f2e151 "Total expenses-depreciation"
label variable xf2e161 "Imputation field for F2E161 - Total expenses-interest"
label variable f2e161 "Total expenses-interest"
label variable xf2e171 "Imputation field for F2E171 - Total expenses-all other"
label variable f2e171 "Total expenses-all other"
label define label_xf2a01 10 "Reported" 
label define label_xf2a01 11 "Analyst corrected reported value", add 
label define label_xf2a01 12 "Data generated from other data values", add 
label define label_xf2a01 13 "Implied zero", add 
label define label_xf2a01 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a01 22 "Imputed using the Group Median procedure", add 
label define label_xf2a01 23 "Partial imputation", add 
label define label_xf2a01 30 "Not applicable", add 
label define label_xf2a01 31 "Institution left item blank", add 
label define label_xf2a01 32 "Do not know", add 
label define label_xf2a01 33 "Particular 1st prof field not applicable", add 
label define label_xf2a01 40 "Suppressed to protect confidentiality", add 
label values xf2a01 label_xf2a01
label define label_xf2a02 10 "Reported" 
label define label_xf2a02 11 "Analyst corrected reported value", add 
label define label_xf2a02 12 "Data generated from other data values", add 
label define label_xf2a02 13 "Implied zero", add 
label define label_xf2a02 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a02 22 "Imputed using the Group Median procedure", add 
label define label_xf2a02 23 "Partial imputation", add 
label define label_xf2a02 30 "Not applicable", add 
label define label_xf2a02 31 "Institution left item blank", add 
label define label_xf2a02 32 "Do not know", add 
label define label_xf2a02 33 "Particular 1st prof field not applicable", add 
label define label_xf2a02 40 "Suppressed to protect confidentiality", add 
label values xf2a02 label_xf2a02
label define label_xf2a03 10 "Reported" 
label define label_xf2a03 11 "Analyst corrected reported value", add 
label define label_xf2a03 12 "Data generated from other data values", add 
label define label_xf2a03 13 "Implied zero", add 
label define label_xf2a03 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a03 22 "Imputed using the Group Median procedure", add 
label define label_xf2a03 23 "Partial imputation", add 
label define label_xf2a03 30 "Not applicable", add 
label define label_xf2a03 31 "Institution left item blank", add 
label define label_xf2a03 32 "Do not know", add 
label define label_xf2a03 33 "Particular 1st prof field not applicable", add 
label define label_xf2a03 40 "Suppressed to protect confidentiality", add 
label values xf2a03 label_xf2a03
label define label_xf2a04 10 "Reported" 
label define label_xf2a04 11 "Analyst corrected reported value", add 
label define label_xf2a04 12 "Data generated from other data values", add 
label define label_xf2a04 13 "Implied zero", add 
label define label_xf2a04 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a04 22 "Imputed using the Group Median procedure", add 
label define label_xf2a04 23 "Partial imputation", add 
label define label_xf2a04 30 "Not applicable", add 
label define label_xf2a04 31 "Institution left item blank", add 
label define label_xf2a04 32 "Do not know", add 
label define label_xf2a04 33 "Particular 1st prof field not applicable", add 
label define label_xf2a04 40 "Suppressed to protect confidentiality", add 
label values xf2a04 label_xf2a04
label define label_xf2a05 10 "Reported" 
label define label_xf2a05 11 "Analyst corrected reported value", add 
label define label_xf2a05 12 "Data generated from other data values", add 
label define label_xf2a05 13 "Implied zero", add 
label define label_xf2a05 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a05 22 "Imputed using the Group Median procedure", add 
label define label_xf2a05 23 "Partial imputation", add 
label define label_xf2a05 30 "Not applicable", add 
label define label_xf2a05 31 "Institution left item blank", add 
label define label_xf2a05 32 "Do not know", add 
label define label_xf2a05 33 "Particular 1st prof field not applicable", add 
label define label_xf2a05 40 "Suppressed to protect confidentiality", add 
label values xf2a05 label_xf2a05
label define label_xf2a06 10 "Reported" 
label define label_xf2a06 11 "Analyst corrected reported value", add 
label define label_xf2a06 12 "Data generated from other data values", add 
label define label_xf2a06 13 "Implied zero", add 
label define label_xf2a06 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a06 22 "Imputed using the Group Median procedure", add 
label define label_xf2a06 23 "Partial imputation", add 
label define label_xf2a06 30 "Not applicable", add 
label define label_xf2a06 31 "Institution left item blank", add 
label define label_xf2a06 32 "Do not know", add 
label define label_xf2a06 33 "Particular 1st prof field not applicable", add 
label define label_xf2a06 40 "Suppressed to protect confidentiality", add 
label values xf2a06 label_xf2a06
label define label_xf2a11 10 "Reported" 
label define label_xf2a11 11 "Analyst corrected reported value", add 
label define label_xf2a11 12 "Data generated from other data values", add 
label define label_xf2a11 13 "Implied zero", add 
label define label_xf2a11 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a11 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a11 22 "Imputed using the Group Median procedure", add 
label define label_xf2a11 23 "Partial imputation", add 
label define label_xf2a11 30 "Not applicable", add 
label define label_xf2a11 31 "Institution left item blank", add 
label define label_xf2a11 32 "Do not know", add 
label define label_xf2a11 33 "Particular 1st prof field not applicable", add 
label define label_xf2a11 40 "Suppressed to protect confidentiality", add 
label values xf2a11 label_xf2a11
label define label_xf2a12 10 "Reported" 
label define label_xf2a12 11 "Analyst corrected reported value", add 
label define label_xf2a12 12 "Data generated from other data values", add 
label define label_xf2a12 13 "Implied zero", add 
label define label_xf2a12 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a12 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a12 22 "Imputed using the Group Median procedure", add 
label define label_xf2a12 23 "Partial imputation", add 
label define label_xf2a12 30 "Not applicable", add 
label define label_xf2a12 31 "Institution left item blank", add 
label define label_xf2a12 32 "Do not know", add 
label define label_xf2a12 33 "Particular 1st prof field not applicable", add 
label define label_xf2a12 40 "Suppressed to protect confidentiality", add 
label values xf2a12 label_xf2a12
label define label_xf2a13 10 "Reported" 
label define label_xf2a13 11 "Analyst corrected reported value", add 
label define label_xf2a13 12 "Data generated from other data values", add 
label define label_xf2a13 13 "Implied zero", add 
label define label_xf2a13 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a13 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a13 22 "Imputed using the Group Median procedure", add 
label define label_xf2a13 23 "Partial imputation", add 
label define label_xf2a13 30 "Not applicable", add 
label define label_xf2a13 31 "Institution left item blank", add 
label define label_xf2a13 32 "Do not know", add 
label define label_xf2a13 33 "Particular 1st prof field not applicable", add 
label define label_xf2a13 40 "Suppressed to protect confidentiality", add 
label values xf2a13 label_xf2a13
label define label_xf2a14 10 "Reported" 
label define label_xf2a14 11 "Analyst corrected reported value", add 
label define label_xf2a14 12 "Data generated from other data values", add 
label define label_xf2a14 13 "Implied zero", add 
label define label_xf2a14 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a14 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a14 22 "Imputed using the Group Median procedure", add 
label define label_xf2a14 23 "Partial imputation", add 
label define label_xf2a14 30 "Not applicable", add 
label define label_xf2a14 31 "Institution left item blank", add 
label define label_xf2a14 32 "Do not know", add 
label define label_xf2a14 33 "Particular 1st prof field not applicable", add 
label define label_xf2a14 40 "Suppressed to protect confidentiality", add 
label values xf2a14 label_xf2a14
label define label_xf2b01 10 "Reported" 
label define label_xf2b01 11 "Analyst corrected reported value", add 
label define label_xf2b01 12 "Data generated from other data values", add 
label define label_xf2b01 13 "Implied zero", add 
label define label_xf2b01 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b01 22 "Imputed using the Group Median procedure", add 
label define label_xf2b01 23 "Partial imputation", add 
label define label_xf2b01 30 "Not applicable", add 
label define label_xf2b01 31 "Institution left item blank", add 
label define label_xf2b01 32 "Do not know", add 
label define label_xf2b01 33 "Particular 1st prof field not applicable", add 
label define label_xf2b01 40 "Suppressed to protect confidentiality", add 
label values xf2b01 label_xf2b01
label define label_xf2b02 10 "Reported" 
label define label_xf2b02 11 "Analyst corrected reported value", add 
label define label_xf2b02 12 "Data generated from other data values", add 
label define label_xf2b02 13 "Implied zero", add 
label define label_xf2b02 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b02 22 "Imputed using the Group Median procedure", add 
label define label_xf2b02 23 "Partial imputation", add 
label define label_xf2b02 30 "Not applicable", add 
label define label_xf2b02 31 "Institution left item blank", add 
label define label_xf2b02 32 "Do not know", add 
label define label_xf2b02 33 "Particular 1st prof field not applicable", add 
label define label_xf2b02 40 "Suppressed to protect confidentiality", add 
label values xf2b02 label_xf2b02
label define label_xf2b03 10 "Reported" 
label define label_xf2b03 11 "Analyst corrected reported value", add 
label define label_xf2b03 12 "Data generated from other data values", add 
label define label_xf2b03 13 "Implied zero", add 
label define label_xf2b03 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b03 22 "Imputed using the Group Median procedure", add 
label define label_xf2b03 23 "Partial imputation", add 
label define label_xf2b03 30 "Not applicable", add 
label define label_xf2b03 31 "Institution left item blank", add 
label define label_xf2b03 32 "Do not know", add 
label define label_xf2b03 33 "Particular 1st prof field not applicable", add 
label define label_xf2b03 40 "Suppressed to protect confidentiality", add 
label values xf2b03 label_xf2b03
label define label_xf2b04 10 "Reported" 
label define label_xf2b04 11 "Analyst corrected reported value", add 
label define label_xf2b04 12 "Data generated from other data values", add 
label define label_xf2b04 13 "Implied zero", add 
label define label_xf2b04 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b04 22 "Imputed using the Group Median procedure", add 
label define label_xf2b04 23 "Partial imputation", add 
label define label_xf2b04 30 "Not applicable", add 
label define label_xf2b04 31 "Institution left item blank", add 
label define label_xf2b04 32 "Do not know", add 
label define label_xf2b04 33 "Particular 1st prof field not applicable", add 
label define label_xf2b04 40 "Suppressed to protect confidentiality", add 
label values xf2b04 label_xf2b04
label define label_xf2b05 10 "Reported" 
label define label_xf2b05 11 "Analyst corrected reported value", add 
label define label_xf2b05 12 "Data generated from other data values", add 
label define label_xf2b05 13 "Implied zero", add 
label define label_xf2b05 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b05 22 "Imputed using the Group Median procedure", add 
label define label_xf2b05 23 "Partial imputation", add 
label define label_xf2b05 30 "Not applicable", add 
label define label_xf2b05 31 "Institution left item blank", add 
label define label_xf2b05 32 "Do not know", add 
label define label_xf2b05 33 "Particular 1st prof field not applicable", add 
label define label_xf2b05 40 "Suppressed to protect confidentiality", add 
label values xf2b05 label_xf2b05
label define label_xf2b06 10 "Reported" 
label define label_xf2b06 11 "Analyst corrected reported value", add 
label define label_xf2b06 12 "Data generated from other data values", add 
label define label_xf2b06 13 "Implied zero", add 
label define label_xf2b06 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b06 22 "Imputed using the Group Median procedure", add 
label define label_xf2b06 23 "Partial imputation", add 
label define label_xf2b06 30 "Not applicable", add 
label define label_xf2b06 31 "Institution left item blank", add 
label define label_xf2b06 32 "Do not know", add 
label define label_xf2b06 33 "Particular 1st prof field not applicable", add 
label define label_xf2b06 40 "Suppressed to protect confidentiality", add 
label values xf2b06 label_xf2b06
label define label_xf2b07 10 "Reported" 
label define label_xf2b07 11 "Analyst corrected reported value", add 
label define label_xf2b07 12 "Data generated from other data values", add 
label define label_xf2b07 13 "Implied zero", add 
label define label_xf2b07 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b07 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b07 22 "Imputed using the Group Median procedure", add 
label define label_xf2b07 23 "Partial imputation", add 
label define label_xf2b07 30 "Not applicable", add 
label define label_xf2b07 31 "Institution left item blank", add 
label define label_xf2b07 32 "Do not know", add 
label define label_xf2b07 33 "Particular 1st prof field not applicable", add 
label define label_xf2b07 40 "Suppressed to protect confidentiality", add 
label values xf2b07 label_xf2b07
label define label_xf2c01 10 "Reported" 
label define label_xf2c01 11 "Analyst corrected reported value", add 
label define label_xf2c01 12 "Data generated from other data values", add 
label define label_xf2c01 13 "Implied zero", add 
label define label_xf2c01 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c01 22 "Imputed using the Group Median procedure", add 
label define label_xf2c01 23 "Partial imputation", add 
label define label_xf2c01 30 "Not applicable", add 
label define label_xf2c01 31 "Institution left item blank", add 
label define label_xf2c01 32 "Do not know", add 
label define label_xf2c01 33 "Particular 1st prof field not applicable", add 
label define label_xf2c01 40 "Suppressed to protect confidentiality", add 
label values xf2c01 label_xf2c01
label define label_xf2c02 10 "Reported" 
label define label_xf2c02 11 "Analyst corrected reported value", add 
label define label_xf2c02 12 "Data generated from other data values", add 
label define label_xf2c02 13 "Implied zero", add 
label define label_xf2c02 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c02 22 "Imputed using the Group Median procedure", add 
label define label_xf2c02 23 "Partial imputation", add 
label define label_xf2c02 30 "Not applicable", add 
label define label_xf2c02 31 "Institution left item blank", add 
label define label_xf2c02 32 "Do not know", add 
label define label_xf2c02 33 "Particular 1st prof field not applicable", add 
label define label_xf2c02 40 "Suppressed to protect confidentiality", add 
label values xf2c02 label_xf2c02
label define label_xf2c03 10 "Reported" 
label define label_xf2c03 11 "Analyst corrected reported value", add 
label define label_xf2c03 12 "Data generated from other data values", add 
label define label_xf2c03 13 "Implied zero", add 
label define label_xf2c03 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c03 22 "Imputed using the Group Median procedure", add 
label define label_xf2c03 23 "Partial imputation", add 
label define label_xf2c03 30 "Not applicable", add 
label define label_xf2c03 31 "Institution left item blank", add 
label define label_xf2c03 32 "Do not know", add 
label define label_xf2c03 33 "Particular 1st prof field not applicable", add 
label define label_xf2c03 40 "Suppressed to protect confidentiality", add 
label values xf2c03 label_xf2c03
label define label_xf2c04 10 "Reported" 
label define label_xf2c04 11 "Analyst corrected reported value", add 
label define label_xf2c04 12 "Data generated from other data values", add 
label define label_xf2c04 13 "Implied zero", add 
label define label_xf2c04 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c04 22 "Imputed using the Group Median procedure", add 
label define label_xf2c04 23 "Partial imputation", add 
label define label_xf2c04 30 "Not applicable", add 
label define label_xf2c04 31 "Institution left item blank", add 
label define label_xf2c04 32 "Do not know", add 
label define label_xf2c04 33 "Particular 1st prof field not applicable", add 
label define label_xf2c04 40 "Suppressed to protect confidentiality", add 
label values xf2c04 label_xf2c04
label define label_xf2c05 10 "Reported" 
label define label_xf2c05 11 "Analyst corrected reported value", add 
label define label_xf2c05 12 "Data generated from other data values", add 
label define label_xf2c05 13 "Implied zero", add 
label define label_xf2c05 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c05 22 "Imputed using the Group Median procedure", add 
label define label_xf2c05 23 "Partial imputation", add 
label define label_xf2c05 30 "Not applicable", add 
label define label_xf2c05 31 "Institution left item blank", add 
label define label_xf2c05 32 "Do not know", add 
label define label_xf2c05 33 "Particular 1st prof field not applicable", add 
label define label_xf2c05 40 "Suppressed to protect confidentiality", add 
label values xf2c05 label_xf2c05
label define label_xf2c06 10 "Reported" 
label define label_xf2c06 11 "Analyst corrected reported value", add 
label define label_xf2c06 12 "Data generated from other data values", add 
label define label_xf2c06 13 "Implied zero", add 
label define label_xf2c06 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c06 22 "Imputed using the Group Median procedure", add 
label define label_xf2c06 23 "Partial imputation", add 
label define label_xf2c06 30 "Not applicable", add 
label define label_xf2c06 31 "Institution left item blank", add 
label define label_xf2c06 32 "Do not know", add 
label define label_xf2c06 33 "Particular 1st prof field not applicable", add 
label define label_xf2c06 40 "Suppressed to protect confidentiality", add 
label values xf2c06 label_xf2c06
label define label_xf2c07 10 "Reported" 
label define label_xf2c07 11 "Analyst corrected reported value", add 
label define label_xf2c07 12 "Data generated from other data values", add 
label define label_xf2c07 13 "Implied zero", add 
label define label_xf2c07 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c07 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c07 22 "Imputed using the Group Median procedure", add 
label define label_xf2c07 23 "Partial imputation", add 
label define label_xf2c07 30 "Not applicable", add 
label define label_xf2c07 31 "Institution left item blank", add 
label define label_xf2c07 32 "Do not know", add 
label define label_xf2c07 33 "Particular 1st prof field not applicable", add 
label define label_xf2c07 40 "Suppressed to protect confidentiality", add 
label values xf2c07 label_xf2c07
label define label_xf2c08 10 "Reported" 
label define label_xf2c08 11 "Analyst corrected reported value", add 
label define label_xf2c08 12 "Data generated from other data values", add 
label define label_xf2c08 13 "Implied zero", add 
label define label_xf2c08 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c08 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c08 22 "Imputed using the Group Median procedure", add 
label define label_xf2c08 23 "Partial imputation", add 
label define label_xf2c08 30 "Not applicable", add 
label define label_xf2c08 31 "Institution left item blank", add 
label define label_xf2c08 32 "Do not know", add 
label define label_xf2c08 33 "Particular 1st prof field not applicable", add 
label define label_xf2c08 40 "Suppressed to protect confidentiality", add 
label values xf2c08 label_xf2c08
label define label_xf2c09 10 "Reported" 
label define label_xf2c09 11 "Analyst corrected reported value", add 
label define label_xf2c09 12 "Data generated from other data values", add 
label define label_xf2c09 13 "Implied zero", add 
label define label_xf2c09 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c09 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c09 22 "Imputed using the Group Median procedure", add 
label define label_xf2c09 23 "Partial imputation", add 
label define label_xf2c09 30 "Not applicable", add 
label define label_xf2c09 31 "Institution left item blank", add 
label define label_xf2c09 32 "Do not know", add 
label define label_xf2c09 33 "Particular 1st prof field not applicable", add 
label define label_xf2c09 40 "Suppressed to protect confidentiality", add 
label values xf2c09 label_xf2c09
label define label_xf2d01 10 "Reported" 
label define label_xf2d01 11 "Analyst corrected reported value", add 
label define label_xf2d01 12 "Data generated from other data values", add 
label define label_xf2d01 13 "Implied zero", add 
label define label_xf2d01 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d01 22 "Imputed using the Group Median procedure", add 
label define label_xf2d01 23 "Partial imputation", add 
label define label_xf2d01 30 "Not applicable", add 
label define label_xf2d01 31 "Institution left item blank", add 
label define label_xf2d01 32 "Do not know", add 
label define label_xf2d01 33 "Particular 1st prof field not applicable", add 
label define label_xf2d01 40 "Suppressed to protect confidentiality", add 
label values xf2d01 label_xf2d01
label define label_xf2d02 10 "Reported" 
label define label_xf2d02 11 "Analyst corrected reported value", add 
label define label_xf2d02 12 "Data generated from other data values", add 
label define label_xf2d02 13 "Implied zero", add 
label define label_xf2d02 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d02 22 "Imputed using the Group Median procedure", add 
label define label_xf2d02 23 "Partial imputation", add 
label define label_xf2d02 30 "Not applicable", add 
label define label_xf2d02 31 "Institution left item blank", add 
label define label_xf2d02 32 "Do not know", add 
label define label_xf2d02 33 "Particular 1st prof field not applicable", add 
label define label_xf2d02 40 "Suppressed to protect confidentiality", add 
label values xf2d02 label_xf2d02
label define label_xf2d03 10 "Reported" 
label define label_xf2d03 11 "Analyst corrected reported value", add 
label define label_xf2d03 12 "Data generated from other data values", add 
label define label_xf2d03 13 "Implied zero", add 
label define label_xf2d03 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d03 22 "Imputed using the Group Median procedure", add 
label define label_xf2d03 23 "Partial imputation", add 
label define label_xf2d03 30 "Not applicable", add 
label define label_xf2d03 31 "Institution left item blank", add 
label define label_xf2d03 32 "Do not know", add 
label define label_xf2d03 33 "Particular 1st prof field not applicable", add 
label define label_xf2d03 40 "Suppressed to protect confidentiality", add 
label values xf2d03 label_xf2d03
label define label_xf2d04 10 "Reported" 
label define label_xf2d04 11 "Analyst corrected reported value", add 
label define label_xf2d04 12 "Data generated from other data values", add 
label define label_xf2d04 13 "Implied zero", add 
label define label_xf2d04 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d04 22 "Imputed using the Group Median procedure", add 
label define label_xf2d04 23 "Partial imputation", add 
label define label_xf2d04 30 "Not applicable", add 
label define label_xf2d04 31 "Institution left item blank", add 
label define label_xf2d04 32 "Do not know", add 
label define label_xf2d04 33 "Particular 1st prof field not applicable", add 
label define label_xf2d04 40 "Suppressed to protect confidentiality", add 
label values xf2d04 label_xf2d04
label define label_xf2d05 10 "Reported" 
label define label_xf2d05 11 "Analyst corrected reported value", add 
label define label_xf2d05 12 "Data generated from other data values", add 
label define label_xf2d05 13 "Implied zero", add 
label define label_xf2d05 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d05 22 "Imputed using the Group Median procedure", add 
label define label_xf2d05 23 "Partial imputation", add 
label define label_xf2d05 30 "Not applicable", add 
label define label_xf2d05 31 "Institution left item blank", add 
label define label_xf2d05 32 "Do not know", add 
label define label_xf2d05 33 "Particular 1st prof field not applicable", add 
label define label_xf2d05 40 "Suppressed to protect confidentiality", add 
label values xf2d05 label_xf2d05
label define label_xf2d06 10 "Reported" 
label define label_xf2d06 11 "Analyst corrected reported value", add 
label define label_xf2d06 12 "Data generated from other data values", add 
label define label_xf2d06 13 "Implied zero", add 
label define label_xf2d06 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d06 22 "Imputed using the Group Median procedure", add 
label define label_xf2d06 23 "Partial imputation", add 
label define label_xf2d06 30 "Not applicable", add 
label define label_xf2d06 31 "Institution left item blank", add 
label define label_xf2d06 32 "Do not know", add 
label define label_xf2d06 33 "Particular 1st prof field not applicable", add 
label define label_xf2d06 40 "Suppressed to protect confidentiality", add 
label values xf2d06 label_xf2d06
label define label_xf2d07 10 "Reported" 
label define label_xf2d07 11 "Analyst corrected reported value", add 
label define label_xf2d07 12 "Data generated from other data values", add 
label define label_xf2d07 13 "Implied zero", add 
label define label_xf2d07 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d07 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d07 22 "Imputed using the Group Median procedure", add 
label define label_xf2d07 23 "Partial imputation", add 
label define label_xf2d07 30 "Not applicable", add 
label define label_xf2d07 31 "Institution left item blank", add 
label define label_xf2d07 32 "Do not know", add 
label define label_xf2d07 33 "Particular 1st prof field not applicable", add 
label define label_xf2d07 40 "Suppressed to protect confidentiality", add 
label values xf2d07 label_xf2d07
label define label_xf2d08 10 "Reported" 
label define label_xf2d08 11 "Analyst corrected reported value", add 
label define label_xf2d08 12 "Data generated from other data values", add 
label define label_xf2d08 13 "Implied zero", add 
label define label_xf2d08 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d08 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d08 22 "Imputed using the Group Median procedure", add 
label define label_xf2d08 23 "Partial imputation", add 
label define label_xf2d08 30 "Not applicable", add 
label define label_xf2d08 31 "Institution left item blank", add 
label define label_xf2d08 32 "Do not know", add 
label define label_xf2d08 33 "Particular 1st prof field not applicable", add 
label define label_xf2d08 40 "Suppressed to protect confidentiality", add 
label values xf2d08 label_xf2d08
label define label_xf2d09 10 "Reported" 
label define label_xf2d09 11 "Analyst corrected reported value", add 
label define label_xf2d09 12 "Data generated from other data values", add 
label define label_xf2d09 13 "Implied zero", add 
label define label_xf2d09 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d09 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d09 22 "Imputed using the Group Median procedure", add 
label define label_xf2d09 23 "Partial imputation", add 
label define label_xf2d09 30 "Not applicable", add 
label define label_xf2d09 31 "Institution left item blank", add 
label define label_xf2d09 32 "Do not know", add 
label define label_xf2d09 33 "Particular 1st prof field not applicable", add 
label define label_xf2d09 40 "Suppressed to protect confidentiality", add 
label values xf2d09 label_xf2d09
label define label_xf2d10 10 "Reported" 
label define label_xf2d10 11 "Analyst corrected reported value", add 
label define label_xf2d10 12 "Data generated from other data values", add 
label define label_xf2d10 13 "Implied zero", add 
label define label_xf2d10 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d10 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d10 22 "Imputed using the Group Median procedure", add 
label define label_xf2d10 23 "Partial imputation", add 
label define label_xf2d10 30 "Not applicable", add 
label define label_xf2d10 31 "Institution left item blank", add 
label define label_xf2d10 32 "Do not know", add 
label define label_xf2d10 33 "Particular 1st prof field not applicable", add 
label define label_xf2d10 40 "Suppressed to protect confidentiality", add 
label values xf2d10 label_xf2d10
label define label_xf2d11 10 "Reported" 
label define label_xf2d11 11 "Analyst corrected reported value", add 
label define label_xf2d11 12 "Data generated from other data values", add 
label define label_xf2d11 13 "Implied zero", add 
label define label_xf2d11 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d11 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d11 22 "Imputed using the Group Median procedure", add 
label define label_xf2d11 23 "Partial imputation", add 
label define label_xf2d11 30 "Not applicable", add 
label define label_xf2d11 31 "Institution left item blank", add 
label define label_xf2d11 32 "Do not know", add 
label define label_xf2d11 33 "Particular 1st prof field not applicable", add 
label define label_xf2d11 40 "Suppressed to protect confidentiality", add 
label values xf2d11 label_xf2d11
label define label_xf2d12 10 "Reported" 
label define label_xf2d12 11 "Analyst corrected reported value", add 
label define label_xf2d12 12 "Data generated from other data values", add 
label define label_xf2d12 13 "Implied zero", add 
label define label_xf2d12 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d12 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d12 22 "Imputed using the Group Median procedure", add 
label define label_xf2d12 23 "Partial imputation", add 
label define label_xf2d12 30 "Not applicable", add 
label define label_xf2d12 31 "Institution left item blank", add 
label define label_xf2d12 32 "Do not know", add 
label define label_xf2d12 33 "Particular 1st prof field not applicable", add 
label define label_xf2d12 40 "Suppressed to protect confidentiality", add 
label values xf2d12 label_xf2d12
label define label_xf2d13 10 "Reported" 
label define label_xf2d13 11 "Analyst corrected reported value", add 
label define label_xf2d13 12 "Data generated from other data values", add 
label define label_xf2d13 13 "Implied zero", add 
label define label_xf2d13 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d13 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d13 22 "Imputed using the Group Median procedure", add 
label define label_xf2d13 23 "Partial imputation", add 
label define label_xf2d13 30 "Not applicable", add 
label define label_xf2d13 31 "Institution left item blank", add 
label define label_xf2d13 32 "Do not know", add 
label define label_xf2d13 33 "Particular 1st prof field not applicable", add 
label define label_xf2d13 40 "Suppressed to protect confidentiality", add 
label values xf2d13 label_xf2d13
label define label_xf2d14 10 "Reported" 
label define label_xf2d14 11 "Analyst corrected reported value", add 
label define label_xf2d14 12 "Data generated from other data values", add 
label define label_xf2d14 13 "Implied zero", add 
label define label_xf2d14 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d14 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d14 22 "Imputed using the Group Median procedure", add 
label define label_xf2d14 23 "Partial imputation", add 
label define label_xf2d14 30 "Not applicable", add 
label define label_xf2d14 31 "Institution left item blank", add 
label define label_xf2d14 32 "Do not know", add 
label define label_xf2d14 33 "Particular 1st prof field not applicable", add 
label define label_xf2d14 40 "Suppressed to protect confidentiality", add 
label values xf2d14 label_xf2d14
label define label_xf2d15 10 "Reported" 
label define label_xf2d15 11 "Analyst corrected reported value", add 
label define label_xf2d15 12 "Data generated from other data values", add 
label define label_xf2d15 13 "Implied zero", add 
label define label_xf2d15 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d15 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d15 22 "Imputed using the Group Median procedure", add 
label define label_xf2d15 23 "Partial imputation", add 
label define label_xf2d15 30 "Not applicable", add 
label define label_xf2d15 31 "Institution left item blank", add 
label define label_xf2d15 32 "Do not know", add 
label define label_xf2d15 33 "Particular 1st prof field not applicable", add 
label define label_xf2d15 40 "Suppressed to protect confidentiality", add 
label values xf2d15 label_xf2d15
label define label_xf2d16 10 "Reported" 
label define label_xf2d16 11 "Analyst corrected reported value", add 
label define label_xf2d16 12 "Data generated from other data values", add 
label define label_xf2d16 13 "Implied zero", add 
label define label_xf2d16 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d16 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d16 22 "Imputed using the Group Median procedure", add 
label define label_xf2d16 23 "Partial imputation", add 
label define label_xf2d16 30 "Not applicable", add 
label define label_xf2d16 31 "Institution left item blank", add 
label define label_xf2d16 32 "Do not know", add 
label define label_xf2d16 33 "Particular 1st prof field not applicable", add 
label define label_xf2d16 40 "Suppressed to protect confidentiality", add 
label values xf2d16 label_xf2d16
label define label_xf2e011 10 "Reported" 
label define label_xf2e011 11 "Analyst corrected reported value", add 
label define label_xf2e011 12 "Data generated from other data values", add 
label define label_xf2e011 13 "Implied zero", add 
label define label_xf2e011 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e011 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e011 22 "Imputed using the Group Median procedure", add 
label define label_xf2e011 23 "Partial imputation", add 
label define label_xf2e011 30 "Not applicable", add 
label define label_xf2e011 31 "Institution left item blank", add 
label define label_xf2e011 32 "Do not know", add 
label define label_xf2e011 33 "Particular 1st prof field not applicable", add 
label define label_xf2e011 40 "Suppressed to protect confidentiality", add 
label values xf2e011 label_xf2e011
label define label_xf2e012 10 "Reported" 
label define label_xf2e012 11 "Analyst corrected reported value", add 
label define label_xf2e012 12 "Data generated from other data values", add 
label define label_xf2e012 13 "Implied zero", add 
label define label_xf2e012 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e012 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e012 22 "Imputed using the Group Median procedure", add 
label define label_xf2e012 23 "Partial imputation", add 
label define label_xf2e012 30 "Not applicable", add 
label define label_xf2e012 31 "Institution left item blank", add 
label define label_xf2e012 32 "Do not know", add 
label define label_xf2e012 33 "Particular 1st prof field not applicable", add 
label define label_xf2e012 40 "Suppressed to protect confidentiality", add 
label values xf2e012 label_xf2e012
label define label_xf2e021 10 "Reported" 
label define label_xf2e021 11 "Analyst corrected reported value", add 
label define label_xf2e021 12 "Data generated from other data values", add 
label define label_xf2e021 13 "Implied zero", add 
label define label_xf2e021 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e021 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e021 22 "Imputed using the Group Median procedure", add 
label define label_xf2e021 23 "Partial imputation", add 
label define label_xf2e021 30 "Not applicable", add 
label define label_xf2e021 31 "Institution left item blank", add 
label define label_xf2e021 32 "Do not know", add 
label define label_xf2e021 33 "Particular 1st prof field not applicable", add 
label define label_xf2e021 40 "Suppressed to protect confidentiality", add 
label values xf2e021 label_xf2e021
label define label_xf2e022 10 "Reported" 
label define label_xf2e022 11 "Analyst corrected reported value", add 
label define label_xf2e022 12 "Data generated from other data values", add 
label define label_xf2e022 13 "Implied zero", add 
label define label_xf2e022 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e022 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e022 22 "Imputed using the Group Median procedure", add 
label define label_xf2e022 23 "Partial imputation", add 
label define label_xf2e022 30 "Not applicable", add 
label define label_xf2e022 31 "Institution left item blank", add 
label define label_xf2e022 32 "Do not know", add 
label define label_xf2e022 33 "Particular 1st prof field not applicable", add 
label define label_xf2e022 40 "Suppressed to protect confidentiality", add 
label values xf2e022 label_xf2e022
label define label_xf2e031 10 "Reported" 
label define label_xf2e031 11 "Analyst corrected reported value", add 
label define label_xf2e031 12 "Data generated from other data values", add 
label define label_xf2e031 13 "Implied zero", add 
label define label_xf2e031 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e031 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e031 22 "Imputed using the Group Median procedure", add 
label define label_xf2e031 23 "Partial imputation", add 
label define label_xf2e031 30 "Not applicable", add 
label define label_xf2e031 31 "Institution left item blank", add 
label define label_xf2e031 32 "Do not know", add 
label define label_xf2e031 33 "Particular 1st prof field not applicable", add 
label define label_xf2e031 40 "Suppressed to protect confidentiality", add 
label values xf2e031 label_xf2e031
label define label_xf2e032 10 "Reported" 
label define label_xf2e032 11 "Analyst corrected reported value", add 
label define label_xf2e032 12 "Data generated from other data values", add 
label define label_xf2e032 13 "Implied zero", add 
label define label_xf2e032 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e032 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e032 22 "Imputed using the Group Median procedure", add 
label define label_xf2e032 23 "Partial imputation", add 
label define label_xf2e032 30 "Not applicable", add 
label define label_xf2e032 31 "Institution left item blank", add 
label define label_xf2e032 32 "Do not know", add 
label define label_xf2e032 33 "Particular 1st prof field not applicable", add 
label define label_xf2e032 40 "Suppressed to protect confidentiality", add 
label values xf2e032 label_xf2e032
label define label_xf2e041 10 "Reported" 
label define label_xf2e041 11 "Analyst corrected reported value", add 
label define label_xf2e041 12 "Data generated from other data values", add 
label define label_xf2e041 13 "Implied zero", add 
label define label_xf2e041 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e041 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e041 22 "Imputed using the Group Median procedure", add 
label define label_xf2e041 23 "Partial imputation", add 
label define label_xf2e041 30 "Not applicable", add 
label define label_xf2e041 31 "Institution left item blank", add 
label define label_xf2e041 32 "Do not know", add 
label define label_xf2e041 33 "Particular 1st prof field not applicable", add 
label define label_xf2e041 40 "Suppressed to protect confidentiality", add 
label values xf2e041 label_xf2e041
label define label_xf2e042 10 "Reported" 
label define label_xf2e042 11 "Analyst corrected reported value", add 
label define label_xf2e042 12 "Data generated from other data values", add 
label define label_xf2e042 13 "Implied zero", add 
label define label_xf2e042 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e042 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e042 22 "Imputed using the Group Median procedure", add 
label define label_xf2e042 23 "Partial imputation", add 
label define label_xf2e042 30 "Not applicable", add 
label define label_xf2e042 31 "Institution left item blank", add 
label define label_xf2e042 32 "Do not know", add 
label define label_xf2e042 33 "Particular 1st prof field not applicable", add 
label define label_xf2e042 40 "Suppressed to protect confidentiality", add 
label values xf2e042 label_xf2e042
label define label_xf2e051 10 "Reported" 
label define label_xf2e051 11 "Analyst corrected reported value", add 
label define label_xf2e051 12 "Data generated from other data values", add 
label define label_xf2e051 13 "Implied zero", add 
label define label_xf2e051 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e051 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e051 22 "Imputed using the Group Median procedure", add 
label define label_xf2e051 23 "Partial imputation", add 
label define label_xf2e051 30 "Not applicable", add 
label define label_xf2e051 31 "Institution left item blank", add 
label define label_xf2e051 32 "Do not know", add 
label define label_xf2e051 33 "Particular 1st prof field not applicable", add 
label define label_xf2e051 40 "Suppressed to protect confidentiality", add 
label values xf2e051 label_xf2e051
label define label_xf2e052 10 "Reported" 
label define label_xf2e052 11 "Analyst corrected reported value", add 
label define label_xf2e052 12 "Data generated from other data values", add 
label define label_xf2e052 13 "Implied zero", add 
label define label_xf2e052 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e052 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e052 22 "Imputed using the Group Median procedure", add 
label define label_xf2e052 23 "Partial imputation", add 
label define label_xf2e052 30 "Not applicable", add 
label define label_xf2e052 31 "Institution left item blank", add 
label define label_xf2e052 32 "Do not know", add 
label define label_xf2e052 33 "Particular 1st prof field not applicable", add 
label define label_xf2e052 40 "Suppressed to protect confidentiality", add 
label values xf2e052 label_xf2e052
label define label_xf2e061 10 "Reported" 
label define label_xf2e061 11 "Analyst corrected reported value", add 
label define label_xf2e061 12 "Data generated from other data values", add 
label define label_xf2e061 13 "Implied zero", add 
label define label_xf2e061 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e061 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e061 22 "Imputed using the Group Median procedure", add 
label define label_xf2e061 23 "Partial imputation", add 
label define label_xf2e061 30 "Not applicable", add 
label define label_xf2e061 31 "Institution left item blank", add 
label define label_xf2e061 32 "Do not know", add 
label define label_xf2e061 33 "Particular 1st prof field not applicable", add 
label define label_xf2e061 40 "Suppressed to protect confidentiality", add 
label values xf2e061 label_xf2e061
label define label_xf2e062 10 "Reported" 
label define label_xf2e062 11 "Analyst corrected reported value", add 
label define label_xf2e062 12 "Data generated from other data values", add 
label define label_xf2e062 13 "Implied zero", add 
label define label_xf2e062 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e062 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e062 22 "Imputed using the Group Median procedure", add 
label define label_xf2e062 23 "Partial imputation", add 
label define label_xf2e062 30 "Not applicable", add 
label define label_xf2e062 31 "Institution left item blank", add 
label define label_xf2e062 32 "Do not know", add 
label define label_xf2e062 33 "Particular 1st prof field not applicable", add 
label define label_xf2e062 40 "Suppressed to protect confidentiality", add 
label values xf2e062 label_xf2e062
label define label_xf2e071 10 "Reported" 
label define label_xf2e071 11 "Analyst corrected reported value", add 
label define label_xf2e071 12 "Data generated from other data values", add 
label define label_xf2e071 13 "Implied zero", add 
label define label_xf2e071 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e071 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e071 22 "Imputed using the Group Median procedure", add 
label define label_xf2e071 23 "Partial imputation", add 
label define label_xf2e071 30 "Not applicable", add 
label define label_xf2e071 31 "Institution left item blank", add 
label define label_xf2e071 32 "Do not know", add 
label define label_xf2e071 33 "Particular 1st prof field not applicable", add 
label define label_xf2e071 40 "Suppressed to protect confidentiality", add 
label values xf2e071 label_xf2e071
label define label_xf2e072 10 "Reported" 
label define label_xf2e072 11 "Analyst corrected reported value", add 
label define label_xf2e072 12 "Data generated from other data values", add 
label define label_xf2e072 13 "Implied zero", add 
label define label_xf2e072 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e072 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e072 22 "Imputed using the Group Median procedure", add 
label define label_xf2e072 23 "Partial imputation", add 
label define label_xf2e072 30 "Not applicable", add 
label define label_xf2e072 31 "Institution left item blank", add 
label define label_xf2e072 32 "Do not know", add 
label define label_xf2e072 33 "Particular 1st prof field not applicable", add 
label define label_xf2e072 40 "Suppressed to protect confidentiality", add 
label values xf2e072 label_xf2e072
label define label_xf2e081 10 "Reported" 
label define label_xf2e081 11 "Analyst corrected reported value", add 
label define label_xf2e081 12 "Data generated from other data values", add 
label define label_xf2e081 13 "Implied zero", add 
label define label_xf2e081 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e081 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e081 22 "Imputed using the Group Median procedure", add 
label define label_xf2e081 23 "Partial imputation", add 
label define label_xf2e081 30 "Not applicable", add 
label define label_xf2e081 31 "Institution left item blank", add 
label define label_xf2e081 32 "Do not know", add 
label define label_xf2e081 33 "Particular 1st prof field not applicable", add 
label define label_xf2e081 40 "Suppressed to protect confidentiality", add 
label values xf2e081 label_xf2e081
label define label_xf2e082 10 "Reported" 
label define label_xf2e082 11 "Analyst corrected reported value", add 
label define label_xf2e082 12 "Data generated from other data values", add 
label define label_xf2e082 13 "Implied zero", add 
label define label_xf2e082 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e082 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e082 22 "Imputed using the Group Median procedure", add 
label define label_xf2e082 23 "Partial imputation", add 
label define label_xf2e082 30 "Not applicable", add 
label define label_xf2e082 31 "Institution left item blank", add 
label define label_xf2e082 32 "Do not know", add 
label define label_xf2e082 33 "Particular 1st prof field not applicable", add 
label define label_xf2e082 40 "Suppressed to protect confidentiality", add 
label values xf2e082 label_xf2e082
label define label_xf2e091 10 "Reported" 
label define label_xf2e091 11 "Analyst corrected reported value", add 
label define label_xf2e091 12 "Data generated from other data values", add 
label define label_xf2e091 13 "Implied zero", add 
label define label_xf2e091 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e091 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e091 22 "Imputed using the Group Median procedure", add 
label define label_xf2e091 23 "Partial imputation", add 
label define label_xf2e091 30 "Not applicable", add 
label define label_xf2e091 31 "Institution left item blank", add 
label define label_xf2e091 32 "Do not know", add 
label define label_xf2e091 33 "Particular 1st prof field not applicable", add 
label define label_xf2e091 40 "Suppressed to protect confidentiality", add 
label values xf2e091 label_xf2e091
label define label_xf2e092 10 "Reported" 
label define label_xf2e092 11 "Analyst corrected reported value", add 
label define label_xf2e092 12 "Data generated from other data values", add 
label define label_xf2e092 13 "Implied zero", add 
label define label_xf2e092 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e092 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e092 22 "Imputed using the Group Median procedure", add 
label define label_xf2e092 23 "Partial imputation", add 
label define label_xf2e092 30 "Not applicable", add 
label define label_xf2e092 31 "Institution left item blank", add 
label define label_xf2e092 32 "Do not know", add 
label define label_xf2e092 33 "Particular 1st prof field not applicable", add 
label define label_xf2e092 40 "Suppressed to protect confidentiality", add 
label values xf2e092 label_xf2e092
label define label_xf2e101 10 "Reported" 
label define label_xf2e101 11 "Analyst corrected reported value", add 
label define label_xf2e101 12 "Data generated from other data values", add 
label define label_xf2e101 13 "Implied zero", add 
label define label_xf2e101 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e101 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e101 22 "Imputed using the Group Median procedure", add 
label define label_xf2e101 23 "Partial imputation", add 
label define label_xf2e101 30 "Not applicable", add 
label define label_xf2e101 31 "Institution left item blank", add 
label define label_xf2e101 32 "Do not know", add 
label define label_xf2e101 33 "Particular 1st prof field not applicable", add 
label define label_xf2e101 40 "Suppressed to protect confidentiality", add 
label values xf2e101 label_xf2e101
label define label_xf2e102 10 "Reported" 
label define label_xf2e102 11 "Analyst corrected reported value", add 
label define label_xf2e102 12 "Data generated from other data values", add 
label define label_xf2e102 13 "Implied zero", add 
label define label_xf2e102 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e102 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e102 22 "Imputed using the Group Median procedure", add 
label define label_xf2e102 23 "Partial imputation", add 
label define label_xf2e102 30 "Not applicable", add 
label define label_xf2e102 31 "Institution left item blank", add 
label define label_xf2e102 32 "Do not know", add 
label define label_xf2e102 33 "Particular 1st prof field not applicable", add 
label define label_xf2e102 40 "Suppressed to protect confidentiality", add 
label values xf2e102 label_xf2e102
label define label_xf2e111 10 "Reported" 
label define label_xf2e111 11 "Analyst corrected reported value", add 
label define label_xf2e111 12 "Data generated from other data values", add 
label define label_xf2e111 13 "Implied zero", add 
label define label_xf2e111 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e111 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e111 22 "Imputed using the Group Median procedure", add 
label define label_xf2e111 23 "Partial imputation", add 
label define label_xf2e111 30 "Not applicable", add 
label define label_xf2e111 31 "Institution left item blank", add 
label define label_xf2e111 32 "Do not know", add 
label define label_xf2e111 33 "Particular 1st prof field not applicable", add 
label define label_xf2e111 40 "Suppressed to protect confidentiality", add 
label values xf2e111 label_xf2e111
label define label_xf2e112 10 "Reported" 
label define label_xf2e112 11 "Analyst corrected reported value", add 
label define label_xf2e112 12 "Data generated from other data values", add 
label define label_xf2e112 13 "Implied zero", add 
label define label_xf2e112 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e112 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e112 22 "Imputed using the Group Median procedure", add 
label define label_xf2e112 23 "Partial imputation", add 
label define label_xf2e112 30 "Not applicable", add 
label define label_xf2e112 31 "Institution left item blank", add 
label define label_xf2e112 32 "Do not know", add 
label define label_xf2e112 33 "Particular 1st prof field not applicable", add 
label define label_xf2e112 40 "Suppressed to protect confidentiality", add 
label values xf2e112 label_xf2e112
label define label_xf2e121 10 "Reported" 
label define label_xf2e121 11 "Analyst corrected reported value", add 
label define label_xf2e121 12 "Data generated from other data values", add 
label define label_xf2e121 13 "Implied zero", add 
label define label_xf2e121 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e121 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e121 22 "Imputed using the Group Median procedure", add 
label define label_xf2e121 23 "Partial imputation", add 
label define label_xf2e121 30 "Not applicable", add 
label define label_xf2e121 31 "Institution left item blank", add 
label define label_xf2e121 32 "Do not know", add 
label define label_xf2e121 33 "Particular 1st prof field not applicable", add 
label define label_xf2e121 40 "Suppressed to protect confidentiality", add 
label values xf2e121 label_xf2e121
label define label_xf2e122 10 "Reported" 
label define label_xf2e122 11 "Analyst corrected reported value", add 
label define label_xf2e122 12 "Data generated from other data values", add 
label define label_xf2e122 13 "Implied zero", add 
label define label_xf2e122 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e122 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e122 22 "Imputed using the Group Median procedure", add 
label define label_xf2e122 23 "Partial imputation", add 
label define label_xf2e122 30 "Not applicable", add 
label define label_xf2e122 31 "Institution left item blank", add 
label define label_xf2e122 32 "Do not know", add 
label define label_xf2e122 33 "Particular 1st prof field not applicable", add 
label define label_xf2e122 40 "Suppressed to protect confidentiality", add 
label values xf2e122 label_xf2e122
label define label_xf2e141 10 "Reported" 
label define label_xf2e141 11 "Analyst corrected reported value", add 
label define label_xf2e141 12 "Data generated from other data values", add 
label define label_xf2e141 13 "Implied zero", add 
label define label_xf2e141 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e141 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e141 22 "Imputed using the Group Median procedure", add 
label define label_xf2e141 23 "Partial imputation", add 
label define label_xf2e141 30 "Not applicable", add 
label define label_xf2e141 31 "Institution left item blank", add 
label define label_xf2e141 32 "Do not know", add 
label define label_xf2e141 33 "Particular 1st prof field not applicable", add 
label define label_xf2e141 40 "Suppressed to protect confidentiality", add 
label values xf2e141 label_xf2e141
label define label_xf2e151 10 "Reported" 
label define label_xf2e151 11 "Analyst corrected reported value", add 
label define label_xf2e151 12 "Data generated from other data values", add 
label define label_xf2e151 13 "Implied zero", add 
label define label_xf2e151 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e151 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e151 22 "Imputed using the Group Median procedure", add 
label define label_xf2e151 23 "Partial imputation", add 
label define label_xf2e151 30 "Not applicable", add 
label define label_xf2e151 31 "Institution left item blank", add 
label define label_xf2e151 32 "Do not know", add 
label define label_xf2e151 33 "Particular 1st prof field not applicable", add 
label define label_xf2e151 40 "Suppressed to protect confidentiality", add 
label values xf2e151 label_xf2e151
label define label_xf2e161 10 "Reported" 
label define label_xf2e161 11 "Analyst corrected reported value", add 
label define label_xf2e161 12 "Data generated from other data values", add 
label define label_xf2e161 13 "Implied zero", add 
label define label_xf2e161 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e161 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e161 22 "Imputed using the Group Median procedure", add 
label define label_xf2e161 23 "Partial imputation", add 
label define label_xf2e161 30 "Not applicable", add 
label define label_xf2e161 31 "Institution left item blank", add 
label define label_xf2e161 32 "Do not know", add 
label define label_xf2e161 33 "Particular 1st prof field not applicable", add 
label define label_xf2e161 40 "Suppressed to protect confidentiality", add 
label values xf2e161 label_xf2e161
label define label_xf2e171 10 "Reported" 
label define label_xf2e171 11 "Analyst corrected reported value", add 
label define label_xf2e171 12 "Data generated from other data values", add 
label define label_xf2e171 13 "Implied zero", add 
label define label_xf2e171 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e171 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e171 22 "Imputed using the Group Median procedure", add 
label define label_xf2e171 23 "Partial imputation", add 
label define label_xf2e171 30 "Not applicable", add 
label define label_xf2e171 31 "Institution left item blank", add 
label define label_xf2e171 32 "Do not know", add 
label define label_xf2e171 33 "Particular 1st prof field not applicable", add 
label define label_xf2e171 40 "Suppressed to protect confidentiality", add 
label values xf2e171 label_xf2e171
tab xf2a01
tab xf2a02
tab xf2a03
tab xf2a04
tab xf2a05
tab xf2a06
tab xf2a11
tab xf2a12
tab xf2a13
tab xf2a14
tab xf2b01
tab xf2b02
tab xf2b03
tab xf2b04
tab xf2b05
tab xf2b06
tab xf2b07
tab xf2c01
tab xf2c02
tab xf2c03
tab xf2c04
tab xf2c05
tab xf2c06
tab xf2c07
tab xf2c08
tab xf2c09
tab xf2d01
tab xf2d02
tab xf2d03
tab xf2d04
tab xf2d05
tab xf2d06
tab xf2d07
tab xf2d08
tab xf2d09
tab xf2d10
tab xf2d11
tab xf2d12
tab xf2d13
tab xf2d14
tab xf2d15
tab xf2d16
tab xf2e011
tab xf2e012
tab xf2e021
tab xf2e022
tab xf2e031
tab xf2e032
tab xf2e041
tab xf2e042
tab xf2e051
tab xf2e052
tab xf2e061
tab xf2e062
tab xf2e071
tab xf2e072
tab xf2e081
tab xf2e082
tab xf2e091
tab xf2e092
tab xf2e101
tab xf2e102
tab xf2e111
tab xf2e112
tab xf2e121
tab xf2e122
tab xf2e141
tab xf2e151
tab xf2e161
tab xf2e171
summarize f2a01
summarize f2a02
summarize f2a03
summarize f2a04
summarize f2a05
summarize f2a06
summarize f2a11
summarize f2a12
summarize f2a13
summarize f2a14
summarize f2b01
summarize f2b02
summarize f2b03
summarize f2b04
summarize f2b05
summarize f2b06
summarize f2b07
summarize f2c01
summarize f2c02
summarize f2c03
summarize f2c04
summarize f2c05
summarize f2c06
summarize f2c07
summarize f2c08
summarize f2c09
summarize f2d01
summarize f2d02
summarize f2d03
summarize f2d04
summarize f2d05
summarize f2d06
summarize f2d07
summarize f2d08
summarize f2d09
summarize f2d10
summarize f2d11
summarize f2d12
summarize f2d13
summarize f2d14
summarize f2d15
summarize f2d16
summarize f2e011
summarize f2e012
summarize f2e021
summarize f2e022
summarize f2e031
summarize f2e032
summarize f2e041
summarize f2e042
summarize f2e051
summarize f2e052
summarize f2e061
summarize f2e062
summarize f2e071
summarize f2e072
summarize f2e081
summarize f2e082
summarize f2e091
summarize f2e092
summarize f2e101
summarize f2e102
summarize f2e111
summarize f2e112
summarize f2e121
summarize f2e122
summarize f2e141
summarize f2e151
summarize f2e161
summarize f2e171
save dct_f0001_f2

