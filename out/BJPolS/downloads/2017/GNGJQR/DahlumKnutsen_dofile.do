
********::::::::::::::::::::REPLICATION FILE FOR DAHLUM AND KNUTSEN (2015)::::::::::::::::::::::******

*:::::::::::::TABLES FROM MAIN TEXT:::::::::::::*

*TABLE 1
*A)Non-imputed dataset (Original dataset_analysis.dta)
eststo clear 
mi extract 0
eststo: regress F7.EDI_full values vanhanen1990 dem_tradition1995 if sampleIogW60==1
eststo: regress F7.FHouse_full values vanhanen1990 FHouse if sampleIogW60==1
eststo: regress F7.EDI_full values vanhanen1990 dem_tradition1995 religion1990 schooling1992 alesina1985 if sampleIogW60==1
eststo: regress F7.FHouse_full values vanhanen1990 dem_tradition1995 religion1990 schooling1992 alesina1985 if sampleIogW60==1
*B) Imputed dataset (imputed_all6.dta)
mi xtset ccode year
eststo: mi estimate, post: regress F7.EDI selfexpressionA_1995 vanhanen1990 dem_tradition1995 religion1990 schooling1992 alesina1985
eststo: mi estimate, post: regress F7.FHouse selfexpressionA_1995 vanhanen1990 dem_tradition1995 religion1990 schooling1992 alesina1985
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina, cluster(ccode)
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina if sample_2values==1, cluster(ccode)
esttab using "M:\Statating\stata/TABELL 1.rtf", se nogap label title(TABLE 1.) replace ///
	nonumbers mtitles("1: EDI" "2: FHI" "3: EDI" "4: FHI" "5: EDI" "6:FHI" "7:EDI" "8:FHI" "9:EDI" "10:FHI") addnote("All explanatory variables are lagged by 7 years") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	

*TABLE 2
eststo clear
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode) dftable vartable

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	
	
*TABLE 3 

eststo clear
eststo: mi estimate, cmdok post: xtdpdsys selfexpressionA1 religion gini alesina exports dem_tradition_final, lags(1) endog(FHouse vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys selfexpressionA1 religion gini alesina exports Stock1, lags(1) endog(FHouse vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys selfexpressionA1 religion gini alesina exports dem_tradition_final, lags(1) endog(EDI vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys selfexpressionA1 religion gini alesina exports Gerring, lags(1) endog(EDI vanhanen schooling public_spending) artests(2)
esttab using "M:\Statating\stata/Verdier som AV.doc", se nogap label ///



*******::::::::::::DIAGNOSTIC TESTS REFERRED TO IN THE MAIN TEXT THAT ARE NOT IN THE APPENDIX::::::::********

*VIF test to check for collinearity, p. 18 (based on Table 2)
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
mivif

*Tobit model accounting for EDI being restricted, footnote 69 on p. 22
eststo: tobit F7.EDI_full selfexpressionA1 vanhanen1990 dem_tradition1995 if sampleIogW60==1


*PCSE-Models from Table 2 when adding former colonies, footnote 80 on p. 25
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports british_colony if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports french_colony if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports british_colony if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports french_colony if sample_2values==1, cluster(ccode)





*******:::::::::::::::::::TABLES FROM ONLINE APPENDIX::::::::::::::**************
*(for replication files for multiple imputation and imputation diagnostics, see R-script)

*Table A.3.
corr selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if _mi_m==0


*Table A.4.
corr selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports


*TABLE A.5.
eststo clear
eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
esttab using "M:\Statating\stata/TABELL 2 dropping variables.rtf", se nogap label title(TABLE 2. Dropping each control variable.) replace ///
	nonumbers mtitles("1: EDI" "2: EDI" "3: EDI" "4: EDI" "5: EDI" "6:EDI" "7:EDI" "8:EDI") addnote("All explanatory variables are lagged by 7 years.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


*TABLE A.6.
eststo clear
eststo: mi estimate, post dftable vartable: regress F7.EDI selfexpressionA_1995 vanhanen1990 dem_tradition1995 religion1990 schooling1992 alesina1985
eststo: mi estimate, post dftable vartable: regress F7.FHouse selfexpressionA_1995 vanhanen1990 dem_tradition1995 religion1990 schooling1992 alesina1985
eststo: mi estimate, post dftable vartable: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina, cluster(ccode)
eststo: mi estimate, post dftable vartable: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina, cluster(ccode)
eststo: mi estimate, post dftable vartable: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina if sample_2values==1, cluster(ccode)
eststo: mi estimate, post dftable vartable: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina if sample_2values==1, cluster(ccode)
esttab using "M:\Statating\stata/TABELL 1.rtf", se nogap label title(TABLE 1.) replace ///
	nonumbers mtitles("1: EDI" "2: FHI" "3: EDI" "4: FHI" "5: EDI" "6:FHI" "7:EDI" "8:FHI" "9:EDI" "10:FHI") addnote("All explanatory variables are lagged by 7 years") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


*TABLE A.7.
eststo clear
eststo: mi estimate, post dftable vartable: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post dftable vartable: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post dftable vartable: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post dftable vartable: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post dftable vartable: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post dftable vartable: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode) dftable vartable

eststo: mi estimate, cmdok post dftable vartable: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post dftable vartable: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post dftable vartable: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post dftable vartable: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	

*TABLE A.8.
mi stset, clear
mi xtset ccode year

mi extract 1	
eststo clear
eststo: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2_data 1.rtf", se nogap label title(TABLE 2 on 1st imputed data set.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:EDI" "7:FH" "8:FH") addnote("All explanatory variables are lagged by 7 years") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	


*TABLE A.9.
mi extract 2	
eststo clear
eststo: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2_data 2.rtf", se nogap label title(TABLE 2 on 2nd imputed data set.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:EDI" "7:FH" "8:FH") addnote("All explanatory variables are lagged by 7 years") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	

	
	
*TABLE A.10
use "\\kant\sv-stv-u1\siriad\pc\Desktop\Ph.D\Democracy by demand\SDimpute\imputed28mai_all6.dta", clear	
mi extract 3	
eststo clear
eststo: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2_data 3.rtf", se nogap label title(TABLE 2 on 3rd imputed data set.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:EDI" "7:FH" "8:FH") addnote("All explanatory variables are lagged by 7 years") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	
	

