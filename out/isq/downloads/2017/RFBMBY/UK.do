** With UK Data **
** Table 1 **
tab labiraq_pre labterror_pre, col row
sort partisanship_pre
by partisanship_pre: tab labiraq_pre labterror_pre, col row

** Table 3 and Table 4 **
sem (relresponsive -> relfeelings) (labiraq_pre -> relresponsive) (labiraq_pre -> relcompetence) (labiraq_pre -> reltrust) (labiraq_pre -> relfeelings) (labiraq_pre -> votecon) ///
(labiraq_pre -> voteld) (labiraq_pre -> votelabour) (labterror_pre -> relresponsive) (labterror_pre -> relcompetence) (labterror_pre -> reltrust) (labterror_pre -> relfeelings) ///
(labterror_pre -> votecon) (labterror_pre -> voteld) (labterror_pre -> votelabour) (relcompetence -> relfeelings) ///
(reltrust -> relfeelings) (relfeelings -> votecon) ///
(relfeelings -> voteld) (relfeelings -> votelabour) (conservative_pre -> relresponsive) (conservative_pre -> relcompetence) (conservative_pre -> reltrust) ///
(conservative_pre -> relfeelings) (conservative_pre -> votecon) (conservative_pre -> voteld) (conservative_pre -> votelabour) (libdem_pre -> relresponsive) ///
(libdem_pre -> relcompetence) (libdem_pre -> reltrust) (libdem_pre -> relfeelings) (libdem_pre -> votecon) (libdem_pre -> voteld) (libdem_pre -> votelabour) ///
(labeconomy_pre -> relresponsive) (labeconomy_pre -> relcompetence) (labeconomy_pre -> reltrust) (labeconomy_pre -> relfeelings) (labeconomy_pre -> votecon) ///
(labeconomy_pre -> voteld) (labeconomy_pre -> votelabour), ///
method(adf) cov( e.relresponsive*e.relcompetence e.reltrust*e.relresponsive e.reltrust*e.relcompetence e.votecon@0 e.voteld@0 e.votelabour@0) nocapslatent
estat gof, stats(all)
estat teffects

** Footnote 20 about controlling for valence issues **
sem (relresponsive -> relfeelings) (labiraq_pre -> relresponsive) (labiraq_pre -> relcompetence) (labiraq_pre -> reltrust) (labiraq_pre -> relfeelings) (labiraq_pre -> votecon) ///
(labiraq_pre -> voteld) (labiraq_pre -> votelabour) (labterror_pre -> relresponsive) (labterror_pre -> relcompetence) (labterror_pre -> reltrust) (labterror_pre -> relfeelings) ///
(labterror_pre -> votecon) (labterror_pre -> voteld) (labterror_pre -> votelabour) (relcompetence -> relfeelings) (labnhs_pre -> relresponsive) (labnhs_pre -> relcompetence) ///
(labnhs_pre -> reltrust) (labnhs_pre -> relfeelings) (labnhs_pre -> votecon) (labnhs_pre -> voteld) (labnhs_pre -> votelabour) (reltrust -> relfeelings) (relfeelings -> votecon) ///
(relfeelings -> voteld) (relfeelings -> votelabour) (conservative_pre -> relresponsive) (conservative_pre -> relcompetence) (conservative_pre -> reltrust) ///
(conservative_pre -> relfeelings) (conservative_pre -> votecon) (conservative_pre -> voteld) (conservative_pre -> votelabour) (libdem_pre -> relresponsive) ///
(libdem_pre -> relcompetence) (libdem_pre -> reltrust) (libdem_pre -> relfeelings) (libdem_pre -> votecon) (libdem_pre -> voteld) (libdem_pre -> votelabour) ///
(labeconomy_pre -> relresponsive) (labeconomy_pre -> relcompetence) (labeconomy_pre -> reltrust) (labeconomy_pre -> relfeelings) (labeconomy_pre -> votecon) ///
(labeconomy_pre -> voteld) (labeconomy_pre -> votelabour) (labtax_pre -> relresponsive) (labtax_pre -> relcompetence) (labtax_pre -> reltrust) (labtax_pre -> relfeelings) ///
(labtax_pre -> votecon) (labtax_pre -> voteld) (labtax_pre -> votelabour) (labcrime_pre -> relresponsive) (labcrime_pre -> relcompetence) (labcrime_pre -> reltrust) ///
(labcrime_pre -> relfeelings) (labcrime_pre -> votecon) (labcrime_pre -> voteld) (labcrime_pre -> votelabour) (labasylum_pre -> relresponsive) (labasylum_pre -> relcompetence) ///
(labasylum_pre -> reltrust) (labasylum_pre -> relfeelings) (labasylum_pre -> votecon) (labasylum_pre -> voteld) (labasylum_pre -> votelabour), ///
method(adf) cov( e.relresponsive*e.relcompetence e.reltrust*e.relresponsive e.reltrust*e.relcompetence e.votecon@0 e.voteld@0 e.votelabour@0) nocapslatent


** Table 5 **
sem (relresponsive -> relfeelings) (labiraq_pre -> relresponsive) (labiraq_pre -> relcompetence) (labiraq_pre -> reltrust) (labiraq_pre -> relfeelings) (labiraq_pre -> votecon) ///
(labiraq_pre -> voteld) (labiraq_pre -> votelabour) (labterror_pre -> relresponsive) (labterror_pre -> relcompetence) (labterror_pre -> reltrust) (labterror_pre -> relfeelings) ///
(labterror_pre -> votecon) (labterror_pre -> voteld) (labterror_pre -> votelabour) (relcompetence -> relfeelings) ///
(reltrust -> relfeelings) (relfeelings -> votecon) ///
(relfeelings -> voteld) (relfeelings -> votelabour) ///
(labeconomy_pre -> relresponsive) (labeconomy_pre -> relcompetence) (labeconomy_pre -> reltrust) (labeconomy_pre -> relfeelings) (labeconomy_pre -> votecon) ///
(labeconomy_pre -> voteld) (labeconomy_pre -> votelabour) if partisanship_pre != 0, group(partisanship_pre) ///
method(adf) cov( e.relresponsive*e.relcompetence e.reltrust*e.relresponsive e.reltrust*e.relcompetence e.votecon@0 e.voteld@0 e.votelabour@0) nocapslatent
estat gof, stats(all)
estat teffects

** Table 6 **
tab labiraq_pre partisanship_pre, col




