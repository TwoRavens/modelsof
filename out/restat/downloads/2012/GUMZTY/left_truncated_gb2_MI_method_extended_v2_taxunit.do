*This program runs the MI-GB2 procedure for years since 1968.  In order to change the program and include all years,
* rather than just the years prior to 1975, simply change refernces to 1975 to 2008;

#delimit;
set more off;

*Oct 29 revision: This revision will separate the MI Process into 4 steps to let us run it piece by piece;
*April 8 revision: This revision allows us to run the GB2 process for tax-units
*April 15: cumulative shares doesn't work when there are percentiles with 0 share.  So using alternate method.
*July 12: extend to include years from 1968 to 1974;
*July 15: Set the imputation so all in household receive the same income, fix problem with missing people from h`i'==1;

clear;
set mem 1400m;
set matsize 500;
global data = "/rdcprojects/co1/co00524/data/data_out/";
global tempdat = "/rdcprojects/co1/co00524/data/data_out/Temporary_data";
global savepoint = "/rdcprojects/co1/co00524/jeffwork/pgb2_output/left_tr_gb2";
global GB2estimates = "/rdcprojects/co1/co00524/jeffwork/MI_GB2/GB2_estimates";
global output = "/rdcprojects/co1/co00524/jeffwork/MI_GB2/Release_output";
sysdir set PERSONAL "/rdcprojects/co1/co00524/statacode/";


************************************************************************************************;
* STEP 1b: Define matrices for GB2 estimable values. These are Ginis, P90/P10, and the GE(2), ;
* with their respective standard errors. I also include in here the mean and variance with the ;
* the standard error, plus the samples sizes for all and those that are less than one after the ;
* household summation of personal income. ;
capture program drop matrix_gb2_stats;
program define matrix_gb2_stats;
   matrix `1'=J(41,12,.);
   matrix colnames `1'= GB2_Gini SE_Gini  Mean SE_mean Var SE_var 
                        p90p10   SE_p9010 ge_2 SE_ge_2 N   N_zero ;
   matrix rownames `1'= $rows;
end;
************************************************************************************************;

************************************************************************************************;
* STEP 1c: Define matrices for quantiles for a Q-Q plot. This means all quantiles that are;
* produced by a "sum, detail" command or by the "gb2lfit" command are written into a matrix. ;
* This matrix will be a little large, but that should not matter much. Note that the ;
* matrix is "transposed" compared to the other ones - we are not interested in each ;
* quantile over the years, but rather how each year's quantile distribution looks like. ;
capture program drop matrix_ptiles;
program define matrix_ptiles;
   matrix `1'=J(99,41,.);
   matrix rownames `1'= p01 p02 p03 p04 p05 p06 p07 p08 p09 p10 
                        p11 p12 p13 p14 p15 p16 p17 p18 p19 p20
                        p21 p22 p23 p24 p25 p26 p27 p28 p29 p30 
                        p31 p32 p33 p34 p35 p36 p37 p38 p39 p40
                        p41 p42 p43 p44 p45 p46 p47 p48 p49 p50
                        p51 p52 p53 p54 p55 p56 p57 p58 p59 p60
                        p61 p62 p63 p64 p65 p66 p67 p68 p69 p70                        
                        p71 p72 p73 p74 p75 p76 p77 p78 p79 p80
                        p81 p82 p83 p84 p85 p86 p87 p88 p89 p90
                        p91 p92 p93 p94 p95 p96 p97 p98 p99 ;
   matrix colnames `1'= $rows;
end;
************************************************************************************************;

************************************************************************************************;
* STEP 1d: Define matrices for the GB2 parameters and their standard errors. We need for each ;
* estimation the paramter values (a,b,p,q), their standard error, and the samples size. ;
capture program drop matrix_gb2_param;
program define matrix_gb2_param;
   matrix `1'=J(41,9,.);
   matrix colnames `1'= a se_a b se_b p se_p q se_q N;
   matrix rownames `1'= $rows;
end;
************************************************************************************************;

