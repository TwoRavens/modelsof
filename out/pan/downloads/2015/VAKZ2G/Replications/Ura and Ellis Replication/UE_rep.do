*** Grant Lebo Replication -- Ura and Ellis *** 

use "dir/UE_rep.dta"
****************
* Main Article *
****************

***********
* Table 13 * 
***********

reg d.demmood l.demmood d.onion1000 l.onion1000 d.beef l.beef d.coalemiss l.coalemiss d.sharks l.sharks d.tornadodeath l.tornadodeath
est store dem
reg d.repmood l.repmood d.onion1000 l.onion1000  d.beef l.beef d.coalemiss l.coalemiss d.sharks l.sharks d.tornadodeath l.tornadodeath
est store rep
suest dem rep

*** Test on whether coefficients are significantly different from each other
dis _b[dem_mean:l.demmood]-_b[rep_mean:l.repmood]
dis _b[dem_mean: d.onion1000]-_b[rep_mean: d.onion1000]
dis _b[dem_mean:l.onion1000]-_b[rep_mean:l.onion1000]
dis _b[dem_mean:d.beef]-_b[rep_mean:d.beef]
dis _b[dem_mean:l.beef]-_b[rep_mean:l.beef]
dis _b[dem_mean:d.coalemiss]-_b[rep_mean:d.coalemiss]
dis _b[dem_mean:l.coalemiss]-_b[rep_mean:l.coalemiss]
dis _b[dem_mean:d.cumsharks]-_b[rep_mean:d.cumsharks]
dis _b[dem_mean:l.cumsharks]-_b[rep_mean:l.cumsharks]
dis _b[dem_mean:d.tfatal]-_b[rep_mean:d.tfatal]
dis _b[dem_mean:l.tfatal]-_b[rep_mean:l.tfatal]


test _b[dem_mean:l.demmood]=_b[rep_mean:l.repmood]
test _b[dem_mean: d.onion1000]=_b[rep_mean: d.onion1000]
test _b[dem_mean:l.onion1000]=_b[rep_mean:l.onion1000]
test _b[dem_mean:d.beef]=_b[rep_mean:d.beef]
test _b[dem_mean:l.beef]=_b[rep_mean:l.beef]
test _b[dem_mean:d.coalemiss]=_b[rep_mean:d.coalemiss]
test _b[dem_mean:l.coalemiss]=_b[rep_mean:l.coalemiss]
test _b[dem_mean:d.cumsharks]=_b[rep_mean:d.cumsharks]
test _b[dem_mean:l.cumsharks]=_b[rep_mean:l.cumsharks]
test _b[dem_mean:d.tfatal]=_b[rep_mean:d.tfatal]
test _b[dem_mean:l.tfatal]=_b[rep_mean:l.tfatal]

*** Creation of Long Run Multipliers
dis _b[dem_mean:l.onion1000]/_b[dem_mean:l.demmood]
dis _b[dem_mean:l.beef]/_b[dem_mean:l.demmood]
dis _b[dem_mean:l.coalemiss]/_b[dem_mean:l.demmood]
dis _b[dem_mean:l.cumsharks]/_b[dem_mean:l.demmood]
dis _b[dem_mean:l.tfatal]/_b[dem_mean:l.demmood]

dis _b[rep_mean:l.onion1000]/_b[rep_mean:l.repmood]
dis _b[rep_mean:l.beef]/_b[rep_mean:l.repmood]
dis _b[rep_mean:l.coalemiss]/_b[rep_mean:l.repmood]
dis _b[rep_mean:l.cumsharks]/_b[rep_mean:l.repmood]
dis _b[rep_mean:l.tfatal]/_b[rep_mean:l.repmood]

dis _b[rep_mean:l.onion1000]/_b[rep_mean:l.repmood] - _b[dem_mean:l.onion1000]/_b[dem_mean:l.demmood]
dis _b[rep_mean:l.beef]/_b[rep_mean:l.repmood] - _b[dem_mean:l.beef]/_b[dem_mean:l.demmood]
dis _b[rep_mean:l.coalemiss]/_b[rep_mean:l.repmood] -  _b[dem_mean:l.coalemiss]/_b[dem_mean:l.demmood]
dis _b[rep_mean:l.cumsharks]/_b[rep_mean:l.repmood] - _b[dem_mean:l.cumsharks]/_b[dem_mean:l.demmood]
dis _b[rep_mean:l.tfatal]/_b[rep_mean:l.repmood] - _b[dem_mean:l.tfatal]/_b[dem_mean:l.demmood]

