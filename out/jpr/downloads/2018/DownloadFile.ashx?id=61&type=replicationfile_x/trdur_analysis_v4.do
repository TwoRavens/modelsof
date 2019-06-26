
cd  "/Users/Geoff/Dropbox/Eric and Geoff/During Conflict Trials/Data/OutputFormattedData"
use tr_condur_v4.dta, clear


**** Trials section descriptives and charts
**********************************************************************

	*Collapse
		
		drop n
		gen n=1
		set scheme s1mono
		collapse (sum) n epend icc_inter ict bct gct, by(year)
		drop if year<1970

		
	*Figure 1: Area chart with lines
	
		twoway (area n year, color(gs8)) (line ict year, lpattern(solid) color(gs13))  ///
			(line bct year, lpattern(solid) color(black)) (line gct year, lpattern(dash)), ///
			legend(label(1 "Ongoing conflicts") label(2 "Int'l trials") label(3 "DHR trials") label(4 "Security trials") size(vsmall) ring(0) position(10)) ///
			caption("Figure 1: Count of ongoing conflicts and mid-conflict criminal prosecutions") ///
			 saving(figure1.gph, replace)
			 
			 graph export figure1.tif, width(3900) replace
			 
	
	*Figure 2: Stacked area chart
	
		by year: gen tot=bct+gct+ict
		by year: gen gper=gct/tot
		by year: gen bper=bct/tot
		by year: gen iper=ict/tot
		gen ct3 = gper+bper
		gen ct4 = gper+bper+iper
	
		twoway (area ct4 year, color(gs15)) (area ct3 year, color(gs11)) (area gper year, color(gs7)), ///
			xlabel(1970 (5) 2010, alternate) ylabel(0 (.25) 1) xtitle("") ///
			text(.10 1975 "{bf:Security trials}") text(.50 1990 "{bf:Domestic HR}") text(.98 1999.5 "{bf:International}") legend(off) ///
			caption("Figure 2: Stacked area chart of prosecutions in conflict") ///
			saving(figure2.gph, replace)
			
			graph export figure2.tif, width(3900) replace


			
**** Table of Conflicts and Trials
**********************************************************************

	** Table III for Appendix

		use tr_condur_v4.dta, clear
			
			drop n
			gen n=1
			drop if year<1970

			collapse (firstnm) country (sum) n epend (max) ccode dyads ethwar region gsum bsum isum ///
				(mean) polity2, by(conflictid) 
			
			sort region country
			
			gen polity2rd=round(polity2,.1)

			gen conflicts=1

			collapse (firstnm) country (sum) n epend dyads conflicts (max) ethwar region gsum bsum isum ///
				(mean) polity2rd, by(ccode)

			gen region2="."
			replace region2="Americas" if region==5
			replace region2="Europe" if region==1
			replace region2="Mideast" if region==2
			replace region2="Asia" if region==3
			replace region2="Africa" if region==4

			sort region2 country
			order conflicts, after(n)

			listtex region2 country n conflicts epend gsum bsum isum polity2rd using TA3.tex, replace

	
	**Summary Stats, page 20 
	
		collapse (sum) n conflicts epend gsum bsum isum (mean) polity2rd, by(region)
	 



**** St set, labels, and summary
**********************************************************************