************************************************************************************************;
* STEP 1e: Define matrices for the Entropy parameters and their standard errors.;
capture program drop matrix_ent_param;
program define matrix_ent_param;
   matrix `1'=J(41,8,.);
   matrix colnames `1'= GEm1 se_GEm1 GE0 se_GE0 GE1 se_GE1 GE2 se_GE2;
   matrix rownames `1'= $rows;
end;
************************************************************************************************;

************************************************************************************************;
* STEP 1g: Define program that does the GB2 Gini estimation for public and internal ;
* regular data. It needs similar things than the program in 1f: 1) the income variable ;
* that is to be used, 2) the respective censoring variable, 3) the matrix that should ;
* contain the estimated Gini values, and the other inequality measures we can directly ;
* compute, 4) the matrix that has the parameter estimates from the GB2, and 5) the data ;
* source. Note that the setup is with all values set to one if <= 1. ;

***PART A OF THE MI-GB2 PROCESS - CALCULATE THE GB2 ESTIMATES AND SAVE TO DISK;

capture program drop rungb2gini;
program define rungb2gini;
syntax [namelist];   
   local incvar:   word 1 of `namelist';
   local censor:   word 2 of `namelist';
   local matgini:  word 3 of `namelist';
   local matent:   word 4 of `namelist';
   local matparm:  word 5 of `namelist';
   local matptile: word 6 of `namelist';
   local dataset:  word 7 of `namelist';
 
   tempvar settoone;

   * get datasource;
   if "`dataset'"=="public" {;
      use "$data/temp_pub.dta", clear;
   };   
   if "`dataset'"=="intern" {;
      use "$data/temp_int.dta", clear;
   };
   if "`dataset'"=="taxunit" {;
      use "$data/int_PS_comparison_working.dta", clear;
      *for simplicity in matching code (to match what I did before for the HH), renaming fwgt as pwgt and the subfam/hhseq as h_id;
      rename fwgt pwgt;
      rename subfamid h_id;
   };   
   if "`dataset'"~="public" & "`dataset'"~="intern" & "`dataset'"~="taxunit" {;
      noisily display in red "not a valid dataset";
      exit;
   };   

   forvalues yr=1968/2008 {;
      preserve;
         local j=`yr'-1967;
         keep if year==`yr' & pwgt>0 & pwgt<.;
          * set the value to one if <=1;
         gen     settoone = `incvar';
         replace settoone = 1 if `incvar' < 1;
         count;
         * household size adjustment and size reduction;
         if "`dataset'"!="taxunit" {;
            replace settoone = settoone/(sqrt(hhsize)*10000);
         }   ;
    
         * keep only necessary variables ;
         keep settoone `censor' pwgt h_id year;
         _pctile settoone [aw=pwgt], p(30);
         gen xp30 = r(r1);
         local p30 = r(r1);

         * set into survey data mode...;
         version 8: svyset [pw=pwgt], psu(h_id);            

         * I am estimating the GB2 with previous year's parameters as starting points, ;
         * as this may speed the estimation up and help if there is no convergence. ;
         if `yr' == 1968 {;
            *Start with 1976 result since I have that from before;
            estimates use "$GB2estimates/gb2_`dataset'_1976.ster";
               matrix LAST_EST = e(b);
            noisily gb2lfit settoone [aw=pwgt], 
               censvar(`censor') lefttr(xp30) tech(bhhh 5 nr 5) difficult from(LAST_EST)
               nrtolerance(3.5e-5) cluster(h_id);
               matrix LAST_EST = e(b);
            estimates save "$GB2estimates/gb2_`dataset'_`yr'", replace;
            * pgb2lt settoone, lefttr(`p30') saving("$savepoint/pgb2_`dataset'_`yr'", replace) 
                 xtitle("Emperical CDF") ytitle("GB2 CDF");
         };
         if `yr' > 1968 & `yr'<=1975 {;
            noisily gb2lfit settoone, 
               censvar(`censor') lefttr(xp30) tech(bhhh 5 nr 5) difficult from(LAST_EST)
               nrtolerance(3.5e-5) cluster(h_id);
               matrix LAST_EST = e(b);
            estimates save "$GB2estimates/gb2_`dataset'_`yr'", replace;
            * pgb2lt settoone, lefttr(`p30') saving("$savepoint/pgb2_`dataset'_`yr'", replace) 
                 xtitle("Emperical CDF") ytitle("GB2 CDF");
         };
         if `yr' >= 1976 {;
            *To speed process, use GB2 parameters from earlier runs for years since 1976;
            estimates use "$GB2estimates/gb2_`dataset'_1976.ster";
            matrix LAST_EST = e(b);
            noisily gb2lfit settoone, 
               censvar(`censor') lefttr(xp30) tech(bhhh 5 nr 5) difficult from(LAST_EST)
               nrtolerance(3.5e-5) cluster(h_id);
               matrix LAST_EST = e(b);
            estimates save "$GB2estimates/gb2_`dataset'_`yr'", replace;
            * pgb2lt settoone, lefttr(`p30') saving("$savepoint/pgb2_`dataset'_`yr'", replace) 
                 xtitle("Emperical CDF") ytitle("GB2 CDF");
         };

      restore;
   };
end;
* program rungb2gini;       

* PART B OF THE PROCESS: CREATING THE MULTIPLE-IMPUTED DATATSETS FOR EACH YEAR;

capture program drop create_MI_datasets;
program define create_MI_datasets;
syntax [namelist];   
   local incvar:   word 1 of `namelist';
   local censor:   word 2 of `namelist';
   local dataset:  word 3 of `namelist';

quietly {;

   forvalues yr=1968/2008 {;

      * get datasource;
      if "`dataset'"=="public" {;
         use $data/temp_pub.dta, clear;
      };   
      if "`dataset'"=="intern" {;
         use $data/temp_int.dta, clear;
      };   
      if "`dataset'"=="taxunit" {;
      use "$data/int_PS_comparison_working.dta", clear;
      *for simplicity in matching code (to match what I did before for the HH), renaming fwgt as pwgt and the subfam/hhseq as h_id;
      rename fwgt pwgt;
      rename subfamid h_id;
      };   
      if "`dataset'"~="public" & "`dataset'"~="intern" & "`dataset'"~="taxunit" {;
         noisily display in red "not a valid dataset";
         exit;
      };   

         *Create settoone variable again (this becomes Z later in the program);
         keep if year==`yr' & pwgt>0 & pwgt<.;
          * set the value to one if <=1;
         gen     settoone = `incvar';
         replace settoone = 1 if `incvar' < 1;
         count;
         * household size adjustment and size reduction;
         if "`dataset'"!="taxunit" {; 
            replace settoone = settoone/(sqrt(hhsize)*10000);
         };

         * keep only necessary variables ;
         keep settoone `censor' pwgt h_id year;
         compress;

         * Use the estimates that were saved from rungb2gini program;
         estimates use "$GB2estimates/gb2_`dataset'_`yr'";         
     
         sort h_id, stable;
         gen obsid = _n;

         local a = e(ba);
         local b = e(bb);
         local p = e(bp);
         local q = e(bq);
   
         *Making copying Stephen's code easier by renaming settoone to match his variable, z;
         gen z = settoone;
   
         gen Falpha = ibeta(`p',`q',(z/`b')^`a'/(1+(z/`b')^`a'));
      
         set seed xxxxx;
     
         *This line sets the number of imputations.  There are other places that it will;
         *change later on as well.;
         local imps 100;
         local imps1 = `imps'+1;
   
         forval i = 1/`imps' {; 
            gen z`i' = z;
            gen double h`i' = (uniform()*(1-Falpha)+Falpha) if `censor'==1;
            replace z`i' = `b'*(invibeta(`p',`q',h`i')/(1-invibeta(`p',`q',h`i')))^(1/`a') if `censor'==1;
            replace z`i' = `b'*(0.9999999999999999/(1-0.9999999999999999))^(1/`a') if `censor'==1 & z`i'==.;
            noi sum z`i' if `censor'==1; *check if means are indeed above the top-code value;
         };
   
         gen mean = .;
         gen gini = .;
         gen gem1 = .;
         gen ge0 = .;
         gen ge1 = .;
         gen ge2 = .;
                  
         forval i = 1/`imps' {;
            sum z`i' [aw=pwgt], meanonly;
            replace mean = r(mean) in `i';
            ineqdeco z`i';
       
            replace gini = r(gini) in `i';
            replace gem1 = r(gem1) in `i';
            replace ge0 = r(ge0) in `i';
            replace ge1 = r(ge1) in `i';
            replace ge2 = r(ge2) in `i';
         };
      
         sum mean, meanonly;
         replace mean = r(mean) in `imps1';
         sum gini, meanonly;
         replace gini = r(mean) in `imps1';
         sum gem1, meanonly;
         replace gem1 = r(mean) in `imps1';
         sum ge0, meanonly;
         replace ge0 = r(mean) in `imps1';
         sum ge1, meanonly;
         replace ge1 = r(mean) in `imps1';
         sum ge2, meanonly;
         replace ge2 = r(mean) in `imps1';
         
         noi disp "`yr'";
                  
         save "$tempdat/`dataset'_junk", replace;
      
         forval i = 1/`imps' {;
            use "$tempdat/`dataset'_junk", clear;
            keep obsid h_id pwgt year z`i';
            rename z`i' z;
            gen byte mi = `i';
            save "$tempdat/`dataset'_mi_`i'", replace;
         };
         
         *mi_`imps' is left in memory;
         
         forval i = 1/`=`imps'-1' {;
            append using $tempdat/`dataset'_mi_`i';
         };
      
         sort mi h_id;
         de, de;
         su;
         save "$tempdat/`dataset'_mi`yr'",replace;

         ***I don't think I need this line since I don't think we use current estimates because they are from the individual files, but just in case ...;
         estimates save "$tempdat/New_estimates/junk_estimates_`dataset'_`yr'", replace;
      
         forval i = 1/`imps' {;
           capture erase "$tempdat/`dataset'_mi_`i'";
         };
      
         capture erase "$tempdat/`dataset'_junk.dta";
   }; 
};
end;
   
