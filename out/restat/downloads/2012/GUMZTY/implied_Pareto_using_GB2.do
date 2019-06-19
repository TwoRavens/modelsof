*This program calculates the implied Pareto coefficients from the MI-GB2 procedure for years since 1968. 
*It uses the previously created MI-Datasets from the MI-GB2 programs.

#delimit;
clear;
clear matrix;
set more off;

*March 10 revision: initial version;

clear;
set mem 1400m;
set matsize 500;
global data = "/rdcprojects/co1/co00524/data/data_out/";
global tempdat = "/rdcprojects/co1/co00524/data/data_out/Temporary_data";
global savepoint = "/rdcprojects/co1/co00524/jeffwork/pgb2_output/left_tr_gb2";
global GB2estimates = "/rdcprojects/co1/co00524/jeffwork/MI_GB2/GB2_estimates";
global output = "/rdcprojects/co1/co00524/jeffwork/MI_GB2/Release_output";
sysdir set PERSONAL "/rdcprojects/co1/co00524/statacode/";

********************************************************************************************;

* STEP C - COMBINING ESTIMATES FROM MI DATESETS;
***Combining estimates from multiple imputed datasets;


capture program drop mi_implied_pareto;
program define mi_implied_pareto;
syntax [namelist];   
local ds:   word 1 of `namelist';

local imps = 100;

matrix beta=J(3,41,.);
matrix colnames beta = $rows;
matrix rownames beta = p90 p95 p99;

noi disp "enterring forvalues loop";
quietly {;
forvalues year=1968/2008 {;
   local k = `year'-1967;
   use "$tempdat/`ds'_mi`year'", clear;

   local m = `imps';
   local yr = `year';

   forvalues i = 1/`m' {;
      preserve;
      keep if mi==`i';
      
      quietly summarize z [aw=pwgt], de;

      local p90 = r(p90);
      local p95 = r(p95);
      local p99 = r(p99);

      summarize z [aw=pwgt] if z>=`p90', meanonly;
      local b90 = r(mean)/`p90';

      summarize z [aw=pwgt] if z>=`p95', meanonly;
      local b95 = r(mean)/`p95';

      summarize z [aw=pwgt] if z>=`p99', meanonly;
      local b99 = r(mean)/`p99';
      
      *noisily display in gr "b90 = `b90', b95 = `b95', b99 = `b99'";
      
      if `i'==1 {;
         tempname B;
         matrix `B'= (`b90', `b95', `b99')';
      };
      else {;
         matrix `B' = `B' + (`b90', `b95', `b99')';
      };
      restore;
      *noi disp in gr _continue ".";
   };

   matrix `B' = `B'/`m';
  
   forvalues j = 1/3 {;
     matrix beta[`j',`k']=`B'[`j',1];
   };
     
   noi disp in red "implied Pareto b coefficients in `yr'";
   matrix list `B';
   
};
};
   matrix list beta;
end;


************************************************************************************************;
* DONE with program defining;
************************************************************************************************;

************************************************************************************************;
************************************************************************************************;
* FROM HERE ON ARE THE STATS!  ;

* Now define several matrices that contain the results of the estimations. ;
global rows = "1967 1968 1969 1970 1971 1972 1973 1974
               1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 
               1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 
               2005 2006 2007";

* Find the implied Pareto b parameters;
mi_implied_pareto taxunit;
mi_implied_pareto intern;

* That's it ;