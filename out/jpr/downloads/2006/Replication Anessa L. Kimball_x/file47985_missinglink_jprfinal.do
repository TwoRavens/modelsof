*Replication 'do-file' for "Alliance Formation and Conflict Initiation: The Missing Link" by Anessa L. Kimball

clear 
set mem 200m
use "C:\Documents and Settings\akimbal1\Desktop\MissingLink\MissingLink_JPRfinal.dta"

*Models
**Table I
**Single Probit Model
probit conflict RELCAP contig jtdem jaut pwrs allform2 peaceyrs _spline1 _spline2 _spline3, robust
sum conflict RELCAP contig jtdem jaut pwrs allform2 peaceyrs _spline1 _spline2 _spline3 if e(sample)
**Bivariate Probit Model 1
biprobit (allform2 = RELCAP logdist contig jtdem jaut sharerival allyrs _spline1af _spline2af _spline3af) (conflict = RELCAP contig jtdem jaut pwrs peaceyrs _spline1 _spline2 _spline3), robust
**Bivariate Probit Model 2
biprobit (allform2 = RELCAP logdist contig jtdem jaut sharerival allyrs _spline1af _spline2af _spline3af) (conflict = RELCAP contig jtdem jaut pwrs allform2 peaceyrs _spline1 _spline2 _spline3), robust
sum allform2 RELCAP logdist contig jtdem jaut sharerival conflict pwrs _spline1 _spline2 _spline3 peaceyrs allyrs _spline1af _spline2af _spline3af if e(sample)

**Table II (Comparisons of 1816-1944 and 1945-2000)
**1816-1944
biprobit (allform2 = RELCAP logdist contig jtdem jaut sharerival allyrs _spline1af _spline2af _spline3af) (conflict = RELCAP contig jtdem jaut pwrs allform2 peaceyrs _spline1 _spline2 _spline3) if year <1945, robust
sum allform2 RELCAP logdist contig jtdem jaut sharerival conflict pwrs allyrs _spline1af _spline2af _spline3af peaceyrs _spline1 _spline2 _spline3 if e(sample)
**1945-2000
biprobit (allform2 = RELCAP logdist contig jtdem jaut sharerival allyrs _spline1af _spline2af _spline3af) (conflict = RELCAP contig jtdem jaut pwrs allform2 peaceyrs _spline1 _spline2 _spline3) if year>1944, robust
sum allform2 RELCAP logdist contig jtdem jaut sharerival conflict pwrs allyrs _spline1af _spline2af _spline3af peaceyrs _spline1 _spline2 _spline3 if e(sample)
