
*****************************************************
** Main Results 
*****************************************************

*****************************************************
** Table 1
*****************************************************

clear
set more off

use "~/services_admin_tscs.dta"

xtset ccodecow

global controls "lpop_l wdi_urban_l lgdppc_l conflict_l dpi_state_l p_polity2_l loilpc_l aid_pc_l"


gen quinq5 = 1 if year==1970 | year==1975 | year==1980 | year==1985 | year==1990 | year==1995 | year==2000 | year==2005 | year==2010


keep if region_x=="Sub-Saharan Africa"
fvset base 2000 year

xtreg ServicesA $controls adminpc_l5 adminpc2_l5 i.year,fe r cluster(ccodecow)
est store A
xtreg ServicesA $controls ladminpc_l5 i.year,fe r cluster(ccodecow)
est store B 
ivregress 2sls ServicesA $controls al_ethnic i.year (adminpc_l5 adminpc2_l5=lmeanMINUSi_adminpc_l6 lmeanMINUSi_adminpc2_l6 herf herf2 llength llength2), r cluster(ccodecow)
est store C
ivregress 2sls ServicesA $controls al_ethnic i.year (ladminpc_l5=lmeanMINUSi_adminpc_l6 lmeanMINUSi_adminpc2_l6 herf herf2 llength llength2), r cluster(ccodecow)
est store D
xtreg ServicesCA $controls adminpc_l5 adminpc2_l5 i.year,fe r cluster(ccodecow)
est store E
xtreg ServicesCA $controls ladminpc_l5 i.year,fe r cluster(ccodecow)
est store F 
ivregress 2sls ServicesCA $controls al_ethnic i.year (adminpc_l5 adminpc2_l5=lmeanMINUSi_adminpc_l6 lmeanMINUSi_adminpc2_l6 herf herf2 llength llength2), r cluster(ccodecow)
est store G
ivregress 2sls ServicesCA $controls al_ethnic i.year (ladminpc_l5=lmeanMINUSi_adminpc_l6 lmeanMINUSi_adminpc2_l6 herf herf2 llength llength2), r cluster(ccodecow)
est store H
esttab A B C D E F G H using "Analysis/tables/main_table.tex", replace cells(b(star fmt(3)) se(par fmt(3))) scalars(N ll aic bic) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) label title("Fixed Effects and IV Models, Annual") mtitles("Main, FE" "Main, FE" "Main, IV" "Main, IV" "Ext, FE" "Ext, FE" "Ext, IV" "Ext, IV")
eststo clear


*****************************************************
** Table 2
*****************************************************

clear
set more off

use "~SubnationalData.dta"

xtset mid
global controls singlebirth gender moth_age moth_agesq prevsib24 birthorder birthordersq

