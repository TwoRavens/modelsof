**Replication Data for Lupton "The External Validity of College Student Subject Pools in Experimental Research:**
**A Cross-Sample Comparison of Treatment Effect Heterogeneity"**

**Read in Data**
use LuptonExternalValidityReplicationData.dta

**To Replicate Results from Main Body Text**

**To Replicate Figure 1**
reg response democracy stateinterest staterep leaderrep if pool=="A", robust
estimates store A
reg response democracy stateinterest staterep leaderrep if pool=="B", robust
estimates store B
reg response democracy stateinterest staterep leaderrep if pool=="C", robust
estimates store C
reg response democracy stateinterest staterep leaderrep if pool=="AMT", robust
estimates store D
coefplot A B C D, drop(_cons) xline(0) 
graph save Figure1, replace

**To Replicate Results from Appendix**

**To Replicate Table A.1**
putexcel set TableA_1.xlsx, sheet(Sheet1) replace
putexcel A2 = "Partisanship"
putexcel A3 = "% Democrat"
putexcel A4 = "% Republican"
putexcel A5 = "% Female"
putexcel A6 = "Political Affiliation"
putexcel A7 = "% Conservative"
putexcel A8 = "% Liberal"
putexcel A9 = "Age (Mean"
putexcel A10 = "% Somewhat or Very Interested in Politics"
putexcel A11 = "% Somewhat or Very Closely Follow International Events"
putexcel A12 = "Attention to News in Past Week"
putexcel A13 = "% Once a day or more"
putexcel A14 = "% 3-5 Times a week"
putexcel A15 = "% Once a week"
putexcel A16 = "% Not at all"
putexcel A17 = "Views on the Role of Leaders"
putexcel A18 = "% Strongly or somewhat agree leaders are important..."
putexcel A19 = "% Strongly or somewhat disagree a country..."
putexcel A20 = "Views on the Use of Force"
putexcel A21 = "% Strongly or somewhat agree that sometimes..."
putexcel A22 = "% Strongly or somewhat agree the use of military..."
putexcel A23 = "% Drop Out Survey"
putexcel A24 = "N (completed)"
putexcel B1 = "Student Sample A"
putexcel C1 = "Student Sample B"
putexcel D1 = "Student Sample C"
putexcel E1 = "MTurk Sample"
tab party pool, column nofreq 
**Copy and paste values from results into excel table**
putexcel B3 = "50.00"
putexcel B4 = "18.18"
putexcel C3 = "44.62"
putexcel C4 = "22.31"
putexcel D3 = "25.46"
putexcel D4 = "42.59"
putexcel E3 = "42.51"
putexcel E4 = "15.21"
tab gender pool, column nofreq
putexcel B5 = "53.21"
putexcel C5 = "44.09"
putexcel D5 = "43.98"
putexcel E5 = "43.24"
tab polaffil pool, column nofreq
di 1.85+6.48+17.59
putexcel B7 = "25.92"
di 20.37+37.04+12.04
putexcel B8 = "62.04"
di 7.69+3.85
putexcel C7 = "11.54"
di 23.85+20.77+20.77
putexcel C8 = "65.39"
putexcel D7 = "31.84"
di 19.40+12.94+16.92
putexcel D8 = "49.26"
di 7.12+6.58+7.90
putexcel E7 = "21.60"
di 17.75+29.60+11.41
putexcel E8 = "58.76"
sort pool
by pool: sum age
putexcel B9 = "20.07"
putexcel C9 = "21.52"
putexcel D9 = "23.78"
putexcel E9 = "34.33"
tab polint pool, column nofreq
di 44.95+44.95
putexcel B10 = "89.90"
di 11.54+10.00
putexcel C10 = "21.54"
di 54.17+13.43
putexcel D10 = "67.60"
di 51.96+8.27
putexcel E10 = "60.23"
tab eventint pool, column nofreq
di 50.00+20.91
putexcel B11 = "70.91"
di 26.92+1.54
putexcel C11 = "28.46"
di 38.14+7.91
putexcel D11 = "46.05"
di 42.61+5.38
putexcel E11 = "47.99"
tab attention pool, column nofreq
putexcel B13 = "13.64"
putexcel B14 = "32.73" 
putexcel B15 = "26.36"
putexcel B16 = "27.27"
di 23.08+20.77
putexcel C13 = "43.85"
putexcel C14 = "31.54"
putexcel C15 = "15.38"
putexcel C16 = "9.23"
di 6.02+18.06
putexcel D13 = "24.08"
putexcel D14 = "34.72"
putexcel D15 = "22.22"
putexcel D16 = "18.98"
di 3.78+19.23
putexcel E13 = "23.01"
putexcel E14 = "34.34"
putexcel E15 = "21.78"
putexcel E16 = "20.88"
tab leaderimp pool, column nofreq
di 56.36+31.82
putexcel B18 = "88.18"
di 10.24+7.87 
putexcel C18 = "18.11"
di 51.39+36.11
putexcel D18 = "87.50"
di 56.40+30.18
putexcel E18 = "86.58"
tab leadersig pool, column nofreq
di 50.91+30.91
putexcel B19 = "81.82"
di 49.21+25.40
putexcel C19 = "74.61"
di 42.79+36.74
putexcel D19 = "79.53"
di 43.41+21.45
putexcel E19 = "64.86"
tab forceok pool, column nofreq
di 41.82+16.36
putexcel B21 = "58.18"
di 22.05+9.45
putexcel C21 = "31.50"
di 28.70+7.41
putexcel D21 = "36.11"
di 34.91+4.82
putexcel E21 = "39.73"
tab forcebad pool, column nofreq
di 37.27+5.45
putexcel B22 = "42.72"
di 29.13+4.72
putexcel C22 = "33.85"
di 17.13+3.24
putexcel D22 = "20.37"
di 20.36+3.45
putexcel E22 = "23.81"
**Drop out rates were calculated using data from the qualtrics browser platform**
putexcel B23 = "34.13"
putexcel C23 = "9.70"
putexcel D23 = "10.74"
putexcel E23 = "12.92"
tab pool
putexcel B24 = "110"
putexcel C24 = "130"
putexcel D24 = "216"
putexcel E24 = "2,117"
 
