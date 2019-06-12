*/ Replication file for Signing River Treaties -- Does it Improve Cooperation/*

*/Data sources: 
*/River data: Brochmann and Gleditsch 2011. Forthcoming. 
*/ Water events: Manually coded from http://ocid.nacse.org/tfdd/internationalEvents.php. Available in dyadic form from author
*/ River treaties: Manually coded from http://ocid.nacse.org/tfdd/treaties.php. Available in dyadic form from author
*/ The rivalry variable is from Klein, Goertz & Diehl (2006): The New Rivalry Dataset: Procedures and Patterns. 
Journal of Peace Research 43(3). Available at http://prio.no/Research-and-Publications/Journal-of-Peace-Research/Replication-Data/Detail?oid=303792
*/Alliance data is collected from Gibler and Sarkees. (2004) 
Measuring Alliances: The Correlates of War Formal Interstate Alliance Data set, 1816-2000. Journal of Peace Research 41(2): 211-222.
Available at: http://www.correlatesofwar.org/
*/ The power and GDP variables are from the replication file of: Oneal and Russett. (2005) Rule of three, Let it be? When More Really Is Better. 
Conflict Management and Peace Science 22(4):293–310. Available from either http://www.yale.edu/unsy/democ/democ1.htm 
or www.bama.ua.edu/~joneal/CMPS2005
*/The remainder of the variables are from Hegre. (2008) Gravitating toward War. Preponderance May Pacify, but Power Kills.
Journal of Conflict Resolution 52(4): 566–589. Available at: http://www.prio.no/CSCW/Research-and-Publications/Publication/?oid=183044 

//* Tables and figures in the article*/

//* Figure 1. Probit analyses of the effect of signed treaties on cooperation over 20 years
probit w_coop treatlag if sharedbas == 1 & year > 1947
probit w_coop treatlag2 if sharedbas == 1 & year > 1947
probit w_coop treatlag3 if sharedbas == 1 & year > 1947
probit w_coop treatlag4 if sharedbas == 1 & year > 1947
probit w_coop treatlag5 if sharedbas == 1 & year > 1947
probit w_coop treatlag6 if sharedbas == 1 & year > 1947
probit w_coop treatlag7 if sharedbas == 1 & year > 1947
probit w_coop treatlag8 if sharedbas == 1 & year > 1947
probit w_coop treatlag9 if sharedbas == 1 & year > 1947
probit w_coop treatlag10 if sharedbas == 1 & year > 1947
probit w_coop treatlag11 if sharedbas == 1 & year > 1947
probit w_coop treatlag12 if sharedbas == 1 & year > 1947
probit w_coop treatlag13 if sharedbas == 1 & year > 1947
probit w_coop treatlag14 if sharedbas == 1 & year > 1947
probit w_coop treatlag15 if sharedbas == 1 & year > 1947
probit w_coop treatlag16 if sharedbas == 1 & year > 1947
probit w_coop treatlag17 if sharedbas == 1 & year > 1947
probit w_coop treatlag18 if sharedbas == 1 & year > 1947
probit w_coop treatlag19 if sharedbas == 1 & year > 1947
probit w_coop treatlag20 if sharedbas == 1 & year > 1947

//* Table 1. Descriptive statistics of all included variables 
summ w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv ///
lnbasinsi if year>=1948 & sharedbas == 1

//* Table 2. Estimation results: Single probit of water cooperation and bivariate probit model of water cooperation and treaty signing, 1948-1999

*/Table 2 -- final model */
probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & year <=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
biprobit (w_coop= treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi) if year >= 1948 & year <=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
 
*/ Table 2 with high_coop */
probit high_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & year <=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
biprobit (high_coop= treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi)if year >= 1948 & year<=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append

*/Testing with different lag structures -- Varying degrees of significance. Justyfiying the lag structure I have chosen*/
probit w_coop treatlag treatlag2 treatlag3 treatlag4 treatlag5 treatlag6 treatlag7 treatlag8 treatlag9 treatlag10 treatlag11 treatlag12 treatlag13 treatlag14 ///
allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
probit w_coop treatlag treatlag4_8 treatlag11_15 treatlag16_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append