*** Malawi ***
foreach y in  infantmort childmort {

xtreg `y' $controls i.year i.TR if (split1!=2 & Country=="Malawi") , fe vce (cluster mid)
xtreg `y' $controls i.year time_splinter if (split1!=2 & Country=="Malawi") , fe vce (cluster mid)
*Drop all years post 2003 [the second wave of splits begins in 2003]
xtreg `y' $controls i.year i.TR if (split1!=2 & Country=="Malawi" & year<2003) , fe vce (cluster mid)

*** Nigeria ***
xtreg `y' $controls i.year i.TR if (split1!=2 & Country=="Nigeria") , fe vce (cluster mid)
xtreg `y' $controls i.year time_splinter if (split1!=2 & Country=="Nigeria") , fe vce (cluster mid)
*Drop all years post 1996 [there were 2 splits in 1987 and then a wave of splits in 1991, followed by a waves of splits in 1996]
xtreg `y' $controls i.year i.TR if (split1!=2 & Country=="Nigeria" & year<1996) , fe vce (cluster mid)

*** Uganda ***
xtreg `y' $controls i.year i.TR_S if (TRM!=1 & Country=="Uganda") , fe  vce (cluster mid)
xtreg `y' $controls i.year time_splinter  if (TRM~=1 & Country=="Uganda"), fe vce (cluster mid)
*Drop all years post 2005 [the third wave of splits begins in 2005]
xtreg `y' $controls i.year i.TR_S if (TRM!=1 & Country=="Uganda" & year<2005), fe   vce (cluster mid)

}

*****************************************************
** Figure 1 - Part 1 [Part 2 found in Main_Results_Replication_R.R]
*****************************************************
clear
set more off

use "~/services_admin_tscs.dta"
xtset ccodecow

global controls "lpop_l wdi_urban_l lgdppc_l conflict_l dpi_state_l p_polity2_l loilpc_l aid_pc_l"


gen quinq5 = 1 if year==1970 | year==1975 | year==1980 | year==1985 | year==1990 | year==1995 | year==2000 | year==2005 | year==2010


keep if region_x=="Sub-Saharan Africa"
fvset base 2000 year

* Output estimates and variance-covariance matrix to create figures in R
xtreg ServicesCA $controls admin_l5 admin2_l5 i.year,fe r cluster(ccodecow)
matrix list e(V)
matrix COV = get(VCE)
mat2txt, matrix(COV) saving(covariance)

xtreg ServicesCA $controls admin_l5 admin2_l5 i.year,fe r cluster(ccodecow)
parmest, saving(coefs)

*****************************************************
** Figure 2
*****************************************************
clear
set more off

use "~SubnationalData.dta"

egen uniqueid = concat(motherid DHSYEAR birthorder)
egen id=group(uniqueid)

xtset id year
keep if (year > 1980)


*** Infant Mortality ***
egen averageimw0 = mean(infantmort) if (initialsplit==0), by(year Country)
egen averageimw1 = mean(infantmort) if (initialsplit==1), by(year Country)
egen averageimw2 = mean(infantmort) if (initialsplit==2), by(year Country)

*** Child Mortality ***
egen averagecmw0 = mean(childmort) if (initialsplit==0), by(year Country)
egen averagecmw1 = mean(childmort) if (initialsplit==1), by(year Country)
egen averagecmw2 = mean(childmort) if (initialsplit==2), by(year Country)

*** Malawi ***
#delimit;
graph twoway (lpolyci infantmort year if (initialsplit==0 & Country=="Malawi")) 
(lpolyci infantmort year if (initialsplit==1 & Country=="Malawi"), lpattern(dash) ciplot(rspike)),  name (MalawiIM1)
tline(1998, lwidth(medium) lcolor(red)) tline(2003, lwidth(medium) lcolor(red)) 
title(Malawi) subtitle(Infant Mortality)
xtitle (Year of Birth) ylab(, grid) 
legend(off) scheme(s1mono);
#delimit cr

#delimit;
graph twoway (lpolyci childmort year if (initialsplit==0 & Country=="Malawi")) 
(lpolyci childmort year if (initialsplit==1 & Country=="Malawi"), lpattern(dash) ciplot(rspike)),  name(MalawiCM1)
tline(1998, lwidth(medium) lcolor(red)) tline(2003, lwidth(medium) lcolor(red)) 
title(Malawi) subtitle(Child Mortality)
xtitle (Year of Birth) ylab(, grid) 
legend(off) scheme(s1mono);
#delimit cr

*** Nigeria ***

#delimit;
graph twoway (lpolyci infantmort year if (initialsplit==0 & Country=="Nigeria")) 
(lpolyci infantmort year if (initialsplit==1  & Country=="Nigeria"), lpattern(dash) ciplot(rspike)), name (NigeriaIM1)
tline(1987, lwidth(medium) lcolor(red)) tline(1991, lwidth(medium) lcolor(red)) tline(1996, lwidth(medium) lcolor(red)) 
title(Nigeria) subtitle(Infant Mortality)
xtitle (Year of Birth) ylab(, grid) 
legend(off) scheme(s1mono);
#delimit cr


#delimit;
graph twoway (lpolyci childmort year if (initialsplit==0 & Country=="Nigeria")) 
(lpolyci childmort year if (initialsplit==1 & Country=="Nigeria"), lpattern(dash) ciplot(rspike)), name (NigeriaCM1)
tline(1987, lwidth(medium) lcolor(red)) tline(1991, lwidth(medium) lcolor(red)) tline(1996, lwidth(medium) lcolor(red)) 
title(Nigeria) subtitle(Child Mortality)
xtitle (Year of Birth) ylab(, grid) 
legend(off) scheme(s1mono);
#delimit cr

***Uganda ***

#delimit;
graph twoway (lpolyci infantmort year if (initialsplit==0 & Country=="Uganda")) 
(lpolyci infantmort year if (initialsplit==1 & Country=="Uganda"), lpattern(dash) ciplot(rspike)),  name (UgandaIM1)
tline(1997, lwidth(medium) lcolor(red)) tline(2000, lwidth(medium) lcolor(red)) tline(2005, lwidth(medium) lcolor(red)) tline(2009, lwidth(medium) lcolor(red)) 
title(Uganda) subtitle(Infant Mortality)
xtitle (Year of Birth) ylab(, grid) 
legend(off) scheme(s1mono);
#delimit cr


#delimit;
graph twoway (lpolyci childmort year if (initialsplit==0 & Country=="Uganda")) 
(lpolyci childmort year if (initialsplit==1 & Country=="Uganda"), lpattern(dash) ciplot(rspike)), name (UgandaCM1)
tline(1997, lwidth(medium) lcolor(red)) tline(2000, lwidth(medium) lcolor(red)) tline(2005, lwidth(medium) lcolor(red)) tline(2009, lwidth(medium) lcolor(red)) 
title(Uganda) subtitle(Child Mortality)
xtitle (Year of Birth) ylab(, grid) 
legend(off) scheme(s1mono);
#delimit cr

graph combine MalawiIM1 NigeriaIM1 UgandaIM1 MalawiCM1 NigeriaCM1 UgandaCM1
