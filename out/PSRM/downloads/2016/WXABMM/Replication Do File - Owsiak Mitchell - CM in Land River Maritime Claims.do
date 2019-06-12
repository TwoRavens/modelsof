*Replication Files for: Owsiak, Andrew P., and Sara McLaughlin Mitchell. 2016. Conflict Management in Land, River, and Maritime Claims. Political Science Research and Methods.

*Analysis conducted in Stata 14
*Note: Do files use the relogit and spost9 packages.
*Use "Replication Data - Owsiak Mitchell - CM in Land River Maritime Claims.dta"

set more off


*Table 1. Columns 1-4.
tab peacefulattempt revissue, column chi2
tab attbilat revissue, column chi2
tab maxmultilatneg revissue, column chi2
tab att3rd revissue, column chi2
tab att3non revissue, column chi2
tab maxgoodoffice revissue, column chi2
tab maxfactfinding revissue, column chi2
tab maxmed revissue, column chi2
tab att3bind revissue, column chi2
tab maxarbitration revissue, column chi2
tab maxadjudication revissue, column chi2

*NOTES: 
*1. revissue: 1=territorial/2=river/3=eez maritime/4=non-eez maritime.
*2. All maritime disputes = (eez maritime)+(non-eez maritime). Alternative, column 5 can be calculated by repeating the above using "issue", where issue: 1=territorial/2=river/3=maritime

*Table 1. Column 5 (issue==3)
tab peacefulattempt issue, column chi2
tab attbilat issue, column chi2
tab maxmultilatneg issue, column chi2
tab att3rd issue, column chi2
tab att3non issue, column chi2
tab maxgoodoffice issue, column chi2
tab maxfactfinding issue, column chi2
tab maxmed issue, column chi2
tab att3bind issue, column chi2
tab maxarbitration issue, column chi2
tab maxadjudication issue, column chi2

*Tables 2 & 4
*Model 1, Table 2; Row 1, Table 4
logit peacefulattempt marnoeez mareez riveriss icowsal recmidwt recnowt democ6 relcaps duration, robust
prvalue, x(marnoeez 0 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 0 riveriss 1) rest(mean) level(90)
prvalue, x(marnoeez 1 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 1 riveriss 0) rest(mean) level(90) 
*Model 2, Table 2; Row 2, Table 4
logit attbilat marnoeez mareez  riveriss icowsal recmidwt recnowt democ6 relcaps duration, robust 
prvalue, x(marnoeez 0 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 0 riveriss 1) rest(mean) level(90)
prvalue, x(marnoeez 1 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 1 riveriss 0) rest(mean) level(90)
*Model 3, Table 2; Row 4, Table 4 (*NOTE: Row 3, Table 4 appears below)
logit att3rd marnoeez mareez  riveriss icowsal recmidwt recnowt democ6 relcaps duration, robust 
prvalue, x(marnoeez 0 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 0 riveriss 1) rest(mean) level(90)
prvalue, x(marnoeez 1 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 1 riveriss 0) rest(mean) level(90)
*Model 4, Table 2; Row 5, Table 4
logit att3non marnoeez mareez  riveriss icowsal recmidwt recnowt democ6 relcaps duration, robust
prvalue, x(marnoeez 0 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 0 riveriss 1) rest(mean) level(90)
prvalue, x(marnoeez 1 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 1 riveriss 0) rest(mean) level(90)
*Model 5, Table 2; Row 9, Table 4 (*NOTE: Rows 6-8, Table 4 appear below)
logit att3bind marnoeez mareez  riveriss icowsal recmidwt recnowt democ6 relcaps duration, robust 
prvalue, x(marnoeez 0 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 0 riveriss 1) rest(mean) level(90)
prvalue, x(marnoeez 1 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 1 riveriss 0) rest(mean) level(90)
*Model 6, Table 2; Row 12, Table 4 (*NOTE: Rows 10-11, Table 4 appear below)
*logit maxregionaligo marnoeez mareez riveriss icowsal recmidwt recnowt democ6 relcaps duration, robust
relogit maxregionaligo  marnoeez mareez  riveriss icowsal recmidwt recnowt democ6 relcaps duration
setx riveriss 0 mareez 0 marnoeez 0 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90) 
setx riveriss 1 mareez 0 marnoeez 0 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90)
setx riveriss 0 mareez 0 marnoeez 1 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90)
setx riveriss 0 mareez 1 marnoeez 0 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90)
*Model 7, Table 2; Row 13, Table 4
*logit maxglobaligo marnoeez mareez riveriss icowsal recmidwt recnowt democ6 relcaps duration, robust
relogit maxglobaligo marnoeez mareez riveriss icowsal recmidwt recnowt democ6 relcaps duration
setx riveriss 0 mareez 0 marnoeez 0 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90) 
setx riveriss 1 mareez 0 marnoeez 0 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90)
setx riveriss 0 mareez 0 marnoeez 1 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90)
setx riveriss 0 mareez 1 marnoeez 0 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90)

