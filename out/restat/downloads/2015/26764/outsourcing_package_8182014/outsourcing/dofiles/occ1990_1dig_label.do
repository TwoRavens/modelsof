
*******************************
*Label variable occ1990_1dig
*******************************

/* Aggregate the Chinese occupations categories from 46 categories into 17, in order to match with occ1990dd */
/* Only 14 categories left: C1&C3 are aggregated into B2; D2 is aggregated into D1*/
  
#delimit;  
label define occ1990_1dig_label
      1 "Executive, Administrative, and Managerial Occupations"
      2 "Management Related Occupations"
      3 "Professional Specialty Occupations"
      4 "Technicians and Related Support Occupations"
      5 "Sales Occupations"
      6 "Administrative Support Occupations"
      8 "Protective Service Occupations"
      9 "Other Service Occupations"
      10 "Farm Operators and Managers"
      12 "Mechanics and Repairers"
      13 "Construction Trades"
      14 "Extractive Occupations"
      15 "Precision Production Occupations"
      16 "Machine Operators, Assemblers, and Inspectors"
      17 "Transportation and Material Moving Occupations"
;
label var occ1990_1dig occ1990_1dig_label ;
#delimit cr;
