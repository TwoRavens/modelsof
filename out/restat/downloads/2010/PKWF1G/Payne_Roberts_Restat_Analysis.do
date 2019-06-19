cap log close
cap drop _all
mata: mata clear
set memory 300m
set mat 500

#delimit ;
cd k:/snail/research/Old_retired/joanne/final_revision_2008;

log using Payne_Roberts_Restat_Analysis.log, replace;
tempfile t1 t2 t3 t4;
global univreg "facx facx2 grd grden grdli ";
global state "pop popsq pcinc pcincsq gspag gsphlth govdem studr stldr";

*********************;
******  Table 1 ******;
**********************;

use payne_roberts_table1, clear;
	gen y=yr if pfnd==1; egen ny=min(y), by(ustate); egen xy=max(y), by(ustate);
		gen by=yr if pbud==1; egen nby=min(by), by(ustate); egen xby=max(by), by(ustate);
                   label var ny "1st yr perf fund"; label var xy "most recent yr perf fund";
                   label var nby "1st Yr perf budg"; label var xby "most recent yr perf budg";
	gen yy=min(ny, nby);
	bysort ustate: keep if _n==1;
		sort yy ustate;
		list ustate ny xy nby xby;


*********************;
*** Table 2;
*********************;
use payne_roberts_table23, clear;
xtset gfice yr;
   *****************  Summary Statistics for depedendent variable ******************;
          *** total research expenditures (col 1);
                  sum rest;
              ** by type of institution;
                    tab fship, sum(rest);
          ** by discipline type ;
               sort fship;  by fship: sum  resten restli restph restss if state_chg==1;

  ****************   Regressions -- column 1 -- all institutions... column 2 -- only those institutions that
                     adopt a public funding scheme over sample period;
      tab yr, gen(dy);
     ***** column 1;
           xtreg rest perf2 $univreg $state dy*, i(gfice) cluster(ustate)  fe;
keep if state_chg==1;
     **** column 2;
           xtreg rest perf2 $univreg $state dy*, i(gfice) cluster(ustate)  fe;
     **** column 3-7 regressions by type of discipline;
           foreach var of varlist rest resten restli restph restss  {;
		xtreg `var' perf2f perf2nf $univreg $state dy*, i(gfice) cluster(ustate)  fe;
			test perf2f=perf2nf;
	};

*********************;
****  Table 3 Panel A;
*********************;

    *****************  Summary Statistics for dependent variable ******************;
               sort fship;  by fship: sum art art04 enga lifa phya soca;

    *****************  Regressions *****************************************;
       foreach var of varlist art art04 enga lifa phya soca {;

       	xtreg `var' perf2f perf2nf $univreg $state dy*, i(gfice) cluster(ustate) fe;
			test perf2f=perf2nf;
    };

*********************;
****  Table 3 Panel B;
*********************;

    *****************  Summary Statistics for dependent variable ******************;
               sort fship;  by fship: sum cart cart04 engca lifca phyca socca;

    *****************  Regressions *****************************************;
       foreach var of varlist cart cart04 engca lifca phyca socca {;

       	xtreg `var' perf2f perf2nf $univreg $state dy*, i(gfice) cluster(ustate)  fe;
			test perf2f=perf2nf;
    };


