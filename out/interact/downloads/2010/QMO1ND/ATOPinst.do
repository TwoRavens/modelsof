**when using the variables below, please cite:  
**Leeds, Brett Ashley and Sezi Anac.  2005.  Alliance Institutionalization and Alliance Performance.  International Interactions 31 (3): 183-202.

**code for creating Leeds & Anac peacetime military coordination (military institutionalization) variable
**Here the variable is created at the alliance level-- the highest level of institutionalization ever achieved in the alliance
**Using the alliance phase dataset one could create the same measure by alliance phase, thus insuring that the institutional features are in effect in the given year.

use "atop3_0a.dta", clear
su milcon intcom base milaid subord contrib orgpurp1 orgpurp2
su estmode pubsecr organ1 organ2

gen hinst=0
recode hinst 0=1 if milcon==3
recode hinst 0=1 if intcom==1
recode hinst 0=1 if base>0 & base~=.
tab hinst
gen minst=0
recode minst 0=1 if milcon==2
recode minst 0=1 if milaid>2 & milaid<5
recode minst 0=1 if subord>0 & subord~=.
recode minst 0=1 if contrib==1
gen milorg=0
recode milorg 0=1 if orgpurp1==1
recode milorg 0=1 if orgpurp1==4
recode milorg 0=1 if orgpurp2==1
recode milorg 0=1 if orgpurp2==4
recode milorg 0=. if orgpurp1==. & orgpurp2==.
recode minst 0=1 if milorg==1
tab hinst minst
recode minst 1=0 if hinst==1
tab hinst minst
recode hinst 0=. if milcon==. & intcom==. & base==.
recode minst 0=. if milcon==. & milaid==. & subord==. & contrib==. & milorg==.
gen milinst=0
recode milinst 0=1 if minst==1
recode milinst 0=2 if hinst==1
recode milinst 0=. if hinst==. & minst==.
tab milinst

**code for creating Leeds & Anac formality variable
gen pubtreat=0
recode pubtreat 0=1 if estmode==1 & pubsecr~=2
recode pubtreat 0=. if estmode==. & pubsecr==.
tab pubtreat
gen formorg=0
recode formorg 0=1 if organ1==3
recode formorg 0=1 if organ1==2
recode formorg 0=1 if organ2==3
recode formorg 0=1 if organ2==2
recode formorg 0=. if organ1==. & organ2==.
tab pubtreat formorg
gen formal=0
recode formal 0=2 if pubtreat==1 & formorg==1
recode formal 0=1 if pubtreat==1 & formorg==0
recode formal 0=1 if pubtreat==0 & formorg==1
recode formal 0=. if pubtreat==. & formorg==.
tab formal
keep atopid hinst minst milorg milinst pubtreat formorg formal version
order atopid hinst minst milorg milinst pubtreat formorg formal version
save "ATOPinst.dta", replace