* SE of LRM is given by 
* Var(a/b) = (1/b^2)Var(a) + (a^2/b^4)Var(b) - 2(a/b^3)Cov(a,b)
*So l.variable are 3, 5, 7, 9, 11
*ECM is 1

matrix b = e(b)
matrix V = e(V)
* FOR DEMOCRATS -- 
scalar a3 = b[1,3]
scalar a5 = b[1,5]
scalar a7 = b[1,7]
scalar a9 = b[1,9]
scalar a11 = b[1,11]
scalar b1 = b[1,1]

scalar vara3=V[3,3]
scalar vara5=V[5,5]
scalar vara7=V[7,7]
scalar vara9=V[9,9]
scalar vara11=V[11,11]
scalar varb1=V[1,1]

scalar cova3b1=V[3,1]
scalar cova5b1=V[5,1]
scalar cova7b1=V[7,1]
scalar cova9b1=V[9,1]
scalar cova11b1=V[11,1]

* generic SE equation is square root of variance
dis sqrt((1/b1^2)*vara3 + (a3^2/b1^4)*varb1 - 2*(a3/b1^3)*cova3b1)


* ------

* FOR REPUBLICANS ----- ECM is b14
scalar b14 = b[1,14]
scalar a16 = b[1,16]
scalar a18 = b[1,18]
scalar a20 = b[1,20]
scalar a22 = b[1,22]
scalar a24 = b[1,24]

scalar varb14 = V[14,14]
scalar vara16 = V[16,16]
scalar vara18 = V[18,18]
scalar vara20 = V[20,20]
scalar vara22 = V[22,22]
scalar vara24 = V[24,24]

scalar cova16b14=V[16,14]
scalar cova18b14=V[18,14]
scalar cova20b14=V[20,14]
scalar cova22b14=V[22,14]
scalar cova24b14=V[24,14]
* generic SE equation is square root of variance
dis sqrt((1/b14^2)*vara3 + (a3^2/b14^4)*varb14 - 2*(a3/b14^3)*cova3b14)

************
* Table 14 * 
************

* Democrats
reg demmood domestic10b 
* calculate residuasl
predict dres1, r 
reg demmood defense10b
predict dres2, r 
reg demmood inflation 
predict dres3, r 
reg demmood unemployment 
predict dres4, r 
reg demmood top1share 
predict dres5, r 

* Republicans
reg repmood domestic10b 
predict rres1, r 
reg repmood defense10b
predict rres2, r 
reg repmood inflation 
predict rres3, r 
reg repmood unemployment 
predict rres4, r 
reg repmood top1share 
predict rres5, r 

* 3 step ECM - first fractionally difference (do this for all IVs, DVs, and residuals)
arfima d.demmood
predict dv, fdifference
arfima d.repmood
predict rdv, fdifference
arfima d.domestic
predict iv1, fdiff
arfima d.defense
predict iv2, fdiff
arfima d.inflation
predict iv3, fdiff
arfima d.unemployment
predict iv4, fdiff
arfima d.top1share
predict iv5, fdiff

* Dem residuals
arfima d.dres1
predict dres1f, fdiff
arfima d.dres2
predict dres2f, fdiff
arfima d.dres3
predict dres3f, fdiff
arfima d.dres4 
predict dres4f, fdiff
arfima d.dres5
predict dres5f, fdiff

*Rep residuals
arfima d.rres1
predict rres1f, fdiff
arfima d.rres2
predict rres2f, fdiff
arfima d.rres3
predict rres3f, fdiff
arfima d.rres4 
predict rres4f, fdiff
arfima d.rres5
predict rres5f, fdiff