*Tables 3 & 4
*Model 1, Table 3; Row 6, Table 4
logit maxgoodoffice marnoeez mareez riveriss   icowsal recmidwt recnowt democ6 relcaps duration , robust
prvalue, x(marnoeez 0 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 0 riveriss 1) rest(mean) level(90)
prvalue, x(marnoeez 1 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 1 riveriss 0) rest(mean) level(90)
*Model 2, Table 3; Row 7, Table 4
*logit maxfactfinding marnoeez  mareez riveriss   icowsal recmidwt recnowt democ6 relcaps duration , robust
relogit maxfactfinding riveriss icowsal recmidwt recnowt democ6 relcaps duration
setx riveriss 0 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90) 
setx riveriss 1 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90)
*Model 3, Table 3; Row 8, Table 4
logit maxmed marnoeez mareez riveriss icowsal recmidwt recnowt democ6 relcaps duration , robust
prvalue, x(marnoeez 0 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 0 riveriss 1) rest(mean) level(90)
prvalue, x(marnoeez 1 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 1 riveriss 0) rest(mean) level(90)
*Model 4, Table 3; Row 10, Table 4
*logit maxarbitration marnoeez mareez riveriss   icowsal recmidwt recnowt democ6 relcaps duration , robust
relogit maxarbitration mareez icowsal recmidwt recnowt democ6 relcaps duration
setx mareez 0 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90) 
setx mareez 1 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90)
*Model 5, Table 3; Row 11, Table 4
*logit maxadjudication marnoeez mareez riveriss  icowsal recmidwt recnowt democ6 relcaps duration , robust
relogit maxadjudication marnoeez mareez riveriss   icowsal recmidwt recnowt democ6 relcaps duration
setx riveriss 0 mareez 0 marnoeez 0 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90) 
setx riveriss 1 mareez 0 marnoeez 0 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90)
setx riveriss 0 mareez 0 marnoeez 1 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90)
setx riveriss 0 mareez 1 marnoeez 0 icowsal mean recmidwt mean recnowt mean democ6 mean relcaps mean duration mean
relogitq, level(90)
*Model 6, Table 3; Row 3, Table 4
logit maxmultilatneg marnoeez mareez riveriss   icowsal recmidwt recnowt democ6 relcaps duration, robust
prvalue, x(marnoeez 0 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 0 riveriss 1) rest(mean) level(90)
prvalue, x(marnoeez 1 mareez 0 riveriss 0) rest(mean) level(90)
prvalue, x(marnoeez 0 mareez 1 riveriss 0) rest(mean) level(90)

*Table 4
*The first substantive command (either setx or prvalue) under each model gives the base model (column 1, Table 1), which is for land claims. The second, third, and fourth commands give results for river, non-eez maritime, and maritime claims respectively. The percentages displayed in the text are calculated as: ((mean pr(y=1|claim type, x)-(mean pr(y=1|land claim, x)/(mean pr(y=1|land claim, x)*100). Values are bolded in each row if the calculated cell value (col. 2-4) falls outside the confidence interval for the land claim (reported in parentheses, col. 1).

 
