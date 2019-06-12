**the first part of this replication file comes directly from Weeks (2008).  The variable new_recip is the revised reciprocation variable.


*fake regression to order variables correctly for tables
label var recip "Dummy Model Table 4"
logit recip single1 military1 hybrid1 other1 dynastic1 nondynastic1 interregna interregnadem personal1 w1 polityIV majmaj minmaj majmin capshare1 contig ally s_wt_glo  s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000, robust cluster(cwkeynum) 
eststo model0

	*Schultz rep 1945-1999 consolidated democracies only
label var recip "Table 4 Model 1"
logit recip demdum1 majmaj minmaj majmin capshare1 contig ally s_wt_glo  s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000, robust cluster(cwkeynum) 
eststo model1

	*full sample with Geddes: democracy is base category
label var recip "Table 4 Model 2"
logit recip interregnadem personal1 single1 military1 hybrid1 dynastic1 nondynastic1 interregna other1 majmaj minmaj majmin capshare1 contig ally s_wt_glo s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000, robust cluster(cwkeynum)
eststo model2

	*bilateral sample with Geddes: democracy is base category
label var recip "Table 4 Model 3"
logit recip interregnadem personal1 single1 military1 hybrid1 dynastic1 nondynastic1 interregna other1 majmaj minmaj majmin capshare1 contig ally s_wt_glo s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000 & bilateral==1, robust cluster(cwkeynum)
eststo model3

	*autocracies ONLY, using personalists as base category (how different from personalists are other autocs)
label var recip "Table 4 Model 4"
logit recip polity2_1 single1 military1 hybrid1 dynastic1 nondynastic1 interregna other1 majmaj minmaj majmin capshare1 contig ally s_wt_glo  s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000 & demdum1==0, robust cluster(cwkeynum)
eststo model4

	*exclude personalists and drop major power status: does capshare predict recip?
*label var recip "Table 4 Model 4"
*logit recip single1 military1 hybrid1 dynastic1 nondynastic1 interregna other1 capshare1 contig ally s_wt_glo  s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000 & personal1==0, robust cluster(cwkeynum)
*outreg using Table4, se bdec(2) append

*****reanalyze with new variable
	*Schultz rep 1945-1999 consolidated democracies only
*label var recip "Table 4 Model 1"
logit new_recip demdum1 majmaj minmaj majmin capshare1 contig ally s_wt_glo  s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000, robust cluster(cwkeynum) 
eststo model1a

	*full sample with Geddes: democracy is base category
*label var recip "Table 4 Model 2"
logit new_recip interregnadem personal1 single1 military1 hybrid1 dynastic1 nondynastic1 interregna other1 majmaj minmaj majmin capshare1 contig ally s_wt_glo s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000, robust cluster(cwkeynum)
eststo model2a

	*bilateral sample with Geddes: democracy is base category
*label var recip "Table 4 Model 3"
logit new_recip interregnadem personal1 single1 military1 hybrid1 dynastic1 nondynastic1 interregna other1 majmaj minmaj majmin capshare1 contig ally s_wt_glo s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000 & bilateral==1, robust cluster(cwkeynum)
eststo model3a

	*autocracies ONLY, using personalists as base category (how different from personalists are other autocs)
*label var recip "Table 4 Model 4"
logit new_recip polity2_1 single1 military1 hybrid1 dynastic1 nondynastic1 interregna other1 majmaj minmaj majmin capshare1 contig ally s_wt_glo  s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000 & demdum1==0, robust cluster(cwkeynum)
eststo model4a

***checking if drops cause the changes

	*Schultz rep 1945-1999 consolidated democracies only
label var recip "Table 4 Model 1"
logit recip demdum1 majmaj minmaj majmin capshare1 contig ally s_wt_glo  s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000 &new_recip~=., robust cluster(cwkeynum) 
eststo model11

	*full sample with Geddes: democracy is base category
label var recip "Table 4 Model 2"
logit recip interregnadem personal1 single1 military1 hybrid1 dynastic1 nondynastic1 interregna other1 majmaj minmaj majmin capshare1 contig ally s_wt_glo s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000&new_recip~=., robust cluster(cwkeynum)
eststo model21

	*bilateral sample with Geddes: democracy is base category
label var recip "Table 4 Model 3"
logit recip interregnadem personal1 single1 military1 hybrid1 dynastic1 nondynastic1 interregna other1 majmaj minmaj majmin capshare1 contig ally s_wt_glo s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000 &new_recip~=.& bilateral==1, robust cluster(cwkeynum)
eststo model31

	*autocracies ONLY, using personalists as base category (how different from personalists are other autocs)
label var recip "Table 4 Model 4"
logit recip polity2_1 single1 military1 hybrid1 dynastic1 nondynastic1 interregna other1 majmaj minmaj majmin capshare1 contig ally s_wt_glo  s_ld_1 s_ld_2 revter revgov revpol revoth if year>1945 & year<2000 & demdum1==0&new_recip~=., robust cluster(cwkeynum)
eststo model41