* 3 step FECM (DEM) - lag of fractionally differenced residuals with all other FI var
reg dv iv1 iv2 iv3 iv4 iv5 l.dres5f
* 3 step FECM (REP) - lag of fractionally differenced residuals with all other FI var
reg rdv iv1 iv2 iv3 iv4 iv5 l.rres5f
* NOTE: rest of FECM estimates are found below in code for Tables D.4 and D.5

**************
* Supplement * 
**************

*************
* Table D.1 *
*************

reg d.demmood l.demmood d.domestic10b l.domestic10b d.defense10b l.defense10b d.top1share l.top1share d.inflation l.inflation d.unemployment l.unemployment
est store dem
reg d.repmood l.repmood d.domestic10b l.domestic10b d.defense10b l.defense10b d.top1share l.top1share d.inflation l.inflation d.unemployment l.unemployment
est store rep
suest dem rep

*Recover variance-covariance matrix from SER estimation for computing the standard errors of the model's LRMs.
matrix list e(V)
matrix b = e(b)
matrix V = e(V)

*So l.variable are 3, 5, 7, 9, 11
*ECM is 1
scalar a3 = b[1,3]
scalar a5 = b[1,5]
scalar a7 = b[1,7]
scalar a9 = b[1,9]
scalar a11 = b[1,11]
scalar b1 = b[1,1]

scalar vara3=V[3,3]
scalar vara5=V[5,5]
scalar vara7=V[7,7]
scalar vara9=V[9,9]
scalar vara11=V[11,11]
scalar varb1=V[1,1]

scalar cova3b1=V[3,1]
scalar cova5b1=V[5,1]
scalar cova7b1=V[7,1]
scalar cova9b1=V[9,1]
scalar cova11b1=V[11,1]

* generic SE equation is square root of variance
dis sqrt((1/b1^2)*vara3 + (a3^2/b1^4)*varb1 - 2*(a3/b1^3)*cova3b1)


*** Test on whether coefficients are significantly different from each other
dis _b[dem_mean:l.demmood]-_b[rep_mean:l.repmood]
dis _b[dem_mean: d.domestic10b]-_b[rep_mean: d.domestic10b]
dis _b[dem_mean:l.domestic10b]-_b[rep_mean:l.domestic10b]
dis _b[dem_mean:d.defense10b]-_b[rep_mean:d.defense10b]
dis _b[dem_mean:l.defense10b]-_b[rep_mean:l.defense10b]
dis _b[dem_mean:d.top1share]-_b[rep_mean:d.top1share]
dis _b[dem_mean:d.inflation]-_b[rep_mean:d.inflation]
dis _b[dem_mean:l.inflation]-_b[rep_mean:l.inflation]
dis _b[dem_mean:d.unemployment]-_b[rep_mean:d.unemployment]
dis _b[dem_mean:l.unemployment]-_b[rep_mean:l.unemployment]


test _b[dem_mean:l.demmood]=_b[rep_mean:l.repmood]
test _b[dem_mean: d.domestic10b]=_b[rep_mean: d.domestic10b]
test _b[dem_mean:l.domestic10b]=_b[rep_mean:l.domestic10b]
test _b[dem_mean:d.defense10b]=_b[rep_mean:d.defense10b]
test _b[dem_mean:l.defense10b]=_b[rep_mean:l.defense10b]
test _b[dem_mean:d.top1share]=_b[rep_mean:d.top1share]
test _b[dem_mean:d.inflation]=_b[rep_mean:d.inflation]
test _b[dem_mean:l.inflation]=_b[rep_mean:l.inflation]
test _b[dem_mean:d.unemployment]=_b[rep_mean:d.unemployment]
test _b[dem_mean:l.unemployment]=_b[rep_mean:l.unemployment]

*** Creation of Long Run Multipliers
dis _b[dem_mean:l.domestic10b]/_b[dem_mean:l.demmood]
dis _b[dem_mean:l.domestic10b]/_b[dem_mean:l.demmood]
dis _b[dem_mean:l.domestic10b]/_b[dem_mean:l.demmood]
dis _b[dem_mean:l.domestic10b]/_b[dem_mean:l.demmood]
dis _b[dem_mean:l.domestic10b]/_b[dem_mean:l.demmood]