cd  "/Users/Geoff/Dropbox/Eric and Geoff/During Conflict Trials/Data/OutputFormattedData"
	
	use tr_condur_v4.dta, clear
	
	**Summary Stats on conflict, research design section
	
		collapse (sum) epend (max) ccode t3, by(conflictid ep)
		collapse (sum) epend (max) ccode, by(conflictid)
		gen n=1
		collapse (sum) n, by(ccode)

	
	**Other stuff
	
	use tr_condur_v4.dta, clear	
	
	**Labels
	
		label variable icc_inter "ICC intervention"
		label variable isum "Previous int'l trials"
		label variable ict "Int'l trials"
		label variable ibin "Int'l trial"
		label variable ivbin "		Int'l verdict"
		label variable l11_ibin "Int'l trial [t+(t-1)]"
		label variable l11_ivbin "Int'l verdict [t+(t-1)]"
		label variable bsum "Previous conflict DHR trials"
		label variable bct "DHR trials"
		label variable bbin "DHR trial"
		label variable bvbin "		DHR verdict"
		label variable l11_bbin "DHR trial [t+(t-1)]"
		label variable l11_bvbin "DHR verdict [t+(t-1)]"
		label variable bhbin "High-tranking DHR trial"
		label variable bhct "High-ranking DHR trials"
		label variable l11_bhbin "High-ranking DHR trial"
		label variable dsum "Previous security trials"
		label variable gct "Security trials"
		label variable gbin "Security trial" 
		label variable l11_gbin "Security trial [t+(t-1)]" 
		label variable gvbin "		Security verdict"
		label variable l11_gvbin "Security verdict [t+(t-1)]" 
		label variable gsum "Previous HR security trials"
		label variable gct "Security trials"
		label variable gbin "Security trial" 
		label variable epend "Conflict termination"
		label variable terr "Territorial"
		label variable cumint "Cum. intensity" 
		label variable bop "Balance of power"
		label variable dyads "Ongoing conflicts"
		label variable unpko "UN peacekeeping"
		label variable mediation "Mediation" 
		label variable ethwar "Ethnic war"
		label variable coup "Coup"
		label variable demo "Democracy"
		label variable xconst "Executive constraint"
		label variable lsji "Jud independence"
		label variable cfhr "HR protection"
		label variable t2 "Conflict duration"
		label variable t3 "Conflict duration"
		label variable t32 "Duration squared"
		label variable t33 "Duration cubed" 
		label variable condur "Conflict duration"
		label variable ltime "Conflict duration (ln)"

	
	**Table I Appendix
	
		estpost summarize icc_inter gbin gvbin bbin bvbin ibin ivbin   ///
			epend icc_inter terr cumint t3 bop dyads unpko mediation ethwar coup demo lsji cfhr 

			esttab using Table2.tex, replace label cells("count mean sd min max")

	
	**Multicolinearity?
	
		corr icc_inter ibin bbin gbin 
		corr bop icc_inter ibin bbin gbin
		corr epend terr cumint t bop dyads unpko mediation ethwar coup demo lsji cfhr 


	**Some var changes	
	
		gen contype=0
		replace contype=1 if coup==1
		replace contype=2 if ethnic==1
		replace contype=3 if secession==1
		replace contype=4 if terrorist==1
		replace contype=5 if islamist==1
		replace contype=6 if civilwar==1
		replace contype=7 if autonomy==1
		replace contype=8 if communist==1

		gen govterr=0
		replace govterr=1 if gov==1
		replace govterr=2 if terr==1

		tabulate bbin contype
		tabulate gbin contype

		gen nego=0
		replace nego=1 if (pcag_term==1 | cease_term==1)
		gen negoterm=0
		replace negoterm=1 if (nego==1 & epend==1)

		
	**Missing values
		
		tab1 epend icc_inter ibin bbin gbin t2 terr cumint bop dyads unpko mediation ethwar coup demo, m
	
	
	
**** ANALYSES
******************************************************************************************
	
