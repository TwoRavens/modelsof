/* this file makes a table w/fully interacted race and degree status regressions */

log using bonustable_interactions_restat.txt, text replace

set more off
use mergedcleaned04, clear
append using mergedcleaned00

areg allnone offcampus morethantuit getarefund female black asian hisp raceoth parhelpd nontuithelp , absorb(uglvl2) robust
outreg using tablebonus_interactions_race_9903.txt, replace se coefastr 10pct

gen black_off = black*offcampus
gen black_more = black*morethantuit

areg allnone offcampus morethantuit getarefund female black* asian hisp raceoth parhelpd nontuithelp , absorb(uglvl2) robust
outreg using tablebonus_interactions_race_9903.txt, append se coefastr 10pct

gen female_off = female*offcampus
gen female_more = female*morethantuit

areg allnone offcampus morethantuit getarefund female* black asian hisp raceoth parhelpd nontuithelp , absorb(uglvl2) robust
outreg using tablebonus_interactions_race_9903.txt, append se coefastr 10pct

gen asian_off = asian*offcampus
gen asian_more = asian*morethantuit

areg allnone offcampus morethantuit getarefund female black asian* hisp raceoth parhelpd nontuithelp , absorb(uglvl2) robust
outreg using tablebonus_interactions_race_9903.txt, append se coefastr 10pct

gen hisp_off = hispanic*offcampus
gen hisp_more = hispanic*morethantuit

areg allnone offcampus morethantuit getarefund female black asian hisp* raceoth parhelpd nontuithelp , absorb(uglvl2) robust
outreg using tablebonus_interactions_race_9903.txt, append se coefastr 10pct

gen raceoth_off = raceoth*offcampus
gen raceoth_more = raceoth * morethantuit

areg allnone offcampus morethantuit getarefund female black asian hispanic raceoth* parhelpd nontuithelp , absorb(uglvl2) robust
outreg using tablebonus_interactions_race_9903.txt, append se coefastr 10pct

areg allnone offcampus morethantuit getarefund female* black* asian* hisp* raceoth* parhelpd nontuithelp , absorb(uglvl2) robust
outreg using tablebonus_interactions_race_9903.txt, append se coefastr 10pct

/* now do interactions for grade level */
gen soph = uglvl2==2
gen junior = uglvl2==3
gen senior = uglvl2==4
gen soph_off = soph*offcampus
gen soph_more = soph*morethantuit

reg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp soph junior senior, robust
outreg using tablebonus_interactions_uglvl_9903.txt, replace se coefastr 10pct

reg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp soph* junior senior, robust
outreg using tablebonus_interactions_uglvl_9903.txt, append se coefastr 10pct

gen junior_off = junior*offcampus
gen junior_more = junior*morethantuit

reg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp soph junior* senior, robust
outreg using tablebonus_interactions_uglvl_9903.txt, append se coefastr 10pct


gen senior_off = senior*offcampus
gen senior_more = senior*morethantuit

reg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp soph junior senior*, robust
outreg using tablebonus_interactions_uglvl_9903.txt, append se coefastr 10pct

reg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp soph* junior* senior*, robust
outreg using tablebonus_interactions_uglvl_9903.txt, append se coefastr 10pct

/* now do research university types */
areg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp type_* , absorb(uglvl2) robust
outreg using tablebonus_interactions_type_9903.txt, replace se coefastr 10pct

gen masters_off = type_masters * offcampus
gen masters_more = type_masters * morethantuit


areg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp type_* masters*, absorb(uglvl2) robust
outreg using tablebonus_interactions_type_9903.txt, append se coefastr 10pct

gen bac_off = type_bac * offcampus
gen bac_more = type_bac * morethantuit


areg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp type_* bac*, absorb(uglvl2) robust
outreg using tablebonus_interactions_type_9903.txt, append se coefastr 10pct

gen typeoth_off = type_oth * offcampus
gen typeoth_more = type_oth * morethantuit


areg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp type_* typeoth*, absorb(uglvl2) robust
outreg using tablebonus_interactions_type_9903.txt, append se coefastr 10pct

areg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp type_* masters* bac* typeoth*, absorb(uglvl2) robust
outreg using tablebonus_interactions_type_9903.txt, append se coefastr 10pct

/* interact w/ expensive school, cost of attendance */

gen expens_off = expensiveschool * offcampus
gen expens_more = expensiveschool * morethantuit


gen highcost_off = highcost * offcampus
gen highcost_more = highcost * morethantuit


areg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp expensiveschool highcost , absorb(uglvl2) robust
outreg using tablebonus_interactions_cost_9903.txt, replace se coefastr 10pct
areg allnone offcampus morethantuit getarefund female black asian hispanic raceoth parhelpd nontuithelp highcost* expens* , absorb(uglvl2) robust
outreg using tablebonus_interactions_cost_9903.txt, append se coefastr 10pct

log close
