
clear
set more off
capture log close
set logtype text
set matsize 4000
set mem 900m

#delimit ;

log using total_110519_final.log, replace;
cd "H:\YR\labora\labora\Keh\Keksijät\totaaliajot\";


*---------------------------------------------------------------------------;
*get patent info from uinv_linked.dta for individuals;
*---------------------------------------------------------------------------;

*calculate patents per individual by application year;

use uinv_linked.dta;

drop vuosi;
rename hakuvuosi vuosi;
sort shtun vuosi;
save inv_linked_app.dta, replace;
clear;

use ht8804_inv.dta;
keep shtun vuosi; 
destring vuosi, replace;
sort shtun vuosi;
merge shtun vuosi using inv_linked_app.dta, uniqmaster;
tab _merge;
sort shtun vuosi;
egen paten_app=group(spatent);
by shtun vuosi: egen pat_apps=count(paten_app);
keep shtun vuosi pat_apps;

duplicates drop shtun vuosi pat_apps, force;
sort vuosi;
keep if vuosi>=1991 & vuosi<=1999;

save pat_app.dta, replace;
clear;
*--------------------------------------------------------------------;
*calculate patents per individual by grant year;

use uinv_linked.dta;

drop vuosi;
rename gyear vuosi;

gen assig_firm = 0 if asscode==1 | asscode==5;
replace assig_firm = 1 if syrtun_pat==syrtun_fleed & syrtun_pat!="";
replace assig_firm = 2 if syrtun_pat!=syrtun_fleed & assig_firm==. & syrtun_pat!="" & syrtun_fleed!="";
replace assig_firm = 4 if syrtun_pat=="" & assig_firm!=0;
replace assig_firm = 5 if syrtun_fleed=="" & assig_firm!=0;
replace assig_firm = 3 if syrtun_pat=="" & syrtun_fleed=="" & assig_firm!=0;

tab assig_firm;

gen citlag=2002-hakuvuosi;

rename creceive1 cits;

replace cits=cits/0.037 if citlag==1 & cat==1;
replace cits=cits/0.045 if citlag==1 & cat==2;
replace cits=cits/0.026 if citlag==1 & cat==3;
replace cits=cits/0.048 if citlag==1 & cat==4;
replace cits=cits/0.043 if citlag==1 & cat==5;
replace cits=cits/0.026 if citlag==1 & cat==6;

replace cits=cits/0.091 if citlag==2 & cat==1;
replace cits=cits/0.112 if citlag==2 & cat==2;
replace cits=cits/0.067 if citlag==2 & cat==3;
replace cits=cits/0.115 if citlag==2 & cat==4;
replace cits=cits/0.101 if citlag==2 & cat==5;
replace cits=cits/0.069 if citlag==2 & cat==6;

replace cits=cits/0.152 if citlag==3 & cat==1;
replace cits=cits/0.188 if citlag==3 & cat==2;
replace cits=cits/0.114 if citlag==3 & cat==3;
replace cits=cits/0.187 if citlag==3 & cat==4;
replace cits=cits/0.164 if citlag==3 & cat==5;
replace cits=cits/0.123 if citlag==3 & cat==6;

replace cits=cits/0.214 if citlag==4 & cat==1;
replace cits=cits/0.266 if citlag==4 & cat==2;
replace cits=cits/0.165 if citlag==4 & cat==3;
replace cits=cits/0.259 if citlag==4 & cat==4;
replace cits=cits/0.226 if citlag==4 & cat==5;
replace cits=cits/0.182 if citlag==4 & cat==6;

replace cits=cits/0.275 if citlag==5 & cat==1;
replace cits=cits/0.342 if citlag==5 & cat==2;
replace cits=cits/0.216 if citlag==5 & cat==3;
replace cits=cits/0.327 if citlag==5 & cat==4;
replace cits=cits/0.285 if citlag==5 & cat==5;
replace cits=cits/0.244 if citlag==5 & cat==6;

replace cits=cits/0.333 if citlag==6 & cat==1;
replace cits=cits/0.413 if citlag==6 & cat==2;
replace cits=cits/0.265 if citlag==6 & cat==3;
replace cits=cits/0.390 if citlag==6 & cat==4;
replace cits=cits/0.341 if citlag==6 & cat==5;
replace cits=cits/0.306 if citlag==6 & cat==6;

replace cits=cits/0.387 if citlag==7 & cat==1;
replace cits=cits/0.479 if citlag==7 & cat==2;
replace cits=cits/0.314 if citlag==7 & cat==3;
replace cits=cits/0.448 if citlag==7 & cat==4;
replace cits=cits/0.393 if citlag==7 & cat==5;
replace cits=cits/0.366 if citlag==7 & cat==6;

replace cits=cits/0.438 if citlag==8 & cat==1;
replace cits=cits/0.538 if citlag==8 & cat==2;
replace cits=cits/0.360 if citlag==8 & cat==3;
replace cits=cits/0.502 if citlag==8 & cat==4;
replace cits=cits/0.442 if citlag==8 & cat==5;
replace cits=cits/0.424 if citlag==8 & cat==6;

replace cits=cits/0.485 if citlag==9 & cat==1;
replace cits=cits/0.592 if citlag==9 & cat==2;
replace cits=cits/0.404 if citlag==9 & cat==3;
replace cits=cits/0.550 if citlag==9 & cat==4;
replace cits=cits/0.487 if citlag==9 & cat==5;
replace cits=cits/0.479 if citlag==9 & cat==6;

replace cits=cits/0.529 if citlag==10 & cat==1;
replace cits=cits/0.640 if citlag==10 & cat==2;
replace cits=cits/0.446 if citlag==10 & cat==3;
replace cits=cits/0.594 if citlag==10 & cat==4;
replace cits=cits/0.530 if citlag==10 & cat==5;
replace cits=cits/0.530 if citlag==10 & cat==6;

replace cits=cits/0.569 if citlag==11 & cat==1;
replace cits=cits/0.683 if citlag==11 & cat==2;
replace cits=cits/0.486 if citlag==11 & cat==3;
replace cits=cits/0.635 if citlag==11 & cat==4;
replace cits=cits/0.569 if citlag==11 & cat==5;
replace cits=cits/0.578 if citlag==11 & cat==6;

