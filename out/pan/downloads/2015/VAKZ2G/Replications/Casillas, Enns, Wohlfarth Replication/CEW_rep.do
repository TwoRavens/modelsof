*** Grant Lebo Replication -- Cassillas, Enns, Wohlfarth
use "dir/CEW_rep.dta"
******************
** Main Article **
******************

***********
* Table 8 *
***********
dfuller all_rev, reg
dfuller nosal_rev, reg
dfuller sal_rev, reg
arfima d.all_rev
arfima d.nosal_rev


***********
* Table 9 * 
***********

*see CEW_MCrep.do

***********
* Table 10 * 
***********

* Column 1 * 

ivreg2 d.all_rev l.all_rev d.tornadod l.tornadod d.sharks l.sharks (d.beef l.beef = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality), first

* Long Run Multipliers * 

matrix b = e(b)
matrix V = e(V)
* Long Run Multiplier
* Lag of beef
scalar a2 = b[1,2]
* Lag of Sharks
scalar a7 = b[1,7]
* ECM
scalar b1 = b[1,3]
*Variances
scalar vara2 = V[2,2]
scalar vara7 = V[7,7]
scalar varb1 = V[3,3]
* Covariances
scalar cova2b1 = V[2,3]
scalar cova7b1 = V[7,3]

*s.e. for Beef
dis sqrt((1/b1^2)*vara2 + (a2^2/b1^4)*varb1 - 2*(a2/b1^3)*cova2b1)
* s.e. for sharks
dis sqrt((1/b1^2)*vara7 + (a7^2/b1^4)*varb1 - 2*(a7/b1^3)*cova7b1)

* Column 2 * 

ivreg2 d.nosal_rev l.nosal_rev d.tornadod l.tornadod d.sharks l.sharks (d.beef l.beef = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality), first

matrix b = e(b)
matrix V = e(V)
* Long Run Multiplier
* Lag of beef
scalar a2 = b[1,2]
* Lag of Sharks
scalar a7 = b[1,7]
* ECM
scalar b1 = b[1,3]
*Variances
scalar vara2 = V[2,2]
scalar vara7 = V[7,7]
scalar varb1 = V[3,3]
* Covariances
scalar cova2b1 = V[2,3]
scalar cova7b1 = V[7,3]

*s.e. for Beef
dis sqrt((1/b1^2)*vara2 + (a2^2/b1^4)*varb1 - 2*(a2/b1^3)*cova2b1)
* s.e. for sharks
dis sqrt((1/b1^2)*vara7 + (a7^2/b1^4)*varb1 - 2*(a7/b1^3)*cova7b1)

* Column 3 * 

ivreg2 d.sal_rev l.sal_rev d.tornadod l.tornadod d.sharks l.sharks (d.beef l.beef = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality), first

matrix b = e(b)
matrix V = e(V)
* Long Run Multiplier
* Lag of beef
scalar a2 = b[1,2]
* Lag of Sharks
scalar a7 = b[1,7]
* ECM
scalar b1 = b[1,3]
*Variances
scalar vara2 = V[2,2]
scalar vara7 = V[7,7]
scalar varb1 = V[3,3]
* Covariances
scalar cova2b1 = V[2,3]
scalar cova7b1 = V[7,3]

*s.e. for Beef
dis sqrt((1/b1^2)*vara2 + (a2^2/b1^4)*varb1 - 2*(a2/b1^3)*cova2b1)
* s.e. for sharks
dis sqrt((1/b1^2)*vara7 + (a7^2/b1^4)*varb1 - 2*(a7/b1^3)*cova7b1)

***********
* Table 11 * 
***********
* Create residuals through level regression 
reg all_rev mood
predict res, r
reg all_rev zsc_med
predict res2, r

reg nosal_rev mood
predict nores, r
reg nosal_rev zsc_med
predict nores2, r

reg sal_rev mood
predict salres, r
reg sal_rev zsc_med
predict salres2, r
reg sal_rev zmq_med
predict salres3, r

* fractionally difference DVs
arfima d.all_rev
predict dall_revf, fdiff
arfima d.nosal_rev
predict dnosal_revf, fdiff
arfima sal_rev
predict sal_revf, fdiff

* fractionally difference IVs
arfima d.mood
predict dmoodf, fdiff
arfima d.zsc_med
predict dzscf, fdiff
arfima d.zmq_med
predict dzmqf, fdiff

* fractionally difference ECMs
arfima d.res
predict resf, r
arfima res2
predict res2f, r

arfima d.nores
predict noresf, r
arfima nores2
predict nores2f, r

arfima salres
predict salresf, r
arfima salres2
predict salres2f, r
arfima salres3
predict salres3f, r

* column 1
reg dall_revf dmoodf dzscf dzmqf l.resf
* column 2
reg dall_revf dmoodf dzscf dzmqf l.res2f
* column 3
reg dnosal_revf dmoodf dzscf dzmqf l.noresf
* column 4
reg dnosal_revf dmoodf dzscf dzmqf l.nores2f
* column 5
reg sal_revf dmoodf dzscf dzmqf

***********
* Table 12 * 
***********
* Bounds from Narayan (2005) for k=3 T=45 at 5% (3.535 4.733)
* All Reviews
reg d.all_rev l.all_rev l.d.all_rev d.mood l.mood d.zsc_med l.zsc_med d.zmq_med l.zmq_med
bgodfrey, lags(1/3)
hettest
actest, lags(3)
* Block F-test
test l.all_rev l.mood l.zsc_med l.zmq_med
* F = 3.19 

