#delimit;
clear; clear matrix;
program drop _all;
set memory 100m;
set matsize 2000;
macro drop cond iXfips;

global control "yes";
global table "tab_15_guvenen";
global depvar1  "varloginc";




cd "$startdir/$outputtables";



global rho=1; global rhotrans=1; global bigrho=100*$rho;
*quietly do "$startdir/$dofiles/merge_state_conditions_rho";
use "$startdir/$outputdata/statecohortswconditionsrhofips$bigrho.dta",clear;

gen insample=0;
replace insample=1 if  year>=1955;
drop if fips==2 | fips==11 | fips==15;
sort C year A;
******WITHIN: (ORIGINAL VERSION) ;
global iXfips "i.fips*i.C     i.fips*A                 i.A*i.year" ;
renpfix Ainitcondsbeta betaAinitconds;
renpfix Asqinitcondsbeta betaAsqinitconds;


global cond "rhoadjcumsumneggrowth   rhotransrecentneggrowth rhoadjcumsumdgdp  rhotransrecentdgdp     rhoadjcumsumdsgdp2   rhotransrecentdsgdp2   
       betarhoadjcumsumrecsty betarhotransrecentrecsty  betarhoadjcumsumnipadgdp_neg  betarhotransrecentnipadgdp_neg  betarhoadjcumsumrecmonth betarhotransrecentrecmonth
       betarhoadjcumsumnipadgdp betarhotransrecentnipadgdp        betarhoadjcumsumnipadgdp_nsq2  betarhotransrecentnipadgdp_nsq2   rhoadjcumsumempshare rhotransrecentempshare   
       Ainitcondsneggrowth Asqinitcondsneggrowth  Ainitcondsdgdp Asqinitcondsdgdp Ainitcondsdsgdp2 Asqinitcondsdsgdp2                
       betaAinitcondsrecsty betaAsqinitcondsrecsty    betaAinitcondsnipadgdp_neg betaAsqinitcondsnipadgdp_neg betaAinitcondsrecmonth betaAsqinitcondsrecmonth  betaAinitcondsnipadgdp betaAsqinitcondsnipadgdp
       betaAinitcondsnipadgdp_nsq2 betaAsqinitcondsnipadgdp_nsq2  Ainitcondsempshare Asqinitcondsempshare ";

if "$bootstrap"=="noBS"{;
quietly reg varloginc $cond;
        outreg using "$table", nolabel  ctitle(ones) bdec(4) se rdec(3) replace;
};


program define runreg;
quietly  xi: reg $depvar1 $cond $iXfips [aweight=Ninc] if insample==1;
        outreg $cond using "$table", nolabel  ctitle(ones) bdec(4) se rdec(3) append;
end;

global cond "rhoadjcumsumneggrowth rhotransrecentneggrowth"; runreg; 
global cond "rhoadjcumsumdgdp rhoadjcumsumdsgdp2  rhotransrecentdgdp rhotransrecentdsgdp2 "; runreg; 
**beta;
replace insample=1;
global cond "betarhoadjcumsumrecsty betarhotransrecentrecsty"; runreg; 
global cond "betarhoadjcumsumnipadgdp_neg  betarhotransrecentnipadgdp_neg"; runreg; 
global cond "betarhoadjcumsumrecmonth betarhotransrecentrecmonth"; runreg; 
global cond "betarhoadjcumsumnipadgdp  betarhoadjcumsumnipadgdp_nsq2 betarhotransrecentnipadgdp betarhotransrecentnipadgdp_nsq2"; runreg; 
global cond " rhoadjcumsumempshare rhotransrecentempshare"; runreg;


gen Asq=A^2;
global iXfips "i.fips*i.C     i.fips*A      i.fips*Asq      i.fips*i.rhoterm     i.A*i.year" ;
replace insample=0 if year<1955;
global cond "rhoadjcumsumneggrowth rhotransrecentneggrowth Ainitcondsneggrowth Asqinitcondsneggrowth"; runreg; 
global cond "rhoadjcumsumdgdp rhoadjcumsumdsgdp2  rhotransrecentdgdp rhotransrecentdsgdp2 Ainitcondsdgdp Asqinitcondsdgdp Ainitcondsdsgdp2 Asqinitcondsdsgdp2"; runreg; 
**beta;
replace insample=1;
global cond "betarhoadjcumsumrecsty betarhotransrecentrecsty betaAinitcondsrecsty betaAsqinitcondsrecsty  "; runreg; 
global cond "betarhoadjcumsumnipadgdp_neg  betarhotransrecentnipadgdp_neg betaAinitcondsnipadgdp_neg betaAsqinitcondsnipadgdp_neg "; runreg; 
global cond "betarhoadjcumsumrecmonth betarhotransrecentrecmonth betaAinitcondsrecmonth betaAsqinitcondsrecmonth  "; runreg; 
global cond "betarhoadjcumsumnipadgdp  betarhoadjcumsumnipadgdp_nsq2 betarhotransrecentnipadgdp betarhotransrecentnipadgdp_nsq2 betaAinitcondsnipadgdp betaAsqinitcondsnipadgdp
       betaAinitcondsnipadgdp_nsq2 betaAsqinitcondsnipadgdp_nsq2   "; runreg;
global cond " rhoadjcumsumempshare rhotransrecentempshare Ainitcondsempshare Asqinitcondsempshare"; runreg;








use "$startdir/$outputdata/statecohortswconditionsrhofips95.dta",clear;
gen insample=0;
replace insample=1 if  year>=1955;
drop if fips==2 | fips==11 | fips==15;
sort C year A;
renpfix Ainitcondsbeta betaAinitconds;
renpfix Asqinitcondsbeta betaAsqinitconds;


               
gen Asq=A^2;
global iXfips "i.fips*i.C     i.fips*A      i.fips*Asq      i.fips*i.rhoterm     i.A*i.year" ;

global cond "rhoadjcumsumneggrowth rhotransrecentneggrowth Ainitcondsneggrowth Asqinitcondsneggrowth"; runreg; 
global cond "rhoadjcumsumdgdp rhoadjcumsumdsgdp2  rhotransrecentdgdp rhotransrecentdsgdp2 Ainitcondsdgdp Asqinitcondsdgdp Ainitcondsdsgdp2 Asqinitcondsdsgdp2"; runreg; 
**beta;
replace insample=1;
global cond "betarhoadjcumsumrecsty betarhotransrecentrecsty betaAinitcondsrecsty betaAsqinitcondsrecsty  "; runreg; 
global cond "betarhoadjcumsumnipadgdp_neg  betarhotransrecentnipadgdp_neg betaAinitcondsnipadgdp_neg betaAsqinitcondsnipadgdp_neg "; runreg; 
global cond "betarhoadjcumsumrecmonth betarhotransrecentrecmonth betaAinitcondsrecmonth betaAsqinitcondsrecmonth  "; runreg; 
global cond "betarhoadjcumsumnipadgdp  betarhoadjcumsumnipadgdp_nsq2 betarhotransrecentnipadgdp betarhotransrecentnipadgdp_nsq2 betaAinitcondsnipadgdp betaAsqinitcondsnipadgdp
       betaAinitcondsnipadgdp_nsq2 betaAsqinitcondsnipadgdp_nsq2   "; runreg; 
global cond " rhoadjcumsumempshare rhotransrecentempshare Ainitcondsempshare Asqinitcondsempshare"; runreg;





