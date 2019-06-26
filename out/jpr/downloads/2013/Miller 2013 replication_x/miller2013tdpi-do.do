* Table 1 models.

xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues  initnonterrmid5yc tarnonterrmid5yc initterrmid5yc tarterrmid5yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, || ccode:
estimates store m4
xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues  nonterrmid5yc terrmid5yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, || ccode:
estimates store m3
xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues mid5yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, || ccode:
estimates store m2
xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues  || ccode:
estimates store m1
esttab m1 m2 m3 m4 using "Dropbox/projects/well-being/analysis/table1.tex", tex replace b(%10.3f) se title("Multilevel Models of Individual Subjective Well-being")
* This esttab procedure is very crude.  Some additional formatting is in order.
* Standard deviation of the random effect will have to be included manually. This isn't difficult.  
* Regional effects should be suppressed from this table by the reader, though they are there to observe.
* I suppress the constant, because it is not very informative in the mixed effects modeling framework.
* Importantly, this procedure is helpful to reduce the chance of human error in creating LaTeX tables.

* Three year counts as a robustness check

xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues  initnonterrmid3yc tarnonterrmid3yc initterrmid3yc tarterrmid3yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, || ccode:
estimates store threeyearm4
xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues  nonterrmid3yc terrmid3yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, || ccode:
estimates store threeyearm3
xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues mid3yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, || ccode:
estimates store threeyearm2
esttab m1 threeyearm2 threeyearm3 threeyearm4 using "Dropbox/projects/well-being/analysis/tab-3yc.tex", tex replace b(%10.3f) se title("Multilevel Models of Individual Subjective Well-being with Three Year Counts")
* Again, I recommend additional formatting.
* This esttab process is there to reduce the chance of human error as much as possible.

* One year counts as a robustness check.  It mostly fails for the hypotheses of interest, but, as I mention in the appendix, I'm not terribly worried about it.

xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues  initnonterrmid1yc tarnonterrmid1yc initterrmid1yc tarterrmid1yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, || ccode:
estimates store oneyearm4
xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues  nonterrmid1yc terrmid1yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, || ccode:
estimates store oneyearm3
xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues mid1yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, || ccode:
estimates store oneyearm2
esttab m1 oneyearm2 oneyearm3 oneyearm4 using "Dropbox/projects/well-being/analysis/tab-1yc.tex", tex replace b(%10.3f) se title("Multilevel Models of Individual Subjective Well-being with One Year Counts")
*Again, additional formatting necessary.


* Outcomes included as a robustness check.

xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues  initnonterrmid5yc tarnonterrmid5yc initterrmid5yc tarterrmid5yc win loss compromise yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, || ccode:
estimates store outcomes
esttab outcomes using "Dropbox/projects/well-being/analysis/tab-outcomes.tex", tex replace b(%10.3f) se title("Multilevel Models of Individual Subjective Well-being with Outcome Variables")


* Religion dummies.

xtmelogit mostlyhappy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues  atheist jewish muslim catholic christian  orthodox  buddhist  initnonterrmid5yc tarnonterrmid5yc initterrmid5yc tarterrmid5yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, || ccode:
estimates store religiondummies
esttab religiondummies using "Dropbox/projects/well-being/analysis/tab-religiondummies.tex", tex replace b(%10.3f) se title("Multilevel Models of Individual Subjective Well-being with Religion Dummies")


* Ordered logit with robust standard errors.

ologit happy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues  initnonterrmid5yc tarnonterrmid5yc initterrmid5yc tarterrmid5yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, vce(robust)
estimates store ologm4
ologit happy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues  nonterrmid5yc terrmid5yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, vce(robust)
estimates store ologm3
ologit happy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues mid5yc yrdem6 zinflationcpi zwvsperunemploy zlifeexptotal i.region, vce(robust)
estimates store ologm2
ologit happy age age2 female stablerel unemployed highincome lowincome collegeed importrelig trustmostpeople friendsimportant timewithfriends spendtimewithcolleagues, vce(robust)
estimates store ologm1
esttab ologm1 ologm2 ologm3 ologm4 using "Dropbox/projects/well-being/analysis/tab-olog.tex", tex replace b(%10.3f) se title("Ordered Logit Models of Individual Subjective Well-being")