replace cits=cits/0.607 if citlag==12 & cat==1;
replace cits=cits/0.721 if citlag==12 & cat==2;
replace cits=cits/0.524 if citlag==12 & cat==3;
replace cits=cits/0.671 if citlag==12 & cat==4;
replace cits=cits/0.606 if citlag==12 & cat==5;
replace cits=cits/0.622 if citlag==12 & cat==6;

replace cits=cits/0.642 if citlag==13 & cat==1;
replace cits=cits/0.755 if citlag==13 & cat==2;
replace cits=cits/0.560 if citlag==13 & cat==3;
replace cits=cits/0.705 if citlag==13 & cat==4;
replace cits=cits/0.640 if citlag==13 & cat==5;
replace cits=cits/0.662 if citlag==13 & cat==6;

replace cits=cits/0.674 if citlag==14 & cat==1;
replace cits=cits/0.785 if citlag==14 & cat==2;
replace cits=cits/0.593 if citlag==14 & cat==3;
replace cits=cits/0.735 if citlag==14 & cat==4;
replace cits=cits/0.671 if citlag==14 & cat==5;
replace cits=cits/0.699 if citlag==14 & cat==6;

replace cits=cits/0.704 if citlag==15 & cat==1;
replace cits=cits/0.812 if citlag==15 & cat==2;
replace cits=cits/0.625 if citlag==15 & cat==3;
replace cits=cits/0.763 if citlag==15 & cat==4;
replace cits=cits/0.701 if citlag==15 & cat==5;
replace cits=cits/0.732 if citlag==15 & cat==6;


sum no_inv;
sum cits;
tab no_inv;
tab cat;
tab assig_firm;

tab asscode;
tab hakuvuosi;

*---------------------------------;
*calculate share of patent and cites per individual per patent;

gen ipshare= 1/no_inv;
sum ipshare;

gen cishare= cits/no_inv;
sum cishare;

*---------------------------------;
sort shtun vuosi;
save inv_linked1.dta, replace;

clear;

*---------------------------------------------------------------------------;
*get individual information from FLEED and merge with patent info;
*---------------------------------------------------------------------------;

use ht8804_inv.dta;

keep shtun vuosi sp ika kieli kans ptoim1 amas1 apvm1 tyokk ttyotu tyrtu svatva svatvp 
syrtun  nuts2  ututku ; 

destring vuosi, replace;

sort shtun vuosi;

merge shtun vuosi using inv_linked1.dta, uniqmaster;

tab _merge;

*---------------------------------;
*compare matched and unmatched patents;

gen match=0 if _merge==2;
replace match=1 if _merge==3;

ttest no_inv, by(match);
ttest cits, by(match);

tab no_inv match, chi2 column;
tab cat match, chi2 column;
tab assig_firm match, chi2 column;
tab asscode match, chi2 column;
tab hakuvuosi match, chi2 column;

drop if shtun=="";

drop _merge;

*--------------------------------------------------------------------;
*calculate patents granted and citations received per person per year;
*--------------------------------------------------------------------;

sort shtun vuosi;

egen paten=group(spatent);

by shtun vuosi: egen pats=count(paten);

by shtun vuosi: egen pats_ind=count(paten) if assig_firm==0;
replace pats_ind=0 if pats_ind==.;
by shtun vuosi: egen pats_indi=max(pats_ind);

by shtun vuosi: egen coinv=total(no_inv); *no. of inventors;

by shtun vuosi: egen pats_share=total(ipshare);
sum pats_share;

by shtun vuosi: egen cits_share=total(cishare);
sum cits_share;

rename cits creceive1;

by shtun vuosi: egen cits=total(creceive1); 

by shtun vuosi: egen cits_ind=total(creceive1) if assig_firm==0;
replace cits_ind=0 if cits_ind==.;
by shtun vuosi: egen cits_indi=max(cits_ind);


*-----------------------------------------------;

duplicates report shtun vuosi pats;

duplicates drop shtun vuosi pats, force;

sort vuosi;
keep if vuosi>=1991 & vuosi<=1999;

save inv_linked_s2.dta, replace;
clear;

use inv_linked_s2.dta;
sort shtun vuosi;

merge shtun vuosi using pat_app.dta, sort;
drop _merge;

save inv_linked_s2.dta, replace;
clear;


*--------------------------------------------------------------------------;
*calculate average wages per firm using sample from FLEED;

use "H:\YR\labora\labora\Keh\Keksijät\kontrollit\kontr_otos4.dta";

rename ttyotu wage;

replace wage=wage/0.895316804407714 if vuosi==1991;
replace wage=wage/0.918044077134986 if vuosi==1992;
replace wage=wage/0.93732782369146 if vuosi==1993;
replace wage=wage/0.947658402203857 if vuosi==1994;
replace wage=wage/0.957300275482094 if vuosi==1995;
replace wage=wage/0.962809917355372 if vuosi==1996;
replace wage=wage/0.974517906336088 if vuosi==1997;
replace wage=wage/0.988292011019284 if vuosi==1998;

collapse wage, by(syrtun vuosi);

replace wage=log(wage);
rename wage firmwage;

save firm_wages.dta, replace;

clear;
*--------------------------------------------------------------------------;


*---------------------------------------------------------------------------;
*use patent data to calculate patents & cites per assignee firm;
*---------------------------------------------------------------------------;
use uinv_linked.dta;

drop vuosi;
rename gyear vuosi;

sort syrtun_pat vuosi spatent;
duplicates drop syrtun_pat vuosi spatent, force;
sort syrtun_pat vuosi spatent;

egen fpaten=group(spatent);

bysort syrtun_pat vuosi: egen firm_patcount = count(fpaten);

rename creceive1 cits;

*adjust cites for truncation using Hall et al. formula;

gen citlag=2002-hakuvuosi;

replace cits=cits/0.037 if citlag==1 & cat==1;
replace cits=cits/0.045 if citlag==1 & cat==2;
replace cits=cits/0.026 if citlag==1 & cat==3;
replace cits=cits/0.048 if citlag==1 & cat==4;
replace cits=cits/0.043 if citlag==1 & cat==5;
replace cits=cits/0.026 if citlag==1 & cat==6;

replace cits=cits/0.091 if citlag==2 & cat==1;
replace cits=cits/0.112 if citlag==2 & cat==2;
replace cits=cits/0.067 if citlag==2 & cat==3;
replace cits=cits/0.115 if citlag==2 & cat==4;
replace cits=cits/0.101 if citlag==2 & cat==5;
replace cits=cits/0.069 if citlag==2 & cat==6;

