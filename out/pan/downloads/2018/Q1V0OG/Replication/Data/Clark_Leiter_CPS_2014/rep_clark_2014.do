
/**Variables**

*DV: votechgtt1: change in vote share from time t-1 to time t

*IVs: votechgt1t2: lagged change in vote share
*     cgscn2tt1: change in combined valence score of party from t-1 to t
*     partydispuw: change in party system dispersion (unweighted by party size) from t-1 to t
*     valbydispuw: interaction of change in valence and change in disperison
*     ingovt_mc: Dummy if party is in gov't
*     partnum: unique party number identifiying party
*     electnum: unique election number identifying inter-electoral period
*     country: name of country
*     year: election year
*     period: election period analysed (range from t-1 to t)
*     party: name of party
*     scantwo: party's valence at time t
*/

cd "~/Dropbox (MIT)/Interaction Paper/Data/Included/Clark_Leiter_CPS_2014"
use "clark_leiter_cps2014", clear

xtset partnum electnum

/**model 1**/
xtreg votechgtt1 votechgt1t2 cgscn2tt1 , fe robust

/**model 2**/
xtreg votechgtt1 votechgt1t2 cgscn2tt1 ingovt_mc partydispuw valbydispuw , fe robust

keep if e(sample)==1

areg votechgtt1, a(partnum)
predict res_votechgtt1, res

saveold "rep_clark_2014", replace