**Regular Probits, combined models

	probit epend icc_inter ict bct gct t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup demo lsji cfhr, ///
		cluster(conflictid) robust

	probit epend gbin bbin ibin icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
		cluster(conflictid) robust
			estimates store p1
			estat gof, group(10)
			
			*Cox
			stset t3, id(conflep) fail(epend)
			sts graph, by(ibin)
			
			streg icc_inter ibin bbin gbin terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, distribution(weibull) cluster(conflictid) robust 
				*Results suggest that probability of termination decreases with time	
	
			*Non-coups
			probit epend icc_inter ibin bbin gbin t3 t32 t33 terr cumint bop dyads unpko mediation ethwar xconst lsji cfhr if coup==0, cluster(conflictid) robust	
		
			*Negotiated Termination
			probit negoterm icc_inter ibin bbin gbin t3 t32 t33 terr cumint bop dyads unpko mediation ethwar xconst lsji cfhr, ///
				cluster(conflictid) robust
				
			*Victory Termination
			probit vic_term ibin bbin gbin t3 t32 t33 terr cumint bop dyads unpko mediation ethwar xconst lsji cfhr, ///
				cluster(conflictid) robust	
			
			*Sum of all binary trials over conflict episode
			probit epend icc_inter ibsum bbsum gbsum t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
				cluster(conflictid) robust
			
	
	probit epend l11_gbin l11_bbin l11_ibin icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
		cluster(conflictid) robust
			estimates store p2
			estat gof

	probit epend gvbin bvbin ivbin icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
		cluster(conflictid)	robust
			estimates store p3
			estat gof
			
	probit epend l11_gvbin l11_bvbin l11_ivbin icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
		cluster(conflictid)	robust
			estimates store p4
			estat gof
		
		
	**Table II Appendix
	
		gen allbin=0
			replace allbin=1 if (gbin==1 | bbin==1 | ibin==1)
			
		probit epend allbin icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
			cluster(conflictid)	robust
				estimates store a1
		
		*Latex
		esttab a1 using TA2.tex, replace ///
			label ///
			wide ///
			se scalars(N ll ll N_clust chi2 r2_p) ///
			star(\dag 0.10 * 0.05 ** 0.01) ///
			title(Probit Models) /// 
			note(**p\sym{<}.01  *p\sym{<}.05  \dag p\sym{<}.10.) ///
			nonumbers mtitles("All trials")
			
		*Excel
		esttab a1 using TA2.csv, replace ///
			label ///
			wide ///
			se scalars(N ll ll N_clust chi2 r2_p) ///
			star(\dag 0.10 * 0.05 ** 0.01) ///
			title(Probit Models) /// 
			note(**p<.01  *p<.05  \dag p<.10.) ///
			nonumbers mtitles("All trials")
	
	
	**Table I in text
	
		*Latex
		esttab p1 p2 p3 p4  using T1.tex, wide replace ///
			label ///
			se scalars(N ll ll N_clust chi2 r2_p) ///
			star(\dag 0.10 * 0.05 ** 0.01) ///
			title(Probit models) /// 
			note(**p\sym{<}.01  *p\sym{<}.05  \dag p\sym{<}.10.) ///
			nonumbers mtitles("Trial" "Trial[t+(t-1)]" "Verdict" "Verdict[t+(t-1)]")	
		
		*Excel
		esttab p1 p2 p3 p4  using T1.csv, wide replace ///
			label ///
			se scalars(N ll ll N_clust chi2 r2_p) ///
			star(\dag 0.10 * 0.05 ** 0.01) ///
			title(Probit models) /// 
			note(**p<.01  *p<.05  \dag p<.10.) ///
			nonumbers mtitles("Trial" "Trial[t+(t-1)]" "Verdict" "Verdict[t+(t-1)]")
		
		
	**Figure 3: Coefplot 
		
			coefplot (p1, label(Risk of termination)), ///
			xline(0) levels(95) labels drop(_cons)  ///
			title("Model 1") ///
			order (gbin bbin ibin icc_inter coup unpko mediation cfhr ethwar t3 t32 t33 terr bop xconst lsji cumint dyads) ///
			saving(coefplot1.gph, replace)

			coefplot (p2, label(Risk of termination)), ///
			xline(0) levels(95) labels drop(icc_inter _cons coup unpko mediation cfhr ethwar t3 t32 t33 terr bop xconst lsji cumint dyads) ///
			title("Model 2") ///
			order (l11_gbin l11_bbin l11_ibin) ///
			saving(coefplot2.gph, replace)
			
			coefplot (p3, label(Risk of termination)), ///
			xline(0) levels(95) labels drop(_cons icc_inter coup unpko mediation cfhr ethwar t3 t32 t33 terr bop xconst lsji cumint dyads) ///
			title("Model 3") ///
			order (gvbin bvbin ivbin) ///
			saving(coefplot3.gph, replace)
			
			coefplot (p4, label(Risk of termination)), ///
			xline(0) levels(95) labels drop(_cons icc_inter coup unpko mediation cfhr ethwar t3 t32 t33 terr bop xconst lsji cumint dyads) ///
			title("Model 4") ///
			order (l11_gvbin l11_bvbin l11_ivbin) ///
			saving(coefplot4.gph, replace)
			
		*Output
			graph combine coefplot2.gph coefplot3.gph coefplot4.gph, col(1) saving(coefplot234.gph, replace)
			graph combine coefplot1.gph coefplot234.gph, note("Two-tailed tests reported. Controls unreported for models 2-4.") ///
				caption("Figure 3. Probit coefficients")
			graph export coefplot1234.tif, width(3900) replace
			
		
		
	**Clarify for Figure 4 -- might change slightly with different simulations

		*Security Trials
		*Original operationalization

		estsimp probit epend gbin bbin ibin  icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
			cluster(conflictid) robust genname(eq1) sims(10000)
			
			setx icc_inter 0 ibin 0 bbin 0 gbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 ibin 0 bbin 0 gbin 1 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi 
			
			simqi, fd(pr) changex(gbin 0 1) level(95) 
			
		
		* Two years 		
		
		estsimp probit epend l11_gbin l11_bbin l11_ibin  icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
			cluster(conflictid) robust genname(eq2) sims(10000)
			
			setx icc_inter 0 l11_ibin 0 l11_bbin 0 l11_gbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 l11_ibin 0 l11_bbin 0 l11_gbin 1 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			
			simqi, fd(pr) changex(l11_gbin 0 1) level(95) 
				
			
		* Verdicts  		
		
		estsimp probit epend gvbin bvbin ivbin icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
			cluster(conflictid) robust genname(eq3) sims(10000)
			
			setx icc_inter 0 ivbin 0 bvbin 0 gvbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 ivbin 0 bvbin 0 gvbin 1 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			
			simqi, fd(pr) changex(gvbin 0 1) level(95)  
				
		
		
		*DHR Trials
		*Original operationalization

		estsimp probit epend gbin bbin ibin icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
			cluster(conflictid) robust genname(eq4) sims(10000)
			
			setx icc_inter 0 ibin 0 bbin 0 gbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 ibin 0 bbin 1 gbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			
			simqi, fd(pr) changex(bbin 0 1) level(95) 
		
		* Two years 		
		
		estsimp probit epend l11_gbin l11_bbin l11_ibin  icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
			cluster(conflictid) robust genname(eq5) sims(10000)
			
			setx icc_inter 0 l11_ibin 0 l11_bbin 0 l11_gbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 l11_ibin 0 l11_bbin 1 l11_gbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			
			simqi, fd(pr) changex(l11_bbin 0 1) level(95) 
			
		* Verdicts  		
		
		estsimp probit epend gvbin bvbin ivbin icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
			cluster(conflictid) robust genname(eq6) sims(10000)
			
			setx icc_inter 0 ivbin 0 bvbin 0 gvbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 ivbin 0 bvbin 1 gvbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			
			simqi, fd(pr) changex(bvbin 0 1) level(95) 
				
	
		*Intl Trials
		*Original operationalization

		estsimp probit epend gbin bbin ibin  icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
			cluster(conflictid) robust genname(eq7) sims(10000)
			
			setx icc_inter 0 ibin 0 bbin 0 gbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 ibin 1 bbin 0 gbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			
			simqi, fd(pr) changex(ibin 0 1) level(95) 
			
		* Two years 		
		
		estsimp probit epend l11_gbin l11_bbin l11_ibin  icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
			cluster(conflictid) robust genname(eq8) sims(10000)
			
			setx icc_inter 0 l11_ibin 0 l11_bbin 0 l11_gbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 l11_ibin 1 l11_bbin 0 l11_gbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			
			simqi, fd(pr) changex(l11_ibin 0 1) level(95) 
		
			
		* Verdicts  		
		
		estsimp probit epend gvbin bvbin ivbin icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
			cluster(conflictid) robust genname(eq9) sims(10000)
			
			setx icc_inter 0 ivbin 0 bvbin 0 gvbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 ivbin 1 bvbin 0 gvbin 0 terr 0 cumint 0 t3 mean t32 mean t33 mean bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi 	

			simqi, fd(pr) changex(ivbin 0 1) level(95) 	
		
	
		*first differences, and confidence intervals from above copied into Figure4.csv file 
		** values may differ slightly due to variations when simulating parameters via Clarify **
			
			clear
			insheet using "Figure4.csv" 
			gen fd100=fd*100
			gen fdmin100=fdmin*100
			gen fdmax100=fdmax*100
			gen dfd100=dfd*100
			gen dfdmin100=dfdmin*100
			gen dfdmax100=dfdmax*100
			gen ifd100=ifd*100
			gen ifdmin100=ifdmin*100
			gen ifdmax100=ifdmax*100
		
		
		*Figure 4: predicted probabilities graph
		
		#delimit;
		twoway (bar fd100 sec, barw(.2) color(gs6)) ||
		  (rcap fdmin100 fdmax100 sec, lw(thin) color(black)) ||
		  (bar dfd100 dhr, barw(.2) color(gs10)) ||
		  (rcap dfdmin100 dfdmax100 dhr if dhr!=., lw(thin) color(black))
		  (bar ifd100 ihr, barw(.2) color(gs14)) ||
		  (rcap ifdmin100 ifdmax100 ihr if ihr!=., lw(thin) color(black)),
		  xlabel(1.2 "Prosecutions" 2 "Prosecutions t+(t-1)",
					labsize(medsmall))
		  ylabel(-15(5)35, val angle(horizontal))
		  ymtick(-15(5)35)
		  ytitle("Change in probability from baseline", size(small))
		  yline(0, lstyle(foreground) lpattern(dash) lw(thin) lc(black))
		    legend(order(1 3 5) label(1 "Security trials") label (3 "Domestic HR") label(5 "International") rows(1) size(vsmall))
		  graphregion(color(white))
		   text(-1 1 "16%", place(s) color(black) size(small))
		  text(-9 1.2 "-2%", place(s) color(black) size(small))
		  text(-4.5 1.4 "9%", place(s) color(black) size(small))
		   text(-1 1.8 "13%", place(s) color(black) size(small))
		  text(-11 2 "-3%", place(s) color(black) size(small))
		   text(-5 2.2 "10%", place(s) color(black) size(small))
		   caption("Figure 4. First differences, baseline: no prosecutions")
		   saving(fd.gph, replace)
					  ;
			#delimit cr
		
		graph export figure4.tif, width(3900) replace


		
	**Bivariate Probits to test selection, and mechanisms

		use tr_condur_v4.dta, clear	
		
	
		*Labels
	
		label variable icc_inter "ICC intervention"
		label variable isum "Previous int'l trials"
		label variable ict "Int'l trials"
		label variable ibin "Int'l trial"
		label variable ivbin "		Int'l verdict"
		label variable l11_ibin "Int'l trial [t+(t-1)]"
		label variable l11_ivbin "Int'l verdict [t+(t-1)]"
		label variable bsum "Previous conflict DHR trials"
		label variable bct "DHR trials"
		label variable bbin "DHR trial"
		label variable bvbin "		DHR verdict"
		label variable l11_bbin "DHR trial [t+(t-1)]"
		label variable l11_bvbin "DHR verdict [t+(t-1)]"
		label variable bhbin "High-ranking DHR trial"
		label variable bhct "High-ranking DHR trials"
		label variable l11_bhbin "High-ranking DHR trial"
		label variable dsum "Previous security trials"
		label variable gct "Security trials"
		label variable gbin "Security trial" 
		label variable l11_gbin "Security trial [t+(t-1)]" 
		label variable gvbin "		Security verdict"
		label variable l11_gvbin "Security verdict [t+(t-1)]" 
		label variable gsum "Previous HR security trials"
		label variable gct "Security trials"
		label variable gbin "Security trial" 
		label variable epend "Conflict termination"
		label variable terr "Territorial"
		label variable cumint "Cum. intensity" 
		label variable bop "Balance of power"
		label variable dyads "Ongoing conflicts"
		label variable unpko "UN peacekeeping"
		label variable mediation "Mediation" 
		label variable ethwar "Ethnic war"
		label variable coup "Coup"
		label variable demo "Democracy"
		label variable xconst "Executive constraint"
		label variable lsji "Jud independence"
		label variable cfhr "HR protection"
		label variable t2 "Conflict duration"
		label variable t3 "Conflict duration"
		label variable t32 "Duration squared"
		label variable t33 "Duration cubed"
		label variable condur "Conflict duration"
		label variable ltime "Conflict duration (ln)"

		*Security trials
		biprobit (gbin=dyads bop coup lsji xconst cfhr) ///
		(epend=gbin terr cumint t3 t32 t33 dyads bop unpko mediation ethwar coup cfhr), ///
		cluster(conflictid) 
			estimates store bpb1
			
		*Domestic HR Conflict trials
		biprobit (bbin=coup lsji xconst cfhr) ///
		(epend=bbin terr cumint t3 t32 t33 dyads bop unpko mediation ethwar coup cfhr), ///
		cluster(conflictid)
			estimates store bpb2
 
		*International trials
		biprobit (ibin=coup lsji xconst cfhr unpko) ///
		(epend=ibin terr cumint t3 t32 t33 bop dyads unpko mediation ethwar coup cfhr), ///
		cluster(conflictid)
			estimates store bpb3
 	
	**Table of results
			
		*Latex	
		esttab  bpb1 bpb2 bpb3 using T2.tex, replace ///
			label ///
			wide ///
			se scalars(N ll ll N_clust chi2 r2_p) ///
			star(\dag 0.10 * 0.05 ** 0.01) ///
			title(Seemingly Unrelated Bivariate Probits) /// 
			note(**p\sym{<}.01  *p\sym{<}.05  \dag p\sym{<}.10.) ///
			nonumbers mtitles(Security DHR Int'l)	
			
		*Excel	
		esttab  bpb1 bpb2 bpb3 using T2.csv, replace ///
			label ///
			wide ///
			se scalars(N ll ll N_clust chi2 r2_p) ///
			star(\dag 0.10 * 0.05 ** 0.01) ///
			title(Seemingly unrelated bivariate probits) /// 
			note(**p<.01  *p<.05  \dag p<.10.) ///
			nonumbers mtitles(Security DHR Int'l)	

		
***Appendix effects of time

	estsimp probit epend gbin bbin ibin icc_inter t3 t32 t33 terr cumint bop dyads unpko mediation ethwar coup xconst lsji cfhr, ///
			cluster(conflictid) robust genname(eq1) sims(10000)
			
			setx icc_inter 0 ibin 0 bbin 0 gbin 0 terr 0 cumint 0 t3 1 t32 1 t33 1  bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 ibin 0 bbin 0 gbin 0 terr 0 cumint 0 t3 5 t32 25 t33 125 bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi 
			setx icc_inter 0 ibin 0 bbin 0 gbin 0 terr 0 cumint 0 t3 10 t32 100 t33 1000 bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi 
			
			setx icc_inter 0 ibin 0 bbin 0 gbin 1 terr 0 cumint 0 t3 1 t32 1 t33 1  bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 ibin 0 bbin 0 gbin 1 terr 0 cumint 0 t3 5 t32 25 t33 125 bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi 
			setx icc_inter 0 ibin 0 bbin 0 gbin 1 terr 0 cumint 0 t3 10 t32 100 t33 1000 bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi 
			
			setx icc_inter 0 ibin 0 bbin 1 gbin 0 terr 0 cumint 0 t3 1 t32 1 t33 1  bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 ibin 0 bbin 1 gbin 0 terr 0 cumint 0 t3 5 t32 25 t33 125 bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi 
			setx icc_inter 0 ibin 0 bbin 1 gbin 0 terr 0 cumint 0 t3 10 t32 100 t33 1000 bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi 
			
			setx icc_inter 0 ibin 1 bbin 0 gbin 0 terr 0 cumint 0 t3 1 t32 1 t33 1  bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi
			setx icc_inter 0 ibin 1 bbin 0 gbin 0 terr 0 cumint 0 t3 5 t32 25 t33 125 bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi 
			setx icc_inter 0 ibin 1 bbin 0 gbin 0 terr 0 cumint 0 t3 10 t32 100 t33 1000 bop mean dyads mean unpko 0 mediation 0 ethwar 0 coup 0 xconst mean lsji mean cfhr mean
			simqi 
			
			*save in csv file called FigureA1
			
			clear
			insheet using "FigureA1.csv" 
			replace baseline=baseline*100
			replace security=security*100
			replace domestic=domestic*100
			replace international=international*100
			
			
			twoway (line baseline time, lpattern(solid) color(black)) (line security time, lpattern(longdash) color(gs10)) ///
			(line domestic time, lpattern(solid) color(gs10))  (line international time, lpattern(dash) color(gs10)) , ///
			xlabel(1(1)10) ///
			legend(label(1 "Baseline") label(2 "Security") label(3 "Domestic HR") label(4 "International") size(vsmall) ring(0) position(10)) ///
			ytitle("Probability of termination") ///
			caption("Figure A1: Effect of time on probability of conflict termination") ///
			 saving(figureA1.gph, replace)
			 
			 graph export figureA1.tif, width(3900) replace

			
			
