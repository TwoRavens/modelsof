capture log close
drop _all
set more 1
#delimit;
   
cd "C:\Dropbox\Main\p-cycle\Writing\ReStatRevision\Replication_Xiang2014_PCycle\Data";

set logtype text; 
log using aaaa, replace; 



*************step 1 Ng trade share*************************; 

use NS2; keep if year==92 | (year==91 & msic87=="2111"); *****2111 is in the data 72-91, ng=0 all years;
drop year; gen x=real(msic87); drop msic87; rename x msic87; compress;
sort msic87; save c1, replace; 

************step 2 concord Ng trade share to sic87 basis***************;
use sic87_msic87.dta;
keep if year==92; drop year; 
drop if msic87<2000 | msic87>9000; *****drop non-mfg categories; 
sort msic87; merge msic87 using c1; tab _merge; 
tab msic87 if _merge==1; ****1 for 3582, which does not exist in NS2.dta; drop if _merge==1; drop _merge;

foreach x of varlist fobNng fobNog fobSng fobSog {;
  replace `x'=`x'*wfobmsic;
};
foreach x of varlist cifNng cifNog cifSng cifSog {;
  replace `x'=`x'*wcifmsic;
};

sort sic87; collapse (sum) fob* cif*, by(sic87); 
****************calculate various shares***********************;
foreach x in fob cif {;
  gen ntsA`x'=(`x'Nng+`x'Sng)/(`x'Nng+`x'Sng+`x'Nog+`x'Sog); gen ttA`x'=(`x'Nng+`x'Sng+`x'Nog+`x'Sog);
  gen ntsN`x'=(`x'Nng)/(`x'Nng+`x'Nog); gen ttN`x'=(`x'Nng+`x'Nog);
  gen ntsS`x'=(`x'Sng)/(`x'Sng+`x'Sog); gen ttS`x'=(`x'Nng+`x'Nog);
  label var ntsA`x' "ng trade share, N+S, `x' based";
  label var ntsN`x' "ng trade share in N, `x' based";
  label var ntsS`x' "ng trade share in S, `x' based";
  label var ttA`x' "total trade value, N+S, `x' based";
  label var ttN`x' "total trade value, N, `x' based";
  label var ttS`x' "total trade value, S, `x' based";
};

drop fob* cif*; sort sic87; save c1, replace; 


**********step 4 convert sic87 codes into ISIC rev2IO codes*********************;
use sic87toiotable.dta; 
sort sic87; merge sic87 using c1; 
tab _merge; ***all 3 except 2067, which is not in VSCorrelation.dta, issue about processes, drop; 
drop if _merge==1; drop _merge; 

foreach x in fob cif {;
  gen ntsA`x'V=ntsA`x'*ttA`x'; gen ntsN`x'V=ntsN`x'*ttN`x'; gen ntsS`x'V=ntsS`x'*ttS`x';
};

sort io95; collapse (sum) nts*V tt*, by(io95); 

foreach x in fob cif {;
  gen ntsA`x'=ntsA`x'V/ttA`x'; gen ntsN`x'=ntsN`x'V/ttN`x'; gen ntsS`x'=ntsS`x'V/ttS`x';
};

sort io95; keep io95 io_name ntsNfob ntsSfob; 
label var io95 "Industry Classification in Table 2";
label var io_name "industry names in Table 2"; 
label var ntsNfob "column 1 of Table 2";
label var ntsSfob "Column 2 of Table 2";
save c1, replace; 


log close; 