**To Replicate Table A.2**
reg response democracy stateinterest staterep leaderrep subjectPool, robust
outreg2 using TableA_2, replace excel dec(3) alpha(0.001, 0.01, 0.05)
reg response democracy stateinterest staterep leaderrep if pool=="A", robust
outreg2 using TableA_2, append excel dec(3) alpha(0.001, 0.01, 0.05)
reg response democracy stateinterest staterep leaderrep if pool=="B", robust
outreg2 using TableA_2, append excel dec(3) alpha(0.001, 0.01, 0.05)
reg response democracy stateinterest staterep leaderrep if pool=="C", robust
outreg2 using TableA_2, append excel dec(3) alpha(0.001, 0.01, 0.05)
reg response democracy stateinterest staterep leaderrep if pool=="AMT", robust
outreg2 using TableA_2, append excel dec(3) alpha(0.001, 0.01, 0.05)

**To Replicate Table A.3**
reg response i.democracy i.stateinterest i.staterep i.leaderrep subjectPool, robust
outreg2 using TableA_3, replace excel dec(3) alpha(0.001, 0.01, 0.05)
reg response i.democracy i.stateinterest i.staterep i.leaderrep if pool=="A", robust
outreg2 using TableA_3, append excel dec(3) alpha(0.001, 0.01, 0.05)
reg response i.democracy i.stateinterest i.staterep i.leaderrep if pool=="B", robust
outreg2 using TableA_3, append excel dec(3) alpha(0.001, 0.01, 0.05)
reg response i.democracy i.stateinterest i.staterep i.leaderrep if pool=="C", robust
outreg2 using TableA_3, append excel dec(3) alpha(0.001, 0.01, 0.05)
reg response i.democracy i.stateinterest i.staterep i.leaderrep if pool=="AMT", robust
outreg2 using TableA_3, append excel dec(3) alpha(0.001, 0.01, 0.05)

