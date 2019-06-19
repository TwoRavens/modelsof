
/* Aggregate the occupations categories from several hundred categories to 17, based on occ1990dd_table.pdf */

  gen occ1990_1dig=.
*A1: Executive, Administrative, and Managerial Occupations*
  replace occ1990_1dig= 1 if occ1990dd>=4 &occ1990dd<=22
*A2: Management Related Occupations *
  replace occ1990_1dig= 2 if occ1990dd>=23 &occ1990dd<= 37
*A3: Professional Specialty Occupations *
  replace occ1990_1dig= 3 if occ1990dd>=43 &occ1990dd<=199
*B1: Technicians and Related Support Occupations *
  replace occ1990_1dig= 4 if occ1990dd>=203 &occ1990dd<=235
*B2: Sales Occupations *
  replace occ1990_1dig= 5 if occ1990dd>=243 &occ1990dd<=283
*B3: Administrative Support Occupations *
  replace occ1990_1dig= 6 if occ1990dd>=303 &occ1990dd<=389
*C1: Housekeeping and Cleaning Occupations *
  replace occ1990_1dig= 7 if occ1990dd>=405 &occ1990dd<=408
*C2: Protective Service Occupations *
  replace occ1990_1dig= 8 if occ1990dd>=415 &occ1990dd<=427
*C3: Other Service Occupations *
  replace occ1990_1dig= 9 if occ1990dd>=433 &occ1990dd<=472
*D1: Farm Operators and Managers *
  replace occ1990_1dig= 10 if occ1990dd>=473 &occ1990dd<=475
*D2: Other Agricultural and Related Occupations*
  replace occ1990_1dig= 11 if occ1990dd>= 479 &occ1990dd<= 498
*E1: Mechanics and Repairers *
  replace occ1990_1dig= 12 if occ1990dd>= 503 &occ1990dd<=549
*E2:Construction Trades*
  replace occ1990_1dig= 13 if occ1990dd>=558 &occ1990dd<=599
*E3: Extractive Occupations *
  replace occ1990_1dig= 14 if occ1990dd>=614 &occ1990dd<=617
*E4: Precision Production Occupations *
  replace occ1990_1dig= 15 if occ1990dd>=628 &occ1990dd<=699
*F1: Machine Operators, Assemblers, and Inspectors*
  replace occ1990_1dig= 16 if occ1990dd>= 703 &occ1990dd<=799
*F2: Transportation and Material Moving Occupations *
  replace occ1990_1dig= 17 if occ1990dd>=803 &occ1990dd<=889

*** Incorporate changes CC made, dropping to 14 categories ***
  /* Only 14 categories left: C1&C3 are aggregated into B2; D2 is aggregated into D1*/
  replace occ1990_1dig=5 if occ1990_1dig==5 | occ1990_1dig==7 | occ1990_1dig==9
  replace occ1990_1dig=10 if occ1990_1dig==10 | occ1990_1dig ==11