*/Table 2 -- after Cold War */
probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1990 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
biprobit (w_coop= treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi) if year >= 1990 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
biprobit (high_coop= treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi)if year >= 1990 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append

*/Table 2 -- before 1990 -- more sig. here -- even 6 to 10 */
probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year <= 1990 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
biprobit (w_coop= treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi) if year <= 1990 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
biprobit (high_coop= treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi)if year <= 1990 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append

*/Table 2 with treaty already present in dyad - prev_treaty */
probit w_coop prev_treaty treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & year <=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
biprobit (w_coop= prev_treaty treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi) if year >= 1948 & year <=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
biprobit (high_coop= prev_treaty treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi)if year >= 1948 & year<=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append

*/Table2 with confldec rather than peace history*/
probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies confldec prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & year <=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
biprobit (w_coop= treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies confldec prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies confldec lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi) if year >= 1948 & year <=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
biprobit (high_coop= treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies confldec prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies confldec lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi)if year >= 1948 & year<=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append

*/Table 2 with rivalry rather than peace history*/
probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies rivalry_year prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & year <=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
biprobit (w_coop= treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies rivalry_year prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies rivalry_year lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi) if year >= 1948 & year <=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
biprobit (high_coop= treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies rivalry_year prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies rivalry_year lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi)if year >= 1948 & year<=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append


*/Table 2 with scaled variable detecting "net interaction"
reg net_interact treatlag
reg net_interact treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
reg alog_netint treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append

*/ Table 2 with fixed effects*/
xtlogit w_coop treatlag allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc if year >= 1948 & year <=1999 & sharedbas == 1, fe i(dyadid)
xtlogit high_coop treatlag allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc if year >= 1948 & year <=1999 & sharedbas == 1, fe i(dyadid)
xtlogit w_coop treatlag2 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc if year >= 1948 & year <= 1999 & sharedbas == 1, fe i(dyadid)
xtlogit w_coop treatlag3 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc if year >= 1948 & year <= 1999 & sharedbas == 1, fe i(dyadid)
xtlogit w_coop treatlag2_5 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc if year >= 1948 & year <= 1999 & sharedbas == 1, fe i(dyadid)

*/Table 2 with downstream preponderance rather than preponderance in general */
probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 downprep twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & year <=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
biprobit (w_coop= treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 downprep twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos downprep twodemoc updown numberriv lnbasinsi) if year >= 1948 & year <=1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append


*/Table 2 with bilateral and multilateral treaties*/

*/Bilateral and multilateral*/
probit w_coop bilatlag bilatlag2_5 bilatlag6_10 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & year <= 1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
biprobit (w_coop= bilatlag bilatlag2_5 bilatlag6_10 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi) if year >= 1948 & year <= 1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
biprobit (high_coop= bilatlag bilatlag2_5 bilatlag6_10 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi)if year >= 1948 & year <= 1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append

probit w_coop multilatlag multilag2_5 multilag6_10 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & year <= 1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
biprobit (w_coop= multilatlag multilag2_5 multilag6_10 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi) if year >= 1948 & year <= 1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
biprobit (high_coop= multilatlag multilag2_5 multilag6_10 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi) ///
(anytreaty=allies peacehis2 lnlrggdpc lnsmlgdpc dytrd lnigos prepond twodemoc updown numberriv lnbasinsi)if year >= 1948 & year <= 1999 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append



*/Building model with GDP */
probit w_coop lnlrggdpc lnsmlgdpc if year >= 1948 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster replace
probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append
probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & sharedbas == 1, robust cluster(dyadid)
outreg using M:\test1.doc, nolabel 3aster append


*/ Marginal effects based on Model 2 */
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16