replace cits=cits/0.152 if citlag==3 & cat==1;
replace cits=cits/0.188 if citlag==3 & cat==2;
replace cits=cits/0.114 if citlag==3 & cat==3;
replace cits=cits/0.187 if citlag==3 & cat==4;
replace cits=cits/0.164 if citlag==3 & cat==5;
replace cits=cits/0.123 if citlag==3 & cat==6;

replace cits=cits/0.214 if citlag==4 & cat==1;
replace cits=cits/0.266 if citlag==4 & cat==2;
replace cits=cits/0.165 if citlag==4 & cat==3;
replace cits=cits/0.259 if citlag==4 & cat==4;
replace cits=cits/0.226 if citlag==4 & cat==5;
replace cits=cits/0.182 if citlag==4 & cat==6;

replace cits=cits/0.275 if citlag==5 & cat==1;
replace cits=cits/0.342 if citlag==5 & cat==2;
replace cits=cits/0.216 if citlag==5 & cat==3;
replace cits=cits/0.327 if citlag==5 & cat==4;
replace cits=cits/0.285 if citlag==5 & cat==5;
replace cits=cits/0.244 if citlag==5 & cat==6;

replace cits=cits/0.333 if citlag==6 & cat==1;
replace cits=cits/0.413 if citlag==6 & cat==2;
replace cits=cits/0.265 if citlag==6 & cat==3;
replace cits=cits/0.390 if citlag==6 & cat==4;
replace cits=cits/0.341 if citlag==6 & cat==5;
replace cits=cits/0.306 if citlag==6 & cat==6;

replace cits=cits/0.387 if citlag==7 & cat==1;
replace cits=cits/0.479 if citlag==7 & cat==2;
replace cits=cits/0.314 if citlag==7 & cat==3;
replace cits=cits/0.448 if citlag==7 & cat==4;
replace cits=cits/0.393 if citlag==7 & cat==5;
replace cits=cits/0.366 if citlag==7 & cat==6;

replace cits=cits/0.438 if citlag==8 & cat==1;
replace cits=cits/0.538 if citlag==8 & cat==2;
replace cits=cits/0.360 if citlag==8 & cat==3;
replace cits=cits/0.502 if citlag==8 & cat==4;
replace cits=cits/0.442 if citlag==8 & cat==5;
replace cits=cits/0.424 if citlag==8 & cat==6;

replace cits=cits/0.485 if citlag==9 & cat==1;
replace cits=cits/0.592 if citlag==9 & cat==2;
replace cits=cits/0.404 if citlag==9 & cat==3;
replace cits=cits/0.550 if citlag==9 & cat==4;
replace cits=cits/0.487 if citlag==9 & cat==5;
replace cits=cits/0.479 if citlag==9 & cat==6;

replace cits=cits/0.529 if citlag==10 & cat==1;
replace cits=cits/0.640 if citlag==10 & cat==2;
replace cits=cits/0.446 if citlag==10 & cat==3;
replace cits=cits/0.594 if citlag==10 & cat==4;
replace cits=cits/0.530 if citlag==10 & cat==5;
replace cits=cits/0.530 if citlag==10 & cat==6;

replace cits=cits/0.569 if citlag==11 & cat==1;
replace cits=cits/0.683 if citlag==11 & cat==2;
replace cits=cits/0.486 if citlag==11 & cat==3;
replace cits=cits/0.635 if citlag==11 & cat==4;
replace cits=cits/0.569 if citlag==11 & cat==5;
replace cits=cits/0.578 if citlag==11 & cat==6;

replace cits=cits/0.607 if citlag==12 & cat==1;
replace cits=cits/0.721 if citlag==12 & cat==2;
replace cits=cits/0.524 if citlag==12 & cat==3;
replace cits=cits/0.671 if citlag==12 & cat==4;
replace cits=cits/0.606 if citlag==12 & cat==5;
replace cits=cits/0.622 if citlag==12 & cat==6;

replace cits=cits/0.642 if citlag==13 & cat==1;
replace cits=cits/0.755 if citlag==13 & cat==2;
replace cits=cits/0.560 if citlag==13 & cat==3;
replace cits=cits/0.705 if citlag==13 & cat==4;
replace cits=cits/0.640 if citlag==13 & cat==5;
replace cits=cits/0.662 if citlag==13 & cat==6;

replace cits=cits/0.674 if citlag==14 & cat==1;
replace cits=cits/0.785 if citlag==14 & cat==2;
replace cits=cits/0.593 if citlag==14 & cat==3;
replace cits=cits/0.735 if citlag==14 & cat==4;
replace cits=cits/0.671 if citlag==14 & cat==5;
replace cits=cits/0.699 if citlag==14 & cat==6;

replace cits=cits/0.704 if citlag==15 & cat==1;
replace cits=cits/0.812 if citlag==15 & cat==2;
replace cits=cits/0.625 if citlag==15 & cat==3;
replace cits=cits/0.763 if citlag==15 & cat==4;
replace cits=cits/0.701 if citlag==15 & cat==5;
replace cits=cits/0.732 if citlag==15 & cat==6;


bysort syrtun_pat vuosi: egen firm_citcount = total(cits);


rename syrtun_pat syrtun;
keep syrtun vuosi firm_patcount firm_citcount;

sort syrtun vuosi;
collapse firm_patcount firm_citcount, by(syrtun vuosi);

drop if syrtun=="";

*tab firm_patcount;

sort syrtun vuosi;

*make into a panel;
egen fid=group(syrtun);

sort fid;
by fid: egen totpcount=total(firm_patcount);

sort fid vuosi;
tsset fid vuosi;
xtdes;


gen lagfats=l.firm_patcount;
gen lagfat2=l2.firm_patcount;
gen lagfat3=l3.firm_patcount;
gen lagfat4=l4.firm_patcount;
gen lagfat5=l5.firm_patcount;
gen lagfat6=l6.firm_patcount;
gen lagfat7=l7.firm_patcount;
gen lagfat8=l8.firm_patcount;

replace lagfats=0 if lagfats==.;
replace lagfat2=0 if lagfat2==.;
replace lagfat3=0 if lagfat3==.;
replace lagfat4=0 if lagfat4==.;
replace lagfat5=0 if lagfat5==.;
replace lagfat6=0 if lagfat6==.;
replace lagfat7=0 if lagfat7==.;
replace lagfat8=0 if lagfat8==.;

