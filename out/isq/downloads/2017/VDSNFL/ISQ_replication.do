*Replication do file for "Media-driven Humanitarianism? News Media Coverage of Human Rights Abuses and the Use of Economic Sanctions."
*Questions and comments can be directed to Timothy M. Peterson at tpeterso@mailbox.sc.edu

*note: our analysis requires the use of the CMP package in Stata
cmp setup

*Table 1: Newsweek data
cmp (threat_all_issue=llnnwi2 lally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl) (llnnwi2 = lcomb lally ldep1 llngdppc2 lpolity22 llndist lelec), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_all_issue= llnnwi2 lally llnnwi2xlally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr electionprox lavapp lunemp linfl) (llnnwi2 = lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp= llnnwi2 lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiyr electionprox lavapp lunemp linfl) (llnnwi2 = lcomb lally ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp= llnnwi2 lally lcomb llnnwi2xlally ltargetexp llngdppc2 lpolity22 lndist tiyr electionprox lavapp lunemp linfl) (llnnwi2 = lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist lelec), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp_with= llnnwi2 lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiwyr electionprox lavapp lunemp linfl) (llnnwi2 = lcomb lally ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp_with= llnnwi2 lally lcomb llnnwi2xlally ltargetexp llngdppc2 lpolity22 lndist tiwyr electionprox lavapp lunemp linfl) (llnnwi2 = lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)

*Table 2: NYT data
cmp (threat_all_issue= llnnytimes lally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl) (llnnytimes = lcomb lally ldep1 llngdppc2 lpolity22 llndist lelec), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_all_issue= llnnytimes lally llnnytimesxlally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr electionprox lavapp lunemp linfl) (llnnytimes = lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp= llnnytimes lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiyr electionprox lavapp lunemp linfl) (llnnytimes = lcomb lally ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp= llnnytimes lally lcomb llnnytimesxlally ltargetexp llngdppc2 lpolity22 lndist tiyr electionprox lavapp lunemp linfl) (llnnytimes = lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist lelec), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp_with= llnnytimes lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiwyr electionprox lavapp lunemp linfl) (llnnytimes = lcomb lally ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp_with= llnnytimes lally lcomb llnnytimesxlally ltargetexp llngdppc2 lpolity22 lndist tiwyr electionprox lavapp lunemp linfl) (llnnytimes = lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)

*Post-estimation
lincom [llnnwi2]lcomb + [llnnwi2]lcombxlally

margins, at((median) _all lally=1  electionprox=0 lcomb=4 llnnwi2=(0 .69314718 1.0986123 1.3862944 1.6094379 1.7917595 1.9459101 2.0794415 2.1972246 2.3025851 2.3978953 2.4849066 2.5649494 2.6390573 2.7080502 2.7725887 2.8332133 2.8903718 2.944439 2.9957323 3.0445224 3.0910425 3.1354942 3.1780538 3.2188758 3.2580965 3.2958369 3.3322045 3.3672958 3.4011974 3.4339872 3.4657359 3.4965076 3.5263605 3.5553481 3.5835189 3.6109179 3.6375862 3.6635616 3.6888795 3.7135721 3.7376696 )) predict(pr) force



*Robustness check models
**including Newsweek and Economist
cmp (threat_all_issue=llnttlmdia2 lally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl) (lttlmdia2= lcomb lally ldep1 llngdppc2 lpolity22 llndist lelec), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_all_issue=llnttlmdia2 lally llnttlmdia2xlally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl) (lttlmdia2= lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp= llnttlmdia2 lally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl) (lttlmdia2= lcomb lally ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp= llnttlmdia2 lally lcomb llnttlmdia2xlally ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl) (lttlmdia2= lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp_with= llnttlmdia2 lally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl) (lttlmdia2= lcomb lally ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp_with= llnttlmdia2 lally lcomb llnttlmdia2xlally ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl) (lttlmdia2= lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist lelec ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)


**NYT and Washington Post -- 5-year intervals
cmp (threat_all_issue=llntotmdia lally lcomb ltargetexp llngdppc2 lpolity22 lndist  ) (llntotmdia= lcomb lally ldep1 llngdppc2 lpolity22 llndist ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_all_issue=llntotmdia lally llntotmdiaxlally lcomb ltargetexp llngdppc2 lpolity22 lndist  ) (llntotmdia= lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp=llntotmdia lally lcomb ltargetexp llngdppc2 lpolity22 lndist  ) (llntotmdia= lcomb lally ldep1 llngdppc2 lpolity22 llndist ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp=llntotmdia lally llntotmdiaxlally lcomb ltargetexp llngdppc2 lpolity22 lndist  ) (llntotmdia= lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp_with=llntotmdia lally lcomb ltargetexp llngdppc2 lpolity22 lndist  ) (llntotmdia= lcomb lally ldep1 llngdppc2 lpolity22 llndist ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)
cmp (threat_or_imp_with=llntotmdia lally llntotmdiaxlally lcomb ltargetexp llngdppc2 lpolity22 lndist  ) (llntotmdia= lcomb lally lcombxlall ldep1 llngdppc2 lpolity22 llndist ), nolr ind($cmp_probit $cmp_cont)  cluster(dyadid)


**probit, Newsweek data
probit threat_all_issue llnnwi2 lally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_all_issue c.llnnwi2##c.lally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_or_imp llnnwi2 lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_or_imp c.llnnwi2##c.c.lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_or_imp_w llnnwi2 lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiwyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_or_imp_w c.llnnwi2##c.lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiwyr  electionprox lavapp lunemp linfl,  cluster(dyadid)


**probit, NYT data
probit threat_all_issue llnnytimes lally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_all_issue c.llnnytimes##c.lally lcomb ltargetexp llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_or_imp llnnytimes lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_or_imp c.llnnytimes##c.c.lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_or_imp_w llnnytimes lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiwyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_or_imp_w c.llnnytimes##c.lally lcomb ltargetexp llngdppc2 lpolity22 lndist tiwyr  electionprox lavapp lunemp linfl,  cluster(dyadid)


***interacting target export share (and alliance) with media
probit threat_all_issue c.llnnwi2##(c.ltargetexp c.lally) lcomb llngdppc2 lpolity22 lndist threatyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_or_imp c.llnnwi2##(c.ltargetexp c.lally) lcomb llngdppc2 lpolity22 lndist tiyr  electionprox lavapp lunemp linfl,  cluster(dyadid)
probit threat_or_imp_with c.llnnwi2##(c.ltargetexp c.lally) lcomb llngdppc2 lpolity22 lndist tiwyr  electionprox lavapp lunemp linfl,  cluster(dyadid)