estsimp probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 & year<= 1999 & sharedbas == 1, robust cluster(dyadid)
setx (lnlrggdpc lnsmlgdpc peacehis2 lnigos dytrd numberriv lnbasinsi) mean (allies twodemoc prepond updown treatlag treatlag2_5 treatlag6_10 treatlag11_20) 0
simqi, listx
simqi fd(pr) changex(lnlrggdpc mean p10 & lnsmlgdpc mean p10 & lnigos mean p10 & peacehis2 mean p10 & lnbasinsi mean p10 & dytrd mean p10 & numberriv mean p10 & allies 0 1 & twodemoc 0 1 & prepond 0 1 & updown 0 1 & treatlag 0 1 & treatlag2_5 0 1 & treatlag6_10 0 1 & treatlag11_20 0 1)

estsimp probit w_coop treatlag treatlag2_5 treatlag6_10 treatlag11_20 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi if year >= 1948 &year <= 1999 & sharedbas == 1, robust cluster(dyadid)
setx (lnlrggdpc lnsmlgdpc peacehis2 lnigos dytrd numberriv lnbasinsi) mean (allies twodemoc prepond updown treatlag treatlag2_5 treatlag6_10 treatlag11_20) 0
simqi, listx
simqi fd(pr) changex(lnlrggdpc mean p90 & lnsmlgdpc mean p90 & lnigos mean p90 & peacehis2 mean p90 & lnbasinsi mean p90 & dytrd mean p90 & numberriv mean p90)



---------------------
*//Below is documenatation of hoe the variables were generated and some correlations. All variables are present in the current dataset.

 
**// Correlations and generating various variables **/

tab anytreaty
tab treaty_multilat
tab treaty_bilat


corr w_coop treatlag treatlag2_5 treatlag6_10 allies peacehis2 prepond twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc updown numberriv lnbasinsi 
corr allies twodemoc lnigos dytrd lnlrggdpc lnsmlgdpc 
corr prev_treaty treatlag treatlag2_5 treatlag6_10 treatlag11_20

*/Generating high levels of cooperation -- High_coop
gen high_coop =1 if maxcoop > 3
replace high_coop = 0 if high_coop ==.


*/scaling confl and coop*/
tab maxconfl
drop net_interact
gen net_interact = .
replace net_interact = maxcoop + maxconfl

gen alog_netint = net_interact
replace alog_netint = -198.3 if net_interact == -7
replace alog_netint = -130.4 if net_interact == -6
replace alog_netint = -79.4 if net_interact == -5
replace alog_netint = -43.3 if net_interact == -4
replace alog_netint = -19.8 if net_interact == -3
replace alog_netint = -6.6 if net_interact == -2
replace alog_netint = 6.6 if net_interact == 2
replace alog_netint = 19.8 if net_interact == 3
replace alog_netint = 43.3 if net_interact == 4
replace alog_netint = 79.4 if net_interact == 5


*/Rivalry variable*/
replace rivalry_year = 0 if rivalry_year != 1


//*Gen previous treaty*//
drop prev_treaty
sort dyadid year
gen prev_treaty = 0
replace prev_treaty =1 if anytreaty[_n-1]== 1 & dyadid == dyadid[_n-1]
replace prev_treaty =prev_treaty[_n-1] if anytreaty[_n-1] ==0 & dyadid == dyadid[_n-1]
list year dyadid anytreaty prev_treaty in 1/50

gen first_treaty = 0
replace first_treaty = 1 if anytreaty == 1 & prev_treaty == 0
list year dyadid first_treaty anytreaty prev_treaty in 1/100
gen firsttrlag = 1 if first_treaty[_n-1] ==1 & dyadid==dyadid[_n-1]   
replace firsttrlag = 0 if firsttrlag != 1
list year dyadid first_treaty firsttrlag anytreaty prev_treaty in 1/100


//*Gen time since water conflict*//
drop conflhist
sort dyadid year
gen conflhist =999
replace conflhist = 0 if w_confl[_n-1] == 1 & dyadid == dyadid[_n-1]
replace conflhist = conflhist[_n-1]+1 if w_confl[_n-1] == 0 & dyadid == dyadid[_n-1]
replace conflhist = 999 if conflhist > 999
replace conflhist = 0 if w_confl == 1
list year dyadid w_confl conflhist in 1/90 
//*decay function*//
drop confldec
sort dyadid year
gen confldec = -2^(-conflhist)
gen confldec2 = -2^(-conflhist/2)
list year dyadid w_confl conflhist confldec in 1/90 
//* Here, after making the decay functions, replace conflhist == . if conflhist =999*//
replace conflhist = . if conflhist == 999