gen lagfits=l.firm_citcount;
gen lagfit2=l2.firm_citcount;
gen lagfit3=l3.firm_citcount;
gen lagfit4=l4.firm_citcount;
gen lagfit5=l5.firm_citcount;
gen lagfit6=l6.firm_citcount;
gen lagfit7=l7.firm_citcount;
gen lagfit8=l8.firm_citcount;

replace lagfits=0 if lagfits==.;
replace lagfit2=0 if lagfit2==.;
replace lagfit3=0 if lagfit3==.;
replace lagfit4=0 if lagfit4==.;
replace lagfit5=0 if lagfit5==.;
replace lagfit6=0 if lagfit6==.;
replace lagfit7=0 if lagfit7==.;
replace lagfit8=0 if lagfit8==.;



tsset, clear;
keep syrtun vuosi firm_patcount lagfats lagfat2 lagfat3 lagfat4 lagfat5 lagfat6 lagfat7 lagfat8
firm_citcount lagfits lagfit2 lagfit3 lagfit4 lagfit5 lagfit6 lagfit7 lagfit8;
sort syrtun vuosi;

save firm_pats.dta, replace; 

clear;

*--------------------------------------------------------------------;
*merge with financial statements info;
*--------------------------------------------------------------------;

use tp8804.dta;
destring vuosi, replace;
keep if vuosi>=1991 & vuosi<=1999;

keep syrtun vuosi tphenk tplv tol95;

duplicates report syrtun vuosi;

sort syrtun vuosi;
save tp8804_1.dta, replace;

clear;


use inv_linked_s2.dta;

sort syrtun vuosi;

merge syrtun vuosi using tp8804_1.dta, uniqusing;
tab _merge;

drop if _merge==2;
drop _merge;
save inv_linked_s2.dta, replace;

clear;


*--------------------------------------------------------------------;
*add rd variables and firm patenting variables;
*--------------------------------------------------------------------;
use rd8505.dta;

destring vuosi, replace;

keep if vuosi>=1991 & vuosi<=1999;

keep syrtun vuosi ysyht;

sort syrtun vuosi;

save rd9199a.dta, replace;

clear;

use inv_linked_s2.dta;

sort syrtun vuosi;

merge syrtun vuosi using rd9199a.dta, uniqusing;

tab _merge;
drop if _merge==2;
drop _merge;

save inv_linked_s2.dta, replace;

clear;

use inv_linked_s2.dta;

sort syrtun vuosi;
merge syrtun vuosi using firm_pats.dta, sort uniqusing;
tab _merge;
drop if _merge==2;
drop _merge;

replace firm_patcount=0 if firm_patcount==.;

replace lagfats=0 if lagfats==.;
replace lagfat2=0 if lagfat2==.;
replace lagfat3=0 if lagfat3==.;
replace lagfat4=0 if lagfat4==.;
replace lagfat5=0 if lagfat5==.;
replace lagfat6=0 if lagfat6==.;

replace firm_citcount=0 if firm_citcount==.;
replace lagfits=0 if lagfits==.;
replace lagfit2=0 if lagfit2==.;
replace lagfit3=0 if lagfit3==.;
replace lagfit4=0 if lagfit4==.;
replace lagfit5=0 if lagfit5==.;
replace lagfit6=0 if lagfit6==.;


tab firm_patcount;


*merge firm wages;

sort syrtun vuosi;
merge syrtun vuosi using firm_wages.dta, sort uniqusing;

tab _merge;
drop if _merge==2;
drop _merge;

save inv_linked_s2.dta, replace;

clear;


*---------------------------------------------------;
*make into a panel;
*---------------------------------------------------;

use inv_linked_s2.dta;

sort shtun vuosi;
duplicates report shtun vuosi;

egen id=group(shtun);

tsset id vuosi;
xtdes;

sort syrtun;
egen firm_id=group(syrtun);

xtdes;


*--------------------------------------------------------------------;
*PERSON-LEVEL CONTROLS;
*--------------------------------------------------------------------;

destring sp, replace;
destring amas1, replace;
destring ptoim1, replace;
destring tyokk, replace;
destring ika, replace;

drop if amas1==.;

*GENDER;
gen female=1 if sp==2;
replace female=0 if sp==1;


*WAGES;
gen wage=ttyotu;

*deflate wages to 1999 money;

replace wage=wage/0.895316804407714 if vuosi==1991;
replace wage=wage/0.918044077134986 if vuosi==1992;
replace wage=wage/0.93732782369146 if vuosi==1993;
replace wage=wage/0.947658402203857 if vuosi==1994;
replace wage=wage/0.957300275482094 if vuosi==1995;
replace wage=wage/0.962809917355372 if vuosi==1996;
replace wage=wage/0.974517906336088 if vuosi==1997;
replace wage=wage/0.988292011019284 if vuosi==1998;

gen logwage = log(wage);


gen wage3=svatva;
replace wage3=wage3/0.895316804407714 if vuosi==1991;
replace wage3=wage3/0.918044077134986 if vuosi==1992;
replace wage3=wage3/0.93732782369146 if vuosi==1993;
replace wage3=wage3/0.947658402203857 if vuosi==1994;
replace wage3=wage3/0.957300275482094 if vuosi==1995;
replace wage3=wage3/0.962809917355372 if vuosi==1996;
replace wage3=wage3/0.974517906336088 if vuosi==1997;
replace wage3=wage3/0.988292011019284 if vuosi==1998;

gen logwage3=log(wage3);

gen wage4=svatvp;
replace wage4=wage4/0.895316804407714 if vuosi==1991;
replace wage4=wage4/0.918044077134986 if vuosi==1992;
replace wage4=wage4/0.93732782369146 if vuosi==1993;
replace wage4=wage4/0.947658402203857 if vuosi==1994;
replace wage4=wage4/0.957300275482094 if vuosi==1995;
replace wage4=wage4/0.962809917355372 if vuosi==1996;
replace wage4=wage4/0.974517906336088 if vuosi==1997;
replace wage4=wage4/0.988292011019284 if vuosi==1998;

gen logwage4=log(wage4);

gen wage5=wage4 + wage3;
gen logwage5=log(wage5);


*EDUCATION;
gen educ=substr(ututku,1,2);
destring educ, replace;

gen edu_level=substr(ututku,1,1);
destring edu_level, replace;

gen edu_field=substr(ututku,2,1);
destring edu_field, replace;


