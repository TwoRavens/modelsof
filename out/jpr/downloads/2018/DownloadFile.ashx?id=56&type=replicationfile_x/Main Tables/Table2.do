*Author: Mitch Radtke and Hyeran Jo 
*Project: Fighting the Hydra (Table 2)
*Date Last Modified: December 1, 2017


*Opening up the Data
use "E:\Hyeran\Hydra\RR2\Replication\Data\RadtkeJo_JPR_Macro.dta", clear

*Set system directory

sysdir set PLUS "E:\Stata12\ado\plus"
sysdir set PERSONAL "E:\Stata12\ado\personal"


*Recode the adaptability scale to a 3-pt scale (Low, Medium, High) to ease estimation
recode adapt_scale_c (0=0) (1=0) (2=1) (3=1) (4=2), gen (adapt_3)

**Table 2***
nbreg bdbest_ucdp i.un_sanction##c.adapt_3 i.newid, robust
outreg2 using "E:\Hyeran\Hydra\RR2\Replication\Table 2.doc", dec(3)

nbreg bdbest_ucdp i.un_sanction##i.adapt_3 i.newid, robust
outreg2 using "E:\Hyeran\Hydra\RR2\Replication\Table 2.doc", dec(3) append

nbreg bdbest_ucdp i.un_sanction##i.adapt_3 rebelsupport_num_c rebstrength_num i.newid, robust
outreg2 using "E:\Hyeran\Hydra\RR2\Replication\Table 2.doc", dec(3) append

 
 
**Marginal effects [coefficients don't change if we go to split sample]***
nbreg bdbest_ucdp un_sanction i.newid if adapt_3==0, robust


**Change in Predicted Count (Fixed Effect set to MILF in 1990--217 deaths)
margins, dydx(un_sanction) at(528.newid==1)
*Effect: decrease of 214 deaths, CI: -379.06 to -49.66

**Change in Predicted Count (Fixed Effect set to SPLM/A in 2011--217 deaths)
nbreg bdbest_ucdp un_sanction i.newid if adapt_3==1, robust
margins, dydx(un_sanction) at(549.newid==1)
*Effect: decrease of 77.5 deaths, CI: -325.11 to 170.19


**Change in Predicted Count (Fixed Effect set to PUK---4 obs. average (280 deaths))
nbreg bdbest_ucdp un_sanction i.newid if adapt_3==2, robust
margins, dydx(un_sanction) at(423.newid==1)
*Effect: increase of 81 deaths, CI: rer to 224.36

***Effect size is going to be based on the fixed effect--try to keep that as close possible to the median value for the medium group (191) and only one obs for id. 
*PUK was the best I could do for high adaptability. Effect for high adaptablity likely overestimated a bit. 

twoway (scatter effect n, mcolor(black)) (rcap upper lower n, lcolor(black) vertical) if _n<=3, xtitle("Rebel Adaptability", height (5)) ytitle("Change in Predicted Battle Deaths", height(7)) graphr(fcolor(white)) xlabel(0 ""  1 "Low" 2 "Medium" 3 "High" 4 "") legend(off)