//*Lagged variables -- are all present in the current dataset//
capture drop treatlag
sort dyadid year
gen treatlag =.
replace treatlag =anytreaty[_n-1] if dyadid==dyadid[_n-1]   
replace treatlag = 0 if treatlag == .
capture drop treatlag2
gen treatlag2 =.
replace treatlag2 =anytreaty[_n-2] if dyadid==dyadid[_n-2] 
replace treatlag2 = 0 if treatlag2 == .
gen treatlag3 =.
replace treatlag3 =anytreaty[_n-3] if dyadid==dyadid[_n-3]   
replace treatlag3 = 0 if treatlag3 == .
gen treatlag4 =.
replace treatlag4 =anytreaty[_n-4] if dyadid==dyadid[_n-4]   
replace treatlag4 = 0 if treatlag4 == .
gen treatlag5 =.
replace treatlag5 =anytreaty[_n-5] if dyadid==dyadid[_n-5]   
replace treatlag5 = 0 if treatlag5 == .
gen treatlag6 =.
replace treatlag6 =anytreaty[_n-6] if dyadid==dyadid[_n-6]   
replace treatlag6 = 0 if treatlag6 == .
gen treatlag7 =.
replace treatlag7 =anytreaty[_n-7] if dyadid==dyadid[_n-7]   
replace treatlag7 = 0 if treatlag7 == .
gen treatlag8 =.
replace treatlag8 =anytreaty[_n-8] if dyadid==dyadid[_n-8]   
replace treatlag8 = 0 if treatlag8 == .
gen treatlag9 =.
replace treatlag9 =anytreaty[_n-9] if dyadid==dyadid[_n-9]   
replace treatlag9 = 0 if treatlag9 == .
gen treatlag10 =.
replace treatlag10 =anytreaty[_n-10] if dyadid==dyadid[_n-10]   
replace treatlag10 = 0 if treatlag10 == .
gen treatlag11 =.
replace treatlag11 =anytreaty[_n-11] if dyadid==dyadid[_n-11]   
replace treatlag11 = 0 if treatlag11 == .
gen treatlag12 =.
replace treatlag12 =anytreaty[_n-12] if dyadid==dyadid[_n-12]   
replace treatlag12 = 0 if treatlag12 == .
gen treatlag13 =.
replace treatlag13 =anytreaty[_n-13] if dyadid==dyadid[_n-13]   
replace treatlag13 = 0 if treatlag13 == .
gen treatlag14 =.
replace treatlag14 =anytreaty[_n-14] if dyadid==dyadid[_n-14]   
replace treatlag14 = 0 if treatlag14 == .
gen treatlag15 =.
replace treatlag15 =anytreaty[_n-15] if dyadid==dyadid[_n-15]   
replace treatlag15 = 0 if treatlag15 == .
gen treatlag16 =.
replace treatlag16 =anytreaty[_n-16] if dyadid==dyadid[_n-16]   
replace treatlag16 = 0 if treatlag16 == .
gen treatlag17 =.
replace treatlag17 =anytreaty[_n-17] if dyadid==dyadid[_n-17]   
replace treatlag17 = 0 if treatlag17 == .
gen treatlag18 =.
replace treatlag18 =anytreaty[_n-18] if dyadid==dyadid[_n-18]   
replace treatlag18 = 0 if treatlag18 == .
gen treatlag19 =.
replace treatlag19 =anytreaty[_n-19] if dyadid==dyadid[_n-19]   
replace treatlag19 = 0 if treatlag19 == .
gen treatlag20 =.
replace treatlag20 =anytreaty[_n-20] if dyadid==dyadid[_n-20]   
replace treatlag20 = 0 if treatlag20 == .


gen treatlag2_5 = .
replace treatlag2_5 = 1 if treatlag2 == 1
replace treatlag2_5 = 1 if treatlag3 == 1
replace treatlag2_5 = 1 if treatlag4 == 1
replace treatlag2_5 = 1 if treatlag5 == 1
replace treatlag2_5 = 0 if treatlag2_5 == .

