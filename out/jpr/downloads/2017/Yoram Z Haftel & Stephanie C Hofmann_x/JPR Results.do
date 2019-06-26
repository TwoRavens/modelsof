 use "C:\Users\user\Dropbox\REOs and Security\Draft Summer 2015\JPR Final\Data Set Final.dta", clear
 
* Table 1 
* Model 1
oprobit desecurity2 lag_civilwar lag_delegation lag_concen lag_rival lag_mem rso_2 southx2, cluster(nbloc) robust
* Model 2
xi: oprobit desecurity2 lag_civilwar lag_delegation lag_concen lag_rival lag_mem rso_2 southx2 i.year, cluster(nbloc) robust
* Model 3
xi: oprobit desecurity2 lag_civilwar lag_delegation lag_concen lag_rival lag_contig rso_2 southx2 i.year,cluster(nbloc)robust
* Model 4
xi: oprobit desecurity2 lag_civilwar lag_delegation lag_concen lag_affinity lag_mem rso_2 southx2 i.year, cluster(nbloc) robust
* Model 5
xi: oprobit desecurity5 lag_civilwar lag_delegation lag_concen lag_rival lag_mem rso_2 southx2 i.year, cluster(nbloc) robust
* Model 6
xi: oprobit desecurity2 lag_civilwar lag_delegation lag_concen lag_rival lag_mem rso_2 southx2 i.year if bloc !="EU", cluster(nbloc) robust
* End Table 1 *

* Table 2 - substantive Interpretation 
* Use Model 1/Table 1 for estimating substative effects

oprobit desecurity2 lag_civilwar lag_delegation lag_concen lag_rival lag_mem rso_2 southx2, cluster(nbloc) robust

* Use Spost command prvalue to estimate substantive effects
* Substantive effect - delegation 
prvalue, x(lag_delegation=0.2) rest(mean)
prvalue, x(lag_delegation=0) rest(mean)

* Substantive effect - rivalry 
prvalue, x(lag_rival=1) rest(mean)
prvalue, x(lag_rival=0) rest(mean)

* Substantive effect - number of members 
prvalue, x(lag_mem=12.2 ) rest(mean)
prvalue, x(lag_mem=3.28 ) rest(mean)

* Substantive effect - South-South REOs 
prvalue, x(southx2=1 ) rest(mean)
prvalue, x(southx2=0 ) rest(mean)

* End of Table 2 **
