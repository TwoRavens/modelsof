capture log close
cd "C:\gfrechette\My Dropbox"
*log using df/log/foo.log, replace	/* remove the * and change the path to create a log file */

set more 1
clear
set mem 100m

* SECTION III

* sessions characteristics
use df/data/stata/dal_bo_2010a_data, clear

replace maxround=. if round>1
table session r, c(max clientid mean maxmatch mean maxround) by(delta)
table session r if match==1 & round==1, c(max totalpayoff mean totalpayoff min totalpayoff) by(delta)
table delta r if match==1 & round==1, c(max totalpayoff mean totalpayoff min totalpayoff) scol 
sum totalpayoff if match==1 & round==1
table delta if clientid==1, c(mean maxround) 


* SECTION III.A

* TABLE 3: Percentage of Cooperation by Treatment

* top left panel
table delta r if match==1 & round==1, c(mean coop)
probit coop treat_2 if match==1 & round==1 & (treat_1==1|treat_2==1), cluster(date)
probit coop treat_4 if match==1 & round==1 & (treat_1==1|treat_4==1), cluster(date)
probit coop treat_3 if match==1 & round==1 & (treat_2==1|treat_3==1), cluster(date)
probit coop treat_5 if match==1 & round==1 & (treat_2==1|treat_5==1), cluster(date)
probit coop treat_6 if match==1 & round==1 & (treat_3==1|treat_6==1), cluster(date)
probit coop treat_5 if match==1 & round==1 & (treat_4==1|treat_5==1), cluster(date)
probit coop treat_6 if match==1 & round==1 & (treat_5==1|treat_6==1), cluster(date)

* top right panel
table delta r if match==1, c(mean coop)
probit coop treat_2 if match==1 & (treat_1==1|treat_2==1), cluster(date)
probit coop treat_4 if match==1 & (treat_1==1|treat_4==1), cluster(date)
probit coop treat_3 if match==1 & (treat_2==1|treat_3==1), cluster(date)
probit coop treat_5 if match==1 & (treat_2==1|treat_5==1), cluster(date)
probit coop treat_6 if match==1 & (treat_3==1|treat_6==1), cluster(date)
probit coop treat_5 if match==1 & (treat_4==1|treat_5==1), cluster(date)
probit coop treat_6 if match==1 & (treat_5==1|treat_6==1), cluster(date)

* bottom left panel
table delta r if round==1, c(mean coop)
probit coop treat_2 if round==1 & (treat_1==1|treat_2==1), cluster(date)
probit coop treat_4 if round==1 & (treat_1==1|treat_4==1), cluster(date)
probit coop treat_6 if round==1 & (treat_1==1|treat_6==1), cluster(date)
probit coop treat_3 if round==1 & (treat_2==1|treat_3==1), cluster(date)
probit coop treat_5 if round==1 & (treat_2==1|treat_5==1), cluster(date)
probit coop treat_6 if round==1 & (treat_3==1|treat_6==1), cluster(date)
probit coop treat_5 if round==1 & (treat_4==1|treat_5==1), cluster(date)
probit coop treat_6 if round==1 & (treat_5==1|treat_6==1), cluster(date)

* bottom right panel
table delta r, c(mean coop)
probit coop treat_2 if (treat_1==1|treat_2==1), cluster(date)
probit coop treat_4 if (treat_1==1|treat_4==1), cluster(date)
probit coop treat_6 if (treat_1==1|treat_6==1), cluster(date)
probit coop treat_3 if (treat_2==1|treat_3==1), cluster(date)
probit coop treat_5 if (treat_2==1|treat_5==1), cluster(date)
probit coop treat_6 if (treat_3==1|treat_6==1), cluster(date)
probit coop treat_5 if (treat_4==1|treat_5==1), cluster(date)
probit coop treat_6 if (treat_5==1|treat_6==1), cluster(date)

* 2nd paragraph

