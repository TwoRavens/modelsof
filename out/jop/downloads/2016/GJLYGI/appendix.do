use "main results.dta", clear

* Table 1B

xtmixed r_racism black hispanic auth_01 r_div c.auth_01#c.r_div c.partyid_01#c.r_div c.ideology_01#c.r_div c.income_01#c.r_div partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 pctcollege_01 r_poldiv_01 || fips: auth_01 partyid_01, reml

xtmixed r_immatt black hispanic auth_01 r_div c.auth_01#c.r_div c.partyid_01#c.r_div c.ideology_01#c.r_div c.income_01#c.r_div partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 pctcollege_01 r_poldiv_01 || fips: auth_01 partyid_01, reml

xtmixed r_pol_intol black hispanic auth_01 r_div c.auth_01#c.r_div c.partyid_01#c.r_div c.ideology_01#c.r_div c.income_01#c.r_div partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 pctcollege_01 || fips: auth_01, reml

* Table 2B

xtmixed r_racism black hispanic auth_01 r_div c.auth_01#c.r_div c.partyid_01#c.r_div c.ideology_01#c.r_div c.income#c.r_div partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 pctcollege_01 r_poldiv_01 c.unempcnty05_01#c.r_div c.bush04cnty_01#c.r_div c.pctcollege_01#c.r_div c.r_poldiv_01#c.r_div || fips: auth_01 partyid_01, reml

xtmixed r_immatt black hispanic auth_01 r_div c.auth_01#c.r_div c.partyid_01#c.r_div c.ideology_01#c.r_div c.income#c.r_div partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 pctcollege_01 r_poldiv_01 c.unempcnty05_01#c.r_div c.bush04cnty_01#c.r_div c.pctcollege_01#c.r_div c.r_poldiv_01#c.r_div || fips: auth_01 partyid_01, reml

xtmixed r_pol_intol black hispanic auth_01 r_div c.auth_01#c.r_div c.partyid_01#c.r_div c.ideology_01#c.r_div c.income#c.r_div partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 pctcollege_01 r_poldiv_01 c.unempcnty05_01#c.r_div c.bush04cnty_01#c.r_div c.pctcollege_01#c.r_div c.r_poldiv_01#c.r_div || fips: auth_01 partyid_01, reml

* Table 3B

xtmixed r_racism auth_01 r_div c.auth_01#c.r_div c.auth_01#c.pctcollege_01 c.auth_01#c.r_poldiv_01 partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 r_poldiv_01 pctcollege_01 if white == 1 || fips: auth_01 partyid_01, reml

margins, at(auth_01 = (.375 1) r_div = (0(.01)1)) vsquish
marginsplot, xdim(r_div) recast(line) recastci(rarea) graphregion(color(white)) ytitle("") title("Racial Resentment")

* Go into the graph editor, click on the play button, and load style.grec

xtmixed r_immatt auth_01 r_div c.auth_01#c.r_div c.auth_01#c.pctcollege_01 c.auth_01#c.r_poldiv_01 partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 r_poldiv_01 pctcollege_01 if white == 1 || fips: auth_01 partyid_01, reml

margins, at(auth_01 = (.375 1) r_div = (0(.01)1)) vsquish
marginsplot, xdim(r_div) recast(line) recastci(rarea) graphregion(color(white)) ytitle("") title("Racial Resentment")

* Go into the graph editor, click on the record button, and load style.grec

xtmixed r_pol_intol auth_01 r_div c.auth_01#c.r_div c.auth_01#c.pctcollege_01 c.auth_01#c.r_poldiv_01 partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 r_poldiv_01 pctcollege_01 if white == 1 || fips: auth_01 partyid_01, reml

margins, at(auth_01 = (.375 1) r_div = (0(.01)1)) vsquish
marginsplot, xdim(r_div) recast(line) recastci(rarea) graphregion(color(white)) ytitle("") title("Racial Resentment")

* Go into the graph editor, click on the record button, and load style.grec

use "dorm results.dta", clear

* Table 2C

* Nationalism Model

reg nationalism_01 prior_nationalism_01  auth01 lib cons george1_01 hhi_rev_01 c.auth01#c.hhi_rev_0 mixeddorm freshman black hispanic female age_01 knowroommate foreign_student

margins, at(auth01 = (0 1) hhi_rev_01 = (0(.01)1)) vsquish
marginsplot, xdim(hhi_rev_01) recast(line) recastci(rarea) graphregion(color(white)) ytitle("") title("Nationalism")

* Go into the graph editor, click on the record button, and load style.grec


* Immigration Model

reg immigration_01 prior_immigration_01 auth01 lib cons george1_01 hhi_rev_01 c.auth01#c.hhi_rev_0 mixeddorm freshman black hispanic female age_01 knowroommate foreign_student

* Refugee Model

reg refugee_01 prior_refugee_01  auth01 lib cons george1_01 hhi_rev_01 c.auth01#c.hhi_rev_0 mixeddorm freshman black hispanic female age_01 knowroommate foreign_student

margins, at(auth01 = (0 1) hhi_rev_01 = (0(.01)1)) vsquish
marginsplot, xdim(hhi_rev_01) recast(line) recastci(rarea) graphregion(color(white)) ytitle("") title("Refugee Attitudes")

* Go into the graph editor, click on the record button, and load style.grec


* Militarism Model

reg militarism_01 prior_militarism_01  auth01 lib cons george1_01 hhi_rev_01 c.auth01#c.hhi_rev_0 mixeddorm freshman black hispanic female age_01 knowroommate foreign_student

margins, at(auth01 = (0 1) hhi_rev_01 = (0(.01)1)) vsquish
marginsplot, xdim(hhi_rev_01) recast(line) recastci(rarea) graphregion(color(white)) ytitle("") title("Militarism")

* Go into the graph editor, click on the record button, and load style.grec

* Figure 3C: Run "Randomization Check.R"

* Table 3C: Run "Balance Checks.R"

* Table 4C

reg nationalism_01 prior_nationalism_01  auth01 lib cons george1_01 c.auth01#c.hhi_rev_0 c.lib#c.hhi_rev_0 c.cons#c.hhi_rev_0 c.george1_01#c.hhi_rev_0 c.open_01##c.hhi_rev_01 mixeddorm freshman black hispanic female age_01 knowroommate foreign_student

reg militarism_01 prior_militarism_01  auth01 lib cons george1_01 c.auth01#c.hhi_rev_0 c.lib#c.hhi_rev_0 c.cons#c.hhi_rev_0 c.george1_01#c.hhi_rev_0 c.open_01##c.hhi_rev_01 mixeddorm freshman black hispanic female age_01 knowroommate foreign_student

reg refugee_01 prior_refugee_01  auth01 lib cons george1_01 c.auth01#c.hhi_rev_0 c.lib#c.hhi_rev_0 c.cons#c.hhi_rev_0 c.george1_01#c.hhi_rev_0 c.open_01##c.hhi_rev_01 mixeddorm freshman black hispanic female age_01 knowroommate foreign_student

* Table 5C

probit dropped_out c.auth01##c.hhi_rev_01




