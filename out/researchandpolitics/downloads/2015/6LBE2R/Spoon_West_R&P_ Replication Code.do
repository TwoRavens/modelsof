**Spoon West R&P R&R Models**

*Model 1*
logit prescand Presence Avg_Vote_Share sn_won populous concurrent governor federal  presplur fhinv lag_prescand, cluster(country_year)

*Model 2*
logit prescand Presence Avg_Vote_Share sn_won populous concurrent governor federal  presplur fhinv lag_prescand presence_concurrent performance_concurrent , cluster(country_year)

*Model 3*
logit prescand Presence Avg_Vote_Share sn_won populous concurrent governor federal  presplur fhinv lag_prescand presence_lagpres performance_lagpres, cluster(country_year)


//Figure 2a with distribution rug//

logit prescan Avg_Vote_Share  Presence sn_won  concurrent governor federal populous  presplur enpp fhinv prevpres, cluster(country_year)

gen newvar=.01
gen Presence2=Presence

quietly margins, at(Presence=(0(.1)1)) level(95) vsquish 

marginsplot, addplot (spike newvar Presence2, xtitle("Sub-National Electoral Presence") ytitle("Pr(Presidential Candidate)") legend(off))


//Figure 2b with distribution rug//

logit prescand Avg_Vote_Share  Presence sn_won populous concurrent governor federal  presplur fhinv lag_prescand, cluster(country_year)

gen newvar=.01
gen Avg_Vote_Share2=Avg_Vote_Share

quietly margins, at(Avg_Vote_Share=(0(.1).9)) level(90) vsquish

marginsplot, addplot (spike newvar Avg_Vote_Share2, xtitle("Sub-National Electoral Performance") ytitle("Pr(Presidential Candidate)") legend(off))