*TABLE A.11	
use "\\kant\sv-stv-u1\siriad\pc\Desktop\Ph.D\Democracy by demand\SDimpute\imputed28mai_all6.dta", clear	
mi extract 4	
eststo clear
eststo: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2_data 4.rtf", se nogap label title(TABLE 2 on 4th imputed data set.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:EDI" "7:FH" "8:FH") addnote("All explanatory variables are lagged by 7 years") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	

	
*TABLE A.12	
use "\\kant\sv-stv-u1\siriad\pc\Desktop\Ph.D\Democracy by demand\SDimpute\imputed28mai_all6.dta", clear	
mi extract 5	
eststo clear
eststo: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2_data 5.rtf", se nogap label title(TABLE 2 on 5thrd imputed data set.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:EDI" "7:FH" "8:FH") addnote("All explanatory variables are lagged by 7 years") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	
	
	

*TABLE A.13.
eststo clear
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1 & year>1984, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1 & year>1984, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1984, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1984, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1984, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1984, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1984, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1984, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1984, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1984, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2 _etter 1984.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH" "9:EDI" "10:FH") addnote("All explanatory variables are lagged by 7 years, except from in model 5 og 7 where a 1-year lag i used") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	
	

*TABLE A.14.
eststo clear
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1 & year>1989, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1 & year>1989, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1989, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1989, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1989, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1989, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1989, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1989, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1989, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
estat vif
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1989, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2 _etter 1990.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH" "9:EDI" "10:FH") addnote("All explanatory variables are lagged by 7 years, except from in model 5 og 7 where a 1-year lag i used") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
	


*TABLE A.15.
eststo clear
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1 & year>1994, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1 & year>1994, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1994, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1994, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1994, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1 & year>1994, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1994, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1994, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1994, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1 & year>1994, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2 _etter 1994.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH" "9:EDI" "10:FH") addnote("All explanatory variables are lagged by 7 years, except from in model 5 og 7 where a 1-year lag i used") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	
	

*TABLE B.1. 
eststo clear
eststo: mi estimate, cmdok post: probit F.FHouse_dikoL FHouse_dikoL selfexpressionA1 wdi_gdpc values_BNP schooling exports gini religion public_spending alesina FHouseL_values FHouseL_wdi_gdpc FHouseL_schooling FHouseL_export FHouseL_gini FHouseL_religion FHouseL_spending FHouseL_alesina if sample_2values, cluster(ccode)