*MONTHS EMPLOYED;
rename tyokk months;


*TENURE;
*apvm is the beginning date for the job;
*first two digits indicate the year;

gen startyr=substr(apvm1,1,2);
destring startyr, replace;
gen tenure=vuosi-1900-startyr;


*AGE;
gen age=ika;

gen age2 = age^2;
gen tenure2 = tenure^2;


*---------------------------------------------------------------------;
*NUMBER OF PATENTS PER PERSON OVER ALL THE YEARS (91-99);
*---------------------------------------------------------------------;

sort id;
by id: egen totpat=total(pats);
drop if totpat==0; 

*--------------------------------------------------------------------;
*FIRM-LEVEL CONTROLS;
*--------------------------------------------------------------------;
*note: firm variables not available for all the obs;

gen sector=substr(tol95,1,2);

gen emp=tphenk/100;

sort vuosi;
by vuosi: sum emp;
by vuosi: sum tplv;

gen rd_int=ysyht/tplv;


*generate variable for big patenters;

gen big_patf=0;
replace big_patf=1 if firm_patcount>57 & vuosi==1998;
bysort firm_id: egen big_pat=max(big_patf);

tab big_pat;


*--------------------------------------------------------------------;
*generate lags of patent variables; 
*--------------------------------------------------------------------;

sort id vuosi;

gen lagpats=l.pats;
gen lagpat2=l2.pats;
gen lagpat3=l3.pats;
gen lagpat4=l4.pats;
gen lagpat5=l5.pats;
gen lagpat6=l6.pats;
gen lagpat7=l7.pats;
gen lagpat8=l8.pats;

gen lagpsh=l.pats_share;
gen lagpsh2=l2.pats_share;
gen lagpsh3=l3.pats_share;
gen lagpsh4=l4.pats_share;
gen lagpsh5=l5.pats_share;
gen lagpsh6=l6.pats_share;


gen lagcits=l.cits;
gen lagcit2=l2.cits;
gen lagcit3=l3.cits;
gen lagcit4=l4.cits;
gen lagcit5=l5.cits;
gen lagcit6=l6.cits;
gen lagcit7=l7.cits;

gen lagcsh=l.cits_share;
gen lagcsh2=l2.cits_share;
gen lagcsh3=l3.cits_share;
gen lagcsh4=l4.cits_share;
gen lagcsh5=l5.cits_share;
gen lagcsh6=l6.cits_share;

gen lagpatsi=l.pats_indi;
gen lagpat2i=l2.pats_indi;
gen lagpat3i=l3.pats_indi;
gen lagpat4i=l4.pats_indi;
gen lagpat5i=l5.pats_indi;
gen lagpat6i=l6.pats_indi;

gen lagcitsi=l.cits_indi;
gen lagcit2i=l2.cits_indi;
gen lagcit3i=l3.cits_indi;
gen lagcit4i=l4.cits_indi;
gen lagcit5i=l5.cits_indi;
gen lagcit6i=l6.cits_indi;

gen nocits=0;
replace nocits=1 if pats>0 & pats!=. & cits==0;

gen cits10=0;
replace cits10=1 if cits>0 & cits<10;

gen cits20=0;
replace cits20=1 if cits>=10 & cits<20;

gen cits30=0;
replace cits30=1 if cits>=20 & cits<30;

gen topcits=0;
replace topcits=1 if cits>=30 & cits!=.;


gen lagnoc=l.nocits;
gen lag10c=l.cits10;
gen lag20c=l.cits20;
gen lag30c=l.cits30;
gen lagtopc=l.topcits;

gen lagnoc2=l2.nocits;
gen lag10c2=l2.cits10;
gen lag20c2=l2.cits20;
gen lag30c2=l2.cits30;
gen lagtopc2=l2.topcits;

gen lagnoc3=l3.nocits;
gen lag10c3=l3.cits10;
gen lag20c3=l3.cits20;
gen lag30c3=l3.cits30;
gen lagtop3=l3.topcits;

gen lagnoc4=l4.nocits;
gen lag10c4=l4.cits10;
gen lag20c4=l4.cits20;
gen lag30c4=l4.cits30;
gen lagtopc4=l4.topcits;

gen lagnoc5=l5.nocits;
gen lag10c5=l5.cits10;
gen lag20c5=l5.cits20;
gen lag30c5=l5.cits30;
gen lagtopc5=l5.topcits;

gen lagnoc6=l6.nocits;
gen lag10c6=l6.cits10;
gen lag20c6=l6.cits20;
gen lag30c6=l6.cits30;
gen lagtopc6=l6.topcits;

*-------------------------------------------------------;
*interact with new (employer change);

gen byte new = (tenure==0 & firm_id!=l.firm_id);
replace new = 0 if f.startyr == l.startyr;


gen old=0;
gen lagold=l.old;
gen lagold2=l2.old;
gen lagold3=l3.old;
gen lagold4=l4.old;
gen lagold5=l5.old;
gen lagold6=l6.old;

gen lagnew=l.new;
gen lagnew2 = l2.new;
gen lagnew3 = l3.new;
gen lagnew4 = l4.new;
gen lagnew5 = l5.new;
gen lagnew6 = l6.new;


replace old=1 if new==1 & old==0;
replace lagold=1 if new==1 & lagold==0;
replace lagold2=1 if new==1 & lagold2==0;
replace lagold3=1 if new==1 & lagold3==0;
replace lagold4=1 if new==1 & lagold4==0;
replace lagold5=1 if new==1 & lagold5==0;
replace lagold6=1 if new==1 & lagold6==0;

replace lagold=1 if l.new==1 & lagold==0;
replace lagold2=1 if l.new==1 & lagold2==0;
replace lagold3=1 if l.new==1 & lagold3==0;
replace lagold4=1 if l.new==1 & lagold4==0;
replace lagold5=1 if l.new==1 & lagold5==0;
replace lagold6=1 if l.new==1 & lagold6==0;

replace lagold2=1 if l2.new==1 & lagold2==0;
replace lagold3=1 if l2.new==1 & lagold3==0;
replace lagold4=1 if l2.new==1 & lagold4==0;
replace lagold5=1 if l2.new==1 & lagold5==0;
replace lagold6=1 if l2.new==1 & lagold6==0;

replace lagold3=1 if l3.new==1 & lagold3==0;
replace lagold4=1 if l3.new==1 & lagold4==0;
replace lagold5=1 if l3.new==1 & lagold5==0;
replace lagold6=1 if l3.new==1 & lagold6==0;

