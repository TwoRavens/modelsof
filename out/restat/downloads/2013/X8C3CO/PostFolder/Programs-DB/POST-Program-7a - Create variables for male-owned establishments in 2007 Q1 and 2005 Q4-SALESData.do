/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/

/****************************************************************************/
/* This program merges public and private-owned estab, women-owned estab, 
   and public-owned estab into one file by age & size and year & quarter. 

   Then it creates male-owned establishment variables. */
/****************************************************************************/

#delimit ; 
clear;
set mem 3000m;
set matsize 800;
set more off;
capture log close;
set trace off;

/****************************************************************************/
/* DEFINE THE PATH TO ENTREPRENEUR FOLDER                                   */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************/
/*SEND OUTPUT TO THE LOG FILE                                               */
/****************************************************************************/

log using `path'\Results\DB_Program7a.log, replace; 


/**********************************************************************************************/
/* Loop through different types of datasets (s)
     1) tract-level vars (2007Q1 for LHS vars in Arrival Regs and Segregation indexes,
                            - includes new (< 12 months) & small (< 10 emp) estab
                            - created in Program 3)                           
     2) 1-mile ring vars + tract-level vars (2007Q1 for Summary Stats 
                                               - includes all ages & sizes estab
                                               - created in Program 6)
     3) 1-mile ring vars + tract-level vars (2005Q4 for RHS in Regs 
                                               - includes all ages & sizes estab
                                               - created in Program 6)
     4) 1-mile ring vars + tract-level vars (2005Q4 for RHS in Regs 
                                               - includes all ages & small (< 10 emp) estab
                                               - created in Program 6)
     5) 1-mile ring vars + tract-level vars (2005Q4 for RHS in Regs 
                                               - includes all ages & large (>= 10 emp) estab
                                               - created in Program 6) 
     6) 5-mile ring vars + tract-level vars (2007Q1 for Summary Stats 
                                               - includes all ages & sizes estab
                                               - created in Program 6)
     7) 5-mile ring vars + tract-level vars (2005Q4 for RHS in Regs 
                                               - includes all ages & sizes estab
                                               - created in Program 6)
     8) 5-mile ring vars + tract-level vars (2005Q4 for RHS in Regs 
                                               - includes all ages & small (< 10 emp) estab
                                               - created in Program 6)
     9) 5-mile ring vars + tract-level vars (2005Q4 for RHS in Regs 
                                               - includes all ages & large (>= 10 emp) estab
                                               - created in Program 6) 
*/
/**********************************************************************************************/
local s = 1;
  while `s' <= 6 {;

display "";
display "*************** Group `s' *******************";
display "";

if `s' == 1 {;                             /* tract-level datasets are created in Program 3 */
   local var       ownnew;
   local all      `path'\Temp\Tract_level_1yearold_9lessEstSize_allusa_pubandpriv_07Q1;   /*All Public- and Private-Owned Enterprises*/
   local female   `path'\Temp\Tract_level_1yearold_9lessEstSize_allusa_priv_women_07Q1;   /*Private Women-Owned Enterprises*/
   local public   `path'\Temp\Tract_level_1yearold_9lessEstSize_allusa_pub_07Q1;          /*Publicly-Owned Enterprises*/
   local savefile `path'\Temp\1yearold_9lessEstSize_allusa_07Q1_w-Male.dta;
};

                                           /* ring-level datasets are created in Program 6 */
if `s' == 2 {;                             /* 2007 Q1 - all ages and sizes */
   local size      _;
   local time      07Q1;
   local ring      1;
};

if `s' == 3 {;                             /* 2007 Q1 - all ages and very small (1 emp) */
   local size      _1EstSize_;
   local time      07Q1;
   local ring      1;
};

if `s' == 4 {;                             /* 2005 Q4 - all ages and sizes */
   local size      _;
   local time      05Q4;
   local ring      1;
};

if `s' == 5 {;                             /* 2005 Q4 - all ages and small (< 10 emp) */
   local size      _9lessEstSize_;
   local time      05Q4;
   local ring      1;
};

if `s' == 6 {;                             /* 2005 Q4 - all ages and large (>= 10 emp) */
   local size      _10moreEstSize_;
   local time      05Q4;
   local ring      1;
};

if `s' == 7 {;                             /* 2007 Q1 - all ages and sizes */
   local size      _;
   local time      07Q1;
   local ring      5;
};

if `s' == 8 {;                             /* 2007 Q1 - all ages and very small (1 emp)*/
   local size      _1EstSize_;
   local time      07Q1;
   local ring      5;
};

if `s' == 9 {;                             /* 2005 Q4 - all ages and sizes */
   local size      _;
   local time      05Q4;
   local ring      5;
};

if `s' == 10 {;                            /* 2005 Q4 - all ages and small (< 10 emp) */
   local size      _9lessEstSize_;
   local time      05Q4;
   local ring      5;
};