gen treatlag6_10 = .
replace treatlag6_10 = 1 if treatlag6 == 1
replace treatlag6_10 = 1 if treatlag7 == 1
replace treatlag6_10 = 1 if treatlag8 == 1
replace treatlag6_10 = 1 if treatlag9 == 1
replace treatlag6_10 = 1 if treatlag10 == 1
replace treatlag6_10 = 0 if treatlag6_10 == .


gen treatlag4_8 = .
replace treatlag4_8 = 1 if treatlag4 == 1
replace treatlag4_8 = 1 if treatlag5 == 1
replace treatlag4_8 = 1 if treatlag6 == 1
replace treatlag4_8 = 1 if treatlag7 == 1
replace treatlag4_8 = 1 if treatlag8 == 1
replace treatlag4_8 = 0 if treatlag4_8 == .

gen treatlag11_20 = .
replace treatlag11_20 = 1 if treatlag11 == 1
replace treatlag11_20 = 1 if treatlag12== 1
replace treatlag11_20 = 1 if treatlag13 == 1
replace treatlag11_20 = 1 if treatlag14 == 1
replace treatlag11_20 = 1 if treatlag15 == 1
replace treatlag11_20 = 1 if treatlag16 == 1
replace treatlag11_20 = 1 if treatlag17 == 1
replace treatlag11_20 = 1 if treatlag18 == 1
replace treatlag11_20 = 1 if treatlag19 == 1
replace treatlag11_20 = 1 if treatlag20 == 1
replace treatlag11_20 = 0 if treatlag11_20 == .


gen treatlag1_10 = 1 if treatlag == 1
replace treatlag1_10 = 1 if treatlag2_5 == 1
replace treatlag1_10 = 1 if treatlag6_10 == 1
replace treatlag1_10 = 0 if treatlag1_10 != 1
list dyadid year treatlag treatlag2_5 treatlag6_10 treatlag1_10 in 1/100

gen treatlag11_15 = .
replace treatlag11_15 = 1 if treatlag11 == 1
replace treatlag11_15 = 1 if treatlag12== 1
replace treatlag11_15 = 1 if treatlag13 == 1
replace treatlag11_15 = 1 if treatlag14 == 1
replace treatlag11_15 = 1 if treatlag15 == 1
replace treatlag11_15 = 0 if treatlag11_15 == .

gen treatlag16_20 = .
replace treatlag16_20 = 1 if treatlag16 == 1
replace treatlag16_20 = 1 if treatlag17 == 1
replace treatlag16_20 = 1 if treatlag18 == 1
replace treatlag16_20 = 1 if treatlag19 == 1
replace treatlag16_20 = 1 if treatlag20 == 1
replace treatlag16_20 = 0 if treatlag16_20 == .


gen bilatlag2 = .
replace bilatlag2 = treaty_bilat[_n-2] if dyadid ==dyadid[_n-2]
replace bilatlag2 = 0 if bilatlag2 == .
gen bilatlag3 = .
replace bilatlag3 = treaty_bilat[_n-3] if dyadid ==dyadid[_n-3]
replace bilatlag3 = 0 if bilatlag3 == .
gen bilatlag4 = .
replace bilatlag4 = treaty_bilat[_n-4] if dyadid ==dyadid[_n-4]
replace bilatlag4 = 0 if bilatlag4 == .
gen bilatlag5 = .
replace bilatlag5 = treaty_bilat[_n-5] if dyadid ==dyadid[_n-5]
replace bilatlag5 = 0 if bilatlag5 == .
gen bilatlag6 = .
replace bilatlag6 = treaty_bilat[_n-6] if dyadid ==dyadid[_n-6]
replace bilatlag6 = 0 if bilatlag6 == .
gen bilatlag7 = .
replace bilatlag7 = treaty_bilat[_n-7] if dyadid ==dyadid[_n-7]
replace bilatlag7 = 0 if bilatlag7 == .
gen bilatlag8 = .
replace bilatlag8 = treaty_bilat[_n-8] if dyadid ==dyadid[_n-8]
replace bilatlag8 = 0 if bilatlag8 == .
gen bilatlag9 = .
replace bilatlag9 = treaty_bilat[_n-9] if dyadid ==dyadid[_n-9]
replace bilatlag9 = 0 if bilatlag9 == .
gen bilatlag10 = .
replace bilatlag10 = treaty_bilat[_n-10] if dyadid ==dyadid[_n-10]
replace bilatlag10 = 0 if bilatlag10 == .

