
** Replication dataset for Joshi, Maloy, and Peterson: "Popular vs. elite democratic structures and international peace."
**  Please direct any comments to Timothy M. Peterson, timothy.peterson@sc.edu



** Models from paper

xtlogit init_MID c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m1

xtlogit  init_use c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001
est store m2

outreg2 [m1 m2] using table1, bdec(3) alpha(0.001, 0.01, 0.05) word addstat(chi2, e(chi2), ll, e(ll))



** Appendix models
* Appendix table 1 (additional controls)

xtlogit  init_MID c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m1

xtlogit  init_use c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001
est store m2

xtlogit  init_MID c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001 israel us
est store m3

xtlogit  init_use c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001 israel us
est store m4

xtlogit  init_MID c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001 israel us
est store m5

xtlogit  init_use c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001 israel us
est store m6

outreg2 [m1 m2 m3 m4 m5 m6] using table_a1, bdec(3) alpha(0.001, 0.01, 0.05) word addstat(chi2, e(chi2), ll, e(ll))


* Appendix table 2 (unweighted IDI)

xtlogit  init_MID c.l.IDI_unweighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m1

xtlogit  init_use c.l.IDI_unweighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001
est store m2

xtlogit  init_MID c.l.IDI_unweighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m3

xtlogit  init_use c.l.IDI_unweighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001
est store m4

xtlogit  init_MID c.l.IDI_unweighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001 israel us
est store m5

xtlogit  init_use c.l.IDI_unweighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001 israel us
est store m6

xtlogit  init_MID c.l.IDI_unweighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001 israel us
est store m7

xtlogit  init_use c.l.IDI_unweighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001 israel us
est store m8

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8] using table_a2, bdec(3) alpha(0.001, 0.01, 0.05) word addstat(chi2, e(chi2), ll, e(ll))


* Appendix table 3 (DD index for target democracy)

xtlogit  init_MID c.l.IDI_weighted##c.l.democracy2 l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m1

xtlogit  init_use c.l.IDI_weighted##c.l.democracy2 l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001
est store m2

xtlogit  init_MID c.l.IDI_weighted##c.l.democracy2 l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m3

xtlogit  init_use c.l.IDI_weighted##c.l.democracy2 l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001
est store m4

xtlogit  init_MID c.l.IDI_weighted##c.l.democracy2 l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001 israel us
est store m5

xtlogit  init_use c.l.IDI_weighted##c.l.democracy2 l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001 israel us
est store m6

xtlogit  init_MID c.l.IDI_weighted##c.l.democracy2 l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001 israel us 
est store m7

xtlogit  init_use c.l.IDI_weighted##c.l.democracy2 l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001 israel us
est store m8

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8] using table_a3, bdec(3) alpha(0.001, 0.01, 0.05) word addstat(chi2, e(chi2), ll, e(ll))


* Appendix table 4 (omitting interaction term)

xtlogit  init_MID c.l.IDI_weighted c.l.polity2a l.caprat l.s_wt_glo lndist c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m1

xtlogit  init_use c.l.IDI_weighted c.l.polity2a  l.caprat l.s_wt_glo lndist c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001
est store m2

xtlogit  init_MID c.l.IDI_weighted c.l.polity2a  l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m3

xtlogit  init_use c.l.IDI_weighted c.l.polity2a  l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001
est store m4

xtlogit  init_MID c.l.IDI_weighted c.l.polity2a  l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001 israel us
est store m5

xtlogit  init_use c.l.IDI_weighted c.l.polity2a  l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001 israel us
est store m6

xtlogit  init_MID c.l.IDI_weighted c.l.polity2a  l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001 israel us
est store m7

xtlogit  init_use c.l.IDI_weighted c.l.polity2a  l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001 israel us
est store m8

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8] using table_a4, bdec(3) alpha(0.001, 0.01, 0.05) word addstat(chi2, e(chi2), ll, e(ll))


* Appendix table 5 (IDI components)

xtlogit init_MID (c.l.votacc)##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m1

xtlogit init_MID (c.l.legrep)##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m2

xtlogit init_MID (c.l.votacc c.l.legrep)##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m3

xtlogit  init_use (c.l.votacc)##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001
est store m4

xtlogit  init_use (c.l.legrep)##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001
est store m5

xtlogit  init_use (c.l.votacc c.l.legrep)##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001
est store m6

