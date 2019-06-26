**With the exception of Table II and Appendix B, all tables and figures were created using Stata.
*In the case of Table II and Appendix B, SPSS was used since the sample weight was not supported by Stata

***MAIN ANALYSIS***
*Table I*
factor  mixmarr ownstate safety coop if year==1989, mineigen(1)
estat kmo
alpha  mixmarr ownstate safety coop if year==1989
factor  mixmarr ownstate safety coop if year==2003
estat kmo
alpha  mixmarr ownstate safety coop if year==2003

*Table II*
*Copy this into SPSS syntax
WEIGHT BY stdwt.
USE ALL.
COMPUTE filter_$=(cid=1&year=2003).
VARIABLE LABEL filter_$ 'cid=1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
DESCRIPTIVES VARIABLES=nationalism male age religious education income rural_now rural_prev killed
  /STATISTICS=MEAN STDDEV MIN MAX.
USE ALL.
COMPUTE filter_$=(cid=3&year=2003).
VARIABLE LABEL filter_$ 'cid=3 (FILTER)'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
DESCRIPTIVES VARIABLES=nationalism male age religious education income rural_now rural_prev killed
  /STATISTICS=MEAN STDDEV MIN MAX.
USE ALL.
COMPUTE filter_$=(cid=6&year=2003).
VARIABLE LABEL filter_$ 'cid=6 (FILTER)'.
FORMAT filter_$ (f1.0).
FILTER BY filter_$.
DESCRIPTIVES VARIABLES=nationalism male age religious education income rural_now rural_prev killed
  /STATISTICS=MEAN STDDEV MIN MAX.

*Approximation in Stata (without sample weight)
sum nationalism male age religious education income rural_now rural_prev killed if cid==6&year==2003
sum nationalism male age religious education income rural_now rural_prev killed if cid==1&year==2003
sum nationalism male age religious education income rural_now rural_prev killed if cid==3&year==2003

*Table III*
xi: reg nationalism i.year*wardummy  [pw=stdwt], cl(cid)
test wardummy _IyeaXwar_2003
*Left upper square = constant term
*Right upper square
di 2.464029 + .3513515
*Left lower square
di 2.464029 + .1686877
*Left lower square
di 2.464029 + .1686877 + .3513515 + .3063803
*robustness
xi: reg nationalism i.year*wardummy

*Table IV*
*to reproduce table IV, follow the procedure below specifying the desired country/ethnicity (cid_ethn)
*e.g. Albanian (ethnicity ==1) in Kosovo (cid==6)
ttest nationalism if cid_ethn==601, by(year)
*e.g. "Other" (ethnicity==10) in Vojvodina (country==7)
ttest nationalism  if cid_ethn==710, by(year)
*for country and sample totals, data should be weighted, e.g. Bosnia, Croatia and total sample:
xi: reg nationalism i.year if cid==1 [pw=stdwt]
xi: reg nationalism i.year if cid==3 [pw=stdwt]
xi: reg nationalism i.year [pw=stdwt]

*Table V*
char ethnicity[omit]8
char cid[omit]3
xi: reg nationalism  i.cid ib(8).ethnicity male age religious education income rural_now rural_prev killed [pw=stdwt] if warcountry ==1, cl(cid)
outreg2 using table, replace bdec(3) 2aster
xi: reg nationalism  i.cid*killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if warcountry ==1, cl(cid)
outreg2 using table, append bdec(3) 2aster

*Figure 1*
graph box nationalism [pweight = stdwt], over(year) over(c_order)

***SENSITIVITY ANALYSIS***
*Appendix B*
*Created in Excel from descriptive statistics (see Table II above for syntax).

*Appendic C*
tab ethnicity year if cid==1, col
tab ethnicity year if cid==2, col
tab ethnicity year if cid==3, col
tab ethnicity year if cid==4, col
tab ethnicity year if cid==5, col
tab ethnicity year if cid==6, col
tab ethnicity year if cid==7, col

*Appendix D*
xi: reg nationalism  i.cid*killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if warcountry ==1, cl(cid)
outreg2 using appendix, replace bdec(3) 2aster
xi: reg nationalism  i.cid*emigrated ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if warcountry ==1, cl(cid)
outreg2 using appendix, append bdec(3) 2aster
xi: reg nationalism  i.cid*famwound ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if warcountry ==1, cl(cid)
outreg2 using appendix, append bdec(3) 2aster
xi: reg nationalism  i.cid*captured ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if warcountry ==1, cl(cid)
outreg2 using appendix, append bdec(3) 2aster

*Appendix E*
xi: reg nationalism  killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt]if cid==6&year==2003
xi: reg mixmarr killed ib(8).ethnicity male age religious education income rural_now rural_prev if cid==6&year==2003
xi: reg safety killed ib(8).ethnicity male age religious education income rural_now rural_prev if cid==6&year==2003
xi: reg coop killed ib(8).ethnicity male age religious education income rural_now rural_prev if cid==6&year==2003
xi: reg ownstate killed ib(8).ethnicity male age religious education income rural_now rural_prev if cid==6&year==2003

xi: reg nationalism  killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if cid==1&year==2003
xi: reg mixmarr killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if cid==1&year==2003
xi: reg safety killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if cid==1&year==2003
xi: reg coop killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if cid==1&year==2003
xi: reg ownstate killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if cid==1&year==2003

xi: reg nationalism  killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if cid==3
xi: reg mixmarr killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if cid==3&year==2003
xi: reg safety killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if cid==3&year==2003
xi: reg coop killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if cid==3&year==2003
xi: reg ownstate killed ib(8).ethnicity male age religious education income rural_now rural_prev [pw=stdwt] if cid==3&year==2003

*Appendix F*
xtset cluster
char ethnicity[omit]8
char cid[omit]3
xi: xtreg nationalism i.cid killed male age religious education income rural_now rural_prev if warcountry==1, mle nolog
outreg2 using test, bdec(3) replace 2aster
xi: xtreg nationalism i.cid*killed male age religious education income rural_now rural_prev if warcountry==1, mle nolog
outreg2 using test, bdec(3) append 2aster