gen bilatlag2_5 = .
replace bilatlag2_5 = 1 if bilatlag2 == 1
replace bilatlag2_5 = 1 if bilatlag3 == 1
replace bilatlag2_5 = 1 if bilatlag4 == 1
replace bilatlag2_5 = 1 if bilatlag5 == 1
replace bilatlag2_5 = 0 if bilatlag2_5 == .

gen bilatlag6_10 = .
replace bilatlag6_10 = 1 if bilatlag6 == 1
replace bilatlag6_10 = 1 if bilatlag7 == 1
replace bilatlag6_10 = 1 if bilatlag8 == 1
replace bilatlag6_10 = 1 if bilatlag9 == 1
replace bilatlag6_10 = 1 if bilatlag10 == 1
replace bilatlag6_10 = 0 if bilatlag6_10 == .

gen multilag2 = .
replace multilag2 = treaty_multilat[_n-2] if dyadid ==dyadid[_n-2]
replace multilag2 = 0 if multilag2 == .
gen multilag3 = .
replace multilag3 = treaty_multilat[_n-3] if dyadid ==dyadid[_n-3]
replace multilag3 = 0 if multilag3 == .
gen multilag4 = .
replace multilag4 = treaty_multilat[_n-4] if dyadid ==dyadid[_n-4]
replace multilag4 = 0 if multilag4 == .
gen multilag5 = .
replace multilag5 = treaty_multilat[_n-5] if dyadid ==dyadid[_n-5]
replace multilag5 = 0 if multilag5 == .
gen multilag6 = .
replace multilag6 = treaty_multilat[_n-6] if dyadid ==dyadid[_n-6]
replace multilag6 = 0 if multilag6 == .
gen multilag7 = .
replace multilag7 = treaty_multilat[_n-7] if dyadid ==dyadid[_n-7]
replace multilag7 = 0 if multilag7 == .
gen multilag8 = .
replace multilag8 = treaty_multilat[_n-8] if dyadid ==dyadid[_n-8]
replace multilag8 = 0 if multilag8 == .
gen multilag9 = .
replace multilag9 = treaty_multilat[_n-9] if dyadid ==dyadid[_n-9]
replace multilag9 = 0 if multilag9 == .
gen multilag10 = .
replace multilag10 = treaty_multilat[_n-10] if dyadid ==dyadid[_n-10]
replace multilag10 = 0 if multilag10 == .

gen multilag2_5 = .
replace multilag2_5 = 1 if multilag2 == 1
replace multilag2_5 = 1 if multilag3 == 1
replace multilag2_5 = 1 if multilag4 == 1
replace multilag2_5 = 1 if multilag5 == 1
replace multilag2_5 = 0 if multilag2_5 == .

drop multilag6_10
gen multilag6_10 = .
replace multilag6_10 = 1 if multilag6 == 1
replace multilag6_10 = 1 if multilag7 == 1
replace multilag6_10 = 1 if multilag8 == 1
replace multilag6_10 = 1 if multilag9 == 1
replace multilag6_10 = 1 if multilag10 == 1
replace multilag6_10 = 0 if multilag6_10 == .


gen multilag2_9 = .
replace multilag2_9 = 1 if multilag2 == 1
replace multilag2_9 = 1 if multilag3 == 1
replace multilag2_9 = 1 if multilag4 == 1
replace multilag2_9 = 1 if multilag5 == 1
replace multilag2_9 = 1 if multilag6 == 1
replace multilag2_9 = 1 if multilag7 == 1
replace multilag2_9 = 1 if multilag8 == 1
replace multilag2_9 = 1 if multilag9 == 1
replace multilag2_9 = 0 if multilag2_9 == .



