outreg2 [m1 m2 m3 m4 m5 m6] using table_a7, bdec(3) alpha(0.001, 0.01, 0.05) word addstat(chi2, e(chi2), ll, e(ll))


* Appendix table 6 (IDI base components)

xtlogit init_MID (c.l.electoralsystem )##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m1

xtlogit init_MID (c.l.univsuff )##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m2

xtlogit init_MID ( c.l.autoreg )##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m3

xtlogit init_MID ( c.l.compvote)##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m4

xtlogit init_MID (c.l.unicameral)##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m5

xtlogit init_MID (c.l.electoralsystem c.l.univsuff c.l.autoreg c.l.compvote c.l.unicameral)##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001
est store m6

outreg2 [m1 m2 m3 m4 m5 m6] using table_a8, bdec(3) alpha(0.001, 0.01, 0.05) word addstat(chi2, e(chi2), ll, e(ll))



* Appendix table 7 (logit models with clustered standard errors)

logit init_MID c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar 2001.year, cluster(dyad)
est store m1

logit init_MID c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar 2001.year, cluster(dyad)
est store m2

logit init_use c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar 2001.year, cluster(dyad)
est store m3

logit init_use c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar 2001.year, cluster(dyad)
est store m4

logit init_MID c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar 2001.year israel us, cluster(dyad)
est store m5

logit init_MID c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar 2001.year israel us, cluster(dyad)
est store m6

logit init_use c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar 2001.year israel us, cluster(dyad)
est store m7

logit init_use c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.l.dep1##c.l.dep2 l.totigo c.l.lngdppc1##c.l.lngdppc2 c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar 2001.year israel us, cluster(dyad)
est store m8

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8] using table_a5, bdec(3) alpha(0.001, 0.01, 0.05) word addstat(chi2, e(chi2), ll, e(ll))



** For Appendix table 8 (interaction significance)

xtlogit init_MID c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001

margins if e(sample),  at((medians) _all l.IDI_weighted=(0 6)l.polity2a=(0 20)) pr(pu0)  post
nlcom ( _b[4._at] - _b[2._at]) - ( _b[3._at] - _b[1._at])
nlcom  _b[4._at] - _b[2._at]
nlcom  _b[3._at] - _b[1._at]
nlcom  _b[4._at] - _b[3._at]
nlcom  _b[2._at] - _b[1._at]

margins if e(sample),  at((medians) _all L.s_wt_glo=0.05 l.IDI_weighted=(0 6) l.polity2a=(0 20)) pr(pu0) post
nlcom ( _b[4._at] - _b[2._at]) - ( _b[3._at] - _b[1._at])
nlcom  _b[4._at] - _b[2._at]
nlcom  _b[3._at] - _b[1._at]
nlcom  _b[4._at] - _b[3._at]
nlcom  _b[2._at] - _b[1._at]



** For Figure 2

xtlogit init_MID c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001

margins if e(sample), dydx(l.IDI_weighted)  at((medians) _all l.polity2a=(0(1)20)) pr(pu0)
margins if e(sample), dydx(l.polity2a)  at((medians) _all l.IDI_weighted=(0(.5)6)) pr(pu0)

xtlogit  init_use c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001

margins if e(sample), dydx(l.IDI_weighted)  at((medians) _all l.polity2a=(0(1)20)) pr(pu0)
margins if e(sample), dydx(l.polity2a)  at((medians) _all l.IDI_weighted=(0(.5)6)) pr(pu0)


** For Figure 3

xtlogit init_MID c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_MID_yr##c.init_MID_yr##c.init_MID_yr coldwar year2001

margins if e(sample),  at((medians) _all  l.IDI_weighted=(0)l.polity2a=(0(1)20)) pr(pu0)
margins if e(sample),  at((medians) _all  l.IDI_weighted=(6)l.polity2a=(0(1)20)) pr(pu0)

xtlogit  init_use c.l.IDI_weighted##c.l.polity2a l.caprat lndist l.s_wt_glo c.init_use_yr##c.init_use_yr##c.init_use_yr coldwar year2001

margins if e(sample),  at((medians) _all  l.IDI_weighted=(0)l.polity2a=(0(1)20)) pr(pu0)
margins if e(sample),  at((medians) _all  l.IDI_weighted=(6)l.polity2a=(0(1)20)) pr(pu0)