**To Replicate Table A.4**
putexcel set TableA_4.xlsx, sheet(Sheet1) replace
putexcel A2 = "Regime Type"
putexcel A4 = "State Interest"
putexcel A6 = "Past State Behavior"
putexcel A8 = "Past Leader Behavior"
putexcel B1 = "A vs. B"
putexcel C1 = "A vs. C"
putexcel D1 = "B vs. C"
putexcel E1 = "A vs. MTurk"
putexcel F1 = "B vs. Mturk"
putexcel G1 = "C vs. MTurk"
oneway response pool if democracy!=0&(pool=="A"|pool=="B"), t
putexcel B2 = (r(F))
putexcel B3 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if democracy!=0&(pool=="A"|pool=="C"), t
putexcel C2 = (r(F))
putexcel C3 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if democracy!=0&(pool=="B"|pool=="C"), t
putexcel D2 = (r(F))
putexcel D3 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if democracy!=0&(pool=="A"|pool=="AMT"), t
putexcel E2 = (r(F))
putexcel E3 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if democracy!=0&(pool=="B"|pool=="AMT"), t
putexcel F2 = (r(F))
putexcel F3 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if democracy!=0&(pool=="C"|pool=="AMT"), t
putexcel G2 = (r(F))
putexcel G3 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if stateinterest!=0&(pool=="A"|pool=="B"), t
putexcel B4 = (r(F))
putexcel B5 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if stateinterest!=0&(pool=="A"|pool=="C"), t
putexcel C4 = (r(F))
putexcel C5 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if stateinterest!=0&(pool=="B"|pool=="C"), t
putexcel D4 = (r(F))
putexcel D5 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if stateinterest!=0&(pool=="A"|pool=="AMT"), t
putexcel E4 = (r(F))
putexcel E5 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if stateinterest!=0&(pool=="B"|pool=="AMT"), t
putexcel F4 = (r(F)) 
putexcel F5 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if stateinterest!=0&(pool=="C"|pool=="AMT"), t
putexcel G4 = (r(F))
putexcel G5 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if staterep!=0&(pool=="A"|pool=="B"), t
putexcel B6 = (r(F))
putexcel B7 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if staterep!=0&(pool=="A"|pool=="C"), t
putexcel C6 = (r(F))
putexcel C7 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if staterep!=0&(pool=="B"|pool=="C"), t
putexcel D6 = (r(F))
putexcel D7 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if staterep!=0&(pool=="A"|pool=="AMT"), t
putexcel E6 = (r(F))
putexcel E7 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if staterep!=0&(pool=="B"|pool=="AMT"), t
putexcel F6 = (r(F))
putexcel F7 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if staterep!=0&(pool=="C"|pool=="AMT"), t
putexcel G6 = (r(F))
putexcel G7 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if leaderrep!=0&(pool=="A"|pool=="B"), t
putexcel B8 = (r(F))
putexcel B9 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if leaderrep!=0&(pool=="A"|pool=="C"), t
putexcel C8 = (r(F))
putexcel C9 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if leaderrep!=0&(pool=="B"|pool=="C"), t
putexcel D8 = (r(F))
putexcel D9 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if leaderrep!=0&(pool=="A"|pool=="AMT"), t
putexcel E8 = (r(F))
putexcel E9 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if leaderrep!=0&(pool=="B"|pool=="AMT"), t
putexcel F8 = (r(F))
putexcel F9 = (Ftail(r(df_m), r(df_r), r(F)))
oneway response pool if leaderrep!=0&(pool=="C"|pool=="AMT"), t
putexcel G8 = (r(F))
putexcel G9 = (Ftail(r(df_m), r(df_r), r(F)))