capture program drop same_hinc;
program define same_hinc;
syntax [namelist];
local ds:  word 1 of `namelist';
quietly {;
   forvalues yr=1968/2008 {;
#delimit;
      use "$tempdat/`dataset'_mi`yr'",clear;
      sort year mi h_id, stable;
      by year mi h_id: gen perid = _n;
      bysort year mi h_id (perid): replace z = z[1];
      save "$tempdat/`dataset'_mi`yr'",replace;
   };
};
end;



* STEP C - COMBINING ESTIMATES FROM MI DATESETS;
***Combining estimates from multiple imputed datasets;


capture program drop mi_quickshares;
program define mi_quickshares;
syntax [namelist];   
local ds:   word 1 of `namelist';

local imps = 100;

matrix smallshares=J(10,41,.);
matrix colnames smallshares = $rows;
matrix rownames smallshares = p90 p91 p92 p93 p94 p95 p96 p97 p98 p99;

noi disp "enterring forvalues loop";

forvalues year=1968/2008 {;
   local k = `year'-1967;
   use "$tempdat/`ds'_mi`year'", clear;

   local m = `imps';
   local yr = `year';

   *Code currently assumes 100 groups;
   local groups = 100;

   forvalues i = 1/`m' {;
      preserve;
      keep if mi==`i';
      
      quietly sumdist z [aw=pwgt], ngp(`groups');

      tempname R`i';
      matrix `R`i'' = (r(sh91), r(sh92), r(sh93), r(sh94), r(sh95), r(sh96), r(sh97), r(sh98), r(sh99), r(sh100))';

      if `i'==1 {;
         tempname R;
         matrix `R'= (r(sh91), r(sh92), r(sh93), r(sh94), r(sh95), r(sh96), r(sh97), r(sh98), r(sh99), r(sh100))';
      };
      else {;
         matrix `R' = `R' + (r(sh91), r(sh92), r(sh93), r(sh94), r(sh95), r(sh96), r(sh97), r(sh98), r(sh99), r(sh100))';
      };
      restore;
   noisily display in gr _continue ".";
   };

   matrix `R' = `R'/`m';
  
   tempname Q;
   matrix `Q' = J(10,1,.);
   matrix `Q'[10,1] = `R'[10,1];
   forvalues j = 1/9 {;
      local m = 10 - `j';
      local l = 11 - `j';
         
      matrix `Q'[`m',1] = `Q'[`l',1] + `R'[`m',1];
   };
  
   forvalues j = 1/10 {;
     matrix smallshares[`j',`k']=`Q'[`j',1];
   };
     
   noi disp "Cumulative Shares by income percentile for `ds' in `yr'";
   matrix list `Q';
   
};
   matrix list smallshares;
end;


capture program drop mi_ge;
program define mi_ge, eclass;
syntax [namelist];   
   local ds:   word 1 of `namelist';
   
   tempname W Q B T QQ TR;
   
   local m = $m;
   local yr = $yr;

   forvalues i = 1/`m' {;

      *To speed the process, I am keeping only values with the current value of mi;
      preserve;
      keep if mi==`i';

      qui svygei z if mi ==`i';

      estimates save "$tempdat/`ds'/GE`yr'_`i'", replace;
      estout using $tempdat/`ds'/GE`yr'_`i'.txt, replace cells("b(fmt(%20.15f)) se(fmt(%20.15f))");
      mat est = e(est);
      mat var = e(V);

      * Save to ASCII file, the estimated measures and their std error for each imputed data set;
      * File includes surve year, imputation dataset id, index name, estimate, std error;
      file open output using $tempdat/`ds'/GE`yr'_`i'.out, write replace;
      file write output "`yr'" _col(6) "`i'" _col(10) "GEm1" _col(15) %20.15f (est[1,1]) _col(46) %20.15f (sqrt(var[1,1])) _n;
      file write output "`yr'" _col(6) "`i'" _col(10) "GE0"  _col(15) %20.15f (est[1,2]) _col(46) %20.15f (sqrt(var[2,2])) _n;
      file write output "`yr'" _col(6) "`i'" _col(10) "GE1"  _col(15) %20.15f (est[1,3]) _col(46) %20.15f (sqrt(var[3,3])) _n;     
      file write output "`yr'" _col(6) "`i'" _col(10) "GE2"  _col(15) %20.15f (est[1,4]) _col(46) %20.15f (sqrt(var[4,4])) _n;
      file close output;

      tempname Q`i';
      matrix `Q`i''=e(est);
      if `i'==1 {;
         matrix `Q'=e(est);
         matrix `W'=e(V);  
      };
      else {;
         matrix `Q'=`Q' + e(est);
         matrix `W'=`W' + e(V);  
      };

      restore;
   };
   
   matrix `Q' = `Q'/`m';
   matrix `W' = `W'/`m';
   local k = colsof(`Q');
   matrix `B'=J(`k',`k',0);

   forvalues i=1/`m' {;
      estimates use $tempdat/`ds'/GE`yr'_`i';
      mat est = e(est);
      mat var = e(V);
      eret repost b = est V = var;
      estimates save $tempdat/`ds'/GE`yr'_`i', replace;

      matrix `QQ'=`Q`i''-`Q';
      if `i'==1 {;
         matrix `B'=`QQ''*`QQ';
      };
      else matrix `B'=`B'+`QQ''*`QQ';
   };
   matrix `B'=`B'/(`m'-1);
 
   matrix `TR'=`W'+`B'/`m'; *Estimated VCE matrix - REITER FORMULA;
   
   ereturn post `Q' `TR';
   ereturn local cmd "mi_ge";

   /*;
   c1   GE(-1);
   c2   MLD = GE(0);
   c3   Theil = GE(1);
   c4   GE(2);
   c5   GE(3);
   */;

   ereturn display;
   
   *Save the combined GE estimates;
   estimates save $output/`ds'/GE`yr'_all, replace;
   estimates store GE`yr'_all;

   estimates table GE`yr'_all, b(%20.15f) se(%20.15f);

   estout GE`yr'_all using $output/`ds'/GE`yr'_all.txt, replace cells("b(fmt(%20.15f)) se(fmt(%20.15f))");

   di " ";
   di "This is the .txt ascii file version produced by -estout-";
   di " ";
   type $output/`ds'/GE`yr'_all.txt;

   mat est = e(b);
   mat var = e(V);

   file open output0 using $output/`ds'/GE`yr'_all.out, write replace;
   file write output0 "`yr'" _col(7) "GEm1" _col(13) %20.15f (est[1,1]) _col(35) %20.15f (sqrt(var[1,1])) _n;
   file write output0 "`yr'" _col(7) "GE0"  _col(13) %20.15f (est[1,2]) _col(35) %20.15f (sqrt(var[2,2])) _n;
   file write output0 "`yr'" _col(7) "GE1"  _col(13) %20.15f (est[1,3]) _col(35) %20.15f (sqrt(var[3,3])) _n;
   file write output0 "`yr'" _col(7) "GE2"  _col(13) %20.15f (est[1,4]) _col(35) %20.15f (sqrt(var[4,4])) _n;
   file close output0;

   di " ";
   di "This is the .out ascii file version";
   di " ";
   type $output/`ds'/GE`yr'_all.out;

   noi matrix list e(b);
   noi matrix list e(V);
   
