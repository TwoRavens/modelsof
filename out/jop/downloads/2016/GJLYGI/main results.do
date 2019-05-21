use "main results.dta", clear

* Racial Resentment

xtmixed r_racism black hispanic auth_01 r_div c.auth_01#c.r_div c.auth_01#c.pctcollege_01 c.auth_01#c.r_poldiv_01 partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 r_poldiv_01 pctcollege_01 || fips: auth_01 partyid_01, reml
margins, at(auth_01 = (.375 1) r_div = (0(.01)1)) vsquish
marginsplot, xdim(r_div) recast(line) recastci(rarea) graphregion(color(white)) ytitle("") title("Racial Resentment")

margins, at(r_div = 1 auth_01 = (.375 1)) vsquish

* Go into the graph editor, click on the record button, and load style.grec

* Immigration

xtmixed r_immatt black hispanic auth_01 r_div c.auth_01#c.r_div c.auth_01#c.pctcollege_01 c.auth_01#c.r_poldiv_01 partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 r_poldiv_01 pctcollege_01 || fips: auth_01 partyid_01, reml

margins, at(auth_01 = (.375 1) r_div = (0(.01)1)) vsquish
marginsplot, xdim(r_div) recast(line) recastci(rarea) graphregion(color(white)) ytitle("") title("Negative Immigration Beliefs")

margins, at(r_div = 1 auth_01 = (.375 1)) vsquish

* Go into the graph editor, click on the record button, and load style.grec

* Political Intolerance

xtmixed r_pol_intol black hispanic auth_01 r_div c.auth_01#c.r_div c.auth_01#c.pctcollege_01 c.auth_01#c.r_poldiv_01 partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 r_poldiv_01 pctcollege_01 || fips: auth_01 partyid_01, reml
margins, at(auth_01 = (.375 1) r_div = (0(.01)1)) vsquish
marginsplot, xdim(r_div) recast(line) recastci(rarea) graphregion(color(white)) ytitle("") title("Political Intolerance")

margins, at(r_div = 1 auth_01 = (.375 1)) vsquish

* Go into the graph editor, click on the record button, and load style.grec

* Cultural Concerns

xtmixed r_imcult black hispanic auth_01 r_div c.auth_01#c.r_div c.auth_01#c.pctcollege_01 c.auth_01#c.r_poldiv_01 partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 r_poldiv_01 pctcollege_01 || fips: auth_01 partyid_01, reml

* Safety Concerns

xtmixed r_imcrm black hispanic auth_01 r_div c.auth_01#c.r_div c.auth_01#c.pctcollege_01 c.auth_01#c.r_poldiv_01 partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 r_poldiv_01 pctcollege_01 || fips: auth_01 partyid_01, reml

* Economic Concerns

xtmixed r_imeco black hispanic auth_01 r_div c.auth_01#c.r_div c.auth_01#c.pctcollege_01 c.auth_01#c.r_poldiv_01 partyid_01 ideology_01 female age_01 education_01 income_01 unempcnty05_01 bush04cnty_01 r_poldiv_01 pctcollege_01 || fips: auth_01 partyid_01, reml