**To Replicate Table A.5**
putexcel set TableA_5.xlsx, sheet(Sheet1) replace
putexcel A2 = "Partisanship"
putexcel A4 = "Political Affiliation"
putexcel A6 = "Gender"
putexcel A8 = "Interest in Int'l Politics"
putexcel A10 = "Attention to Int'l Politics"
putexcel A12 = "Impact of Int'l Leaders (mean)"
putexcel A14 = "Acceptability of Use of Force (mean)"
putexcel B1 = "A vs. B"
putexcel C1 = "A vs. C"
putexcel D1 = "B vs. C"
putexcel E1 = "A vs. MTurk"
putexcel F1 = "B vs. Mturk"
putexcel G1 = "C vs. MTurk"
oneway party pool if pool=="A"|pool=="B", t
putexcel B2 = (r(F))   
putexcel B3 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway party pool if pool=="A"|pool=="C", t
putexcel C2 = (r(F))   
putexcel C3 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway party pool if pool=="B"|pool=="C", t
putexcel D2 = (r(F))   
putexcel D3 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway party pool if pool=="A"|pool=="AMT", t
putexcel E2 = (r(F))   
putexcel E3 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway party pool if pool=="B"|pool=="AMT", t
putexcel F2 = (r(F))   
putexcel F3 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway party pool if pool=="C"|pool=="AMT", t
putexcel G2 = (r(F))   
putexcel G3 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway polaffil pool if pool=="A"|pool=="B", t
putexcel B4 = (r(F))   
putexcel B5 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway polaffil pool if pool=="A"|pool=="C", t
putexcel C4 = (r(F))   
putexcel C5 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway polaffil pool if pool=="B"|pool=="C", t
putexcel D4 = (r(F))   
putexcel D5 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway polaffil pool if pool=="A"|pool=="AMT", t
putexcel E4 = (r(F))   
putexcel E5 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway polaffil pool if pool=="B"|pool=="AMT", t
putexcel F4 = (r(F))   
putexcel F5 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway polaffil pool if pool=="C"|pool=="AMT", t
putexcel G4 = (r(F))   
putexcel G5 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway gender pool if pool=="A"|pool=="B", t
putexcel B6 = (r(F))   
putexcel B7 = (Ftail(r(df_m), r(df_r), r(F))) 
oneway gender pool if pool=="A"|pool=="C", t
putexcel C6 = (r(F))   
putexcel C7 = (Ftail(r(df_m), r(df_r), r(F)))
oneway gender pool if pool=="B"|pool=="C", t
putexcel D6 = (r(F))
putexcel D7 = (Ftail(r(df_m), r(df_r), r(F)))
oneway gender pool if pool=="A"|pool=="AMT", t
putexcel E6 = (r(F))
putexcel E7 = (Ftail(r(df_m), r(df_r), r(F)))
oneway gender pool if pool=="B"|pool=="AMT", t
putexcel F6 = (r(F))
putexcel F7 = (Ftail(r(df_m), r(df_r), r(F)))
oneway gender pool if pool=="C"|pool=="AMT", t
putexcel G6 = (r(F)) 
putexcel G7 = (Ftail(r(df_m), r(df_r), r(F)))
oneway polint pool if pool=="A"|pool=="B", t
putexcel B8 = (r(F))
putexcel B9 = (Ftail(r(df_m), r(df_r), r(F)))
oneway polint pool if pool=="A"|pool=="C", t
putexcel C8 = (r(F))
putexcel C9 = (Ftail(r(df_m), r(df_r), r(F)))
oneway polint pool if pool=="B"|pool=="C", t
putexcel D8 = (r(F))
putexcel D9 = (Ftail(r(df_m), r(df_r), r(F)))
oneway polint pool if pool=="A"|pool=="AMT", t
putexcel E8 = (r(F))
putexcel E9 = (Ftail(r(df_m), r(df_r), r(F)))
oneway polint pool if pool=="B"|pool=="AMT", t
putexcel F8 = (r(F))
putexcel F9 = (Ftail(r(df_m), r(df_r), r(F)))
oneway polint pool if pool=="C"|pool=="AMT", t
putexcel G8 = (r(F))
putexcel G9 = (Ftail(r(df_m), r(df_r), r(F)))
oneway eventint pool if pool=="A"|pool=="B", t
putexcel B10 = (r(F))
putexcel B11 = (Ftail(r(df_m), r(df_r), r(F)))
oneway eventint pool if pool=="A"|pool=="C", t
putexcel C10 = (r(F))
putexcel C11 = (Ftail(r(df_m), r(df_r), r(F)))
oneway eventint pool if pool=="B"|pool=="C", t
putexcel D10 = (r(F))
putexcel D11 = (Ftail(r(df_m), r(df_r), r(F)))
oneway eventint pool if pool=="A"|pool=="AMT", t
putexcel E10 = (r(F))
putexcel E11 = (Ftail(r(df_m), r(df_r), r(F)))
oneway eventint pool if pool=="B"|pool=="AMT", t
putexcel F10 = (r(F))
putexcel F11 = (Ftail(r(df_m), r(df_r), r(F)))
oneway eventint pool if pool=="C"|pool=="AMT", t
putexcel G10 = (r(F)) 
putexcel G11 = (Ftail(r(df_m), r(df_r), r(F)))
oneway LeaderViews pool if pool=="A"|pool=="B", t
putexcel B12 = (r(F))
putexcel B13 = (Ftail(r(df_m), r(df_r), r(F)))
oneway LeaderViews pool if pool=="A"|pool=="C", t
putexcel C12 = (r(F)) 
putexcel C13 = (Ftail(r(df_m), r(df_r), r(F)))
oneway LeaderViews pool if pool=="B"|pool=="C", t
putexcel D12 = (r(F))
putexcel D13 = (Ftail(r(df_m), r(df_r), r(F)))
oneway LeaderViews pool if pool=="A"|pool=="AMT", t
putexcel E12 = (r(F))
putexcel E13 = (Ftail(r(df_m), r(df_r), r(F)))
oneway LeaderViews pool if pool=="B"|pool=="AMT", t
putexcel F12 = (r(F))
putexcel F13 = (Ftail(r(df_m), r(df_r), r(F)))
oneway LeaderViews pool if pool=="C"|pool=="AMT", t
putexcel G12 = (r(F))
putexcel G13 = (Ftail(r(df_m), r(df_r), r(F)))
oneway UseOfForce pool if pool=="A"|pool=="B", t
putexcel B14 = (r(F))
putexcel B15 = (Ftail(r(df_m), r(df_r), r(F)))
oneway UseOfForce pool if pool=="A"|pool=="C", t
putexcel C14 = (r(F))
putexcel C15 = (Ftail(r(df_m), r(df_r), r(F)))
oneway UseOfForce pool if pool=="B"|pool=="C", t
putexcel D14 = (r(F))
putexcel D15 = (Ftail(r(df_m), r(df_r), r(F)))
oneway UseOfForce pool if pool=="A"|pool=="AMT", t
putexcel E14 = (r(F))
putexcel E15 = (Ftail(r(df_m), r(df_r), r(F)))
oneway UseOfForce pool if pool=="B"|pool=="AMT", t
putexcel F14 = (r(F))
putexcel F15 = (Ftail(r(df_m), r(df_r), r(F)))
oneway UseOfForce pool if pool=="C"|pool=="AMT", t
putexcel G14 = (r(F))
putexcel G15 = (Ftail(r(df_m), r(df_r), r(F)))

