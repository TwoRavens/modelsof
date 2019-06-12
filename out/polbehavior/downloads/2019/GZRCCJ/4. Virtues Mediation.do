
clear
set more off

quiet: do "1. Virtues Prepare Variables.do"


*===============================================================================
*programs ======================
*===============================================================================

capture program drop te_direct
program te_direct, eclass
    quietly estat teffects
    mat b = r(direct)
    mat V = r(V_direct)
    local N = e(N)
    ereturn post b V, obs(`N')
    ereturn local cmd te_direct 
end

capture program drop te_indirect
program te_indirect, eclass
    quietly estat teffects
    mat b = r(indirect)
    mat V = r(V_indirect)
    ereturn post b V
    ereturn local cmd te_indirect 
end

capture program drop te_total
program te_total, eclass
    quietly estat teffects
    mat b = r(total)
    mat V = r(V_total)
    ereturn post b V
    ereturn local cmd te_total 
end


svyset [pweight=weight]
tab religion4, gen(rel)
keep weight interaction polinterest politicaltalk ///
	disagreement partybonding partybridging female age education income rel2 rel3 rel4 nonwhite pidstrength repdummy

* For sensitivity analysis in R
outsheet * using Mediation.csv, comma nolab replace

*===============================================================================
*regressions ======================
*===============================================================================

*webuse nhanes2f, clear
svy: sem (disagreement <- partybonding female age education income rel2 rel3 rel4 nonwhite pidstrength repdummy) ///
		(disagreement <- partybridging female age education income rel2 rel3 rel4 nonwhite pidstrength repdummy) ///
		(interaction   <- disagreement partybonding partybridging female age education income rel2 rel3 rel4 nonwhite pidstrength repdummy)
est store main
te_direct
est store direct
est restore main
te_indirect
est store indirect
est restore main
te_total
est store total
esttab direct indirect total using mediate_interaction.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace mtitles(direct indirect total)


svy: sem (disagreement <- partybonding female age education income rel2 rel3 rel4 nonwhite pidstrength repdummy) ///
		(disagreement <- partybridging female age education income rel2 rel3 rel4 nonwhite pidstrength repdummy) ///
		(polinterest <- disagreement partybonding partybridging female age education income rel2 rel3 rel4 nonwhite pidstrength repdummy)
est store main
te_direct
est store direct
est restore main
te_indirect
est store indirect
est restore main
te_total
est store total
esttab direct indirect total using mediate_polinterest.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace mtitles(direct indirect total)


svy: sem (disagreement <- partybonding female age education income rel2 rel3 rel4 nonwhite pidstrength repdummy) ///
		(disagreement <- partybridging female age education income rel2 rel3 rel4 nonwhite pidstrength repdummy) ///
		(politicaltalk <- disagreement partybonding partybridging female age education income rel2 rel3 rel4 nonwhite pidstrength repdummy)
est store main
te_direct
est store direct
est restore main
te_indirect
est store indirect
est restore main
te_total
est store total
esttab direct indirect total using mediate_politicaltalk.csv, b(3) se(2) starlevels(+ .10 * .05 ** .01 *** .001) r2(3) nogaps replace mtitles(direct indirect total)

