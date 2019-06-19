#delimit;
use mergecap_3, clear;
rename rnetop  rnp;
rename unsklab blue;
rename sklab white;
rename avgemps L;
rename rmatusd2 rm;
rename rfuels2 rf;
rename rserv rs;
rename ciiu isic;
rename id ppn;
gen double lny=log(rnp);
gen double lnw=log(white);
gen double lnb=log(blue);
gen double lnk=log(tnkall);
gen double lnm=log(rm);
gen double lns=log(rs);
gen double lne=log(elecbvol);/**  Measuring electricity in units bought **/ 
/** Using only bought electricity: 	generated electricity is reflected in fuel, etc**/

gen double lnf=log(rf); /** Almost 50% of observations missing for lnf**/

gen double epr = elecbval/elecbvol;

keep ppn year isic ciiu* lny lnb* lnw* lnk* lnm* lns* lnf* lne*
matls netop elecbval elecbvol epr fuels skwages unskwages servpur rnp blue white 
tnkall L rm rf relecbval rs finvrm iinvrm def_op79 opprofs valadded
enteryr cpi rva3 val3;

gen tpd=1*(year<1985)+2*(year>=1985& year<1991)+3*(year>=1991);
gen pd2= (tpd==2);
gen pd3= (tpd==3);

egen indyr= group(isic year);
egen indop=sum(rnp), by(indyr);
gen logindop=log(indop);
sort isic year;
gen xx=(indop-indop[_n-1])/indop if year==year[_n-1]+1 
	& isic==isic[_n-1];
egen perch_indop=max(xx), by(indyr); drop xx;

/*********************************************************************/
/** Fixing the relevant prices (to compare to the marginal products **/
gen pr_b=unskw/blue;
gen pr_w=skw/white;
gen pr_m=(matls - (finvrm-iinvrm))/rm;
gen pr_f=fuels/rf;
gen pr_e= epr;
/*********************************************************************/

egen indblue=sum(blue) if unskwage ~=., by(indyr);
egen indbwbill=sum(unskwage), by(indyr);
egen indwhite=sum(white)if skwage ~=., by(indyr);
egen indwwbill=sum(skwage), by(indyr);
gen avpr_b= indbwbill/indblue;
gen avpr_w= indwwbill/indwhite;

egen sd_pr_b=sd(pr_b), by(ppn);
egen sd_blue=sd(blue), by(ppn);

egen sd_pr_w=sd(pr_w), by(ppn);
egen sd_white=sd(white), by(ppn);
replace lnm=log(exp(lnm) + exp(lnf)) if lnf~=.;/** Deal with missing fuels in this way **/
qui gen double lnrva=log(rva3);


global indlist 311 313 321 322 323 324 331 332 342 351 352 354 355 356 361 362 381 383 384 385 390; 
qui gen dsample=.;
foreach x in $indlist{;
qui replace dsample=1 if ciiu_3d==`x';
};
qui keep if dsample==1;
save temp_chile_fin, replace;