**To Replicate Table A.6**
putexcel set TableA_6.xlsx, sheet(Sheet1) replace
putexcel A2 = "Regime Type"
putexcel A5 = "State Interest"
putexcel A8 = "Past State Behavior"
putexcel A11 = "Past Leader Behavior"
putexcel B1 = "A vs. B"
putexcel C1 = "A vs. C"
putexcel D1 = "B vs. C"
putexcel E1 = "A vs. MTurk"
putexcel F1 = "B vs. Mturk"
putexcel G1 = "C vs. MTurk"
oneway response pool if democracy!=0&(pool=="A"|pool=="B"), t
esizei 24 2.125 .612 33 1.909 .765, cohensd
putexcel B2 = (r(d))
putexcel B3 = (r(lb_d)) 
putexcel B4 = (r(ub_d))
oneway response pool if democracy!=0&(pool=="A"|pool=="C"), t
esizei 24 2.125 .612 43 2.535 .631, cohensd
putexcel C2 = (r(d))
putexcel C3 = (r(lb_d)) 
putexcel C4 = (r(ub_d))
oneway response pool if democracy!=0&(pool=="B"|pool=="C"), t
esizei 33 1.909 .765 43 2.535 .631, cohensd
putexcel D2 = (r(d))
putexcel D3 = (r(lb_d)) 
putexcel D4 = (r(ub_d))
oneway response pool if democracy!=0&(pool=="A"|pool=="AMT"), t
esizei 24 2.125 .612 436 2.321 .719, cohensd
putexcel E2 = (r(d))
putexcel E3 = (r(lb_d)) 
putexcel E4 = (r(ub_d))
oneway response pool if democracy!=0&(pool=="B"|pool=="AMT"), t
esizei 33 1.909 .765 436 2.321 .719, cohensd
putexcel F2 = (r(d))
putexcel F3 = (r(lb_d)) 
putexcel F4 = (r(ub_d))
oneway response pool if democracy!=0&(pool=="C"|pool=="AMT"), t
esizei 43 2.535 .631 436 2.321 .719, cohensd
putexcel G2 = (r(d))
putexcel G3 = (r(lb_d)) 
putexcel G4 = (r(ub_d))
oneway response pool if stateinterest!=0&(pool=="A"|pool=="B"), t
esizei 20 2.25 .639 27 1.852 .818, cohensd
putexcel B5 = (r(d))
putexcel B6 = (r(lb_d)) 
putexcel B7 = (r(ub_d))
oneway response pool if stateinterest!=0&(pool=="A"|pool=="C"), t
esizei 20 2.25 .639 60 2.133 .769, cohensd
putexcel C5 = (r(d))
putexcel C6 = (r(lb_d)) 
putexcel C7 = (r(ub_d))
oneway response pool if stateinterest!=0&(pool=="B"|pool=="C"), t
esizei 27 1.852 .818 60 2.133 .769, cohensd
putexcel D5 = (r(d))
putexcel D6 = (r(lb_d)) 
putexcel D7 = (r(ub_d))
oneway response pool if stateinterest!=0&(pool=="A"|pool=="AMT"), t
esizei 20 2.25 .639 445 2.088 .747, cohensd
putexcel E5 = (r(d))
putexcel E6 = (r(lb_d)) 
putexcel E7 = (r(ub_d))
oneway response pool if stateinterest!=0&(pool=="B"|pool=="AMT"), t
esizei 27 1.852 .818 445 2.088 .747, cohensd
putexcel F5 = (r(d))
putexcel F6 = (r(lb_d)) 
putexcel F7 = (r(ub_d))
oneway response pool if stateinterest!=0&(pool=="C"|pool=="AMT"), t
esizei 60 2.133 .769 445 2.088 .747, cohensd
putexcel G5 = (r(d))
putexcel G6 = (r(lb_d)) 
putexcel G7 = (r(ub_d))
oneway response pool if staterep!=0&(pool=="A"|pool=="B"), t
esizei 16 1.875 .806 41 2.122 .842, cohensd
putexcel B8 = (r(d))
putexcel B9 = (r(lb_d)) 
putexcel B10 = (r(ub_d))
oneway response pool if staterep!=0&(pool=="A"|pool=="C"), t
esizei 16 1.875 .806 59 1.983 .707, cohensd
putexcel C8 = (r(d))
putexcel C9 = (r(lb_d)) 
putexcel C10 = (r(ub_d))
oneway response pool if staterep!=0&(pool=="B"|pool=="C"), t
esizei 41 2.122 .842 59 1.983 .707, cohensd
putexcel D8 = (r(d))
putexcel D9 = (r(lb_d)) 
putexcel D10 = (r(ub_d))
oneway response pool if staterep!=0&(pool=="A"|pool=="AMT"), t
esizei 16 1.875 .806 438 1.993 .724, cohensd
putexcel E8 = (r(d))
putexcel E9 = (r(lb_d)) 
putexcel E10 = (r(ub_d))
oneway response pool if staterep!=0&(pool=="B"|pool=="AMT"), t
esizei 41 2.122 .842 438 1.993 .724, cohensd
putexcel F8 = (r(d))
putexcel F9 = (r(lb_d)) 
putexcel F10 = (r(ub_d))
oneway response pool if staterep!=0&(pool=="C"|pool=="AMT"), t
esizei 59 1.983 .707 438 1.993 .724, cohensd
putexcel G8 = (r(d))
putexcel G9 = (r(lb_d)) 
putexcel G10 = (r(ub_d))
oneway response pool if leaderrep!=0&(pool=="A"|pool=="B"), t
esizei 90 2.1 .735 109 2.009 .799, cohensd
putexcel B11 = (r(d))
putexcel B12 = (r(lb_d)) 
putexcel B13 = (r(ub_d))
oneway response pool if leaderrep!=0&(pool=="A"|pool=="C"), t
esizei 90 2.1 .735 162 2.185 .758, cohensd
putexcel C11 = (r(d))
putexcel C12 = (r(lb_d)) 
putexcel C13 = (r(ub_d))
oneway response pool if leaderrep!=0&(pool=="B"|pool=="C"), t
esizei 109 2.009 .799 162 2.185 .758, cohensd
putexcel D11 = (r(d))
putexcel D12 = (r(lb_d)) 
putexcel D13 = (r(ub_d))
oneway response pool if leaderrep!=0&(pool=="A"|pool=="AMT"), t
esizei 90 2.1 .735 1634 2.137 .744, cohensd
putexcel E11 = (r(d))
putexcel E12 = (r(lb_d)) 
putexcel E13 = (r(ub_d))
oneway response pool if leaderrep!=0&(pool=="B"|pool=="AMT"), t
esizei 109 2.009 .799 1634 2.137 .744, cohensd
putexcel F11 = (r(d))
putexcel F12 = (r(lb_d)) 
putexcel F13 = (r(ub_d))
oneway response pool if leaderrep!=0&(pool=="C"|pool=="AMT"), t
esizei 162 2.185 .758 1634 2.137 .744, cohensd
putexcel G11 = (r(d))
putexcel G12 = (r(lb_d)) 
putexcel G13 = (r(ub_d))