eststo: mi estimate, cmdok post: probit F7.FHouse_dikoL FHouse_dikoL selfexpressionA1 wdi_gdpc values_BNP schooling exports gini religion public_spending alesina FHouseL_values FHouseL_wdi_gdpc FHouseL_schooling FHouseL_export FHouseL_gini FHouseL_religion FHouseL_spending FHouseL_alesina if sample_2values, cluster(ccode)

eststo: mi estimate, cmdok post: probit F.FHouse_dikoH FHouse_dikoH selfexpressionA1 wdi_gdpc values_BNP schooling exports gini religion public_spending alesina FHouseH_values FHouseH_wdi_gdpc FHouseH_schooling FHouseH_export FHouseH_gini FHouseH_religion FHouseH_spending FHouseH_alesina if sample_2values, cluster(ccode)
eststo: mi estimate, cmdok post: probit F7.FHouse_dikoH FHouse_dikoH selfexpressionA1 wdi_gdpc values_BNP schooling exports gini religion public_spending alesina FHouseH_values FHouseH_wdi_gdpc FHouseH_schooling FHouseH_export FHouseH_gini FHouseH_religion FHouseH_spending FHouseH_alesina if sample_2values, cluster(ccode)

eststo: mi estimate, cmdok post: probit F.ACLP ACLP selfexpressionA1 wdi_gdpc values_BNP schooling exports gini religion public_spending alesina ACLP_values ACLP_wdi_gdpc ACLP_schooling ACLP_export ACLP_gini ACLP_religion ACLP_spending ACLP_alesina if sample_2values, cluster(ccode)
eststo: mi estimate, cmdok post: probit F7.ACLP ACLP selfexpressionA1 wdi_gdpc values_wdi_BNP schooling exports gini religion public_spending alesina ACLP_values ACLP_wdi_gdpc ACLP_schooling ACLP_export ACLP_gini ACLP_religion ACLP_spending ACLP_alesina if sample_2values, cluster(ccode)

esttab using "M:\Statating\stata/TABELL 3.rtf", se nogap label title(TABLE 3. Dynamic probit regression med wdi_gdpc interaction) replace ///
	nonumbers mtitles("1: FHI (low). " "2: FHI (low).7-year lag" "3: FHI (high). 1-year lag" "4:FHI(high). 7-year lag" "5: ACLP. 1-year lag" "6:ACLP. 7-year lag") addnotes("All independent and control variables are lagged by one year. Freedom House (FH) is dichotomized using three different thresholds: Low: 1 equals FH > 2.5, medium: 1 equals FH > 4, high: 1 equals FH > 5.5" "All independent variables are lagged by one year") ///
	pr2 scalars(ll ll_0) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
	

