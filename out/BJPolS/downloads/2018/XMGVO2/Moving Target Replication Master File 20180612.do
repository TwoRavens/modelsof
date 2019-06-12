***************************************
****First, we need to set the Stage****
***************************************
cd "C:\Users\drew\Desktop"
sort country_num year
xtset country_num year
****************
****FIGURE 1****
****************
*Step 1 - Prepare xlsx
putexcel C1 = ("GEA") using "C:\Users\drew\Desktop\mAUROC GEA.xlsx", replace
putexcel D1 = ("w/o Arab Uprising Cases") using "C:\Users\drew\Desktop\mAUROC GEA.xlsx", modify
putexcel E1 = ("w/o MENA") using "C:\Users\drew\Desktop\mAUROC GEA.xlsx", modify
forval i = 2/51{
putexcel A`i' = (1956+(`i'-2)) ///
		 B`i' = (1965+(`i'-2)) ///
		 using "C:\Users\drew\Desktop\mAUROC GEA.xlsx", modify
}
*Step 2 - Estimate moving 10yr models, calculate AUROC, export to xlsx
forval i = 2/51{						
quietly logit full_onset full_dem part_dem_nofac part_dem_fac part_aut imr_std discrimination border_conflict i.region	///
	if year >= 1956+(`i'-2) & year <= 1965+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 | year >= 1956+(`i'-2) & year <= 1965+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph
quietly putexcel C`i' =(r(area)) using "C:\Users\drew\Desktop\mAUROC GEA.xlsx", modify
}
forval i = 2/51{						
quietly logit full_onset full_dem part_dem_nofac part_dem_fac part_aut imr_std discrimination border_conflict i.region	///
	if year >= 1956+(`i'-2) & year <= 1965+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 & arab_spring != 1 | year >= 1956+(`i'-2) & year <= 1965+(`i'-2) & full_onset == 0 & missing(ongoing_conflict) & arab_spring != 1 
quietly lroc if e(sample), nograph
quietly putexcel D`i' =(r(area)) using "C:\Users\drew\Desktop\mAUROC GEA.xlsx", modify
}
forval i = 2/51{
quietly logit full_onset full_dem part_dem_nofac part_dem_fac part_aut imr_std discrimination border_conflict i.region	///
	if year >= 1956+(`i'-2) & year <= 1965+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 & region != 5 | year >= 1956+(`i'-2) & year <= 1965+(`i'-2) & full_onset == 0 & missing(ongoing_conflict) & region != 5
quietly lroc if e(sample), nograph
quietly putexcel E`i' =(r(area)) using "C:\Users\drew\Desktop\mAUROC GEA.xlsx", modify
}
***************
****TABLE 1****
***************
*Step 1 - train models (1-year at a time) and make predictions for test years (2005-2014) 
gen AllPredict = .
gen AllDeciles = .
sort country_num year
xtset country_num year
forval i = 2005/2014 {
quietly logit full_onset																								///
full_dem part_dem_nofac part_dem_fac part_aut imr_std discrimination border_conflict i.region							///
if year < `i' & full_onset == 1 & ongoing_conflict == 1 | year < `i' & full_onset == 0 & missing(ongoing_conflict)
predict Predict`i' if year == `i' & full_onset == 1 & ongoing_conflict == 1 | year == `i' & full_onset == 0 & missing(ongoing_conflict)
replace AllPredict = Predict`i' if !missing(Predict`i')
xtile Deciles`i' = Predict`i', nq(10)
replace AllDeciles = Deciles`i' if !missing(Deciles`i')
drop Predict`i' Deciles`i'
}
*Step 2 - export probabilities and rankings
export excel country year AllPredict AllDeciles using "Table 1.xlsx"	///
if full_onset == 1 & AllDeciles >= 9 & !missing(AllDeciles), firstrow(variables) sheet("correctly classified onsets", replace)
export excel country year AllPredict AllDeciles using "Table 1.xlsx"	///
if full_onset == 1 & AllDeciles < 9 & !missing(AllDeciles), firstrow(variables) sheet("incorrectly classified onsets", replace)
****************
****Figure 2****
****************
*Step 1 - prepare xlsx
putexcel C1 = ("culled (CU)")						///								///	 
		 using "GEA onsets.xlsx", replace
forval i = 2/51{
putexcel A`i' = (1955+(`i'-2))	///
		 B`i' = (1964+(`i'-2))	///
		 using "GEA onsets.xlsx", modify
}
forval i = 2/51 {
disp `i' "->" 1955+(`i'-2) "-" 1964+(`i'-2)
}
/*CU - Culled*/
forval i = 19/51 {
disp 1955+(`i'-2) "-" 1964+(`i'-2)
eststo model: quietly logit full_onset									///
					xxxcimrln bnnyroffln1p elcelethc 					///
					wdimobp100ln1p 										///
					wdipopurbmi ythbul4 bnkunrestln1p nvcdosregtln1p 	///
					postcoldwar iosiccpr1 nldany1 i.fiwcl				///
		if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 | 	///
		   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph 
quietly putexcel C`i' =(r(area))	///
using "GEA onsets.xlsx", modify
eststo clear
}
/*Hegre - m48*/
do "C:\Users\drew\Documents\Minerva\Forecasting Failures\Future is a Moving Target Replication\Predicting Armed Conflict Replication Files\Constraints.do"
putexcel D1 = ("m48 (Hegre)")						/// 
		 using "GEA onsets.xlsx", modify
forval i = 18/47 {
disp `i'																			
eststo model: quietly logit full_onset				///
								  loi 				///
								  let 				/// 
								  lli 				/// 
								  lyo  				///
								  llpo 				/// 
								  led 				/// 
								  r4 r6 r7			///
		if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 |	///
		   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph 
quietly putexcel D`i' =(r(area))	///
using "GEA onsets.xlsx", modify
}
putexcel E1 = ("GEA")						/// 
		 using "GEA onsets.xlsx", modify
forval i = 2/51{						
quietly logit full_onset full_dem part_dem_nofac part_dem_fac part_aut imr_std discrimination border_conflict i.region	///
	if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 |	///
	   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph
quietly putexcel E`i' =(r(area)) using "GEA onsets.xlsx", modify
}
***************
****Table 2****
***************
sort country_num year
xtset country_num year			
eststo	GEA95_04: logit full_onset																		///
full_dem part_dem_nofac part_dem_fac part_aut tran imr_std discrimination border_conflict i.region		///
	if year >= 1995 & year <= 2004 & full_onset == 1 & ongoing_conflict == 1 | year >= 1995 & year <= 2004 & full_onset == 0 & missing(ongoing_conflict)
eststo	GEA05_14: logit full_onset																		///
full_dem part_dem_nofac part_dem_fac part_aut tran imr_std discrimination border_conflict i.region		///
	if year >= 2005 & year <= 2014 & full_onset == 1 & ongoing_conflict == 1 | year >= 2005 & year <= 2014 & full_onset == 0 & missing(ongoing_conflict)
eststo	GEA56_14: logit full_onset																		///
full_dem part_dem_nofac part_dem_fac part_aut tran imr_std discrimination border_conflict i.region		///
	if year >= 1956 & year <= 2014 & full_onset == 1 & ongoing_conflict == 1 | year >= 1956 & year <= 2014 & full_onset == 0 & missing(ongoing_conflict)
esttab GEA95_04 GEA05_14 GEA56_14																					///
using "Table 2.rtf"		///
, replace parentheses nogaps nodepvars nonumbers scalars("ll Log lik." "chi2 Chi-squared")

******************
****Appendix A****
******************
eststo CU: logit nvcstart1												///
					xxxcimrln bnnyroffln1p elcelethc 					///
					wdimobp100ln1p 										///
					wdipopurbmi ythbul4 bnkunrestln1p nvcdosregtln1p 	///
					postcoldwar iosiccpr1 nldany1 i.fiwcl				///
	if year <= 2013

eststo HEA: logit conflict_onsets_binary	///
								  loi 				///
								  let 				/// 
								  lli 				/// 
								  lyo  				///
								  llpo 				/// 
								  led 				/// 
								  r4 r6 r7			///
	if year <= 2009
esttab HEA CU	///
using "Hegre Model Summary.rtf"		///
, replace parentheses nogaps label nodepvars nonumbers b(a3) pr2 p(3) aic(2) bic(2)
******************
****Appendix B****
******************
/*Using GEA Onsets*/
*Step 1 - prepare xlsx
putexcel C1 = ("culled (CU)")						///								///	 
		 using "Appendix A - GEA onsets.xlsx", replace
forval i = 2/51{
putexcel A`i' = (1955+(`i'-2))	///
		 B`i' = (1964+(`i'-2))	///
		 using "Appendix A - GEA onsets.xlsx", modify
}
forval i = 2/51 {
disp `i' "->" 1955+(`i'-2) "-" 1964+(`i'-2)
}
/*CU - Culled*/
forval i = 19/51 {
disp 1955+(`i'-2) "-" 1964+(`i'-2)
eststo model: quietly logit full_onset									///
					xxxcimrln bnnyroffln1p elcelethc 					///
					wdimobp100ln1p 										///
					wdipopurbmi ythbul4 bnkunrestln1p nvcdosregtln1p 	///
					postcoldwar iosiccpr1 nldany1 i.fiwcl				///
		if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 | 	///
		   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph 
quietly putexcel C`i' =(r(area))	///
using "Appendix A - GEA onsets.xlsx", modify
eststo clear
}
/*Hegre - m48*/
do "C:\Users\drew\Documents\Minerva\Forecasting Failures\Future is a Moving Target Replication\Predicting Armed Conflict Replication Files\Constraints.do"
putexcel D1 = ("m48 (Hegre)")						/// 
		 using "Appendix A - GEA onsets.xlsx", modify
forval i = 18/47 {
disp `i'																			
eststo model: quietly logit full_onset				///
								  loi 				///
								  let 				/// 
								  lli 				/// 
								  lyo  				///
								  llpo 				/// 
								  led 				/// 
								  r4 r6 r7			///
		if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 |	///
		   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph 
quietly putexcel D`i' =(r(area))	///
using "Appendix A - GEA onsets.xlsx", modify
}
putexcel E1 = ("GEA")						/// 
		 using "Appendix A - GEA onsets.xlsx", modify
forval i = 2/51{						
quietly logit full_onset full_dem part_dem_nofac part_dem_fac part_aut imr_std discrimination border_conflict i.region	///
	if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 |	///
	   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph
quietly putexcel E`i' =(r(area)) using "Appendix A - GEA onsets.xlsx", modify
}
/*Using MEC Onsets*/
*Step 1 - prepare xlsx
putexcel C1 = ("culled (CU)")						///								///	 
		 using "Appendix A - MEC onsets.xlsx", replace
forval i = 2/51{
putexcel A`i' = (1955+(`i'-2))	///
		 B`i' = (1964+(`i'-2))	///
		 using "Appendix A - MEC onsets.xlsx", modify
}
forval i = 2/51 {
disp `i' "->" 1955+(`i'-2) "-" 1964+(`i'-2)
}
/*CU - Culled*/
forval i = 19/51 {
disp 1955+(`i'-2) "-" 1964+(`i'-2)
eststo model: quietly logit nvcstart1									///
					xxxcimrln bnnyroffln1p elcelethc 					///
					wdimobp100ln1p 										///
					wdipopurbmi ythbul4 bnkunrestln1p nvcdosregtln1p 	///
					postcoldwar iosiccpr1 nldany1 i.fiwcl				///
		if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 | 	///
		   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph 
quietly putexcel C`i' =(r(area))	///
using "Appendix A - MEC onsets.xlsx", modify
eststo clear
}
/*Hegre - m48*/
do "C:\Users\drew\Documents\Minerva\Forecasting Failures\Future is a Moving Target Replication\Predicting Armed Conflict Replication Files\Constraints.do"
putexcel D1 = ("m48 (Hegre)")						/// 
		 using "Appendix A - MEC onsets.xlsx", modify
forval i = 18/47 {
disp `i'																			
eststo model: quietly logit nvcstart1				///
								  loi 				///
								  let 				/// 
								  lli 				/// 
								  lyo  				///
								  llpo 				/// 
								  led 				/// 
								  r4 r6 r7			///
		if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 |	///
		   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph 
quietly putexcel D`i' =(r(area))	///
using "Appendix A - MEC onsets.xlsx", modify
}
/*GEA model*/
putexcel E1 = ("GEA")						/// 
		 using "Appendix A - MEC onsets.xlsx", modify
forval i = 10/51{						
quietly logit nvcstart1 full_dem part_dem_nofac part_dem_fac part_aut imr_std discrimination border_conflict i.region	///
	if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 |	///
	   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph
quietly putexcel E`i' =(r(area)) using "Appendix A - MEC onsets.xlsx", modify
}
/*Using HEA Onsets*/
*Step 1 - prepare xlsx
putexcel C1 = ("culled (CU)")						///								///	 
		 using "Appendix A - HEA onsets.xlsx", replace
forval i = 2/51{
putexcel A`i' = (1955+(`i'-2))	///
		 B`i' = (1964+(`i'-2))	///
		 using "Appendix A - HEA onsets.xlsx", modify
}
forval i = 2/51 {
disp `i' "->" 1955+(`i'-2) "-" 1964+(`i'-2)
}
/*CU - Culled*/
forval i = 19/51 {
disp 1955+(`i'-2) "-" 1964+(`i'-2)
eststo model: quietly logit conflict_onsets_binary									///
					xxxcimrln bnnyroffln1p elcelethc 					///
					wdimobp100ln1p 										///
					wdipopurbmi ythbul4 bnkunrestln1p nvcdosregtln1p 	///
					postcoldwar iosiccpr1 nldany1 i.fiwcl				///
		if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 | 	///
		   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph 
quietly putexcel C`i' =(r(area))	///
using "Appendix A - HEA onsets.xlsx", modify
eststo clear
}
/*Hegre - m48*/
do "C:\Users\drew\Documents\Minerva\Forecasting Failures\Future is a Moving Target Replication\Predicting Armed Conflict Replication Files\Constraints.do"
putexcel D1 = ("m48 (Hegre)")						/// 
		 using "Appendix A - HEA onsets.xlsx", modify
forval i = 18/47 {
disp `i'																			
eststo model: quietly logit conflict_onsets_binary				///
								  loi 				///
								  let 				/// 
								  lli 				/// 
								  lyo  				///
								  llpo 				/// 
								  led 				/// 
								  r4 r6 r7			///
		if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 |	///
		   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph 
quietly putexcel D`i' =(r(area))	///
using "Appendix A - HEA onsets.xlsx", modify
}
putexcel E1 = ("GEA")						/// 
		 using "Appendix A - HEA onsets.xlsx", modify
forval i = 10/51{						
quietly logit conflict_onsets_binary full_dem part_dem_nofac part_dem_fac part_aut imr_std discrimination border_conflict i.region	///
	if year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 1 & ongoing_conflict == 1 |	///
	   year >= 1955+(`i'-2) & year <= 1964+(`i'-2) & full_onset == 0 & missing(ongoing_conflict)
quietly lroc if e(sample), nograph
quietly putexcel E`i' =(r(area)) using "Appendix A - HEA onsets.xlsx", modify
}
******************
****Appendix C****
******************
*Step 1 - prepare xlsx
putexcel D1 = ("mAUROC")					///
		 E1 = ("out-of-sample accuracy")	///
		 F1 = ("events captured in top decile") 		///		 
		 using "Appendix C.xlsx", replace

forval i = 2/49{
putexcel A`i' = (1958+(`i'-2))	///
		 B`i' = (1967+(`i'-2))	///
		 using "Appendix C.xlsx", modify
}
*Step 2 - calculate mAUROC and export to xlsx
sort country_num year
xtset country_num year
forval i = 2/49 {
quietly logit full_onset																				///
full_dem part_dem_nofac part_dem_fac part_aut imr_std discrimination border_conflict i.region			///
	if year >= (1958+(`i'-2)) & year <= (1967+(`i'-2)) & full_onset == 1 & ongoing_conflict == 1 | year >= (1958+(`i'-2)) & year <= (1967+(`i'-2)) & full_onset == 0 & missing(ongoing_conflict)			
quietly lroc if e(sample), nograph
quietly putexcel C`i' =(r(area)) using "Appendix C.xlsx", modify
}
*Step 3 - Make predictions, calculate accuracies (yearly), export to xlsx
replace AllPredict = .		/*make sure to clear 'AllPredict' & 'AllDeciles' from Table 1*/
replace AllDeciles = .
sort country_num year
xtset country_num year
forval i = 1965/2014 {
quietly logit full_onset																									///
full_dem part_dem_nofac part_dem_fac part_aut imr_std discrimination border_conflict i.region								///
	if year < `i' & full_onset == 1 & ongoing_conflict == 1 | year < `i' & full_onset == 0 & missing(ongoing_conflict)
predict Predict`i' if year == `i' & full_onset == 1 & ongoing_conflict == 1 | year == `i' & full_onset == 0 & missing(ongoing_conflict)
replace AllPredict = Predict`i' if !missing(Predict`i') & year == `i'
xtile Deciles`i' = Predict`i', nq(10)
replace AllDeciles = Deciles`i' if year == `i'
drop Predict`i' Deciles`i'
}
forval i = 9/49 {
count if year >= (`i'+1956) & year <= (`i'+1965) & full_onset == 1
quietly putexcel E`i' =(r(N)) using "Appendix C.xlsx", modify
count if year >= (`i'+1956) & year <= (`i'+1965) & AllDeciles >= 9 & !missing(AllDeciles) & full_onset == 1
quietly putexcel F`i' =(r(N)) using "Appendix C.xlsx", modify
}
//
***************
****The End****
***************