**To Replicate Table A.7**
reg response democracy stateinterest staterep leaderrep, robust
outreg2 using TableA_7, replace excel dec(3) alpha(0.001, 0.01, 0.05)
reg response democracy stateinterest staterep leaderrep male maleDemocracy maleStateInt malestaterep maleLeaderRep, robust
outreg2 using TableA_7, append excel dec(3) alpha(0.001, 0.01, 0.05)
reg response democracy stateinterest staterep leaderrep republican republicanDemocracy republicanStateInt republicanLeaderRep republicaStaterep, robust
outreg2 using TableA_7, append excel dec(3) alpha(0.001, 0.01, 0.05)
reg response democracy stateinterest staterep leaderrep HighPolInt HighPolIntDem HighPolIntStateInt HighPolIntStateRep HighPolIntLeader, robust
outreg2 using TableA_7, append excel dec(3) alpha(0.001, 0.01, 0.05)
reg response democracy stateinterest staterep leaderrep AgeLow AgeDem AgeState AgeLeader AgeStateInt, robust
outreg2 using TableA_7, append excel dec(3) alpha(0.001, 0.01, 0.05)
reg response democracy stateinterest staterep leaderrep DislikeForce DislikeForceDem DislikeForceStateInt DislikeForceState DislikeForceLeader, robust
outreg2 using TableA_7, append excel dec(3) alpha(0.001, 0.01, 0.05)
reg response democracy stateinterest staterep leaderrep Liberal LiberalDem LiberalStateInt LiberalState LiberalLeader, robust
outreg2 using TableA_7, append excel dec(3) alpha(0.001, 0.01, 0.05)