replace lagold4=1 if l4.new==1 & lagold4==0;
replace lagold5=1 if l4.new==1 & lagold5==0;
replace lagold6=1 if l4.new==1 & lagold6==0;

replace lagold5=1 if l5.new==1 & lagold5==0;
replace lagold6=1 if l5.new==1 & lagold6==0;

replace lagold6=1 if l6.new==1 & lagold6==0;




*--------------------------------------------------------------------;
*LIMIT THE SAMPLE TO THOSE OBS USED IN THE EMPIRICAL ANALYSIS;
*the biggest sample used;
*--------------------------------------------------------------------;

xi: reg logwage pats age tenure female  months emp i.vuosi i.sector i.educ i.nuts2;
keep if e(sample);

drop if amas1==2;

*descriptive statistics; 
sort vuosi;
by vuosi: sum wage pats cits age female tenure months emp; /* TABLE 1a */
by vuosi: sum wage pats cits age female tenure months emp if pats>0; /* TABLE 1b */

tab edu_level;
tab edu_field; /* TABLE 1c */


tab sector; /* TABLE 1d */

tab coinv;
sort vuosi;
by vuosi: tab firm_patcount;
sum rd_int;

sum nocits;
sum cits10;
sum cits20;
sum cits30;
sum topcits;

histogram pats, discrete frequency;
graph save graph1a.gph, replace;

histogram totpat, discrete frequency;
graph save graph2a.gph, replace;

histogram cits if pats>0, frequency;
graph save graph3a.gph, replace;

histogram pats if pats>0, discrete frequency;
graph save graph4a.gph, replace;

histogram totpat if vuosi==1999, discrete frequency;
graph save graph5a.gph, replace;

gen avgcits=0;
replace avgcits=cits/pats if pats>0 & pats!=.;
histogram avgcits if pats>0, frequency;
graph save graph6a.gph, replace;

*--------------------------------------------------------------------;
*REGRESSION STUFF BEGINS HERE;
*--------------------------------------------------------------------;

*first make vectors of explanatory variables;

*--------------------------------------------------------------------;
*WITH GRANTED PATENTS;
*--------------------------------------------------------------------;

#delimit ;
global expl_0 "age age2 tenure female  months emp i.vuosi i.sector  i.educ i.nuts2";
global expl_1 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats"; 
global expl_2 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats lagpats"; 
global expl_3 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats lagpats lagpat2";
global expl_4 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats lagpats lagpat2 lagpat3";
global expl_5 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats lagpats lagpat2 lagpat3 lagpat4";
global expl_6 "age age2 tenure  female  months emp  i.vuosi i.sector i.educ i.nuts2 pats lagpats lagpat2 lagpat3 lagpat4 lagpat5";
global expl_7 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats lagpats lagpat2 lagpat3 lagpat4 lagpat5 lagpat6";
global expl_8 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats lagpats lagpat2 lagpat3 lagpat4 lagpat5 lagpat6 lagpat7";

*--------------------------------------------------------------------;
*WITH CITATIONS; 
*--------------------------------------------------------------------;

global expl_10 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2";
global expl_11 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats ";
global expl_12 "age age2 tenure  female  months emp  i.vuosi  i.sector i.educ i.nuts2 pats lagcits";
global expl_13 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats lagcits lagcit2";
global expl_14 "age age2 tenure  female  months emp  i.vuosi  i.sector i.educ i.nuts2 pats lagcits lagcit2 lagcit3";
global expl_15 "age age2 tenure  female  months emp  i.vuosi  i.sector i.educ i.nuts2 pats lagcits lagcit2 lagcit3 lagcit4";
global expl_16 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats lagcits lagcit2 lagcit3 lagcit4 lagcit5";
global expl_17 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats lagcits lagcit2 lagcit3 lagcit4 lagcit5 lagcit6";
global expl_18 "age age2 tenure  female  months emp  i.vuosi i.sector  i.educ i.nuts2 pats lagcits lagcit2 lagcit3 lagcit4 lagcit5 lagcit6 lagcit7";

global expl_cg "nocits
cits10
cits20
cits30
topcits
lagnoc
 lag10c
 lag20c
 lag30c
 lagtopc
 lagnoc2
 lag10c2
 lag20c2
 lag30c2
 lagtopc2
 lagnoc3
 lag10c3
 lag20c3
 lag30c3
 lagtop3
 lagnoc4
 lag10c4
 lag20c4
 lag30c4
 lagtopc4
 lagnoc5
 lag10c5
 lag20c5
 lag30c5
 lagtopc5
lagnoc6
 lag10c6
 lag20c6
 lag30c6
 lagtopc6";

*-----------------------------------------------------------------------------------------------------;

*-----------------------------------------------------------------------------------------------------;
*ALL REGRESSIONS BEGIN HERE;
*-----------------------------------------------------------------------------------------------------;

*-----------------------------------------------------------------------------------------------------;

#delimit ;
sort id vuosi;

*-----------------------------------------------------------------------------------------------------;
*main specifications;
*-----------------------------------------------------------------------------------------------------;
*patent counts;


xi: reg logwage $expl_1, cluster(id);
xi: reg logwage $expl_2, cluster(id); /* TABLE 2 */
xi: reg logwage $expl_3, cluster(id);
xi: reg logwage $expl_4, cluster(id);
xi: reg logwage $expl_5, cluster(id);
xi: reg logwage $expl_6, cluster(id);
xi: reg logwage $expl_7, cluster(id); /* TABLE 3 */
xi: reg logwage $expl_8, cluster(id);


xi: xtreg logwage $expl_1, fe robust  ; /* TABLE 2 */
xi: xtreg logwage $expl_2, fe robust  ;
xi: xtreg logwage $expl_3, fe robust  ;
xi: xtreg logwage $expl_4, fe robust  ;
xi: xtreg logwage $expl_5, fe robust  ;
xi: xtreg logwage $expl_6, fe robust  ;
xi: xtreg logwage $expl_7, fe robust  ; /* TABLE 3 */
xi: xtreg logwage $expl_8, fe robust  ;


