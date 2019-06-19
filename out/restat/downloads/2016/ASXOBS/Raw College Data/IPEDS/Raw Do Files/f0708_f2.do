* Created: 9/13/2009 3:28:51 AM
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
insheet using "../Raw Data/f0708_f2_data_stata.csv", comma clear
label data "dct_f0708_f2"
label variable unitid "unitid"
label variable xf2a01 "Imputation field for F2A01 - Long-term investments"
label variable f2a01 "Long-term investments"
label variable xf2a02 "Imputation field for F2A02 - Total assets"
label variable f2a02 "Total assets"
label variable xf2a03 "Imputation field for F2A03 - Total liabilities"
label variable f2a03 "Total liabilities"
label variable xf2a03a "Imputation field for F2A03A - Debt related to Property, Plant, and Equipment"
label variable f2a03a "Debt related to Property, Plant, and Equipment"
label variable xf2a04 "Imputation field for F2A04 - Total unrestricted net assets"
label variable f2a04 "Total unrestricted net assets"
label variable xf2a05 "Imputation field for F2A05 - Total restricted net assets"
label variable f2a05 "Total restricted net assets"
label variable xf2a05a "Imputation field for F2A05A - Permanently restricted net assets included in total restricted net assets"
label variable f2a05a "Permanently restricted net assets included in total restricted net assets"
label variable xf2a05b "Imputation field for F2A05B - Temporarily restricted net assets"
label variable f2a05b "Temporarily restricted net assets"
label variable xf2a06 "Imputation field for F2A06 - Total net assets"
label variable f2a06 "Total net assets"
label variable xf2a11 "Imputation field for F2A11 - Land  improvements - End of year"
label variable f2a11 "Land  improvements - End of year"
label variable xf2a12 "Imputation field for F2A12 - Buildings - End of year"
label variable f2a12 "Buildings - End of year"
label variable xf2a13 "Imputation field for F2A13 - Equipment, including art and library collections - End of year"
label variable f2a13 "Equipment, including art and library collections - End of year"
label variable xf2a14 "Imputation field for F2A14 - Property obtained under capital leases - End of year"
label variable f2a14 "Property obtained under capital leases - End of year"
label variable xf2a15 "Imputation field for F2A15 - Construction in Progress"
label variable f2a15 "Construction in Progress"
label variable xf2a16 "Imputation field for F2A16 - Other plant, property and equipment"
label variable f2a16 "Other plant, property and equipment"
label variable xf2a17 "Imputation field for F2A17 - Total Plant, Property, and Equipment"
label variable f2a17 "Total Plant, Property, and Equipment"
label variable xf2a18 "Imputation field for F2A18 - Accumulated depreciation"
label variable f2a18 "Accumulated depreciation"
label variable xf2a19 "Imputation field for F2A19 - Property, Plant, and Equipment, net of accumulated depreciation"
label variable f2a19 "Property, Plant, and Equipment, net of accumulated depreciation"
label variable f2a20 "Intangible Assets, net of accumulated amortization"
label variable xf2a20 "Imputation field for F2A20 - Intangible Assets, net of accumulated amortization"
label variable xf2b01 "Imputation field for F2B01 - Total revenues and investment return"
label variable f2b01 "Total revenues and investment return"
label variable xf2b02 "Imputation field for F2B02 - Total expenses"
label variable f2b02 "Total expenses"
label variable xf2b03 "Imputation field for F2B03 - Other specific changes in net assets"
label variable f2b03 "Other specific changes in net assets"
label variable xf2b04 "Imputation field for F2B04 - Total change in net assets"
label variable f2b04 "Total change in net assets"
label variable xf2b05 "Imputation field for F2B05 - Net assets, beginning of the year"
label variable f2b05 "Net assets, beginning of the year"
label variable xf2b06 "Imputation field for F2B06 - Adjustments to beginning of year net assets"
label variable f2b06 "Adjustments to beginning of year net assets"
label variable xf2b07 "Imputation field for F2B07 - Net assets, end of the year"
label variable f2b07 "Net assets, end of the year"
label variable xf2c01 "Imputation field for F2C01 - Pell grants"
label variable f2c01 "Pell grants"
label variable xf2c02 "Imputation field for F2C02 - Other federal grants"
label variable f2c02 "Other federal grants"
label variable xf2c03 "Imputation field for F2C03 - State grants"
label variable f2c03 "State grants"
label variable xf2c04 "Imputation field for F2C04 - Local grants"
label variable f2c04 "Local grants"
label variable xf2c05 "Imputation field for F2C05 - Institutional grants (funded)"
label variable f2c05 "Institutional grants (funded)"
label variable xf2c06 "Imputation field for F2C06 - Institutional grants (unfunded)"
label variable f2c06 "Institutional grants (unfunded)"
label variable xf2c07 "Imputation field for F2C07 - Total student grants"
label variable f2c07 "Total student grants"
label variable xf2c08 "Imputation field for F2C08 - Allowances applied to tuition and fees"
label variable f2c08 "Allowances applied to tuition and fees"
label variable xf2c09 "Imputation field for F2C09 - Allowances applied to auxiliary enterprise revenues"
label variable f2c09 "Allowances applied to auxiliary enterprise revenues"
label variable xf2d01 "Imputation field for F2D01 - Tuition and fees - Total"
label variable f2d01 "Tuition and fees - Total"
label variable xf2d012 "Imputation field for F2D012 - Tuition and fees - Unrestricted"
label variable f2d012 "Tuition and fees - Unrestricted"
label variable xf2d013 "Imputation field for F2D013 - Tuition and fees - Temporarily restricted"
label variable f2d013 "Tuition and fees - Temporarily restricted"
label variable xf2d014 "Imputation field for F2D014 - Tuition and fees - Permanently restricted"
label variable f2d014 "Tuition and fees - Permanently restricted"
label variable xf2d02 "Imputation field for F2D02 - Federal appropriations - Total"
label variable f2d02 "Federal appropriations - Total"
label variable xf2d022 "Imputation field for F2D022 - Federal appropriations - Unrestricted"
label variable f2d022 "Federal appropriations - Unrestricted"
label variable xf2d023 "Imputation field for F2D023 - Federal appropriations - Temporarily restricted"
label variable f2d023 "Federal appropriations - Temporarily restricted"
label variable xf2d024 "Imputation field for F2D024 - Federal appropriations - Permanently restricted"
label variable f2d024 "Federal appropriations - Permanently restricted"
label variable xf2d03 "Imputation field for F2D03 - State appropriations - Total"
label variable f2d03 "State appropriations - Total"
label variable xf2d032 "Imputation field for F2D032 - State appropriations - Unrestricted"
label variable f2d032 "State appropriations - Unrestricted"
label variable xf2d033 "Imputation field for F2D033 - State appropriations - Temporarily restricted"
label variable f2d033 "State appropriations - Temporarily restricted"
label variable xf2d034 "Imputation field for F2D034 - State appropriations - Permanently restricted"
label variable f2d034 "State appropriations - Permanently restricted"
label variable xf2d04 "Imputation field for F2D04 - Local appropriations - Total"
label variable f2d04 "Local appropriations - Total"
label variable xf2d042 "Imputation field for F2D042 - Local appropriations - Unrestricted"
label variable f2d042 "Local appropriations - Unrestricted"
label variable xf2d043 "Imputation field for F2D043 - Local appropriations -  Temporarily restricted"
label variable f2d043 "Local appropriations -  Temporarily restricted"
label variable xf2d044 "Imputation field for F2D044 - Local appropriations - Permanently restricted"
label variable f2d044 "Local appropriations - Permanently restricted"
label variable xf2d05 "Imputation field for F2D05 - Federal grants and contracts - Total"
label variable f2d05 "Federal grants and contracts - Total"
label variable xf2d052 "Imputation field for F2D052 - Federal grants and contracts - Unrestricted"
label variable f2d052 "Federal grants and contracts - Unrestricted"
label variable xf2d053 "Imputation field for F2D053 - Federal grants and contracts  - Temporarily restricted"
label variable f2d053 "Federal grants and contracts  - Temporarily restricted"
label variable xf2d054 "Imputation field for F2D054 - Federal grants and contracts - Pemanently restricted"
label variable f2d054 "Federal grants and contracts - Pemanently restricted"
label variable xf2d06 "Imputation field for F2D06 - State grants and contracts - Total"
label variable f2d06 "State grants and contracts - Total"
label variable xf2d062 "Imputation field for F2D062 - State grants and contracts - Unrestricted"
label variable f2d062 "State grants and contracts - Unrestricted"
label variable xf2d063 "Imputation field for F2D063 - State grants and contracts - Temporarily restricted"
label variable f2d063 "State grants and contracts - Temporarily restricted"
label variable xf2d064 "Imputation field for F2D064 - State grants and contracts - Permanently restricted"
label variable f2d064 "State grants and contracts - Permanently restricted"
label variable xf2d07 "Imputation field for F2D07 - Local grants and contracts - Total"
label variable f2d07 "Local grants and contracts - Total"
label variable xf2d072 "Imputation field for F2D072 - Local grants and contracts - Unrestricted"
label variable f2d072 "Local grants and contracts - Unrestricted"
label variable xf2d073 "Imputation field for F2D073 - Local grants and contracts - Temporarily restricted"
label variable f2d073 "Local grants and contracts - Temporarily restricted"
label variable xf2d074 "Imputation field for F2D074 - Local grants and contracts  - Permanently restricted"
label variable f2d074 "Local grants and contracts  - Permanently restricted"
label variable xf2d08 "Imputation field for F2D08 - Private gifts, grants, and contracts - Total"
label variable f2d08 "Private gifts, grants, and contracts - Total"
label variable xf2d082 "Imputation field for F2D082 - Private gifts, grants, and contracts - Unrestricted"
label variable f2d082 "Private gifts, grants, and contracts - Unrestricted"
label variable xf2d083 "Imputation field for F2D083 - Private gifts, grants and contracts - Temporarily restricted"
label variable f2d083 "Private gifts, grants and contracts - Temporarily restricted"
label variable xf2d084 "Imputation field for F2D084 - Private gifts, grants, and contracts - Permanently restricted"
label variable f2d084 "Private gifts, grants, and contracts - Permanently restricted"
label variable xf2d08a "Imputation field for F2D08A - Private gifts - Total"
label variable f2d08a "Private gifts - Total"
label variable xf2d082a "Imputation field for F2D082A - Private gifts - Unrestricted"
label variable f2d082a "Private gifts - Unrestricted"
label variable xf2d083a "Imputation field for F2D083A - Private gifts - Temporarily restricted"
label variable f2d083a "Private gifts - Temporarily restricted"
label variable xf2d084a "Imputation field for F2D084A - Private gifts - Permanentlly restricted"
label variable f2d084a "Private gifts - Permanentlly restricted"
label variable xf2d08b "Imputation field for F2D08B - Private grants and contrants - Total"
label variable f2d08b "Private grants and contrants - Total"
label variable xf2d082b "Imputation field for F2D082B - Private grants and contracts - Unrestricted"
label variable f2d082b "Private grants and contracts - Unrestricted"
label variable xf2d083b "Imputation field for F2D083B - Private grants and contracts - Temporarily restricted"
label variable f2d083b "Private grants and contracts - Temporarily restricted"
label variable xf2d084b "Imputation field for F2D084B - Private grants, and contracts - Permanently restricted"
label variable f2d084b "Private grants, and contracts - Permanently restricted"
label variable xf2d09 "Imputation field for F2D09 - Contributions from affiliated entities - Total"
label variable f2d09 "Contributions from affiliated entities - Total"
label variable xf2d092 "Imputation field for F2D092 - Contributions from affiliated entities - Unrestricted"
label variable f2d092 "Contributions from affiliated entities - Unrestricted"
label variable xf2d093 "Imputation field for F2D093 - Contributions from affiliated entities - Temporarily restricted"
label variable f2d093 "Contributions from affiliated entities - Temporarily restricted"
label variable xf2d094 "Imputation field for F2D094 - Contributions from affiliated entities - Permanently restricted"
label variable f2d094 "Contributions from affiliated entities - Permanently restricted"
label variable xf2d10 "Imputation field for F2D10 - Investment return - Total"
label variable f2d10 "Investment return - Total"
label variable xf2d102 "Imputation field for F2D102 - Investment return - Unrestricted"
label variable f2d102 "Investment return - Unrestricted"
label variable xf2d103 "Imputation field for F2D103 - Investment return - Temporarily restricted"
label variable f2d103 "Investment return - Temporarily restricted"
label variable xf2d104 "Imputation field for F2D104 - Investment return - Permanently restricted"
label variable f2d104 "Investment return - Permanently restricted"
label variable xf2d11 "Imputation field for F2D11 - Sales and services of educational activities - Total"
label variable f2d11 "Sales and services of educational activities - Total"
label variable xf2d112 "Imputation field for F2D112 - Sales and services of educational activities - Unrestricted"
label variable f2d112 "Sales and services of educational activities - Unrestricted"
label variable xf2d12 "Imputation field for F2D12 - Sales and services of auxiliary enterprises - Total"
label variable f2d12 "Sales and services of auxiliary enterprises - Total"
label variable xf2d122 "Imputation field for F2D122 - Sales and services of auxiliary enterprises - Unrestricted"
label variable f2d122 "Sales and services of auxiliary enterprises - Unrestricted"
label variable xf2d13 "Imputation field for F2D13 - Hospital revenue - Total"
label variable f2d13 "Hospital revenue - Total"
label variable xf2d132 "Imputation field for F2D132 - Hospital revenue - Unrestricted"
label variable f2d132 "Hospital revenue - Unrestricted"
label variable xf2d14 "Imputation field for F2D14 - Independent operations revenue - Total"
label variable f2d14 "Independent operations revenue - Total"
label variable xf2d142 "Imputation field for F2D142 - Independent operations revenue - Unrestricted"
label variable f2d142 "Independent operations revenue - Unrestricted"
label variable xf2d143 "Imputation field for F2D143 - Independent operations revenue - Temporarily restricted"
label variable f2d143 "Independent operations revenue - Temporarily restricted"
label variable xf2d144 "Imputation field for F2D144 - Independent operations revenue - Permanently restricted"
label variable f2d144 "Independent operations revenue - Permanently restricted"
label variable xf2d15 "Imputation field for F2D15 - Other revenue - Total"
label variable f2d15 "Other revenue - Total"
label variable xf2d152 "Imputation field for F2D152 - Other revenue - Unrestricted"
label variable f2d152 "Other revenue - Unrestricted"
label variable xf2d153 "Imputation field for F2D153 - Other revenue - Temporarily restricted"
label variable f2d153 "Other revenue - Temporarily restricted"
label variable xf2d154 "Imputation field for F2D154 - Other revenue - Permanently restricted"
label variable f2d154 "Other revenue - Permanently restricted"
label variable xf2d16 "Imputation field for F2D16 - Total revenues and investment return - Total"
label variable f2d16 "Total revenues and investment return - Total"
label variable xf2d162 "Imputation field for F2D162 - Total revenues and investment return - Unrestricted"
label variable f2d162 "Total revenues and investment return - Unrestricted"
label variable xf2d163 "Imputation field for F2D163 - Total revenues and investment return - Temporarily restricted"
label variable f2d163 "Total revenues and investment return - Temporarily restricted"
label variable xf2d164 "Imputation field for F2D164 - Total revenues and investment return - Permanently restricted"
label variable f2d164 "Total revenues and investment return - Permanently restricted"
label variable xf2d172 "Imputation field for F2D172 - Net assets released from restriction - Unrestricted"
label variable f2d172 "Net assets released from restriction - Unrestricted"
label variable xf2d173 "Imputation field for F2D173 - Net assets released from restriction - Temporarily restricted"
label variable f2d173 "Net assets released from restriction - Temporarily restricted"
label variable xf2d182 "Imputation field for F2D182 - Net total revenues, after assets released from restriction - Unrestricted"
label variable f2d182 "Net total revenues, after assets released from restriction - Unrestricted"
label variable xf2d183 "Imputation field for F2D183 - Net total revenues, after assets released from restriction - Temporarily restricted"
label variable f2d183 "Net total revenues, after assets released from restriction - Temporarily restricted"
label variable xf2d184 "Imputation field for F2D184 - Net total revenues, after assets released from restriction - Permanently restricted"
label variable f2d184 "Net total revenues, after assets released from restriction - Permanently restricted"
label variable xf2e011 "Imputation field for F2E011 - Instruction-Total amount"
label variable f2e011 "Instruction-Total amount"
label variable xf2e012 "Imputation field for F2E012 - Instruction-Salaries and wages"
label variable f2e012 "Instruction-Salaries and wages"
label variable xf2e013 "Imputation field for F2E013 - Instruction-Benefits"
label variable f2e013 "Instruction-Benefits"
label variable xf2e014 "Imputation field for F2E014 - Instruction-Operation and maintenance of plant"
label variable f2e014 "Instruction-Operation and maintenance of plant"
label variable xf2e015 "Imputation field for F2E015 - Instruction-Depreciation"
label variable f2e015 "Instruction-Depreciation"
label variable xf2e016 "Imputation field for F2E016 - Instruction-Interest"
label variable f2e016 "Instruction-Interest"
label variable xf2e017 "Imputation field for F2E017 - Instruction-All other"
label variable f2e017 "Instruction-All other"
label variable xf2e021 "Imputation field for F2E021 - Research-Total amount"
label variable f2e021 "Research-Total amount"
label variable xf2e022 "Imputation field for F2E022 - Research-Salaries and wages"
label variable f2e022 "Research-Salaries and wages"
label variable xf2e023 "Imputation field for F2E023 - Research-Benefits"
label variable f2e023 "Research-Benefits"
label variable xf2e024 "Imputation field for F2E024 - Research-Operation and maintenance of plant"
label variable f2e024 "Research-Operation and maintenance of plant"
label variable xf2e025 "Imputation field for F2E025 - Research-Depreciation"
label variable f2e025 "Research-Depreciation"
label variable xf2e026 "Imputation field for F2E026 - Research-Interest"
label variable f2e026 "Research-Interest"
label variable xf2e027 "Imputation field for F2E027 - Research-All other"
label variable f2e027 "Research-All other"
label variable xf2e031 "Imputation field for F2E031 - Public service-Total amount"
label variable f2e031 "Public service-Total amount"
label variable xf2e032 "Imputation field for F2E032 - Public service-Salaries and wages"
label variable f2e032 "Public service-Salaries and wages"
label variable xf2e033 "Imputation field for F2E033 - Public service-Benefits"
label variable f2e033 "Public service-Benefits"
label variable xf2e034 "Imputation field for F2E034 - Public service-Operation and maintenance of plant"
label variable f2e034 "Public service-Operation and maintenance of plant"
label variable xf2e035 "Imputation field for F2E035 - Public service-Depreciation"
label variable f2e035 "Public service-Depreciation"
label variable xf2e036 "Imputation field for F2E036 - Public service-Interest"
label variable f2e036 "Public service-Interest"
label variable xf2e037 "Imputation field for F2E037 - Public service-All other"
label variable f2e037 "Public service-All other"
label variable xf2e041 "Imputation field for F2E041 - Academic support-Total amount"
label variable f2e041 "Academic support-Total amount"
label variable xf2e042 "Imputation field for F2E042 - Academic support-Salaries and wages"
label variable f2e042 "Academic support-Salaries and wages"
label variable xf2e043 "Imputation field for F2E043 - Academic support-Benefits"
label variable f2e043 "Academic support-Benefits"
label variable xf2e044 "Imputation field for F2E044 - Academic support-Operation and maintenance of plant"
label variable f2e044 "Academic support-Operation and maintenance of plant"
label variable xf2e045 "Imputation field for F2E045 - Academic support-Depreciation"
label variable f2e045 "Academic support-Depreciation"
label variable xf2e046 "Imputation field for F2E046 - Academic support-Interest"
label variable f2e046 "Academic support-Interest"
label variable xf2e047 "Imputation field for F2E047 - Academic support-All other"
label variable f2e047 "Academic support-All other"
label variable xf2e051 "Imputation field for F2E051 - Student service-Total amount"
label variable f2e051 "Student service-Total amount"
label variable xf2e052 "Imputation field for F2E052 - Student service-Salaries and wages"
label variable f2e052 "Student service-Salaries and wages"
label variable xf2e053 "Imputation field for F2E053 - Student service-Benefits"
label variable f2e053 "Student service-Benefits"
label variable xf2e054 "Imputation field for F2E054 - Student service-Operation and maintenance of plant"
label variable f2e054 "Student service-Operation and maintenance of plant"
label variable xf2e055 "Imputation field for F2E055 - Student service-Depreciation"
label variable f2e055 "Student service-Depreciation"
label variable xf2e056 "Imputation field for F2E056 - Student service-Interest"
label variable f2e056 "Student service-Interest"
label variable xf2e057 "Imputation field for F2E057 - Student service-All other"
label variable f2e057 "Student service-All other"
label variable xf2e061 "Imputation field for F2E061 - Institutional support-Total amount"
label variable f2e061 "Institutional support-Total amount"
label variable xf2e062 "Imputation field for F2E062 - Institutional support-Salaries and wages"
label variable f2e062 "Institutional support-Salaries and wages"
label variable xf2e063 "Imputation field for F2E063 - Institutional support-Benefits"
label variable f2e063 "Institutional support-Benefits"
label variable xf2e064 "Imputation field for F2E064 - Institutional support-Operation and maintenance of plant"
label variable f2e064 "Institutional support-Operation and maintenance of plant"
label variable xf2e065 "Imputation field for F2E065 - Institutional support-Depreciation"
label variable f2e065 "Institutional support-Depreciation"
label variable xf2e066 "Imputation field for F2E066 - Institutional support-Interest"
label variable f2e066 "Institutional support-Interest"
label variable xf2e067 "Imputation field for F2E067 - Institutional support-All other"
label variable f2e067 "Institutional support-All other"
label variable xf2e071 "Imputation field for F2E071 - Auxiliary enterprises-Total amount"
label variable f2e071 "Auxiliary enterprises-Total amount"
label variable xf2e072 "Imputation field for F2E072 - Auxiliary enterprises-Salaries and wages"
label variable f2e072 "Auxiliary enterprises-Salaries and wages"
label variable xf2e073 "Imputation field for F2E073 - Auxiliary enterprises-Benefits"
label variable f2e073 "Auxiliary enterprises-Benefits"
label variable xf2e074 "Imputation field for F2E074 - Auxiliary enterprises-Operation and maintenance of plant"
label variable f2e074 "Auxiliary enterprises-Operation and maintenance of plant"
label variable xf2e075 "Imputation field for F2E075 - Auxiliary enterprises-Depreciation"
label variable f2e075 "Auxiliary enterprises-Depreciation"
label variable xf2e076 "Imputation field for F2E076 - Auxiliary enterprises-Interest"
label variable f2e076 "Auxiliary enterprises-Interest"
label variable xf2e077 "Imputation field for F2E077 - Auxiliary enterprises-All other"
label variable f2e077 "Auxiliary enterprises-All other"
label variable xf2e081 "Imputation field for F2E081 - Net grant aid to students-Total amount"
label variable f2e081 "Net grant aid to students-Total amount"
label variable xf2e082 "Imputation field for F2E082 - Net grant aid to students-Salaries and wages"
label variable f2e082 "Net grant aid to students-Salaries and wages"
label variable xf2e083 "Imputation field for F2E083 - Net grant aid to students-Benefits"
label variable f2e083 "Net grant aid to students-Benefits"
label variable xf2e084 "Imputation field for F2E084 - Net grant aid to students-Operation and maintenance of plant"
label variable f2e084 "Net grant aid to students-Operation and maintenance of plant"
label variable xf2e085 "Imputation field for F2E085 - Net grant aid to students-Depreciation"
label variable f2e085 "Net grant aid to students-Depreciation"
label variable xf2e086 "Imputation field for F2E086 - Net grant aid to students-Interest"
label variable f2e086 "Net grant aid to students-Interest"
label variable xf2e087 "Imputation field for F2E087 - Net grant aid to students-All other"
label variable f2e087 "Net grant aid to students-All other"
label variable xf2e091 "Imputation field for F2E091 - Hospital services-Total amount"
label variable f2e091 "Hospital services-Total amount"
label variable xf2e092 "Imputation field for F2E092 - Hospital services-Salaries and wages"
label variable f2e092 "Hospital services-Salaries and wages"
label variable xf2e093 "Imputation field for F2E093 - Hospital services-Benefits"
label variable f2e093 "Hospital services-Benefits"
label variable xf2e094 "Imputation field for F2E094 - Hospital services-Operation and maintenance of plant"
label variable f2e094 "Hospital services-Operation and maintenance of plant"
label variable xf2e095 "Imputation field for F2E095 - Hospital services-Depreciation"
label variable f2e095 "Hospital services-Depreciation"
label variable xf2e096 "Imputation field for F2E096 - Hospital services-Interest"
label variable f2e096 "Hospital services-Interest"
label variable xf2e097 "Imputation field for F2E097 - Hospital services-All other"
label variable f2e097 "Hospital services-All other"
label variable xf2e101 "Imputation field for F2E101 - Independent operations-Total Amount"
label variable f2e101 "Independent operations-Total Amount"
label variable xf2e102 "Imputation field for F2E102 - Independent operations-Salaries and wages"
label variable f2e102 "Independent operations-Salaries and wages"
label variable xf2e103 "Imputation field for F2E103 - Independent operations-Benefits"
label variable f2e103 "Independent operations-Benefits"
label variable xf2e104 "Imputation field for F2E104 - Independent operations-Operation and maintenance of plant"
label variable f2e104 "Independent operations-Operation and maintenance of plant"
label variable xf2e105 "Imputation field for F2E105 - Independent operations-Depreciation"
label variable f2e105 "Independent operations-Depreciation"
label variable xf2e106 "Imputation field for F2E106 - Independent operations-Interest"
label variable f2e106 "Independent operations-Interest"
label variable xf2e107 "Imputation field for F2E107 - Independent operations-All other"
label variable f2e107 "Independent operations-All other"
label variable xf2e111 "Imputation field for F2E111 - Operation and maintenance of plant-Total amount"
label variable f2e111 "Operation and maintenance of plant-Total amount"
label variable xf2e112 "Imputation field for F2E112 - Operation and maintenance of plant-Salaries and wages"
label variable f2e112 "Operation and maintenance of plant-Salaries and wages"
label variable xf2e113 "Imputation field for F2E113 - Operation and maintenance of plant-Benefits"
label variable f2e113 "Operation and maintenance of plant-Benefits"
label variable xf2e114 "Imputation field for F2E114 - Operation and maintenance of plant-Operation and maintenance of plant"
label variable f2e114 "Operation and maintenance of plant-Operation and maintenance of plant"
label variable xf2e115 "Imputation field for F2E115 - Operation and maintenance of plant-Depreciation"
label variable f2e115 "Operation and maintenance of plant-Depreciation"
label variable xf2e116 "Imputation field for F2E116 - Operation and maintenance of plant-Interest"
label variable f2e116 "Operation and maintenance of plant-Interest"
label variable xf2e117 "Imputation field for F2E117 - Operation and maintenance of plant-All other"
label variable f2e117 "Operation and maintenance of plant-All other"
label variable xf2e121 "Imputation field for F2E121 - Other expenses-Total amount"
label variable f2e121 "Other expenses-Total amount"
label variable xf2e122 "Imputation field for F2E122 - Other expenses-Salaries and wages"
label variable f2e122 "Other expenses-Salaries and wages"
label variable xf2e123 "Imputation field for F2E123 - Other expenses-Benefits"
label variable f2e123 "Other expenses-Benefits"
label variable xf2e124 "Imputation field for F2E124 - Other expenses-Operation and maintenance of plant"
label variable f2e124 "Other expenses-Operation and maintenance of plant"
label variable xf2e125 "Imputation field for F2E125 - Other expenses-Depreciation"
label variable f2e125 "Other expenses-Depreciation"
label variable xf2e126 "Imputation field for F2E126 - Other expenses-Interest"
label variable f2e126 "Other expenses-Interest"
label variable xf2e127 "Imputation field for F2E127 - Other expenses-All other"
label variable f2e127 "Other expenses-All other"
label variable xf2e131 "Imputation field for F2E131 - Total expenses-Total amount"
label variable f2e131 "Total expenses-Total amount"
label variable xf2e132 "Imputation field for F2E132 - Total expenses-Salaries and wages"
label variable f2e132 "Total expenses-Salaries and wages"
label variable xf2e133 "Imputation field for F2E133 - Total expenses-Benefits"
label variable f2e133 "Total expenses-Benefits"
label variable xf2e134 "Imputation field for F2E134 - Total expenses-Operation and maintenance of plant"
label variable f2e134 "Total expenses-Operation and maintenance of plant"
label variable xf2e135 "Imputation field for F2E135 - Total expenses-Depreciation"
label variable f2e135 "Total expenses-Depreciation"
label variable xf2e136 "Imputation field for F2E136 - Total expenses-Interest"
label variable f2e136 "Total expenses-Interest"
label variable xf2e137 "Imputation field for F2E137 - Total expenses-All other"
label variable f2e137 "Total expenses-All other"
label variable xf2h01 "Imputation field for F2H01 - Value of endowment assets at the beginning of the fiscal year"
label variable f2h01 "Value of endowment assets at the beginning of the fiscal year"
label variable xf2h02 "Imputation field for F2H02 - Value of endowment assets at the end of the fiscal year"
label variable f2h02 "Value of endowment assets at the end of the fiscal year"
label variable f2fha "Does this institution or any of its foundations or other affiliated organizations own endowment assets ?"
label define label_xf2a01 10 "Reported" 
label define label_xf2a01 11 "Analyst corrected reported value", add 
label define label_xf2a01 12 "Data generated from other data values", add 
label define label_xf2a01 13 "Implied zero", add 
label define label_xf2a01 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a01 22 "Imputed using the Group Median procedure", add 
label define label_xf2a01 23 "Logical imputation", add 
label define label_xf2a01 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a01 30 "Not applicable", add 
label define label_xf2a01 31 "Institution left item blank", add 
label define label_xf2a01 32 "Do not know", add 
label define label_xf2a01 33 "Particular 1st prof field not applicable", add 
label define label_xf2a01 50 "Outlier value derived from reported data", add 
label define label_xf2a01 51 "Outlier value derived from imported data", add 
label define label_xf2a01 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a01 53 "Value not derived - data not usable", add 
label values xf2a01 label_xf2a01
label define label_xf2a02 10 "Reported" 
label define label_xf2a02 11 "Analyst corrected reported value", add 
label define label_xf2a02 12 "Data generated from other data values", add 
label define label_xf2a02 13 "Implied zero", add 
label define label_xf2a02 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a02 22 "Imputed using the Group Median procedure", add 
label define label_xf2a02 23 "Logical imputation", add 
label define label_xf2a02 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a02 30 "Not applicable", add 
label define label_xf2a02 31 "Institution left item blank", add 
label define label_xf2a02 32 "Do not know", add 
label define label_xf2a02 33 "Particular 1st prof field not applicable", add 
label define label_xf2a02 50 "Outlier value derived from reported data", add 
label define label_xf2a02 51 "Outlier value derived from imported data", add 
label define label_xf2a02 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a02 53 "Value not derived - data not usable", add 
label values xf2a02 label_xf2a02
label define label_xf2a03 10 "Reported" 
label define label_xf2a03 11 "Analyst corrected reported value", add 
label define label_xf2a03 12 "Data generated from other data values", add 
label define label_xf2a03 13 "Implied zero", add 
label define label_xf2a03 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a03 22 "Imputed using the Group Median procedure", add 
label define label_xf2a03 23 "Logical imputation", add 
label define label_xf2a03 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a03 30 "Not applicable", add 
label define label_xf2a03 31 "Institution left item blank", add 
label define label_xf2a03 32 "Do not know", add 
label define label_xf2a03 33 "Particular 1st prof field not applicable", add 
label define label_xf2a03 50 "Outlier value derived from reported data", add 
label define label_xf2a03 51 "Outlier value derived from imported data", add 
label define label_xf2a03 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a03 53 "Value not derived - data not usable", add 
label values xf2a03 label_xf2a03
label define label_xf2a03a 10 "Reported" 
label define label_xf2a03a 11 "Analyst corrected reported value", add 
label define label_xf2a03a 12 "Data generated from other data values", add 
label define label_xf2a03a 13 "Implied zero", add 
label define label_xf2a03a 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a03a 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a03a 22 "Imputed using the Group Median procedure", add 
label define label_xf2a03a 23 "Logical imputation", add 
label define label_xf2a03a 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a03a 30 "Not applicable", add 
label define label_xf2a03a 31 "Institution left item blank", add 
label define label_xf2a03a 32 "Do not know", add 
label define label_xf2a03a 33 "Particular 1st prof field not applicable", add 
label define label_xf2a03a 50 "Outlier value derived from reported data", add 
label define label_xf2a03a 51 "Outlier value derived from imported data", add 
label define label_xf2a03a 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a03a 53 "Value not derived - data not usable", add 
label values xf2a03a label_xf2a03a
label define label_xf2a04 10 "Reported" 
label define label_xf2a04 11 "Analyst corrected reported value", add 
label define label_xf2a04 12 "Data generated from other data values", add 
label define label_xf2a04 13 "Implied zero", add 
label define label_xf2a04 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a04 22 "Imputed using the Group Median procedure", add 
label define label_xf2a04 23 "Logical imputation", add 
label define label_xf2a04 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a04 30 "Not applicable", add 
label define label_xf2a04 31 "Institution left item blank", add 
label define label_xf2a04 32 "Do not know", add 
label define label_xf2a04 33 "Particular 1st prof field not applicable", add 
label define label_xf2a04 50 "Outlier value derived from reported data", add 
label define label_xf2a04 51 "Outlier value derived from imported data", add 
label define label_xf2a04 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a04 53 "Value not derived - data not usable", add 
label values xf2a04 label_xf2a04
label define label_xf2a05 10 "Reported" 
label define label_xf2a05 11 "Analyst corrected reported value", add 
label define label_xf2a05 12 "Data generated from other data values", add 
label define label_xf2a05 13 "Implied zero", add 
label define label_xf2a05 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a05 22 "Imputed using the Group Median procedure", add 
label define label_xf2a05 23 "Logical imputation", add 
label define label_xf2a05 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a05 30 "Not applicable", add 
label define label_xf2a05 31 "Institution left item blank", add 
label define label_xf2a05 32 "Do not know", add 
label define label_xf2a05 33 "Particular 1st prof field not applicable", add 
label define label_xf2a05 50 "Outlier value derived from reported data", add 
label define label_xf2a05 51 "Outlier value derived from imported data", add 
label define label_xf2a05 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a05 53 "Value not derived - data not usable", add 
label values xf2a05 label_xf2a05
label define label_xf2a05a 10 "Reported" 
label define label_xf2a05a 11 "Analyst corrected reported value", add 
label define label_xf2a05a 12 "Data generated from other data values", add 
label define label_xf2a05a 13 "Implied zero", add 
label define label_xf2a05a 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a05a 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a05a 22 "Imputed using the Group Median procedure", add 
label define label_xf2a05a 23 "Logical imputation", add 
label define label_xf2a05a 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a05a 30 "Not applicable", add 
label define label_xf2a05a 31 "Institution left item blank", add 
label define label_xf2a05a 32 "Do not know", add 
label define label_xf2a05a 33 "Particular 1st prof field not applicable", add 
label define label_xf2a05a 50 "Outlier value derived from reported data", add 
label define label_xf2a05a 51 "Outlier value derived from imported data", add 
label define label_xf2a05a 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a05a 53 "Value not derived - data not usable", add 
label values xf2a05a label_xf2a05a
label define label_xf2a05b 10 "Reported" 
label define label_xf2a05b 11 "Analyst corrected reported value", add 
label define label_xf2a05b 12 "Data generated from other data values", add 
label define label_xf2a05b 13 "Implied zero", add 
label define label_xf2a05b 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a05b 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a05b 22 "Imputed using the Group Median procedure", add 
label define label_xf2a05b 23 "Logical imputation", add 
label define label_xf2a05b 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a05b 30 "Not applicable", add 
label define label_xf2a05b 31 "Institution left item blank", add 
label define label_xf2a05b 32 "Do not know", add 
label define label_xf2a05b 33 "Particular 1st prof field not applicable", add 
label define label_xf2a05b 50 "Outlier value derived from reported data", add 
label define label_xf2a05b 51 "Outlier value derived from imported data", add 
label define label_xf2a05b 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a05b 53 "Value not derived - data not usable", add 
label values xf2a05b label_xf2a05b
label define label_xf2a06 10 "Reported" 
label define label_xf2a06 11 "Analyst corrected reported value", add 
label define label_xf2a06 12 "Data generated from other data values", add 
label define label_xf2a06 13 "Implied zero", add 
label define label_xf2a06 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a06 22 "Imputed using the Group Median procedure", add 
label define label_xf2a06 23 "Logical imputation", add 
label define label_xf2a06 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a06 30 "Not applicable", add 
label define label_xf2a06 31 "Institution left item blank", add 
label define label_xf2a06 32 "Do not know", add 
label define label_xf2a06 33 "Particular 1st prof field not applicable", add 
label define label_xf2a06 50 "Outlier value derived from reported data", add 
label define label_xf2a06 51 "Outlier value derived from imported data", add 
label define label_xf2a06 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a06 53 "Value not derived - data not usable", add 
label values xf2a06 label_xf2a06
label define label_xf2a11 10 "Reported" 
label define label_xf2a11 11 "Analyst corrected reported value", add 
label define label_xf2a11 12 "Data generated from other data values", add 
label define label_xf2a11 13 "Implied zero", add 
label define label_xf2a11 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a11 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a11 22 "Imputed using the Group Median procedure", add 
label define label_xf2a11 23 "Logical imputation", add 
label define label_xf2a11 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a11 30 "Not applicable", add 
label define label_xf2a11 31 "Institution left item blank", add 
label define label_xf2a11 32 "Do not know", add 
label define label_xf2a11 33 "Particular 1st prof field not applicable", add 
label define label_xf2a11 50 "Outlier value derived from reported data", add 
label define label_xf2a11 51 "Outlier value derived from imported data", add 
label define label_xf2a11 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a11 53 "Value not derived - data not usable", add 
label values xf2a11 label_xf2a11
label define label_xf2a12 10 "Reported" 
label define label_xf2a12 11 "Analyst corrected reported value", add 
label define label_xf2a12 12 "Data generated from other data values", add 
label define label_xf2a12 13 "Implied zero", add 
label define label_xf2a12 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a12 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a12 22 "Imputed using the Group Median procedure", add 
label define label_xf2a12 23 "Logical imputation", add 
label define label_xf2a12 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a12 30 "Not applicable", add 
label define label_xf2a12 31 "Institution left item blank", add 
label define label_xf2a12 32 "Do not know", add 
label define label_xf2a12 33 "Particular 1st prof field not applicable", add 
label define label_xf2a12 50 "Outlier value derived from reported data", add 
label define label_xf2a12 51 "Outlier value derived from imported data", add 
label define label_xf2a12 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a12 53 "Value not derived - data not usable", add 
label values xf2a12 label_xf2a12
label define label_xf2a13 10 "Reported" 
label define label_xf2a13 11 "Analyst corrected reported value", add 
label define label_xf2a13 12 "Data generated from other data values", add 
label define label_xf2a13 13 "Implied zero", add 
label define label_xf2a13 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a13 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a13 22 "Imputed using the Group Median procedure", add 
label define label_xf2a13 23 "Logical imputation", add 
label define label_xf2a13 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a13 30 "Not applicable", add 
label define label_xf2a13 31 "Institution left item blank", add 
label define label_xf2a13 32 "Do not know", add 
label define label_xf2a13 33 "Particular 1st prof field not applicable", add 
label define label_xf2a13 50 "Outlier value derived from reported data", add 
label define label_xf2a13 51 "Outlier value derived from imported data", add 
label define label_xf2a13 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a13 53 "Value not derived - data not usable", add 
label values xf2a13 label_xf2a13
label define label_xf2a14 10 "Reported" 
label define label_xf2a14 11 "Analyst corrected reported value", add 
label define label_xf2a14 12 "Data generated from other data values", add 
label define label_xf2a14 13 "Implied zero", add 
label define label_xf2a14 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a14 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a14 22 "Imputed using the Group Median procedure", add 
label define label_xf2a14 23 "Logical imputation", add 
label define label_xf2a14 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a14 30 "Not applicable", add 
label define label_xf2a14 31 "Institution left item blank", add 
label define label_xf2a14 32 "Do not know", add 
label define label_xf2a14 33 "Particular 1st prof field not applicable", add 
label define label_xf2a14 50 "Outlier value derived from reported data", add 
label define label_xf2a14 51 "Outlier value derived from imported data", add 
label define label_xf2a14 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a14 53 "Value not derived - data not usable", add 
label values xf2a14 label_xf2a14
label define label_xf2a15 10 "Reported" 
label define label_xf2a15 11 "Analyst corrected reported value", add 
label define label_xf2a15 12 "Data generated from other data values", add 
label define label_xf2a15 13 "Implied zero", add 
label define label_xf2a15 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a15 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a15 22 "Imputed using the Group Median procedure", add 
label define label_xf2a15 23 "Logical imputation", add 
label define label_xf2a15 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a15 30 "Not applicable", add 
label define label_xf2a15 31 "Institution left item blank", add 
label define label_xf2a15 32 "Do not know", add 
label define label_xf2a15 33 "Particular 1st prof field not applicable", add 
label define label_xf2a15 50 "Outlier value derived from reported data", add 
label define label_xf2a15 51 "Outlier value derived from imported data", add 
label define label_xf2a15 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a15 53 "Value not derived - data not usable", add 
label values xf2a15 label_xf2a15
label define label_xf2a16 10 "Reported" 
label define label_xf2a16 11 "Analyst corrected reported value", add 
label define label_xf2a16 12 "Data generated from other data values", add 
label define label_xf2a16 13 "Implied zero", add 
label define label_xf2a16 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a16 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a16 22 "Imputed using the Group Median procedure", add 
label define label_xf2a16 23 "Logical imputation", add 
label define label_xf2a16 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a16 30 "Not applicable", add 
label define label_xf2a16 31 "Institution left item blank", add 
label define label_xf2a16 32 "Do not know", add 
label define label_xf2a16 33 "Particular 1st prof field not applicable", add 
label define label_xf2a16 50 "Outlier value derived from reported data", add 
label define label_xf2a16 51 "Outlier value derived from imported data", add 
label define label_xf2a16 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a16 53 "Value not derived - data not usable", add 
label values xf2a16 label_xf2a16
label define label_xf2a17 10 "Reported" 
label define label_xf2a17 11 "Analyst corrected reported value", add 
label define label_xf2a17 12 "Data generated from other data values", add 
label define label_xf2a17 13 "Implied zero", add 
label define label_xf2a17 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a17 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a17 22 "Imputed using the Group Median procedure", add 
label define label_xf2a17 23 "Logical imputation", add 
label define label_xf2a17 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a17 30 "Not applicable", add 
label define label_xf2a17 31 "Institution left item blank", add 
label define label_xf2a17 32 "Do not know", add 
label define label_xf2a17 33 "Particular 1st prof field not applicable", add 
label define label_xf2a17 50 "Outlier value derived from reported data", add 
label define label_xf2a17 51 "Outlier value derived from imported data", add 
label define label_xf2a17 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a17 53 "Value not derived - data not usable", add 
label values xf2a17 label_xf2a17
label define label_xf2a18 10 "Reported" 
label define label_xf2a18 11 "Analyst corrected reported value", add 
label define label_xf2a18 12 "Data generated from other data values", add 
label define label_xf2a18 13 "Implied zero", add 
label define label_xf2a18 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a18 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a18 22 "Imputed using the Group Median procedure", add 
label define label_xf2a18 23 "Logical imputation", add 
label define label_xf2a18 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a18 30 "Not applicable", add 
label define label_xf2a18 31 "Institution left item blank", add 
label define label_xf2a18 32 "Do not know", add 
label define label_xf2a18 33 "Particular 1st prof field not applicable", add 
label define label_xf2a18 50 "Outlier value derived from reported data", add 
label define label_xf2a18 51 "Outlier value derived from imported data", add 
label define label_xf2a18 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a18 53 "Value not derived - data not usable", add 
label values xf2a18 label_xf2a18
label define label_xf2a19 10 "Reported" 
label define label_xf2a19 11 "Analyst corrected reported value", add 
label define label_xf2a19 12 "Data generated from other data values", add 
label define label_xf2a19 13 "Implied zero", add 
label define label_xf2a19 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a19 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a19 22 "Imputed using the Group Median procedure", add 
label define label_xf2a19 23 "Logical imputation", add 
label define label_xf2a19 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a19 30 "Not applicable", add 
label define label_xf2a19 31 "Institution left item blank", add 
label define label_xf2a19 32 "Do not know", add 
label define label_xf2a19 33 "Particular 1st prof field not applicable", add 
label define label_xf2a19 50 "Outlier value derived from reported data", add 
label define label_xf2a19 51 "Outlier value derived from imported data", add 
label define label_xf2a19 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a19 53 "Value not derived - data not usable", add 
label values xf2a19 label_xf2a19
label define label_xf2a20 10 "Reported" 
label define label_xf2a20 11 "Analyst corrected reported value", add 
label define label_xf2a20 12 "Data generated from other data values", add 
label define label_xf2a20 13 "Implied zero", add 
label define label_xf2a20 20 "Imputed using Carry Forward procedure", add 
label define label_xf2a20 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2a20 22 "Imputed using the Group Median procedure", add 
label define label_xf2a20 23 "Logical imputation", add 
label define label_xf2a20 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2a20 30 "Not applicable", add 
label define label_xf2a20 31 "Institution left item blank", add 
label define label_xf2a20 32 "Do not know", add 
label define label_xf2a20 33 "Particular 1st prof field not applicable", add 
label define label_xf2a20 50 "Outlier value derived from reported data", add 
label define label_xf2a20 51 "Outlier value derived from imported data", add 
label define label_xf2a20 52 "Value not derived - parent/child differs across components", add 
label define label_xf2a20 53 "Value not derived - data not usable", add 
label values xf2a20 label_xf2a20
label define label_xf2b01 10 "Reported" 
label define label_xf2b01 11 "Analyst corrected reported value", add 
label define label_xf2b01 12 "Data generated from other data values", add 
label define label_xf2b01 13 "Implied zero", add 
label define label_xf2b01 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b01 22 "Imputed using the Group Median procedure", add 
label define label_xf2b01 23 "Logical imputation", add 
label define label_xf2b01 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2b01 30 "Not applicable", add 
label define label_xf2b01 31 "Institution left item blank", add 
label define label_xf2b01 32 "Do not know", add 
label define label_xf2b01 33 "Particular 1st prof field not applicable", add 
label define label_xf2b01 50 "Outlier value derived from reported data", add 
label define label_xf2b01 51 "Outlier value derived from imported data", add 
label define label_xf2b01 52 "Value not derived - parent/child differs across components", add 
label define label_xf2b01 53 "Value not derived - data not usable", add 
label values xf2b01 label_xf2b01
label define label_xf2b02 10 "Reported" 
label define label_xf2b02 11 "Analyst corrected reported value", add 
label define label_xf2b02 12 "Data generated from other data values", add 
label define label_xf2b02 13 "Implied zero", add 
label define label_xf2b02 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b02 22 "Imputed using the Group Median procedure", add 
label define label_xf2b02 23 "Logical imputation", add 
label define label_xf2b02 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2b02 30 "Not applicable", add 
label define label_xf2b02 31 "Institution left item blank", add 
label define label_xf2b02 32 "Do not know", add 
label define label_xf2b02 33 "Particular 1st prof field not applicable", add 
label define label_xf2b02 50 "Outlier value derived from reported data", add 
label define label_xf2b02 51 "Outlier value derived from imported data", add 
label define label_xf2b02 52 "Value not derived - parent/child differs across components", add 
label define label_xf2b02 53 "Value not derived - data not usable", add 
label values xf2b02 label_xf2b02
label define label_xf2b03 10 "Reported" 
label define label_xf2b03 11 "Analyst corrected reported value", add 
label define label_xf2b03 12 "Data generated from other data values", add 
label define label_xf2b03 13 "Implied zero", add 
label define label_xf2b03 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b03 22 "Imputed using the Group Median procedure", add 
label define label_xf2b03 23 "Logical imputation", add 
label define label_xf2b03 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2b03 30 "Not applicable", add 
label define label_xf2b03 31 "Institution left item blank", add 
label define label_xf2b03 32 "Do not know", add 
label define label_xf2b03 33 "Particular 1st prof field not applicable", add 
label define label_xf2b03 50 "Outlier value derived from reported data", add 
label define label_xf2b03 51 "Outlier value derived from imported data", add 
label define label_xf2b03 52 "Value not derived - parent/child differs across components", add 
label define label_xf2b03 53 "Value not derived - data not usable", add 
label values xf2b03 label_xf2b03
label define label_xf2b04 10 "Reported" 
label define label_xf2b04 11 "Analyst corrected reported value", add 
label define label_xf2b04 12 "Data generated from other data values", add 
label define label_xf2b04 13 "Implied zero", add 
label define label_xf2b04 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b04 22 "Imputed using the Group Median procedure", add 
label define label_xf2b04 23 "Logical imputation", add 
label define label_xf2b04 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2b04 30 "Not applicable", add 
label define label_xf2b04 31 "Institution left item blank", add 
label define label_xf2b04 32 "Do not know", add 
label define label_xf2b04 33 "Particular 1st prof field not applicable", add 
label define label_xf2b04 50 "Outlier value derived from reported data", add 
label define label_xf2b04 51 "Outlier value derived from imported data", add 
label define label_xf2b04 52 "Value not derived - parent/child differs across components", add 
label define label_xf2b04 53 "Value not derived - data not usable", add 
label values xf2b04 label_xf2b04
label define label_xf2b05 10 "Reported" 
label define label_xf2b05 11 "Analyst corrected reported value", add 
label define label_xf2b05 12 "Data generated from other data values", add 
label define label_xf2b05 13 "Implied zero", add 
label define label_xf2b05 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b05 22 "Imputed using the Group Median procedure", add 
label define label_xf2b05 23 "Logical imputation", add 
label define label_xf2b05 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2b05 30 "Not applicable", add 
label define label_xf2b05 31 "Institution left item blank", add 
label define label_xf2b05 32 "Do not know", add 
label define label_xf2b05 33 "Particular 1st prof field not applicable", add 
label define label_xf2b05 50 "Outlier value derived from reported data", add 
label define label_xf2b05 51 "Outlier value derived from imported data", add 
label define label_xf2b05 52 "Value not derived - parent/child differs across components", add 
label define label_xf2b05 53 "Value not derived - data not usable", add 
label values xf2b05 label_xf2b05
label define label_xf2b06 10 "Reported" 
label define label_xf2b06 11 "Analyst corrected reported value", add 
label define label_xf2b06 12 "Data generated from other data values", add 
label define label_xf2b06 13 "Implied zero", add 
label define label_xf2b06 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b06 22 "Imputed using the Group Median procedure", add 
label define label_xf2b06 23 "Logical imputation", add 
label define label_xf2b06 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2b06 30 "Not applicable", add 
label define label_xf2b06 31 "Institution left item blank", add 
label define label_xf2b06 32 "Do not know", add 
label define label_xf2b06 33 "Particular 1st prof field not applicable", add 
label define label_xf2b06 50 "Outlier value derived from reported data", add 
label define label_xf2b06 51 "Outlier value derived from imported data", add 
label define label_xf2b06 52 "Value not derived - parent/child differs across components", add 
label define label_xf2b06 53 "Value not derived - data not usable", add 
label values xf2b06 label_xf2b06
label define label_xf2b07 10 "Reported" 
label define label_xf2b07 11 "Analyst corrected reported value", add 
label define label_xf2b07 12 "Data generated from other data values", add 
label define label_xf2b07 13 "Implied zero", add 
label define label_xf2b07 20 "Imputed using Carry Forward procedure", add 
label define label_xf2b07 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2b07 22 "Imputed using the Group Median procedure", add 
label define label_xf2b07 23 "Logical imputation", add 
label define label_xf2b07 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2b07 30 "Not applicable", add 
label define label_xf2b07 31 "Institution left item blank", add 
label define label_xf2b07 32 "Do not know", add 
label define label_xf2b07 33 "Particular 1st prof field not applicable", add 
label define label_xf2b07 50 "Outlier value derived from reported data", add 
label define label_xf2b07 51 "Outlier value derived from imported data", add 
label define label_xf2b07 52 "Value not derived - parent/child differs across components", add 
label define label_xf2b07 53 "Value not derived - data not usable", add 
label values xf2b07 label_xf2b07
label define label_xf2c01 10 "Reported" 
label define label_xf2c01 11 "Analyst corrected reported value", add 
label define label_xf2c01 12 "Data generated from other data values", add 
label define label_xf2c01 13 "Implied zero", add 
label define label_xf2c01 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c01 22 "Imputed using the Group Median procedure", add 
label define label_xf2c01 23 "Logical imputation", add 
label define label_xf2c01 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2c01 30 "Not applicable", add 
label define label_xf2c01 31 "Institution left item blank", add 
label define label_xf2c01 32 "Do not know", add 
label define label_xf2c01 33 "Particular 1st prof field not applicable", add 
label define label_xf2c01 50 "Outlier value derived from reported data", add 
label define label_xf2c01 51 "Outlier value derived from imported data", add 
label define label_xf2c01 52 "Value not derived - parent/child differs across components", add 
label define label_xf2c01 53 "Value not derived - data not usable", add 
label values xf2c01 label_xf2c01
label define label_xf2c02 10 "Reported" 
label define label_xf2c02 11 "Analyst corrected reported value", add 
label define label_xf2c02 12 "Data generated from other data values", add 
label define label_xf2c02 13 "Implied zero", add 
label define label_xf2c02 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c02 22 "Imputed using the Group Median procedure", add 
label define label_xf2c02 23 "Logical imputation", add 
label define label_xf2c02 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2c02 30 "Not applicable", add 
label define label_xf2c02 31 "Institution left item blank", add 
label define label_xf2c02 32 "Do not know", add 
label define label_xf2c02 33 "Particular 1st prof field not applicable", add 
label define label_xf2c02 50 "Outlier value derived from reported data", add 
label define label_xf2c02 51 "Outlier value derived from imported data", add 
label define label_xf2c02 52 "Value not derived - parent/child differs across components", add 
label define label_xf2c02 53 "Value not derived - data not usable", add 
label values xf2c02 label_xf2c02
label define label_xf2c03 10 "Reported" 
label define label_xf2c03 11 "Analyst corrected reported value", add 
label define label_xf2c03 12 "Data generated from other data values", add 
label define label_xf2c03 13 "Implied zero", add 
label define label_xf2c03 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c03 22 "Imputed using the Group Median procedure", add 
label define label_xf2c03 23 "Logical imputation", add 
label define label_xf2c03 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2c03 30 "Not applicable", add 
label define label_xf2c03 31 "Institution left item blank", add 
label define label_xf2c03 32 "Do not know", add 
label define label_xf2c03 33 "Particular 1st prof field not applicable", add 
label define label_xf2c03 50 "Outlier value derived from reported data", add 
label define label_xf2c03 51 "Outlier value derived from imported data", add 
label define label_xf2c03 52 "Value not derived - parent/child differs across components", add 
label define label_xf2c03 53 "Value not derived - data not usable", add 
label values xf2c03 label_xf2c03
label define label_xf2c04 10 "Reported" 
label define label_xf2c04 11 "Analyst corrected reported value", add 
label define label_xf2c04 12 "Data generated from other data values", add 
label define label_xf2c04 13 "Implied zero", add 
label define label_xf2c04 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c04 22 "Imputed using the Group Median procedure", add 
label define label_xf2c04 23 "Logical imputation", add 
label define label_xf2c04 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2c04 30 "Not applicable", add 
label define label_xf2c04 31 "Institution left item blank", add 
label define label_xf2c04 32 "Do not know", add 
label define label_xf2c04 33 "Particular 1st prof field not applicable", add 
label define label_xf2c04 50 "Outlier value derived from reported data", add 
label define label_xf2c04 51 "Outlier value derived from imported data", add 
label define label_xf2c04 52 "Value not derived - parent/child differs across components", add 
label define label_xf2c04 53 "Value not derived - data not usable", add 
label values xf2c04 label_xf2c04
label define label_xf2c05 10 "Reported" 
label define label_xf2c05 11 "Analyst corrected reported value", add 
label define label_xf2c05 12 "Data generated from other data values", add 
label define label_xf2c05 13 "Implied zero", add 
label define label_xf2c05 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c05 22 "Imputed using the Group Median procedure", add 
label define label_xf2c05 23 "Logical imputation", add 
label define label_xf2c05 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2c05 30 "Not applicable", add 
label define label_xf2c05 31 "Institution left item blank", add 
label define label_xf2c05 32 "Do not know", add 
label define label_xf2c05 33 "Particular 1st prof field not applicable", add 
label define label_xf2c05 50 "Outlier value derived from reported data", add 
label define label_xf2c05 51 "Outlier value derived from imported data", add 
label define label_xf2c05 52 "Value not derived - parent/child differs across components", add 
label define label_xf2c05 53 "Value not derived - data not usable", add 
label values xf2c05 label_xf2c05
label define label_xf2c06 10 "Reported" 
label define label_xf2c06 11 "Analyst corrected reported value", add 
label define label_xf2c06 12 "Data generated from other data values", add 
label define label_xf2c06 13 "Implied zero", add 
label define label_xf2c06 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c06 22 "Imputed using the Group Median procedure", add 
label define label_xf2c06 23 "Logical imputation", add 
label define label_xf2c06 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2c06 30 "Not applicable", add 
label define label_xf2c06 31 "Institution left item blank", add 
label define label_xf2c06 32 "Do not know", add 
label define label_xf2c06 33 "Particular 1st prof field not applicable", add 
label define label_xf2c06 50 "Outlier value derived from reported data", add 
label define label_xf2c06 51 "Outlier value derived from imported data", add 
label define label_xf2c06 52 "Value not derived - parent/child differs across components", add 
label define label_xf2c06 53 "Value not derived - data not usable", add 
label values xf2c06 label_xf2c06
label define label_xf2c07 10 "Reported" 
label define label_xf2c07 11 "Analyst corrected reported value", add 
label define label_xf2c07 12 "Data generated from other data values", add 
label define label_xf2c07 13 "Implied zero", add 
label define label_xf2c07 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c07 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c07 22 "Imputed using the Group Median procedure", add 
label define label_xf2c07 23 "Logical imputation", add 
label define label_xf2c07 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2c07 30 "Not applicable", add 
label define label_xf2c07 31 "Institution left item blank", add 
label define label_xf2c07 32 "Do not know", add 
label define label_xf2c07 33 "Particular 1st prof field not applicable", add 
label define label_xf2c07 50 "Outlier value derived from reported data", add 
label define label_xf2c07 51 "Outlier value derived from imported data", add 
label define label_xf2c07 52 "Value not derived - parent/child differs across components", add 
label define label_xf2c07 53 "Value not derived - data not usable", add 
label values xf2c07 label_xf2c07
label define label_xf2c08 10 "Reported" 
label define label_xf2c08 11 "Analyst corrected reported value", add 
label define label_xf2c08 12 "Data generated from other data values", add 
label define label_xf2c08 13 "Implied zero", add 
label define label_xf2c08 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c08 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c08 22 "Imputed using the Group Median procedure", add 
label define label_xf2c08 23 "Logical imputation", add 
label define label_xf2c08 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2c08 30 "Not applicable", add 
label define label_xf2c08 31 "Institution left item blank", add 
label define label_xf2c08 32 "Do not know", add 
label define label_xf2c08 33 "Particular 1st prof field not applicable", add 
label define label_xf2c08 50 "Outlier value derived from reported data", add 
label define label_xf2c08 51 "Outlier value derived from imported data", add 
label define label_xf2c08 52 "Value not derived - parent/child differs across components", add 
label define label_xf2c08 53 "Value not derived - data not usable", add 
label values xf2c08 label_xf2c08
label define label_xf2c09 10 "Reported" 
label define label_xf2c09 11 "Analyst corrected reported value", add 
label define label_xf2c09 12 "Data generated from other data values", add 
label define label_xf2c09 13 "Implied zero", add 
label define label_xf2c09 20 "Imputed using Carry Forward procedure", add 
label define label_xf2c09 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2c09 22 "Imputed using the Group Median procedure", add 
label define label_xf2c09 23 "Logical imputation", add 
label define label_xf2c09 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2c09 30 "Not applicable", add 
label define label_xf2c09 31 "Institution left item blank", add 
label define label_xf2c09 32 "Do not know", add 
label define label_xf2c09 33 "Particular 1st prof field not applicable", add 
label define label_xf2c09 50 "Outlier value derived from reported data", add 
label define label_xf2c09 51 "Outlier value derived from imported data", add 
label define label_xf2c09 52 "Value not derived - parent/child differs across components", add 
label define label_xf2c09 53 "Value not derived - data not usable", add 
label values xf2c09 label_xf2c09
label define label_xf2d01 10 "Reported" 
label define label_xf2d01 11 "Analyst corrected reported value", add 
label define label_xf2d01 12 "Data generated from other data values", add 
label define label_xf2d01 13 "Implied zero", add 
label define label_xf2d01 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d01 22 "Imputed using the Group Median procedure", add 
label define label_xf2d01 23 "Logical imputation", add 
label define label_xf2d01 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d01 30 "Not applicable", add 
label define label_xf2d01 31 "Institution left item blank", add 
label define label_xf2d01 32 "Do not know", add 
label define label_xf2d01 33 "Particular 1st prof field not applicable", add 
label define label_xf2d01 50 "Outlier value derived from reported data", add 
label define label_xf2d01 51 "Outlier value derived from imported data", add 
label define label_xf2d01 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d01 53 "Value not derived - data not usable", add 
label values xf2d01 label_xf2d01
label define label_xf2d012 10 "Reported" 
label define label_xf2d012 11 "Analyst corrected reported value", add 
label define label_xf2d012 12 "Data generated from other data values", add 
label define label_xf2d012 13 "Implied zero", add 
label define label_xf2d012 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d012 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d012 22 "Imputed using the Group Median procedure", add 
label define label_xf2d012 23 "Logical imputation", add 
label define label_xf2d012 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d012 30 "Not applicable", add 
label define label_xf2d012 31 "Institution left item blank", add 
label define label_xf2d012 32 "Do not know", add 
label define label_xf2d012 33 "Particular 1st prof field not applicable", add 
label define label_xf2d012 50 "Outlier value derived from reported data", add 
label define label_xf2d012 51 "Outlier value derived from imported data", add 
label define label_xf2d012 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d012 53 "Value not derived - data not usable", add 
label values xf2d012 label_xf2d012
label define label_xf2d013 10 "Reported" 
label define label_xf2d013 11 "Analyst corrected reported value", add 
label define label_xf2d013 12 "Data generated from other data values", add 
label define label_xf2d013 13 "Implied zero", add 
label define label_xf2d013 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d013 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d013 22 "Imputed using the Group Median procedure", add 
label define label_xf2d013 23 "Logical imputation", add 
label define label_xf2d013 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d013 30 "Not applicable", add 
label define label_xf2d013 31 "Institution left item blank", add 
label define label_xf2d013 32 "Do not know", add 
label define label_xf2d013 33 "Particular 1st prof field not applicable", add 
label define label_xf2d013 50 "Outlier value derived from reported data", add 
label define label_xf2d013 51 "Outlier value derived from imported data", add 
label define label_xf2d013 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d013 53 "Value not derived - data not usable", add 
label values xf2d013 label_xf2d013
label define label_xf2d014 10 "Reported" 
label define label_xf2d014 11 "Analyst corrected reported value", add 
label define label_xf2d014 12 "Data generated from other data values", add 
label define label_xf2d014 13 "Implied zero", add 
label define label_xf2d014 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d014 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d014 22 "Imputed using the Group Median procedure", add 
label define label_xf2d014 23 "Logical imputation", add 
label define label_xf2d014 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d014 30 "Not applicable", add 
label define label_xf2d014 31 "Institution left item blank", add 
label define label_xf2d014 32 "Do not know", add 
label define label_xf2d014 33 "Particular 1st prof field not applicable", add 
label define label_xf2d014 50 "Outlier value derived from reported data", add 
label define label_xf2d014 51 "Outlier value derived from imported data", add 
label define label_xf2d014 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d014 53 "Value not derived - data not usable", add 
label values xf2d014 label_xf2d014
label define label_xf2d02 10 "Reported" 
label define label_xf2d02 11 "Analyst corrected reported value", add 
label define label_xf2d02 12 "Data generated from other data values", add 
label define label_xf2d02 13 "Implied zero", add 
label define label_xf2d02 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d02 22 "Imputed using the Group Median procedure", add 
label define label_xf2d02 23 "Logical imputation", add 
label define label_xf2d02 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d02 30 "Not applicable", add 
label define label_xf2d02 31 "Institution left item blank", add 
label define label_xf2d02 32 "Do not know", add 
label define label_xf2d02 33 "Particular 1st prof field not applicable", add 
label define label_xf2d02 50 "Outlier value derived from reported data", add 
label define label_xf2d02 51 "Outlier value derived from imported data", add 
label define label_xf2d02 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d02 53 "Value not derived - data not usable", add 
label values xf2d02 label_xf2d02
label define label_xf2d022 10 "Reported" 
label define label_xf2d022 11 "Analyst corrected reported value", add 
label define label_xf2d022 12 "Data generated from other data values", add 
label define label_xf2d022 13 "Implied zero", add 
label define label_xf2d022 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d022 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d022 22 "Imputed using the Group Median procedure", add 
label define label_xf2d022 23 "Logical imputation", add 
label define label_xf2d022 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d022 30 "Not applicable", add 
label define label_xf2d022 31 "Institution left item blank", add 
label define label_xf2d022 32 "Do not know", add 
label define label_xf2d022 33 "Particular 1st prof field not applicable", add 
label define label_xf2d022 50 "Outlier value derived from reported data", add 
label define label_xf2d022 51 "Outlier value derived from imported data", add 
label define label_xf2d022 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d022 53 "Value not derived - data not usable", add 
label values xf2d022 label_xf2d022
label define label_xf2d023 10 "Reported" 
label define label_xf2d023 11 "Analyst corrected reported value", add 
label define label_xf2d023 12 "Data generated from other data values", add 
label define label_xf2d023 13 "Implied zero", add 
label define label_xf2d023 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d023 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d023 22 "Imputed using the Group Median procedure", add 
label define label_xf2d023 23 "Logical imputation", add 
label define label_xf2d023 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d023 30 "Not applicable", add 
label define label_xf2d023 31 "Institution left item blank", add 
label define label_xf2d023 32 "Do not know", add 
label define label_xf2d023 33 "Particular 1st prof field not applicable", add 
label define label_xf2d023 50 "Outlier value derived from reported data", add 
label define label_xf2d023 51 "Outlier value derived from imported data", add 
label define label_xf2d023 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d023 53 "Value not derived - data not usable", add 
label values xf2d023 label_xf2d023
label define label_xf2d024 10 "Reported" 
label define label_xf2d024 11 "Analyst corrected reported value", add 
label define label_xf2d024 12 "Data generated from other data values", add 
label define label_xf2d024 13 "Implied zero", add 
label define label_xf2d024 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d024 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d024 22 "Imputed using the Group Median procedure", add 
label define label_xf2d024 23 "Logical imputation", add 
label define label_xf2d024 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d024 30 "Not applicable", add 
label define label_xf2d024 31 "Institution left item blank", add 
label define label_xf2d024 32 "Do not know", add 
label define label_xf2d024 33 "Particular 1st prof field not applicable", add 
label define label_xf2d024 50 "Outlier value derived from reported data", add 
label define label_xf2d024 51 "Outlier value derived from imported data", add 
label define label_xf2d024 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d024 53 "Value not derived - data not usable", add 
label values xf2d024 label_xf2d024
label define label_xf2d03 10 "Reported" 
label define label_xf2d03 11 "Analyst corrected reported value", add 
label define label_xf2d03 12 "Data generated from other data values", add 
label define label_xf2d03 13 "Implied zero", add 
label define label_xf2d03 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d03 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d03 22 "Imputed using the Group Median procedure", add 
label define label_xf2d03 23 "Logical imputation", add 
label define label_xf2d03 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d03 30 "Not applicable", add 
label define label_xf2d03 31 "Institution left item blank", add 
label define label_xf2d03 32 "Do not know", add 
label define label_xf2d03 33 "Particular 1st prof field not applicable", add 
label define label_xf2d03 50 "Outlier value derived from reported data", add 
label define label_xf2d03 51 "Outlier value derived from imported data", add 
label define label_xf2d03 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d03 53 "Value not derived - data not usable", add 
label values xf2d03 label_xf2d03
label define label_xf2d032 10 "Reported" 
label define label_xf2d032 11 "Analyst corrected reported value", add 
label define label_xf2d032 12 "Data generated from other data values", add 
label define label_xf2d032 13 "Implied zero", add 
label define label_xf2d032 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d032 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d032 22 "Imputed using the Group Median procedure", add 
label define label_xf2d032 23 "Logical imputation", add 
label define label_xf2d032 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d032 30 "Not applicable", add 
label define label_xf2d032 31 "Institution left item blank", add 
label define label_xf2d032 32 "Do not know", add 
label define label_xf2d032 33 "Particular 1st prof field not applicable", add 
label define label_xf2d032 50 "Outlier value derived from reported data", add 
label define label_xf2d032 51 "Outlier value derived from imported data", add 
label define label_xf2d032 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d032 53 "Value not derived - data not usable", add 
label values xf2d032 label_xf2d032
label define label_xf2d033 10 "Reported" 
label define label_xf2d033 11 "Analyst corrected reported value", add 
label define label_xf2d033 12 "Data generated from other data values", add 
label define label_xf2d033 13 "Implied zero", add 
label define label_xf2d033 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d033 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d033 22 "Imputed using the Group Median procedure", add 
label define label_xf2d033 23 "Logical imputation", add 
label define label_xf2d033 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d033 30 "Not applicable", add 
label define label_xf2d033 31 "Institution left item blank", add 
label define label_xf2d033 32 "Do not know", add 
label define label_xf2d033 33 "Particular 1st prof field not applicable", add 
label define label_xf2d033 50 "Outlier value derived from reported data", add 
label define label_xf2d033 51 "Outlier value derived from imported data", add 
label define label_xf2d033 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d033 53 "Value not derived - data not usable", add 
label values xf2d033 label_xf2d033
label define label_xf2d034 10 "Reported" 
label define label_xf2d034 11 "Analyst corrected reported value", add 
label define label_xf2d034 12 "Data generated from other data values", add 
label define label_xf2d034 13 "Implied zero", add 
label define label_xf2d034 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d034 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d034 22 "Imputed using the Group Median procedure", add 
label define label_xf2d034 23 "Logical imputation", add 
label define label_xf2d034 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d034 30 "Not applicable", add 
label define label_xf2d034 31 "Institution left item blank", add 
label define label_xf2d034 32 "Do not know", add 
label define label_xf2d034 33 "Particular 1st prof field not applicable", add 
label define label_xf2d034 50 "Outlier value derived from reported data", add 
label define label_xf2d034 51 "Outlier value derived from imported data", add 
label define label_xf2d034 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d034 53 "Value not derived - data not usable", add 
label values xf2d034 label_xf2d034
label define label_xf2d04 10 "Reported" 
label define label_xf2d04 11 "Analyst corrected reported value", add 
label define label_xf2d04 12 "Data generated from other data values", add 
label define label_xf2d04 13 "Implied zero", add 
label define label_xf2d04 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d04 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d04 22 "Imputed using the Group Median procedure", add 
label define label_xf2d04 23 "Logical imputation", add 
label define label_xf2d04 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d04 30 "Not applicable", add 
label define label_xf2d04 31 "Institution left item blank", add 
label define label_xf2d04 32 "Do not know", add 
label define label_xf2d04 33 "Particular 1st prof field not applicable", add 
label define label_xf2d04 50 "Outlier value derived from reported data", add 
label define label_xf2d04 51 "Outlier value derived from imported data", add 
label define label_xf2d04 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d04 53 "Value not derived - data not usable", add 
label values xf2d04 label_xf2d04
label define label_xf2d042 10 "Reported" 
label define label_xf2d042 11 "Analyst corrected reported value", add 
label define label_xf2d042 12 "Data generated from other data values", add 
label define label_xf2d042 13 "Implied zero", add 
label define label_xf2d042 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d042 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d042 22 "Imputed using the Group Median procedure", add 
label define label_xf2d042 23 "Logical imputation", add 
label define label_xf2d042 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d042 30 "Not applicable", add 
label define label_xf2d042 31 "Institution left item blank", add 
label define label_xf2d042 32 "Do not know", add 
label define label_xf2d042 33 "Particular 1st prof field not applicable", add 
label define label_xf2d042 50 "Outlier value derived from reported data", add 
label define label_xf2d042 51 "Outlier value derived from imported data", add 
label define label_xf2d042 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d042 53 "Value not derived - data not usable", add 
label values xf2d042 label_xf2d042
label define label_xf2d043 10 "Reported" 
label define label_xf2d043 11 "Analyst corrected reported value", add 
label define label_xf2d043 12 "Data generated from other data values", add 
label define label_xf2d043 13 "Implied zero", add 
label define label_xf2d043 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d043 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d043 22 "Imputed using the Group Median procedure", add 
label define label_xf2d043 23 "Logical imputation", add 
label define label_xf2d043 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d043 30 "Not applicable", add 
label define label_xf2d043 31 "Institution left item blank", add 
label define label_xf2d043 32 "Do not know", add 
label define label_xf2d043 33 "Particular 1st prof field not applicable", add 
label define label_xf2d043 50 "Outlier value derived from reported data", add 
label define label_xf2d043 51 "Outlier value derived from imported data", add 
label define label_xf2d043 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d043 53 "Value not derived - data not usable", add 
label values xf2d043 label_xf2d043
label define label_xf2d044 10 "Reported" 
label define label_xf2d044 11 "Analyst corrected reported value", add 
label define label_xf2d044 12 "Data generated from other data values", add 
label define label_xf2d044 13 "Implied zero", add 
label define label_xf2d044 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d044 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d044 22 "Imputed using the Group Median procedure", add 
label define label_xf2d044 23 "Logical imputation", add 
label define label_xf2d044 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d044 30 "Not applicable", add 
label define label_xf2d044 31 "Institution left item blank", add 
label define label_xf2d044 32 "Do not know", add 
label define label_xf2d044 33 "Particular 1st prof field not applicable", add 
label define label_xf2d044 50 "Outlier value derived from reported data", add 
label define label_xf2d044 51 "Outlier value derived from imported data", add 
label define label_xf2d044 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d044 53 "Value not derived - data not usable", add 
label values xf2d044 label_xf2d044
label define label_xf2d05 10 "Reported" 
label define label_xf2d05 11 "Analyst corrected reported value", add 
label define label_xf2d05 12 "Data generated from other data values", add 
label define label_xf2d05 13 "Implied zero", add 
label define label_xf2d05 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d05 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d05 22 "Imputed using the Group Median procedure", add 
label define label_xf2d05 23 "Logical imputation", add 
label define label_xf2d05 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d05 30 "Not applicable", add 
label define label_xf2d05 31 "Institution left item blank", add 
label define label_xf2d05 32 "Do not know", add 
label define label_xf2d05 33 "Particular 1st prof field not applicable", add 
label define label_xf2d05 50 "Outlier value derived from reported data", add 
label define label_xf2d05 51 "Outlier value derived from imported data", add 
label define label_xf2d05 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d05 53 "Value not derived - data not usable", add 
label values xf2d05 label_xf2d05
label define label_xf2d052 10 "Reported" 
label define label_xf2d052 11 "Analyst corrected reported value", add 
label define label_xf2d052 12 "Data generated from other data values", add 
label define label_xf2d052 13 "Implied zero", add 
label define label_xf2d052 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d052 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d052 22 "Imputed using the Group Median procedure", add 
label define label_xf2d052 23 "Logical imputation", add 
label define label_xf2d052 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d052 30 "Not applicable", add 
label define label_xf2d052 31 "Institution left item blank", add 
label define label_xf2d052 32 "Do not know", add 
label define label_xf2d052 33 "Particular 1st prof field not applicable", add 
label define label_xf2d052 50 "Outlier value derived from reported data", add 
label define label_xf2d052 51 "Outlier value derived from imported data", add 
label define label_xf2d052 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d052 53 "Value not derived - data not usable", add 
label values xf2d052 label_xf2d052
label define label_xf2d053 10 "Reported" 
label define label_xf2d053 11 "Analyst corrected reported value", add 
label define label_xf2d053 12 "Data generated from other data values", add 
label define label_xf2d053 13 "Implied zero", add 
label define label_xf2d053 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d053 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d053 22 "Imputed using the Group Median procedure", add 
label define label_xf2d053 23 "Logical imputation", add 
label define label_xf2d053 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d053 30 "Not applicable", add 
label define label_xf2d053 31 "Institution left item blank", add 
label define label_xf2d053 32 "Do not know", add 
label define label_xf2d053 33 "Particular 1st prof field not applicable", add 
label define label_xf2d053 50 "Outlier value derived from reported data", add 
label define label_xf2d053 51 "Outlier value derived from imported data", add 
label define label_xf2d053 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d053 53 "Value not derived - data not usable", add 
label values xf2d053 label_xf2d053
label define label_xf2d054 10 "Reported" 
label define label_xf2d054 11 "Analyst corrected reported value", add 
label define label_xf2d054 12 "Data generated from other data values", add 
label define label_xf2d054 13 "Implied zero", add 
label define label_xf2d054 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d054 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d054 22 "Imputed using the Group Median procedure", add 
label define label_xf2d054 23 "Logical imputation", add 
label define label_xf2d054 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d054 30 "Not applicable", add 
label define label_xf2d054 31 "Institution left item blank", add 
label define label_xf2d054 32 "Do not know", add 
label define label_xf2d054 33 "Particular 1st prof field not applicable", add 
label define label_xf2d054 50 "Outlier value derived from reported data", add 
label define label_xf2d054 51 "Outlier value derived from imported data", add 
label define label_xf2d054 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d054 53 "Value not derived - data not usable", add 
label values xf2d054 label_xf2d054
label define label_xf2d06 10 "Reported" 
label define label_xf2d06 11 "Analyst corrected reported value", add 
label define label_xf2d06 12 "Data generated from other data values", add 
label define label_xf2d06 13 "Implied zero", add 
label define label_xf2d06 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d06 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d06 22 "Imputed using the Group Median procedure", add 
label define label_xf2d06 23 "Logical imputation", add 
label define label_xf2d06 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d06 30 "Not applicable", add 
label define label_xf2d06 31 "Institution left item blank", add 
label define label_xf2d06 32 "Do not know", add 
label define label_xf2d06 33 "Particular 1st prof field not applicable", add 
label define label_xf2d06 50 "Outlier value derived from reported data", add 
label define label_xf2d06 51 "Outlier value derived from imported data", add 
label define label_xf2d06 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d06 53 "Value not derived - data not usable", add 
label values xf2d06 label_xf2d06
label define label_xf2d062 10 "Reported" 
label define label_xf2d062 11 "Analyst corrected reported value", add 
label define label_xf2d062 12 "Data generated from other data values", add 
label define label_xf2d062 13 "Implied zero", add 
label define label_xf2d062 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d062 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d062 22 "Imputed using the Group Median procedure", add 
label define label_xf2d062 23 "Logical imputation", add 
label define label_xf2d062 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d062 30 "Not applicable", add 
label define label_xf2d062 31 "Institution left item blank", add 
label define label_xf2d062 32 "Do not know", add 
label define label_xf2d062 33 "Particular 1st prof field not applicable", add 
label define label_xf2d062 50 "Outlier value derived from reported data", add 
label define label_xf2d062 51 "Outlier value derived from imported data", add 
label define label_xf2d062 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d062 53 "Value not derived - data not usable", add 
label values xf2d062 label_xf2d062
label define label_xf2d063 10 "Reported" 
label define label_xf2d063 11 "Analyst corrected reported value", add 
label define label_xf2d063 12 "Data generated from other data values", add 
label define label_xf2d063 13 "Implied zero", add 
label define label_xf2d063 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d063 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d063 22 "Imputed using the Group Median procedure", add 
label define label_xf2d063 23 "Logical imputation", add 
label define label_xf2d063 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d063 30 "Not applicable", add 
label define label_xf2d063 31 "Institution left item blank", add 
label define label_xf2d063 32 "Do not know", add 
label define label_xf2d063 33 "Particular 1st prof field not applicable", add 
label define label_xf2d063 50 "Outlier value derived from reported data", add 
label define label_xf2d063 51 "Outlier value derived from imported data", add 
label define label_xf2d063 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d063 53 "Value not derived - data not usable", add 
label values xf2d063 label_xf2d063
label define label_xf2d064 10 "Reported" 
label define label_xf2d064 11 "Analyst corrected reported value", add 
label define label_xf2d064 12 "Data generated from other data values", add 
label define label_xf2d064 13 "Implied zero", add 
label define label_xf2d064 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d064 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d064 22 "Imputed using the Group Median procedure", add 
label define label_xf2d064 23 "Logical imputation", add 
label define label_xf2d064 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d064 30 "Not applicable", add 
label define label_xf2d064 31 "Institution left item blank", add 
label define label_xf2d064 32 "Do not know", add 
label define label_xf2d064 33 "Particular 1st prof field not applicable", add 
label define label_xf2d064 50 "Outlier value derived from reported data", add 
label define label_xf2d064 51 "Outlier value derived from imported data", add 
label define label_xf2d064 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d064 53 "Value not derived - data not usable", add 
label values xf2d064 label_xf2d064
label define label_xf2d07 10 "Reported" 
label define label_xf2d07 11 "Analyst corrected reported value", add 
label define label_xf2d07 12 "Data generated from other data values", add 
label define label_xf2d07 13 "Implied zero", add 
label define label_xf2d07 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d07 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d07 22 "Imputed using the Group Median procedure", add 
label define label_xf2d07 23 "Logical imputation", add 
label define label_xf2d07 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d07 30 "Not applicable", add 
label define label_xf2d07 31 "Institution left item blank", add 
label define label_xf2d07 32 "Do not know", add 
label define label_xf2d07 33 "Particular 1st prof field not applicable", add 
label define label_xf2d07 50 "Outlier value derived from reported data", add 
label define label_xf2d07 51 "Outlier value derived from imported data", add 
label define label_xf2d07 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d07 53 "Value not derived - data not usable", add 
label values xf2d07 label_xf2d07
label define label_xf2d072 10 "Reported" 
label define label_xf2d072 11 "Analyst corrected reported value", add 
label define label_xf2d072 12 "Data generated from other data values", add 
label define label_xf2d072 13 "Implied zero", add 
label define label_xf2d072 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d072 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d072 22 "Imputed using the Group Median procedure", add 
label define label_xf2d072 23 "Logical imputation", add 
label define label_xf2d072 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d072 30 "Not applicable", add 
label define label_xf2d072 31 "Institution left item blank", add 
label define label_xf2d072 32 "Do not know", add 
label define label_xf2d072 33 "Particular 1st prof field not applicable", add 
label define label_xf2d072 50 "Outlier value derived from reported data", add 
label define label_xf2d072 51 "Outlier value derived from imported data", add 
label define label_xf2d072 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d072 53 "Value not derived - data not usable", add 
label values xf2d072 label_xf2d072
label define label_xf2d073 10 "Reported" 
label define label_xf2d073 11 "Analyst corrected reported value", add 
label define label_xf2d073 12 "Data generated from other data values", add 
label define label_xf2d073 13 "Implied zero", add 
label define label_xf2d073 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d073 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d073 22 "Imputed using the Group Median procedure", add 
label define label_xf2d073 23 "Logical imputation", add 
label define label_xf2d073 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d073 30 "Not applicable", add 
label define label_xf2d073 31 "Institution left item blank", add 
label define label_xf2d073 32 "Do not know", add 
label define label_xf2d073 33 "Particular 1st prof field not applicable", add 
label define label_xf2d073 50 "Outlier value derived from reported data", add 
label define label_xf2d073 51 "Outlier value derived from imported data", add 
label define label_xf2d073 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d073 53 "Value not derived - data not usable", add 
label values xf2d073 label_xf2d073
label define label_xf2d074 10 "Reported" 
label define label_xf2d074 11 "Analyst corrected reported value", add 
label define label_xf2d074 12 "Data generated from other data values", add 
label define label_xf2d074 13 "Implied zero", add 
label define label_xf2d074 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d074 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d074 22 "Imputed using the Group Median procedure", add 
label define label_xf2d074 23 "Logical imputation", add 
label define label_xf2d074 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d074 30 "Not applicable", add 
label define label_xf2d074 31 "Institution left item blank", add 
label define label_xf2d074 32 "Do not know", add 
label define label_xf2d074 33 "Particular 1st prof field not applicable", add 
label define label_xf2d074 50 "Outlier value derived from reported data", add 
label define label_xf2d074 51 "Outlier value derived from imported data", add 
label define label_xf2d074 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d074 53 "Value not derived - data not usable", add 
label values xf2d074 label_xf2d074
label define label_xf2d08 10 "Reported" 
label define label_xf2d08 11 "Analyst corrected reported value", add 
label define label_xf2d08 12 "Data generated from other data values", add 
label define label_xf2d08 13 "Implied zero", add 
label define label_xf2d08 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d08 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d08 22 "Imputed using the Group Median procedure", add 
label define label_xf2d08 23 "Logical imputation", add 
label define label_xf2d08 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d08 30 "Not applicable", add 
label define label_xf2d08 31 "Institution left item blank", add 
label define label_xf2d08 32 "Do not know", add 
label define label_xf2d08 33 "Particular 1st prof field not applicable", add 
label define label_xf2d08 50 "Outlier value derived from reported data", add 
label define label_xf2d08 51 "Outlier value derived from imported data", add 
label define label_xf2d08 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d08 53 "Value not derived - data not usable", add 
label values xf2d08 label_xf2d08
label define label_xf2d082 10 "Reported" 
label define label_xf2d082 11 "Analyst corrected reported value", add 
label define label_xf2d082 12 "Data generated from other data values", add 
label define label_xf2d082 13 "Implied zero", add 
label define label_xf2d082 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d082 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d082 22 "Imputed using the Group Median procedure", add 
label define label_xf2d082 23 "Logical imputation", add 
label define label_xf2d082 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d082 30 "Not applicable", add 
label define label_xf2d082 31 "Institution left item blank", add 
label define label_xf2d082 32 "Do not know", add 
label define label_xf2d082 33 "Particular 1st prof field not applicable", add 
label define label_xf2d082 50 "Outlier value derived from reported data", add 
label define label_xf2d082 51 "Outlier value derived from imported data", add 
label define label_xf2d082 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d082 53 "Value not derived - data not usable", add 
label values xf2d082 label_xf2d082
label define label_xf2d083 10 "Reported" 
label define label_xf2d083 11 "Analyst corrected reported value", add 
label define label_xf2d083 12 "Data generated from other data values", add 
label define label_xf2d083 13 "Implied zero", add 
label define label_xf2d083 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d083 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d083 22 "Imputed using the Group Median procedure", add 
label define label_xf2d083 23 "Logical imputation", add 
label define label_xf2d083 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d083 30 "Not applicable", add 
label define label_xf2d083 31 "Institution left item blank", add 
label define label_xf2d083 32 "Do not know", add 
label define label_xf2d083 33 "Particular 1st prof field not applicable", add 
label define label_xf2d083 50 "Outlier value derived from reported data", add 
label define label_xf2d083 51 "Outlier value derived from imported data", add 
label define label_xf2d083 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d083 53 "Value not derived - data not usable", add 
label values xf2d083 label_xf2d083
label define label_xf2d084 10 "Reported" 
label define label_xf2d084 11 "Analyst corrected reported value", add 
label define label_xf2d084 12 "Data generated from other data values", add 
label define label_xf2d084 13 "Implied zero", add 
label define label_xf2d084 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d084 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d084 22 "Imputed using the Group Median procedure", add 
label define label_xf2d084 23 "Logical imputation", add 
label define label_xf2d084 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d084 30 "Not applicable", add 
label define label_xf2d084 31 "Institution left item blank", add 
label define label_xf2d084 32 "Do not know", add 
label define label_xf2d084 33 "Particular 1st prof field not applicable", add 
label define label_xf2d084 50 "Outlier value derived from reported data", add 
label define label_xf2d084 51 "Outlier value derived from imported data", add 
label define label_xf2d084 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d084 53 "Value not derived - data not usable", add 
label values xf2d084 label_xf2d084
label define label_xf2d08a 10 "Reported" 
label define label_xf2d08a 11 "Analyst corrected reported value", add 
label define label_xf2d08a 12 "Data generated from other data values", add 
label define label_xf2d08a 13 "Implied zero", add 
label define label_xf2d08a 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d08a 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d08a 22 "Imputed using the Group Median procedure", add 
label define label_xf2d08a 23 "Logical imputation", add 
label define label_xf2d08a 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d08a 30 "Not applicable", add 
label define label_xf2d08a 31 "Institution left item blank", add 
label define label_xf2d08a 32 "Do not know", add 
label define label_xf2d08a 33 "Particular 1st prof field not applicable", add 
label define label_xf2d08a 50 "Outlier value derived from reported data", add 
label define label_xf2d08a 51 "Outlier value derived from imported data", add 
label define label_xf2d08a 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d08a 53 "Value not derived - data not usable", add 
label values xf2d08a label_xf2d08a
label define label_xf2d082a 10 "Reported" 
label define label_xf2d082a 11 "Analyst corrected reported value", add 
label define label_xf2d082a 12 "Data generated from other data values", add 
label define label_xf2d082a 13 "Implied zero", add 
label define label_xf2d082a 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d082a 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d082a 22 "Imputed using the Group Median procedure", add 
label define label_xf2d082a 23 "Logical imputation", add 
label define label_xf2d082a 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d082a 30 "Not applicable", add 
label define label_xf2d082a 31 "Institution left item blank", add 
label define label_xf2d082a 32 "Do not know", add 
label define label_xf2d082a 33 "Particular 1st prof field not applicable", add 
label define label_xf2d082a 50 "Outlier value derived from reported data", add 
label define label_xf2d082a 51 "Outlier value derived from imported data", add 
label define label_xf2d082a 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d082a 53 "Value not derived - data not usable", add 
label values xf2d082a label_xf2d082a
label define label_xf2d083a 10 "Reported" 
label define label_xf2d083a 11 "Analyst corrected reported value", add 
label define label_xf2d083a 12 "Data generated from other data values", add 
label define label_xf2d083a 13 "Implied zero", add 
label define label_xf2d083a 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d083a 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d083a 22 "Imputed using the Group Median procedure", add 
label define label_xf2d083a 23 "Logical imputation", add 
label define label_xf2d083a 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d083a 30 "Not applicable", add 
label define label_xf2d083a 31 "Institution left item blank", add 
label define label_xf2d083a 32 "Do not know", add 
label define label_xf2d083a 33 "Particular 1st prof field not applicable", add 
label define label_xf2d083a 50 "Outlier value derived from reported data", add 
label define label_xf2d083a 51 "Outlier value derived from imported data", add 
label define label_xf2d083a 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d083a 53 "Value not derived - data not usable", add 
label values xf2d083a label_xf2d083a
label define label_xf2d084a 10 "Reported" 
label define label_xf2d084a 11 "Analyst corrected reported value", add 
label define label_xf2d084a 12 "Data generated from other data values", add 
label define label_xf2d084a 13 "Implied zero", add 
label define label_xf2d084a 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d084a 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d084a 22 "Imputed using the Group Median procedure", add 
label define label_xf2d084a 23 "Logical imputation", add 
label define label_xf2d084a 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d084a 30 "Not applicable", add 
label define label_xf2d084a 31 "Institution left item blank", add 
label define label_xf2d084a 32 "Do not know", add 
label define label_xf2d084a 33 "Particular 1st prof field not applicable", add 
label define label_xf2d084a 50 "Outlier value derived from reported data", add 
label define label_xf2d084a 51 "Outlier value derived from imported data", add 
label define label_xf2d084a 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d084a 53 "Value not derived - data not usable", add 
label values xf2d084a label_xf2d084a
label define label_xf2d08b 10 "Reported" 
label define label_xf2d08b 11 "Analyst corrected reported value", add 
label define label_xf2d08b 12 "Data generated from other data values", add 
label define label_xf2d08b 13 "Implied zero", add 
label define label_xf2d08b 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d08b 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d08b 22 "Imputed using the Group Median procedure", add 
label define label_xf2d08b 23 "Logical imputation", add 
label define label_xf2d08b 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d08b 30 "Not applicable", add 
label define label_xf2d08b 31 "Institution left item blank", add 
label define label_xf2d08b 32 "Do not know", add 
label define label_xf2d08b 33 "Particular 1st prof field not applicable", add 
label define label_xf2d08b 50 "Outlier value derived from reported data", add 
label define label_xf2d08b 51 "Outlier value derived from imported data", add 
label define label_xf2d08b 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d08b 53 "Value not derived - data not usable", add 
label values xf2d08b label_xf2d08b
label define label_xf2d082b 10 "Reported" 
label define label_xf2d082b 11 "Analyst corrected reported value", add 
label define label_xf2d082b 12 "Data generated from other data values", add 
label define label_xf2d082b 13 "Implied zero", add 
label define label_xf2d082b 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d082b 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d082b 22 "Imputed using the Group Median procedure", add 
label define label_xf2d082b 23 "Logical imputation", add 
label define label_xf2d082b 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d082b 30 "Not applicable", add 
label define label_xf2d082b 31 "Institution left item blank", add 
label define label_xf2d082b 32 "Do not know", add 
label define label_xf2d082b 33 "Particular 1st prof field not applicable", add 
label define label_xf2d082b 50 "Outlier value derived from reported data", add 
label define label_xf2d082b 51 "Outlier value derived from imported data", add 
label define label_xf2d082b 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d082b 53 "Value not derived - data not usable", add 
label values xf2d082b label_xf2d082b
label define label_xf2d083b 10 "Reported" 
label define label_xf2d083b 11 "Analyst corrected reported value", add 
label define label_xf2d083b 12 "Data generated from other data values", add 
label define label_xf2d083b 13 "Implied zero", add 
label define label_xf2d083b 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d083b 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d083b 22 "Imputed using the Group Median procedure", add 
label define label_xf2d083b 23 "Logical imputation", add 
label define label_xf2d083b 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d083b 30 "Not applicable", add 
label define label_xf2d083b 31 "Institution left item blank", add 
label define label_xf2d083b 32 "Do not know", add 
label define label_xf2d083b 33 "Particular 1st prof field not applicable", add 
label define label_xf2d083b 50 "Outlier value derived from reported data", add 
label define label_xf2d083b 51 "Outlier value derived from imported data", add 
label define label_xf2d083b 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d083b 53 "Value not derived - data not usable", add 
label values xf2d083b label_xf2d083b
label define label_xf2d084b 10 "Reported" 
label define label_xf2d084b 11 "Analyst corrected reported value", add 
label define label_xf2d084b 12 "Data generated from other data values", add 
label define label_xf2d084b 13 "Implied zero", add 
label define label_xf2d084b 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d084b 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d084b 22 "Imputed using the Group Median procedure", add 
label define label_xf2d084b 23 "Logical imputation", add 
label define label_xf2d084b 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d084b 30 "Not applicable", add 
label define label_xf2d084b 31 "Institution left item blank", add 
label define label_xf2d084b 32 "Do not know", add 
label define label_xf2d084b 33 "Particular 1st prof field not applicable", add 
label define label_xf2d084b 50 "Outlier value derived from reported data", add 
label define label_xf2d084b 51 "Outlier value derived from imported data", add 
label define label_xf2d084b 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d084b 53 "Value not derived - data not usable", add 
label values xf2d084b label_xf2d084b
label define label_xf2d09 10 "Reported" 
label define label_xf2d09 11 "Analyst corrected reported value", add 
label define label_xf2d09 12 "Data generated from other data values", add 
label define label_xf2d09 13 "Implied zero", add 
label define label_xf2d09 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d09 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d09 22 "Imputed using the Group Median procedure", add 
label define label_xf2d09 23 "Logical imputation", add 
label define label_xf2d09 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d09 30 "Not applicable", add 
label define label_xf2d09 31 "Institution left item blank", add 
label define label_xf2d09 32 "Do not know", add 
label define label_xf2d09 33 "Particular 1st prof field not applicable", add 
label define label_xf2d09 50 "Outlier value derived from reported data", add 
label define label_xf2d09 51 "Outlier value derived from imported data", add 
label define label_xf2d09 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d09 53 "Value not derived - data not usable", add 
label values xf2d09 label_xf2d09
label define label_xf2d092 10 "Reported" 
label define label_xf2d092 11 "Analyst corrected reported value", add 
label define label_xf2d092 12 "Data generated from other data values", add 
label define label_xf2d092 13 "Implied zero", add 
label define label_xf2d092 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d092 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d092 22 "Imputed using the Group Median procedure", add 
label define label_xf2d092 23 "Logical imputation", add 
label define label_xf2d092 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d092 30 "Not applicable", add 
label define label_xf2d092 31 "Institution left item blank", add 
label define label_xf2d092 32 "Do not know", add 
label define label_xf2d092 33 "Particular 1st prof field not applicable", add 
label define label_xf2d092 50 "Outlier value derived from reported data", add 
label define label_xf2d092 51 "Outlier value derived from imported data", add 
label define label_xf2d092 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d092 53 "Value not derived - data not usable", add 
label values xf2d092 label_xf2d092
label define label_xf2d093 10 "Reported" 
label define label_xf2d093 11 "Analyst corrected reported value", add 
label define label_xf2d093 12 "Data generated from other data values", add 
label define label_xf2d093 13 "Implied zero", add 
label define label_xf2d093 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d093 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d093 22 "Imputed using the Group Median procedure", add 
label define label_xf2d093 23 "Logical imputation", add 
label define label_xf2d093 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d093 30 "Not applicable", add 
label define label_xf2d093 31 "Institution left item blank", add 
label define label_xf2d093 32 "Do not know", add 
label define label_xf2d093 33 "Particular 1st prof field not applicable", add 
label define label_xf2d093 50 "Outlier value derived from reported data", add 
label define label_xf2d093 51 "Outlier value derived from imported data", add 
label define label_xf2d093 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d093 53 "Value not derived - data not usable", add 
label values xf2d093 label_xf2d093
label define label_xf2d094 10 "Reported" 
label define label_xf2d094 11 "Analyst corrected reported value", add 
label define label_xf2d094 12 "Data generated from other data values", add 
label define label_xf2d094 13 "Implied zero", add 
label define label_xf2d094 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d094 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d094 22 "Imputed using the Group Median procedure", add 
label define label_xf2d094 23 "Logical imputation", add 
label define label_xf2d094 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d094 30 "Not applicable", add 
label define label_xf2d094 31 "Institution left item blank", add 
label define label_xf2d094 32 "Do not know", add 
label define label_xf2d094 33 "Particular 1st prof field not applicable", add 
label define label_xf2d094 50 "Outlier value derived from reported data", add 
label define label_xf2d094 51 "Outlier value derived from imported data", add 
label define label_xf2d094 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d094 53 "Value not derived - data not usable", add 
label values xf2d094 label_xf2d094
label define label_xf2d10 10 "Reported" 
label define label_xf2d10 11 "Analyst corrected reported value", add 
label define label_xf2d10 12 "Data generated from other data values", add 
label define label_xf2d10 13 "Implied zero", add 
label define label_xf2d10 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d10 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d10 22 "Imputed using the Group Median procedure", add 
label define label_xf2d10 23 "Logical imputation", add 
label define label_xf2d10 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d10 30 "Not applicable", add 
label define label_xf2d10 31 "Institution left item blank", add 
label define label_xf2d10 32 "Do not know", add 
label define label_xf2d10 33 "Particular 1st prof field not applicable", add 
label define label_xf2d10 50 "Outlier value derived from reported data", add 
label define label_xf2d10 51 "Outlier value derived from imported data", add 
label define label_xf2d10 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d10 53 "Value not derived - data not usable", add 
label values xf2d10 label_xf2d10
label define label_xf2d102 10 "Reported" 
label define label_xf2d102 11 "Analyst corrected reported value", add 
label define label_xf2d102 12 "Data generated from other data values", add 
label define label_xf2d102 13 "Implied zero", add 
label define label_xf2d102 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d102 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d102 22 "Imputed using the Group Median procedure", add 
label define label_xf2d102 23 "Logical imputation", add 
label define label_xf2d102 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d102 30 "Not applicable", add 
label define label_xf2d102 31 "Institution left item blank", add 
label define label_xf2d102 32 "Do not know", add 
label define label_xf2d102 33 "Particular 1st prof field not applicable", add 
label define label_xf2d102 50 "Outlier value derived from reported data", add 
label define label_xf2d102 51 "Outlier value derived from imported data", add 
label define label_xf2d102 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d102 53 "Value not derived - data not usable", add 
label values xf2d102 label_xf2d102
label define label_xf2d103 10 "Reported" 
label define label_xf2d103 11 "Analyst corrected reported value", add 
label define label_xf2d103 12 "Data generated from other data values", add 
label define label_xf2d103 13 "Implied zero", add 
label define label_xf2d103 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d103 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d103 22 "Imputed using the Group Median procedure", add 
label define label_xf2d103 23 "Logical imputation", add 
label define label_xf2d103 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d103 30 "Not applicable", add 
label define label_xf2d103 31 "Institution left item blank", add 
label define label_xf2d103 32 "Do not know", add 
label define label_xf2d103 33 "Particular 1st prof field not applicable", add 
label define label_xf2d103 50 "Outlier value derived from reported data", add 
label define label_xf2d103 51 "Outlier value derived from imported data", add 
label define label_xf2d103 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d103 53 "Value not derived - data not usable", add 
label values xf2d103 label_xf2d103
label define label_xf2d104 10 "Reported" 
label define label_xf2d104 11 "Analyst corrected reported value", add 
label define label_xf2d104 12 "Data generated from other data values", add 
label define label_xf2d104 13 "Implied zero", add 
label define label_xf2d104 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d104 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d104 22 "Imputed using the Group Median procedure", add 
label define label_xf2d104 23 "Logical imputation", add 
label define label_xf2d104 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d104 30 "Not applicable", add 
label define label_xf2d104 31 "Institution left item blank", add 
label define label_xf2d104 32 "Do not know", add 
label define label_xf2d104 33 "Particular 1st prof field not applicable", add 
label define label_xf2d104 50 "Outlier value derived from reported data", add 
label define label_xf2d104 51 "Outlier value derived from imported data", add 
label define label_xf2d104 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d104 53 "Value not derived - data not usable", add 
label values xf2d104 label_xf2d104
label define label_xf2d11 10 "Reported" 
label define label_xf2d11 11 "Analyst corrected reported value", add 
label define label_xf2d11 12 "Data generated from other data values", add 
label define label_xf2d11 13 "Implied zero", add 
label define label_xf2d11 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d11 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d11 22 "Imputed using the Group Median procedure", add 
label define label_xf2d11 23 "Logical imputation", add 
label define label_xf2d11 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d11 30 "Not applicable", add 
label define label_xf2d11 31 "Institution left item blank", add 
label define label_xf2d11 32 "Do not know", add 
label define label_xf2d11 33 "Particular 1st prof field not applicable", add 
label define label_xf2d11 50 "Outlier value derived from reported data", add 
label define label_xf2d11 51 "Outlier value derived from imported data", add 
label define label_xf2d11 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d11 53 "Value not derived - data not usable", add 
label values xf2d11 label_xf2d11
label define label_xf2d112 10 "Reported" 
label define label_xf2d112 11 "Analyst corrected reported value", add 
label define label_xf2d112 12 "Data generated from other data values", add 
label define label_xf2d112 13 "Implied zero", add 
label define label_xf2d112 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d112 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d112 22 "Imputed using the Group Median procedure", add 
label define label_xf2d112 23 "Logical imputation", add 
label define label_xf2d112 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d112 30 "Not applicable", add 
label define label_xf2d112 31 "Institution left item blank", add 
label define label_xf2d112 32 "Do not know", add 
label define label_xf2d112 33 "Particular 1st prof field not applicable", add 
label define label_xf2d112 50 "Outlier value derived from reported data", add 
label define label_xf2d112 51 "Outlier value derived from imported data", add 
label define label_xf2d112 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d112 53 "Value not derived - data not usable", add 
label values xf2d112 label_xf2d112
label define label_xf2d12 10 "Reported" 
label define label_xf2d12 11 "Analyst corrected reported value", add 
label define label_xf2d12 12 "Data generated from other data values", add 
label define label_xf2d12 13 "Implied zero", add 
label define label_xf2d12 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d12 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d12 22 "Imputed using the Group Median procedure", add 
label define label_xf2d12 23 "Logical imputation", add 
label define label_xf2d12 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d12 30 "Not applicable", add 
label define label_xf2d12 31 "Institution left item blank", add 
label define label_xf2d12 32 "Do not know", add 
label define label_xf2d12 33 "Particular 1st prof field not applicable", add 
label define label_xf2d12 50 "Outlier value derived from reported data", add 
label define label_xf2d12 51 "Outlier value derived from imported data", add 
label define label_xf2d12 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d12 53 "Value not derived - data not usable", add 
label values xf2d12 label_xf2d12
label define label_xf2d122 10 "Reported" 
label define label_xf2d122 11 "Analyst corrected reported value", add 
label define label_xf2d122 12 "Data generated from other data values", add 
label define label_xf2d122 13 "Implied zero", add 
label define label_xf2d122 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d122 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d122 22 "Imputed using the Group Median procedure", add 
label define label_xf2d122 23 "Logical imputation", add 
label define label_xf2d122 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d122 30 "Not applicable", add 
label define label_xf2d122 31 "Institution left item blank", add 
label define label_xf2d122 32 "Do not know", add 
label define label_xf2d122 33 "Particular 1st prof field not applicable", add 
label define label_xf2d122 50 "Outlier value derived from reported data", add 
label define label_xf2d122 51 "Outlier value derived from imported data", add 
label define label_xf2d122 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d122 53 "Value not derived - data not usable", add 
label values xf2d122 label_xf2d122
label define label_xf2d13 10 "Reported" 
label define label_xf2d13 11 "Analyst corrected reported value", add 
label define label_xf2d13 12 "Data generated from other data values", add 
label define label_xf2d13 13 "Implied zero", add 
label define label_xf2d13 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d13 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d13 22 "Imputed using the Group Median procedure", add 
label define label_xf2d13 23 "Logical imputation", add 
label define label_xf2d13 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d13 30 "Not applicable", add 
label define label_xf2d13 31 "Institution left item blank", add 
label define label_xf2d13 32 "Do not know", add 
label define label_xf2d13 33 "Particular 1st prof field not applicable", add 
label define label_xf2d13 50 "Outlier value derived from reported data", add 
label define label_xf2d13 51 "Outlier value derived from imported data", add 
label define label_xf2d13 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d13 53 "Value not derived - data not usable", add 
label values xf2d13 label_xf2d13
label define label_xf2d132 10 "Reported" 
label define label_xf2d132 11 "Analyst corrected reported value", add 
label define label_xf2d132 12 "Data generated from other data values", add 
label define label_xf2d132 13 "Implied zero", add 
label define label_xf2d132 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d132 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d132 22 "Imputed using the Group Median procedure", add 
label define label_xf2d132 23 "Logical imputation", add 
label define label_xf2d132 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d132 30 "Not applicable", add 
label define label_xf2d132 31 "Institution left item blank", add 
label define label_xf2d132 32 "Do not know", add 
label define label_xf2d132 33 "Particular 1st prof field not applicable", add 
label define label_xf2d132 50 "Outlier value derived from reported data", add 
label define label_xf2d132 51 "Outlier value derived from imported data", add 
label define label_xf2d132 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d132 53 "Value not derived - data not usable", add 
label values xf2d132 label_xf2d132
label define label_xf2d14 10 "Reported" 
label define label_xf2d14 11 "Analyst corrected reported value", add 
label define label_xf2d14 12 "Data generated from other data values", add 
label define label_xf2d14 13 "Implied zero", add 
label define label_xf2d14 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d14 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d14 22 "Imputed using the Group Median procedure", add 
label define label_xf2d14 23 "Logical imputation", add 
label define label_xf2d14 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d14 30 "Not applicable", add 
label define label_xf2d14 31 "Institution left item blank", add 
label define label_xf2d14 32 "Do not know", add 
label define label_xf2d14 33 "Particular 1st prof field not applicable", add 
label define label_xf2d14 50 "Outlier value derived from reported data", add 
label define label_xf2d14 51 "Outlier value derived from imported data", add 
label define label_xf2d14 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d14 53 "Value not derived - data not usable", add 
label values xf2d14 label_xf2d14
label define label_xf2d142 10 "Reported" 
label define label_xf2d142 11 "Analyst corrected reported value", add 
label define label_xf2d142 12 "Data generated from other data values", add 
label define label_xf2d142 13 "Implied zero", add 
label define label_xf2d142 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d142 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d142 22 "Imputed using the Group Median procedure", add 
label define label_xf2d142 23 "Logical imputation", add 
label define label_xf2d142 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d142 30 "Not applicable", add 
label define label_xf2d142 31 "Institution left item blank", add 
label define label_xf2d142 32 "Do not know", add 
label define label_xf2d142 33 "Particular 1st prof field not applicable", add 
label define label_xf2d142 50 "Outlier value derived from reported data", add 
label define label_xf2d142 51 "Outlier value derived from imported data", add 
label define label_xf2d142 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d142 53 "Value not derived - data not usable", add 
label values xf2d142 label_xf2d142
label define label_xf2d143 10 "Reported" 
label define label_xf2d143 11 "Analyst corrected reported value", add 
label define label_xf2d143 12 "Data generated from other data values", add 
label define label_xf2d143 13 "Implied zero", add 
label define label_xf2d143 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d143 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d143 22 "Imputed using the Group Median procedure", add 
label define label_xf2d143 23 "Logical imputation", add 
label define label_xf2d143 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d143 30 "Not applicable", add 
label define label_xf2d143 31 "Institution left item blank", add 
label define label_xf2d143 32 "Do not know", add 
label define label_xf2d143 33 "Particular 1st prof field not applicable", add 
label define label_xf2d143 50 "Outlier value derived from reported data", add 
label define label_xf2d143 51 "Outlier value derived from imported data", add 
label define label_xf2d143 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d143 53 "Value not derived - data not usable", add 
label values xf2d143 label_xf2d143
label define label_xf2d144 10 "Reported" 
label define label_xf2d144 11 "Analyst corrected reported value", add 
label define label_xf2d144 12 "Data generated from other data values", add 
label define label_xf2d144 13 "Implied zero", add 
label define label_xf2d144 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d144 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d144 22 "Imputed using the Group Median procedure", add 
label define label_xf2d144 23 "Logical imputation", add 
label define label_xf2d144 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d144 30 "Not applicable", add 
label define label_xf2d144 31 "Institution left item blank", add 
label define label_xf2d144 32 "Do not know", add 
label define label_xf2d144 33 "Particular 1st prof field not applicable", add 
label define label_xf2d144 50 "Outlier value derived from reported data", add 
label define label_xf2d144 51 "Outlier value derived from imported data", add 
label define label_xf2d144 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d144 53 "Value not derived - data not usable", add 
label values xf2d144 label_xf2d144
label define label_xf2d15 10 "Reported" 
label define label_xf2d15 11 "Analyst corrected reported value", add 
label define label_xf2d15 12 "Data generated from other data values", add 
label define label_xf2d15 13 "Implied zero", add 
label define label_xf2d15 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d15 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d15 22 "Imputed using the Group Median procedure", add 
label define label_xf2d15 23 "Logical imputation", add 
label define label_xf2d15 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d15 30 "Not applicable", add 
label define label_xf2d15 31 "Institution left item blank", add 
label define label_xf2d15 32 "Do not know", add 
label define label_xf2d15 33 "Particular 1st prof field not applicable", add 
label define label_xf2d15 50 "Outlier value derived from reported data", add 
label define label_xf2d15 51 "Outlier value derived from imported data", add 
label define label_xf2d15 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d15 53 "Value not derived - data not usable", add 
label values xf2d15 label_xf2d15
label define label_xf2d152 10 "Reported" 
label define label_xf2d152 11 "Analyst corrected reported value", add 
label define label_xf2d152 12 "Data generated from other data values", add 
label define label_xf2d152 13 "Implied zero", add 
label define label_xf2d152 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d152 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d152 22 "Imputed using the Group Median procedure", add 
label define label_xf2d152 23 "Logical imputation", add 
label define label_xf2d152 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d152 30 "Not applicable", add 
label define label_xf2d152 31 "Institution left item blank", add 
label define label_xf2d152 32 "Do not know", add 
label define label_xf2d152 33 "Particular 1st prof field not applicable", add 
label define label_xf2d152 50 "Outlier value derived from reported data", add 
label define label_xf2d152 51 "Outlier value derived from imported data", add 
label define label_xf2d152 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d152 53 "Value not derived - data not usable", add 
label values xf2d152 label_xf2d152
label define label_xf2d153 10 "Reported" 
label define label_xf2d153 11 "Analyst corrected reported value", add 
label define label_xf2d153 12 "Data generated from other data values", add 
label define label_xf2d153 13 "Implied zero", add 
label define label_xf2d153 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d153 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d153 22 "Imputed using the Group Median procedure", add 
label define label_xf2d153 23 "Logical imputation", add 
label define label_xf2d153 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d153 30 "Not applicable", add 
label define label_xf2d153 31 "Institution left item blank", add 
label define label_xf2d153 32 "Do not know", add 
label define label_xf2d153 33 "Particular 1st prof field not applicable", add 
label define label_xf2d153 50 "Outlier value derived from reported data", add 
label define label_xf2d153 51 "Outlier value derived from imported data", add 
label define label_xf2d153 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d153 53 "Value not derived - data not usable", add 
label values xf2d153 label_xf2d153
label define label_xf2d154 10 "Reported" 
label define label_xf2d154 11 "Analyst corrected reported value", add 
label define label_xf2d154 12 "Data generated from other data values", add 
label define label_xf2d154 13 "Implied zero", add 
label define label_xf2d154 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d154 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d154 22 "Imputed using the Group Median procedure", add 
label define label_xf2d154 23 "Logical imputation", add 
label define label_xf2d154 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d154 30 "Not applicable", add 
label define label_xf2d154 31 "Institution left item blank", add 
label define label_xf2d154 32 "Do not know", add 
label define label_xf2d154 33 "Particular 1st prof field not applicable", add 
label define label_xf2d154 50 "Outlier value derived from reported data", add 
label define label_xf2d154 51 "Outlier value derived from imported data", add 
label define label_xf2d154 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d154 53 "Value not derived - data not usable", add 
label values xf2d154 label_xf2d154
label define label_xf2d16 10 "Reported" 
label define label_xf2d16 11 "Analyst corrected reported value", add 
label define label_xf2d16 12 "Data generated from other data values", add 
label define label_xf2d16 13 "Implied zero", add 
label define label_xf2d16 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d16 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d16 22 "Imputed using the Group Median procedure", add 
label define label_xf2d16 23 "Logical imputation", add 
label define label_xf2d16 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d16 30 "Not applicable", add 
label define label_xf2d16 31 "Institution left item blank", add 
label define label_xf2d16 32 "Do not know", add 
label define label_xf2d16 33 "Particular 1st prof field not applicable", add 
label define label_xf2d16 50 "Outlier value derived from reported data", add 
label define label_xf2d16 51 "Outlier value derived from imported data", add 
label define label_xf2d16 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d16 53 "Value not derived - data not usable", add 
label values xf2d16 label_xf2d16
label define label_xf2d162 10 "Reported" 
label define label_xf2d162 11 "Analyst corrected reported value", add 
label define label_xf2d162 12 "Data generated from other data values", add 
label define label_xf2d162 13 "Implied zero", add 
label define label_xf2d162 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d162 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d162 22 "Imputed using the Group Median procedure", add 
label define label_xf2d162 23 "Logical imputation", add 
label define label_xf2d162 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d162 30 "Not applicable", add 
label define label_xf2d162 31 "Institution left item blank", add 
label define label_xf2d162 32 "Do not know", add 
label define label_xf2d162 33 "Particular 1st prof field not applicable", add 
label define label_xf2d162 50 "Outlier value derived from reported data", add 
label define label_xf2d162 51 "Outlier value derived from imported data", add 
label define label_xf2d162 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d162 53 "Value not derived - data not usable", add 
label values xf2d162 label_xf2d162
label define label_xf2d163 10 "Reported" 
label define label_xf2d163 11 "Analyst corrected reported value", add 
label define label_xf2d163 12 "Data generated from other data values", add 
label define label_xf2d163 13 "Implied zero", add 
label define label_xf2d163 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d163 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d163 22 "Imputed using the Group Median procedure", add 
label define label_xf2d163 23 "Logical imputation", add 
label define label_xf2d163 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d163 30 "Not applicable", add 
label define label_xf2d163 31 "Institution left item blank", add 
label define label_xf2d163 32 "Do not know", add 
label define label_xf2d163 33 "Particular 1st prof field not applicable", add 
label define label_xf2d163 50 "Outlier value derived from reported data", add 
label define label_xf2d163 51 "Outlier value derived from imported data", add 
label define label_xf2d163 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d163 53 "Value not derived - data not usable", add 
label values xf2d163 label_xf2d163
label define label_xf2d164 10 "Reported" 
label define label_xf2d164 11 "Analyst corrected reported value", add 
label define label_xf2d164 12 "Data generated from other data values", add 
label define label_xf2d164 13 "Implied zero", add 
label define label_xf2d164 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d164 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d164 22 "Imputed using the Group Median procedure", add 
label define label_xf2d164 23 "Logical imputation", add 
label define label_xf2d164 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d164 30 "Not applicable", add 
label define label_xf2d164 31 "Institution left item blank", add 
label define label_xf2d164 32 "Do not know", add 
label define label_xf2d164 33 "Particular 1st prof field not applicable", add 
label define label_xf2d164 50 "Outlier value derived from reported data", add 
label define label_xf2d164 51 "Outlier value derived from imported data", add 
label define label_xf2d164 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d164 53 "Value not derived - data not usable", add 
label values xf2d164 label_xf2d164
label define label_xf2d172 10 "Reported" 
label define label_xf2d172 11 "Analyst corrected reported value", add 
label define label_xf2d172 12 "Data generated from other data values", add 
label define label_xf2d172 13 "Implied zero", add 
label define label_xf2d172 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d172 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d172 22 "Imputed using the Group Median procedure", add 
label define label_xf2d172 23 "Logical imputation", add 
label define label_xf2d172 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d172 30 "Not applicable", add 
label define label_xf2d172 31 "Institution left item blank", add 
label define label_xf2d172 32 "Do not know", add 
label define label_xf2d172 33 "Particular 1st prof field not applicable", add 
label define label_xf2d172 50 "Outlier value derived from reported data", add 
label define label_xf2d172 51 "Outlier value derived from imported data", add 
label define label_xf2d172 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d172 53 "Value not derived - data not usable", add 
label values xf2d172 label_xf2d172
label define label_xf2d173 10 "Reported" 
label define label_xf2d173 11 "Analyst corrected reported value", add 
label define label_xf2d173 12 "Data generated from other data values", add 
label define label_xf2d173 13 "Implied zero", add 
label define label_xf2d173 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d173 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d173 22 "Imputed using the Group Median procedure", add 
label define label_xf2d173 23 "Logical imputation", add 
label define label_xf2d173 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d173 30 "Not applicable", add 
label define label_xf2d173 31 "Institution left item blank", add 
label define label_xf2d173 32 "Do not know", add 
label define label_xf2d173 33 "Particular 1st prof field not applicable", add 
label define label_xf2d173 50 "Outlier value derived from reported data", add 
label define label_xf2d173 51 "Outlier value derived from imported data", add 
label define label_xf2d173 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d173 53 "Value not derived - data not usable", add 
label values xf2d173 label_xf2d173
label define label_xf2d182 10 "Reported" 
label define label_xf2d182 11 "Analyst corrected reported value", add 
label define label_xf2d182 12 "Data generated from other data values", add 
label define label_xf2d182 13 "Implied zero", add 
label define label_xf2d182 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d182 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d182 22 "Imputed using the Group Median procedure", add 
label define label_xf2d182 23 "Logical imputation", add 
label define label_xf2d182 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d182 30 "Not applicable", add 
label define label_xf2d182 31 "Institution left item blank", add 
label define label_xf2d182 32 "Do not know", add 
label define label_xf2d182 33 "Particular 1st prof field not applicable", add 
label define label_xf2d182 50 "Outlier value derived from reported data", add 
label define label_xf2d182 51 "Outlier value derived from imported data", add 
label define label_xf2d182 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d182 53 "Value not derived - data not usable", add 
label values xf2d182 label_xf2d182
label define label_xf2d183 10 "Reported" 
label define label_xf2d183 11 "Analyst corrected reported value", add 
label define label_xf2d183 12 "Data generated from other data values", add 
label define label_xf2d183 13 "Implied zero", add 
label define label_xf2d183 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d183 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d183 22 "Imputed using the Group Median procedure", add 
label define label_xf2d183 23 "Logical imputation", add 
label define label_xf2d183 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d183 30 "Not applicable", add 
label define label_xf2d183 31 "Institution left item blank", add 
label define label_xf2d183 32 "Do not know", add 
label define label_xf2d183 33 "Particular 1st prof field not applicable", add 
label define label_xf2d183 50 "Outlier value derived from reported data", add 
label define label_xf2d183 51 "Outlier value derived from imported data", add 
label define label_xf2d183 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d183 53 "Value not derived - data not usable", add 
label values xf2d183 label_xf2d183
label define label_xf2d184 10 "Reported" 
label define label_xf2d184 11 "Analyst corrected reported value", add 
label define label_xf2d184 12 "Data generated from other data values", add 
label define label_xf2d184 13 "Implied zero", add 
label define label_xf2d184 20 "Imputed using Carry Forward procedure", add 
label define label_xf2d184 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2d184 22 "Imputed using the Group Median procedure", add 
label define label_xf2d184 23 "Logical imputation", add 
label define label_xf2d184 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2d184 30 "Not applicable", add 
label define label_xf2d184 31 "Institution left item blank", add 
label define label_xf2d184 32 "Do not know", add 
label define label_xf2d184 33 "Particular 1st prof field not applicable", add 
label define label_xf2d184 50 "Outlier value derived from reported data", add 
label define label_xf2d184 51 "Outlier value derived from imported data", add 
label define label_xf2d184 52 "Value not derived - parent/child differs across components", add 
label define label_xf2d184 53 "Value not derived - data not usable", add 
label values xf2d184 label_xf2d184
label define label_xf2e011 10 "Reported" 
label define label_xf2e011 11 "Analyst corrected reported value", add 
label define label_xf2e011 12 "Data generated from other data values", add 
label define label_xf2e011 13 "Implied zero", add 
label define label_xf2e011 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e011 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e011 22 "Imputed using the Group Median procedure", add 
label define label_xf2e011 23 "Logical imputation", add 
label define label_xf2e011 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e011 30 "Not applicable", add 
label define label_xf2e011 31 "Institution left item blank", add 
label define label_xf2e011 32 "Do not know", add 
label define label_xf2e011 33 "Particular 1st prof field not applicable", add 
label define label_xf2e011 50 "Outlier value derived from reported data", add 
label define label_xf2e011 51 "Outlier value derived from imported data", add 
label define label_xf2e011 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e011 53 "Value not derived - data not usable", add 
label values xf2e011 label_xf2e011
label define label_xf2e012 10 "Reported" 
label define label_xf2e012 11 "Analyst corrected reported value", add 
label define label_xf2e012 12 "Data generated from other data values", add 
label define label_xf2e012 13 "Implied zero", add 
label define label_xf2e012 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e012 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e012 22 "Imputed using the Group Median procedure", add 
label define label_xf2e012 23 "Logical imputation", add 
label define label_xf2e012 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e012 30 "Not applicable", add 
label define label_xf2e012 31 "Institution left item blank", add 
label define label_xf2e012 32 "Do not know", add 
label define label_xf2e012 33 "Particular 1st prof field not applicable", add 
label define label_xf2e012 50 "Outlier value derived from reported data", add 
label define label_xf2e012 51 "Outlier value derived from imported data", add 
label define label_xf2e012 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e012 53 "Value not derived - data not usable", add 
label values xf2e012 label_xf2e012
label define label_xf2e013 10 "Reported" 
label define label_xf2e013 11 "Analyst corrected reported value", add 
label define label_xf2e013 12 "Data generated from other data values", add 
label define label_xf2e013 13 "Implied zero", add 
label define label_xf2e013 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e013 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e013 22 "Imputed using the Group Median procedure", add 
label define label_xf2e013 23 "Logical imputation", add 
label define label_xf2e013 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e013 30 "Not applicable", add 
label define label_xf2e013 31 "Institution left item blank", add 
label define label_xf2e013 32 "Do not know", add 
label define label_xf2e013 33 "Particular 1st prof field not applicable", add 
label define label_xf2e013 50 "Outlier value derived from reported data", add 
label define label_xf2e013 51 "Outlier value derived from imported data", add 
label define label_xf2e013 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e013 53 "Value not derived - data not usable", add 
label values xf2e013 label_xf2e013
label define label_xf2e014 10 "Reported" 
label define label_xf2e014 11 "Analyst corrected reported value", add 
label define label_xf2e014 12 "Data generated from other data values", add 
label define label_xf2e014 13 "Implied zero", add 
label define label_xf2e014 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e014 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e014 22 "Imputed using the Group Median procedure", add 
label define label_xf2e014 23 "Logical imputation", add 
label define label_xf2e014 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e014 30 "Not applicable", add 
label define label_xf2e014 31 "Institution left item blank", add 
label define label_xf2e014 32 "Do not know", add 
label define label_xf2e014 33 "Particular 1st prof field not applicable", add 
label define label_xf2e014 50 "Outlier value derived from reported data", add 
label define label_xf2e014 51 "Outlier value derived from imported data", add 
label define label_xf2e014 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e014 53 "Value not derived - data not usable", add 
label values xf2e014 label_xf2e014
label define label_xf2e015 10 "Reported" 
label define label_xf2e015 11 "Analyst corrected reported value", add 
label define label_xf2e015 12 "Data generated from other data values", add 
label define label_xf2e015 13 "Implied zero", add 
label define label_xf2e015 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e015 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e015 22 "Imputed using the Group Median procedure", add 
label define label_xf2e015 23 "Logical imputation", add 
label define label_xf2e015 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e015 30 "Not applicable", add 
label define label_xf2e015 31 "Institution left item blank", add 
label define label_xf2e015 32 "Do not know", add 
label define label_xf2e015 33 "Particular 1st prof field not applicable", add 
label define label_xf2e015 50 "Outlier value derived from reported data", add 
label define label_xf2e015 51 "Outlier value derived from imported data", add 
label define label_xf2e015 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e015 53 "Value not derived - data not usable", add 
label values xf2e015 label_xf2e015
label define label_xf2e016 10 "Reported" 
label define label_xf2e016 11 "Analyst corrected reported value", add 
label define label_xf2e016 12 "Data generated from other data values", add 
label define label_xf2e016 13 "Implied zero", add 
label define label_xf2e016 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e016 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e016 22 "Imputed using the Group Median procedure", add 
label define label_xf2e016 23 "Logical imputation", add 
label define label_xf2e016 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e016 30 "Not applicable", add 
label define label_xf2e016 31 "Institution left item blank", add 
label define label_xf2e016 32 "Do not know", add 
label define label_xf2e016 33 "Particular 1st prof field not applicable", add 
label define label_xf2e016 50 "Outlier value derived from reported data", add 
label define label_xf2e016 51 "Outlier value derived from imported data", add 
label define label_xf2e016 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e016 53 "Value not derived - data not usable", add 
label values xf2e016 label_xf2e016
label define label_xf2e017 10 "Reported" 
label define label_xf2e017 11 "Analyst corrected reported value", add 
label define label_xf2e017 12 "Data generated from other data values", add 
label define label_xf2e017 13 "Implied zero", add 
label define label_xf2e017 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e017 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e017 22 "Imputed using the Group Median procedure", add 
label define label_xf2e017 23 "Logical imputation", add 
label define label_xf2e017 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e017 30 "Not applicable", add 
label define label_xf2e017 31 "Institution left item blank", add 
label define label_xf2e017 32 "Do not know", add 
label define label_xf2e017 33 "Particular 1st prof field not applicable", add 
label define label_xf2e017 50 "Outlier value derived from reported data", add 
label define label_xf2e017 51 "Outlier value derived from imported data", add 
label define label_xf2e017 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e017 53 "Value not derived - data not usable", add 
label values xf2e017 label_xf2e017
label define label_xf2e021 10 "Reported" 
label define label_xf2e021 11 "Analyst corrected reported value", add 
label define label_xf2e021 12 "Data generated from other data values", add 
label define label_xf2e021 13 "Implied zero", add 
label define label_xf2e021 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e021 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e021 22 "Imputed using the Group Median procedure", add 
label define label_xf2e021 23 "Logical imputation", add 
label define label_xf2e021 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e021 30 "Not applicable", add 
label define label_xf2e021 31 "Institution left item blank", add 
label define label_xf2e021 32 "Do not know", add 
label define label_xf2e021 33 "Particular 1st prof field not applicable", add 
label define label_xf2e021 50 "Outlier value derived from reported data", add 
label define label_xf2e021 51 "Outlier value derived from imported data", add 
label define label_xf2e021 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e021 53 "Value not derived - data not usable", add 
label values xf2e021 label_xf2e021
label define label_xf2e022 10 "Reported" 
label define label_xf2e022 11 "Analyst corrected reported value", add 
label define label_xf2e022 12 "Data generated from other data values", add 
label define label_xf2e022 13 "Implied zero", add 
label define label_xf2e022 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e022 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e022 22 "Imputed using the Group Median procedure", add 
label define label_xf2e022 23 "Logical imputation", add 
label define label_xf2e022 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e022 30 "Not applicable", add 
label define label_xf2e022 31 "Institution left item blank", add 
label define label_xf2e022 32 "Do not know", add 
label define label_xf2e022 33 "Particular 1st prof field not applicable", add 
label define label_xf2e022 50 "Outlier value derived from reported data", add 
label define label_xf2e022 51 "Outlier value derived from imported data", add 
label define label_xf2e022 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e022 53 "Value not derived - data not usable", add 
label values xf2e022 label_xf2e022
label define label_xf2e023 10 "Reported" 
label define label_xf2e023 11 "Analyst corrected reported value", add 
label define label_xf2e023 12 "Data generated from other data values", add 
label define label_xf2e023 13 "Implied zero", add 
label define label_xf2e023 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e023 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e023 22 "Imputed using the Group Median procedure", add 
label define label_xf2e023 23 "Logical imputation", add 
label define label_xf2e023 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e023 30 "Not applicable", add 
label define label_xf2e023 31 "Institution left item blank", add 
label define label_xf2e023 32 "Do not know", add 
label define label_xf2e023 33 "Particular 1st prof field not applicable", add 
label define label_xf2e023 50 "Outlier value derived from reported data", add 
label define label_xf2e023 51 "Outlier value derived from imported data", add 
label define label_xf2e023 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e023 53 "Value not derived - data not usable", add 
label values xf2e023 label_xf2e023
label define label_xf2e024 10 "Reported" 
label define label_xf2e024 11 "Analyst corrected reported value", add 
label define label_xf2e024 12 "Data generated from other data values", add 
label define label_xf2e024 13 "Implied zero", add 
label define label_xf2e024 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e024 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e024 22 "Imputed using the Group Median procedure", add 
label define label_xf2e024 23 "Logical imputation", add 
label define label_xf2e024 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e024 30 "Not applicable", add 
label define label_xf2e024 31 "Institution left item blank", add 
label define label_xf2e024 32 "Do not know", add 
label define label_xf2e024 33 "Particular 1st prof field not applicable", add 
label define label_xf2e024 50 "Outlier value derived from reported data", add 
label define label_xf2e024 51 "Outlier value derived from imported data", add 
label define label_xf2e024 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e024 53 "Value not derived - data not usable", add 
label values xf2e024 label_xf2e024
label define label_xf2e025 10 "Reported" 
label define label_xf2e025 11 "Analyst corrected reported value", add 
label define label_xf2e025 12 "Data generated from other data values", add 
label define label_xf2e025 13 "Implied zero", add 
label define label_xf2e025 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e025 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e025 22 "Imputed using the Group Median procedure", add 
label define label_xf2e025 23 "Logical imputation", add 
label define label_xf2e025 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e025 30 "Not applicable", add 
label define label_xf2e025 31 "Institution left item blank", add 
label define label_xf2e025 32 "Do not know", add 
label define label_xf2e025 33 "Particular 1st prof field not applicable", add 
label define label_xf2e025 50 "Outlier value derived from reported data", add 
label define label_xf2e025 51 "Outlier value derived from imported data", add 
label define label_xf2e025 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e025 53 "Value not derived - data not usable", add 
label values xf2e025 label_xf2e025
label define label_xf2e026 10 "Reported" 
label define label_xf2e026 11 "Analyst corrected reported value", add 
label define label_xf2e026 12 "Data generated from other data values", add 
label define label_xf2e026 13 "Implied zero", add 
label define label_xf2e026 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e026 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e026 22 "Imputed using the Group Median procedure", add 
label define label_xf2e026 23 "Logical imputation", add 
label define label_xf2e026 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e026 30 "Not applicable", add 
label define label_xf2e026 31 "Institution left item blank", add 
label define label_xf2e026 32 "Do not know", add 
label define label_xf2e026 33 "Particular 1st prof field not applicable", add 
label define label_xf2e026 50 "Outlier value derived from reported data", add 
label define label_xf2e026 51 "Outlier value derived from imported data", add 
label define label_xf2e026 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e026 53 "Value not derived - data not usable", add 
label values xf2e026 label_xf2e026
label define label_xf2e027 10 "Reported" 
label define label_xf2e027 11 "Analyst corrected reported value", add 
label define label_xf2e027 12 "Data generated from other data values", add 
label define label_xf2e027 13 "Implied zero", add 
label define label_xf2e027 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e027 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e027 22 "Imputed using the Group Median procedure", add 
label define label_xf2e027 23 "Logical imputation", add 
label define label_xf2e027 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e027 30 "Not applicable", add 
label define label_xf2e027 31 "Institution left item blank", add 
label define label_xf2e027 32 "Do not know", add 
label define label_xf2e027 33 "Particular 1st prof field not applicable", add 
label define label_xf2e027 50 "Outlier value derived from reported data", add 
label define label_xf2e027 51 "Outlier value derived from imported data", add 
label define label_xf2e027 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e027 53 "Value not derived - data not usable", add 
label values xf2e027 label_xf2e027
label define label_xf2e031 10 "Reported" 
label define label_xf2e031 11 "Analyst corrected reported value", add 
label define label_xf2e031 12 "Data generated from other data values", add 
label define label_xf2e031 13 "Implied zero", add 
label define label_xf2e031 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e031 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e031 22 "Imputed using the Group Median procedure", add 
label define label_xf2e031 23 "Logical imputation", add 
label define label_xf2e031 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e031 30 "Not applicable", add 
label define label_xf2e031 31 "Institution left item blank", add 
label define label_xf2e031 32 "Do not know", add 
label define label_xf2e031 33 "Particular 1st prof field not applicable", add 
label define label_xf2e031 50 "Outlier value derived from reported data", add 
label define label_xf2e031 51 "Outlier value derived from imported data", add 
label define label_xf2e031 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e031 53 "Value not derived - data not usable", add 
label values xf2e031 label_xf2e031
label define label_xf2e032 10 "Reported" 
label define label_xf2e032 11 "Analyst corrected reported value", add 
label define label_xf2e032 12 "Data generated from other data values", add 
label define label_xf2e032 13 "Implied zero", add 
label define label_xf2e032 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e032 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e032 22 "Imputed using the Group Median procedure", add 
label define label_xf2e032 23 "Logical imputation", add 
label define label_xf2e032 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e032 30 "Not applicable", add 
label define label_xf2e032 31 "Institution left item blank", add 
label define label_xf2e032 32 "Do not know", add 
label define label_xf2e032 33 "Particular 1st prof field not applicable", add 
label define label_xf2e032 50 "Outlier value derived from reported data", add 
label define label_xf2e032 51 "Outlier value derived from imported data", add 
label define label_xf2e032 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e032 53 "Value not derived - data not usable", add 
label values xf2e032 label_xf2e032
label define label_xf2e033 10 "Reported" 
label define label_xf2e033 11 "Analyst corrected reported value", add 
label define label_xf2e033 12 "Data generated from other data values", add 
label define label_xf2e033 13 "Implied zero", add 
label define label_xf2e033 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e033 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e033 22 "Imputed using the Group Median procedure", add 
label define label_xf2e033 23 "Logical imputation", add 
label define label_xf2e033 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e033 30 "Not applicable", add 
label define label_xf2e033 31 "Institution left item blank", add 
label define label_xf2e033 32 "Do not know", add 
label define label_xf2e033 33 "Particular 1st prof field not applicable", add 
label define label_xf2e033 50 "Outlier value derived from reported data", add 
label define label_xf2e033 51 "Outlier value derived from imported data", add 
label define label_xf2e033 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e033 53 "Value not derived - data not usable", add 
label values xf2e033 label_xf2e033
label define label_xf2e034 10 "Reported" 
label define label_xf2e034 11 "Analyst corrected reported value", add 
label define label_xf2e034 12 "Data generated from other data values", add 
label define label_xf2e034 13 "Implied zero", add 
label define label_xf2e034 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e034 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e034 22 "Imputed using the Group Median procedure", add 
label define label_xf2e034 23 "Logical imputation", add 
label define label_xf2e034 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e034 30 "Not applicable", add 
label define label_xf2e034 31 "Institution left item blank", add 
label define label_xf2e034 32 "Do not know", add 
label define label_xf2e034 33 "Particular 1st prof field not applicable", add 
label define label_xf2e034 50 "Outlier value derived from reported data", add 
label define label_xf2e034 51 "Outlier value derived from imported data", add 
label define label_xf2e034 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e034 53 "Value not derived - data not usable", add 
label values xf2e034 label_xf2e034
label define label_xf2e035 10 "Reported" 
label define label_xf2e035 11 "Analyst corrected reported value", add 
label define label_xf2e035 12 "Data generated from other data values", add 
label define label_xf2e035 13 "Implied zero", add 
label define label_xf2e035 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e035 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e035 22 "Imputed using the Group Median procedure", add 
label define label_xf2e035 23 "Logical imputation", add 
label define label_xf2e035 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e035 30 "Not applicable", add 
label define label_xf2e035 31 "Institution left item blank", add 
label define label_xf2e035 32 "Do not know", add 
label define label_xf2e035 33 "Particular 1st prof field not applicable", add 
label define label_xf2e035 50 "Outlier value derived from reported data", add 
label define label_xf2e035 51 "Outlier value derived from imported data", add 
label define label_xf2e035 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e035 53 "Value not derived - data not usable", add 
label values xf2e035 label_xf2e035
label define label_xf2e036 10 "Reported" 
label define label_xf2e036 11 "Analyst corrected reported value", add 
label define label_xf2e036 12 "Data generated from other data values", add 
label define label_xf2e036 13 "Implied zero", add 
label define label_xf2e036 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e036 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e036 22 "Imputed using the Group Median procedure", add 
label define label_xf2e036 23 "Logical imputation", add 
label define label_xf2e036 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e036 30 "Not applicable", add 
label define label_xf2e036 31 "Institution left item blank", add 
label define label_xf2e036 32 "Do not know", add 
label define label_xf2e036 33 "Particular 1st prof field not applicable", add 
label define label_xf2e036 50 "Outlier value derived from reported data", add 
label define label_xf2e036 51 "Outlier value derived from imported data", add 
label define label_xf2e036 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e036 53 "Value not derived - data not usable", add 
label values xf2e036 label_xf2e036
label define label_xf2e037 10 "Reported" 
label define label_xf2e037 11 "Analyst corrected reported value", add 
label define label_xf2e037 12 "Data generated from other data values", add 
label define label_xf2e037 13 "Implied zero", add 
label define label_xf2e037 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e037 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e037 22 "Imputed using the Group Median procedure", add 
label define label_xf2e037 23 "Logical imputation", add 
label define label_xf2e037 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e037 30 "Not applicable", add 
label define label_xf2e037 31 "Institution left item blank", add 
label define label_xf2e037 32 "Do not know", add 
label define label_xf2e037 33 "Particular 1st prof field not applicable", add 
label define label_xf2e037 50 "Outlier value derived from reported data", add 
label define label_xf2e037 51 "Outlier value derived from imported data", add 
label define label_xf2e037 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e037 53 "Value not derived - data not usable", add 
label values xf2e037 label_xf2e037
label define label_xf2e041 10 "Reported" 
label define label_xf2e041 11 "Analyst corrected reported value", add 
label define label_xf2e041 12 "Data generated from other data values", add 
label define label_xf2e041 13 "Implied zero", add 
label define label_xf2e041 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e041 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e041 22 "Imputed using the Group Median procedure", add 
label define label_xf2e041 23 "Logical imputation", add 
label define label_xf2e041 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e041 30 "Not applicable", add 
label define label_xf2e041 31 "Institution left item blank", add 
label define label_xf2e041 32 "Do not know", add 
label define label_xf2e041 33 "Particular 1st prof field not applicable", add 
label define label_xf2e041 50 "Outlier value derived from reported data", add 
label define label_xf2e041 51 "Outlier value derived from imported data", add 
label define label_xf2e041 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e041 53 "Value not derived - data not usable", add 
label values xf2e041 label_xf2e041
label define label_xf2e042 10 "Reported" 
label define label_xf2e042 11 "Analyst corrected reported value", add 
label define label_xf2e042 12 "Data generated from other data values", add 
label define label_xf2e042 13 "Implied zero", add 
label define label_xf2e042 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e042 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e042 22 "Imputed using the Group Median procedure", add 
label define label_xf2e042 23 "Logical imputation", add 
label define label_xf2e042 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e042 30 "Not applicable", add 
label define label_xf2e042 31 "Institution left item blank", add 
label define label_xf2e042 32 "Do not know", add 
label define label_xf2e042 33 "Particular 1st prof field not applicable", add 
label define label_xf2e042 50 "Outlier value derived from reported data", add 
label define label_xf2e042 51 "Outlier value derived from imported data", add 
label define label_xf2e042 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e042 53 "Value not derived - data not usable", add 
label values xf2e042 label_xf2e042
label define label_xf2e043 10 "Reported" 
label define label_xf2e043 11 "Analyst corrected reported value", add 
label define label_xf2e043 12 "Data generated from other data values", add 
label define label_xf2e043 13 "Implied zero", add 
label define label_xf2e043 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e043 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e043 22 "Imputed using the Group Median procedure", add 
label define label_xf2e043 23 "Logical imputation", add 
label define label_xf2e043 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e043 30 "Not applicable", add 
label define label_xf2e043 31 "Institution left item blank", add 
label define label_xf2e043 32 "Do not know", add 
label define label_xf2e043 33 "Particular 1st prof field not applicable", add 
label define label_xf2e043 50 "Outlier value derived from reported data", add 
label define label_xf2e043 51 "Outlier value derived from imported data", add 
label define label_xf2e043 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e043 53 "Value not derived - data not usable", add 
label values xf2e043 label_xf2e043
label define label_xf2e044 10 "Reported" 
label define label_xf2e044 11 "Analyst corrected reported value", add 
label define label_xf2e044 12 "Data generated from other data values", add 
label define label_xf2e044 13 "Implied zero", add 
label define label_xf2e044 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e044 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e044 22 "Imputed using the Group Median procedure", add 
label define label_xf2e044 23 "Logical imputation", add 
label define label_xf2e044 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e044 30 "Not applicable", add 
label define label_xf2e044 31 "Institution left item blank", add 
label define label_xf2e044 32 "Do not know", add 
label define label_xf2e044 33 "Particular 1st prof field not applicable", add 
label define label_xf2e044 50 "Outlier value derived from reported data", add 
label define label_xf2e044 51 "Outlier value derived from imported data", add 
label define label_xf2e044 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e044 53 "Value not derived - data not usable", add 
label values xf2e044 label_xf2e044
label define label_xf2e045 10 "Reported" 
label define label_xf2e045 11 "Analyst corrected reported value", add 
label define label_xf2e045 12 "Data generated from other data values", add 
label define label_xf2e045 13 "Implied zero", add 
label define label_xf2e045 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e045 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e045 22 "Imputed using the Group Median procedure", add 
label define label_xf2e045 23 "Logical imputation", add 
label define label_xf2e045 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e045 30 "Not applicable", add 
label define label_xf2e045 31 "Institution left item blank", add 
label define label_xf2e045 32 "Do not know", add 
label define label_xf2e045 33 "Particular 1st prof field not applicable", add 
label define label_xf2e045 50 "Outlier value derived from reported data", add 
label define label_xf2e045 51 "Outlier value derived from imported data", add 
label define label_xf2e045 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e045 53 "Value not derived - data not usable", add 
label values xf2e045 label_xf2e045
label define label_xf2e046 10 "Reported" 
label define label_xf2e046 11 "Analyst corrected reported value", add 
label define label_xf2e046 12 "Data generated from other data values", add 
label define label_xf2e046 13 "Implied zero", add 
label define label_xf2e046 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e046 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e046 22 "Imputed using the Group Median procedure", add 
label define label_xf2e046 23 "Logical imputation", add 
label define label_xf2e046 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e046 30 "Not applicable", add 
label define label_xf2e046 31 "Institution left item blank", add 
label define label_xf2e046 32 "Do not know", add 
label define label_xf2e046 33 "Particular 1st prof field not applicable", add 
label define label_xf2e046 50 "Outlier value derived from reported data", add 
label define label_xf2e046 51 "Outlier value derived from imported data", add 
label define label_xf2e046 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e046 53 "Value not derived - data not usable", add 
label values xf2e046 label_xf2e046
label define label_xf2e047 10 "Reported" 
label define label_xf2e047 11 "Analyst corrected reported value", add 
label define label_xf2e047 12 "Data generated from other data values", add 
label define label_xf2e047 13 "Implied zero", add 
label define label_xf2e047 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e047 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e047 22 "Imputed using the Group Median procedure", add 
label define label_xf2e047 23 "Logical imputation", add 
label define label_xf2e047 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e047 30 "Not applicable", add 
label define label_xf2e047 31 "Institution left item blank", add 
label define label_xf2e047 32 "Do not know", add 
label define label_xf2e047 33 "Particular 1st prof field not applicable", add 
label define label_xf2e047 50 "Outlier value derived from reported data", add 
label define label_xf2e047 51 "Outlier value derived from imported data", add 
label define label_xf2e047 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e047 53 "Value not derived - data not usable", add 
label values xf2e047 label_xf2e047
label define label_xf2e051 10 "Reported" 
label define label_xf2e051 11 "Analyst corrected reported value", add 
label define label_xf2e051 12 "Data generated from other data values", add 
label define label_xf2e051 13 "Implied zero", add 
label define label_xf2e051 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e051 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e051 22 "Imputed using the Group Median procedure", add 
label define label_xf2e051 23 "Logical imputation", add 
label define label_xf2e051 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e051 30 "Not applicable", add 
label define label_xf2e051 31 "Institution left item blank", add 
label define label_xf2e051 32 "Do not know", add 
label define label_xf2e051 33 "Particular 1st prof field not applicable", add 
label define label_xf2e051 50 "Outlier value derived from reported data", add 
label define label_xf2e051 51 "Outlier value derived from imported data", add 
label define label_xf2e051 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e051 53 "Value not derived - data not usable", add 
label values xf2e051 label_xf2e051
label define label_xf2e052 10 "Reported" 
label define label_xf2e052 11 "Analyst corrected reported value", add 
label define label_xf2e052 12 "Data generated from other data values", add 
label define label_xf2e052 13 "Implied zero", add 
label define label_xf2e052 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e052 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e052 22 "Imputed using the Group Median procedure", add 
label define label_xf2e052 23 "Logical imputation", add 
label define label_xf2e052 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e052 30 "Not applicable", add 
label define label_xf2e052 31 "Institution left item blank", add 
label define label_xf2e052 32 "Do not know", add 
label define label_xf2e052 33 "Particular 1st prof field not applicable", add 
label define label_xf2e052 50 "Outlier value derived from reported data", add 
label define label_xf2e052 51 "Outlier value derived from imported data", add 
label define label_xf2e052 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e052 53 "Value not derived - data not usable", add 
label values xf2e052 label_xf2e052
label define label_xf2e053 10 "Reported" 
label define label_xf2e053 11 "Analyst corrected reported value", add 
label define label_xf2e053 12 "Data generated from other data values", add 
label define label_xf2e053 13 "Implied zero", add 
label define label_xf2e053 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e053 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e053 22 "Imputed using the Group Median procedure", add 
label define label_xf2e053 23 "Logical imputation", add 
label define label_xf2e053 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e053 30 "Not applicable", add 
label define label_xf2e053 31 "Institution left item blank", add 
label define label_xf2e053 32 "Do not know", add 
label define label_xf2e053 33 "Particular 1st prof field not applicable", add 
label define label_xf2e053 50 "Outlier value derived from reported data", add 
label define label_xf2e053 51 "Outlier value derived from imported data", add 
label define label_xf2e053 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e053 53 "Value not derived - data not usable", add 
label values xf2e053 label_xf2e053
label define label_xf2e054 10 "Reported" 
label define label_xf2e054 11 "Analyst corrected reported value", add 
label define label_xf2e054 12 "Data generated from other data values", add 
label define label_xf2e054 13 "Implied zero", add 
label define label_xf2e054 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e054 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e054 22 "Imputed using the Group Median procedure", add 
label define label_xf2e054 23 "Logical imputation", add 
label define label_xf2e054 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e054 30 "Not applicable", add 
label define label_xf2e054 31 "Institution left item blank", add 
label define label_xf2e054 32 "Do not know", add 
label define label_xf2e054 33 "Particular 1st prof field not applicable", add 
label define label_xf2e054 50 "Outlier value derived from reported data", add 
label define label_xf2e054 51 "Outlier value derived from imported data", add 
label define label_xf2e054 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e054 53 "Value not derived - data not usable", add 
label values xf2e054 label_xf2e054
label define label_xf2e055 10 "Reported" 
label define label_xf2e055 11 "Analyst corrected reported value", add 
label define label_xf2e055 12 "Data generated from other data values", add 
label define label_xf2e055 13 "Implied zero", add 
label define label_xf2e055 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e055 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e055 22 "Imputed using the Group Median procedure", add 
label define label_xf2e055 23 "Logical imputation", add 
label define label_xf2e055 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e055 30 "Not applicable", add 
label define label_xf2e055 31 "Institution left item blank", add 
label define label_xf2e055 32 "Do not know", add 
label define label_xf2e055 33 "Particular 1st prof field not applicable", add 
label define label_xf2e055 50 "Outlier value derived from reported data", add 
label define label_xf2e055 51 "Outlier value derived from imported data", add 
label define label_xf2e055 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e055 53 "Value not derived - data not usable", add 
label values xf2e055 label_xf2e055
label define label_xf2e056 10 "Reported" 
label define label_xf2e056 11 "Analyst corrected reported value", add 
label define label_xf2e056 12 "Data generated from other data values", add 
label define label_xf2e056 13 "Implied zero", add 
label define label_xf2e056 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e056 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e056 22 "Imputed using the Group Median procedure", add 
label define label_xf2e056 23 "Logical imputation", add 
label define label_xf2e056 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e056 30 "Not applicable", add 
label define label_xf2e056 31 "Institution left item blank", add 
label define label_xf2e056 32 "Do not know", add 
label define label_xf2e056 33 "Particular 1st prof field not applicable", add 
label define label_xf2e056 50 "Outlier value derived from reported data", add 
label define label_xf2e056 51 "Outlier value derived from imported data", add 
label define label_xf2e056 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e056 53 "Value not derived - data not usable", add 
label values xf2e056 label_xf2e056
label define label_xf2e057 10 "Reported" 
label define label_xf2e057 11 "Analyst corrected reported value", add 
label define label_xf2e057 12 "Data generated from other data values", add 
label define label_xf2e057 13 "Implied zero", add 
label define label_xf2e057 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e057 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e057 22 "Imputed using the Group Median procedure", add 
label define label_xf2e057 23 "Logical imputation", add 
label define label_xf2e057 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e057 30 "Not applicable", add 
label define label_xf2e057 31 "Institution left item blank", add 
label define label_xf2e057 32 "Do not know", add 
label define label_xf2e057 33 "Particular 1st prof field not applicable", add 
label define label_xf2e057 50 "Outlier value derived from reported data", add 
label define label_xf2e057 51 "Outlier value derived from imported data", add 
label define label_xf2e057 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e057 53 "Value not derived - data not usable", add 
label values xf2e057 label_xf2e057
label define label_xf2e061 10 "Reported" 
label define label_xf2e061 11 "Analyst corrected reported value", add 
label define label_xf2e061 12 "Data generated from other data values", add 
label define label_xf2e061 13 "Implied zero", add 
label define label_xf2e061 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e061 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e061 22 "Imputed using the Group Median procedure", add 
label define label_xf2e061 23 "Logical imputation", add 
label define label_xf2e061 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e061 30 "Not applicable", add 
label define label_xf2e061 31 "Institution left item blank", add 
label define label_xf2e061 32 "Do not know", add 
label define label_xf2e061 33 "Particular 1st prof field not applicable", add 
label define label_xf2e061 50 "Outlier value derived from reported data", add 
label define label_xf2e061 51 "Outlier value derived from imported data", add 
label define label_xf2e061 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e061 53 "Value not derived - data not usable", add 
label values xf2e061 label_xf2e061
label define label_xf2e062 10 "Reported" 
label define label_xf2e062 11 "Analyst corrected reported value", add 
label define label_xf2e062 12 "Data generated from other data values", add 
label define label_xf2e062 13 "Implied zero", add 
label define label_xf2e062 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e062 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e062 22 "Imputed using the Group Median procedure", add 
label define label_xf2e062 23 "Logical imputation", add 
label define label_xf2e062 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e062 30 "Not applicable", add 
label define label_xf2e062 31 "Institution left item blank", add 
label define label_xf2e062 32 "Do not know", add 
label define label_xf2e062 33 "Particular 1st prof field not applicable", add 
label define label_xf2e062 50 "Outlier value derived from reported data", add 
label define label_xf2e062 51 "Outlier value derived from imported data", add 
label define label_xf2e062 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e062 53 "Value not derived - data not usable", add 
label values xf2e062 label_xf2e062
label define label_xf2e063 10 "Reported" 
label define label_xf2e063 11 "Analyst corrected reported value", add 
label define label_xf2e063 12 "Data generated from other data values", add 
label define label_xf2e063 13 "Implied zero", add 
label define label_xf2e063 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e063 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e063 22 "Imputed using the Group Median procedure", add 
label define label_xf2e063 23 "Logical imputation", add 
label define label_xf2e063 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e063 30 "Not applicable", add 
label define label_xf2e063 31 "Institution left item blank", add 
label define label_xf2e063 32 "Do not know", add 
label define label_xf2e063 33 "Particular 1st prof field not applicable", add 
label define label_xf2e063 50 "Outlier value derived from reported data", add 
label define label_xf2e063 51 "Outlier value derived from imported data", add 
label define label_xf2e063 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e063 53 "Value not derived - data not usable", add 
label values xf2e063 label_xf2e063
label define label_xf2e064 10 "Reported" 
label define label_xf2e064 11 "Analyst corrected reported value", add 
label define label_xf2e064 12 "Data generated from other data values", add 
label define label_xf2e064 13 "Implied zero", add 
label define label_xf2e064 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e064 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e064 22 "Imputed using the Group Median procedure", add 
label define label_xf2e064 23 "Logical imputation", add 
label define label_xf2e064 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e064 30 "Not applicable", add 
label define label_xf2e064 31 "Institution left item blank", add 
label define label_xf2e064 32 "Do not know", add 
label define label_xf2e064 33 "Particular 1st prof field not applicable", add 
label define label_xf2e064 50 "Outlier value derived from reported data", add 
label define label_xf2e064 51 "Outlier value derived from imported data", add 
label define label_xf2e064 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e064 53 "Value not derived - data not usable", add 
label values xf2e064 label_xf2e064
label define label_xf2e065 10 "Reported" 
label define label_xf2e065 11 "Analyst corrected reported value", add 
label define label_xf2e065 12 "Data generated from other data values", add 
label define label_xf2e065 13 "Implied zero", add 
label define label_xf2e065 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e065 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e065 22 "Imputed using the Group Median procedure", add 
label define label_xf2e065 23 "Logical imputation", add 
label define label_xf2e065 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e065 30 "Not applicable", add 
label define label_xf2e065 31 "Institution left item blank", add 
label define label_xf2e065 32 "Do not know", add 
label define label_xf2e065 33 "Particular 1st prof field not applicable", add 
label define label_xf2e065 50 "Outlier value derived from reported data", add 
label define label_xf2e065 51 "Outlier value derived from imported data", add 
label define label_xf2e065 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e065 53 "Value not derived - data not usable", add 
label values xf2e065 label_xf2e065
label define label_xf2e066 10 "Reported" 
label define label_xf2e066 11 "Analyst corrected reported value", add 
label define label_xf2e066 12 "Data generated from other data values", add 
label define label_xf2e066 13 "Implied zero", add 
label define label_xf2e066 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e066 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e066 22 "Imputed using the Group Median procedure", add 
label define label_xf2e066 23 "Logical imputation", add 
label define label_xf2e066 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e066 30 "Not applicable", add 
label define label_xf2e066 31 "Institution left item blank", add 
label define label_xf2e066 32 "Do not know", add 
label define label_xf2e066 33 "Particular 1st prof field not applicable", add 
label define label_xf2e066 50 "Outlier value derived from reported data", add 
label define label_xf2e066 51 "Outlier value derived from imported data", add 
label define label_xf2e066 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e066 53 "Value not derived - data not usable", add 
label values xf2e066 label_xf2e066
label define label_xf2e067 10 "Reported" 
label define label_xf2e067 11 "Analyst corrected reported value", add 
label define label_xf2e067 12 "Data generated from other data values", add 
label define label_xf2e067 13 "Implied zero", add 
label define label_xf2e067 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e067 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e067 22 "Imputed using the Group Median procedure", add 
label define label_xf2e067 23 "Logical imputation", add 
label define label_xf2e067 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e067 30 "Not applicable", add 
label define label_xf2e067 31 "Institution left item blank", add 
label define label_xf2e067 32 "Do not know", add 
label define label_xf2e067 33 "Particular 1st prof field not applicable", add 
label define label_xf2e067 50 "Outlier value derived from reported data", add 
label define label_xf2e067 51 "Outlier value derived from imported data", add 
label define label_xf2e067 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e067 53 "Value not derived - data not usable", add 
label values xf2e067 label_xf2e067
label define label_xf2e071 10 "Reported" 
label define label_xf2e071 11 "Analyst corrected reported value", add 
label define label_xf2e071 12 "Data generated from other data values", add 
label define label_xf2e071 13 "Implied zero", add 
label define label_xf2e071 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e071 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e071 22 "Imputed using the Group Median procedure", add 
label define label_xf2e071 23 "Logical imputation", add 
label define label_xf2e071 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e071 30 "Not applicable", add 
label define label_xf2e071 31 "Institution left item blank", add 
label define label_xf2e071 32 "Do not know", add 
label define label_xf2e071 33 "Particular 1st prof field not applicable", add 
label define label_xf2e071 50 "Outlier value derived from reported data", add 
label define label_xf2e071 51 "Outlier value derived from imported data", add 
label define label_xf2e071 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e071 53 "Value not derived - data not usable", add 
label values xf2e071 label_xf2e071
label define label_xf2e072 10 "Reported" 
label define label_xf2e072 11 "Analyst corrected reported value", add 
label define label_xf2e072 12 "Data generated from other data values", add 
label define label_xf2e072 13 "Implied zero", add 
label define label_xf2e072 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e072 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e072 22 "Imputed using the Group Median procedure", add 
label define label_xf2e072 23 "Logical imputation", add 
label define label_xf2e072 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e072 30 "Not applicable", add 
label define label_xf2e072 31 "Institution left item blank", add 
label define label_xf2e072 32 "Do not know", add 
label define label_xf2e072 33 "Particular 1st prof field not applicable", add 
label define label_xf2e072 50 "Outlier value derived from reported data", add 
label define label_xf2e072 51 "Outlier value derived from imported data", add 
label define label_xf2e072 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e072 53 "Value not derived - data not usable", add 
label values xf2e072 label_xf2e072
label define label_xf2e073 10 "Reported" 
label define label_xf2e073 11 "Analyst corrected reported value", add 
label define label_xf2e073 12 "Data generated from other data values", add 
label define label_xf2e073 13 "Implied zero", add 
label define label_xf2e073 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e073 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e073 22 "Imputed using the Group Median procedure", add 
label define label_xf2e073 23 "Logical imputation", add 
label define label_xf2e073 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e073 30 "Not applicable", add 
label define label_xf2e073 31 "Institution left item blank", add 
label define label_xf2e073 32 "Do not know", add 
label define label_xf2e073 33 "Particular 1st prof field not applicable", add 
label define label_xf2e073 50 "Outlier value derived from reported data", add 
label define label_xf2e073 51 "Outlier value derived from imported data", add 
label define label_xf2e073 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e073 53 "Value not derived - data not usable", add 
label values xf2e073 label_xf2e073
label define label_xf2e074 10 "Reported" 
label define label_xf2e074 11 "Analyst corrected reported value", add 
label define label_xf2e074 12 "Data generated from other data values", add 
label define label_xf2e074 13 "Implied zero", add 
label define label_xf2e074 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e074 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e074 22 "Imputed using the Group Median procedure", add 
label define label_xf2e074 23 "Logical imputation", add 
label define label_xf2e074 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e074 30 "Not applicable", add 
label define label_xf2e074 31 "Institution left item blank", add 
label define label_xf2e074 32 "Do not know", add 
label define label_xf2e074 33 "Particular 1st prof field not applicable", add 
label define label_xf2e074 50 "Outlier value derived from reported data", add 
label define label_xf2e074 51 "Outlier value derived from imported data", add 
label define label_xf2e074 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e074 53 "Value not derived - data not usable", add 
label values xf2e074 label_xf2e074
label define label_xf2e075 10 "Reported" 
label define label_xf2e075 11 "Analyst corrected reported value", add 
label define label_xf2e075 12 "Data generated from other data values", add 
label define label_xf2e075 13 "Implied zero", add 
label define label_xf2e075 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e075 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e075 22 "Imputed using the Group Median procedure", add 
label define label_xf2e075 23 "Logical imputation", add 
label define label_xf2e075 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e075 30 "Not applicable", add 
label define label_xf2e075 31 "Institution left item blank", add 
label define label_xf2e075 32 "Do not know", add 
label define label_xf2e075 33 "Particular 1st prof field not applicable", add 
label define label_xf2e075 50 "Outlier value derived from reported data", add 
label define label_xf2e075 51 "Outlier value derived from imported data", add 
label define label_xf2e075 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e075 53 "Value not derived - data not usable", add 
label values xf2e075 label_xf2e075
label define label_xf2e076 10 "Reported" 
label define label_xf2e076 11 "Analyst corrected reported value", add 
label define label_xf2e076 12 "Data generated from other data values", add 
label define label_xf2e076 13 "Implied zero", add 
label define label_xf2e076 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e076 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e076 22 "Imputed using the Group Median procedure", add 
label define label_xf2e076 23 "Logical imputation", add 
label define label_xf2e076 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e076 30 "Not applicable", add 
label define label_xf2e076 31 "Institution left item blank", add 
label define label_xf2e076 32 "Do not know", add 
label define label_xf2e076 33 "Particular 1st prof field not applicable", add 
label define label_xf2e076 50 "Outlier value derived from reported data", add 
label define label_xf2e076 51 "Outlier value derived from imported data", add 
label define label_xf2e076 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e076 53 "Value not derived - data not usable", add 
label values xf2e076 label_xf2e076
label define label_xf2e077 10 "Reported" 
label define label_xf2e077 11 "Analyst corrected reported value", add 
label define label_xf2e077 12 "Data generated from other data values", add 
label define label_xf2e077 13 "Implied zero", add 
label define label_xf2e077 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e077 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e077 22 "Imputed using the Group Median procedure", add 
label define label_xf2e077 23 "Logical imputation", add 
label define label_xf2e077 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e077 30 "Not applicable", add 
label define label_xf2e077 31 "Institution left item blank", add 
label define label_xf2e077 32 "Do not know", add 
label define label_xf2e077 33 "Particular 1st prof field not applicable", add 
label define label_xf2e077 50 "Outlier value derived from reported data", add 
label define label_xf2e077 51 "Outlier value derived from imported data", add 
label define label_xf2e077 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e077 53 "Value not derived - data not usable", add 
label values xf2e077 label_xf2e077
label define label_xf2e081 10 "Reported" 
label define label_xf2e081 11 "Analyst corrected reported value", add 
label define label_xf2e081 12 "Data generated from other data values", add 
label define label_xf2e081 13 "Implied zero", add 
label define label_xf2e081 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e081 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e081 22 "Imputed using the Group Median procedure", add 
label define label_xf2e081 23 "Logical imputation", add 
label define label_xf2e081 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e081 30 "Not applicable", add 
label define label_xf2e081 31 "Institution left item blank", add 
label define label_xf2e081 32 "Do not know", add 
label define label_xf2e081 33 "Particular 1st prof field not applicable", add 
label define label_xf2e081 50 "Outlier value derived from reported data", add 
label define label_xf2e081 51 "Outlier value derived from imported data", add 
label define label_xf2e081 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e081 53 "Value not derived - data not usable", add 
label values xf2e081 label_xf2e081
label define label_xf2e082 10 "Reported" 
label define label_xf2e082 11 "Analyst corrected reported value", add 
label define label_xf2e082 12 "Data generated from other data values", add 
label define label_xf2e082 13 "Implied zero", add 
label define label_xf2e082 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e082 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e082 22 "Imputed using the Group Median procedure", add 
label define label_xf2e082 23 "Logical imputation", add 
label define label_xf2e082 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e082 30 "Not applicable", add 
label define label_xf2e082 31 "Institution left item blank", add 
label define label_xf2e082 32 "Do not know", add 
label define label_xf2e082 33 "Particular 1st prof field not applicable", add 
label define label_xf2e082 50 "Outlier value derived from reported data", add 
label define label_xf2e082 51 "Outlier value derived from imported data", add 
label define label_xf2e082 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e082 53 "Value not derived - data not usable", add 
label values xf2e082 label_xf2e082
label define label_xf2e083 10 "Reported" 
label define label_xf2e083 11 "Analyst corrected reported value", add 
label define label_xf2e083 12 "Data generated from other data values", add 
label define label_xf2e083 13 "Implied zero", add 
label define label_xf2e083 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e083 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e083 22 "Imputed using the Group Median procedure", add 
label define label_xf2e083 23 "Logical imputation", add 
label define label_xf2e083 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e083 30 "Not applicable", add 
label define label_xf2e083 31 "Institution left item blank", add 
label define label_xf2e083 32 "Do not know", add 
label define label_xf2e083 33 "Particular 1st prof field not applicable", add 
label define label_xf2e083 50 "Outlier value derived from reported data", add 
label define label_xf2e083 51 "Outlier value derived from imported data", add 
label define label_xf2e083 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e083 53 "Value not derived - data not usable", add 
label values xf2e083 label_xf2e083
label define label_xf2e084 10 "Reported" 
label define label_xf2e084 11 "Analyst corrected reported value", add 
label define label_xf2e084 12 "Data generated from other data values", add 
label define label_xf2e084 13 "Implied zero", add 
label define label_xf2e084 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e084 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e084 22 "Imputed using the Group Median procedure", add 
label define label_xf2e084 23 "Logical imputation", add 
label define label_xf2e084 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e084 30 "Not applicable", add 
label define label_xf2e084 31 "Institution left item blank", add 
label define label_xf2e084 32 "Do not know", add 
label define label_xf2e084 33 "Particular 1st prof field not applicable", add 
label define label_xf2e084 50 "Outlier value derived from reported data", add 
label define label_xf2e084 51 "Outlier value derived from imported data", add 
label define label_xf2e084 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e084 53 "Value not derived - data not usable", add 
label values xf2e084 label_xf2e084
label define label_xf2e085 10 "Reported" 
label define label_xf2e085 11 "Analyst corrected reported value", add 
label define label_xf2e085 12 "Data generated from other data values", add 
label define label_xf2e085 13 "Implied zero", add 
label define label_xf2e085 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e085 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e085 22 "Imputed using the Group Median procedure", add 
label define label_xf2e085 23 "Logical imputation", add 
label define label_xf2e085 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e085 30 "Not applicable", add 
label define label_xf2e085 31 "Institution left item blank", add 
label define label_xf2e085 32 "Do not know", add 
label define label_xf2e085 33 "Particular 1st prof field not applicable", add 
label define label_xf2e085 50 "Outlier value derived from reported data", add 
label define label_xf2e085 51 "Outlier value derived from imported data", add 
label define label_xf2e085 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e085 53 "Value not derived - data not usable", add 
label values xf2e085 label_xf2e085
label define label_xf2e086 10 "Reported" 
label define label_xf2e086 11 "Analyst corrected reported value", add 
label define label_xf2e086 12 "Data generated from other data values", add 
label define label_xf2e086 13 "Implied zero", add 
label define label_xf2e086 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e086 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e086 22 "Imputed using the Group Median procedure", add 
label define label_xf2e086 23 "Logical imputation", add 
label define label_xf2e086 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e086 30 "Not applicable", add 
label define label_xf2e086 31 "Institution left item blank", add 
label define label_xf2e086 32 "Do not know", add 
label define label_xf2e086 33 "Particular 1st prof field not applicable", add 
label define label_xf2e086 50 "Outlier value derived from reported data", add 
label define label_xf2e086 51 "Outlier value derived from imported data", add 
label define label_xf2e086 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e086 53 "Value not derived - data not usable", add 
label values xf2e086 label_xf2e086
label define label_xf2e087 10 "Reported" 
label define label_xf2e087 11 "Analyst corrected reported value", add 
label define label_xf2e087 12 "Data generated from other data values", add 
label define label_xf2e087 13 "Implied zero", add 
label define label_xf2e087 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e087 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e087 22 "Imputed using the Group Median procedure", add 
label define label_xf2e087 23 "Logical imputation", add 
label define label_xf2e087 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e087 30 "Not applicable", add 
label define label_xf2e087 31 "Institution left item blank", add 
label define label_xf2e087 32 "Do not know", add 
label define label_xf2e087 33 "Particular 1st prof field not applicable", add 
label define label_xf2e087 50 "Outlier value derived from reported data", add 
label define label_xf2e087 51 "Outlier value derived from imported data", add 
label define label_xf2e087 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e087 53 "Value not derived - data not usable", add 
label values xf2e087 label_xf2e087
label define label_xf2e091 10 "Reported" 
label define label_xf2e091 11 "Analyst corrected reported value", add 
label define label_xf2e091 12 "Data generated from other data values", add 
label define label_xf2e091 13 "Implied zero", add 
label define label_xf2e091 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e091 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e091 22 "Imputed using the Group Median procedure", add 
label define label_xf2e091 23 "Logical imputation", add 
label define label_xf2e091 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e091 30 "Not applicable", add 
label define label_xf2e091 31 "Institution left item blank", add 
label define label_xf2e091 32 "Do not know", add 
label define label_xf2e091 33 "Particular 1st prof field not applicable", add 
label define label_xf2e091 50 "Outlier value derived from reported data", add 
label define label_xf2e091 51 "Outlier value derived from imported data", add 
label define label_xf2e091 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e091 53 "Value not derived - data not usable", add 
label values xf2e091 label_xf2e091
label define label_xf2e092 10 "Reported" 
label define label_xf2e092 11 "Analyst corrected reported value", add 
label define label_xf2e092 12 "Data generated from other data values", add 
label define label_xf2e092 13 "Implied zero", add 
label define label_xf2e092 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e092 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e092 22 "Imputed using the Group Median procedure", add 
label define label_xf2e092 23 "Logical imputation", add 
label define label_xf2e092 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e092 30 "Not applicable", add 
label define label_xf2e092 31 "Institution left item blank", add 
label define label_xf2e092 32 "Do not know", add 
label define label_xf2e092 33 "Particular 1st prof field not applicable", add 
label define label_xf2e092 50 "Outlier value derived from reported data", add 
label define label_xf2e092 51 "Outlier value derived from imported data", add 
label define label_xf2e092 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e092 53 "Value not derived - data not usable", add 
label values xf2e092 label_xf2e092
label define label_xf2e093 10 "Reported" 
label define label_xf2e093 11 "Analyst corrected reported value", add 
label define label_xf2e093 12 "Data generated from other data values", add 
label define label_xf2e093 13 "Implied zero", add 
label define label_xf2e093 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e093 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e093 22 "Imputed using the Group Median procedure", add 
label define label_xf2e093 23 "Logical imputation", add 
label define label_xf2e093 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e093 30 "Not applicable", add 
label define label_xf2e093 31 "Institution left item blank", add 
label define label_xf2e093 32 "Do not know", add 
label define label_xf2e093 33 "Particular 1st prof field not applicable", add 
label define label_xf2e093 50 "Outlier value derived from reported data", add 
label define label_xf2e093 51 "Outlier value derived from imported data", add 
label define label_xf2e093 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e093 53 "Value not derived - data not usable", add 
label values xf2e093 label_xf2e093
label define label_xf2e094 10 "Reported" 
label define label_xf2e094 11 "Analyst corrected reported value", add 
label define label_xf2e094 12 "Data generated from other data values", add 
label define label_xf2e094 13 "Implied zero", add 
label define label_xf2e094 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e094 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e094 22 "Imputed using the Group Median procedure", add 
label define label_xf2e094 23 "Logical imputation", add 
label define label_xf2e094 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e094 30 "Not applicable", add 
label define label_xf2e094 31 "Institution left item blank", add 
label define label_xf2e094 32 "Do not know", add 
label define label_xf2e094 33 "Particular 1st prof field not applicable", add 
label define label_xf2e094 50 "Outlier value derived from reported data", add 
label define label_xf2e094 51 "Outlier value derived from imported data", add 
label define label_xf2e094 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e094 53 "Value not derived - data not usable", add 
label values xf2e094 label_xf2e094
label define label_xf2e095 10 "Reported" 
label define label_xf2e095 11 "Analyst corrected reported value", add 
label define label_xf2e095 12 "Data generated from other data values", add 
label define label_xf2e095 13 "Implied zero", add 
label define label_xf2e095 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e095 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e095 22 "Imputed using the Group Median procedure", add 
label define label_xf2e095 23 "Logical imputation", add 
label define label_xf2e095 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e095 30 "Not applicable", add 
label define label_xf2e095 31 "Institution left item blank", add 
label define label_xf2e095 32 "Do not know", add 
label define label_xf2e095 33 "Particular 1st prof field not applicable", add 
label define label_xf2e095 50 "Outlier value derived from reported data", add 
label define label_xf2e095 51 "Outlier value derived from imported data", add 
label define label_xf2e095 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e095 53 "Value not derived - data not usable", add 
label values xf2e095 label_xf2e095
label define label_xf2e096 10 "Reported" 
label define label_xf2e096 11 "Analyst corrected reported value", add 
label define label_xf2e096 12 "Data generated from other data values", add 
label define label_xf2e096 13 "Implied zero", add 
label define label_xf2e096 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e096 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e096 22 "Imputed using the Group Median procedure", add 
label define label_xf2e096 23 "Logical imputation", add 
label define label_xf2e096 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e096 30 "Not applicable", add 
label define label_xf2e096 31 "Institution left item blank", add 
label define label_xf2e096 32 "Do not know", add 
label define label_xf2e096 33 "Particular 1st prof field not applicable", add 
label define label_xf2e096 50 "Outlier value derived from reported data", add 
label define label_xf2e096 51 "Outlier value derived from imported data", add 
label define label_xf2e096 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e096 53 "Value not derived - data not usable", add 
label values xf2e096 label_xf2e096
label define label_xf2e097 10 "Reported" 
label define label_xf2e097 11 "Analyst corrected reported value", add 
label define label_xf2e097 12 "Data generated from other data values", add 
label define label_xf2e097 13 "Implied zero", add 
label define label_xf2e097 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e097 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e097 22 "Imputed using the Group Median procedure", add 
label define label_xf2e097 23 "Logical imputation", add 
label define label_xf2e097 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e097 30 "Not applicable", add 
label define label_xf2e097 31 "Institution left item blank", add 
label define label_xf2e097 32 "Do not know", add 
label define label_xf2e097 33 "Particular 1st prof field not applicable", add 
label define label_xf2e097 50 "Outlier value derived from reported data", add 
label define label_xf2e097 51 "Outlier value derived from imported data", add 
label define label_xf2e097 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e097 53 "Value not derived - data not usable", add 
label values xf2e097 label_xf2e097
label define label_xf2e101 10 "Reported" 
label define label_xf2e101 11 "Analyst corrected reported value", add 
label define label_xf2e101 12 "Data generated from other data values", add 
label define label_xf2e101 13 "Implied zero", add 
label define label_xf2e101 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e101 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e101 22 "Imputed using the Group Median procedure", add 
label define label_xf2e101 23 "Logical imputation", add 
label define label_xf2e101 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e101 30 "Not applicable", add 
label define label_xf2e101 31 "Institution left item blank", add 
label define label_xf2e101 32 "Do not know", add 
label define label_xf2e101 33 "Particular 1st prof field not applicable", add 
label define label_xf2e101 50 "Outlier value derived from reported data", add 
label define label_xf2e101 51 "Outlier value derived from imported data", add 
label define label_xf2e101 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e101 53 "Value not derived - data not usable", add 
label values xf2e101 label_xf2e101
label define label_xf2e102 10 "Reported" 
label define label_xf2e102 11 "Analyst corrected reported value", add 
label define label_xf2e102 12 "Data generated from other data values", add 
label define label_xf2e102 13 "Implied zero", add 
label define label_xf2e102 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e102 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e102 22 "Imputed using the Group Median procedure", add 
label define label_xf2e102 23 "Logical imputation", add 
label define label_xf2e102 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e102 30 "Not applicable", add 
label define label_xf2e102 31 "Institution left item blank", add 
label define label_xf2e102 32 "Do not know", add 
label define label_xf2e102 33 "Particular 1st prof field not applicable", add 
label define label_xf2e102 50 "Outlier value derived from reported data", add 
label define label_xf2e102 51 "Outlier value derived from imported data", add 
label define label_xf2e102 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e102 53 "Value not derived - data not usable", add 
label values xf2e102 label_xf2e102
label define label_xf2e103 10 "Reported" 
label define label_xf2e103 11 "Analyst corrected reported value", add 
label define label_xf2e103 12 "Data generated from other data values", add 
label define label_xf2e103 13 "Implied zero", add 
label define label_xf2e103 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e103 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e103 22 "Imputed using the Group Median procedure", add 
label define label_xf2e103 23 "Logical imputation", add 
label define label_xf2e103 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e103 30 "Not applicable", add 
label define label_xf2e103 31 "Institution left item blank", add 
label define label_xf2e103 32 "Do not know", add 
label define label_xf2e103 33 "Particular 1st prof field not applicable", add 
label define label_xf2e103 50 "Outlier value derived from reported data", add 
label define label_xf2e103 51 "Outlier value derived from imported data", add 
label define label_xf2e103 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e103 53 "Value not derived - data not usable", add 
label values xf2e103 label_xf2e103
label define label_xf2e104 10 "Reported" 
label define label_xf2e104 11 "Analyst corrected reported value", add 
label define label_xf2e104 12 "Data generated from other data values", add 
label define label_xf2e104 13 "Implied zero", add 
label define label_xf2e104 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e104 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e104 22 "Imputed using the Group Median procedure", add 
label define label_xf2e104 23 "Logical imputation", add 
label define label_xf2e104 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e104 30 "Not applicable", add 
label define label_xf2e104 31 "Institution left item blank", add 
label define label_xf2e104 32 "Do not know", add 
label define label_xf2e104 33 "Particular 1st prof field not applicable", add 
label define label_xf2e104 50 "Outlier value derived from reported data", add 
label define label_xf2e104 51 "Outlier value derived from imported data", add 
label define label_xf2e104 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e104 53 "Value not derived - data not usable", add 
label values xf2e104 label_xf2e104
label define label_xf2e105 10 "Reported" 
label define label_xf2e105 11 "Analyst corrected reported value", add 
label define label_xf2e105 12 "Data generated from other data values", add 
label define label_xf2e105 13 "Implied zero", add 
label define label_xf2e105 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e105 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e105 22 "Imputed using the Group Median procedure", add 
label define label_xf2e105 23 "Logical imputation", add 
label define label_xf2e105 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e105 30 "Not applicable", add 
label define label_xf2e105 31 "Institution left item blank", add 
label define label_xf2e105 32 "Do not know", add 
label define label_xf2e105 33 "Particular 1st prof field not applicable", add 
label define label_xf2e105 50 "Outlier value derived from reported data", add 
label define label_xf2e105 51 "Outlier value derived from imported data", add 
label define label_xf2e105 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e105 53 "Value not derived - data not usable", add 
label values xf2e105 label_xf2e105
label define label_xf2e106 10 "Reported" 
label define label_xf2e106 11 "Analyst corrected reported value", add 
label define label_xf2e106 12 "Data generated from other data values", add 
label define label_xf2e106 13 "Implied zero", add 
label define label_xf2e106 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e106 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e106 22 "Imputed using the Group Median procedure", add 
label define label_xf2e106 23 "Logical imputation", add 
label define label_xf2e106 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e106 30 "Not applicable", add 
label define label_xf2e106 31 "Institution left item blank", add 
label define label_xf2e106 32 "Do not know", add 
label define label_xf2e106 33 "Particular 1st prof field not applicable", add 
label define label_xf2e106 50 "Outlier value derived from reported data", add 
label define label_xf2e106 51 "Outlier value derived from imported data", add 
label define label_xf2e106 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e106 53 "Value not derived - data not usable", add 
label values xf2e106 label_xf2e106
label define label_xf2e107 10 "Reported" 
label define label_xf2e107 11 "Analyst corrected reported value", add 
label define label_xf2e107 12 "Data generated from other data values", add 
label define label_xf2e107 13 "Implied zero", add 
label define label_xf2e107 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e107 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e107 22 "Imputed using the Group Median procedure", add 
label define label_xf2e107 23 "Logical imputation", add 
label define label_xf2e107 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e107 30 "Not applicable", add 
label define label_xf2e107 31 "Institution left item blank", add 
label define label_xf2e107 32 "Do not know", add 
label define label_xf2e107 33 "Particular 1st prof field not applicable", add 
label define label_xf2e107 50 "Outlier value derived from reported data", add 
label define label_xf2e107 51 "Outlier value derived from imported data", add 
label define label_xf2e107 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e107 53 "Value not derived - data not usable", add 
label values xf2e107 label_xf2e107
label define label_xf2e111 10 "Reported" 
label define label_xf2e111 11 "Analyst corrected reported value", add 
label define label_xf2e111 12 "Data generated from other data values", add 
label define label_xf2e111 13 "Implied zero", add 
label define label_xf2e111 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e111 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e111 22 "Imputed using the Group Median procedure", add 
label define label_xf2e111 23 "Logical imputation", add 
label define label_xf2e111 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e111 30 "Not applicable", add 
label define label_xf2e111 31 "Institution left item blank", add 
label define label_xf2e111 32 "Do not know", add 
label define label_xf2e111 33 "Particular 1st prof field not applicable", add 
label define label_xf2e111 50 "Outlier value derived from reported data", add 
label define label_xf2e111 51 "Outlier value derived from imported data", add 
label define label_xf2e111 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e111 53 "Value not derived - data not usable", add 
label values xf2e111 label_xf2e111
label define label_xf2e112 10 "Reported" 
label define label_xf2e112 11 "Analyst corrected reported value", add 
label define label_xf2e112 12 "Data generated from other data values", add 
label define label_xf2e112 13 "Implied zero", add 
label define label_xf2e112 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e112 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e112 22 "Imputed using the Group Median procedure", add 
label define label_xf2e112 23 "Logical imputation", add 
label define label_xf2e112 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e112 30 "Not applicable", add 
label define label_xf2e112 31 "Institution left item blank", add 
label define label_xf2e112 32 "Do not know", add 
label define label_xf2e112 33 "Particular 1st prof field not applicable", add 
label define label_xf2e112 50 "Outlier value derived from reported data", add 
label define label_xf2e112 51 "Outlier value derived from imported data", add 
label define label_xf2e112 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e112 53 "Value not derived - data not usable", add 
label values xf2e112 label_xf2e112
label define label_xf2e113 10 "Reported" 
label define label_xf2e113 11 "Analyst corrected reported value", add 
label define label_xf2e113 12 "Data generated from other data values", add 
label define label_xf2e113 13 "Implied zero", add 
label define label_xf2e113 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e113 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e113 22 "Imputed using the Group Median procedure", add 
label define label_xf2e113 23 "Logical imputation", add 
label define label_xf2e113 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e113 30 "Not applicable", add 
label define label_xf2e113 31 "Institution left item blank", add 
label define label_xf2e113 32 "Do not know", add 
label define label_xf2e113 33 "Particular 1st prof field not applicable", add 
label define label_xf2e113 50 "Outlier value derived from reported data", add 
label define label_xf2e113 51 "Outlier value derived from imported data", add 
label define label_xf2e113 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e113 53 "Value not derived - data not usable", add 
label values xf2e113 label_xf2e113
label define label_xf2e114 10 "Reported" 
label define label_xf2e114 11 "Analyst corrected reported value", add 
label define label_xf2e114 12 "Data generated from other data values", add 
label define label_xf2e114 13 "Implied zero", add 
label define label_xf2e114 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e114 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e114 22 "Imputed using the Group Median procedure", add 
label define label_xf2e114 23 "Logical imputation", add 
label define label_xf2e114 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e114 30 "Not applicable", add 
label define label_xf2e114 31 "Institution left item blank", add 
label define label_xf2e114 32 "Do not know", add 
label define label_xf2e114 33 "Particular 1st prof field not applicable", add 
label define label_xf2e114 50 "Outlier value derived from reported data", add 
label define label_xf2e114 51 "Outlier value derived from imported data", add 
label define label_xf2e114 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e114 53 "Value not derived - data not usable", add 
label values xf2e114 label_xf2e114
label define label_xf2e115 10 "Reported" 
label define label_xf2e115 11 "Analyst corrected reported value", add 
label define label_xf2e115 12 "Data generated from other data values", add 
label define label_xf2e115 13 "Implied zero", add 
label define label_xf2e115 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e115 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e115 22 "Imputed using the Group Median procedure", add 
label define label_xf2e115 23 "Logical imputation", add 
label define label_xf2e115 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e115 30 "Not applicable", add 
label define label_xf2e115 31 "Institution left item blank", add 
label define label_xf2e115 32 "Do not know", add 
label define label_xf2e115 33 "Particular 1st prof field not applicable", add 
label define label_xf2e115 50 "Outlier value derived from reported data", add 
label define label_xf2e115 51 "Outlier value derived from imported data", add 
label define label_xf2e115 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e115 53 "Value not derived - data not usable", add 
label values xf2e115 label_xf2e115
label define label_xf2e116 10 "Reported" 
label define label_xf2e116 11 "Analyst corrected reported value", add 
label define label_xf2e116 12 "Data generated from other data values", add 
label define label_xf2e116 13 "Implied zero", add 
label define label_xf2e116 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e116 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e116 22 "Imputed using the Group Median procedure", add 
label define label_xf2e116 23 "Logical imputation", add 
label define label_xf2e116 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e116 30 "Not applicable", add 
label define label_xf2e116 31 "Institution left item blank", add 
label define label_xf2e116 32 "Do not know", add 
label define label_xf2e116 33 "Particular 1st prof field not applicable", add 
label define label_xf2e116 50 "Outlier value derived from reported data", add 
label define label_xf2e116 51 "Outlier value derived from imported data", add 
label define label_xf2e116 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e116 53 "Value not derived - data not usable", add 
label values xf2e116 label_xf2e116
label define label_xf2e117 10 "Reported" 
label define label_xf2e117 11 "Analyst corrected reported value", add 
label define label_xf2e117 12 "Data generated from other data values", add 
label define label_xf2e117 13 "Implied zero", add 
label define label_xf2e117 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e117 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e117 22 "Imputed using the Group Median procedure", add 
label define label_xf2e117 23 "Logical imputation", add 
label define label_xf2e117 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e117 30 "Not applicable", add 
label define label_xf2e117 31 "Institution left item blank", add 
label define label_xf2e117 32 "Do not know", add 
label define label_xf2e117 33 "Particular 1st prof field not applicable", add 
label define label_xf2e117 50 "Outlier value derived from reported data", add 
label define label_xf2e117 51 "Outlier value derived from imported data", add 
label define label_xf2e117 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e117 53 "Value not derived - data not usable", add 
label values xf2e117 label_xf2e117
label define label_xf2e121 10 "Reported" 
label define label_xf2e121 11 "Analyst corrected reported value", add 
label define label_xf2e121 12 "Data generated from other data values", add 
label define label_xf2e121 13 "Implied zero", add 
label define label_xf2e121 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e121 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e121 22 "Imputed using the Group Median procedure", add 
label define label_xf2e121 23 "Logical imputation", add 
label define label_xf2e121 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e121 30 "Not applicable", add 
label define label_xf2e121 31 "Institution left item blank", add 
label define label_xf2e121 32 "Do not know", add 
label define label_xf2e121 33 "Particular 1st prof field not applicable", add 
label define label_xf2e121 50 "Outlier value derived from reported data", add 
label define label_xf2e121 51 "Outlier value derived from imported data", add 
label define label_xf2e121 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e121 53 "Value not derived - data not usable", add 
label values xf2e121 label_xf2e121
label define label_xf2e122 10 "Reported" 
label define label_xf2e122 11 "Analyst corrected reported value", add 
label define label_xf2e122 12 "Data generated from other data values", add 
label define label_xf2e122 13 "Implied zero", add 
label define label_xf2e122 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e122 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e122 22 "Imputed using the Group Median procedure", add 
label define label_xf2e122 23 "Logical imputation", add 
label define label_xf2e122 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e122 30 "Not applicable", add 
label define label_xf2e122 31 "Institution left item blank", add 
label define label_xf2e122 32 "Do not know", add 
label define label_xf2e122 33 "Particular 1st prof field not applicable", add 
label define label_xf2e122 50 "Outlier value derived from reported data", add 
label define label_xf2e122 51 "Outlier value derived from imported data", add 
label define label_xf2e122 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e122 53 "Value not derived - data not usable", add 
label values xf2e122 label_xf2e122
label define label_xf2e123 10 "Reported" 
label define label_xf2e123 11 "Analyst corrected reported value", add 
label define label_xf2e123 12 "Data generated from other data values", add 
label define label_xf2e123 13 "Implied zero", add 
label define label_xf2e123 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e123 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e123 22 "Imputed using the Group Median procedure", add 
label define label_xf2e123 23 "Logical imputation", add 
label define label_xf2e123 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e123 30 "Not applicable", add 
label define label_xf2e123 31 "Institution left item blank", add 
label define label_xf2e123 32 "Do not know", add 
label define label_xf2e123 33 "Particular 1st prof field not applicable", add 
label define label_xf2e123 50 "Outlier value derived from reported data", add 
label define label_xf2e123 51 "Outlier value derived from imported data", add 
label define label_xf2e123 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e123 53 "Value not derived - data not usable", add 
label values xf2e123 label_xf2e123
label define label_xf2e124 10 "Reported" 
label define label_xf2e124 11 "Analyst corrected reported value", add 
label define label_xf2e124 12 "Data generated from other data values", add 
label define label_xf2e124 13 "Implied zero", add 
label define label_xf2e124 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e124 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e124 22 "Imputed using the Group Median procedure", add 
label define label_xf2e124 23 "Logical imputation", add 
label define label_xf2e124 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e124 30 "Not applicable", add 
label define label_xf2e124 31 "Institution left item blank", add 
label define label_xf2e124 32 "Do not know", add 
label define label_xf2e124 33 "Particular 1st prof field not applicable", add 
label define label_xf2e124 50 "Outlier value derived from reported data", add 
label define label_xf2e124 51 "Outlier value derived from imported data", add 
label define label_xf2e124 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e124 53 "Value not derived - data not usable", add 
label values xf2e124 label_xf2e124
label define label_xf2e125 10 "Reported" 
label define label_xf2e125 11 "Analyst corrected reported value", add 
label define label_xf2e125 12 "Data generated from other data values", add 
label define label_xf2e125 13 "Implied zero", add 
label define label_xf2e125 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e125 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e125 22 "Imputed using the Group Median procedure", add 
label define label_xf2e125 23 "Logical imputation", add 
label define label_xf2e125 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e125 30 "Not applicable", add 
label define label_xf2e125 31 "Institution left item blank", add 
label define label_xf2e125 32 "Do not know", add 
label define label_xf2e125 33 "Particular 1st prof field not applicable", add 
label define label_xf2e125 50 "Outlier value derived from reported data", add 
label define label_xf2e125 51 "Outlier value derived from imported data", add 
label define label_xf2e125 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e125 53 "Value not derived - data not usable", add 
label values xf2e125 label_xf2e125
label define label_xf2e126 10 "Reported" 
label define label_xf2e126 11 "Analyst corrected reported value", add 
label define label_xf2e126 12 "Data generated from other data values", add 
label define label_xf2e126 13 "Implied zero", add 
label define label_xf2e126 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e126 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e126 22 "Imputed using the Group Median procedure", add 
label define label_xf2e126 23 "Logical imputation", add 
label define label_xf2e126 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e126 30 "Not applicable", add 
label define label_xf2e126 31 "Institution left item blank", add 
label define label_xf2e126 32 "Do not know", add 
label define label_xf2e126 33 "Particular 1st prof field not applicable", add 
label define label_xf2e126 50 "Outlier value derived from reported data", add 
label define label_xf2e126 51 "Outlier value derived from imported data", add 
label define label_xf2e126 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e126 53 "Value not derived - data not usable", add 
label values xf2e126 label_xf2e126
label define label_xf2e127 10 "Reported" 
label define label_xf2e127 11 "Analyst corrected reported value", add 
label define label_xf2e127 12 "Data generated from other data values", add 
label define label_xf2e127 13 "Implied zero", add 
label define label_xf2e127 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e127 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e127 22 "Imputed using the Group Median procedure", add 
label define label_xf2e127 23 "Logical imputation", add 
label define label_xf2e127 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e127 30 "Not applicable", add 
label define label_xf2e127 31 "Institution left item blank", add 
label define label_xf2e127 32 "Do not know", add 
label define label_xf2e127 33 "Particular 1st prof field not applicable", add 
label define label_xf2e127 50 "Outlier value derived from reported data", add 
label define label_xf2e127 51 "Outlier value derived from imported data", add 
label define label_xf2e127 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e127 53 "Value not derived - data not usable", add 
label values xf2e127 label_xf2e127
label define label_xf2e131 10 "Reported" 
label define label_xf2e131 11 "Analyst corrected reported value", add 
label define label_xf2e131 12 "Data generated from other data values", add 
label define label_xf2e131 13 "Implied zero", add 
label define label_xf2e131 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e131 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e131 22 "Imputed using the Group Median procedure", add 
label define label_xf2e131 23 "Logical imputation", add 
label define label_xf2e131 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e131 30 "Not applicable", add 
label define label_xf2e131 31 "Institution left item blank", add 
label define label_xf2e131 32 "Do not know", add 
label define label_xf2e131 33 "Particular 1st prof field not applicable", add 
label define label_xf2e131 50 "Outlier value derived from reported data", add 
label define label_xf2e131 51 "Outlier value derived from imported data", add 
label define label_xf2e131 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e131 53 "Value not derived - data not usable", add 
label values xf2e131 label_xf2e131
label define label_xf2e132 10 "Reported" 
label define label_xf2e132 11 "Analyst corrected reported value", add 
label define label_xf2e132 12 "Data generated from other data values", add 
label define label_xf2e132 13 "Implied zero", add 
label define label_xf2e132 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e132 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e132 22 "Imputed using the Group Median procedure", add 
label define label_xf2e132 23 "Logical imputation", add 
label define label_xf2e132 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e132 30 "Not applicable", add 
label define label_xf2e132 31 "Institution left item blank", add 
label define label_xf2e132 32 "Do not know", add 
label define label_xf2e132 33 "Particular 1st prof field not applicable", add 
label define label_xf2e132 50 "Outlier value derived from reported data", add 
label define label_xf2e132 51 "Outlier value derived from imported data", add 
label define label_xf2e132 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e132 53 "Value not derived - data not usable", add 
label values xf2e132 label_xf2e132
label define label_xf2e133 10 "Reported" 
label define label_xf2e133 11 "Analyst corrected reported value", add 
label define label_xf2e133 12 "Data generated from other data values", add 
label define label_xf2e133 13 "Implied zero", add 
label define label_xf2e133 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e133 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e133 22 "Imputed using the Group Median procedure", add 
label define label_xf2e133 23 "Logical imputation", add 
label define label_xf2e133 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e133 30 "Not applicable", add 
label define label_xf2e133 31 "Institution left item blank", add 
label define label_xf2e133 32 "Do not know", add 
label define label_xf2e133 33 "Particular 1st prof field not applicable", add 
label define label_xf2e133 50 "Outlier value derived from reported data", add 
label define label_xf2e133 51 "Outlier value derived from imported data", add 
label define label_xf2e133 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e133 53 "Value not derived - data not usable", add 
label values xf2e133 label_xf2e133
label define label_xf2e134 10 "Reported" 
label define label_xf2e134 11 "Analyst corrected reported value", add 
label define label_xf2e134 12 "Data generated from other data values", add 
label define label_xf2e134 13 "Implied zero", add 
label define label_xf2e134 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e134 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e134 22 "Imputed using the Group Median procedure", add 
label define label_xf2e134 23 "Logical imputation", add 
label define label_xf2e134 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e134 30 "Not applicable", add 
label define label_xf2e134 31 "Institution left item blank", add 
label define label_xf2e134 32 "Do not know", add 
label define label_xf2e134 33 "Particular 1st prof field not applicable", add 
label define label_xf2e134 50 "Outlier value derived from reported data", add 
label define label_xf2e134 51 "Outlier value derived from imported data", add 
label define label_xf2e134 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e134 53 "Value not derived - data not usable", add 
label values xf2e134 label_xf2e134
label define label_xf2e135 10 "Reported" 
label define label_xf2e135 11 "Analyst corrected reported value", add 
label define label_xf2e135 12 "Data generated from other data values", add 
label define label_xf2e135 13 "Implied zero", add 
label define label_xf2e135 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e135 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e135 22 "Imputed using the Group Median procedure", add 
label define label_xf2e135 23 "Logical imputation", add 
label define label_xf2e135 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e135 30 "Not applicable", add 
label define label_xf2e135 31 "Institution left item blank", add 
label define label_xf2e135 32 "Do not know", add 
label define label_xf2e135 33 "Particular 1st prof field not applicable", add 
label define label_xf2e135 50 "Outlier value derived from reported data", add 
label define label_xf2e135 51 "Outlier value derived from imported data", add 
label define label_xf2e135 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e135 53 "Value not derived - data not usable", add 
label values xf2e135 label_xf2e135
label define label_xf2e136 10 "Reported" 
label define label_xf2e136 11 "Analyst corrected reported value", add 
label define label_xf2e136 12 "Data generated from other data values", add 
label define label_xf2e136 13 "Implied zero", add 
label define label_xf2e136 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e136 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e136 22 "Imputed using the Group Median procedure", add 
label define label_xf2e136 23 "Logical imputation", add 
label define label_xf2e136 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e136 30 "Not applicable", add 
label define label_xf2e136 31 "Institution left item blank", add 
label define label_xf2e136 32 "Do not know", add 
label define label_xf2e136 33 "Particular 1st prof field not applicable", add 
label define label_xf2e136 50 "Outlier value derived from reported data", add 
label define label_xf2e136 51 "Outlier value derived from imported data", add 
label define label_xf2e136 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e136 53 "Value not derived - data not usable", add 
label values xf2e136 label_xf2e136
label define label_xf2e137 10 "Reported" 
label define label_xf2e137 11 "Analyst corrected reported value", add 
label define label_xf2e137 12 "Data generated from other data values", add 
label define label_xf2e137 13 "Implied zero", add 
label define label_xf2e137 20 "Imputed using Carry Forward procedure", add 
label define label_xf2e137 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2e137 22 "Imputed using the Group Median procedure", add 
label define label_xf2e137 23 "Logical imputation", add 
label define label_xf2e137 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2e137 30 "Not applicable", add 
label define label_xf2e137 31 "Institution left item blank", add 
label define label_xf2e137 32 "Do not know", add 
label define label_xf2e137 33 "Particular 1st prof field not applicable", add 
label define label_xf2e137 50 "Outlier value derived from reported data", add 
label define label_xf2e137 51 "Outlier value derived from imported data", add 
label define label_xf2e137 52 "Value not derived - parent/child differs across components", add 
label define label_xf2e137 53 "Value not derived - data not usable", add 
label values xf2e137 label_xf2e137
label define label_xf2h01 10 "Reported" 
label define label_xf2h01 11 "Analyst corrected reported value", add 
label define label_xf2h01 12 "Data generated from other data values", add 
label define label_xf2h01 13 "Implied zero", add 
label define label_xf2h01 20 "Imputed using Carry Forward procedure", add 
label define label_xf2h01 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2h01 22 "Imputed using the Group Median procedure", add 
label define label_xf2h01 23 "Logical imputation", add 
label define label_xf2h01 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2h01 30 "Not applicable", add 
label define label_xf2h01 31 "Institution left item blank", add 
label define label_xf2h01 32 "Do not know", add 
label define label_xf2h01 33 "Particular 1st prof field not applicable", add 
label define label_xf2h01 50 "Outlier value derived from reported data", add 
label define label_xf2h01 51 "Outlier value derived from imported data", add 
label define label_xf2h01 52 "Value not derived - parent/child differs across components", add 
label define label_xf2h01 53 "Value not derived - data not usable", add 
label values xf2h01 label_xf2h01
label define label_xf2h02 10 "Reported" 
label define label_xf2h02 11 "Analyst corrected reported value", add 
label define label_xf2h02 12 "Data generated from other data values", add 
label define label_xf2h02 13 "Implied zero", add 
label define label_xf2h02 20 "Imputed using Carry Forward procedure", add 
label define label_xf2h02 21 "Imputed using Nearest Neighbor procedure", add 
label define label_xf2h02 22 "Imputed using the Group Median procedure", add 
label define label_xf2h02 23 "Logical imputation", add 
label define label_xf2h02 24 "Ratio adjustment base on enrollment by race/gender in part A", add 
label define label_xf2h02 30 "Not applicable", add 
label define label_xf2h02 31 "Institution left item blank", add 
label define label_xf2h02 32 "Do not know", add 
label define label_xf2h02 33 "Particular 1st prof field not applicable", add 
label define label_xf2h02 50 "Outlier value derived from reported data", add 
label define label_xf2h02 51 "Outlier value derived from imported data", add 
label define label_xf2h02 52 "Value not derived - parent/child differs across components", add 
label define label_xf2h02 53 "Value not derived - data not usable", add 
label values xf2h02 label_xf2h02
label define label_f2fha 1 "Yes - (report endowment assets)" 
label define label_f2fha 2 "No", add 
label values f2fha label_f2fha
tab xf2a01
tab xf2a02
tab xf2a03
tab xf2a03a
tab xf2a04
tab xf2a05
tab xf2a05a
tab xf2a05b
tab xf2a06
tab xf2a11
tab xf2a12
tab xf2a13
tab xf2a14
tab xf2a15
tab xf2a16
tab xf2a17
tab xf2a18
tab xf2a19
tab xf2a20
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
tab xf2d012
tab xf2d013
tab xf2d014
tab xf2d02
tab xf2d022
tab xf2d023
tab xf2d024
tab xf2d03
tab xf2d032
tab xf2d033
tab xf2d034
tab xf2d04
tab xf2d042
tab xf2d043
tab xf2d044
tab xf2d05
tab xf2d052
tab xf2d053
tab xf2d054
tab xf2d06
tab xf2d062
tab xf2d063
tab xf2d064
tab xf2d07
tab xf2d072
tab xf2d073
tab xf2d074
tab xf2d08
tab xf2d082
tab xf2d083
tab xf2d084
tab xf2d08a
tab xf2d082a
tab xf2d083a
tab xf2d084a
tab xf2d08b
tab xf2d082b
tab xf2d083b
tab xf2d084b
tab xf2d09
tab xf2d092
tab xf2d093
tab xf2d094
tab xf2d10
tab xf2d102
tab xf2d103
tab xf2d104
tab xf2d11
tab xf2d112
tab xf2d12
tab xf2d122
tab xf2d13
tab xf2d132
tab xf2d14
tab xf2d142
tab xf2d143
tab xf2d144
tab xf2d15
tab xf2d152
tab xf2d153
tab xf2d154
tab xf2d16
tab xf2d162
tab xf2d163
tab xf2d164
tab xf2d172
tab xf2d173
tab xf2d182
tab xf2d183
tab xf2d184
tab xf2e011
tab xf2e012
tab xf2e013
tab xf2e014
tab xf2e015
tab xf2e016
tab xf2e017
tab xf2e021
tab xf2e022
tab xf2e023
tab xf2e024
tab xf2e025
tab xf2e026
tab xf2e027
tab xf2e031
tab xf2e032
tab xf2e033
tab xf2e034
tab xf2e035
tab xf2e036
tab xf2e037
tab xf2e041
tab xf2e042
tab xf2e043
tab xf2e044
tab xf2e045
tab xf2e046
tab xf2e047
tab xf2e051
tab xf2e052
tab xf2e053
tab xf2e054
tab xf2e055
tab xf2e056
tab xf2e057
tab xf2e061
tab xf2e062
tab xf2e063
tab xf2e064
tab xf2e065
tab xf2e066
tab xf2e067
tab xf2e071
tab xf2e072
tab xf2e073
tab xf2e074
tab xf2e075
tab xf2e076
tab xf2e077
tab xf2e081
tab xf2e082
tab xf2e083
tab xf2e084
tab xf2e085
tab xf2e086
tab xf2e087
tab xf2e091
tab xf2e092
tab xf2e093
tab xf2e094
tab xf2e095
tab xf2e096
tab xf2e097
tab xf2e101
tab xf2e102
tab xf2e103
tab xf2e104
tab xf2e105
tab xf2e106
tab xf2e107
tab xf2e111
tab xf2e112
tab xf2e113
tab xf2e114
tab xf2e115
tab xf2e116
tab xf2e117
tab xf2e121
tab xf2e122
tab xf2e123
tab xf2e124
tab xf2e125
tab xf2e126
tab xf2e127
tab xf2e131
tab xf2e132
tab xf2e133
tab xf2e134
tab xf2e135
tab xf2e136
tab xf2e137
tab xf2h01
tab xf2h02
tab f2fha
summarize f2a01
summarize f2a02
summarize f2a03
summarize f2a03a
summarize f2a04
summarize f2a05
summarize f2a05a
summarize f2a05b
summarize f2a06
summarize f2a11
summarize f2a12
summarize f2a13
summarize f2a14
summarize f2a15
summarize f2a16
summarize f2a17
summarize f2a18
summarize f2a19
summarize f2a20
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
summarize f2d012
summarize f2d013
summarize f2d014
summarize f2d02
summarize f2d022
summarize f2d023
summarize f2d024
summarize f2d03
summarize f2d032
summarize f2d033
summarize f2d034
summarize f2d04
summarize f2d042
summarize f2d043
summarize f2d044
summarize f2d05
summarize f2d052
summarize f2d053
summarize f2d054
summarize f2d06
summarize f2d062
summarize f2d063
summarize f2d064
summarize f2d07
summarize f2d072
summarize f2d073
summarize f2d074
summarize f2d08
summarize f2d082
summarize f2d083
summarize f2d084
summarize f2d08a
summarize f2d082a
summarize f2d083a
summarize f2d084a
summarize f2d08b
summarize f2d082b
summarize f2d083b
summarize f2d084b
summarize f2d09
summarize f2d092
summarize f2d093
summarize f2d094
summarize f2d10
summarize f2d102
summarize f2d103
summarize f2d104
summarize f2d11
summarize f2d112
summarize f2d12
summarize f2d122
summarize f2d13
summarize f2d132
summarize f2d14
summarize f2d142
summarize f2d143
summarize f2d144
summarize f2d15
summarize f2d152
summarize f2d153
summarize f2d154
summarize f2d16
summarize f2d162
summarize f2d163
summarize f2d164
summarize f2d172
summarize f2d173
summarize f2d182
summarize f2d183
summarize f2d184
summarize f2e011
summarize f2e012
summarize f2e013
summarize f2e014
summarize f2e015
summarize f2e016
summarize f2e017
summarize f2e021
summarize f2e022
summarize f2e023
summarize f2e024
summarize f2e025
summarize f2e026
summarize f2e027
summarize f2e031
summarize f2e032
summarize f2e033
summarize f2e034
summarize f2e035
summarize f2e036
summarize f2e037
summarize f2e041
summarize f2e042
summarize f2e043
summarize f2e044
summarize f2e045
summarize f2e046
summarize f2e047
summarize f2e051
summarize f2e052
summarize f2e053
summarize f2e054
summarize f2e055
summarize f2e056
summarize f2e057
summarize f2e061
summarize f2e062
summarize f2e063
summarize f2e064
summarize f2e065
summarize f2e066
summarize f2e067
summarize f2e071
summarize f2e072
summarize f2e073
summarize f2e074
summarize f2e075
summarize f2e076
summarize f2e077
summarize f2e081
summarize f2e082
summarize f2e083
summarize f2e084
summarize f2e085
summarize f2e086
summarize f2e087
summarize f2e091
summarize f2e092
summarize f2e093
summarize f2e094
summarize f2e095
summarize f2e096
summarize f2e097
summarize f2e101
summarize f2e102
summarize f2e103
summarize f2e104
summarize f2e105
summarize f2e106
summarize f2e107
summarize f2e111
summarize f2e112
summarize f2e113
summarize f2e114
summarize f2e115
summarize f2e116
summarize f2e117
summarize f2e121
summarize f2e122
summarize f2e123
summarize f2e124
summarize f2e125
summarize f2e126
summarize f2e127
summarize f2e131
summarize f2e132
summarize f2e133
summarize f2e134
summarize f2e135
summarize f2e136
summarize f2e137
summarize f2h01
summarize f2h02
save dct_f0708_f2

