*Reference: Owsiak, Andrew P. 2012. Signing Up for Peace: International Boundary Agreements, Democracy, and Militarized Interstate Conflict. International Studies Quarterly.
*
*Data is made available for replication purposes only.
*The commands below replicate all statistical results that appear in the manuscript.
*Replication commands are listed by data set and then by the table in which the results appear (in order).
*Within each data file, information about the coding/source for each variable can be obtained by typing "notes <variable name>" (e.g., notes settlem).
*Note: You may need to download Clarify to complete the do file. Please visit: http://gking.harvard.edu/clarify/docs/clarify.html for more information (Accessed 11 Sept. 2010).
*
*
*
*Using file "Owsiak - Signing Up for Peace - Escalation - 09.2010"
*
*Table 1: Crosstabulations, columns 1-3.
*
tab settlem cow5yrwi, chi2 gamma
*
*Table 2: Models 1-8 (in order)
logit cow5yrwi settlem
logit cow5yrwi settlem territor regime other
logit cow5yrwi settlem jtdemfinal
logit cow5yrwi settlem territor regime other jtdemfinal
logit cow5yrwi settlem territor regime other jtdemfinal majinvolve atopally lncincratio
logit cow5yrwi settlem territor regime other jtdemfinal majinvolve atopally lncincratio if year<1946 & wrldwaryr==0
logit cow5yrwi settlem territor regime other jtdemfinal majinvolve atopally lncincratio if year>1945
logit cow5yrwi settlem territor regime other jtdemfinal majinvolve atopally lncincratio if year>1899 & wrldwaryr==0
* 
*Table 4: Rows 1-3.
estsimp logit cow5yrwi settlem territor regime other majinvolve atopally lncincratio
setx settlem 0 territor 0 regime 0 other 0 majinvolve 0 atopally 0 lncincratio mean
simqi
setx settlem 1 territor 0 regime 0 other 0 majinvolve 0 atopally 0 lncincratio mean
simqi
setx settlem 0 territor 1 regime 0 other 0 majinvolve 0 atopally 0 lncincratio mean
simqi
setx settlem 1 territor 1 regime 0 other 0 majinvolve 0 atopally 0 lncincratio mean
simqi
*
*
*Using file "Owsiak - Signing Up for Peace - Onset - 09.2010"
*
*Table 1: Crosstabulations, columns 4-9.
tab midonset settlem, chi2 gamma
tab settlem jtdem6, chi2 gamma
*
*Table 3: Models 1-6 (in order)
logit midonset settlem peaceyears _spline1 _spline2 _spline3
logit midonset settlem jtdem6 peaceyears _spline1 _spline2 _spline3
logit midonset settlem jtdem6  majinvolve atopally lncincratio peaceyears _spline1 _spline2 _spline3
logit midonset settlem jtdem6  majinvolve atopally lncincratio peaceyears _spline1 _spline2 _spline3 if year<1946 & worldwaryr==0
logit midonset settlem jtdem6  majinvolve atopally lncincratio peaceyears _spline1 _spline2 _spline3 if year>1945
logit midonset settlem jtdem6  majinvolve atopally lncincratio peaceyears _spline1 _spline2 _spline3 if year>1899 & worldwaryr==0
*
*Table 4: Row 4.
estsimp logit midonset settlem jtdem6 majinvolve atopally lncincratio peaceyears  _spline1 _spline2 _spline3
setx settlem 0 jtdem6 0 majinvolve 0 atopally 0 lncincratio mean peaceyears mean _spline1 mean _spline2 mean _spline3 mean
simqi
setx settlem 1 jtdem6 0 majinvolve 0 atopally 0 lncincratio mean peaceyears mean _spline1 mean _spline2 mean _spline3 mean
simqi
setx settlem 0 jtdem6 1 majinvolve 0 atopally 0 lncincratio mean peaceyears mean _spline1 mean _spline2 mean _spline3 mean
simqi
setx settlem 1 jtdem6 1 majinvolve 0 atopally 0 lncincratio mean peaceyears mean _spline1 mean _spline2 mean _spline3 mean
simqi