xi: reg D.(logwage $expl_1), vce(cluster id);
xi: reg D.(logwage $expl_2), vce(cluster id); /* TABLE 2 */
xi: reg D.(logwage $expl_3), vce(cluster id);
xi: reg D.(logwage $expl_4), vce(cluster id);
xi: reg D.(logwage $expl_5), vce(cluster id);
xi: reg D.(logwage $expl_6), vce(cluster id);
xi: reg D.(logwage $expl_7), vce(cluster id); /* TABLE 3 */
xi: reg D.(logwage $expl_8), vce(cluster id);


*-----------------------------------------------------;

*citations;

xi: reg logwage $expl_11, cluster(id);
xi: reg logwage $expl_12, cluster(id); 
xi: reg logwage $expl_13, cluster(id);
xi: reg logwage $expl_14, cluster(id);
xi: reg logwage $expl_15, cluster(id);
xi: reg logwage $expl_16, cluster(id);
xi: reg logwage $expl_17, cluster(id); /* TABLE 4 */
xi: reg logwage $expl_18, cluster(id);

xi: xtreg logwage $expl_11, fe robust  ;
xi: xtreg logwage $expl_12, fe robust  ;
xi: xtreg logwage $expl_13, fe robust  ;
xi: xtreg logwage $expl_14, fe robust  ;
xi: xtreg logwage $expl_15, fe robust  ;
xi: xtreg logwage $expl_16, fe robust  ;
xi: xtreg logwage $expl_17, fe robust  ; /* TABLE 4 */
xi: xtreg logwage $expl_18, fe robust  ;

xi: reg D.(logwage $expl_11), vce(cluster id);
xi: reg D.(logwage $expl_12), vce(cluster id); 
xi: reg D.(logwage $expl_13), vce(cluster id);
xi: reg D.(logwage $expl_14), vce(cluster id);
xi: reg D.(logwage $expl_15), vce(cluster id);
xi: reg D.(logwage $expl_16), vce(cluster id);
xi: reg D.(logwage $expl_17), vce(cluster id); /* TABLE 4 */
xi: reg D.(logwage $expl_18), vce(cluster id);

*citations as a categorical variable;
xi: xtreg logwage $expl_0 $expl_cg, fe robust  ; /* TABLE 5 */

*include tenure-squared;
xi: xtreg logwage $expl_7 tenure2, fe robust  ;
xi: xtreg logwage $expl_17 tenure2, fe robust  ;
*-----------------------------------------------------;
* tests of exogeneity using leads;

xi: xtreg logwage $expl_5 f.pats f2.pats, fe robust;
xi: xtreg logwage $expl_6 f.pats, fe robust;
xi: xtreg logwage $expl_7 f.pats, fe robust;

*-----------------------------------------------------;
*controlling for firm effects;
*-----------------------------------------------------;

*average firm wage;

xi: xtreg logwage $expl_7 firmwage, fe robust  ; /* TABLE 6 col 2 */
xi: xtreg logwage $expl_17 firmwage, fe robust  ; /* TABLE 7 col 2 */
xi: xtreg logwage $expl_0 $expl_cg firmwage, fe robust  ; /* TABLE 7 col 2 */

*firm patents;

xi: xtreg logwage $expl_7 firm_patcount lagfats lagfat2 lagfat3 lagfat4 lagfat5 lagfat6, fe robust  ; /* TABLE 6  col 1*/
 
*firm citations;

xi: xtreg logwage $expl_17 firm_citcount lagfits lagfit2 lagfit3 lagfit4 lagfit5 lagfit6, fe robust  ; /* TABLE 7 col 1 */
xi: xtreg logwage $expl_0 $expl_cg firm_citcount lagfits lagfit2 lagfit3 lagfit4 lagfit5 lagfit6, fe robust  ; /* TABLE 8 col 1 */


*sample for which RD intensity avaialble;

xi: xtreg logwage $expl_7 if rd_int!=., fe robust  ; /* TABLE 6 col 3 */
xi: xtreg logwage $expl_17 if rd_int!=.,  fe robust  ; /* TABLE 7  col 3 */
xi: xtreg logwage $expl_0 $expl_cg if rd_int!=.,  fe robust  ; /* TABLE 8  col 3 */

*with firm R&D intensity;
replace rd_int=0.0000001 if rd_int==0;
replace rd_int=log(rd_int);

xi: xtreg logwage $expl_7 rd_int, fe robust  ; /* TABLE 6 col 4*/
xi: xtreg logwage $expl_17 rd_int,  fe robust  ; /* TABLE 7 col 4 */
xi: xtreg logwage $expl_0 $expl_cg rd_int,  fe robust  ; /* TABLE 8 col 4 */


*-----------------------------------------------------------------------;
*individual assigned patents v firm assigned;
*-----------------------------------------------------------------------;

sum nocits if pats_indi!=0;
sum cits10 if pats_indi!=0;
sum cits20 if pats_indi!=0;
sum cits30 if pats_indi!=0;
sum topcits if pats_indi!=0;

sum nocits if pats_indi==0;
sum cits10 if pats_indi==0;
sum cits20 if pats_indi==0;
sum cits30 if pats_indi==0;
sum topcits if pats_indi==0;

gen patsff=pats-pats_indi;
gen lpatff=lagpats-lagpatsi;
gen lpatf2=lagpat2-lagpat2i;
gen lpatf3=lagpat3-lagpat3i;
gen lpatf4=lagpat4-lagpat4i;
gen lpatf5=lagpat5-lagpat5i;
gen lpatf6=lagpat6-lagpat6i;

gen citsff=cits-cits_indi;
gen lcitff=lagcits-lagcitsi;
gen lcitf2=lagcit2-lagcit2i;
gen lcitf3=lagcit3-lagcit3i;
gen lcitf4=lagcit4-lagcit4i;
gen lcitf5=lagcit5-lagcit5i;
gen lcitf6=lagcit6-lagcit6i;

/* TABLE 10 */
xi: xtreg logwage $expl_0 pats_indi lagpatsi lagpat2i lagpat3i lagpat4i lagpat5i lagpat6i patsff lpatff lpatf2 lpatf3 lpatf4 lpatf5 lpatf6, fe robust  ;
xi: xtreg logwage $expl_0 cits_indi lagcitsi lagcit2i lagcit3i lagcit4i lagcit5i lagcit6i citsff lcitff lcitf2 lcitf3 lcitf4 lcitf5 lcitf6, fe robust  ;