* equilibrium vs not
probit coop sgpe if round==1, cluster(date)
probit coop sgpe, cluster(date)


* SECTION III.B

* Table 4

table dec_match sgpe if round == 1, c(mean coop)
table dec_match sgpe, c(mean coop)
table dec_match rd if round == 1 & sgpe==1, c(mean coop)
table dec_match rd if sgpe==1, c(mean coop)

* 2nd paragraph

probit coop dec_match_11 if round==1 & (dec_match_0==1|dec_match_11==1) & sgpe==0, cluster(date)
probit coop dec_match_11 if (dec_match_0==1|dec_match_11==1) & sgpe==0, cluster(date)	/* mentioned in text but no numbers explicitely stated */

* SECTION III.C

* 1st paragraph

probit coop dec_match_11 if round==1 & (dec_match_0==1|dec_match_11==1) & sgpe==1, cluster(date)
probit coop dec_match_11 if (dec_match_0==1|dec_match_11==1) & sgpe==1, cluster(date)
* is coop different across SPE and not-SPE
probit coop sgpe if round==1 & dec_match_0==1, cluster(date)
probit coop sgpe if dec_match_0==1, cluster(date)
probit coop sgpe if round==1 & dec_match_11==1, cluster(date)
probit coop sgpe if dec_match_11==1, cluster(date)

* SECTION III.D

* 1st paragraph

probit coop dec_match_11 if round==1 & (dec_match_0==1|dec_match_11==1) & rd==1, cluster(date)
probit coop dec_match_11 if (dec_match_0==1|dec_match_11==1) & rd==1, cluster(date)
* is coop different across RD and not-RD
probit coop rd if round==1 & sgpe==1 & dec_match_0==1, cluster(date)
probit coop rd if sgpe==1 & dec_match_0==1, cluster(date)
probit coop rd if round==1 & sgpe==1 & dec_match_11==1, cluster(date)
probit coop rd if sgpe==1 & dec_match_11==1, cluster(date)

* SECTION IV

* Table 5

drop if round~=1
gen drd = 1
replace drd = 0.722222222222222 if treatment == 2
replace drd = 0.382352941176471 if treatment == 3
replace drd = 0.8125 if treatment == 4
replace drd = 0.270833333333333 if treatment == 5
replace drd = 0.1625 if treatment == 6
gen drd2=drd^2

replace maxround=. if match==maxmatch
egen avemaxround = mean(maxround), by(date)
gen devmaxround = avemaxround-2 if delta==0.5
replace devmaxround = avemaxround-4 if delta==0.75

probit coop drd drd2 devmaxround if match==maxmatch & round==1, cluster(date)
mfx compute

* Table 6

bysort treatment session id round (match): gen ocoop_pm = ocoop[_n-1] /* Round 1 Opponent Coop in previous match, pm = previous match */
bysort treatment session id round (match): gen maxround_pm = maxround[_n-1] /* Number of rounds in previous match, pm = previous match */
gen foo = coop if match == 1 & round == 1
egen m1r1c = max(foo), by(id) /* Match 1 Round 1 Coop */
drop foo

quietly probit coop ocoop_pm maxround_pm m1r1c if round == 1 & match > 1 & treatment == 1, cluster(date)
mfx compute
quietly probit coop ocoop_pm maxround_pm m1r1c if round == 1 & match > 1 & treatment == 2, cluster(date)
mfx compute
quietly probit coop ocoop_pm maxround_pm m1r1c if round == 1 & match > 1 & treatment == 3, cluster(date)
mfx compute
quietly probit coop ocoop_pm maxround_pm m1r1c if round == 1 & match > 1 & treatment == 4, cluster(date)
mfx compute
quietly probit coop ocoop_pm maxround_pm m1r1c if round == 1 & match > 1 & treatment == 5, cluster(date)
mfx compute
quietly probit coop ocoop_pm maxround_pm m1r1c if round == 1 & match > 1 & treatment == 6, cluster(date)
mfx compute



slvNSLvn