if `s' == 11 {;                            /* 2005 Q4 - all ages and large (>= 10 emp) */
   local size      _10moreEstSize_;
   local time      05Q4;
   local ring      5;
};

if `s' == 12 {;                             /* 2007 Q1 - all ages and sizes */
   local size      _;
   local time      07Q1;
   local ring      10;
};

if `s' == 13 {;                             /* 2007 Q1 - all ages and very small (1 emp)*/
   local size      _1EstSize_;
   local time      07Q1;
   local ring      10;
};

if `s' == 14 {;                             /* 2005 Q4 - all ages and sizes */
   local size      _;
   local time      05Q4;
   local ring      10;
};

if `s' == 15 {;                            /* 2005 Q4 - all ages and small (< 10 emp) */
   local size      _9lessEstSize_;
   local time      05Q4;
   local ring      10;
};

if `s' == 16 {;                            /* 2005 Q4 - all ages and large (>= 10 emp) */
   local size      _10moreEstSize_;
   local time      05Q4;
   local ring      10;
};

/****************************************************************************/
/*Set macro for the file name prefixes for datasets s > 1 that include 
  ring-level variables*/
/****************************************************************************/

if `s' == 3 | `s' == 8  | `s' == 13{;                                                          /*Ring-Level Data for Very Small*/
   local var       own;
   local all      `path'\Temp\Rings_allyear`size'allusa_priv_`time'_r`ring'_All-Indus;         /*All Private-Owned Enterprises*/
   local female   `path'\Temp\Rings_allyear`size'allusa_priv_women_`time'_r`ring'_All-Indus;   /*Private Women-Owned Enterprises*/
   local savefile `path'\Temp\Rings_allyear`size'allusa_`time'_r`ring'_w-Male.dta;
};

if `s' ~= 1 & `s' ~= 3 & `s' ~= 8 & `s' ~= 13 {;                                               /*Ring-Level Data for NOT Very Small*/
   local var       own;
   local all      `path'\Temp\Rings_allyear`size'allusa_pubandpriv_`time'_r`ring'_All-Indus;   /*All Public and Private-Owned Enterprises*/
   local female   `path'\Temp\Rings_allyear`size'allusa_priv_women_`time'_r`ring'_All-Indus;   /*Private Women-Owned Enterprises*/
   local public   `path'\Temp\Rings_allyear`size'allusa_pub_`time'_r`ring'_All-Indus;          /*Publicly-Owned Enterprises*/
   local savefile `path'\Temp\Rings_allyear`size'allusa_`time'_r`ring'_w-Male.dta;
};

/****************************************************************************/
/****************************************************************************/
/* Read in and merge by census tract and sic2 code the tract-level data from
   file 1 above for each file "type," female-owned, publicly-owned, and
   public+private owned.

   In order to merge these files we must first add a suffix to the common variable
   names.

   For the datasets including ring-level variables (i.e., s >= 2), 
   renaming has already been done at Program 6 where SIC 0 data were converted 
   to the allemp and allfirm vars. 
*/
/****************************************************************************/
/****************************************************************************/

/* Read in female-owned estab 
   (and add _f suffix only if it includes tract-level vars only (i.e., s = 1))
*/
/****************************************************************************/
use `female'.dta, clear;

if `s' == 1 {;        
   ren `var'firm `var'firm_f;       
   ren `var'emp  `var'emp_f;
};


/* Merge publicly-owned estab (and add _b suffix only for s = 1)*/
/****************************************************************************/
if `s' ~= 3 & `s' ~= 8 & `s' ~= 13 {;
sort geo2000 sic2code;
merge geo2000 sic2code using `public'.dta;
  tab _merge;
  drop _merge;
};

if `s' == 1 {;            
   ren `var'firm `var'firm_b;       
   ren `var'emp  `var'emp_b;
};


/* Merge public+private owned estab and do not add a suffix*/
/****************************************************************************/
sort geo2000 sic2code;             
merge geo2000 sic2code using `all'.dta; 
  tab _merge;
  drop _merge;

/****************************************************************************/
/****************************************************************************/


/****************************************************************************/
/* Keep only relevant 2-digit industries                                    */
/****************************************************************************/
keep if sic2code >= 20 & sic2code <= 39 |  sic2code == 50 | sic2code == 51 |
        sic2code >= 60 & sic2code <= 67 |  sic2code == 73 | sic2code == 80 | 
        sic2code == 81 | sic2code == 86 |  sic2code == 87 | sic2code == 89 |
        sic2code == 0;

/****************************************************************************/
/* Create a balanced Panel with an observation for every tract 
   and the retained industries.                                             */
/****************************************************************************/
capture drop _fillin;
capture drop if sic2code == 0;

fillin geo2000 sic2code;
  tab _fillin;
  drop _fillin;

/****************************************************************************/
/* Convert missing values into zeros                                        */
/****************************************************************************/
                                                           /* TRACT-LEVEL VARIABLES */
   replace `var'firm   = 0 if `var'firm   == .;            /* Both publicly and privately-owned establishments */
   replace `var'emp    = 0 if `var'emp    == .;            
   replace `var'firm_f = 0 if `var'firm_f == .;            /* Private female-owned establishments */
   replace `var'emp_f  = 0 if `var'emp_f  == .;      
   if `s' == 3 | `s' == 8 | `s' == 13 {;
     gen `var'firm_b = 0;                                  /* Publicly-owned establishments -- VERY SMALL (1 emp) */
     gen `var'emp_b  = 0;
   };
   replace `var'firm_b = 0 if `var'firm_b == .;            /* Publicly-owned establishments */
   replace `var'emp_b  = 0 if `var'emp_b  == .;     