* Non-Salient Reviews
reg d.nosal_rev l.nosal_rev l.d.nosal_rev d.mood l.mood d.zsc_med l.zsc_med d.zmq_med l.zmq_med
bgodfrey, lags(1/3)
hettest
actest, lags(3) robust
* Block F-test
test l.nosal_rev l.mood l.zsc_med l.zmq_med
* F = 2.54

****************
** Supplement **
****************

*************
* Table C.1 * 
*************

*All Reversals*
ivregress 2sls d.all_rev l.all_rev d.mood l.mood d.zsc_med l.zsc_med (d.zmq_med l.zmq_med = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality)

* LRM of Public Mood
dis _b[l.mood]/_b[l.all_rev]
* LRM of Court Ideology
dis _b[l.zsc_med]/_b[l.all_rev]

* generic SE equation is square root of variance
dis sqrt((1/b1^2)*vara2 + (a2^2/b1^4)*varb1 - 2*(a2/b1^3)*cova2b1)

matrix b = e(b)
matrix V = e(V)

*Lag of Mood 
scalar a5 = b[1,5]
*Lag of Court Ideology
scalar a7 = b[1,7]
* ECM 
scalar b1 = b[1,3]
*Variances
scalar vara5 = V[5,5]
scalar vara7 = V[7,7]
scalar varb1 = V[3,3]
* Covariances
scalar cova5b1 = V[5,3]
scalar cova7b1 = V[7,3]

*s.e. for LRM of mood
dis sqrt((1/b1^2)*vara5 + (a5^2/b1^4)*varb1 - 2*(a5/b1^3)*cova5b1)
*s.e. for LRM of ideology
dis sqrt((1/b1^2)*vara7 + (a7^2/b1^4)*varb1 - 2*(a7/b1^3)*cova7b1)


* Non-Salient Reversals* 
ivregress 2sls d.nosal_rev l.nosal_rev d.mood l.mood d.zsc_med l.zsc_med (d.zmq_med l.zmq_med = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality)

matrix b = e(b)
matrix V = e(V)

*Lag of Mood 
scalar a5 = b[1,5]
*Lag of Court Ideology
scalar a7 = b[1,7]
* ECM 
scalar b1 = b[1,3]
*Variances
scalar vara5 = V[5,5]
scalar vara7 = V[7,7]
scalar varb1 = V[3,3]
* Covariances
scalar cova5b1 = V[5,3]
scalar cova7b1 = V[7,3]

*s.e. for LRM of mood
dis sqrt((1/b1^2)*vara5 + (a5^2/b1^4)*varb1 - 2*(a5/b1^3)*cova5b1)
*s.e. for LRM of ideology
dis sqrt((1/b1^2)*vara7 + (a7^2/b1^4)*varb1 - 2*(a7/b1^3)*cova7b1)

* Salient Reversals*
ivregress 2sls d.sal_rev l.sal_rev d.mood l.mood d.zsc_med l.zsc_med (d.zmq_med l.zmq_med = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality)

matrix b = e(b)
matrix V = e(V)

*Lag of Mood 
scalar a2 = b[1,2]
*Lag of Court Ideology
scalar a7 = b[1,7]
* ECM 
scalar b1 = b[1,3]
*Variances
scalar vara2 = V[2,2]
scalar vara7 = V[7,7]
scalar varb1 = V[3,3]
* Covariances
scalar cova2b1 = V[2,3]
scalar cova7b1 = V[7,3]

*s.e. for LRM of Social Forces
dis sqrt((1/b1^2)*vara2 + (a2^2/b1^4)*varb1 - 2*(a2/b1^3)*cova2b1)
*s.e. for LRM of ideology
dis sqrt((1/b1^2)*vara7 + (a7^2/b1^4)*varb1 - 2*(a7/b1^3)*cova7b1)

*************
* Table C.2 * 
*************
ivreg2 d.all_rev l.all_rev d.mood l.mood d.zsc_med l.zsc_med (d.zmq_med l.zmq_med = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality), first

ivreg2 d.nosal_rev l.nosal_rev d.mood l.mood d.zsc_med l.zsc_med (d.zmq_med l.zmq_med = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality), first

ivreg2 d.sal_rev l.sal_rev d.mood l.mood d.zsc_med l.zsc_med (d.zmq_med l.zmq_med = d.perchcpi d.unem d.policylib d.def_budg d.homicide d.inequality l.perchcpi l.unem l.policylib l.def_budg l.homicide l.inequality), first

*************
* Table C.3 * 
*************
reg d.all_rev l.all_rev d.mood l.mood d.zsc_med l.zsc_med d.zmq_med l.zmq_med

reg d.sal_rev l.sal_rev d.mood l.mood d.zsc_med l.zsc_med d.zmq_med l.zmq_med

reg d.nosal_rev l.nosal_rev d.mood l.mood d.zsc_med l.zsc_med d.zmq_med l.zmq_med

*************
* Table C.4 * 
*************
reg d.all_rev l.all_rev d.tornadod l.tornadod d.sharks l.sharks d.beef l.beef

reg d.sal_rev l.sal_rev d.tornadod l.tornadod d.sharks l.sharks d.beef l.beef

reg d.nosal_rev l.nosal_rev d.tornadod l.tornadod d.sharks l.sharks d.beef l.beef

*************
* Table C.5 * 
************* 
* This was done in RATS, STATA d estimates for CEW values can be found above 
* in Table 11 