end;

capture program drop mi_lorenz;
program define mi_lorenz, eclass;
syntax [namelist];   
   local ds:   word 1 of `namelist';

   tempname W Q B T QQ TR;
   tempname GW GQ GB GT GQQ GTR;
   
   local m = $m;
   local yr = $yr;

   *Code currently assumes 2 groups to make sure the program runs (use the programs in the MI-GB2 folder for 20 groups);
   local groups = 2;
   local k = `groups' - 1;

   forvalues i = 1/`m' {;

      *To speed the process, I am keeping only values with the current value of mi;
      preserve;
      keep if mi==`i';

      quietly svylorenz z if mi==`i', ngp(`groups');
      estimates save $tempdat/`ds'/lorenz`yr'_`i', replace;

      * save to ascii file the estimated measures and their std error for each imput. data set;
      estout using $tempdat/`ds'/lorenz`yr'_`i'.txt, replace cells("b(fmt(%20.15f)) se(fmt(%20.15f))");

      file open output2 using $tempdat/`ds'/lorenz`yr'_`i'.out, write replace;
      forvalues j = 1/`k' {;
         local J = 5*`j';
         file write output2 "`yr'" _col(6) "`i'" _col(10) "cush`J'" _col(18) %20.15f (e(cush`j')) 
                            _col(48) %20.15f (e(se_cush`j')) _n;
      };
      file close output2;

      file open output3 using $tempdat/`ds'/gini`yr'_`i'.out, write replace;
      file write output3 "`yr'" "`i'" "Gini" _col(5) %20.15f (e(gini)) _col(35) %20.15f (e(se_gini)) _n;
      file close output3;

      tempname Q`i' GQ`i';
      matrix `GQ`i''=(e(gini));
      if `i'==1 {;
         matrix `GQ'=(e(gini));
         matrix `GW'=(e(se_gini))^2;
      };
      else {;
         matrix `GQ'=`GQ'+(e(gini));
         matrix `GW'=`GW'+(e(se_gini))^2;
      };

      restore;
   };
   
   *GINI section;

   matrix `GQ'=`GQ'/`m';
   matrix `GW'=`GW'/`m';
   local k = colsof(`GQ');
   matrix `GB'=J(`k',`k',0);
   
   forvalues i=1/`m' {;
      matrix `GQQ' = `GQ`i''-`GQ';
      if `i'==1 {;
         matrix `GB'=`GQQ''*`GQQ';
      };
      else matrix `GB'=`GB'+`GQQ''*`GQQ';
   };
   matrix `GB'=`GB'/(`m'-1);
   
   matrix `GTR'=`GW'+`GB'/`m';
   
   ereturn post `GQ' `GTR';
   
   noi disp "Gini `yr':";
   noi ereturn display;  *THIS IS THE GINI;
   
   eret local cmd "mi_gini";

   *Save the combined Gini estimates;

   estimates save $output/`ds'/gini`yr'_all, replace;
   estimates store gini`yr'_all;

   estimates table gini`yr'_all, b(%20.15f) se(%20.15f);

   estout gini`yr'_all using $output/`ds'/gini`yr'_all.txt, replace cells("b(fmt(%20.15f)) se(fmt(%20.15f))");

   di " ";
   di "This is the .txt ascii file varsion produced by -estout-";
   di " ";
   type $output/`ds'/gini`yr'_all.txt;

   mat est = e(b);
   mat var = e(V);

   file open output5 using $output/`ds'/gini`yr'_all.out, write replace;
   file write output5 "`yr'" _col(7) "Gini" _col(13) %20.15f (est[1,1]) _col(35) %20.15f (sqrt(var[1,1])) _n;
   file close output5;

   di " ";
   di "This is the .out ascii file version";
   di " ";
   type $output/`ds'/gini`yr'_all.out;

   noisily matrix list e(b);
   noisily matrix list e(V);
