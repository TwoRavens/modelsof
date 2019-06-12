
use "authorshipCaseLevelData.dta", clear

*Table 2: Case Level Summary Statistics
tab numWom
tab numMin
tab assMale
tab assWhite
tab selfAss
tab auMale
tab auWhite
tab published


*** Judge Level analysis
use "authorship.dta", clear

*Table 3: Judge Level Summary statistics
tab genBuck
tab raceBuck
tab published
tab assignor
tab clerk
tab aba2
tab freshman
tab desig
sum iddist tenure, detail

*Table 1: Main regression results
probit author i.genBuck##i.published i.raceBuck##i.published iddist assignor clerk aba2 tenure freshman desig b6.circuit, robust cluster(caseID) 

*Figure 1: Predicted probabilities
margins, at(genBuck=(0 1 2 3) raceBuck==(0 1 2 3) published=(0 1) iddist=.085 assignor=0 clerk=0 aba2=1 tenure=14 desig=0)


**Appendix B: Alternative-Specific Conditional Logit Models
*Table 4: Gender Models
asclogit author male white iddist assignor clerk aba2 tenure freshman desig if published == 1 & assMale == 1, case(caseID) alternatives(jNum) base(1)
asclogit author male white iddist assignor clerk aba2 tenure freshman desig if published == 1 & assMale == 0, case(caseID) alternatives(jNum) base(1)
asclogit author male white iddist assignor clerk aba2 tenure freshman desig if published == 0 & assMale == 1, case(caseID) alternatives(jNum) base(1)
asclogit author male white iddist assignor clerk aba2 tenure freshman desig if published == 0 & assMale == 0, case(caseID) alternatives(jNum) base(1)

*Table 5: Race Models
asclogit author male white iddist assignor clerk aba2 tenure freshman desig if published == 1 & assWhite == 1, case(caseID) alternatives(jNum) base(1)
asclogit author male white iddist assignor clerk aba2 tenure freshman desig if published == 1 & assWhite == 0, case(caseID) alternatives(jNum) base(1)
asclogit author male white iddist assignor clerk aba2 tenure freshman desig if published == 0 & assWhite == 1, case(caseID) alternatives(jNum) base(1)
asclogit author male white iddist assignor clerk aba2 tenure freshman desig if published == 0 & assWhite == 0, case(caseID) alternatives(jNum) base(1)