if `s' >= 2 {;                                             /* RING-LEVEL VARIABLES*/
   replace ownfirm`ring'   = 0 if ownfirm`ring'   == .;    /* Both publicly and privately-owned establishments */
   replace ownemp`ring'    = 0 if ownemp`ring'    == .;        
   replace allemp`ring'    = 0 if allemp`ring'    == .;
   replace ownfirm_f`ring' = 0 if ownfirm_f`ring' == .;    /* Private female-owned establishments */
   replace ownemp_f`ring'  = 0 if ownemp_f`ring'  == .;           
   replace allemp_f`ring'  = 0 if allemp_f`ring'  == .;
   if `s' == 3 | `s' == 8 | `s' == 13 {;
     gen ownfirm_b`ring' = 0;                              /* Publicly-owned establishments -- Very Small (1 emp) */
     gen ownemp_b`ring'  = 0;
     gen allemp_b`ring'  = 0;
   };
   replace ownfirm_b`ring' = 0 if ownfirm_b`ring' == .;    /* Publicly-owned establishments -- Not Very Small */
   replace ownemp_b`ring'  = 0 if ownemp_b`ring'  == .;
   replace allemp_b`ring'  = 0 if allemp_b`ring'  == .;
};

/****************************************************************************/
/* Create male variables by subtracting female and public from public+private.
   Then convert any missing values into zeros although there shouldn't be
   any missing values at this point given the code above.                   */
/****************************************************************************/
    gen `var'firm_m = `var'firm - `var'firm_f - `var'firm_b;                    /* TRACT-LEVEL VARIABLES */
    gen `var'emp_m  = `var'emp  - `var'emp_f  - `var'emp_b;
    replace `var'firm_m = 0 if `var'firm_m == .;     
    replace `var'emp_m  = 0 if `var'emp_m  == .;

if `s' >= 2 {;                                                                  /* RING-LEVEL VARIABLES */
    gen ownfirm_m`ring' = ownfirm`ring' - ownfirm_f`ring' - ownfirm_b`ring';      
    gen ownemp_m`ring'  = ownemp`ring'  - ownemp_f`ring'  - ownemp_b`ring';
    gen allemp_m`ring'  = allemp`ring'  - allemp_f`ring'  - allemp_b`ring';
    replace ownfirm_m`ring' = 0 if ownfirm_m`ring'  == .;    
    replace ownemp_m`ring'  = 0 if ownemp_m`ring'   == .;
    replace allemp_m`ring'  = 0 if allemp_m`ring'   == .;
};

/****************************************************************************/
/* Create variables for all privately-owned establishments 
   by subtracting variables for publicly-owned establishments 
   from variables for publicly and privately-owned establishments           */
/****************************************************************************/
    gen `var'firm_pv = `var'firm - `var'firm_b;                                 /* TRACT-LEVEL VARIABLES */
    gen `var'emp_pv  = `var'emp  - `var'emp_b;
    replace `var'firm_pv = 0 if `var'firm_pv == .;    
    replace `var'emp_pv  = 0 if `var'emp_pv  == .; 

if `s' >= 2 {;                                                                  /* RING-LEVEL VARIABLES*/
    gen ownfirm_pv`ring' = ownfirm`ring' - ownfirm_b`ring';      
    gen ownemp_pv`ring'  = ownemp`ring'  - ownemp_b`ring';
    gen allemp_pv`ring'  = allemp`ring'  - allemp_b`ring';
    replace ownfirm_pv`ring' = 0 if ownfirm_pv`ring' == .;    
    replace ownemp_pv`ring'  = 0 if ownemp_pv`ring'  == .;
    replace allemp_pv`ring'  = 0 if allemp_pv`ring'  == .;
};

/****************************************************************************/
/* Save to the Temp folder                                                  */
/****************************************************************************/
save `savefile', replace;

/****************************************************************************/
/* Go to the next loop                                                      */
/****************************************************************************/
local s = `s' + 1;     /* Advance the loop to the next datafiles */
};

log close;