*TABLE B.2.
eststo clear
eststo: mi estimate, post: regress F7.EDI trust2 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse trust2 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI trust2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse trust2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI trust2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse trust2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(trust2 vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(trust2 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(trust2 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(trust2 vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2_trust.rtf", se nogap label title(TABLE 2. Trust) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


*TABLE B.3.	
eststo clear
eststo: mi estimate, post: regress F7.EDI petitions2 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse petitions2 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI petitions2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse petitions2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI petitions2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse petitions2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(petitions2 vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(petitions2 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(petitions2 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(petitions2 vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2_petition.rtf", se nogap label title(TABLE 2. Trust) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


*TABLE B.4.
eststo clear
eststo: mi estimate, post: regress F7.EDI happiness2 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse happiness2 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI happiness2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse happiness2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI happiness2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse happiness2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(happiness2 vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(trust vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(happiness2 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(happiness2 vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2_happiness.rtf", se nogap label title(TABLE 2. Trust) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


*TABLE B.5.	
eststo clear
eststo: mi estimate, post: regress F7.EDI tolerance2 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse tolerance2 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI tolerance2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse tolerance2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI tolerance2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse tolerance2 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(tolerance2 vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(trust vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(tolerance2 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(tolerance2 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2_tolerance.rtf", se nogap label title(TABLE 2. Trust) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


*TABLE B.6.
eststo clear
eststo: mi estimate, post: regress F7.EDI abortion vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse abortion vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI abortion vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse abortion vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI abortion vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse abortion vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(abortion vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(trust vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(abortion vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(abortion vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2_abortion.rtf", se nogap label title(TABLE 2. Trust) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)


*TABLE B.7.
eststo clear
eststo: mi estimate, cmdok post: probit F.FHouse_dikoL FHouse_dikoL trust2 vanhanen schooling exports gini religion public_spending alesina FHouseL_values FHouseL_vanhanen FHouseL_schooling FHouseL_export FHouseL_gini FHouseL_religion FHouseL_spending FHouseL_alesina if sample_2values, cluster(ccode)
eststo: mi estimate, cmdok post: probit F7.FHouse_dikoL FHouse_dikoL trust2 vanhanen schooling exports gini religion public_spending alesina FHouseL_values FHouseL_vanhanen FHouseL_schooling FHouseL_export FHouseL_gini FHouseL_religion FHouseL_spending FHouseL_alesina if sample_2values, cluster(ccode)

eststo: mi estimate, cmdok post: probit F.FHouse_dikoH FHouse_dikoH trust2 vanhanen schooling exports gini religion public_spending alesina FHouseH_values FHouseH_vanhanen FHouseH_schooling FHouseH_export FHouseH_gini FHouseH_religion FHouseH_spending FHouseH_alesina if sample_2values, cluster(ccode)
eststo: mi estimate, cmdok post: probit F7.FHouse_dikoH FHouse_dikoH trust2 vanhanen schooling exports gini religion public_spending alesina FHouseH_values FHouseH_vanhanen FHouseH_schooling FHouseH_export FHouseH_gini FHouseH_religion FHouseH_spending FHouseH_alesina if sample_2values, cluster(ccode)

eststo: mi estimate, cmdok post: probit F.ACLP ACLP trust2 vanhanen schooling exports gini religion public_spending alesina ACLP_values ACLP_vanhanen ACLP_schooling ACLP_export ACLP_gini ACLP_religion ACLP_spending ACLP_alesina if sample_2values, cluster(ccode)
eststo: mi estimate, cmdok post: probit F7.ACLP ACLP trust2 vanhanen schooling exports gini religion public_spending alesina ACLP_values ACLP_vanhanen ACLP_schooling ACLP_export ACLP_gini ACLP_religion ACLP_spending ACLP_alesina if sample_2values, cluster(ccode)

esttab using "M:\Statating\stata/TABELL 3_trust.rtf", se nogap label title(TABLE 3. Dynamic probit regression) replace ///
	nonumbers mtitles("1: FHI (low). " "2: FHI (low).7-year lag" "3: FHI (high). 1-year lag" "4:FHI(high). 7-year lag" "5: ACLP. 1-year lag" "6:ACLP. 7-year lag") addnotes("All independent and control variables are lagged by one year. Freedom House (FH) is dichotomized using three different thresholds: Low: 1 equals FH > 2.5, medium: 1 equals FH > 4, high: 1 equals FH > 5.5" "All independent variables are lagged by one year") ///
	pr2 scalars(ll ll_0) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
		

*TABLE B.8.		
eststo clear
eststo: mi estimate, post: regress F7.EDI2 selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI2 selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI2 selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI2 religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2 EDI2.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
	
	
*TABLE B.9.
eststo clear
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_1values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_1values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_1values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_1values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_1values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_1values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_1values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_1values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2 sample 1 values syste,.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:EDI" "7:FH" "8:FH") addnote("All explanatory variables are lagged by 7 years, except from in model 5 og 7 where a 1-year lag i used") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	
	
	
*TABLE B.10.	
eststo clear
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending, re i(ccode)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2 sample 1 values syste,.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	
	


*TABLE B.11.	
eststo clear
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen Gerring religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen Gerring religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen Gerring schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen Gerring schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen Gerring schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen Gerring schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports Gerring if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports Gerring if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports Gerring if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports Gerring if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2_democratic stock.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
	

*Table B.12. 
eststo clear
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports prot_zone eng_zone cath_zone euro_orth_zone confucian_zone latin_zone islam_zone africa_zone cultural_zone if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports prot_zone eng_zone cath_zone euro_orth_zone confucian_zone latin_zone islam_zone africa_zone cultural_zone if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports Gerring if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports Gerring if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen religion schooling alesina gini public_spending exports Gerring if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen religion schooling alesina gini public_spending exports Gerring if sample_2values==1, cluster(ccode)


esttab using "M:\Statating\stata/TABELL 2 med time-invariant variables.rtf", se nogap label title(TABLE 2 with country-specific variables.) replace ///
	nonumbers mtitles("1: EDI" "2: FHI" "3: EDI" "4: FHI" "5: EDI" "6:FHI" "7:EDI" "8:FHI") addnote("All explanatory variables are lagged by 7 years") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	
	
	
	
*TABLE B.13
eststo clear
eststo: mi estimate, post: regress F7.EDI pippaindex vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse pippaindex vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI pippaindex vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse pippaindex vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI pippaindex vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse pippaindex vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(pippaindex vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(pippaindex vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2 med pippa index.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers addnote("All explanatory variables are lagged by 7 years") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
	

*TABLE B.14.	
eststo clear
eststo: mi estimate, post: regress F.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtdpdsys F.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2 med 1 year lag.rtf", se nogap label title("TABLE 2 with 1-year lagged independent variables") replace ///
	nonumbers mtitles("1: EDI" "2: FHI" "3: EDI" "4: FHI" "5: EDI" "6:FHI" "7:EDI" "8:FHI") addnote("All explanatory variables are lagged by 1 years") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	
*TABLE B.15.	
eststo clear
eststo clear
eststo: mi estimate, post: regress F5.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F5.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F5.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F5.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F5.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F5.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtdpdsys F5.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F5.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2 med 5 year lag.rtf", se nogap label title("TABLE 2 independent variables lagged by 5 years") replace ///
	nonumbers mtitles("1: EDI" "2: FHI" "3: EDI" "4: FHI" "5: EDI" "6:FHI" "7:EDI" "8:FHI") addnote("All explanatory variables are lagged by 5 years") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
		


*TABLE B.16.
eststo clear
eststo: mi estimate, post: regress F7.polity selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.polity selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.polity selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.polity religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2 med polity.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers addnote("All explanatory variables are lagged by 7 years, except from in model 5 og 7 where a 1-year lag i used") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
	
	
*TABLE B.17.
eststo clear
eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) maxldep(3) maxlags(4) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) maxldep(3) maxlags(4) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
		
eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) maxldep(3) maxlags(2) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) maxldep(3) maxlags(2) artests(2)
esttab using "M:\Statating\stata/TABELL 2_lag restrictions.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI no lag restrictions" "2: FH no lag restrictions" "3: EDI max 4 lags" "4: FH max 4 lags" "5: EDI max 3 lags" "6:FH max 3 lags" "7:EDI max 2 lags" "8:FH max 2 lags") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
	

*TABLE B.18.
eststo clear
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports wdi_fe if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports wdi_fe if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending wdi_fe if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending wdi_fe if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending wdi_fe if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending wdi_fe if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports dem_tradition_final wdi_fe if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final wdi_fe if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final wdi_fe if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final wdi_fe if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 2_med fuels.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
	


*TABLE B.19.
eststo clear
eststo: mi estimate, post: regress F7.EDI selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports regimeoriginreversewave if sample_2values==1, cluster(ccode)
eststo: mi estimate, post: regress F7.FHouse selfexpressionA1 vanhanen dem_tradition_final religion schooling alesina gini public_spending exports regimeoriginreversewave if sample_2values==1, cluster(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending regimeoriginreversewave if sample_2values==1, fe i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending regimeoriginreversewave if sample_2values==1, fe i(ccode)

eststo: mi estimate, post: xtreg F7.EDI selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending regimeoriginreversewave if sample_2values==1, re i(ccode)
eststo: mi estimate, post: xtreg F7.FHouse selfexpressionA1 vanhanen dem_tradition_final schooling exports alesina gini religion public_spending regimeoriginreversewave if sample_2values==1, re i(ccode)

eststo: mi estimate, cmdok post: xtabond F7.EDI religion gini alesina exports dem_tradition_final regimeoriginreversewave if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtabond F7.FHouse religion gini alesina exports dem_tradition_final regimeoriginreversewave if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)

eststo: mi estimate, cmdok post: xtdpdsys F7.EDI religion gini alesina exports dem_tradition_final regimeoriginreversewave if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.FHouse religion gini alesina exports dem_tradition_final regimeoriginreversewave if sample_2values==1, lags(1) endog(selfexpressionA1 vanhanen schooling public_spending) artests(2)


esttab using "M:\Statating\stata/TABELL 2_med waves.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH" "5: EDI" "6:FH" "7:EDI" "8:FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	
	
	
	
*TABLE B.20.	
eststo clear
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(FHouse dem_tradition_final vanhanen schooling public_spending) maxldep(3) maxlags(4) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(FHouse Gerring vanhanen schooling public_spending) maxldep(3) maxlags(4) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(EDI dem_tradition_final vanhanen schooling public_spending) maxldep(3) maxlags(4) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(EDI Gerring vanhanen schooling public_spending) maxldep(3) maxlags(4) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(FHouse dem_tradition_final vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(FHouse Gerring vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(EDI dem_tradition_final vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(EDI Gerring vanhanen schooling public_spending) maxldep(3) maxlags(3) artests(2)

esttab using "M:\Statating\stata/TABELL 3_lag1_instrument_restric.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI max 3 lags" "2: FH max 3 lags" "3: EDI max 3 lags" "4: FH max 3 lags" "5: EDI max 3 lags" "6: FH max 3 lags" "7: EDI max 3 lags" "8: FH max 3 lags") addnote("All explanatory variables are lagged by 1 year. See Table 3 in the paper for further specifications.") ///
	scalars(r
	
	

*TABLE B.21. 
eststo clear
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports, lags(1) endog(FHouse dem_tradition_final vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports, lags(1) endog(FHouse Gerring vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports, lags(1) endog(EDI dem_tradition_final vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F.selfexpressionA1 religion gini alesina exports , lags(1) endog(EDI Gerring vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 3_lag1.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
	



*TABLE B.22.
eststo clear
eststo: mi estimate, cmdok post: xtdpdsys F7.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(FHouse dem_tradition_final vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(FHouse Gerring vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(EDI dem_tradition_final vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtdpdsys F7.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(EDI Gerring vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 3_lag7.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)	



*TABLE B.23.
eststo clear
eststo: mi estimate, cmdok post: xtreg F.selfexpressionA1 FHouse dem_tradition_final vanhanen schooling public_spending religion gini alesina exports if sample_2values==1, re i(ccode)
eststo: mi estimate, cmdok post: xtreg F.selfexpressionA1 FHouse Gerring vanhanen schooling public_spending religion gini alesina exports if sample_2values==1, re i(ccode)
eststo: mi estimate, cmdok post: xtreg F.selfexpressionA1 EDI dem_tradition_final vanhanen schooling public_spending religion gini alesina exports if sample_2values==1, re i(ccode)
eststo: mi estimate, cmdok post: xtreg F.selfexpressionA1 EDI Gerring vanhanen schooling public_spending religion gini alesina exports if sample_2values==1, re i(ccode)

esttab using "M:\Statating\stata/TABELL 3_random effects.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH") addnote("All explanatory variables are lagged by 1 year. See Table 3 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	
*TABLE B.24	
eststo clear
eststo: mi estimate, cmdok post: xtreg F.selfexpressionA1 FHouse dem_tradition_final vanhanen schooling public_spending religion gini alesina exports if sample_2values==1, fe i(ccode)
eststo: mi estimate, cmdok post: xtreg F.selfexpressionA1 FHouse Gerring vanhanen schooling public_spending religion gini alesina exports if sample_2values==1, fe i(ccode)
eststo: mi estimate, cmdok post: xtreg F.selfexpressionA1 EDI dem_tradition_final vanhanen schooling public_spending religion gini alesina exports if sample_2values==1, fe i(ccode)
eststo: mi estimate, cmdok post: xtreg F.selfexpressionA1 EDI Gerring vanhanen schooling public_spending religion gini alesina exports if sample_2values==1, fe i(ccode)

esttab using "M:\Statating\stata/TABELL 3_fixed effects.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH") addnote("All explanatory variables are lagged by 1 year. See Table 3 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
	
	
*TABLE B.25. 
eststo clear
eststo: mi estimate, cmdok post: xtabond F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(FHouse dem_tradition_final vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtabond F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(FHouse Gerring vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtabond F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(EDI dem_tradition_final vanhanen schooling public_spending) artests(2)
eststo: mi estimate, cmdok post: xtabond F.selfexpressionA1 religion gini alesina exports if sample_2values==1, lags(1) endog(EDI Gerring vanhanen schooling public_spending) artests(2)

esttab using "M:\Statating\stata/TABELL 3_bond.rtf", se nogap label title(TABLE 2.) replace ///
	nonumbers mtitles("1: EDI" "2: FH" "3: EDI" "4: FH") addnote("All explanatory variables are lagged by 7 years. See Table 2 in the paper for further specifications.") ///
	scalars(r2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001)

	
	