**To Replicate Table A.8**
putexcel set TableA_8.xlsx, sheet(Sheet1) replace
putexcel A2 = "Regime Type"
putexcel A4 = "State Interest"
putexcel A6 = "Past State Behavior"
putexcel A8 = "Past Leader Behavior"
putexcel B1 = "Student Sample A"
putexcel C1 = "Student Sample B"
putexcel D1 = "Student Sample C"
putexcel E1 = "MTurk Sample"
sum response if pool=="A"&democracy!=0
putexcel B2 = (r(mean))
putexcel B3 = (r(sd))
sum response if pool=="B"&democracy!=0
putexcel C2 = (r(mean))
putexcel C3 = (r(sd))
sum response if pool=="C"&democracy!=0
putexcel D2 = (r(mean))
putexcel D3 = (r(sd))
sum response if pool=="AMT"&democracy!=0
putexcel E2 = (r(mean))
putexcel E3 = (r(sd))
sum response if pool=="A"&stateinterest!=0
putexcel B4 = (r(mean))
putexcel B5 = (r(sd))
sum response if pool=="B"&stateinterest!=0
putexcel C4 = (r(mean))
putexcel C5 = (r(sd))
sum response if pool=="C"&stateinterest!=0
putexcel D4 = (r(mean))
putexcel D5 = (r(sd))
sum response if pool=="AMT"&stateinterest!=0
putexcel E4 = (r(mean))
putexcel E5 = (r(sd))
sum response if pool=="A"&staterep!=0
putexcel B6 = (r(mean))
putexcel B7 = (r(sd))
sum response if pool=="B"&staterep!=0
putexcel C6 = (r(mean))
putexcel C7 = (r(sd))
sum response if pool=="C"&staterep!=0
putexcel D6 = (r(mean))
putexcel D7 = (r(sd))
sum response if pool=="AMT"&staterep!=0
putexcel E6 = (r(mean))
putexcel E7 = (r(sd))
sum response if pool=="A"&leaderrep!=0
putexcel B8 = (r(mean))
putexcel B9 = (r(sd))
sum response if pool=="B"&leaderrep!=0
putexcel C8 = (r(mean))
putexcel C9 = (r(sd))
sum response if pool=="C"&leaderrep!=0
putexcel D8 = (r(mean))
putexcel D9 = (r(sd))
sum response if pool=="AMT"&leaderrep!=0
putexcel E8 = (r(mean))
putexcel E9 = (r(sd))

**End Do File**
