* Created: 2/22/2008 10:21:51 AM
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
insheet using "../Raw Data/f0506_f1a_data_stata.csv", comma clear
label data "dct_f0506_f1a"
label variable unitid "unitid"
label variable xf1a01 "Imputation field for F1A01 - Total current assets"
label variable f1a01 "Total current assets"
label variable xf1a02 "Imputation field for F1A02 - Capital assets - depreciable (gross)"
label variable f1a02 "Capital assets - depreciable (gross)"
label variable xf1a03 "Imputation field for F1A03 - Accumulated depreciation (enter as a positive amount)"
label variable f1a03 "Accumulated depreciation (enter as a positive amount)"
label variable xf1a04 "Imputation field for F1A04 - Other noncurrent assets"
label variable f1a04 "Other noncurrent assets"
label variable xf1a05 "Imputation field for F1A05 - Total noncurrent assets"
label variable f1a05 "Total noncurrent assets"
label variable xf1a06 "Imputation field for F1A06 - Total assets"
label variable f1a06 "Total assets"
label variable xf1a07 "Imputation field for F1A07 - Long-term debt, current portion"
label variable f1a07 "Long-term debt, current portion"
label variable xf1a08 "Imputation field for F1A08 - Other current liabilities"
label variable f1a08 "Other current liabilities"
label variable xf1a09 "Imputation field for F1A09 - Total current liabilities"
label variable f1a09 "Total current liabilities"
label variable xf1a10 "Imputation field for F1A10 - Long-term debt"
label variable f1a10 "Long-term debt"
label variable xf1a11 "Imputation field for F1A11 - Other noncurrent liabilities"
label variable f1a11 "Other noncurrent liabilities"
label variable xf1a12 "Imputation field for F1A12 - Total noncurrent liabilities"
label variable f1a12 "Total noncurrent liabilities"
label variable xf1a13 "Imputation field for F1A13 - Total liabilities"
label variable f1a13 "Total liabilities"
label variable xf1a14 "Imputation field for F1A14 - Invested in capital assets, net of related debt"
label variable f1a14 "Invested in capital assets, net of related debt"
label variable xf1a15 "Imputation field for F1A15 - Restricted-expendable"
label variable f1a15 "Restricted-expendable"
label variable xf1a16 "Imputation field for F1A16 - Restricted-nonexpendable"
label variable f1a16 "Restricted-nonexpendable"
label variable xf1a17 "Imputation field for F1A17 - Unrestricted"
label variable f1a17 "Unrestricted"
label variable xf1a18 "Imputation field for F1A18 - Total net assets"
label variable f1a18 "Total net assets"
label variable xf1a211 "Imputation field for F1A211 - Land  improvements - Beginning balance"
label variable f1a211 "Land  improvements - Beginning balance"
label variable xf1a212 "Imputation field for F1A212 - Land  improvements - Additions"
label variable f1a212 "Land  improvements - Additions"
label variable xf1a213 "Imputation field for F1A213 - Land  improvements - Retirements"
label variable f1a213 "Land  improvements - Retirements"
label variable xf1a214 "Imputation field for F1A214 - Land  improvements - Ending balance"
label variable f1a214 "Land  improvements - Ending balance"
label variable xf1a221 "Imputation field for F1A221 - Infrastructure - Beginning balance"
label variable f1a221 "Infrastructure - Beginning balance"
label variable xf1a222 "Imputation field for F1A222 - Infrastructure - Additions"
label variable f1a222 "Infrastructure - Additions"
label variable xf1a223 "Imputation field for F1A223 - Infrastructure - Retirements"
label variable f1a223 "Infrastructure - Retirements"
label variable xf1a224 "Imputation field for F1A224 - Infrastructure - Ending balance"
label variable f1a224 "Infrastructure - Ending balance"
label variable xf1a231 "Imputation field for F1A231 - Buildings - Beginning balance"
label variable f1a231 "Buildings - Beginning balance"
label variable xf1a232 "Imputation field for F1A232 - Buildings - Additions"
label variable f1a232 "Buildings - Additions"
label variable xf1a233 "Imputation field for F1A233 - Buildings - Retirements"
label variable f1a233 "Buildings - Retirements"
label variable xf1a234 "Imputation field for F1A234 - Buildings - Ending balance"
label variable f1a234 "Buildings - Ending balance"
label variable xf1a241 "Imputation field for F1A241 - Equipment - Beginning balance"
label variable f1a241 "Equipment - Beginning balance"
label variable xf1a242 "Imputation field for F1A242 - Equipment - Additions"
label variable f1a242 "Equipment - Additions"
label variable xf1a243 "Imputation field for F1A243 - Equipment - Retirements"
label variable f1a243 "Equipment - Retirements"
label variable xf1a244 "Imputation field for F1A244 - Equipment - Ending balance"
label variable f1a244 "Equipment - Ending balance"
label variable xf1a251 "Imputation field for F1A251 - Art and library collections - Beginning balance"
label variable f1a251 "Art and library collections - Beginning balance"
label variable xf1a252 "Imputation field for F1A252 - Art and library collections - Additions"
label variable f1a252 "Art and library collections - Additions"
label variable xf1a253 "Imputation field for F1A253 - Art and library collections - Retirements"
label variable f1a253 "Art and library collections - Retirements"
label variable xf1a254 "Imputation field for F1A254 - Art and library collections - Ending balance"
label variable f1a254 "Art and library collections - Ending balance"
label variable xf1a261 "Imputation field for F1A261 - Property obtained under capital leases - Beginning balance"
label variable f1a261 "Property obtained under capital leases - Beginning balance"
label variable xf1a262 "Imputation field for F1A262 - Property obtained under capital leases - Additions"
label variable f1a262 "Property obtained under capital leases - Additions"
label variable xf1a263 "Imputation field for F1A263 - Property obtained under capital leases  - Retirements"
label variable f1a263 "Property obtained under capital leases  - Retirements"
label variable xf1a264 "Imputation field for F1A264 - Property obtained under capital leases  - Ending balance"
label variable f1a264 "Property obtained under capital leases  - Ending balance"
label variable xf1a271 "Imputation field for F1A271 - Construction in progress - Beginning balance"
label variable f1a271 "Construction in progress - Beginning balance"
label variable xf1a272 "Imputation field for F1A272 - Construction in progress - Additions"
label variable f1a272 "Construction in progress - Additions"
label variable xf1a273 "Imputation field for F1A273 - Construction in progress - Retirements"
label variable f1a273 "Construction in progress - Retirements"
label variable xf1a274 "Imputation field for F1A274 - Construction in progress - Ending balance"
label variable f1a274 "Construction in progress - Ending balance"
label variable xf1a281 "Imputation field for F1A281 - Accumulated depreciation - Beginning balance"
label variable f1a281 "Accumulated depreciation - Beginning balance"
label variable xf1a282 "Imputation field for F1A282 - Accumulated depreciation - Additions"
label variable f1a282 "Accumulated depreciation - Additions"
label variable xf1a283 "Imputation field for F1A283 - Accumulated depreciation - Retirements"
label variable f1a283 "Accumulated depreciation - Retirements"
label variable xf1a284 "Imputation field for F1A284 - Accumulated depreciation - Ending balance"
label variable f1a284 "Accumulated depreciation - Ending balance"
label variable xf1b01 "Imputation field for F1B01 - Tuition and fees, after deducting discounts and allowances"
label variable f1b01 "Tuition and fees, after deducting discounts and allowances"
label variable xf1b02 "Imputation field for F1B02 - Federal operating grants and contracts"
label variable f1b02 "Federal operating grants and contracts"
label variable xf1b03 "Imputation field for F1B03 - State operating grants and contracts"
label variable f1b03 "State operating grants and contracts"
label variable xf1b04 "Imputation field for F1B04 - Local/private operating grants and contracts"
label variable f1b04 "Local/private operating grants and contracts"
label variable xf1b05 "Imputation field for F1B05 - Sales and services of auxiliary enterprises"
label variable f1b05 "Sales and services of auxiliary enterprises"
label variable xf1b06 "Imputation field for F1B06 - Sales and services of hospitals"
label variable f1b06 "Sales and services of hospitals"
label variable xf1b07 "Imputation field for F1B07 - Independent operations"
label variable f1b07 "Independent operations"
label variable xf1b08 "Imputation field for F1B08 - Other sources - operating"
label variable f1b08 "Other sources - operating"
label variable xf1b09 "Imputation field for F1B09 - Total operating revenues"
label variable f1b09 "Total operating revenues"
label variable xf1b10 "Imputation field for F1B10 - Federal appropriations"
label variable f1b10 "Federal appropriations"
label variable xf1b11 "Imputation field for F1B11 - State appropriations"
label variable f1b11 "State appropriations"
label variable xf1b12 "Imputation field for F1B12 - Local appropriations, education district taxes, and similar support"
label variable f1b12 "Local appropriations, education district taxes, and similar support"
label variable xf1b13 "Imputation field for F1B13 - Federal nonoperating grants"
label variable f1b13 "Federal nonoperating grants"
label variable xf1b14 "Imputation field for F1B14 - State nonoperating grants"
label variable f1b14 "State nonoperating grants"
label variable xf1b15 "Imputation field for F1B15 - Local nonoperating grants"
label variable f1b15 "Local nonoperating grants"
label variable xf1b16 "Imputation field for F1B16 - Gifts, including contributions from affiliated organizations"
label variable f1b16 "Gifts, including contributions from affiliated organizations"
label variable xf1b17 "Imputation field for F1B17 - Investment income"
label variable f1b17 "Investment income"
label variable xf1b18 "Imputation field for F1B18 - Other nonoperating revenues"
label variable f1b18 "Other nonoperating revenues"
label variable xf1b19 "Imputation field for F1B19 - Total nonoperating revenues"
label variable f1b19 "Total nonoperating revenues"
label variable xf1b20 "Imputation field for F1B20 - Capital appropriations"
label variable f1b20 "Capital appropriations"
label variable xf1b21 "Imputation field for F1B21 - Capital grants and gifts"
label variable f1b21 "Capital grants and gifts"
label variable xf1b22 "Imputation field for F1B22 - Additions to permanent endowments"
label variable f1b22 "Additions to permanent endowments"
label variable xf1b23 "Imputation field for F1B23 - Other revenues and additions"
label variable f1b23 "Other revenues and additions"
label variable xf1b24 "Imputation field for F1B24 - Total other revenues and additions"
label variable f1b24 "Total other revenues and additions"
label variable xf1b25 "Imputation field for F1B25 - Total all revenues and other additions"
label variable f1b25 "Total all revenues and other additions"
label variable xf1c011 "Imputation field for F1C011 - Instruction - Current year total"
label variable f1c011 "Instruction - Current year total"
label variable xf1c012 "Imputation field for F1C012 - Instruction - Salaries and wages"
label variable f1c012 "Instruction - Salaries and wages"
label variable xf1c013 "Imputation field for F1C013 - Instruction - Employee fringe benefits"
label variable f1c013 "Instruction - Employee fringe benefits"
label variable xf1c014 "Imputation field for F1C014 - Instruction - Depreciation"
label variable f1c014 "Instruction - Depreciation"
label variable xf1c015 "Imputation field for F1C015 - Instruction - All other"
label variable f1c015 "Instruction - All other"
label variable xf1c021 "Imputation field for F1C021 - Research - Current year total"
label variable f1c021 "Research - Current year total"
label variable xf1c022 "Imputation field for F1C022 - Research - Salaries and wages"
label variable f1c022 "Research - Salaries and wages"
label variable xf1c023 "Imputation field for F1C023 - Research - Employee fringe benefits"
label variable f1c023 "Research - Employee fringe benefits"
label variable xf1c024 "Imputation field for F1C024 - Research - Depreciation"
label variable f1c024 "Research - Depreciation"
label variable xf1c025 "Imputation field for F1C025 - Research - All other"
label variable f1c025 "Research - All other"
label variable xf1c031 "Imputation field for F1C031 - Public service - Current year total"
label variable f1c031 "Public service - Current year total"
label variable xf1c032 "Imputation field for F1C032 - Public service - Salaries and wages"
label variable f1c032 "Public service - Salaries and wages"
label variable xf1c033 "Imputation field for F1C033 - Public service - Employee fringe benefits"
label variable f1c033 "Public service - Employee fringe benefits"
label variable xf1c034 "Imputation field for F1C034 - Public service - Depreciation"
label variable f1c034 "Public service - Depreciation"
label variable xf1c035 "Imputation field for F1C035 - Public service - All other"
label variable f1c035 "Public service - All other"
label variable xf1c051 "Imputation field for F1C051 - Academic support - Current year total"
label variable f1c051 "Academic support - Current year total"
label variable xf1c052 "Imputation field for F1C052 - Academic support - Salaries and wages"
label variable f1c052 "Academic support - Salaries and wages"
label variable xf1c053 "Imputation field for F1C053 - Academic support - Employee fringe benefits"
label variable f1c053 "Academic support - Employee fringe benefits"
label variable xf1c054 "Imputation field for F1C054 - Academic support - Depreciation"
label variable f1c054 "Academic support - Depreciation"
label variable xf1c055 "Imputation field for F1C055 - Academic support - All other"
label variable f1c055 "Academic support - All other"
label variable xf1c061 "Imputation field for F1C061 - Student services - Current year total"
label variable f1c061 "Student services - Current year total"
label variable xf1c062 "Imputation field for F1C062 - Student services - Salaries and wages"
label variable f1c062 "Student services - Salaries and wages"
label variable xf1c063 "Imputation field for F1C063 - Student services - Employee fringe benefits"
label variable f1c063 "Student services - Employee fringe benefits"
label variable xf1c064 "Imputation field for F1C064 - Student services - Depreciation"
label variable f1c064 "Student services - Depreciation"
label variable xf1c065 "Imputation field for F1C065 - Student services - All other"
label variable f1c065 "Student services - All other"
label variable xf1c071 "Imputation field for F1C071 - Institutional support - Current year total"
label variable f1c071 "Institutional support - Current year total"
label variable xf1c072 "Imputation field for F1C072 - Institutional support - Salaries and wages"
label variable f1c072 "Institutional support - Salaries and wages"
label variable xf1c073 "Imputation field for F1C073 - Institutional support - Employee fringe benefits"
label variable f1c073 "Institutional support - Employee fringe benefits"
label variable xf1c074 "Imputation field for F1C074 - Institutional support - Depreciation"
label variable f1c074 "Institutional support - Depreciation"
label variable xf1c075 "Imputation field for F1C075 - Institutional support - All other"
label variable f1c075 "Institutional support - All other"
label variable xf1c081 "Imputation field for F1C081 - Operation  maintenance of plant - Current year total"
label variable f1c081 "Operation  maintenance of plant - Current year total"
label variable xf1c082 "Imputation field for F1C082 - Operation  maintenance of plant - Salaries and wages"
label variable f1c082 "Operation  maintenance of plant - Salaries and wages"
label variable xf1c083 "Imputation field for F1C083 - Operation  maintenance of plant - Employee fringe benefits"
label variable f1c083 "Operation  maintenance of plant - Employee fringe benefits"
label variable xf1c084 "Imputation field for F1C084 - Operation  maintenance of plant - Depreciation"
label variable f1c084 "Operation  maintenance of plant - Depreciation"
label variable xf1c085 "Imputation field for F1C085 - Operation  maintenance of plant - All other"
label variable f1c085 "Operation  maintenance of plant - All other"
label variable xf1c091 "Imputation field for F1C091 - Depreciation - total expense"
label variable f1c091 "Depreciation - total expense"
label variable xf1c094 "Imputation field for F1C094 - Depreciation"
label variable f1c094 "Depreciation"
label variable xf1c101 "Imputation field for F1C101 - Scholarships and fellowships expenses -- Current year total"
label variable f1c101 "Scholarships and fellowships expenses -- Current year total"
label variable xf1c102 "Imputation field for F1C102 - Scholarships and fellowships expenses -- Salaries and wages"
label variable f1c102 "Scholarships and fellowships expenses -- Salaries and wages"
label variable xf1c103 "Imputation field for F1C103 - Scholarships and fellowships expenses -- Employee fringe benefits"
label variable f1c103 "Scholarships and fellowships expenses -- Employee fringe benefits"
label variable xf1c104 "Imputation field for F1C104 - Scholarships and fellowships expenses -- Depreciation"
label variable f1c104 "Scholarships and fellowships expenses -- Depreciation"
label variable xf1c105 "Imputation field for F1C105 - Scholarships and fellowships expenses -- All other"
label variable f1c105 "Scholarships and fellowships expenses -- All other"
label variable xf1c111 "Imputation field for F1C111 - Auxiliary enterprises -- Current year total"
label variable f1c111 "Auxiliary enterprises -- Current year total"
label variable xf1c112 "Imputation field for F1C112 - Auxiliary enterprises -- Salaries and wages"
label variable f1c112 "Auxiliary enterprises -- Salaries and wages"
label variable xf1c113 "Imputation field for F1C113 - Auxiliary enterprises -- Employee fringe benefits"
label variable f1c113 "Auxiliary enterprises -- Employee fringe benefits"
label variable xf1c114 "Imputation field for F1C114 - Auxiliary enterprises -- Depreciation"
label variable f1c114 "Auxiliary enterprises -- Depreciation"
label variable xf1c115 "Imputation field for F1C115 - Auxiliary enterprises -- All other"
label variable f1c115 "Auxiliary enterprises -- All other"
label variable xf1c121 "Imputation field for F1C121 - Hospital services - Current year total"
label variable f1c121 "Hospital services - Current year total"
label variable xf1c122 "Imputation field for F1C122 - Hospital services - Salaries and wages"
label variable f1c122 "Hospital services - Salaries and wages"
label variable xf1c123 "Imputation field for F1C123 - Hospital services - Employee fringe benefits"
label variable f1c123 "Hospital services - Employee fringe benefits"
label variable xf1c124 "Imputation field for F1C124 - Hospital services - Depreciation"
label variable f1c124 "Hospital services - Depreciation"
label variable xf1c125 "Imputation field for F1C125 - Hospital services - All other"
label variable f1c125 "Hospital services - All other"
label variable xf1c131 "Imputation field for F1C131 - Independent operations - Current year total"
label variable f1c131 "Independent operations - Current year total"
label variable xf1c132 "Imputation field for F1C132 - Independent operations - Salaries and wages"
label variable f1c132 "Independent operations - Salaries and wages"
label variable xf1c133 "Imputation field for F1C133 - Independent operations - Employee fringe benefits"
label variable f1c133 "Independent operations - Employee fringe benefits"
label variable xf1c134 "Imputation field for F1C134 - Independent operations - Depreciation"
label variable f1c134 "Independent operations - Depreciation"
label variable xf1c135 "Imputation field for F1C135 - Independent operations - All other"
label variable f1c135 "Independent operations - All other"
label variable xf1c141 "Imputation field for F1C141 - Other expenses  deductions - Current year total"
label variable f1c141 "Other expenses  deductions - Current year total"
label variable xf1c142 "Imputation field for F1C142 - Other expenses  deductions - Salaries and wages"
label variable f1c142 "Other expenses  deductions - Salaries and wages"
label variable xf1c143 "Imputation field for F1C143 - Other expenses  deductions - Employee fringe benefits"
label variable f1c143 "Other expenses  deductions - Employee fringe benefits"
label variable xf1c144 "Imputation field for F1C144 - Other expenses  deductions - Depreciation"
label variable f1c144 "Other expenses  deductions - Depreciation"
label variable xf1c145 "Imputation field for F1C145 - Other expenses  deductions - All other"
label variable f1c145 "Other expenses  deductions - All other"
label variable xf1c151 "Imputation field for F1C151 - Total operating expenses - Current year total"
label variable f1c151 "Total operating expenses - Current year total"
label variable xf1c152 "Imputation field for F1C152 - Total operating expenses - Salaries  wages"
label variable f1c152 "Total operating expenses - Salaries  wages"
label variable xf1c153 "Imputation field for F1C153 - Total operating expenses - Employee fringe benefits"
label variable f1c153 "Total operating expenses - Employee fringe benefits"
label variable xf1c154 "Imputation field for F1C154 - Total operating expenses - Depreciation"
label variable f1c154 "Total operating expenses - Depreciation"
label variable xf1c155 "Imputation field for F1C155 - Total operating expenses - All other"
label variable f1c155 "Total operating expenses - All other"
label variable xf1c161 "Imputation field for F1C161 - Interest - Current year total"
label variable f1c161 "Interest - Current year total"
label variable xf1c165 "Imputation field for F1C165 - Interest - All other"
label variable f1c165 "Interest - All other"
label variable xf1c171 "Imputation field for F1C171 - Other nonoperating expenses and deductions -  Current year total"
label variable f1c171 "Other nonoperating expenses and deductions -  Current year total"
label variable xf1c172 "Imputation field for F1C172 - Other nonoperating expenses and deductions - Salaries and wages"
label variable f1c172 "Other nonoperating expenses and deductions - Salaries and wages"
label variable xf1c173 "Imputation field for F1C173 - Other nonoperating expenses and deductions - Employee fringe benefits"
label variable f1c173 "Other nonoperating expenses and deductions - Employee fringe benefits"
label variable xf1c174 "Imputation field for F1C174 - Other nonoperating expenses and deductions - Depreciation"
label variable f1c174 "Other nonoperating expenses and deductions - Depreciation"
label variable xf1c175 "Imputation field for F1C175 - Other nonoperating expenses and deductions - All other"
label variable f1c175 "Other nonoperating expenses and deductions - All other"
label variable xf1c181 "Imputation field for F1C181 - Total nonoperating expenses and deductions - Current year total"
label variable f1c181 "Total nonoperating expenses and deductions - Current year total"
label variable xf1c182 "Imputation field for F1C182 - Total nonoperating expenses and deductions - Salaries and wages"
label variable f1c182 "Total nonoperating expenses and deductions - Salaries and wages"
label variable xf1c183 "Imputation field for F1C183 - Total nonoperating expenses and deductions - Employee fringe benefits"
label variable f1c183 "Total nonoperating expenses and deductions - Employee fringe benefits"
label variable xf1c184 "Imputation field for F1C184 - Total nonoperating expenses and deductions - Depreciation"
label variable f1c184 "Total nonoperating expenses and deductions - Depreciation"
label variable xf1c185 "Imputation field for F1C185 - Total nonoperating expenses and deductions - All other"
label variable f1c185 "Total nonoperating expenses and deductions - All other"
label variable xf1c191 "Imputation field for F1C191 - Total expenses  deductions - Current year total"
label variable f1c191 "Total expenses  deductions - Current year total"
label variable xf1c192 "Imputation field for F1C192 - Total expenses  deductions - Salaries and wages"
label variable f1c192 "Total expenses  deductions - Salaries and wages"
label variable xf1c193 "Imputation field for F1C193 - Total expenses  deductions - Employee fringe benefits"
label variable f1c193 "Total expenses  deductions - Employee fringe benefits"
label variable xf1c194 "Imputation field for F1C194 - Total expenses  deductions - Depreciation"
label variable f1c194 "Total expenses  deductions - Depreciation"
label variable xf1c195 "Imputation field for F1C195 - Total expenses  deductions - All other"
label variable f1c195 "Total expenses  deductions - All other"
label variable xf1d01 "Imputation field for F1D01 - Total revenues and other additions"
label variable f1d01 "Total revenues and other additions"
label variable xf1d02 "Imputation field for F1D02 - Total expenses and other deductions"
label variable f1d02 "Total expenses and other deductions"
label variable xf1d03 "Imputation field for F1D03 - Increase in net assets during the year"
label variable f1d03 "Increase in net assets during the year"
label variable xf1d04 "Imputation field for F1D04 - Net assets beginning of year"
label variable f1d04 "Net assets beginning of year"
label variable xf1d05 "Imputation field for F1D05 - Adjustments to beginning net assets"
label variable f1d05 "Adjustments to beginning net assets"
label variable xf1d06 "Imputation field for F1D06 - Net assets end of year"
label variable f1d06 "Net assets end of year"
label variable xf1h01 "Imputation field for F1H01 - Value of endowment assets at the beginning of the fiscal year"
label variable f1h01 "Value of endowment assets at the beginning of the fiscal year"
label variable xf1h02 "Imputation field for F1H02 - Value of endowment assets at the end of the fiscal year"
label variable f1h02 "Value of endowment assets at the end of the fiscal year"
label variable xf1e01 "Imputation field for F1E01 - Pell grants (federal)"
label variable f1e01 "Pell grants (federal)"
label variable xf1e02 "Imputation field for F1E02 - Other federal grants"
label variable f1e02 "Other federal grants"
label variable xf1e03 "Imputation field for F1E03 - Grants by state government"
label variable f1e03 "Grants by state government"
label variable xf1e04 "Imputation field for F1E04 - Grants by local government"
label variable f1e04 "Grants by local government"
label variable xf1e05 "Imputation field for F1E05 - Institutional grants from restricted resources"
label variable f1e05 "Institutional grants from restricted resources"
label variable xf1e06 "Imputation field for F1E06 - Institutional grants from unrestricted resources"
label variable f1e06 "Institutional grants from unrestricted resources"
label variable xf1e07 "Imputation field for F1E07 - Total gross scholarships and fellowships"
label variable f1e07 "Total gross scholarships and fellowships"
label variable xf1e08 "Imputation field for F1E08 - Discounts and allowances applied to tuition and fees"
label variable f1e08 "Discounts and allowances applied to tuition and fees"
label variable xf1e09 "Imputation field for F1E09 - Discounts and fellowships applied to sales & services of auxiliary enterprises"
label variable f1e09 "Discounts and fellowships applied to sales & services of auxiliary enterprises"
label variable xf1e10 "Imputation field for F1E10 - Total discounts and fellowships"
label variable f1e10 "Total discounts and fellowships"
label variable xf1e11 "Imputation field for F1E11 - Net scholarships and fellowships"
label variable f1e11 "Net scholarships and fellowships"
label variable f1fha "Does this institution or any of its foundations or other affiliated organizations own endowment assets ?"
label define label_xf1a01 10 "Reported" 
label define label_xf1a01 11 "Analyst corrected reported value", add 
label define label_xf1a01 12 "Data generated from other data values", add 
label define label_xf1a01 13 "Implied zero", add 
label define label_xf1a01 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a01 22 "Imputed using the Group Median procedure", add 
label define label_xf1a01 23 "Logical imputation", add 
label define label_xf1a01 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a01 30 "Not applicable", add 
label define label_xf1a01 31 "Institution left item blank", add 
label define label_xf1a01 32 "Do not know", add 
label define label_xf1a01 33 "Particular 1st prof field not applicable", add 
label define label_xf1a01 50 "Outlier value derived from reported data", add 
label define label_xf1a01 51 "Outlier value derived from imported data", add 
label define label_xf1a01 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a01 53 "Value not derived - data not usable", add 
label values xf1a01 label_xf1a01
label define label_xf1a02 10 "Reported" 
label define label_xf1a02 11 "Analyst corrected reported value", add 
label define label_xf1a02 12 "Data generated from other data values", add 
label define label_xf1a02 13 "Implied zero", add 
label define label_xf1a02 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a02 22 "Imputed using the Group Median procedure", add 
label define label_xf1a02 23 "Logical imputation", add 
label define label_xf1a02 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a02 30 "Not applicable", add 
label define label_xf1a02 31 "Institution left item blank", add 
label define label_xf1a02 32 "Do not know", add 
label define label_xf1a02 33 "Particular 1st prof field not applicable", add 
label define label_xf1a02 50 "Outlier value derived from reported data", add 
label define label_xf1a02 51 "Outlier value derived from imported data", add 
label define label_xf1a02 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a02 53 "Value not derived - data not usable", add 
label values xf1a02 label_xf1a02
label define label_xf1a03 10 "Reported" 
label define label_xf1a03 11 "Analyst corrected reported value", add 
label define label_xf1a03 12 "Data generated from other data values", add 
label define label_xf1a03 13 "Implied zero", add 
label define label_xf1a03 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a03 22 "Imputed using the Group Median procedure", add 
label define label_xf1a03 23 "Logical imputation", add 
label define label_xf1a03 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a03 30 "Not applicable", add 
label define label_xf1a03 31 "Institution left item blank", add 
label define label_xf1a03 32 "Do not know", add 
label define label_xf1a03 33 "Particular 1st prof field not applicable", add 
label define label_xf1a03 50 "Outlier value derived from reported data", add 
label define label_xf1a03 51 "Outlier value derived from imported data", add 
label define label_xf1a03 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a03 53 "Value not derived - data not usable", add 
label values xf1a03 label_xf1a03
label define label_xf1a04 10 "Reported" 
label define label_xf1a04 11 "Analyst corrected reported value", add 
label define label_xf1a04 12 "Data generated from other data values", add 
label define label_xf1a04 13 "Implied zero", add 
label define label_xf1a04 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a04 22 "Imputed using the Group Median procedure", add 
label define label_xf1a04 23 "Logical imputation", add 
label define label_xf1a04 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a04 30 "Not applicable", add 
label define label_xf1a04 31 "Institution left item blank", add 
label define label_xf1a04 32 "Do not know", add 
label define label_xf1a04 33 "Particular 1st prof field not applicable", add 
label define label_xf1a04 50 "Outlier value derived from reported data", add 
label define label_xf1a04 51 "Outlier value derived from imported data", add 
label define label_xf1a04 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a04 53 "Value not derived - data not usable", add 
label values xf1a04 label_xf1a04
label define label_xf1a05 10 "Reported" 
label define label_xf1a05 11 "Analyst corrected reported value", add 
label define label_xf1a05 12 "Data generated from other data values", add 
label define label_xf1a05 13 "Implied zero", add 
label define label_xf1a05 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a05 22 "Imputed using the Group Median procedure", add 
label define label_xf1a05 23 "Logical imputation", add 
label define label_xf1a05 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a05 30 "Not applicable", add 
label define label_xf1a05 31 "Institution left item blank", add 
label define label_xf1a05 32 "Do not know", add 
label define label_xf1a05 33 "Particular 1st prof field not applicable", add 
label define label_xf1a05 50 "Outlier value derived from reported data", add 
label define label_xf1a05 51 "Outlier value derived from imported data", add 
label define label_xf1a05 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a05 53 "Value not derived - data not usable", add 
label values xf1a05 label_xf1a05
label define label_xf1a06 10 "Reported" 
label define label_xf1a06 11 "Analyst corrected reported value", add 
label define label_xf1a06 12 "Data generated from other data values", add 
label define label_xf1a06 13 "Implied zero", add 
label define label_xf1a06 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a06 22 "Imputed using the Group Median procedure", add 
label define label_xf1a06 23 "Logical imputation", add 
label define label_xf1a06 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a06 30 "Not applicable", add 
label define label_xf1a06 31 "Institution left item blank", add 
label define label_xf1a06 32 "Do not know", add 
label define label_xf1a06 33 "Particular 1st prof field not applicable", add 
label define label_xf1a06 50 "Outlier value derived from reported data", add 
label define label_xf1a06 51 "Outlier value derived from imported data", add 
label define label_xf1a06 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a06 53 "Value not derived - data not usable", add 
label values xf1a06 label_xf1a06
label define label_xf1a07 10 "Reported" 
label define label_xf1a07 11 "Analyst corrected reported value", add 
label define label_xf1a07 12 "Data generated from other data values", add 
label define label_xf1a07 13 "Implied zero", add 
label define label_xf1a07 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a07 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a07 22 "Imputed using the Group Median procedure", add 
label define label_xf1a07 23 "Logical imputation", add 
label define label_xf1a07 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a07 30 "Not applicable", add 
label define label_xf1a07 31 "Institution left item blank", add 
label define label_xf1a07 32 "Do not know", add 
label define label_xf1a07 33 "Particular 1st prof field not applicable", add 
label define label_xf1a07 50 "Outlier value derived from reported data", add 
label define label_xf1a07 51 "Outlier value derived from imported data", add 
label define label_xf1a07 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a07 53 "Value not derived - data not usable", add 
label values xf1a07 label_xf1a07
label define label_xf1a08 10 "Reported" 
label define label_xf1a08 11 "Analyst corrected reported value", add 
label define label_xf1a08 12 "Data generated from other data values", add 
label define label_xf1a08 13 "Implied zero", add 
label define label_xf1a08 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a08 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a08 22 "Imputed using the Group Median procedure", add 
label define label_xf1a08 23 "Logical imputation", add 
label define label_xf1a08 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a08 30 "Not applicable", add 
label define label_xf1a08 31 "Institution left item blank", add 
label define label_xf1a08 32 "Do not know", add 
label define label_xf1a08 33 "Particular 1st prof field not applicable", add 
label define label_xf1a08 50 "Outlier value derived from reported data", add 
label define label_xf1a08 51 "Outlier value derived from imported data", add 
label define label_xf1a08 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a08 53 "Value not derived - data not usable", add 
label values xf1a08 label_xf1a08
label define label_xf1a09 10 "Reported" 
label define label_xf1a09 11 "Analyst corrected reported value", add 
label define label_xf1a09 12 "Data generated from other data values", add 
label define label_xf1a09 13 "Implied zero", add 
label define label_xf1a09 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a09 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a09 22 "Imputed using the Group Median procedure", add 
label define label_xf1a09 23 "Logical imputation", add 
label define label_xf1a09 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a09 30 "Not applicable", add 
label define label_xf1a09 31 "Institution left item blank", add 
label define label_xf1a09 32 "Do not know", add 
label define label_xf1a09 33 "Particular 1st prof field not applicable", add 
label define label_xf1a09 50 "Outlier value derived from reported data", add 
label define label_xf1a09 51 "Outlier value derived from imported data", add 
label define label_xf1a09 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a09 53 "Value not derived - data not usable", add 
label values xf1a09 label_xf1a09
label define label_xf1a10 10 "Reported" 
label define label_xf1a10 11 "Analyst corrected reported value", add 
label define label_xf1a10 12 "Data generated from other data values", add 
label define label_xf1a10 13 "Implied zero", add 
label define label_xf1a10 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a10 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a10 22 "Imputed using the Group Median procedure", add 
label define label_xf1a10 23 "Logical imputation", add 
label define label_xf1a10 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a10 30 "Not applicable", add 
label define label_xf1a10 31 "Institution left item blank", add 
label define label_xf1a10 32 "Do not know", add 
label define label_xf1a10 33 "Particular 1st prof field not applicable", add 
label define label_xf1a10 50 "Outlier value derived from reported data", add 
label define label_xf1a10 51 "Outlier value derived from imported data", add 
label define label_xf1a10 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a10 53 "Value not derived - data not usable", add 
label values xf1a10 label_xf1a10
label define label_xf1a11 10 "Reported" 
label define label_xf1a11 11 "Analyst corrected reported value", add 
label define label_xf1a11 12 "Data generated from other data values", add 
label define label_xf1a11 13 "Implied zero", add 
label define label_xf1a11 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a11 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a11 22 "Imputed using the Group Median procedure", add 
label define label_xf1a11 23 "Logical imputation", add 
label define label_xf1a11 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a11 30 "Not applicable", add 
label define label_xf1a11 31 "Institution left item blank", add 
label define label_xf1a11 32 "Do not know", add 
label define label_xf1a11 33 "Particular 1st prof field not applicable", add 
label define label_xf1a11 50 "Outlier value derived from reported data", add 
label define label_xf1a11 51 "Outlier value derived from imported data", add 
label define label_xf1a11 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a11 53 "Value not derived - data not usable", add 
label values xf1a11 label_xf1a11
label define label_xf1a12 10 "Reported" 
label define label_xf1a12 11 "Analyst corrected reported value", add 
label define label_xf1a12 12 "Data generated from other data values", add 
label define label_xf1a12 13 "Implied zero", add 
label define label_xf1a12 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a12 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a12 22 "Imputed using the Group Median procedure", add 
label define label_xf1a12 23 "Logical imputation", add 
label define label_xf1a12 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a12 30 "Not applicable", add 
label define label_xf1a12 31 "Institution left item blank", add 
label define label_xf1a12 32 "Do not know", add 
label define label_xf1a12 33 "Particular 1st prof field not applicable", add 
label define label_xf1a12 50 "Outlier value derived from reported data", add 
label define label_xf1a12 51 "Outlier value derived from imported data", add 
label define label_xf1a12 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a12 53 "Value not derived - data not usable", add 
label values xf1a12 label_xf1a12
label define label_xf1a13 10 "Reported" 
label define label_xf1a13 11 "Analyst corrected reported value", add 
label define label_xf1a13 12 "Data generated from other data values", add 
label define label_xf1a13 13 "Implied zero", add 
label define label_xf1a13 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a13 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a13 22 "Imputed using the Group Median procedure", add 
label define label_xf1a13 23 "Logical imputation", add 
label define label_xf1a13 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a13 30 "Not applicable", add 
label define label_xf1a13 31 "Institution left item blank", add 
label define label_xf1a13 32 "Do not know", add 
label define label_xf1a13 33 "Particular 1st prof field not applicable", add 
label define label_xf1a13 50 "Outlier value derived from reported data", add 
label define label_xf1a13 51 "Outlier value derived from imported data", add 
label define label_xf1a13 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a13 53 "Value not derived - data not usable", add 
label values xf1a13 label_xf1a13
label define label_xf1a14 10 "Reported" 
label define label_xf1a14 11 "Analyst corrected reported value", add 
label define label_xf1a14 12 "Data generated from other data values", add 
label define label_xf1a14 13 "Implied zero", add 
label define label_xf1a14 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a14 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a14 22 "Imputed using the Group Median procedure", add 
label define label_xf1a14 23 "Logical imputation", add 
label define label_xf1a14 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a14 30 "Not applicable", add 
label define label_xf1a14 31 "Institution left item blank", add 
label define label_xf1a14 32 "Do not know", add 
label define label_xf1a14 33 "Particular 1st prof field not applicable", add 
label define label_xf1a14 50 "Outlier value derived from reported data", add 
label define label_xf1a14 51 "Outlier value derived from imported data", add 
label define label_xf1a14 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a14 53 "Value not derived - data not usable", add 
label values xf1a14 label_xf1a14
label define label_xf1a15 10 "Reported" 
label define label_xf1a15 11 "Analyst corrected reported value", add 
label define label_xf1a15 12 "Data generated from other data values", add 
label define label_xf1a15 13 "Implied zero", add 
label define label_xf1a15 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a15 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a15 22 "Imputed using the Group Median procedure", add 
label define label_xf1a15 23 "Logical imputation", add 
label define label_xf1a15 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a15 30 "Not applicable", add 
label define label_xf1a15 31 "Institution left item blank", add 
label define label_xf1a15 32 "Do not know", add 
label define label_xf1a15 33 "Particular 1st prof field not applicable", add 
label define label_xf1a15 50 "Outlier value derived from reported data", add 
label define label_xf1a15 51 "Outlier value derived from imported data", add 
label define label_xf1a15 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a15 53 "Value not derived - data not usable", add 
label values xf1a15 label_xf1a15
label define label_xf1a16 10 "Reported" 
label define label_xf1a16 11 "Analyst corrected reported value", add 
label define label_xf1a16 12 "Data generated from other data values", add 
label define label_xf1a16 13 "Implied zero", add 
label define label_xf1a16 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a16 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a16 22 "Imputed using the Group Median procedure", add 
label define label_xf1a16 23 "Logical imputation", add 
label define label_xf1a16 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a16 30 "Not applicable", add 
label define label_xf1a16 31 "Institution left item blank", add 
label define label_xf1a16 32 "Do not know", add 
label define label_xf1a16 33 "Particular 1st prof field not applicable", add 
label define label_xf1a16 50 "Outlier value derived from reported data", add 
label define label_xf1a16 51 "Outlier value derived from imported data", add 
label define label_xf1a16 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a16 53 "Value not derived - data not usable", add 
label values xf1a16 label_xf1a16
label define label_xf1a17 10 "Reported" 
label define label_xf1a17 11 "Analyst corrected reported value", add 
label define label_xf1a17 12 "Data generated from other data values", add 
label define label_xf1a17 13 "Implied zero", add 
label define label_xf1a17 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a17 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a17 22 "Imputed using the Group Median procedure", add 
label define label_xf1a17 23 "Logical imputation", add 
label define label_xf1a17 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a17 30 "Not applicable", add 
label define label_xf1a17 31 "Institution left item blank", add 
label define label_xf1a17 32 "Do not know", add 
label define label_xf1a17 33 "Particular 1st prof field not applicable", add 
label define label_xf1a17 50 "Outlier value derived from reported data", add 
label define label_xf1a17 51 "Outlier value derived from imported data", add 
label define label_xf1a17 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a17 53 "Value not derived - data not usable", add 
label values xf1a17 label_xf1a17
label define label_xf1a18 10 "Reported" 
label define label_xf1a18 11 "Analyst corrected reported value", add 
label define label_xf1a18 12 "Data generated from other data values", add 
label define label_xf1a18 13 "Implied zero", add 
label define label_xf1a18 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a18 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a18 22 "Imputed using the Group Median procedure", add 
label define label_xf1a18 23 "Logical imputation", add 
label define label_xf1a18 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a18 30 "Not applicable", add 
label define label_xf1a18 31 "Institution left item blank", add 
label define label_xf1a18 32 "Do not know", add 
label define label_xf1a18 33 "Particular 1st prof field not applicable", add 
label define label_xf1a18 50 "Outlier value derived from reported data", add 
label define label_xf1a18 51 "Outlier value derived from imported data", add 
label define label_xf1a18 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a18 53 "Value not derived - data not usable", add 
label values xf1a18 label_xf1a18
label define label_xf1a211 10 "Reported" 
label define label_xf1a211 11 "Analyst corrected reported value", add 
label define label_xf1a211 12 "Data generated from other data values", add 
label define label_xf1a211 13 "Implied zero", add 
label define label_xf1a211 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a211 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a211 22 "Imputed using the Group Median procedure", add 
label define label_xf1a211 23 "Logical imputation", add 
label define label_xf1a211 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a211 30 "Not applicable", add 
label define label_xf1a211 31 "Institution left item blank", add 
label define label_xf1a211 32 "Do not know", add 
label define label_xf1a211 33 "Particular 1st prof field not applicable", add 
label define label_xf1a211 50 "Outlier value derived from reported data", add 
label define label_xf1a211 51 "Outlier value derived from imported data", add 
label define label_xf1a211 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a211 53 "Value not derived - data not usable", add 
label values xf1a211 label_xf1a211
label define label_xf1a212 10 "Reported" 
label define label_xf1a212 11 "Analyst corrected reported value", add 
label define label_xf1a212 12 "Data generated from other data values", add 
label define label_xf1a212 13 "Implied zero", add 
label define label_xf1a212 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a212 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a212 22 "Imputed using the Group Median procedure", add 
label define label_xf1a212 23 "Logical imputation", add 
label define label_xf1a212 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a212 30 "Not applicable", add 
label define label_xf1a212 31 "Institution left item blank", add 
label define label_xf1a212 32 "Do not know", add 
label define label_xf1a212 33 "Particular 1st prof field not applicable", add 
label define label_xf1a212 50 "Outlier value derived from reported data", add 
label define label_xf1a212 51 "Outlier value derived from imported data", add 
label define label_xf1a212 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a212 53 "Value not derived - data not usable", add 
label values xf1a212 label_xf1a212
label define label_xf1a213 10 "Reported" 
label define label_xf1a213 11 "Analyst corrected reported value", add 
label define label_xf1a213 12 "Data generated from other data values", add 
label define label_xf1a213 13 "Implied zero", add 
label define label_xf1a213 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a213 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a213 22 "Imputed using the Group Median procedure", add 
label define label_xf1a213 23 "Logical imputation", add 
label define label_xf1a213 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a213 30 "Not applicable", add 
label define label_xf1a213 31 "Institution left item blank", add 
label define label_xf1a213 32 "Do not know", add 
label define label_xf1a213 33 "Particular 1st prof field not applicable", add 
label define label_xf1a213 50 "Outlier value derived from reported data", add 
label define label_xf1a213 51 "Outlier value derived from imported data", add 
label define label_xf1a213 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a213 53 "Value not derived - data not usable", add 
label values xf1a213 label_xf1a213
label define label_xf1a214 10 "Reported" 
label define label_xf1a214 11 "Analyst corrected reported value", add 
label define label_xf1a214 12 "Data generated from other data values", add 
label define label_xf1a214 13 "Implied zero", add 
label define label_xf1a214 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a214 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a214 22 "Imputed using the Group Median procedure", add 
label define label_xf1a214 23 "Logical imputation", add 
label define label_xf1a214 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a214 30 "Not applicable", add 
label define label_xf1a214 31 "Institution left item blank", add 
label define label_xf1a214 32 "Do not know", add 
label define label_xf1a214 33 "Particular 1st prof field not applicable", add 
label define label_xf1a214 50 "Outlier value derived from reported data", add 
label define label_xf1a214 51 "Outlier value derived from imported data", add 
label define label_xf1a214 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a214 53 "Value not derived - data not usable", add 
label values xf1a214 label_xf1a214
label define label_xf1a221 10 "Reported" 
label define label_xf1a221 11 "Analyst corrected reported value", add 
label define label_xf1a221 12 "Data generated from other data values", add 
label define label_xf1a221 13 "Implied zero", add 
label define label_xf1a221 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a221 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a221 22 "Imputed using the Group Median procedure", add 
label define label_xf1a221 23 "Logical imputation", add 
label define label_xf1a221 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a221 30 "Not applicable", add 
label define label_xf1a221 31 "Institution left item blank", add 
label define label_xf1a221 32 "Do not know", add 
label define label_xf1a221 33 "Particular 1st prof field not applicable", add 
label define label_xf1a221 50 "Outlier value derived from reported data", add 
label define label_xf1a221 51 "Outlier value derived from imported data", add 
label define label_xf1a221 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a221 53 "Value not derived - data not usable", add 
label values xf1a221 label_xf1a221
label define label_xf1a222 10 "Reported" 
label define label_xf1a222 11 "Analyst corrected reported value", add 
label define label_xf1a222 12 "Data generated from other data values", add 
label define label_xf1a222 13 "Implied zero", add 
label define label_xf1a222 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a222 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a222 22 "Imputed using the Group Median procedure", add 
label define label_xf1a222 23 "Logical imputation", add 
label define label_xf1a222 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a222 30 "Not applicable", add 
label define label_xf1a222 31 "Institution left item blank", add 
label define label_xf1a222 32 "Do not know", add 
label define label_xf1a222 33 "Particular 1st prof field not applicable", add 
label define label_xf1a222 50 "Outlier value derived from reported data", add 
label define label_xf1a222 51 "Outlier value derived from imported data", add 
label define label_xf1a222 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a222 53 "Value not derived - data not usable", add 
label values xf1a222 label_xf1a222
label define label_xf1a223 10 "Reported" 
label define label_xf1a223 11 "Analyst corrected reported value", add 
label define label_xf1a223 12 "Data generated from other data values", add 
label define label_xf1a223 13 "Implied zero", add 
label define label_xf1a223 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a223 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a223 22 "Imputed using the Group Median procedure", add 
label define label_xf1a223 23 "Logical imputation", add 
label define label_xf1a223 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a223 30 "Not applicable", add 
label define label_xf1a223 31 "Institution left item blank", add 
label define label_xf1a223 32 "Do not know", add 
label define label_xf1a223 33 "Particular 1st prof field not applicable", add 
label define label_xf1a223 50 "Outlier value derived from reported data", add 
label define label_xf1a223 51 "Outlier value derived from imported data", add 
label define label_xf1a223 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a223 53 "Value not derived - data not usable", add 
label values xf1a223 label_xf1a223
label define label_xf1a224 10 "Reported" 
label define label_xf1a224 11 "Analyst corrected reported value", add 
label define label_xf1a224 12 "Data generated from other data values", add 
label define label_xf1a224 13 "Implied zero", add 
label define label_xf1a224 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a224 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a224 22 "Imputed using the Group Median procedure", add 
label define label_xf1a224 23 "Logical imputation", add 
label define label_xf1a224 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a224 30 "Not applicable", add 
label define label_xf1a224 31 "Institution left item blank", add 
label define label_xf1a224 32 "Do not know", add 
label define label_xf1a224 33 "Particular 1st prof field not applicable", add 
label define label_xf1a224 50 "Outlier value derived from reported data", add 
label define label_xf1a224 51 "Outlier value derived from imported data", add 
label define label_xf1a224 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a224 53 "Value not derived - data not usable", add 
label values xf1a224 label_xf1a224
label define label_xf1a231 10 "Reported" 
label define label_xf1a231 11 "Analyst corrected reported value", add 
label define label_xf1a231 12 "Data generated from other data values", add 
label define label_xf1a231 13 "Implied zero", add 
label define label_xf1a231 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a231 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a231 22 "Imputed using the Group Median procedure", add 
label define label_xf1a231 23 "Logical imputation", add 
label define label_xf1a231 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a231 30 "Not applicable", add 
label define label_xf1a231 31 "Institution left item blank", add 
label define label_xf1a231 32 "Do not know", add 
label define label_xf1a231 33 "Particular 1st prof field not applicable", add 
label define label_xf1a231 50 "Outlier value derived from reported data", add 
label define label_xf1a231 51 "Outlier value derived from imported data", add 
label define label_xf1a231 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a231 53 "Value not derived - data not usable", add 
label values xf1a231 label_xf1a231
label define label_xf1a232 10 "Reported" 
label define label_xf1a232 11 "Analyst corrected reported value", add 
label define label_xf1a232 12 "Data generated from other data values", add 
label define label_xf1a232 13 "Implied zero", add 
label define label_xf1a232 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a232 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a232 22 "Imputed using the Group Median procedure", add 
label define label_xf1a232 23 "Logical imputation", add 
label define label_xf1a232 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a232 30 "Not applicable", add 
label define label_xf1a232 31 "Institution left item blank", add 
label define label_xf1a232 32 "Do not know", add 
label define label_xf1a232 33 "Particular 1st prof field not applicable", add 
label define label_xf1a232 50 "Outlier value derived from reported data", add 
label define label_xf1a232 51 "Outlier value derived from imported data", add 
label define label_xf1a232 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a232 53 "Value not derived - data not usable", add 
label values xf1a232 label_xf1a232
label define label_xf1a233 10 "Reported" 
label define label_xf1a233 11 "Analyst corrected reported value", add 
label define label_xf1a233 12 "Data generated from other data values", add 
label define label_xf1a233 13 "Implied zero", add 
label define label_xf1a233 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a233 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a233 22 "Imputed using the Group Median procedure", add 
label define label_xf1a233 23 "Logical imputation", add 
label define label_xf1a233 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a233 30 "Not applicable", add 
label define label_xf1a233 31 "Institution left item blank", add 
label define label_xf1a233 32 "Do not know", add 
label define label_xf1a233 33 "Particular 1st prof field not applicable", add 
label define label_xf1a233 50 "Outlier value derived from reported data", add 
label define label_xf1a233 51 "Outlier value derived from imported data", add 
label define label_xf1a233 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a233 53 "Value not derived - data not usable", add 
label values xf1a233 label_xf1a233
label define label_xf1a234 10 "Reported" 
label define label_xf1a234 11 "Analyst corrected reported value", add 
label define label_xf1a234 12 "Data generated from other data values", add 
label define label_xf1a234 13 "Implied zero", add 
label define label_xf1a234 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a234 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a234 22 "Imputed using the Group Median procedure", add 
label define label_xf1a234 23 "Logical imputation", add 
label define label_xf1a234 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a234 30 "Not applicable", add 
label define label_xf1a234 31 "Institution left item blank", add 
label define label_xf1a234 32 "Do not know", add 
label define label_xf1a234 33 "Particular 1st prof field not applicable", add 
label define label_xf1a234 50 "Outlier value derived from reported data", add 
label define label_xf1a234 51 "Outlier value derived from imported data", add 
label define label_xf1a234 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a234 53 "Value not derived - data not usable", add 
label values xf1a234 label_xf1a234
label define label_xf1a241 10 "Reported" 
label define label_xf1a241 11 "Analyst corrected reported value", add 
label define label_xf1a241 12 "Data generated from other data values", add 
label define label_xf1a241 13 "Implied zero", add 
label define label_xf1a241 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a241 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a241 22 "Imputed using the Group Median procedure", add 
label define label_xf1a241 23 "Logical imputation", add 
label define label_xf1a241 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a241 30 "Not applicable", add 
label define label_xf1a241 31 "Institution left item blank", add 
label define label_xf1a241 32 "Do not know", add 
label define label_xf1a241 33 "Particular 1st prof field not applicable", add 
label define label_xf1a241 50 "Outlier value derived from reported data", add 
label define label_xf1a241 51 "Outlier value derived from imported data", add 
label define label_xf1a241 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a241 53 "Value not derived - data not usable", add 
label values xf1a241 label_xf1a241
label define label_xf1a242 10 "Reported" 
label define label_xf1a242 11 "Analyst corrected reported value", add 
label define label_xf1a242 12 "Data generated from other data values", add 
label define label_xf1a242 13 "Implied zero", add 
label define label_xf1a242 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a242 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a242 22 "Imputed using the Group Median procedure", add 
label define label_xf1a242 23 "Logical imputation", add 
label define label_xf1a242 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a242 30 "Not applicable", add 
label define label_xf1a242 31 "Institution left item blank", add 
label define label_xf1a242 32 "Do not know", add 
label define label_xf1a242 33 "Particular 1st prof field not applicable", add 
label define label_xf1a242 50 "Outlier value derived from reported data", add 
label define label_xf1a242 51 "Outlier value derived from imported data", add 
label define label_xf1a242 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a242 53 "Value not derived - data not usable", add 
label values xf1a242 label_xf1a242
label define label_xf1a243 10 "Reported" 
label define label_xf1a243 11 "Analyst corrected reported value", add 
label define label_xf1a243 12 "Data generated from other data values", add 
label define label_xf1a243 13 "Implied zero", add 
label define label_xf1a243 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a243 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a243 22 "Imputed using the Group Median procedure", add 
label define label_xf1a243 23 "Logical imputation", add 
label define label_xf1a243 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a243 30 "Not applicable", add 
label define label_xf1a243 31 "Institution left item blank", add 
label define label_xf1a243 32 "Do not know", add 
label define label_xf1a243 33 "Particular 1st prof field not applicable", add 
label define label_xf1a243 50 "Outlier value derived from reported data", add 
label define label_xf1a243 51 "Outlier value derived from imported data", add 
label define label_xf1a243 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a243 53 "Value not derived - data not usable", add 
label values xf1a243 label_xf1a243
label define label_xf1a244 10 "Reported" 
label define label_xf1a244 11 "Analyst corrected reported value", add 
label define label_xf1a244 12 "Data generated from other data values", add 
label define label_xf1a244 13 "Implied zero", add 
label define label_xf1a244 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a244 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a244 22 "Imputed using the Group Median procedure", add 
label define label_xf1a244 23 "Logical imputation", add 
label define label_xf1a244 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a244 30 "Not applicable", add 
label define label_xf1a244 31 "Institution left item blank", add 
label define label_xf1a244 32 "Do not know", add 
label define label_xf1a244 33 "Particular 1st prof field not applicable", add 
label define label_xf1a244 50 "Outlier value derived from reported data", add 
label define label_xf1a244 51 "Outlier value derived from imported data", add 
label define label_xf1a244 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a244 53 "Value not derived - data not usable", add 
label values xf1a244 label_xf1a244
label define label_xf1a251 10 "Reported" 
label define label_xf1a251 11 "Analyst corrected reported value", add 
label define label_xf1a251 12 "Data generated from other data values", add 
label define label_xf1a251 13 "Implied zero", add 
label define label_xf1a251 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a251 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a251 22 "Imputed using the Group Median procedure", add 
label define label_xf1a251 23 "Logical imputation", add 
label define label_xf1a251 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a251 30 "Not applicable", add 
label define label_xf1a251 31 "Institution left item blank", add 
label define label_xf1a251 32 "Do not know", add 
label define label_xf1a251 33 "Particular 1st prof field not applicable", add 
label define label_xf1a251 50 "Outlier value derived from reported data", add 
label define label_xf1a251 51 "Outlier value derived from imported data", add 
label define label_xf1a251 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a251 53 "Value not derived - data not usable", add 
label values xf1a251 label_xf1a251
label define label_xf1a252 10 "Reported" 
label define label_xf1a252 11 "Analyst corrected reported value", add 
label define label_xf1a252 12 "Data generated from other data values", add 
label define label_xf1a252 13 "Implied zero", add 
label define label_xf1a252 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a252 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a252 22 "Imputed using the Group Median procedure", add 
label define label_xf1a252 23 "Logical imputation", add 
label define label_xf1a252 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a252 30 "Not applicable", add 
label define label_xf1a252 31 "Institution left item blank", add 
label define label_xf1a252 32 "Do not know", add 
label define label_xf1a252 33 "Particular 1st prof field not applicable", add 
label define label_xf1a252 50 "Outlier value derived from reported data", add 
label define label_xf1a252 51 "Outlier value derived from imported data", add 
label define label_xf1a252 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a252 53 "Value not derived - data not usable", add 
label values xf1a252 label_xf1a252
label define label_xf1a253 10 "Reported" 
label define label_xf1a253 11 "Analyst corrected reported value", add 
label define label_xf1a253 12 "Data generated from other data values", add 
label define label_xf1a253 13 "Implied zero", add 
label define label_xf1a253 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a253 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a253 22 "Imputed using the Group Median procedure", add 
label define label_xf1a253 23 "Logical imputation", add 
label define label_xf1a253 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a253 30 "Not applicable", add 
label define label_xf1a253 31 "Institution left item blank", add 
label define label_xf1a253 32 "Do not know", add 
label define label_xf1a253 33 "Particular 1st prof field not applicable", add 
label define label_xf1a253 50 "Outlier value derived from reported data", add 
label define label_xf1a253 51 "Outlier value derived from imported data", add 
label define label_xf1a253 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a253 53 "Value not derived - data not usable", add 
label values xf1a253 label_xf1a253
label define label_xf1a254 10 "Reported" 
label define label_xf1a254 11 "Analyst corrected reported value", add 
label define label_xf1a254 12 "Data generated from other data values", add 
label define label_xf1a254 13 "Implied zero", add 
label define label_xf1a254 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a254 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a254 22 "Imputed using the Group Median procedure", add 
label define label_xf1a254 23 "Logical imputation", add 
label define label_xf1a254 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a254 30 "Not applicable", add 
label define label_xf1a254 31 "Institution left item blank", add 
label define label_xf1a254 32 "Do not know", add 
label define label_xf1a254 33 "Particular 1st prof field not applicable", add 
label define label_xf1a254 50 "Outlier value derived from reported data", add 
label define label_xf1a254 51 "Outlier value derived from imported data", add 
label define label_xf1a254 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a254 53 "Value not derived - data not usable", add 
label values xf1a254 label_xf1a254
label define label_xf1a261 10 "Reported" 
label define label_xf1a261 11 "Analyst corrected reported value", add 
label define label_xf1a261 12 "Data generated from other data values", add 
label define label_xf1a261 13 "Implied zero", add 
label define label_xf1a261 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a261 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a261 22 "Imputed using the Group Median procedure", add 
label define label_xf1a261 23 "Logical imputation", add 
label define label_xf1a261 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a261 30 "Not applicable", add 
label define label_xf1a261 31 "Institution left item blank", add 
label define label_xf1a261 32 "Do not know", add 
label define label_xf1a261 33 "Particular 1st prof field not applicable", add 
label define label_xf1a261 50 "Outlier value derived from reported data", add 
label define label_xf1a261 51 "Outlier value derived from imported data", add 
label define label_xf1a261 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a261 53 "Value not derived - data not usable", add 
label values xf1a261 label_xf1a261
label define label_xf1a262 10 "Reported" 
label define label_xf1a262 11 "Analyst corrected reported value", add 
label define label_xf1a262 12 "Data generated from other data values", add 
label define label_xf1a262 13 "Implied zero", add 
label define label_xf1a262 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a262 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a262 22 "Imputed using the Group Median procedure", add 
label define label_xf1a262 23 "Logical imputation", add 
label define label_xf1a262 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a262 30 "Not applicable", add 
label define label_xf1a262 31 "Institution left item blank", add 
label define label_xf1a262 32 "Do not know", add 
label define label_xf1a262 33 "Particular 1st prof field not applicable", add 
label define label_xf1a262 50 "Outlier value derived from reported data", add 
label define label_xf1a262 51 "Outlier value derived from imported data", add 
label define label_xf1a262 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a262 53 "Value not derived - data not usable", add 
label values xf1a262 label_xf1a262
label define label_xf1a263 10 "Reported" 
label define label_xf1a263 11 "Analyst corrected reported value", add 
label define label_xf1a263 12 "Data generated from other data values", add 
label define label_xf1a263 13 "Implied zero", add 
label define label_xf1a263 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a263 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a263 22 "Imputed using the Group Median procedure", add 
label define label_xf1a263 23 "Logical imputation", add 
label define label_xf1a263 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a263 30 "Not applicable", add 
label define label_xf1a263 31 "Institution left item blank", add 
label define label_xf1a263 32 "Do not know", add 
label define label_xf1a263 33 "Particular 1st prof field not applicable", add 
label define label_xf1a263 50 "Outlier value derived from reported data", add 
label define label_xf1a263 51 "Outlier value derived from imported data", add 
label define label_xf1a263 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a263 53 "Value not derived - data not usable", add 
label values xf1a263 label_xf1a263
label define label_xf1a264 10 "Reported" 
label define label_xf1a264 11 "Analyst corrected reported value", add 
label define label_xf1a264 12 "Data generated from other data values", add 
label define label_xf1a264 13 "Implied zero", add 
label define label_xf1a264 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a264 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a264 22 "Imputed using the Group Median procedure", add 
label define label_xf1a264 23 "Logical imputation", add 
label define label_xf1a264 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a264 30 "Not applicable", add 
label define label_xf1a264 31 "Institution left item blank", add 
label define label_xf1a264 32 "Do not know", add 
label define label_xf1a264 33 "Particular 1st prof field not applicable", add 
label define label_xf1a264 50 "Outlier value derived from reported data", add 
label define label_xf1a264 51 "Outlier value derived from imported data", add 
label define label_xf1a264 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a264 53 "Value not derived - data not usable", add 
label values xf1a264 label_xf1a264
label define label_xf1a271 10 "Reported" 
label define label_xf1a271 11 "Analyst corrected reported value", add 
label define label_xf1a271 12 "Data generated from other data values", add 
label define label_xf1a271 13 "Implied zero", add 
label define label_xf1a271 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a271 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a271 22 "Imputed using the Group Median procedure", add 
label define label_xf1a271 23 "Logical imputation", add 
label define label_xf1a271 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a271 30 "Not applicable", add 
label define label_xf1a271 31 "Institution left item blank", add 
label define label_xf1a271 32 "Do not know", add 
label define label_xf1a271 33 "Particular 1st prof field not applicable", add 
label define label_xf1a271 50 "Outlier value derived from reported data", add 
label define label_xf1a271 51 "Outlier value derived from imported data", add 
label define label_xf1a271 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a271 53 "Value not derived - data not usable", add 
label values xf1a271 label_xf1a271
label define label_xf1a272 10 "Reported" 
label define label_xf1a272 11 "Analyst corrected reported value", add 
label define label_xf1a272 12 "Data generated from other data values", add 
label define label_xf1a272 13 "Implied zero", add 
label define label_xf1a272 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a272 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a272 22 "Imputed using the Group Median procedure", add 
label define label_xf1a272 23 "Logical imputation", add 
label define label_xf1a272 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a272 30 "Not applicable", add 
label define label_xf1a272 31 "Institution left item blank", add 
label define label_xf1a272 32 "Do not know", add 
label define label_xf1a272 33 "Particular 1st prof field not applicable", add 
label define label_xf1a272 50 "Outlier value derived from reported data", add 
label define label_xf1a272 51 "Outlier value derived from imported data", add 
label define label_xf1a272 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a272 53 "Value not derived - data not usable", add 
label values xf1a272 label_xf1a272
label define label_xf1a273 10 "Reported" 
label define label_xf1a273 11 "Analyst corrected reported value", add 
label define label_xf1a273 12 "Data generated from other data values", add 
label define label_xf1a273 13 "Implied zero", add 
label define label_xf1a273 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a273 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a273 22 "Imputed using the Group Median procedure", add 
label define label_xf1a273 23 "Logical imputation", add 
label define label_xf1a273 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a273 30 "Not applicable", add 
label define label_xf1a273 31 "Institution left item blank", add 
label define label_xf1a273 32 "Do not know", add 
label define label_xf1a273 33 "Particular 1st prof field not applicable", add 
label define label_xf1a273 50 "Outlier value derived from reported data", add 
label define label_xf1a273 51 "Outlier value derived from imported data", add 
label define label_xf1a273 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a273 53 "Value not derived - data not usable", add 
label values xf1a273 label_xf1a273
label define label_xf1a274 10 "Reported" 
label define label_xf1a274 11 "Analyst corrected reported value", add 
label define label_xf1a274 12 "Data generated from other data values", add 
label define label_xf1a274 13 "Implied zero", add 
label define label_xf1a274 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a274 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a274 22 "Imputed using the Group Median procedure", add 
label define label_xf1a274 23 "Logical imputation", add 
label define label_xf1a274 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a274 30 "Not applicable", add 
label define label_xf1a274 31 "Institution left item blank", add 
label define label_xf1a274 32 "Do not know", add 
label define label_xf1a274 33 "Particular 1st prof field not applicable", add 
label define label_xf1a274 50 "Outlier value derived from reported data", add 
label define label_xf1a274 51 "Outlier value derived from imported data", add 
label define label_xf1a274 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a274 53 "Value not derived - data not usable", add 
label values xf1a274 label_xf1a274
label define label_xf1a281 10 "Reported" 
label define label_xf1a281 11 "Analyst corrected reported value", add 
label define label_xf1a281 12 "Data generated from other data values", add 
label define label_xf1a281 13 "Implied zero", add 
label define label_xf1a281 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a281 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a281 22 "Imputed using the Group Median procedure", add 
label define label_xf1a281 23 "Logical imputation", add 
label define label_xf1a281 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a281 30 "Not applicable", add 
label define label_xf1a281 31 "Institution left item blank", add 
label define label_xf1a281 32 "Do not know", add 
label define label_xf1a281 33 "Particular 1st prof field not applicable", add 
label define label_xf1a281 50 "Outlier value derived from reported data", add 
label define label_xf1a281 51 "Outlier value derived from imported data", add 
label define label_xf1a281 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a281 53 "Value not derived - data not usable", add 
label values xf1a281 label_xf1a281
label define label_xf1a282 10 "Reported" 
label define label_xf1a282 11 "Analyst corrected reported value", add 
label define label_xf1a282 12 "Data generated from other data values", add 
label define label_xf1a282 13 "Implied zero", add 
label define label_xf1a282 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a282 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a282 22 "Imputed using the Group Median procedure", add 
label define label_xf1a282 23 "Logical imputation", add 
label define label_xf1a282 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a282 30 "Not applicable", add 
label define label_xf1a282 31 "Institution left item blank", add 
label define label_xf1a282 32 "Do not know", add 
label define label_xf1a282 33 "Particular 1st prof field not applicable", add 
label define label_xf1a282 50 "Outlier value derived from reported data", add 
label define label_xf1a282 51 "Outlier value derived from imported data", add 
label define label_xf1a282 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a282 53 "Value not derived - data not usable", add 
label values xf1a282 label_xf1a282
label define label_xf1a283 10 "Reported" 
label define label_xf1a283 11 "Analyst corrected reported value", add 
label define label_xf1a283 12 "Data generated from other data values", add 
label define label_xf1a283 13 "Implied zero", add 
label define label_xf1a283 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a283 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a283 22 "Imputed using the Group Median procedure", add 
label define label_xf1a283 23 "Logical imputation", add 
label define label_xf1a283 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a283 30 "Not applicable", add 
label define label_xf1a283 31 "Institution left item blank", add 
label define label_xf1a283 32 "Do not know", add 
label define label_xf1a283 33 "Particular 1st prof field not applicable", add 
label define label_xf1a283 50 "Outlier value derived from reported data", add 
label define label_xf1a283 51 "Outlier value derived from imported data", add 
label define label_xf1a283 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a283 53 "Value not derived - data not usable", add 
label values xf1a283 label_xf1a283
label define label_xf1a284 10 "Reported" 
label define label_xf1a284 11 "Analyst corrected reported value", add 
label define label_xf1a284 12 "Data generated from other data values", add 
label define label_xf1a284 13 "Implied zero", add 
label define label_xf1a284 20 "Imputed using Carry Forward procedure", add 
label define label_xf1a284 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1a284 22 "Imputed using the Group Median procedure", add 
label define label_xf1a284 23 "Logical imputation", add 
label define label_xf1a284 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1a284 30 "Not applicable", add 
label define label_xf1a284 31 "Institution left item blank", add 
label define label_xf1a284 32 "Do not know", add 
label define label_xf1a284 33 "Particular 1st prof field not applicable", add 
label define label_xf1a284 50 "Outlier value derived from reported data", add 
label define label_xf1a284 51 "Outlier value derived from imported data", add 
label define label_xf1a284 52 "Value not derived - parent/child differs across components", add 
label define label_xf1a284 53 "Value not derived - data not usable", add 
label values xf1a284 label_xf1a284
label define label_xf1b01 10 "Reported" 
label define label_xf1b01 11 "Analyst corrected reported value", add 
label define label_xf1b01 12 "Data generated from other data values", add 
label define label_xf1b01 13 "Implied zero", add 
label define label_xf1b01 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b01 22 "Imputed using the Group Median procedure", add 
label define label_xf1b01 23 "Logical imputation", add 
label define label_xf1b01 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b01 30 "Not applicable", add 
label define label_xf1b01 31 "Institution left item blank", add 
label define label_xf1b01 32 "Do not know", add 
label define label_xf1b01 33 "Particular 1st prof field not applicable", add 
label define label_xf1b01 50 "Outlier value derived from reported data", add 
label define label_xf1b01 51 "Outlier value derived from imported data", add 
label define label_xf1b01 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b01 53 "Value not derived - data not usable", add 
label values xf1b01 label_xf1b01
label define label_xf1b02 10 "Reported" 
label define label_xf1b02 11 "Analyst corrected reported value", add 
label define label_xf1b02 12 "Data generated from other data values", add 
label define label_xf1b02 13 "Implied zero", add 
label define label_xf1b02 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b02 22 "Imputed using the Group Median procedure", add 
label define label_xf1b02 23 "Logical imputation", add 
label define label_xf1b02 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b02 30 "Not applicable", add 
label define label_xf1b02 31 "Institution left item blank", add 
label define label_xf1b02 32 "Do not know", add 
label define label_xf1b02 33 "Particular 1st prof field not applicable", add 
label define label_xf1b02 50 "Outlier value derived from reported data", add 
label define label_xf1b02 51 "Outlier value derived from imported data", add 
label define label_xf1b02 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b02 53 "Value not derived - data not usable", add 
label values xf1b02 label_xf1b02
label define label_xf1b03 10 "Reported" 
label define label_xf1b03 11 "Analyst corrected reported value", add 
label define label_xf1b03 12 "Data generated from other data values", add 
label define label_xf1b03 13 "Implied zero", add 
label define label_xf1b03 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b03 22 "Imputed using the Group Median procedure", add 
label define label_xf1b03 23 "Logical imputation", add 
label define label_xf1b03 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b03 30 "Not applicable", add 
label define label_xf1b03 31 "Institution left item blank", add 
label define label_xf1b03 32 "Do not know", add 
label define label_xf1b03 33 "Particular 1st prof field not applicable", add 
label define label_xf1b03 50 "Outlier value derived from reported data", add 
label define label_xf1b03 51 "Outlier value derived from imported data", add 
label define label_xf1b03 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b03 53 "Value not derived - data not usable", add 
label values xf1b03 label_xf1b03
label define label_xf1b04 10 "Reported" 
label define label_xf1b04 11 "Analyst corrected reported value", add 
label define label_xf1b04 12 "Data generated from other data values", add 
label define label_xf1b04 13 "Implied zero", add 
label define label_xf1b04 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b04 22 "Imputed using the Group Median procedure", add 
label define label_xf1b04 23 "Logical imputation", add 
label define label_xf1b04 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b04 30 "Not applicable", add 
label define label_xf1b04 31 "Institution left item blank", add 
label define label_xf1b04 32 "Do not know", add 
label define label_xf1b04 33 "Particular 1st prof field not applicable", add 
label define label_xf1b04 50 "Outlier value derived from reported data", add 
label define label_xf1b04 51 "Outlier value derived from imported data", add 
label define label_xf1b04 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b04 53 "Value not derived - data not usable", add 
label values xf1b04 label_xf1b04
label define label_xf1b05 10 "Reported" 
label define label_xf1b05 11 "Analyst corrected reported value", add 
label define label_xf1b05 12 "Data generated from other data values", add 
label define label_xf1b05 13 "Implied zero", add 
label define label_xf1b05 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b05 22 "Imputed using the Group Median procedure", add 
label define label_xf1b05 23 "Logical imputation", add 
label define label_xf1b05 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b05 30 "Not applicable", add 
label define label_xf1b05 31 "Institution left item blank", add 
label define label_xf1b05 32 "Do not know", add 
label define label_xf1b05 33 "Particular 1st prof field not applicable", add 
label define label_xf1b05 50 "Outlier value derived from reported data", add 
label define label_xf1b05 51 "Outlier value derived from imported data", add 
label define label_xf1b05 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b05 53 "Value not derived - data not usable", add 
label values xf1b05 label_xf1b05
label define label_xf1b06 10 "Reported" 
label define label_xf1b06 11 "Analyst corrected reported value", add 
label define label_xf1b06 12 "Data generated from other data values", add 
label define label_xf1b06 13 "Implied zero", add 
label define label_xf1b06 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b06 22 "Imputed using the Group Median procedure", add 
label define label_xf1b06 23 "Logical imputation", add 
label define label_xf1b06 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b06 30 "Not applicable", add 
label define label_xf1b06 31 "Institution left item blank", add 
label define label_xf1b06 32 "Do not know", add 
label define label_xf1b06 33 "Particular 1st prof field not applicable", add 
label define label_xf1b06 50 "Outlier value derived from reported data", add 
label define label_xf1b06 51 "Outlier value derived from imported data", add 
label define label_xf1b06 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b06 53 "Value not derived - data not usable", add 
label values xf1b06 label_xf1b06
label define label_xf1b07 10 "Reported" 
label define label_xf1b07 11 "Analyst corrected reported value", add 
label define label_xf1b07 12 "Data generated from other data values", add 
label define label_xf1b07 13 "Implied zero", add 
label define label_xf1b07 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b07 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b07 22 "Imputed using the Group Median procedure", add 
label define label_xf1b07 23 "Logical imputation", add 
label define label_xf1b07 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b07 30 "Not applicable", add 
label define label_xf1b07 31 "Institution left item blank", add 
label define label_xf1b07 32 "Do not know", add 
label define label_xf1b07 33 "Particular 1st prof field not applicable", add 
label define label_xf1b07 50 "Outlier value derived from reported data", add 
label define label_xf1b07 51 "Outlier value derived from imported data", add 
label define label_xf1b07 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b07 53 "Value not derived - data not usable", add 
label values xf1b07 label_xf1b07
label define label_xf1b08 10 "Reported" 
label define label_xf1b08 11 "Analyst corrected reported value", add 
label define label_xf1b08 12 "Data generated from other data values", add 
label define label_xf1b08 13 "Implied zero", add 
label define label_xf1b08 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b08 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b08 22 "Imputed using the Group Median procedure", add 
label define label_xf1b08 23 "Logical imputation", add 
label define label_xf1b08 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b08 30 "Not applicable", add 
label define label_xf1b08 31 "Institution left item blank", add 
label define label_xf1b08 32 "Do not know", add 
label define label_xf1b08 33 "Particular 1st prof field not applicable", add 
label define label_xf1b08 50 "Outlier value derived from reported data", add 
label define label_xf1b08 51 "Outlier value derived from imported data", add 
label define label_xf1b08 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b08 53 "Value not derived - data not usable", add 
label values xf1b08 label_xf1b08
label define label_xf1b09 10 "Reported" 
label define label_xf1b09 11 "Analyst corrected reported value", add 
label define label_xf1b09 12 "Data generated from other data values", add 
label define label_xf1b09 13 "Implied zero", add 
label define label_xf1b09 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b09 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b09 22 "Imputed using the Group Median procedure", add 
label define label_xf1b09 23 "Logical imputation", add 
label define label_xf1b09 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b09 30 "Not applicable", add 
label define label_xf1b09 31 "Institution left item blank", add 
label define label_xf1b09 32 "Do not know", add 
label define label_xf1b09 33 "Particular 1st prof field not applicable", add 
label define label_xf1b09 50 "Outlier value derived from reported data", add 
label define label_xf1b09 51 "Outlier value derived from imported data", add 
label define label_xf1b09 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b09 53 "Value not derived - data not usable", add 
label values xf1b09 label_xf1b09
label define label_xf1b10 10 "Reported" 
label define label_xf1b10 11 "Analyst corrected reported value", add 
label define label_xf1b10 12 "Data generated from other data values", add 
label define label_xf1b10 13 "Implied zero", add 
label define label_xf1b10 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b10 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b10 22 "Imputed using the Group Median procedure", add 
label define label_xf1b10 23 "Logical imputation", add 
label define label_xf1b10 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b10 30 "Not applicable", add 
label define label_xf1b10 31 "Institution left item blank", add 
label define label_xf1b10 32 "Do not know", add 
label define label_xf1b10 33 "Particular 1st prof field not applicable", add 
label define label_xf1b10 50 "Outlier value derived from reported data", add 
label define label_xf1b10 51 "Outlier value derived from imported data", add 
label define label_xf1b10 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b10 53 "Value not derived - data not usable", add 
label values xf1b10 label_xf1b10
label define label_xf1b11 10 "Reported" 
label define label_xf1b11 11 "Analyst corrected reported value", add 
label define label_xf1b11 12 "Data generated from other data values", add 
label define label_xf1b11 13 "Implied zero", add 
label define label_xf1b11 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b11 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b11 22 "Imputed using the Group Median procedure", add 
label define label_xf1b11 23 "Logical imputation", add 
label define label_xf1b11 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b11 30 "Not applicable", add 
label define label_xf1b11 31 "Institution left item blank", add 
label define label_xf1b11 32 "Do not know", add 
label define label_xf1b11 33 "Particular 1st prof field not applicable", add 
label define label_xf1b11 50 "Outlier value derived from reported data", add 
label define label_xf1b11 51 "Outlier value derived from imported data", add 
label define label_xf1b11 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b11 53 "Value not derived - data not usable", add 
label values xf1b11 label_xf1b11
label define label_xf1b12 10 "Reported" 
label define label_xf1b12 11 "Analyst corrected reported value", add 
label define label_xf1b12 12 "Data generated from other data values", add 
label define label_xf1b12 13 "Implied zero", add 
label define label_xf1b12 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b12 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b12 22 "Imputed using the Group Median procedure", add 
label define label_xf1b12 23 "Logical imputation", add 
label define label_xf1b12 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b12 30 "Not applicable", add 
label define label_xf1b12 31 "Institution left item blank", add 
label define label_xf1b12 32 "Do not know", add 
label define label_xf1b12 33 "Particular 1st prof field not applicable", add 
label define label_xf1b12 50 "Outlier value derived from reported data", add 
label define label_xf1b12 51 "Outlier value derived from imported data", add 
label define label_xf1b12 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b12 53 "Value not derived - data not usable", add 
label values xf1b12 label_xf1b12
label define label_xf1b13 10 "Reported" 
label define label_xf1b13 11 "Analyst corrected reported value", add 
label define label_xf1b13 12 "Data generated from other data values", add 
label define label_xf1b13 13 "Implied zero", add 
label define label_xf1b13 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b13 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b13 22 "Imputed using the Group Median procedure", add 
label define label_xf1b13 23 "Logical imputation", add 
label define label_xf1b13 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b13 30 "Not applicable", add 
label define label_xf1b13 31 "Institution left item blank", add 
label define label_xf1b13 32 "Do not know", add 
label define label_xf1b13 33 "Particular 1st prof field not applicable", add 
label define label_xf1b13 50 "Outlier value derived from reported data", add 
label define label_xf1b13 51 "Outlier value derived from imported data", add 
label define label_xf1b13 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b13 53 "Value not derived - data not usable", add 
label values xf1b13 label_xf1b13
label define label_xf1b14 10 "Reported" 
label define label_xf1b14 11 "Analyst corrected reported value", add 
label define label_xf1b14 12 "Data generated from other data values", add 
label define label_xf1b14 13 "Implied zero", add 
label define label_xf1b14 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b14 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b14 22 "Imputed using the Group Median procedure", add 
label define label_xf1b14 23 "Logical imputation", add 
label define label_xf1b14 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b14 30 "Not applicable", add 
label define label_xf1b14 31 "Institution left item blank", add 
label define label_xf1b14 32 "Do not know", add 
label define label_xf1b14 33 "Particular 1st prof field not applicable", add 
label define label_xf1b14 50 "Outlier value derived from reported data", add 
label define label_xf1b14 51 "Outlier value derived from imported data", add 
label define label_xf1b14 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b14 53 "Value not derived - data not usable", add 
label values xf1b14 label_xf1b14
label define label_xf1b15 10 "Reported" 
label define label_xf1b15 11 "Analyst corrected reported value", add 
label define label_xf1b15 12 "Data generated from other data values", add 
label define label_xf1b15 13 "Implied zero", add 
label define label_xf1b15 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b15 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b15 22 "Imputed using the Group Median procedure", add 
label define label_xf1b15 23 "Logical imputation", add 
label define label_xf1b15 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b15 30 "Not applicable", add 
label define label_xf1b15 31 "Institution left item blank", add 
label define label_xf1b15 32 "Do not know", add 
label define label_xf1b15 33 "Particular 1st prof field not applicable", add 
label define label_xf1b15 50 "Outlier value derived from reported data", add 
label define label_xf1b15 51 "Outlier value derived from imported data", add 
label define label_xf1b15 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b15 53 "Value not derived - data not usable", add 
label values xf1b15 label_xf1b15
label define label_xf1b16 10 "Reported" 
label define label_xf1b16 11 "Analyst corrected reported value", add 
label define label_xf1b16 12 "Data generated from other data values", add 
label define label_xf1b16 13 "Implied zero", add 
label define label_xf1b16 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b16 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b16 22 "Imputed using the Group Median procedure", add 
label define label_xf1b16 23 "Logical imputation", add 
label define label_xf1b16 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b16 30 "Not applicable", add 
label define label_xf1b16 31 "Institution left item blank", add 
label define label_xf1b16 32 "Do not know", add 
label define label_xf1b16 33 "Particular 1st prof field not applicable", add 
label define label_xf1b16 50 "Outlier value derived from reported data", add 
label define label_xf1b16 51 "Outlier value derived from imported data", add 
label define label_xf1b16 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b16 53 "Value not derived - data not usable", add 
label values xf1b16 label_xf1b16
label define label_xf1b17 10 "Reported" 
label define label_xf1b17 11 "Analyst corrected reported value", add 
label define label_xf1b17 12 "Data generated from other data values", add 
label define label_xf1b17 13 "Implied zero", add 
label define label_xf1b17 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b17 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b17 22 "Imputed using the Group Median procedure", add 
label define label_xf1b17 23 "Logical imputation", add 
label define label_xf1b17 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b17 30 "Not applicable", add 
label define label_xf1b17 31 "Institution left item blank", add 
label define label_xf1b17 32 "Do not know", add 
label define label_xf1b17 33 "Particular 1st prof field not applicable", add 
label define label_xf1b17 50 "Outlier value derived from reported data", add 
label define label_xf1b17 51 "Outlier value derived from imported data", add 
label define label_xf1b17 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b17 53 "Value not derived - data not usable", add 
label values xf1b17 label_xf1b17
label define label_xf1b18 10 "Reported" 
label define label_xf1b18 11 "Analyst corrected reported value", add 
label define label_xf1b18 12 "Data generated from other data values", add 
label define label_xf1b18 13 "Implied zero", add 
label define label_xf1b18 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b18 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b18 22 "Imputed using the Group Median procedure", add 
label define label_xf1b18 23 "Logical imputation", add 
label define label_xf1b18 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b18 30 "Not applicable", add 
label define label_xf1b18 31 "Institution left item blank", add 
label define label_xf1b18 32 "Do not know", add 
label define label_xf1b18 33 "Particular 1st prof field not applicable", add 
label define label_xf1b18 50 "Outlier value derived from reported data", add 
label define label_xf1b18 51 "Outlier value derived from imported data", add 
label define label_xf1b18 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b18 53 "Value not derived - data not usable", add 
label values xf1b18 label_xf1b18
label define label_xf1b19 10 "Reported" 
label define label_xf1b19 11 "Analyst corrected reported value", add 
label define label_xf1b19 12 "Data generated from other data values", add 
label define label_xf1b19 13 "Implied zero", add 
label define label_xf1b19 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b19 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b19 22 "Imputed using the Group Median procedure", add 
label define label_xf1b19 23 "Logical imputation", add 
label define label_xf1b19 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b19 30 "Not applicable", add 
label define label_xf1b19 31 "Institution left item blank", add 
label define label_xf1b19 32 "Do not know", add 
label define label_xf1b19 33 "Particular 1st prof field not applicable", add 
label define label_xf1b19 50 "Outlier value derived from reported data", add 
label define label_xf1b19 51 "Outlier value derived from imported data", add 
label define label_xf1b19 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b19 53 "Value not derived - data not usable", add 
label values xf1b19 label_xf1b19
label define label_xf1b20 10 "Reported" 
label define label_xf1b20 11 "Analyst corrected reported value", add 
label define label_xf1b20 12 "Data generated from other data values", add 
label define label_xf1b20 13 "Implied zero", add 
label define label_xf1b20 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b20 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b20 22 "Imputed using the Group Median procedure", add 
label define label_xf1b20 23 "Logical imputation", add 
label define label_xf1b20 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b20 30 "Not applicable", add 
label define label_xf1b20 31 "Institution left item blank", add 
label define label_xf1b20 32 "Do not know", add 
label define label_xf1b20 33 "Particular 1st prof field not applicable", add 
label define label_xf1b20 50 "Outlier value derived from reported data", add 
label define label_xf1b20 51 "Outlier value derived from imported data", add 
label define label_xf1b20 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b20 53 "Value not derived - data not usable", add 
label values xf1b20 label_xf1b20
label define label_xf1b21 10 "Reported" 
label define label_xf1b21 11 "Analyst corrected reported value", add 
label define label_xf1b21 12 "Data generated from other data values", add 
label define label_xf1b21 13 "Implied zero", add 
label define label_xf1b21 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b21 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b21 22 "Imputed using the Group Median procedure", add 
label define label_xf1b21 23 "Logical imputation", add 
label define label_xf1b21 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b21 30 "Not applicable", add 
label define label_xf1b21 31 "Institution left item blank", add 
label define label_xf1b21 32 "Do not know", add 
label define label_xf1b21 33 "Particular 1st prof field not applicable", add 
label define label_xf1b21 50 "Outlier value derived from reported data", add 
label define label_xf1b21 51 "Outlier value derived from imported data", add 
label define label_xf1b21 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b21 53 "Value not derived - data not usable", add 
label values xf1b21 label_xf1b21
label define label_xf1b22 10 "Reported" 
label define label_xf1b22 11 "Analyst corrected reported value", add 
label define label_xf1b22 12 "Data generated from other data values", add 
label define label_xf1b22 13 "Implied zero", add 
label define label_xf1b22 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b22 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b22 22 "Imputed using the Group Median procedure", add 
label define label_xf1b22 23 "Logical imputation", add 
label define label_xf1b22 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b22 30 "Not applicable", add 
label define label_xf1b22 31 "Institution left item blank", add 
label define label_xf1b22 32 "Do not know", add 
label define label_xf1b22 33 "Particular 1st prof field not applicable", add 
label define label_xf1b22 50 "Outlier value derived from reported data", add 
label define label_xf1b22 51 "Outlier value derived from imported data", add 
label define label_xf1b22 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b22 53 "Value not derived - data not usable", add 
label values xf1b22 label_xf1b22
label define label_xf1b23 10 "Reported" 
label define label_xf1b23 11 "Analyst corrected reported value", add 
label define label_xf1b23 12 "Data generated from other data values", add 
label define label_xf1b23 13 "Implied zero", add 
label define label_xf1b23 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b23 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b23 22 "Imputed using the Group Median procedure", add 
label define label_xf1b23 23 "Logical imputation", add 
label define label_xf1b23 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b23 30 "Not applicable", add 
label define label_xf1b23 31 "Institution left item blank", add 
label define label_xf1b23 32 "Do not know", add 
label define label_xf1b23 33 "Particular 1st prof field not applicable", add 
label define label_xf1b23 50 "Outlier value derived from reported data", add 
label define label_xf1b23 51 "Outlier value derived from imported data", add 
label define label_xf1b23 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b23 53 "Value not derived - data not usable", add 
label values xf1b23 label_xf1b23
label define label_xf1b24 10 "Reported" 
label define label_xf1b24 11 "Analyst corrected reported value", add 
label define label_xf1b24 12 "Data generated from other data values", add 
label define label_xf1b24 13 "Implied zero", add 
label define label_xf1b24 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b24 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b24 22 "Imputed using the Group Median procedure", add 
label define label_xf1b24 23 "Logical imputation", add 
label define label_xf1b24 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b24 30 "Not applicable", add 
label define label_xf1b24 31 "Institution left item blank", add 
label define label_xf1b24 32 "Do not know", add 
label define label_xf1b24 33 "Particular 1st prof field not applicable", add 
label define label_xf1b24 50 "Outlier value derived from reported data", add 
label define label_xf1b24 51 "Outlier value derived from imported data", add 
label define label_xf1b24 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b24 53 "Value not derived - data not usable", add 
label values xf1b24 label_xf1b24
label define label_xf1b25 10 "Reported" 
label define label_xf1b25 11 "Analyst corrected reported value", add 
label define label_xf1b25 12 "Data generated from other data values", add 
label define label_xf1b25 13 "Implied zero", add 
label define label_xf1b25 20 "Imputed using Carry Forward procedure", add 
label define label_xf1b25 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1b25 22 "Imputed using the Group Median procedure", add 
label define label_xf1b25 23 "Logical imputation", add 
label define label_xf1b25 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1b25 30 "Not applicable", add 
label define label_xf1b25 31 "Institution left item blank", add 
label define label_xf1b25 32 "Do not know", add 
label define label_xf1b25 33 "Particular 1st prof field not applicable", add 
label define label_xf1b25 50 "Outlier value derived from reported data", add 
label define label_xf1b25 51 "Outlier value derived from imported data", add 
label define label_xf1b25 52 "Value not derived - parent/child differs across components", add 
label define label_xf1b25 53 "Value not derived - data not usable", add 
label values xf1b25 label_xf1b25
label define label_xf1c011 10 "Reported" 
label define label_xf1c011 11 "Analyst corrected reported value", add 
label define label_xf1c011 12 "Data generated from other data values", add 
label define label_xf1c011 13 "Implied zero", add 
label define label_xf1c011 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c011 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c011 22 "Imputed using the Group Median procedure", add 
label define label_xf1c011 23 "Logical imputation", add 
label define label_xf1c011 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c011 30 "Not applicable", add 
label define label_xf1c011 31 "Institution left item blank", add 
label define label_xf1c011 32 "Do not know", add 
label define label_xf1c011 33 "Particular 1st prof field not applicable", add 
label define label_xf1c011 50 "Outlier value derived from reported data", add 
label define label_xf1c011 51 "Outlier value derived from imported data", add 
label define label_xf1c011 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c011 53 "Value not derived - data not usable", add 
label values xf1c011 label_xf1c011
label define label_xf1c012 10 "Reported" 
label define label_xf1c012 11 "Analyst corrected reported value", add 
label define label_xf1c012 12 "Data generated from other data values", add 
label define label_xf1c012 13 "Implied zero", add 
label define label_xf1c012 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c012 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c012 22 "Imputed using the Group Median procedure", add 
label define label_xf1c012 23 "Logical imputation", add 
label define label_xf1c012 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c012 30 "Not applicable", add 
label define label_xf1c012 31 "Institution left item blank", add 
label define label_xf1c012 32 "Do not know", add 
label define label_xf1c012 33 "Particular 1st prof field not applicable", add 
label define label_xf1c012 50 "Outlier value derived from reported data", add 
label define label_xf1c012 51 "Outlier value derived from imported data", add 
label define label_xf1c012 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c012 53 "Value not derived - data not usable", add 
label values xf1c012 label_xf1c012
label define label_xf1c013 10 "Reported" 
label define label_xf1c013 11 "Analyst corrected reported value", add 
label define label_xf1c013 12 "Data generated from other data values", add 
label define label_xf1c013 13 "Implied zero", add 
label define label_xf1c013 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c013 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c013 22 "Imputed using the Group Median procedure", add 
label define label_xf1c013 23 "Logical imputation", add 
label define label_xf1c013 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c013 30 "Not applicable", add 
label define label_xf1c013 31 "Institution left item blank", add 
label define label_xf1c013 32 "Do not know", add 
label define label_xf1c013 33 "Particular 1st prof field not applicable", add 
label define label_xf1c013 50 "Outlier value derived from reported data", add 
label define label_xf1c013 51 "Outlier value derived from imported data", add 
label define label_xf1c013 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c013 53 "Value not derived - data not usable", add 
label values xf1c013 label_xf1c013
label define label_xf1c014 10 "Reported" 
label define label_xf1c014 11 "Analyst corrected reported value", add 
label define label_xf1c014 12 "Data generated from other data values", add 
label define label_xf1c014 13 "Implied zero", add 
label define label_xf1c014 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c014 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c014 22 "Imputed using the Group Median procedure", add 
label define label_xf1c014 23 "Logical imputation", add 
label define label_xf1c014 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c014 30 "Not applicable", add 
label define label_xf1c014 31 "Institution left item blank", add 
label define label_xf1c014 32 "Do not know", add 
label define label_xf1c014 33 "Particular 1st prof field not applicable", add 
label define label_xf1c014 50 "Outlier value derived from reported data", add 
label define label_xf1c014 51 "Outlier value derived from imported data", add 
label define label_xf1c014 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c014 53 "Value not derived - data not usable", add 
label values xf1c014 label_xf1c014
label define label_xf1c015 10 "Reported" 
label define label_xf1c015 11 "Analyst corrected reported value", add 
label define label_xf1c015 12 "Data generated from other data values", add 
label define label_xf1c015 13 "Implied zero", add 
label define label_xf1c015 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c015 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c015 22 "Imputed using the Group Median procedure", add 
label define label_xf1c015 23 "Logical imputation", add 
label define label_xf1c015 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c015 30 "Not applicable", add 
label define label_xf1c015 31 "Institution left item blank", add 
label define label_xf1c015 32 "Do not know", add 
label define label_xf1c015 33 "Particular 1st prof field not applicable", add 
label define label_xf1c015 50 "Outlier value derived from reported data", add 
label define label_xf1c015 51 "Outlier value derived from imported data", add 
label define label_xf1c015 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c015 53 "Value not derived - data not usable", add 
label values xf1c015 label_xf1c015
label define label_xf1c021 10 "Reported" 
label define label_xf1c021 11 "Analyst corrected reported value", add 
label define label_xf1c021 12 "Data generated from other data values", add 
label define label_xf1c021 13 "Implied zero", add 
label define label_xf1c021 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c021 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c021 22 "Imputed using the Group Median procedure", add 
label define label_xf1c021 23 "Logical imputation", add 
label define label_xf1c021 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c021 30 "Not applicable", add 
label define label_xf1c021 31 "Institution left item blank", add 
label define label_xf1c021 32 "Do not know", add 
label define label_xf1c021 33 "Particular 1st prof field not applicable", add 
label define label_xf1c021 50 "Outlier value derived from reported data", add 
label define label_xf1c021 51 "Outlier value derived from imported data", add 
label define label_xf1c021 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c021 53 "Value not derived - data not usable", add 
label values xf1c021 label_xf1c021
label define label_xf1c022 10 "Reported" 
label define label_xf1c022 11 "Analyst corrected reported value", add 
label define label_xf1c022 12 "Data generated from other data values", add 
label define label_xf1c022 13 "Implied zero", add 
label define label_xf1c022 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c022 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c022 22 "Imputed using the Group Median procedure", add 
label define label_xf1c022 23 "Logical imputation", add 
label define label_xf1c022 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c022 30 "Not applicable", add 
label define label_xf1c022 31 "Institution left item blank", add 
label define label_xf1c022 32 "Do not know", add 
label define label_xf1c022 33 "Particular 1st prof field not applicable", add 
label define label_xf1c022 50 "Outlier value derived from reported data", add 
label define label_xf1c022 51 "Outlier value derived from imported data", add 
label define label_xf1c022 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c022 53 "Value not derived - data not usable", add 
label values xf1c022 label_xf1c022
label define label_xf1c023 10 "Reported" 
label define label_xf1c023 11 "Analyst corrected reported value", add 
label define label_xf1c023 12 "Data generated from other data values", add 
label define label_xf1c023 13 "Implied zero", add 
label define label_xf1c023 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c023 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c023 22 "Imputed using the Group Median procedure", add 
label define label_xf1c023 23 "Logical imputation", add 
label define label_xf1c023 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c023 30 "Not applicable", add 
label define label_xf1c023 31 "Institution left item blank", add 
label define label_xf1c023 32 "Do not know", add 
label define label_xf1c023 33 "Particular 1st prof field not applicable", add 
label define label_xf1c023 50 "Outlier value derived from reported data", add 
label define label_xf1c023 51 "Outlier value derived from imported data", add 
label define label_xf1c023 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c023 53 "Value not derived - data not usable", add 
label values xf1c023 label_xf1c023
label define label_xf1c024 10 "Reported" 
label define label_xf1c024 11 "Analyst corrected reported value", add 
label define label_xf1c024 12 "Data generated from other data values", add 
label define label_xf1c024 13 "Implied zero", add 
label define label_xf1c024 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c024 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c024 22 "Imputed using the Group Median procedure", add 
label define label_xf1c024 23 "Logical imputation", add 
label define label_xf1c024 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c024 30 "Not applicable", add 
label define label_xf1c024 31 "Institution left item blank", add 
label define label_xf1c024 32 "Do not know", add 
label define label_xf1c024 33 "Particular 1st prof field not applicable", add 
label define label_xf1c024 50 "Outlier value derived from reported data", add 
label define label_xf1c024 51 "Outlier value derived from imported data", add 
label define label_xf1c024 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c024 53 "Value not derived - data not usable", add 
label values xf1c024 label_xf1c024
label define label_xf1c025 10 "Reported" 
label define label_xf1c025 11 "Analyst corrected reported value", add 
label define label_xf1c025 12 "Data generated from other data values", add 
label define label_xf1c025 13 "Implied zero", add 
label define label_xf1c025 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c025 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c025 22 "Imputed using the Group Median procedure", add 
label define label_xf1c025 23 "Logical imputation", add 
label define label_xf1c025 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c025 30 "Not applicable", add 
label define label_xf1c025 31 "Institution left item blank", add 
label define label_xf1c025 32 "Do not know", add 
label define label_xf1c025 33 "Particular 1st prof field not applicable", add 
label define label_xf1c025 50 "Outlier value derived from reported data", add 
label define label_xf1c025 51 "Outlier value derived from imported data", add 
label define label_xf1c025 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c025 53 "Value not derived - data not usable", add 
label values xf1c025 label_xf1c025
label define label_xf1c031 10 "Reported" 
label define label_xf1c031 11 "Analyst corrected reported value", add 
label define label_xf1c031 12 "Data generated from other data values", add 
label define label_xf1c031 13 "Implied zero", add 
label define label_xf1c031 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c031 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c031 22 "Imputed using the Group Median procedure", add 
label define label_xf1c031 23 "Logical imputation", add 
label define label_xf1c031 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c031 30 "Not applicable", add 
label define label_xf1c031 31 "Institution left item blank", add 
label define label_xf1c031 32 "Do not know", add 
label define label_xf1c031 33 "Particular 1st prof field not applicable", add 
label define label_xf1c031 50 "Outlier value derived from reported data", add 
label define label_xf1c031 51 "Outlier value derived from imported data", add 
label define label_xf1c031 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c031 53 "Value not derived - data not usable", add 
label values xf1c031 label_xf1c031
label define label_xf1c032 10 "Reported" 
label define label_xf1c032 11 "Analyst corrected reported value", add 
label define label_xf1c032 12 "Data generated from other data values", add 
label define label_xf1c032 13 "Implied zero", add 
label define label_xf1c032 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c032 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c032 22 "Imputed using the Group Median procedure", add 
label define label_xf1c032 23 "Logical imputation", add 
label define label_xf1c032 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c032 30 "Not applicable", add 
label define label_xf1c032 31 "Institution left item blank", add 
label define label_xf1c032 32 "Do not know", add 
label define label_xf1c032 33 "Particular 1st prof field not applicable", add 
label define label_xf1c032 50 "Outlier value derived from reported data", add 
label define label_xf1c032 51 "Outlier value derived from imported data", add 
label define label_xf1c032 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c032 53 "Value not derived - data not usable", add 
label values xf1c032 label_xf1c032
label define label_xf1c033 10 "Reported" 
label define label_xf1c033 11 "Analyst corrected reported value", add 
label define label_xf1c033 12 "Data generated from other data values", add 
label define label_xf1c033 13 "Implied zero", add 
label define label_xf1c033 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c033 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c033 22 "Imputed using the Group Median procedure", add 
label define label_xf1c033 23 "Logical imputation", add 
label define label_xf1c033 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c033 30 "Not applicable", add 
label define label_xf1c033 31 "Institution left item blank", add 
label define label_xf1c033 32 "Do not know", add 
label define label_xf1c033 33 "Particular 1st prof field not applicable", add 
label define label_xf1c033 50 "Outlier value derived from reported data", add 
label define label_xf1c033 51 "Outlier value derived from imported data", add 
label define label_xf1c033 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c033 53 "Value not derived - data not usable", add 
label values xf1c033 label_xf1c033
label define label_xf1c034 10 "Reported" 
label define label_xf1c034 11 "Analyst corrected reported value", add 
label define label_xf1c034 12 "Data generated from other data values", add 
label define label_xf1c034 13 "Implied zero", add 
label define label_xf1c034 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c034 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c034 22 "Imputed using the Group Median procedure", add 
label define label_xf1c034 23 "Logical imputation", add 
label define label_xf1c034 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c034 30 "Not applicable", add 
label define label_xf1c034 31 "Institution left item blank", add 
label define label_xf1c034 32 "Do not know", add 
label define label_xf1c034 33 "Particular 1st prof field not applicable", add 
label define label_xf1c034 50 "Outlier value derived from reported data", add 
label define label_xf1c034 51 "Outlier value derived from imported data", add 
label define label_xf1c034 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c034 53 "Value not derived - data not usable", add 
label values xf1c034 label_xf1c034
label define label_xf1c035 10 "Reported" 
label define label_xf1c035 11 "Analyst corrected reported value", add 
label define label_xf1c035 12 "Data generated from other data values", add 
label define label_xf1c035 13 "Implied zero", add 
label define label_xf1c035 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c035 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c035 22 "Imputed using the Group Median procedure", add 
label define label_xf1c035 23 "Logical imputation", add 
label define label_xf1c035 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c035 30 "Not applicable", add 
label define label_xf1c035 31 "Institution left item blank", add 
label define label_xf1c035 32 "Do not know", add 
label define label_xf1c035 33 "Particular 1st prof field not applicable", add 
label define label_xf1c035 50 "Outlier value derived from reported data", add 
label define label_xf1c035 51 "Outlier value derived from imported data", add 
label define label_xf1c035 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c035 53 "Value not derived - data not usable", add 
label values xf1c035 label_xf1c035
label define label_xf1c051 10 "Reported" 
label define label_xf1c051 11 "Analyst corrected reported value", add 
label define label_xf1c051 12 "Data generated from other data values", add 
label define label_xf1c051 13 "Implied zero", add 
label define label_xf1c051 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c051 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c051 22 "Imputed using the Group Median procedure", add 
label define label_xf1c051 23 "Logical imputation", add 
label define label_xf1c051 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c051 30 "Not applicable", add 
label define label_xf1c051 31 "Institution left item blank", add 
label define label_xf1c051 32 "Do not know", add 
label define label_xf1c051 33 "Particular 1st prof field not applicable", add 
label define label_xf1c051 50 "Outlier value derived from reported data", add 
label define label_xf1c051 51 "Outlier value derived from imported data", add 
label define label_xf1c051 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c051 53 "Value not derived - data not usable", add 
label values xf1c051 label_xf1c051
label define label_xf1c052 10 "Reported" 
label define label_xf1c052 11 "Analyst corrected reported value", add 
label define label_xf1c052 12 "Data generated from other data values", add 
label define label_xf1c052 13 "Implied zero", add 
label define label_xf1c052 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c052 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c052 22 "Imputed using the Group Median procedure", add 
label define label_xf1c052 23 "Logical imputation", add 
label define label_xf1c052 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c052 30 "Not applicable", add 
label define label_xf1c052 31 "Institution left item blank", add 
label define label_xf1c052 32 "Do not know", add 
label define label_xf1c052 33 "Particular 1st prof field not applicable", add 
label define label_xf1c052 50 "Outlier value derived from reported data", add 
label define label_xf1c052 51 "Outlier value derived from imported data", add 
label define label_xf1c052 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c052 53 "Value not derived - data not usable", add 
label values xf1c052 label_xf1c052
label define label_xf1c053 10 "Reported" 
label define label_xf1c053 11 "Analyst corrected reported value", add 
label define label_xf1c053 12 "Data generated from other data values", add 
label define label_xf1c053 13 "Implied zero", add 
label define label_xf1c053 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c053 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c053 22 "Imputed using the Group Median procedure", add 
label define label_xf1c053 23 "Logical imputation", add 
label define label_xf1c053 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c053 30 "Not applicable", add 
label define label_xf1c053 31 "Institution left item blank", add 
label define label_xf1c053 32 "Do not know", add 
label define label_xf1c053 33 "Particular 1st prof field not applicable", add 
label define label_xf1c053 50 "Outlier value derived from reported data", add 
label define label_xf1c053 51 "Outlier value derived from imported data", add 
label define label_xf1c053 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c053 53 "Value not derived - data not usable", add 
label values xf1c053 label_xf1c053
label define label_xf1c054 10 "Reported" 
label define label_xf1c054 11 "Analyst corrected reported value", add 
label define label_xf1c054 12 "Data generated from other data values", add 
label define label_xf1c054 13 "Implied zero", add 
label define label_xf1c054 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c054 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c054 22 "Imputed using the Group Median procedure", add 
label define label_xf1c054 23 "Logical imputation", add 
label define label_xf1c054 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c054 30 "Not applicable", add 
label define label_xf1c054 31 "Institution left item blank", add 
label define label_xf1c054 32 "Do not know", add 
label define label_xf1c054 33 "Particular 1st prof field not applicable", add 
label define label_xf1c054 50 "Outlier value derived from reported data", add 
label define label_xf1c054 51 "Outlier value derived from imported data", add 
label define label_xf1c054 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c054 53 "Value not derived - data not usable", add 
label values xf1c054 label_xf1c054
label define label_xf1c055 10 "Reported" 
label define label_xf1c055 11 "Analyst corrected reported value", add 
label define label_xf1c055 12 "Data generated from other data values", add 
label define label_xf1c055 13 "Implied zero", add 
label define label_xf1c055 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c055 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c055 22 "Imputed using the Group Median procedure", add 
label define label_xf1c055 23 "Logical imputation", add 
label define label_xf1c055 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c055 30 "Not applicable", add 
label define label_xf1c055 31 "Institution left item blank", add 
label define label_xf1c055 32 "Do not know", add 
label define label_xf1c055 33 "Particular 1st prof field not applicable", add 
label define label_xf1c055 50 "Outlier value derived from reported data", add 
label define label_xf1c055 51 "Outlier value derived from imported data", add 
label define label_xf1c055 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c055 53 "Value not derived - data not usable", add 
label values xf1c055 label_xf1c055
label define label_xf1c061 10 "Reported" 
label define label_xf1c061 11 "Analyst corrected reported value", add 
label define label_xf1c061 12 "Data generated from other data values", add 
label define label_xf1c061 13 "Implied zero", add 
label define label_xf1c061 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c061 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c061 22 "Imputed using the Group Median procedure", add 
label define label_xf1c061 23 "Logical imputation", add 
label define label_xf1c061 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c061 30 "Not applicable", add 
label define label_xf1c061 31 "Institution left item blank", add 
label define label_xf1c061 32 "Do not know", add 
label define label_xf1c061 33 "Particular 1st prof field not applicable", add 
label define label_xf1c061 50 "Outlier value derived from reported data", add 
label define label_xf1c061 51 "Outlier value derived from imported data", add 
label define label_xf1c061 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c061 53 "Value not derived - data not usable", add 
label values xf1c061 label_xf1c061
label define label_xf1c062 10 "Reported" 
label define label_xf1c062 11 "Analyst corrected reported value", add 
label define label_xf1c062 12 "Data generated from other data values", add 
label define label_xf1c062 13 "Implied zero", add 
label define label_xf1c062 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c062 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c062 22 "Imputed using the Group Median procedure", add 
label define label_xf1c062 23 "Logical imputation", add 
label define label_xf1c062 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c062 30 "Not applicable", add 
label define label_xf1c062 31 "Institution left item blank", add 
label define label_xf1c062 32 "Do not know", add 
label define label_xf1c062 33 "Particular 1st prof field not applicable", add 
label define label_xf1c062 50 "Outlier value derived from reported data", add 
label define label_xf1c062 51 "Outlier value derived from imported data", add 
label define label_xf1c062 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c062 53 "Value not derived - data not usable", add 
label values xf1c062 label_xf1c062
label define label_xf1c063 10 "Reported" 
label define label_xf1c063 11 "Analyst corrected reported value", add 
label define label_xf1c063 12 "Data generated from other data values", add 
label define label_xf1c063 13 "Implied zero", add 
label define label_xf1c063 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c063 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c063 22 "Imputed using the Group Median procedure", add 
label define label_xf1c063 23 "Logical imputation", add 
label define label_xf1c063 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c063 30 "Not applicable", add 
label define label_xf1c063 31 "Institution left item blank", add 
label define label_xf1c063 32 "Do not know", add 
label define label_xf1c063 33 "Particular 1st prof field not applicable", add 
label define label_xf1c063 50 "Outlier value derived from reported data", add 
label define label_xf1c063 51 "Outlier value derived from imported data", add 
label define label_xf1c063 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c063 53 "Value not derived - data not usable", add 
label values xf1c063 label_xf1c063
label define label_xf1c064 10 "Reported" 
label define label_xf1c064 11 "Analyst corrected reported value", add 
label define label_xf1c064 12 "Data generated from other data values", add 
label define label_xf1c064 13 "Implied zero", add 
label define label_xf1c064 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c064 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c064 22 "Imputed using the Group Median procedure", add 
label define label_xf1c064 23 "Logical imputation", add 
label define label_xf1c064 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c064 30 "Not applicable", add 
label define label_xf1c064 31 "Institution left item blank", add 
label define label_xf1c064 32 "Do not know", add 
label define label_xf1c064 33 "Particular 1st prof field not applicable", add 
label define label_xf1c064 50 "Outlier value derived from reported data", add 
label define label_xf1c064 51 "Outlier value derived from imported data", add 
label define label_xf1c064 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c064 53 "Value not derived - data not usable", add 
label values xf1c064 label_xf1c064
label define label_xf1c065 10 "Reported" 
label define label_xf1c065 11 "Analyst corrected reported value", add 
label define label_xf1c065 12 "Data generated from other data values", add 
label define label_xf1c065 13 "Implied zero", add 
label define label_xf1c065 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c065 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c065 22 "Imputed using the Group Median procedure", add 
label define label_xf1c065 23 "Logical imputation", add 
label define label_xf1c065 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c065 30 "Not applicable", add 
label define label_xf1c065 31 "Institution left item blank", add 
label define label_xf1c065 32 "Do not know", add 
label define label_xf1c065 33 "Particular 1st prof field not applicable", add 
label define label_xf1c065 50 "Outlier value derived from reported data", add 
label define label_xf1c065 51 "Outlier value derived from imported data", add 
label define label_xf1c065 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c065 53 "Value not derived - data not usable", add 
label values xf1c065 label_xf1c065
label define label_xf1c071 10 "Reported" 
label define label_xf1c071 11 "Analyst corrected reported value", add 
label define label_xf1c071 12 "Data generated from other data values", add 
label define label_xf1c071 13 "Implied zero", add 
label define label_xf1c071 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c071 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c071 22 "Imputed using the Group Median procedure", add 
label define label_xf1c071 23 "Logical imputation", add 
label define label_xf1c071 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c071 30 "Not applicable", add 
label define label_xf1c071 31 "Institution left item blank", add 
label define label_xf1c071 32 "Do not know", add 
label define label_xf1c071 33 "Particular 1st prof field not applicable", add 
label define label_xf1c071 50 "Outlier value derived from reported data", add 
label define label_xf1c071 51 "Outlier value derived from imported data", add 
label define label_xf1c071 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c071 53 "Value not derived - data not usable", add 
label values xf1c071 label_xf1c071
label define label_xf1c072 10 "Reported" 
label define label_xf1c072 11 "Analyst corrected reported value", add 
label define label_xf1c072 12 "Data generated from other data values", add 
label define label_xf1c072 13 "Implied zero", add 
label define label_xf1c072 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c072 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c072 22 "Imputed using the Group Median procedure", add 
label define label_xf1c072 23 "Logical imputation", add 
label define label_xf1c072 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c072 30 "Not applicable", add 
label define label_xf1c072 31 "Institution left item blank", add 
label define label_xf1c072 32 "Do not know", add 
label define label_xf1c072 33 "Particular 1st prof field not applicable", add 
label define label_xf1c072 50 "Outlier value derived from reported data", add 
label define label_xf1c072 51 "Outlier value derived from imported data", add 
label define label_xf1c072 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c072 53 "Value not derived - data not usable", add 
label values xf1c072 label_xf1c072
label define label_xf1c073 10 "Reported" 
label define label_xf1c073 11 "Analyst corrected reported value", add 
label define label_xf1c073 12 "Data generated from other data values", add 
label define label_xf1c073 13 "Implied zero", add 
label define label_xf1c073 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c073 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c073 22 "Imputed using the Group Median procedure", add 
label define label_xf1c073 23 "Logical imputation", add 
label define label_xf1c073 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c073 30 "Not applicable", add 
label define label_xf1c073 31 "Institution left item blank", add 
label define label_xf1c073 32 "Do not know", add 
label define label_xf1c073 33 "Particular 1st prof field not applicable", add 
label define label_xf1c073 50 "Outlier value derived from reported data", add 
label define label_xf1c073 51 "Outlier value derived from imported data", add 
label define label_xf1c073 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c073 53 "Value not derived - data not usable", add 
label values xf1c073 label_xf1c073
label define label_xf1c074 10 "Reported" 
label define label_xf1c074 11 "Analyst corrected reported value", add 
label define label_xf1c074 12 "Data generated from other data values", add 
label define label_xf1c074 13 "Implied zero", add 
label define label_xf1c074 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c074 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c074 22 "Imputed using the Group Median procedure", add 
label define label_xf1c074 23 "Logical imputation", add 
label define label_xf1c074 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c074 30 "Not applicable", add 
label define label_xf1c074 31 "Institution left item blank", add 
label define label_xf1c074 32 "Do not know", add 
label define label_xf1c074 33 "Particular 1st prof field not applicable", add 
label define label_xf1c074 50 "Outlier value derived from reported data", add 
label define label_xf1c074 51 "Outlier value derived from imported data", add 
label define label_xf1c074 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c074 53 "Value not derived - data not usable", add 
label values xf1c074 label_xf1c074
label define label_xf1c075 10 "Reported" 
label define label_xf1c075 11 "Analyst corrected reported value", add 
label define label_xf1c075 12 "Data generated from other data values", add 
label define label_xf1c075 13 "Implied zero", add 
label define label_xf1c075 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c075 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c075 22 "Imputed using the Group Median procedure", add 
label define label_xf1c075 23 "Logical imputation", add 
label define label_xf1c075 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c075 30 "Not applicable", add 
label define label_xf1c075 31 "Institution left item blank", add 
label define label_xf1c075 32 "Do not know", add 
label define label_xf1c075 33 "Particular 1st prof field not applicable", add 
label define label_xf1c075 50 "Outlier value derived from reported data", add 
label define label_xf1c075 51 "Outlier value derived from imported data", add 
label define label_xf1c075 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c075 53 "Value not derived - data not usable", add 
label values xf1c075 label_xf1c075
label define label_xf1c081 10 "Reported" 
label define label_xf1c081 11 "Analyst corrected reported value", add 
label define label_xf1c081 12 "Data generated from other data values", add 
label define label_xf1c081 13 "Implied zero", add 
label define label_xf1c081 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c081 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c081 22 "Imputed using the Group Median procedure", add 
label define label_xf1c081 23 "Logical imputation", add 
label define label_xf1c081 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c081 30 "Not applicable", add 
label define label_xf1c081 31 "Institution left item blank", add 
label define label_xf1c081 32 "Do not know", add 
label define label_xf1c081 33 "Particular 1st prof field not applicable", add 
label define label_xf1c081 50 "Outlier value derived from reported data", add 
label define label_xf1c081 51 "Outlier value derived from imported data", add 
label define label_xf1c081 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c081 53 "Value not derived - data not usable", add 
label values xf1c081 label_xf1c081
label define label_xf1c082 10 "Reported" 
label define label_xf1c082 11 "Analyst corrected reported value", add 
label define label_xf1c082 12 "Data generated from other data values", add 
label define label_xf1c082 13 "Implied zero", add 
label define label_xf1c082 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c082 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c082 22 "Imputed using the Group Median procedure", add 
label define label_xf1c082 23 "Logical imputation", add 
label define label_xf1c082 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c082 30 "Not applicable", add 
label define label_xf1c082 31 "Institution left item blank", add 
label define label_xf1c082 32 "Do not know", add 
label define label_xf1c082 33 "Particular 1st prof field not applicable", add 
label define label_xf1c082 50 "Outlier value derived from reported data", add 
label define label_xf1c082 51 "Outlier value derived from imported data", add 
label define label_xf1c082 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c082 53 "Value not derived - data not usable", add 
label values xf1c082 label_xf1c082
label define label_xf1c083 10 "Reported" 
label define label_xf1c083 11 "Analyst corrected reported value", add 
label define label_xf1c083 12 "Data generated from other data values", add 
label define label_xf1c083 13 "Implied zero", add 
label define label_xf1c083 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c083 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c083 22 "Imputed using the Group Median procedure", add 
label define label_xf1c083 23 "Logical imputation", add 
label define label_xf1c083 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c083 30 "Not applicable", add 
label define label_xf1c083 31 "Institution left item blank", add 
label define label_xf1c083 32 "Do not know", add 
label define label_xf1c083 33 "Particular 1st prof field not applicable", add 
label define label_xf1c083 50 "Outlier value derived from reported data", add 
label define label_xf1c083 51 "Outlier value derived from imported data", add 
label define label_xf1c083 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c083 53 "Value not derived - data not usable", add 
label values xf1c083 label_xf1c083
label define label_xf1c084 10 "Reported" 
label define label_xf1c084 11 "Analyst corrected reported value", add 
label define label_xf1c084 12 "Data generated from other data values", add 
label define label_xf1c084 13 "Implied zero", add 
label define label_xf1c084 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c084 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c084 22 "Imputed using the Group Median procedure", add 
label define label_xf1c084 23 "Logical imputation", add 
label define label_xf1c084 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c084 30 "Not applicable", add 
label define label_xf1c084 31 "Institution left item blank", add 
label define label_xf1c084 32 "Do not know", add 
label define label_xf1c084 33 "Particular 1st prof field not applicable", add 
label define label_xf1c084 50 "Outlier value derived from reported data", add 
label define label_xf1c084 51 "Outlier value derived from imported data", add 
label define label_xf1c084 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c084 53 "Value not derived - data not usable", add 
label values xf1c084 label_xf1c084
label define label_xf1c085 10 "Reported" 
label define label_xf1c085 11 "Analyst corrected reported value", add 
label define label_xf1c085 12 "Data generated from other data values", add 
label define label_xf1c085 13 "Implied zero", add 
label define label_xf1c085 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c085 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c085 22 "Imputed using the Group Median procedure", add 
label define label_xf1c085 23 "Logical imputation", add 
label define label_xf1c085 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c085 30 "Not applicable", add 
label define label_xf1c085 31 "Institution left item blank", add 
label define label_xf1c085 32 "Do not know", add 
label define label_xf1c085 33 "Particular 1st prof field not applicable", add 
label define label_xf1c085 50 "Outlier value derived from reported data", add 
label define label_xf1c085 51 "Outlier value derived from imported data", add 
label define label_xf1c085 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c085 53 "Value not derived - data not usable", add 
label values xf1c085 label_xf1c085
label define label_xf1c091 10 "Reported" 
label define label_xf1c091 11 "Analyst corrected reported value", add 
label define label_xf1c091 12 "Data generated from other data values", add 
label define label_xf1c091 13 "Implied zero", add 
label define label_xf1c091 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c091 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c091 22 "Imputed using the Group Median procedure", add 
label define label_xf1c091 23 "Logical imputation", add 
label define label_xf1c091 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c091 30 "Not applicable", add 
label define label_xf1c091 31 "Institution left item blank", add 
label define label_xf1c091 32 "Do not know", add 
label define label_xf1c091 33 "Particular 1st prof field not applicable", add 
label define label_xf1c091 50 "Outlier value derived from reported data", add 
label define label_xf1c091 51 "Outlier value derived from imported data", add 
label define label_xf1c091 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c091 53 "Value not derived - data not usable", add 
label values xf1c091 label_xf1c091
label define label_xf1c094 10 "Reported" 
label define label_xf1c094 11 "Analyst corrected reported value", add 
label define label_xf1c094 12 "Data generated from other data values", add 
label define label_xf1c094 13 "Implied zero", add 
label define label_xf1c094 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c094 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c094 22 "Imputed using the Group Median procedure", add 
label define label_xf1c094 23 "Logical imputation", add 
label define label_xf1c094 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c094 30 "Not applicable", add 
label define label_xf1c094 31 "Institution left item blank", add 
label define label_xf1c094 32 "Do not know", add 
label define label_xf1c094 33 "Particular 1st prof field not applicable", add 
label define label_xf1c094 50 "Outlier value derived from reported data", add 
label define label_xf1c094 51 "Outlier value derived from imported data", add 
label define label_xf1c094 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c094 53 "Value not derived - data not usable", add 
label values xf1c094 label_xf1c094
label define label_xf1c101 10 "Reported" 
label define label_xf1c101 11 "Analyst corrected reported value", add 
label define label_xf1c101 12 "Data generated from other data values", add 
label define label_xf1c101 13 "Implied zero", add 
label define label_xf1c101 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c101 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c101 22 "Imputed using the Group Median procedure", add 
label define label_xf1c101 23 "Logical imputation", add 
label define label_xf1c101 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c101 30 "Not applicable", add 
label define label_xf1c101 31 "Institution left item blank", add 
label define label_xf1c101 32 "Do not know", add 
label define label_xf1c101 33 "Particular 1st prof field not applicable", add 
label define label_xf1c101 50 "Outlier value derived from reported data", add 
label define label_xf1c101 51 "Outlier value derived from imported data", add 
label define label_xf1c101 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c101 53 "Value not derived - data not usable", add 
label values xf1c101 label_xf1c101
label define label_xf1c102 10 "Reported" 
label define label_xf1c102 11 "Analyst corrected reported value", add 
label define label_xf1c102 12 "Data generated from other data values", add 
label define label_xf1c102 13 "Implied zero", add 
label define label_xf1c102 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c102 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c102 22 "Imputed using the Group Median procedure", add 
label define label_xf1c102 23 "Logical imputation", add 
label define label_xf1c102 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c102 30 "Not applicable", add 
label define label_xf1c102 31 "Institution left item blank", add 
label define label_xf1c102 32 "Do not know", add 
label define label_xf1c102 33 "Particular 1st prof field not applicable", add 
label define label_xf1c102 50 "Outlier value derived from reported data", add 
label define label_xf1c102 51 "Outlier value derived from imported data", add 
label define label_xf1c102 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c102 53 "Value not derived - data not usable", add 
label values xf1c102 label_xf1c102
label define label_xf1c103 10 "Reported" 
label define label_xf1c103 11 "Analyst corrected reported value", add 
label define label_xf1c103 12 "Data generated from other data values", add 
label define label_xf1c103 13 "Implied zero", add 
label define label_xf1c103 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c103 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c103 22 "Imputed using the Group Median procedure", add 
label define label_xf1c103 23 "Logical imputation", add 
label define label_xf1c103 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c103 30 "Not applicable", add 
label define label_xf1c103 31 "Institution left item blank", add 
label define label_xf1c103 32 "Do not know", add 
label define label_xf1c103 33 "Particular 1st prof field not applicable", add 
label define label_xf1c103 50 "Outlier value derived from reported data", add 
label define label_xf1c103 51 "Outlier value derived from imported data", add 
label define label_xf1c103 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c103 53 "Value not derived - data not usable", add 
label values xf1c103 label_xf1c103
label define label_xf1c104 10 "Reported" 
label define label_xf1c104 11 "Analyst corrected reported value", add 
label define label_xf1c104 12 "Data generated from other data values", add 
label define label_xf1c104 13 "Implied zero", add 
label define label_xf1c104 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c104 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c104 22 "Imputed using the Group Median procedure", add 
label define label_xf1c104 23 "Logical imputation", add 
label define label_xf1c104 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c104 30 "Not applicable", add 
label define label_xf1c104 31 "Institution left item blank", add 
label define label_xf1c104 32 "Do not know", add 
label define label_xf1c104 33 "Particular 1st prof field not applicable", add 
label define label_xf1c104 50 "Outlier value derived from reported data", add 
label define label_xf1c104 51 "Outlier value derived from imported data", add 
label define label_xf1c104 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c104 53 "Value not derived - data not usable", add 
label values xf1c104 label_xf1c104
label define label_xf1c105 10 "Reported" 
label define label_xf1c105 11 "Analyst corrected reported value", add 
label define label_xf1c105 12 "Data generated from other data values", add 
label define label_xf1c105 13 "Implied zero", add 
label define label_xf1c105 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c105 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c105 22 "Imputed using the Group Median procedure", add 
label define label_xf1c105 23 "Logical imputation", add 
label define label_xf1c105 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c105 30 "Not applicable", add 
label define label_xf1c105 31 "Institution left item blank", add 
label define label_xf1c105 32 "Do not know", add 
label define label_xf1c105 33 "Particular 1st prof field not applicable", add 
label define label_xf1c105 50 "Outlier value derived from reported data", add 
label define label_xf1c105 51 "Outlier value derived from imported data", add 
label define label_xf1c105 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c105 53 "Value not derived - data not usable", add 
label values xf1c105 label_xf1c105
label define label_xf1c111 10 "Reported" 
label define label_xf1c111 11 "Analyst corrected reported value", add 
label define label_xf1c111 12 "Data generated from other data values", add 
label define label_xf1c111 13 "Implied zero", add 
label define label_xf1c111 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c111 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c111 22 "Imputed using the Group Median procedure", add 
label define label_xf1c111 23 "Logical imputation", add 
label define label_xf1c111 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c111 30 "Not applicable", add 
label define label_xf1c111 31 "Institution left item blank", add 
label define label_xf1c111 32 "Do not know", add 
label define label_xf1c111 33 "Particular 1st prof field not applicable", add 
label define label_xf1c111 50 "Outlier value derived from reported data", add 
label define label_xf1c111 51 "Outlier value derived from imported data", add 
label define label_xf1c111 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c111 53 "Value not derived - data not usable", add 
label values xf1c111 label_xf1c111
label define label_xf1c112 10 "Reported" 
label define label_xf1c112 11 "Analyst corrected reported value", add 
label define label_xf1c112 12 "Data generated from other data values", add 
label define label_xf1c112 13 "Implied zero", add 
label define label_xf1c112 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c112 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c112 22 "Imputed using the Group Median procedure", add 
label define label_xf1c112 23 "Logical imputation", add 
label define label_xf1c112 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c112 30 "Not applicable", add 
label define label_xf1c112 31 "Institution left item blank", add 
label define label_xf1c112 32 "Do not know", add 
label define label_xf1c112 33 "Particular 1st prof field not applicable", add 
label define label_xf1c112 50 "Outlier value derived from reported data", add 
label define label_xf1c112 51 "Outlier value derived from imported data", add 
label define label_xf1c112 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c112 53 "Value not derived - data not usable", add 
label values xf1c112 label_xf1c112
label define label_xf1c113 10 "Reported" 
label define label_xf1c113 11 "Analyst corrected reported value", add 
label define label_xf1c113 12 "Data generated from other data values", add 
label define label_xf1c113 13 "Implied zero", add 
label define label_xf1c113 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c113 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c113 22 "Imputed using the Group Median procedure", add 
label define label_xf1c113 23 "Logical imputation", add 
label define label_xf1c113 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c113 30 "Not applicable", add 
label define label_xf1c113 31 "Institution left item blank", add 
label define label_xf1c113 32 "Do not know", add 
label define label_xf1c113 33 "Particular 1st prof field not applicable", add 
label define label_xf1c113 50 "Outlier value derived from reported data", add 
label define label_xf1c113 51 "Outlier value derived from imported data", add 
label define label_xf1c113 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c113 53 "Value not derived - data not usable", add 
label values xf1c113 label_xf1c113
label define label_xf1c114 10 "Reported" 
label define label_xf1c114 11 "Analyst corrected reported value", add 
label define label_xf1c114 12 "Data generated from other data values", add 
label define label_xf1c114 13 "Implied zero", add 
label define label_xf1c114 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c114 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c114 22 "Imputed using the Group Median procedure", add 
label define label_xf1c114 23 "Logical imputation", add 
label define label_xf1c114 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c114 30 "Not applicable", add 
label define label_xf1c114 31 "Institution left item blank", add 
label define label_xf1c114 32 "Do not know", add 
label define label_xf1c114 33 "Particular 1st prof field not applicable", add 
label define label_xf1c114 50 "Outlier value derived from reported data", add 
label define label_xf1c114 51 "Outlier value derived from imported data", add 
label define label_xf1c114 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c114 53 "Value not derived - data not usable", add 
label values xf1c114 label_xf1c114
label define label_xf1c115 10 "Reported" 
label define label_xf1c115 11 "Analyst corrected reported value", add 
label define label_xf1c115 12 "Data generated from other data values", add 
label define label_xf1c115 13 "Implied zero", add 
label define label_xf1c115 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c115 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c115 22 "Imputed using the Group Median procedure", add 
label define label_xf1c115 23 "Logical imputation", add 
label define label_xf1c115 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c115 30 "Not applicable", add 
label define label_xf1c115 31 "Institution left item blank", add 
label define label_xf1c115 32 "Do not know", add 
label define label_xf1c115 33 "Particular 1st prof field not applicable", add 
label define label_xf1c115 50 "Outlier value derived from reported data", add 
label define label_xf1c115 51 "Outlier value derived from imported data", add 
label define label_xf1c115 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c115 53 "Value not derived - data not usable", add 
label values xf1c115 label_xf1c115
label define label_xf1c121 10 "Reported" 
label define label_xf1c121 11 "Analyst corrected reported value", add 
label define label_xf1c121 12 "Data generated from other data values", add 
label define label_xf1c121 13 "Implied zero", add 
label define label_xf1c121 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c121 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c121 22 "Imputed using the Group Median procedure", add 
label define label_xf1c121 23 "Logical imputation", add 
label define label_xf1c121 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c121 30 "Not applicable", add 
label define label_xf1c121 31 "Institution left item blank", add 
label define label_xf1c121 32 "Do not know", add 
label define label_xf1c121 33 "Particular 1st prof field not applicable", add 
label define label_xf1c121 50 "Outlier value derived from reported data", add 
label define label_xf1c121 51 "Outlier value derived from imported data", add 
label define label_xf1c121 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c121 53 "Value not derived - data not usable", add 
label values xf1c121 label_xf1c121
label define label_xf1c122 10 "Reported" 
label define label_xf1c122 11 "Analyst corrected reported value", add 
label define label_xf1c122 12 "Data generated from other data values", add 
label define label_xf1c122 13 "Implied zero", add 
label define label_xf1c122 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c122 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c122 22 "Imputed using the Group Median procedure", add 
label define label_xf1c122 23 "Logical imputation", add 
label define label_xf1c122 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c122 30 "Not applicable", add 
label define label_xf1c122 31 "Institution left item blank", add 
label define label_xf1c122 32 "Do not know", add 
label define label_xf1c122 33 "Particular 1st prof field not applicable", add 
label define label_xf1c122 50 "Outlier value derived from reported data", add 
label define label_xf1c122 51 "Outlier value derived from imported data", add 
label define label_xf1c122 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c122 53 "Value not derived - data not usable", add 
label values xf1c122 label_xf1c122
label define label_xf1c123 10 "Reported" 
label define label_xf1c123 11 "Analyst corrected reported value", add 
label define label_xf1c123 12 "Data generated from other data values", add 
label define label_xf1c123 13 "Implied zero", add 
label define label_xf1c123 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c123 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c123 22 "Imputed using the Group Median procedure", add 
label define label_xf1c123 23 "Logical imputation", add 
label define label_xf1c123 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c123 30 "Not applicable", add 
label define label_xf1c123 31 "Institution left item blank", add 
label define label_xf1c123 32 "Do not know", add 
label define label_xf1c123 33 "Particular 1st prof field not applicable", add 
label define label_xf1c123 50 "Outlier value derived from reported data", add 
label define label_xf1c123 51 "Outlier value derived from imported data", add 
label define label_xf1c123 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c123 53 "Value not derived - data not usable", add 
label values xf1c123 label_xf1c123
label define label_xf1c124 10 "Reported" 
label define label_xf1c124 11 "Analyst corrected reported value", add 
label define label_xf1c124 12 "Data generated from other data values", add 
label define label_xf1c124 13 "Implied zero", add 
label define label_xf1c124 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c124 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c124 22 "Imputed using the Group Median procedure", add 
label define label_xf1c124 23 "Logical imputation", add 
label define label_xf1c124 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c124 30 "Not applicable", add 
label define label_xf1c124 31 "Institution left item blank", add 
label define label_xf1c124 32 "Do not know", add 
label define label_xf1c124 33 "Particular 1st prof field not applicable", add 
label define label_xf1c124 50 "Outlier value derived from reported data", add 
label define label_xf1c124 51 "Outlier value derived from imported data", add 
label define label_xf1c124 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c124 53 "Value not derived - data not usable", add 
label values xf1c124 label_xf1c124
label define label_xf1c125 10 "Reported" 
label define label_xf1c125 11 "Analyst corrected reported value", add 
label define label_xf1c125 12 "Data generated from other data values", add 
label define label_xf1c125 13 "Implied zero", add 
label define label_xf1c125 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c125 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c125 22 "Imputed using the Group Median procedure", add 
label define label_xf1c125 23 "Logical imputation", add 
label define label_xf1c125 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c125 30 "Not applicable", add 
label define label_xf1c125 31 "Institution left item blank", add 
label define label_xf1c125 32 "Do not know", add 
label define label_xf1c125 33 "Particular 1st prof field not applicable", add 
label define label_xf1c125 50 "Outlier value derived from reported data", add 
label define label_xf1c125 51 "Outlier value derived from imported data", add 
label define label_xf1c125 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c125 53 "Value not derived - data not usable", add 
label values xf1c125 label_xf1c125
label define label_xf1c131 10 "Reported" 
label define label_xf1c131 11 "Analyst corrected reported value", add 
label define label_xf1c131 12 "Data generated from other data values", add 
label define label_xf1c131 13 "Implied zero", add 
label define label_xf1c131 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c131 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c131 22 "Imputed using the Group Median procedure", add 
label define label_xf1c131 23 "Logical imputation", add 
label define label_xf1c131 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c131 30 "Not applicable", add 
label define label_xf1c131 31 "Institution left item blank", add 
label define label_xf1c131 32 "Do not know", add 
label define label_xf1c131 33 "Particular 1st prof field not applicable", add 
label define label_xf1c131 50 "Outlier value derived from reported data", add 
label define label_xf1c131 51 "Outlier value derived from imported data", add 
label define label_xf1c131 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c131 53 "Value not derived - data not usable", add 
label values xf1c131 label_xf1c131
label define label_xf1c132 10 "Reported" 
label define label_xf1c132 11 "Analyst corrected reported value", add 
label define label_xf1c132 12 "Data generated from other data values", add 
label define label_xf1c132 13 "Implied zero", add 
label define label_xf1c132 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c132 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c132 22 "Imputed using the Group Median procedure", add 
label define label_xf1c132 23 "Logical imputation", add 
label define label_xf1c132 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c132 30 "Not applicable", add 
label define label_xf1c132 31 "Institution left item blank", add 
label define label_xf1c132 32 "Do not know", add 
label define label_xf1c132 33 "Particular 1st prof field not applicable", add 
label define label_xf1c132 50 "Outlier value derived from reported data", add 
label define label_xf1c132 51 "Outlier value derived from imported data", add 
label define label_xf1c132 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c132 53 "Value not derived - data not usable", add 
label values xf1c132 label_xf1c132
label define label_xf1c133 10 "Reported" 
label define label_xf1c133 11 "Analyst corrected reported value", add 
label define label_xf1c133 12 "Data generated from other data values", add 
label define label_xf1c133 13 "Implied zero", add 
label define label_xf1c133 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c133 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c133 22 "Imputed using the Group Median procedure", add 
label define label_xf1c133 23 "Logical imputation", add 
label define label_xf1c133 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c133 30 "Not applicable", add 
label define label_xf1c133 31 "Institution left item blank", add 
label define label_xf1c133 32 "Do not know", add 
label define label_xf1c133 33 "Particular 1st prof field not applicable", add 
label define label_xf1c133 50 "Outlier value derived from reported data", add 
label define label_xf1c133 51 "Outlier value derived from imported data", add 
label define label_xf1c133 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c133 53 "Value not derived - data not usable", add 
label values xf1c133 label_xf1c133
label define label_xf1c134 10 "Reported" 
label define label_xf1c134 11 "Analyst corrected reported value", add 
label define label_xf1c134 12 "Data generated from other data values", add 
label define label_xf1c134 13 "Implied zero", add 
label define label_xf1c134 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c134 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c134 22 "Imputed using the Group Median procedure", add 
label define label_xf1c134 23 "Logical imputation", add 
label define label_xf1c134 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c134 30 "Not applicable", add 
label define label_xf1c134 31 "Institution left item blank", add 
label define label_xf1c134 32 "Do not know", add 
label define label_xf1c134 33 "Particular 1st prof field not applicable", add 
label define label_xf1c134 50 "Outlier value derived from reported data", add 
label define label_xf1c134 51 "Outlier value derived from imported data", add 
label define label_xf1c134 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c134 53 "Value not derived - data not usable", add 
label values xf1c134 label_xf1c134
label define label_xf1c135 10 "Reported" 
label define label_xf1c135 11 "Analyst corrected reported value", add 
label define label_xf1c135 12 "Data generated from other data values", add 
label define label_xf1c135 13 "Implied zero", add 
label define label_xf1c135 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c135 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c135 22 "Imputed using the Group Median procedure", add 
label define label_xf1c135 23 "Logical imputation", add 
label define label_xf1c135 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c135 30 "Not applicable", add 
label define label_xf1c135 31 "Institution left item blank", add 
label define label_xf1c135 32 "Do not know", add 
label define label_xf1c135 33 "Particular 1st prof field not applicable", add 
label define label_xf1c135 50 "Outlier value derived from reported data", add 
label define label_xf1c135 51 "Outlier value derived from imported data", add 
label define label_xf1c135 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c135 53 "Value not derived - data not usable", add 
label values xf1c135 label_xf1c135
label define label_xf1c141 10 "Reported" 
label define label_xf1c141 11 "Analyst corrected reported value", add 
label define label_xf1c141 12 "Data generated from other data values", add 
label define label_xf1c141 13 "Implied zero", add 
label define label_xf1c141 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c141 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c141 22 "Imputed using the Group Median procedure", add 
label define label_xf1c141 23 "Logical imputation", add 
label define label_xf1c141 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c141 30 "Not applicable", add 
label define label_xf1c141 31 "Institution left item blank", add 
label define label_xf1c141 32 "Do not know", add 
label define label_xf1c141 33 "Particular 1st prof field not applicable", add 
label define label_xf1c141 50 "Outlier value derived from reported data", add 
label define label_xf1c141 51 "Outlier value derived from imported data", add 
label define label_xf1c141 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c141 53 "Value not derived - data not usable", add 
label values xf1c141 label_xf1c141
label define label_xf1c142 10 "Reported" 
label define label_xf1c142 11 "Analyst corrected reported value", add 
label define label_xf1c142 12 "Data generated from other data values", add 
label define label_xf1c142 13 "Implied zero", add 
label define label_xf1c142 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c142 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c142 22 "Imputed using the Group Median procedure", add 
label define label_xf1c142 23 "Logical imputation", add 
label define label_xf1c142 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c142 30 "Not applicable", add 
label define label_xf1c142 31 "Institution left item blank", add 
label define label_xf1c142 32 "Do not know", add 
label define label_xf1c142 33 "Particular 1st prof field not applicable", add 
label define label_xf1c142 50 "Outlier value derived from reported data", add 
label define label_xf1c142 51 "Outlier value derived from imported data", add 
label define label_xf1c142 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c142 53 "Value not derived - data not usable", add 
label values xf1c142 label_xf1c142
label define label_xf1c143 10 "Reported" 
label define label_xf1c143 11 "Analyst corrected reported value", add 
label define label_xf1c143 12 "Data generated from other data values", add 
label define label_xf1c143 13 "Implied zero", add 
label define label_xf1c143 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c143 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c143 22 "Imputed using the Group Median procedure", add 
label define label_xf1c143 23 "Logical imputation", add 
label define label_xf1c143 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c143 30 "Not applicable", add 
label define label_xf1c143 31 "Institution left item blank", add 
label define label_xf1c143 32 "Do not know", add 
label define label_xf1c143 33 "Particular 1st prof field not applicable", add 
label define label_xf1c143 50 "Outlier value derived from reported data", add 
label define label_xf1c143 51 "Outlier value derived from imported data", add 
label define label_xf1c143 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c143 53 "Value not derived - data not usable", add 
label values xf1c143 label_xf1c143
label define label_xf1c144 10 "Reported" 
label define label_xf1c144 11 "Analyst corrected reported value", add 
label define label_xf1c144 12 "Data generated from other data values", add 
label define label_xf1c144 13 "Implied zero", add 
label define label_xf1c144 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c144 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c144 22 "Imputed using the Group Median procedure", add 
label define label_xf1c144 23 "Logical imputation", add 
label define label_xf1c144 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c144 30 "Not applicable", add 
label define label_xf1c144 31 "Institution left item blank", add 
label define label_xf1c144 32 "Do not know", add 
label define label_xf1c144 33 "Particular 1st prof field not applicable", add 
label define label_xf1c144 50 "Outlier value derived from reported data", add 
label define label_xf1c144 51 "Outlier value derived from imported data", add 
label define label_xf1c144 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c144 53 "Value not derived - data not usable", add 
label values xf1c144 label_xf1c144
label define label_xf1c145 10 "Reported" 
label define label_xf1c145 11 "Analyst corrected reported value", add 
label define label_xf1c145 12 "Data generated from other data values", add 
label define label_xf1c145 13 "Implied zero", add 
label define label_xf1c145 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c145 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c145 22 "Imputed using the Group Median procedure", add 
label define label_xf1c145 23 "Logical imputation", add 
label define label_xf1c145 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c145 30 "Not applicable", add 
label define label_xf1c145 31 "Institution left item blank", add 
label define label_xf1c145 32 "Do not know", add 
label define label_xf1c145 33 "Particular 1st prof field not applicable", add 
label define label_xf1c145 50 "Outlier value derived from reported data", add 
label define label_xf1c145 51 "Outlier value derived from imported data", add 
label define label_xf1c145 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c145 53 "Value not derived - data not usable", add 
label values xf1c145 label_xf1c145
label define label_xf1c151 10 "Reported" 
label define label_xf1c151 11 "Analyst corrected reported value", add 
label define label_xf1c151 12 "Data generated from other data values", add 
label define label_xf1c151 13 "Implied zero", add 
label define label_xf1c151 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c151 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c151 22 "Imputed using the Group Median procedure", add 
label define label_xf1c151 23 "Logical imputation", add 
label define label_xf1c151 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c151 30 "Not applicable", add 
label define label_xf1c151 31 "Institution left item blank", add 
label define label_xf1c151 32 "Do not know", add 
label define label_xf1c151 33 "Particular 1st prof field not applicable", add 
label define label_xf1c151 50 "Outlier value derived from reported data", add 
label define label_xf1c151 51 "Outlier value derived from imported data", add 
label define label_xf1c151 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c151 53 "Value not derived - data not usable", add 
label values xf1c151 label_xf1c151
label define label_xf1c152 10 "Reported" 
label define label_xf1c152 11 "Analyst corrected reported value", add 
label define label_xf1c152 12 "Data generated from other data values", add 
label define label_xf1c152 13 "Implied zero", add 
label define label_xf1c152 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c152 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c152 22 "Imputed using the Group Median procedure", add 
label define label_xf1c152 23 "Logical imputation", add 
label define label_xf1c152 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c152 30 "Not applicable", add 
label define label_xf1c152 31 "Institution left item blank", add 
label define label_xf1c152 32 "Do not know", add 
label define label_xf1c152 33 "Particular 1st prof field not applicable", add 
label define label_xf1c152 50 "Outlier value derived from reported data", add 
label define label_xf1c152 51 "Outlier value derived from imported data", add 
label define label_xf1c152 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c152 53 "Value not derived - data not usable", add 
label values xf1c152 label_xf1c152
label define label_xf1c153 10 "Reported" 
label define label_xf1c153 11 "Analyst corrected reported value", add 
label define label_xf1c153 12 "Data generated from other data values", add 
label define label_xf1c153 13 "Implied zero", add 
label define label_xf1c153 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c153 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c153 22 "Imputed using the Group Median procedure", add 
label define label_xf1c153 23 "Logical imputation", add 
label define label_xf1c153 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c153 30 "Not applicable", add 
label define label_xf1c153 31 "Institution left item blank", add 
label define label_xf1c153 32 "Do not know", add 
label define label_xf1c153 33 "Particular 1st prof field not applicable", add 
label define label_xf1c153 50 "Outlier value derived from reported data", add 
label define label_xf1c153 51 "Outlier value derived from imported data", add 
label define label_xf1c153 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c153 53 "Value not derived - data not usable", add 
label values xf1c153 label_xf1c153
label define label_xf1c154 10 "Reported" 
label define label_xf1c154 11 "Analyst corrected reported value", add 
label define label_xf1c154 12 "Data generated from other data values", add 
label define label_xf1c154 13 "Implied zero", add 
label define label_xf1c154 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c154 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c154 22 "Imputed using the Group Median procedure", add 
label define label_xf1c154 23 "Logical imputation", add 
label define label_xf1c154 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c154 30 "Not applicable", add 
label define label_xf1c154 31 "Institution left item blank", add 
label define label_xf1c154 32 "Do not know", add 
label define label_xf1c154 33 "Particular 1st prof field not applicable", add 
label define label_xf1c154 50 "Outlier value derived from reported data", add 
label define label_xf1c154 51 "Outlier value derived from imported data", add 
label define label_xf1c154 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c154 53 "Value not derived - data not usable", add 
label values xf1c154 label_xf1c154
label define label_xf1c155 10 "Reported" 
label define label_xf1c155 11 "Analyst corrected reported value", add 
label define label_xf1c155 12 "Data generated from other data values", add 
label define label_xf1c155 13 "Implied zero", add 
label define label_xf1c155 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c155 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c155 22 "Imputed using the Group Median procedure", add 
label define label_xf1c155 23 "Logical imputation", add 
label define label_xf1c155 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c155 30 "Not applicable", add 
label define label_xf1c155 31 "Institution left item blank", add 
label define label_xf1c155 32 "Do not know", add 
label define label_xf1c155 33 "Particular 1st prof field not applicable", add 
label define label_xf1c155 50 "Outlier value derived from reported data", add 
label define label_xf1c155 51 "Outlier value derived from imported data", add 
label define label_xf1c155 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c155 53 "Value not derived - data not usable", add 
label values xf1c155 label_xf1c155
label define label_xf1c161 10 "Reported" 
label define label_xf1c161 11 "Analyst corrected reported value", add 
label define label_xf1c161 12 "Data generated from other data values", add 
label define label_xf1c161 13 "Implied zero", add 
label define label_xf1c161 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c161 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c161 22 "Imputed using the Group Median procedure", add 
label define label_xf1c161 23 "Logical imputation", add 
label define label_xf1c161 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c161 30 "Not applicable", add 
label define label_xf1c161 31 "Institution left item blank", add 
label define label_xf1c161 32 "Do not know", add 
label define label_xf1c161 33 "Particular 1st prof field not applicable", add 
label define label_xf1c161 50 "Outlier value derived from reported data", add 
label define label_xf1c161 51 "Outlier value derived from imported data", add 
label define label_xf1c161 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c161 53 "Value not derived - data not usable", add 
label values xf1c161 label_xf1c161
label define label_xf1c165 10 "Reported" 
label define label_xf1c165 11 "Analyst corrected reported value", add 
label define label_xf1c165 12 "Data generated from other data values", add 
label define label_xf1c165 13 "Implied zero", add 
label define label_xf1c165 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c165 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c165 22 "Imputed using the Group Median procedure", add 
label define label_xf1c165 23 "Logical imputation", add 
label define label_xf1c165 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c165 30 "Not applicable", add 
label define label_xf1c165 31 "Institution left item blank", add 
label define label_xf1c165 32 "Do not know", add 
label define label_xf1c165 33 "Particular 1st prof field not applicable", add 
label define label_xf1c165 50 "Outlier value derived from reported data", add 
label define label_xf1c165 51 "Outlier value derived from imported data", add 
label define label_xf1c165 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c165 53 "Value not derived - data not usable", add 
label values xf1c165 label_xf1c165
label define label_xf1c171 10 "Reported" 
label define label_xf1c171 11 "Analyst corrected reported value", add 
label define label_xf1c171 12 "Data generated from other data values", add 
label define label_xf1c171 13 "Implied zero", add 
label define label_xf1c171 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c171 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c171 22 "Imputed using the Group Median procedure", add 
label define label_xf1c171 23 "Logical imputation", add 
label define label_xf1c171 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c171 30 "Not applicable", add 
label define label_xf1c171 31 "Institution left item blank", add 
label define label_xf1c171 32 "Do not know", add 
label define label_xf1c171 33 "Particular 1st prof field not applicable", add 
label define label_xf1c171 50 "Outlier value derived from reported data", add 
label define label_xf1c171 51 "Outlier value derived from imported data", add 
label define label_xf1c171 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c171 53 "Value not derived - data not usable", add 
label values xf1c171 label_xf1c171
label define label_xf1c172 10 "Reported" 
label define label_xf1c172 11 "Analyst corrected reported value", add 
label define label_xf1c172 12 "Data generated from other data values", add 
label define label_xf1c172 13 "Implied zero", add 
label define label_xf1c172 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c172 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c172 22 "Imputed using the Group Median procedure", add 
label define label_xf1c172 23 "Logical imputation", add 
label define label_xf1c172 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c172 30 "Not applicable", add 
label define label_xf1c172 31 "Institution left item blank", add 
label define label_xf1c172 32 "Do not know", add 
label define label_xf1c172 33 "Particular 1st prof field not applicable", add 
label define label_xf1c172 50 "Outlier value derived from reported data", add 
label define label_xf1c172 51 "Outlier value derived from imported data", add 
label define label_xf1c172 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c172 53 "Value not derived - data not usable", add 
label values xf1c172 label_xf1c172
label define label_xf1c173 10 "Reported" 
label define label_xf1c173 11 "Analyst corrected reported value", add 
label define label_xf1c173 12 "Data generated from other data values", add 
label define label_xf1c173 13 "Implied zero", add 
label define label_xf1c173 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c173 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c173 22 "Imputed using the Group Median procedure", add 
label define label_xf1c173 23 "Logical imputation", add 
label define label_xf1c173 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c173 30 "Not applicable", add 
label define label_xf1c173 31 "Institution left item blank", add 
label define label_xf1c173 32 "Do not know", add 
label define label_xf1c173 33 "Particular 1st prof field not applicable", add 
label define label_xf1c173 50 "Outlier value derived from reported data", add 
label define label_xf1c173 51 "Outlier value derived from imported data", add 
label define label_xf1c173 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c173 53 "Value not derived - data not usable", add 
label values xf1c173 label_xf1c173
label define label_xf1c174 10 "Reported" 
label define label_xf1c174 11 "Analyst corrected reported value", add 
label define label_xf1c174 12 "Data generated from other data values", add 
label define label_xf1c174 13 "Implied zero", add 
label define label_xf1c174 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c174 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c174 22 "Imputed using the Group Median procedure", add 
label define label_xf1c174 23 "Logical imputation", add 
label define label_xf1c174 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c174 30 "Not applicable", add 
label define label_xf1c174 31 "Institution left item blank", add 
label define label_xf1c174 32 "Do not know", add 
label define label_xf1c174 33 "Particular 1st prof field not applicable", add 
label define label_xf1c174 50 "Outlier value derived from reported data", add 
label define label_xf1c174 51 "Outlier value derived from imported data", add 
label define label_xf1c174 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c174 53 "Value not derived - data not usable", add 
label values xf1c174 label_xf1c174
label define label_xf1c175 10 "Reported" 
label define label_xf1c175 11 "Analyst corrected reported value", add 
label define label_xf1c175 12 "Data generated from other data values", add 
label define label_xf1c175 13 "Implied zero", add 
label define label_xf1c175 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c175 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c175 22 "Imputed using the Group Median procedure", add 
label define label_xf1c175 23 "Logical imputation", add 
label define label_xf1c175 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c175 30 "Not applicable", add 
label define label_xf1c175 31 "Institution left item blank", add 
label define label_xf1c175 32 "Do not know", add 
label define label_xf1c175 33 "Particular 1st prof field not applicable", add 
label define label_xf1c175 50 "Outlier value derived from reported data", add 
label define label_xf1c175 51 "Outlier value derived from imported data", add 
label define label_xf1c175 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c175 53 "Value not derived - data not usable", add 
label values xf1c175 label_xf1c175
label define label_xf1c181 10 "Reported" 
label define label_xf1c181 11 "Analyst corrected reported value", add 
label define label_xf1c181 12 "Data generated from other data values", add 
label define label_xf1c181 13 "Implied zero", add 
label define label_xf1c181 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c181 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c181 22 "Imputed using the Group Median procedure", add 
label define label_xf1c181 23 "Logical imputation", add 
label define label_xf1c181 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c181 30 "Not applicable", add 
label define label_xf1c181 31 "Institution left item blank", add 
label define label_xf1c181 32 "Do not know", add 
label define label_xf1c181 33 "Particular 1st prof field not applicable", add 
label define label_xf1c181 50 "Outlier value derived from reported data", add 
label define label_xf1c181 51 "Outlier value derived from imported data", add 
label define label_xf1c181 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c181 53 "Value not derived - data not usable", add 
label values xf1c181 label_xf1c181
label define label_xf1c182 10 "Reported" 
label define label_xf1c182 11 "Analyst corrected reported value", add 
label define label_xf1c182 12 "Data generated from other data values", add 
label define label_xf1c182 13 "Implied zero", add 
label define label_xf1c182 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c182 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c182 22 "Imputed using the Group Median procedure", add 
label define label_xf1c182 23 "Logical imputation", add 
label define label_xf1c182 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c182 30 "Not applicable", add 
label define label_xf1c182 31 "Institution left item blank", add 
label define label_xf1c182 32 "Do not know", add 
label define label_xf1c182 33 "Particular 1st prof field not applicable", add 
label define label_xf1c182 50 "Outlier value derived from reported data", add 
label define label_xf1c182 51 "Outlier value derived from imported data", add 
label define label_xf1c182 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c182 53 "Value not derived - data not usable", add 
label values xf1c182 label_xf1c182
label define label_xf1c183 10 "Reported" 
label define label_xf1c183 11 "Analyst corrected reported value", add 
label define label_xf1c183 12 "Data generated from other data values", add 
label define label_xf1c183 13 "Implied zero", add 
label define label_xf1c183 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c183 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c183 22 "Imputed using the Group Median procedure", add 
label define label_xf1c183 23 "Logical imputation", add 
label define label_xf1c183 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c183 30 "Not applicable", add 
label define label_xf1c183 31 "Institution left item blank", add 
label define label_xf1c183 32 "Do not know", add 
label define label_xf1c183 33 "Particular 1st prof field not applicable", add 
label define label_xf1c183 50 "Outlier value derived from reported data", add 
label define label_xf1c183 51 "Outlier value derived from imported data", add 
label define label_xf1c183 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c183 53 "Value not derived - data not usable", add 
label values xf1c183 label_xf1c183
label define label_xf1c184 10 "Reported" 
label define label_xf1c184 11 "Analyst corrected reported value", add 
label define label_xf1c184 12 "Data generated from other data values", add 
label define label_xf1c184 13 "Implied zero", add 
label define label_xf1c184 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c184 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c184 22 "Imputed using the Group Median procedure", add 
label define label_xf1c184 23 "Logical imputation", add 
label define label_xf1c184 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c184 30 "Not applicable", add 
label define label_xf1c184 31 "Institution left item blank", add 
label define label_xf1c184 32 "Do not know", add 
label define label_xf1c184 33 "Particular 1st prof field not applicable", add 
label define label_xf1c184 50 "Outlier value derived from reported data", add 
label define label_xf1c184 51 "Outlier value derived from imported data", add 
label define label_xf1c184 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c184 53 "Value not derived - data not usable", add 
label values xf1c184 label_xf1c184
label define label_xf1c185 10 "Reported" 
label define label_xf1c185 11 "Analyst corrected reported value", add 
label define label_xf1c185 12 "Data generated from other data values", add 
label define label_xf1c185 13 "Implied zero", add 
label define label_xf1c185 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c185 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c185 22 "Imputed using the Group Median procedure", add 
label define label_xf1c185 23 "Logical imputation", add 
label define label_xf1c185 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c185 30 "Not applicable", add 
label define label_xf1c185 31 "Institution left item blank", add 
label define label_xf1c185 32 "Do not know", add 
label define label_xf1c185 33 "Particular 1st prof field not applicable", add 
label define label_xf1c185 50 "Outlier value derived from reported data", add 
label define label_xf1c185 51 "Outlier value derived from imported data", add 
label define label_xf1c185 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c185 53 "Value not derived - data not usable", add 
label values xf1c185 label_xf1c185
label define label_xf1c191 10 "Reported" 
label define label_xf1c191 11 "Analyst corrected reported value", add 
label define label_xf1c191 12 "Data generated from other data values", add 
label define label_xf1c191 13 "Implied zero", add 
label define label_xf1c191 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c191 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c191 22 "Imputed using the Group Median procedure", add 
label define label_xf1c191 23 "Logical imputation", add 
label define label_xf1c191 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c191 30 "Not applicable", add 
label define label_xf1c191 31 "Institution left item blank", add 
label define label_xf1c191 32 "Do not know", add 
label define label_xf1c191 33 "Particular 1st prof field not applicable", add 
label define label_xf1c191 50 "Outlier value derived from reported data", add 
label define label_xf1c191 51 "Outlier value derived from imported data", add 
label define label_xf1c191 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c191 53 "Value not derived - data not usable", add 
label values xf1c191 label_xf1c191
label define label_xf1c192 10 "Reported" 
label define label_xf1c192 11 "Analyst corrected reported value", add 
label define label_xf1c192 12 "Data generated from other data values", add 
label define label_xf1c192 13 "Implied zero", add 
label define label_xf1c192 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c192 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c192 22 "Imputed using the Group Median procedure", add 
label define label_xf1c192 23 "Logical imputation", add 
label define label_xf1c192 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c192 30 "Not applicable", add 
label define label_xf1c192 31 "Institution left item blank", add 
label define label_xf1c192 32 "Do not know", add 
label define label_xf1c192 33 "Particular 1st prof field not applicable", add 
label define label_xf1c192 50 "Outlier value derived from reported data", add 
label define label_xf1c192 51 "Outlier value derived from imported data", add 
label define label_xf1c192 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c192 53 "Value not derived - data not usable", add 
label values xf1c192 label_xf1c192
label define label_xf1c193 10 "Reported" 
label define label_xf1c193 11 "Analyst corrected reported value", add 
label define label_xf1c193 12 "Data generated from other data values", add 
label define label_xf1c193 13 "Implied zero", add 
label define label_xf1c193 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c193 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c193 22 "Imputed using the Group Median procedure", add 
label define label_xf1c193 23 "Logical imputation", add 
label define label_xf1c193 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c193 30 "Not applicable", add 
label define label_xf1c193 31 "Institution left item blank", add 
label define label_xf1c193 32 "Do not know", add 
label define label_xf1c193 33 "Particular 1st prof field not applicable", add 
label define label_xf1c193 50 "Outlier value derived from reported data", add 
label define label_xf1c193 51 "Outlier value derived from imported data", add 
label define label_xf1c193 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c193 53 "Value not derived - data not usable", add 
label values xf1c193 label_xf1c193
label define label_xf1c194 10 "Reported" 
label define label_xf1c194 11 "Analyst corrected reported value", add 
label define label_xf1c194 12 "Data generated from other data values", add 
label define label_xf1c194 13 "Implied zero", add 
label define label_xf1c194 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c194 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c194 22 "Imputed using the Group Median procedure", add 
label define label_xf1c194 23 "Logical imputation", add 
label define label_xf1c194 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c194 30 "Not applicable", add 
label define label_xf1c194 31 "Institution left item blank", add 
label define label_xf1c194 32 "Do not know", add 
label define label_xf1c194 33 "Particular 1st prof field not applicable", add 
label define label_xf1c194 50 "Outlier value derived from reported data", add 
label define label_xf1c194 51 "Outlier value derived from imported data", add 
label define label_xf1c194 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c194 53 "Value not derived - data not usable", add 
label values xf1c194 label_xf1c194
label define label_xf1c195 10 "Reported" 
label define label_xf1c195 11 "Analyst corrected reported value", add 
label define label_xf1c195 12 "Data generated from other data values", add 
label define label_xf1c195 13 "Implied zero", add 
label define label_xf1c195 20 "Imputed using Carry Forward procedure", add 
label define label_xf1c195 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1c195 22 "Imputed using the Group Median procedure", add 
label define label_xf1c195 23 "Logical imputation", add 
label define label_xf1c195 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1c195 30 "Not applicable", add 
label define label_xf1c195 31 "Institution left item blank", add 
label define label_xf1c195 32 "Do not know", add 
label define label_xf1c195 33 "Particular 1st prof field not applicable", add 
label define label_xf1c195 50 "Outlier value derived from reported data", add 
label define label_xf1c195 51 "Outlier value derived from imported data", add 
label define label_xf1c195 52 "Value not derived - parent/child differs across components", add 
label define label_xf1c195 53 "Value not derived - data not usable", add 
label values xf1c195 label_xf1c195
label define label_xf1d01 10 "Reported" 
label define label_xf1d01 11 "Analyst corrected reported value", add 
label define label_xf1d01 12 "Data generated from other data values", add 
label define label_xf1d01 13 "Implied zero", add 
label define label_xf1d01 20 "Imputed using Carry Forward procedure", add 
label define label_xf1d01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1d01 22 "Imputed using the Group Median procedure", add 
label define label_xf1d01 23 "Logical imputation", add 
label define label_xf1d01 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1d01 30 "Not applicable", add 
label define label_xf1d01 31 "Institution left item blank", add 
label define label_xf1d01 32 "Do not know", add 
label define label_xf1d01 33 "Particular 1st prof field not applicable", add 
label define label_xf1d01 50 "Outlier value derived from reported data", add 
label define label_xf1d01 51 "Outlier value derived from imported data", add 
label define label_xf1d01 52 "Value not derived - parent/child differs across components", add 
label define label_xf1d01 53 "Value not derived - data not usable", add 
label values xf1d01 label_xf1d01
label define label_xf1d02 10 "Reported" 
label define label_xf1d02 11 "Analyst corrected reported value", add 
label define label_xf1d02 12 "Data generated from other data values", add 
label define label_xf1d02 13 "Implied zero", add 
label define label_xf1d02 20 "Imputed using Carry Forward procedure", add 
label define label_xf1d02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1d02 22 "Imputed using the Group Median procedure", add 
label define label_xf1d02 23 "Logical imputation", add 
label define label_xf1d02 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1d02 30 "Not applicable", add 
label define label_xf1d02 31 "Institution left item blank", add 
label define label_xf1d02 32 "Do not know", add 
label define label_xf1d02 33 "Particular 1st prof field not applicable", add 
label define label_xf1d02 50 "Outlier value derived from reported data", add 
label define label_xf1d02 51 "Outlier value derived from imported data", add 
label define label_xf1d02 52 "Value not derived - parent/child differs across components", add 
label define label_xf1d02 53 "Value not derived - data not usable", add 
label values xf1d02 label_xf1d02
label define label_xf1d03 10 "Reported" 
label define label_xf1d03 11 "Analyst corrected reported value", add 
label define label_xf1d03 12 "Data generated from other data values", add 
label define label_xf1d03 13 "Implied zero", add 
label define label_xf1d03 20 "Imputed using Carry Forward procedure", add 
label define label_xf1d03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1d03 22 "Imputed using the Group Median procedure", add 
label define label_xf1d03 23 "Logical imputation", add 
label define label_xf1d03 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1d03 30 "Not applicable", add 
label define label_xf1d03 31 "Institution left item blank", add 
label define label_xf1d03 32 "Do not know", add 
label define label_xf1d03 33 "Particular 1st prof field not applicable", add 
label define label_xf1d03 50 "Outlier value derived from reported data", add 
label define label_xf1d03 51 "Outlier value derived from imported data", add 
label define label_xf1d03 52 "Value not derived - parent/child differs across components", add 
label define label_xf1d03 53 "Value not derived - data not usable", add 
label values xf1d03 label_xf1d03
label define label_xf1d04 10 "Reported" 
label define label_xf1d04 11 "Analyst corrected reported value", add 
label define label_xf1d04 12 "Data generated from other data values", add 
label define label_xf1d04 13 "Implied zero", add 
label define label_xf1d04 20 "Imputed using Carry Forward procedure", add 
label define label_xf1d04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1d04 22 "Imputed using the Group Median procedure", add 
label define label_xf1d04 23 "Logical imputation", add 
label define label_xf1d04 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1d04 30 "Not applicable", add 
label define label_xf1d04 31 "Institution left item blank", add 
label define label_xf1d04 32 "Do not know", add 
label define label_xf1d04 33 "Particular 1st prof field not applicable", add 
label define label_xf1d04 50 "Outlier value derived from reported data", add 
label define label_xf1d04 51 "Outlier value derived from imported data", add 
label define label_xf1d04 52 "Value not derived - parent/child differs across components", add 
label define label_xf1d04 53 "Value not derived - data not usable", add 
label values xf1d04 label_xf1d04
label define label_xf1d05 10 "Reported" 
label define label_xf1d05 11 "Analyst corrected reported value", add 
label define label_xf1d05 12 "Data generated from other data values", add 
label define label_xf1d05 13 "Implied zero", add 
label define label_xf1d05 20 "Imputed using Carry Forward procedure", add 
label define label_xf1d05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1d05 22 "Imputed using the Group Median procedure", add 
label define label_xf1d05 23 "Logical imputation", add 
label define label_xf1d05 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1d05 30 "Not applicable", add 
label define label_xf1d05 31 "Institution left item blank", add 
label define label_xf1d05 32 "Do not know", add 
label define label_xf1d05 33 "Particular 1st prof field not applicable", add 
label define label_xf1d05 50 "Outlier value derived from reported data", add 
label define label_xf1d05 51 "Outlier value derived from imported data", add 
label define label_xf1d05 52 "Value not derived - parent/child differs across components", add 
label define label_xf1d05 53 "Value not derived - data not usable", add 
label values xf1d05 label_xf1d05
label define label_xf1d06 10 "Reported" 
label define label_xf1d06 11 "Analyst corrected reported value", add 
label define label_xf1d06 12 "Data generated from other data values", add 
label define label_xf1d06 13 "Implied zero", add 
label define label_xf1d06 20 "Imputed using Carry Forward procedure", add 
label define label_xf1d06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1d06 22 "Imputed using the Group Median procedure", add 
label define label_xf1d06 23 "Logical imputation", add 
label define label_xf1d06 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1d06 30 "Not applicable", add 
label define label_xf1d06 31 "Institution left item blank", add 
label define label_xf1d06 32 "Do not know", add 
label define label_xf1d06 33 "Particular 1st prof field not applicable", add 
label define label_xf1d06 50 "Outlier value derived from reported data", add 
label define label_xf1d06 51 "Outlier value derived from imported data", add 
label define label_xf1d06 52 "Value not derived - parent/child differs across components", add 
label define label_xf1d06 53 "Value not derived - data not usable", add 
label values xf1d06 label_xf1d06
label define label_xf1h01 10 "Reported" 
label define label_xf1h01 11 "Analyst corrected reported value", add 
label define label_xf1h01 12 "Data generated from other data values", add 
label define label_xf1h01 13 "Implied zero", add 
label define label_xf1h01 20 "Imputed using Carry Forward procedure", add 
label define label_xf1h01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1h01 22 "Imputed using the Group Median procedure", add 
label define label_xf1h01 23 "Logical imputation", add 
label define label_xf1h01 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1h01 30 "Not applicable", add 
label define label_xf1h01 31 "Institution left item blank", add 
label define label_xf1h01 32 "Do not know", add 
label define label_xf1h01 33 "Particular 1st prof field not applicable", add 
label define label_xf1h01 50 "Outlier value derived from reported data", add 
label define label_xf1h01 51 "Outlier value derived from imported data", add 
label define label_xf1h01 52 "Value not derived - parent/child differs across components", add 
label define label_xf1h01 53 "Value not derived - data not usable", add 
label values xf1h01 label_xf1h01
label define label_xf1h02 10 "Reported" 
label define label_xf1h02 11 "Analyst corrected reported value", add 
label define label_xf1h02 12 "Data generated from other data values", add 
label define label_xf1h02 13 "Implied zero", add 
label define label_xf1h02 20 "Imputed using Carry Forward procedure", add 
label define label_xf1h02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1h02 22 "Imputed using the Group Median procedure", add 
label define label_xf1h02 23 "Logical imputation", add 
label define label_xf1h02 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1h02 30 "Not applicable", add 
label define label_xf1h02 31 "Institution left item blank", add 
label define label_xf1h02 32 "Do not know", add 
label define label_xf1h02 33 "Particular 1st prof field not applicable", add 
label define label_xf1h02 50 "Outlier value derived from reported data", add 
label define label_xf1h02 51 "Outlier value derived from imported data", add 
label define label_xf1h02 52 "Value not derived - parent/child differs across components", add 
label define label_xf1h02 53 "Value not derived - data not usable", add 
label values xf1h02 label_xf1h02
label define label_xf1e01 10 "Reported" 
label define label_xf1e01 11 "Analyst corrected reported value", add 
label define label_xf1e01 12 "Data generated from other data values", add 
label define label_xf1e01 13 "Implied zero", add 
label define label_xf1e01 20 "Imputed using Carry Forward procedure", add 
label define label_xf1e01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1e01 22 "Imputed using the Group Median procedure", add 
label define label_xf1e01 23 "Logical imputation", add 
label define label_xf1e01 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1e01 30 "Not applicable", add 
label define label_xf1e01 31 "Institution left item blank", add 
label define label_xf1e01 32 "Do not know", add 
label define label_xf1e01 33 "Particular 1st prof field not applicable", add 
label define label_xf1e01 50 "Outlier value derived from reported data", add 
label define label_xf1e01 51 "Outlier value derived from imported data", add 
label define label_xf1e01 52 "Value not derived - parent/child differs across components", add 
label define label_xf1e01 53 "Value not derived - data not usable", add 
label values xf1e01 label_xf1e01
label define label_xf1e02 10 "Reported" 
label define label_xf1e02 11 "Analyst corrected reported value", add 
label define label_xf1e02 12 "Data generated from other data values", add 
label define label_xf1e02 13 "Implied zero", add 
label define label_xf1e02 20 "Imputed using Carry Forward procedure", add 
label define label_xf1e02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1e02 22 "Imputed using the Group Median procedure", add 
label define label_xf1e02 23 "Logical imputation", add 
label define label_xf1e02 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1e02 30 "Not applicable", add 
label define label_xf1e02 31 "Institution left item blank", add 
label define label_xf1e02 32 "Do not know", add 
label define label_xf1e02 33 "Particular 1st prof field not applicable", add 
label define label_xf1e02 50 "Outlier value derived from reported data", add 
label define label_xf1e02 51 "Outlier value derived from imported data", add 
label define label_xf1e02 52 "Value not derived - parent/child differs across components", add 
label define label_xf1e02 53 "Value not derived - data not usable", add 
label values xf1e02 label_xf1e02
label define label_xf1e03 10 "Reported" 
label define label_xf1e03 11 "Analyst corrected reported value", add 
label define label_xf1e03 12 "Data generated from other data values", add 
label define label_xf1e03 13 "Implied zero", add 
label define label_xf1e03 20 "Imputed using Carry Forward procedure", add 
label define label_xf1e03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1e03 22 "Imputed using the Group Median procedure", add 
label define label_xf1e03 23 "Logical imputation", add 
label define label_xf1e03 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1e03 30 "Not applicable", add 
label define label_xf1e03 31 "Institution left item blank", add 
label define label_xf1e03 32 "Do not know", add 
label define label_xf1e03 33 "Particular 1st prof field not applicable", add 
label define label_xf1e03 50 "Outlier value derived from reported data", add 
label define label_xf1e03 51 "Outlier value derived from imported data", add 
label define label_xf1e03 52 "Value not derived - parent/child differs across components", add 
label define label_xf1e03 53 "Value not derived - data not usable", add 
label values xf1e03 label_xf1e03
label define label_xf1e04 10 "Reported" 
label define label_xf1e04 11 "Analyst corrected reported value", add 
label define label_xf1e04 12 "Data generated from other data values", add 
label define label_xf1e04 13 "Implied zero", add 
label define label_xf1e04 20 "Imputed using Carry Forward procedure", add 
label define label_xf1e04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1e04 22 "Imputed using the Group Median procedure", add 
label define label_xf1e04 23 "Logical imputation", add 
label define label_xf1e04 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1e04 30 "Not applicable", add 
label define label_xf1e04 31 "Institution left item blank", add 
label define label_xf1e04 32 "Do not know", add 
label define label_xf1e04 33 "Particular 1st prof field not applicable", add 
label define label_xf1e04 50 "Outlier value derived from reported data", add 
label define label_xf1e04 51 "Outlier value derived from imported data", add 
label define label_xf1e04 52 "Value not derived - parent/child differs across components", add 
label define label_xf1e04 53 "Value not derived - data not usable", add 
label values xf1e04 label_xf1e04
label define label_xf1e05 10 "Reported" 
label define label_xf1e05 11 "Analyst corrected reported value", add 
label define label_xf1e05 12 "Data generated from other data values", add 
label define label_xf1e05 13 "Implied zero", add 
label define label_xf1e05 20 "Imputed using Carry Forward procedure", add 
label define label_xf1e05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1e05 22 "Imputed using the Group Median procedure", add 
label define label_xf1e05 23 "Logical imputation", add 
label define label_xf1e05 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1e05 30 "Not applicable", add 
label define label_xf1e05 31 "Institution left item blank", add 
label define label_xf1e05 32 "Do not know", add 
label define label_xf1e05 33 "Particular 1st prof field not applicable", add 
label define label_xf1e05 50 "Outlier value derived from reported data", add 
label define label_xf1e05 51 "Outlier value derived from imported data", add 
label define label_xf1e05 52 "Value not derived - parent/child differs across components", add 
label define label_xf1e05 53 "Value not derived - data not usable", add 
label values xf1e05 label_xf1e05
label define label_xf1e06 10 "Reported" 
label define label_xf1e06 11 "Analyst corrected reported value", add 
label define label_xf1e06 12 "Data generated from other data values", add 
label define label_xf1e06 13 "Implied zero", add 
label define label_xf1e06 20 "Imputed using Carry Forward procedure", add 
label define label_xf1e06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1e06 22 "Imputed using the Group Median procedure", add 
label define label_xf1e06 23 "Logical imputation", add 
label define label_xf1e06 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1e06 30 "Not applicable", add 
label define label_xf1e06 31 "Institution left item blank", add 
label define label_xf1e06 32 "Do not know", add 
label define label_xf1e06 33 "Particular 1st prof field not applicable", add 
label define label_xf1e06 50 "Outlier value derived from reported data", add 
label define label_xf1e06 51 "Outlier value derived from imported data", add 
label define label_xf1e06 52 "Value not derived - parent/child differs across components", add 
label define label_xf1e06 53 "Value not derived - data not usable", add 
label values xf1e06 label_xf1e06
label define label_xf1e07 10 "Reported" 
label define label_xf1e07 11 "Analyst corrected reported value", add 
label define label_xf1e07 12 "Data generated from other data values", add 
label define label_xf1e07 13 "Implied zero", add 
label define label_xf1e07 20 "Imputed using Carry Forward procedure", add 
label define label_xf1e07 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1e07 22 "Imputed using the Group Median procedure", add 
label define label_xf1e07 23 "Logical imputation", add 
label define label_xf1e07 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1e07 30 "Not applicable", add 
label define label_xf1e07 31 "Institution left item blank", add 
label define label_xf1e07 32 "Do not know", add 
label define label_xf1e07 33 "Particular 1st prof field not applicable", add 
label define label_xf1e07 50 "Outlier value derived from reported data", add 
label define label_xf1e07 51 "Outlier value derived from imported data", add 
label define label_xf1e07 52 "Value not derived - parent/child differs across components", add 
label define label_xf1e07 53 "Value not derived - data not usable", add 
label values xf1e07 label_xf1e07
label define label_xf1e08 10 "Reported" 
label define label_xf1e08 11 "Analyst corrected reported value", add 
label define label_xf1e08 12 "Data generated from other data values", add 
label define label_xf1e08 13 "Implied zero", add 
label define label_xf1e08 20 "Imputed using Carry Forward procedure", add 
label define label_xf1e08 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1e08 22 "Imputed using the Group Median procedure", add 
label define label_xf1e08 23 "Logical imputation", add 
label define label_xf1e08 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1e08 30 "Not applicable", add 
label define label_xf1e08 31 "Institution left item blank", add 
label define label_xf1e08 32 "Do not know", add 
label define label_xf1e08 33 "Particular 1st prof field not applicable", add 
label define label_xf1e08 50 "Outlier value derived from reported data", add 
label define label_xf1e08 51 "Outlier value derived from imported data", add 
label define label_xf1e08 52 "Value not derived - parent/child differs across components", add 
label define label_xf1e08 53 "Value not derived - data not usable", add 
label values xf1e08 label_xf1e08
label define label_xf1e09 10 "Reported" 
label define label_xf1e09 11 "Analyst corrected reported value", add 
label define label_xf1e09 12 "Data generated from other data values", add 
label define label_xf1e09 13 "Implied zero", add 
label define label_xf1e09 20 "Imputed using Carry Forward procedure", add 
label define label_xf1e09 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1e09 22 "Imputed using the Group Median procedure", add 
label define label_xf1e09 23 "Logical imputation", add 
label define label_xf1e09 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1e09 30 "Not applicable", add 
label define label_xf1e09 31 "Institution left item blank", add 
label define label_xf1e09 32 "Do not know", add 
label define label_xf1e09 33 "Particular 1st prof field not applicable", add 
label define label_xf1e09 50 "Outlier value derived from reported data", add 
label define label_xf1e09 51 "Outlier value derived from imported data", add 
label define label_xf1e09 52 "Value not derived - parent/child differs across components", add 
label define label_xf1e09 53 "Value not derived - data not usable", add 
label values xf1e09 label_xf1e09
label define label_xf1e10 10 "Reported" 
label define label_xf1e10 11 "Analyst corrected reported value", add 
label define label_xf1e10 12 "Data generated from other data values", add 
label define label_xf1e10 13 "Implied zero", add 
label define label_xf1e10 20 "Imputed using Carry Forward procedure", add 
label define label_xf1e10 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1e10 22 "Imputed using the Group Median procedure", add 
label define label_xf1e10 23 "Logical imputation", add 
label define label_xf1e10 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1e10 30 "Not applicable", add 
label define label_xf1e10 31 "Institution left item blank", add 
label define label_xf1e10 32 "Do not know", add 
label define label_xf1e10 33 "Particular 1st prof field not applicable", add 
label define label_xf1e10 50 "Outlier value derived from reported data", add 
label define label_xf1e10 51 "Outlier value derived from imported data", add 
label define label_xf1e10 52 "Value not derived - parent/child differs across components", add 
label define label_xf1e10 53 "Value not derived - data not usable", add 
label values xf1e10 label_xf1e10
label define label_xf1e11 10 "Reported" 
label define label_xf1e11 11 "Analyst corrected reported value", add 
label define label_xf1e11 12 "Data generated from other data values", add 
label define label_xf1e11 13 "Implied zero", add 
label define label_xf1e11 20 "Imputed using Carry Forward procedure", add 
label define label_xf1e11 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf1e11 22 "Imputed using the Group Median procedure", add 
label define label_xf1e11 23 "Logical imputation", add 
label define label_xf1e11 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf1e11 30 "Not applicable", add 
label define label_xf1e11 31 "Institution left item blank", add 
label define label_xf1e11 32 "Do not know", add 
label define label_xf1e11 33 "Particular 1st prof field not applicable", add 
label define label_xf1e11 50 "Outlier value derived from reported data", add 
label define label_xf1e11 51 "Outlier value derived from imported data", add 
label define label_xf1e11 52 "Value not derived - parent/child differs across components", add 
label define label_xf1e11 53 "Value not derived - data not usable", add 
label values xf1e11 label_xf1e11
label define label_f1fha 1 "Yes - (report endowment assets)" 
label define label_f1fha 2 "No", add 
label values f1fha label_f1fha
tab xf1a01
tab xf1a02
tab xf1a03
tab xf1a04
tab xf1a05
tab xf1a06
tab xf1a07
tab xf1a08
tab xf1a09
tab xf1a10
tab xf1a11
tab xf1a12
tab xf1a13
tab xf1a14
tab xf1a15
tab xf1a16
tab xf1a17
tab xf1a18
tab xf1a211
tab xf1a212
tab xf1a213
tab xf1a214
tab xf1a221
tab xf1a222
tab xf1a223
tab xf1a224
tab xf1a231
tab xf1a232
tab xf1a233
tab xf1a234
tab xf1a241
tab xf1a242
tab xf1a243
tab xf1a244
tab xf1a251
tab xf1a252
tab xf1a253
tab xf1a254
tab xf1a261
tab xf1a262
tab xf1a263
tab xf1a264
tab xf1a271
tab xf1a272
tab xf1a273
tab xf1a274
tab xf1a281
tab xf1a282
tab xf1a283
tab xf1a284
tab xf1b01
tab xf1b02
tab xf1b03
tab xf1b04
tab xf1b05
tab xf1b06
tab xf1b07
tab xf1b08
tab xf1b09
tab xf1b10
tab xf1b11
tab xf1b12
tab xf1b13
tab xf1b14
tab xf1b15
tab xf1b16
tab xf1b17
tab xf1b18
tab xf1b19
tab xf1b20
tab xf1b21
tab xf1b22
tab xf1b23
tab xf1b24
tab xf1b25
tab xf1c011
tab xf1c012
tab xf1c013
tab xf1c014
tab xf1c015
tab xf1c021
tab xf1c022
tab xf1c023
tab xf1c024
tab xf1c025
tab xf1c031
tab xf1c032
tab xf1c033
tab xf1c034
tab xf1c035
tab xf1c051
tab xf1c052
tab xf1c053
tab xf1c054
tab xf1c055
tab xf1c061
tab xf1c062
tab xf1c063
tab xf1c064
tab xf1c065
tab xf1c071
tab xf1c072
tab xf1c073
tab xf1c074
tab xf1c075
tab xf1c081
tab xf1c082
tab xf1c083
tab xf1c084
tab xf1c085
tab xf1c091
tab xf1c094
tab xf1c101
tab xf1c102
tab xf1c103
tab xf1c104
tab xf1c105
tab xf1c111
tab xf1c112
tab xf1c113
tab xf1c114
tab xf1c115
tab xf1c121
tab xf1c122
tab xf1c123
tab xf1c124
tab xf1c125
tab xf1c131
tab xf1c132
tab xf1c133
tab xf1c134
tab xf1c135
tab xf1c141
tab xf1c142
tab xf1c143
tab xf1c144
tab xf1c145
tab xf1c151
tab xf1c152
tab xf1c153
tab xf1c154
tab xf1c155
tab xf1c161
tab xf1c165
tab xf1c171
tab xf1c172
tab xf1c173
tab xf1c174
tab xf1c175
tab xf1c181
tab xf1c182
tab xf1c183
tab xf1c184
tab xf1c185
tab xf1c191
tab xf1c192
tab xf1c193
tab xf1c194
tab xf1c195
tab xf1d01
tab xf1d02
tab xf1d03
tab xf1d04
tab xf1d05
tab xf1d06
tab xf1h01
tab xf1h02
tab xf1e01
tab xf1e02
tab xf1e03
tab xf1e04
tab xf1e05
tab xf1e06
tab xf1e07
tab xf1e08
tab xf1e09
tab xf1e10
tab xf1e11
tab f1fha
summarize f1a01
summarize f1a02
summarize f1a03
summarize f1a04
summarize f1a05
summarize f1a06
summarize f1a07
summarize f1a08
summarize f1a09
summarize f1a10
summarize f1a11
summarize f1a12
summarize f1a13
summarize f1a14
summarize f1a15
summarize f1a16
summarize f1a17
summarize f1a18
summarize f1a211
summarize f1a212
summarize f1a213
summarize f1a214
summarize f1a221
summarize f1a222
summarize f1a223
summarize f1a224
summarize f1a231
summarize f1a232
summarize f1a233
summarize f1a234
summarize f1a241
summarize f1a242
summarize f1a243
summarize f1a244
summarize f1a251
summarize f1a252
summarize f1a253
summarize f1a254
summarize f1a261
summarize f1a262
summarize f1a263
summarize f1a264
summarize f1a271
summarize f1a272
summarize f1a273
summarize f1a274
summarize f1a281
summarize f1a282
summarize f1a283
summarize f1a284
summarize f1b01
summarize f1b02
summarize f1b03
summarize f1b04
summarize f1b05
summarize f1b06
summarize f1b07
summarize f1b08
summarize f1b09
summarize f1b10
summarize f1b11
summarize f1b12
summarize f1b13
summarize f1b14
summarize f1b15
summarize f1b16
summarize f1b17
summarize f1b18
summarize f1b19
summarize f1b20
summarize f1b21
summarize f1b22
summarize f1b23
summarize f1b24
summarize f1b25
summarize f1c011
summarize f1c012
summarize f1c013
summarize f1c014
summarize f1c015
summarize f1c021
summarize f1c022
summarize f1c023
summarize f1c024
summarize f1c025
summarize f1c031
summarize f1c032
summarize f1c033
summarize f1c034
summarize f1c035
summarize f1c051
summarize f1c052
summarize f1c053
summarize f1c054
summarize f1c055
summarize f1c061
summarize f1c062
summarize f1c063
summarize f1c064
summarize f1c065
summarize f1c071
summarize f1c072
summarize f1c073
summarize f1c074
summarize f1c075
summarize f1c081
summarize f1c082
summarize f1c083
summarize f1c084
summarize f1c085
summarize f1c091
summarize f1c094
summarize f1c101
summarize f1c102
summarize f1c103
summarize f1c104
summarize f1c105
summarize f1c111
summarize f1c112
summarize f1c113
summarize f1c114
summarize f1c115
summarize f1c121
summarize f1c122
summarize f1c123
summarize f1c124
summarize f1c125
summarize f1c131
summarize f1c132
summarize f1c133
summarize f1c134
summarize f1c135
summarize f1c141
summarize f1c142
summarize f1c143
summarize f1c144
summarize f1c145
summarize f1c151
summarize f1c152
summarize f1c153
summarize f1c154
summarize f1c155
summarize f1c161
summarize f1c165
summarize f1c171
summarize f1c172
summarize f1c173
summarize f1c174
summarize f1c175
summarize f1c181
summarize f1c182
summarize f1c183
summarize f1c184
summarize f1c185
summarize f1c191
summarize f1c192
summarize f1c193
summarize f1c194
summarize f1c195
summarize f1d01
summarize f1d02
summarize f1d03
summarize f1d04
summarize f1d05
summarize f1d06
summarize f1h01
summarize f1h02
summarize f1e01
summarize f1e02
summarize f1e03
summarize f1e04
summarize f1e05
summarize f1e06
summarize f1e07
summarize f1e08
summarize f1e09
summarize f1e10
summarize f1e11
save dct_f0506_f1a