end;

capture program drop combine_MI_datasets;
program define combine_MI_datasets;
syntax [namelist];   
   local incvar:   word 1 of `namelist';
   local censor:   word 2 of `namelist';
   local dataset:  word 3 of `namelist';
   local imps = 100;

   forvalues year=1968/2008 {;
      global yr = `year';
      use "$tempdat/`dataset'_mi`year'", clear;

      capture file close _all;
      version 8: svyset [pw=pwgt], psu(h_id);
      global m `imps';

      *Run the mi_ge program above;
      *mi_ge `dataset'; 

      version 9: svyset h_id[pw=pwgt];

      *Run the mi_lorenz program above;
      mi_lorenz `dataset';   
   };
end;

************************************************************************************************;

************************************************************************************************;
* DONE with program defining;
************************************************************************************************;

************************************************************************************************;

* STEP 2a: Get data into shape;

log using /rdcprojects/co1/co00524/inequality/inequality_estimate_all_no_groupq.log, replace;

***********;
* CREATE THE FILES THAT WILL BE MERGED INTO THE MAIN FILES;
***********;

insheet using "/rdcprojects/co1/co00524/data/data_out/int_hhmatch.txt", clear;
gen groupq = 0;
replace groupq = 1 if year<88 & hhtype==2;
replace groupq = 1 if year>=88 & year<94 & htype==9;
replace groupq = 1 if year>=94 & (hrhtype==9 | hrhtype==10);
rename hhseq h_id;
replace year = year+1900;
keep year h_id groupq;
sort year h_id;
compress;
save $data/hhmatch_groupq.dta, replace;

use "/rdcprojects/co1/co00524/data/public_weights.dta", clear;
drop h_id;
rename hhseq h_id;
replace year = year + 1900;
save "$data/public_weights_merge.dta", replace;

insheet using "/rdcprojects/co1/co00524/data/data_out/early_hh.txt", clear;
gen groupq = 0;
replace groupq = 1 if year<74 & hhtype==4;
replace groupq = 1 if year>=74 & year<=75 & hhtype==2;
rename hhseq h_id;
replace year = year + 1900;
keep year h_id groupq;
sort year h_id;
compress;
append using $data/hhmatch_groupq.dta;
save $data/hhmatch_groupq.dta, replace;

********;
* FORMAT THE INTERNAL REGULAR DATA
********;

insheet using "/rdcprojects/co1/co00524/data/data_out/int_tax.txt", clear ;
save "$data/int_ps_comparison_working_shares_tax_and_reg.dta", replace ;
sort year hhseq;
by   year hhseq: gen  hhsize=_N;
by   year hhseq: egen hinc_reg=sum(iinc_reg);
by   year hhseq: egen hdum_reg=sum(idum_reg);
replace hdum_reg=1 if hdum_reg>1 & hdum_reg<.;
rename hhseq h_id;
gen military = 0;
replace military = 1 if pstat == 2;
replace h_id = h_id-300000 if year>=1988;
keep year pwgt h_id hhsize hinc_reg hdum_reg military perid;
sort year h_id;
compress; 
save $data/temp_int.dta, replace;

joinby year h_id perid using "$data/public_weights_merge.dta", unmatched(master);
drop _merge;
replace pwgt = wgt if year>=2005 & wgt!=.;
drop wgt;

joinby year h_id using "$data/hhmatch_groupq.dta", unmatched(master);
sort year h_id;
by   year h_id: egen mil_hh=sum(military);
replace mil_hh=1 if mil_hh>1 & mil_hh!=.;
keep year pwgt h_id hhsize hinc_reg hdum_reg groupq mil_hh;
compress;
keep if groupq==0 & mil_hh==0;

save $data/temp_int.dta, replace;

/*
*need to pull back the military information into the HH file to use for public data;
keep year h_id mil_hh groupq;
collapse mil_hh groupq, by(year h_id);
sort year h_id;
compress;
save $data/hhmatch_groupq.dta, replace;

insheet using "/rdcprojects/co1/co00524/data/data_out/pub_all.txt", clear;
#delimit;
rename hhseq h_id;
sort year h_id;
by   year h_id: gen  hhsize=_N;
by   year h_id: egen hinc_reg=sum(pinc_reg);
by   year h_id: egen hdum_reg=sum(pdum_reg);
replace hdum_ctc=1 if hdum_ctc>1 & hdum_ctc<.;
replace hdum_reg=1 if hdum_reg>1 & hdum_reg<.;
keep year pwgt h_id hhsize hinc_ctc hdum_ctc hinc_reg hdum_reg;
replace h_id = h_id-300000 if year>=1988;
sort year h_id;
compress; 
save $data/temp_pub.dta, replace;

joinby year h_id using "$data/hhmatch_groupq.dta", unmatched(master);
sort year h_id;
keep year pwgt h_id hhsize hinc_reg hdum_reg hinc_ncm groupq mil_hh;
compress;
save $data/temp_pub.dta, replace;

* The datasets now need to have individuals who are in the military or work in group quarters removed;
use $data/temp_pub.dta, clear;
count if groupq!=0;
count if mil_hh!=0;
count if groupq!=0 | mil_hh!=0;
keep if groupq==0 & mil_hh==0;
save $data/temp_pub.dta, replace;

*** END OF COMMENTING OUT THE PUBLIC PORTION ***;
*/;

use $data/temp_int.dta, clear;
keep if groupq==0 & mil_hh==0;
save $data/temp_int.dta, replace;

* we now have two identical datasets in terms of their variables - so it only ;
* depends on which dataset we call, the variables do not matter ;

********;
* FORMAT THE TAX-UNIT UNADJUSTED INTERNAL DATA FILE;
********;
/*;
*Already did insheet above using the same dataset;
*insheet using "/rdcprojects/co1/co00524/data/data_out/int_tax.txt", clear ;
use "$data/int_ps_comparison_working_shares_tax_and_reg.dta", clear;
sort year hhseq ;
rename hhseq h_id ;
gen military = 0 ;
replace military = 1 if pstat == 2 ;
replace h_id = h_id-300000 if year>=1988 ;
sort year h_id ;
compress  ;
save $data/int_ps_comparison_working_shares.dta, replace ;

*Join the current public weights for years after 2005 ;
joinby year h_id perid using "$data/public_weights_merge.dta", unmatched(master) ;
drop _merge ;
replace pwgt = wgt if year>=2005 & wgt!=. ;
drop wgt ;

*Drop group quarters and military ;
joinby year h_id using "$data/hhmatch_groupq.dta", unmatched(master) ;
sort year h_id ;
by   year h_id: egen mil_hh=sum(military) ;
replace mil_hh=1 if mil_hh>1 & mil_hh!=. ;
keep if groupq==0 & mil_hh==0 ;
rename h_id hhseq ;
compress ;
save $data/int_ps_comparison_working_shares.dta, replace ;

*Pull the family weights - which are the weight of the family reference person ;
sort year hhseq sfid ;
by year hhseq sfid: egen famhead = min(perid) ;
by year hhseq sfid: gen famsize = _N ;
gen temp = pwgt if perid==famhead ;
by year hhseq sfid: egen fwgt = max(temp) ;
drop temp   ;


rename sfid2 subfam;

*Assign adult children to their own subfamily if not a reference person or spouse of family ;
* note that spouse isn't present or else would be own subfamily with spouse already;
* note that 1974-1987 people in primary family have no famrel, only hhrel so need a separate line to capture;
* children/other relatives in the primary family;
replace subfam = perid + 12 if age>=20 & ((famrel>=3 & famrel<=24) | (famrel>=27 & famrel<=31)) & year<=1973;
replace subfam = perid + 12 if age>=20 & (hhrel==4 | hhrel==5) & famtype==0 & year>=1974 & year<=1987  ;
replace subfam = perid + 12 if age>=20 & (famrel==3 | famrel==4) & year>=1974 & year<=1987 ;
replace subfam = perid      if age>=20 & (famrel==3 | famrel==4) & year>=1988 ;

*Assign ever-married children to their own subfamily IF not reference person or spouse of family (i.e. are child or other ;
*relative) ... note that spouse isn't present or else would be own subfamily with spouse already;
replace subfam = perid + 12 if age<=19 & married>=2 & married<=7 & ((famrel>=3 & famrel<=24) | (famrel>=27 & famrel<=31))    & year<=1973;
replace subfam = perid + 12 if age<=19 & married<8 & (hhrel==4 | hhrel==5)   & famtype==0 & year>=1974 & year<=1987  ;
replace subfam = perid + 12 if age<=19 & married<8 & (famrel==3 | famrel==4) & year>=1974 & year<=1987 ;
replace subfam = perid      if age<=19 & married<7 & (famrel==3 | famrel==4) & year>=1988 ;

*Calculate age of oldest subfamily member ;
sort year hhseq subfam ;
by year hhseq subfam: egen maxage = max(age) ;

*Determine if anybody is ever-married in the subfamily ;
gen temp = 0 ;
replace temp = 1 if (year<=1973 & married>=2) | (year>=1974 & year<=1987 & married<=7) | (year>=1988 & married<=6) ;
by year hhseq subfam: egen anymarried = max(temp) ;
drop temp ;

/* ;
* OPTION 1 ;
*Drop if there are no ever-married individuals or single individuals over 20 in the subfamily ;
drop if anymarried==0 & maxage<=19 ;

*OPTION 2 (since can't keep income from under-19 year olds in option 1) ;
*Drop if max age under 15, which is the minimum age to record income in the CPS ;
drop if maxage<15 ;
*/ ;

*OPTION 3 (split difference between option 1 and option 2): ;
*Assign individuals in unmarried, under-19 headed subfamilies to the primary family in the household ;
*In cases of no primary family, assign to family of oldest individual in household ;
*Individuals under 15 who live alone are dropped.  Those 15 and older are kept as own subfamily ;
sort year hhseq perid ;
by year hhseq: egen maxhhage = max(age) ;
replace subfam = 1 if anymarried==0 & maxage<=19 & maxhhage>19 ;
sort year hhseq subfam ;
by year hhseq subfam: egen maxage2 = max(age) ;

gen oldest = 1 if age==maxhhage ;
by year hhseq: egen temp = sum(oldest) ;
sort year hhseq oldest ;
by year hhseq oldest: egen temp2 = min(perid); 
replace oldest = 0 if temp>1 & perid!=temp2 ;
gen temp3 = 0 ;
replace temp3 = subfam if oldest==1 ;
by year hhseq: egen oldestsubfam = max(temp3)   ;
replace subfam = oldestsubfam if anymarried==0 & maxage2<=19 & maxhhage>19 ;
drop temp temp2 temp3 ;

sort year hhseq subfam  ;
by year hhseq subfam: gen sfsize = _N ;

*Adjust for the fact that I am breaking up families as originally weighted - so divide the weights to the new ;
*subfamilies based on the size of their respective families ;
replace fwgt = fwgt * sfsize/famsize if sfsize<=famsize  ;

*Drop if under 14 since can't have income ;
drop if age<14 & iinc_tax==0 ;

gen subfamid = hhseq*100 + subfam ;

sort year hhseq subfam ;

by year hhseq subfam: egen finc = sum(iinc_tax);
by year hhseq subfam: egen finc_tc = sum(idum_tax);
replace finc_tc = 1 if finc_tc>=1;

replace finc = 1 if finc<=0;

*collapse to the subfamily;
collapse (mean) fwgt finc finc_tc subfamid, by(year hhseq subfam);

save "/rdcprojects/co1/co00524/data/data_out/int_PS_comparison_working", replace;
*/;
************************************************************************************************;
* FROM HERE ON ARE THE STATS!  ;

* Now define several matrices that contain the results of the estimations. ;
global rows = "1967 1968 1969 1970 1971 1972 1973 1974
               1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 
               1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 
               2005 2006 2007";

*matrix_gb2_stats GINI_PGB2;
matrix_gb2_stats GINI_IGB2;
matrix_gb2_stats GINI_TUGB2;

*matrix_gb2_param PARA_PGB2;
matrix_gb2_param PARA_IGB2;
matrix_gb2_param PARA_TUGB2;

*matrix_ent_param ENT_PGB2;
matrix_ent_param ENT_IGB2;
matrix_ent_param ENT_TUGB2;

*matrix_ptiles PCT_PGB2; 
matrix_ptiles PCT_IGB2; 
matrix_ptiles PCT_TUGB2; 

* Run the GB2 Ginis;
*rungb2gini hinc_ncm hdum_reg GINI_PGB2  ENT_PGB2  PARA_PGB2  PCT_PGB2  public;
*rungb2gini hinc_reg hdum_reg GINI_IGB2  ENT_IGB2  PARA_IGB2  PCT_IGB2  intern;
*rungb2gini finc     finc_tc  GINI_TUGB2 ENT_TUGB2 PARA_TUGB2 PCT_TUGB2 taxunit;

* Create the Multiply Imputed Data sets;
*create_MI_datasets hinc_ncm hdum_reg public;
*create_MI_datasets hinc_reg hdum_reg intern;
create_MI_datasets  finc     finc_tc  taxunit;

* Fix the internal and public Multiply Imputed Data sets so that all imputed individuals in a HH have the same income;
* Note this isn't necessary for tax-units since only 1 obs per tax-unit;
*same_hinc public;
*same_hinc intern;

* Combine the Multiply Imputed Data sets;
*combine_MI_datasets hinc_ncm hdum_reg public;
*combine_MI_datasets hinc_reg hdum_reg intern;
combine_MI_datasets  finc     finc_tc  taxunit;

* Combine the Multiply Imputed Data sets to create detailed share information;
*mi_quickshares public;
*mi_quickshares intern;
mi_quickshares  taxunit;




* That's it ;