*************
* Table D.2 *
*************
 
* see UE_MCrep.do
 
*************
* Table D.3 *
*************
* d estimates come from Table 14 above

**********************
* Tables D.4 and D.5 * 
**********************
* using all residuals and FI variables from Table 14, above
* Democrats
reg dv iv1 iv2 iv3 iv4 iv5 l.dres1f
reg dv iv1 iv2 iv3 iv4 iv5 l.dres2f
reg dv iv1 iv2 iv3 iv4 iv5 l.dres3f
reg dv iv1 iv2 iv3 iv4 iv5 l.dres4f
* Republicans
reg rdv iv1 iv2 iv3 iv4 iv5 l.rres1f
reg rdv iv1 iv2 iv3 iv4 iv5 l.rres2f
reg rdv iv1 iv2 iv3 iv4 iv5 l.rres3f
reg rdv iv1 iv2 iv3 iv4 iv5 l.rres4f

***************************
* Tables D.6, D.7 and D.8 *
***************************
** Nonsense FECM 

reg demmood onion1000 
* calculate residuasl
predict dnonres1, r 
reg demmood coalemiss
predict dnonres2, r 
reg demmood beef 
predict dnonres3, r 
reg demmood sharks 
predict dnonres4, r 
reg demmood tornadod 
predict dnonres5, r 

reg repmood onion1000 
predict rnonres1, r 
reg repmood coalemiss
predict rnonres2, r 
reg repmood beef 
predict rnonres3, r 
reg repmood sharks 
predict rnonres4, r 
reg repmood tornadod 
predict rnonres5, r 

* Dem Nonsense residuals
arfima d.dnonres1
predict dnonres1f, fdiff
arfima d.dnonres2
predict dnonres2f, fdiff
arfima d.dnonres3
predict dnonres3f, fdiff
arfima d.dnonres4 
predict dnonres4f, fdiff
arfima d.dnonres5
predict dnonres5f, fdiff

*Rep Nonsense residuals
arfima d.rnonres1
predict rnonres1f, fdiff
arfima d.rnonres2
predict rnonres2f, fdiff
arfima d.rnonres3
predict rnonres3f, fdiff
arfima d.rnonres4 
predict rnonres4f, fdiff
arfima d.rnonres5
predict rnonres5f, fdiff

* Fractionally difference

arfima d.demmood
predict dv, fdifference
arfima d.repmood
predict rdv, fdifference

arfima d.onion1000
predict niv1, fdiff
arfima d.coalemiss
predict niv2, fdiff
arfima d.beef
predict niv3, fdiff
arfima d.sharks
predict niv4, fdiff
arfima d.tornado, iterate(35)
predict niv5, fdiff

* Democrats
reg dv niv1 niv2 niv3 niv4 niv5 l.dnonres1f
reg dv niv1 niv2 niv3 niv4 niv5 l.dnonres2f
reg dv niv1 niv2 niv3 niv4 niv5 l.dnonres3f
reg dv niv1 niv2 niv3 niv4 niv5 l.dnonres4f
reg dv niv1 niv2 niv3 niv4 niv5 l.dnonres5f
* Republicans
reg rdv niv1 niv2 niv3 niv4 niv5 l.rnonres1f
reg rdv niv1 niv2 niv3 niv4 niv5 l.rnonres2f
reg rdv niv1 niv2 niv3 niv4 niv5 l.rnonres3f
reg rdv niv1 niv2 niv3 niv4 niv5 l.rnonres4f
reg rdv niv1 niv2 niv3 niv4 niv5 l.rnonres5f

*************
* Table D.9 *
*************
reg d.demmood l.demmood
reg d.demmood l.demmood d.unemp l.unemp
reg d.demmood l.demmood d.unemp l.unemp d.domestic l.domestic
reg d.demmood l.demmood d.unemp l.unemp d.domestic l.domestic d.inflation l.inflation
reg d.demmood l.demmood d.unemp l.unemp d.domestic l.domestic d.inflation l.inflation d.top1 l.top1
reg d.demmood l.demmood d.unemp l.unemp d.domestic l.domestic d.inflation l.inflation d.top1 l.top1 d.defense l.defense