xi: xtreg logwage5 $expl_0 pats_indi lagpatsi lagpat2i lagpat3i lagpat4i lagpat5i lagpat6i patsff lpatff lpatf2 lpatf3 lpatf4 lpatf5 lpatf6, fe robust  ;
xi: xtreg logwage5 $expl_0 cits_indi lagcitsi lagcit2i lagcit3i lagcit4i lagcit5i lagcit6i citsff lcitff lcitf2 lcitf3 lcitf4 lcitf5 lcitf6, fe robust  ;



*-----------------------------------------------------;
*patent and citations as shares of inventor;
*-----------------------------------------------------;

/* TABLE 9 */
xi: xtreg logwage $expl_0 pats_share lagpsh lagpsh2 lagpsh3 lagpsh4 lagpsh5 lagpsh6, fe robust  ;
xi: xtreg logwage $expl_0 cits_share lagcsh lagcsh2 lagcsh3 lagcsh4 lagcsh5 lagcsh6, fe robust  ;


*-----------------------------------------------------;
*changes of employer;
*-----------------------------------------------------;

xi: xtreg logwage $expl_0 i.old|pats i.lagold|lagpats i.lagold2|lagpat2
i.lagold3|lagpat3 i.lagold4|lagpat4 i.lagold5|lagpat5 i.lagold6|lagpat6 
new lagnew lagnew2 lagnew3 lagnew4 lagnew5 lagnew6, fe robust;

xi: xtreg logwage $expl_0 i.old|cits i.lagold|lagcits i.lagold2|lagcit2
i.lagold3|lagcit3 i.lagold4|lagcit4 i.lagold5|lagcit5 i.lagold6|lagcit6 
new lagnew lagnew2 lagnew3 lagnew4 lagnew5 lagnew6, fe robust;


*-----------------------------------------------------;
*capital income;
*-----------------------------------------------------;
xi: xtreg logwage3 $expl_7, fe robust  ;
xi: xtreg logwage3 $expl_17, fe robust  ;
xi: xtreg logwage3 $expl_0 $expl_cg,  fe robust  ;

xi: xtreg logwage5 $expl_7, fe robust  ;
xi: xtreg logwage5 $expl_17, fe robust  ;
xi: xtreg logwage5 $expl_0 $expl_cg,  fe robust  ;

*-----------------------------------------------------;
*removing year 1999; /* SECTION 5.5. ROBUSTNESS TEST #1 */
*-----------------------------------------------------;
xi: xtreg logwage $expl_7 if vuosi!=1999, fe robust  ;
xi: xtreg logwage $expl_17 if vuosi!=1999, fe robust  ;
xi: xtreg logwage $expl_0 $expl_cg if vuosi!=1999,  fe robust  ;


*-----------------------------------------------------;
*removing employees at 3 big patenting firms; /* SECTION 5.5. ROBUSTNESS TEST #3 */
*-----------------------------------------------------;

xi: xtreg logwage $expl_7 if big_pat!=1, fe robust  ;
xi: xtreg logwage $expl_17 if if big_pat!=1, fe robust  ;
xi: xtreg logwage $expl_0 $expl_cg if if big_pat!=1,  fe robust  ;


*-----------------------------------------------------;
*sector differences; /* SECTION 5.5. ROBUSTNESS TEST #2 */
*-----------------------------------------------------;
destring sector, replace;

gen chemical=0;
replace chemical=1 if sector==24;

gen metal=0;
replace metal=1 if sector==28;

gen machinery=0;
replace machinery=1 if sector==29;

gen it=0;
replace it=1 if sector==32;

gen medic=0;
replace medic=1 if sector==33;


xi: xtreg logwage age age2 tenure female  months emp  i.vuosi 
i.chemical*pats i.machinery*pats i.metal*pats i.it*pats i.medic*pats 
i.chemical*lagpats i.machinery*lagpats i.metal*lagpats i.it*lagpats i.medic*lagpats
i.chemical*lagpat2 i.machinery*lagpat2 i.metal*lagpat2 i.it*lagpat2 i.medic*lagpat2
i.chemical*lagpat3 i.machinery*lagpat3 i.metal*lagpat3 i.it*lagpat3 i.medic*lagpat3
i.chemical*lagpat4 i.machinery*lagpat4 i.metal*lagpat4 i.it*lagpat4 i.medic*lagpat4
i.chemical*lagpat5 i.machinery*lagpat5 i.metal*lagpat5 i.it*lagpat5 i.medic*lagpat5
i.chemical*lagpat6 i.machinery*lagpat6 i.metal*lagpat6 i.it*lagpat6 i.medic*lagpat6
i.educ i.nuts2, fe robust;

xi: xtreg logwage age age2 tenure female  months emp  i.vuosi 
i.chemical*pats i.machinery*pats  i.it*pats i.medic*pats 
i.chemical*lagpats i.machinery*lagpats  i.it*lagpats i.medic*lagpats
i.chemical*lagpat2 i.machinery*lagpat2  i.it*lagpat2 i.medic*lagpat2
i.chemical*lagpat3 i.machinery*lagpat3  i.it*lagpat3 i.medic*lagpat3
i.chemical*lagpat4 i.machinery*lagpat4  i.it*lagpat4 i.medic*lagpat4
i.chemical*lagpat5 i.machinery*lagpat5  i.it*lagpat5 i.medic*lagpat5
i.chemical*lagpat6 i.machinery*lagpat6  i.it*lagpat6 i.medic*lagpat6
i.educ i.nuts2, fe robust;

*-----------------------------------------------------;
*gender differences; /* SECTION 5.5. ROBUSTNESS TEST #4 */
*-----------------------------------------------------;
xi: xtreg logwage age age2 tenure female  months emp  i.vuosi 
i.sp*pats i.sp*lagpats i.sp*lagpat2 i.sp*lagpat3 i.sp*lagpat4 i.sp*lagpat5 i.sp*lagpat6 i.sector i.educ i.nuts2, fe robust;

xi: xtreg logwage age age2 tenure female  months emp  i.vuosi 
i.sp*cits i.sp*lagcits i.sp*lagcit2 i.sp*lagcit3 i.sp*lagcit4 i.sp*lagcit5 i.sp*lagcit6 i.sector i.educ i.nuts2, fe robust;


*-----------------------------------------------------;
*add patent applications;
*-----------------------------------------------------;

xi: reg logwage $expl_1 pat_apps if vuosi<1997, cluster(id);
xi: xtreg logwage $expl_1 pat_apps if vuosi<1997, fe robust;

clear;

log close;
