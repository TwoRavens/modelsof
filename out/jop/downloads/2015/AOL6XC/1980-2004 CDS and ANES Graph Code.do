*This Do File contains the graph code for the revised version of the paper* 
*co-authored with William M. Myers and Judd R. Thornton for which we* 
*were offered an invitation to revise and resubmit at the Journal of Politics*

*This code "flips" the axis for Figures 3, 4 and 5 in so that*
*the x-axis represents years and the y-axis represents correlations*
*for all figures in the manuscript*

*This code also generates all six figures listed in the supplemental online*
*appendix*

*The figures are a plot of correlations between ideological*
*self-identifications and factor two for elites and the full mass public*
*sample, correlaions between ideological self-identifications and factor two* 
*for the mass public conditioned on sophistication and correlations between* 
*the two operationalizations of political knowledge for each year included*
*in the analysis*

*Note: The correlations between the two operationalizations of political*
*knowledge are shown for each year in which the both measures are available,*
*1988-2004*

*Note: All changes represented in this Do-File are made to satisfy Reviewer 1*
 
*Wed. 19 June 2013*
*Updated: Thurs. 20 June 2013*
*Updated: Wed. 24 July 2013*
*Updated: Friday 26 July 2013*
*Updated: Mon. 29 July 2013*
*Updated: Tues. 17 September 2013*
*Updated: Thurs. 26 September 2013*

****************
*Correlations between ideological self-identifications and factor one*
*for elites and the mass public, which is to say the ANES full sample*

*Note: This graph represents Figure 3 in the paper*
****************

twoway  (scatter CDSest n in 1/6, mcolor(black) msymbol(circle) /// 
        msize(med)) /// 
        (rspike CDSlower CDSupper n in 1/6, vertical lcolor(black) /// 
        lwidth(thin) legend(order(1 "CDS" 3 "ANES")) /// 
        legend(pos(6)col(1)) /// 
        legend(size(small))) ///
		(scatter ANESest n in 1/6, mcolor(black) msymbol(circle) /// 
		mfcolor(white) msize(med)) (rspike ANESlower ANESupper n in 1/6, /// 
		vertical lcolor(black) lwidth(thin)), ///
	  	graphregion(fcolor(white)) graphregion(lpattern(blank)) ///
	    plotregion(lcolor(black))graphregion(margin(medsmall)) /// 
	  	aspectratio(.67) ///
	  	xlabel(1 "1980"  2 "1984" 3 "1988"  4 "1992" 5 "2000" 6 "2004", /// 
	  	labsize(medsmall)) ///
	    xtitle(" ", size(medsmall)) ///
	  	ylabel(.3(.2).9, labsize(medsmall) nogrid) ///
	  	ytitle("Correlation", size(medsmall))
	  	
****************
*Correlations between ideological self-identifications and factor one* 
*for the mass public, conditioned by sophistication*

*Note: This graph compares the aforementioned correlations for the ANES*
*stratified sample*

*Here, the mass public is stratified into thirds according* 
*to the sophistication scale, which combines measures of political knowledge,* 
*interest and involvement*
*The three groups of the stratified sample are labeled "least sophisticated,"
*"moderately sophisticated" and "most sophisticated, respectively"*

*Note: This graph represents Figure 4 in the paper*
****************

twoway  (scatter LOWest n in 1/6, mcolor(black) msymbol(smdiamond) /// 
        msize(med)) /// 
        (rspike LOWlower LOWupper n in 1/6, vertical lcolor(black) /// 
        lwidth(thin) legend(order(5 "Most Sophisticated"  ///
        3 "Moderately Sophisticated" 1 "Least Sophisticated")) /// 
        legend(pos(6)col(1)) /// 
        legend(size(small))) ///
		(scatter MIDDLEest n in 1/6, mcolor(black) msymbol(circle) /// 
	    mfcolor(white) msize(med)) ///
		(rspike MIDDLElower MIDDLEupper n in 1/6, vertical ///
		lcolor(black) lwidth(thin)) ///
		(scatter HIGHest n in 1/6, mcolor(black) msymbol(circle) /// 
		msize(med)) /// 
        (rspike HIGHlow HIGHupper n in 1/6, vertical lcolor(black) /// 
        lwidth(thin)), graphregion(fcolor(white)) /// 
        graphregion(lpattern(blank)) plotregion(lcolor(black)) ///
        graphregion(margin(medsmall)) aspectratio(.67) ///
        xlabel(1 "1980"  2 "1984" 3 "1988"  4 "1992" 5 "2000" 6 "2004", ///
        labsize(medsmall)) /// 
     	xtitle(" ", size(medsmall)) ///
        ylabel(.2(.2).8, nogrid labsize(medsmall)) ///
	    ytitle("Correlation", size(medsmall)) 
		
****************
*Correlations between ideological self-identifications and factor one*
*for elites and ANES "hyper sophisticates"*

*Note: This graph compares the aforementioned correlations between the CDS* 
*sample and ANES "hyper sophisticates," who are operationalized as possessing* 
*a "very high" level of general political information, being*
*"very much interested" in the campaign and having participated in at least* 
*one political activity during the course of the campaign*

*Note: This graph represents Figure 5 in the paper*
****************

twoway  (scatter ANESest n in 1/6, mcolor(black) msymbol(circle_hollow) /// 
        mfcolor(white) msize(med)) /// 
        (rspike ANESlower ANESupper n in 1/6, vertical lcolor(black) /// 
        lwidth(thin) legend(order(3 "CDS" 1 "ANES Hyper Sophisticates")) /// 
        legend(pos(6)col(1)) /// 
        legend(size(small))) ///
		(scatter CDSest n in 1/6, mcolor(black) msymbol(circle) msize(med)) /// 
		(rspike CDSlower CDSupper n in 1/6, /// 
		vertical lcolor(black) lwidth(thin)), ///
	  	graphregion(fcolor(white)) graphregion(lpattern(blank)) ///
	    plotregion(lcolor(black))graphregion(margin(medsmall)) /// 
	  	aspectratio(.67) ///
	  	xlabel(1 "1980"  2 "1984" 3 "1988"  4 "1992" 5 "2000" 6 "2004", /// 
	  	labsize(medsmall)) ///
	    xtitle(" ", size(medsmall)) /// 
	  	ylabel(.3(.2).9, nogrid labsize(medsmall)) ///
	  	ytitle("Correlation", size(medsmall))
	  	
****************
*Analyses that will be included in the supplemental online appendix*
****************

****************
**Correlations between ideological self-identifications and factor two*
*for elites and the mass public, which is to say the ANES full sample*
****************

twoway  (scatter CDSest2 n in 1/6, mcolor(black) msymbol(circle) /// 
        msize(medium)) /// 
        (rspike CDSlower2 CDSupper2 n in 1/6, vertical lcolor(black) /// 
        lwidth(thin) legend(order(1 "CDS" 3 "ANES")) /// 
        legend(pos(6)col(1)) legend(symysize(*.5)) legend(symxsize(*.5)) /// 
        legend(size(small))) ///
		(scatter ANESest2 n in 1/6, mcolor(black) msymbol(circle) /// 
		mfcolor(white) msize(medium)) (rspike ANESlower2 ANESupper2 n in 1/6, /// 
		vertical lcolor(black) lwidth(thin)), ///
	  	graphregion(fcolor(white)) graphregion(lpattern(blank)) ///
	    plotregion(lcolor(black))graphregion(margin(medsmall)) /// 
	  	aspectratio(.67) ///
	  	xlabel(1 "1980"  2 "1984" 3 "1988"  4 "1992" 5 "2000" 6 "2004", /// 
	  	labsize(medsmall)) ///
	    xtitle(" ", size(medsmall)) ///
	  	ylabel(.3(.2).9, labsize(medsmall) nogrid) ///
	  	ytitle("Correlation", size(medsmall))
	  	
****************
*Correlations between ideological self-identifications and factor two* 
*for the mass public, conditioned on sophistication*

*Note: This graph compares the aforementioned correlations for the ANES*
*stratified sample*

*Here, the mass public is stratified into thirds according* 
*to the sophistication scale, which combines measures of political* 
*knowledge, interest and involvement*

*The three groups of the stratified sample are labeled "least" sophisticated,"*
*"moderately sophisticated" and "most sophisticated," respectively*
****************

twoway  (scatter LOWest2 n in 1/6, mcolor(black) msymbol(smdiamond) /// 
        msize(medium)) /// 
        (rspike LOWlower2 LOWupper2 n in 1/6, vertical lcolor(black) /// 
        lwidth(thin) legend(order(5 "Most Sophisticated"  ///
        3 "Moderately Sophisticated" 1 "Least Sophisticated")) /// 
        legend(pos(6)col(1)) legend(size(small))) ///
		(scatter MIDDLEest2 n in 1/6, mcolor(black) msymbol(circle) /// 
	    mfcolor(white) msize(medium)) ///
		(rspike MIDDLElower2 MIDDLEupper2 n in 1/6, vertical ///
		lcolor(black) lwidth(thin)) ///
		(scatter HIGHest2 n in 1/6, mcolor(black) msymbol(circle) /// 
		msize(medium)) /// 
        (rspike HIGHlower2 HIGHupper2 n in 1/6, vertical lcolor(black) /// 
        lwidth(thin)), graphregion(fcolor(white)) /// 
        graphregion(lpattern(blank)) plotregion(lcolor(black)) ///
        graphregion(margin(medsmall)) aspectratio(.67) ///
     	xlabel(1 "1980"  2 "1984" 3 "1988"  4 "1992" 5 "2000" 6 "2004", /// 
	  	labsize(medsmall)) /// 
		xtitle(" ", size(medsmall)) ///
		ylabel(.2(.2).8, labsize(medsmall) nogrid) ///
	    ytitle("Correlation", size(medsmall))

****************
**Correlations between ideological self-identifications and factor one*
*for each political sophistication strata of the mass public,* 
*conditioned on partisan strength*
****************
		
****************
*Correlations between ideological self-identifications and factor two* 
*for the least politically sophisticated strata of the mass public*
*conditioned on partisan strength*
****************

twoway  (scatter LOWstrong n in 1/6, mcolor(black) msymbol(circle) /// 
        msize(medium)) /// 
        (rspike LOWstronglower LOWstrongupper n in 1/6, ///
        vertical lcolor(black) /// 
        lwidth(thin) legend(order(1 "Strong partisans"  ///
        3 "Non-strong partisans")) /// 
        legend(pos(6)col(1)) legend(symysize(*.5)) legend(symxsize(*.5)) /// 
        legend(size(small))) ///
		(scatter LOWnon n in 1/6, mcolor(black) msymbol(circle_hollow) /// 
        msize(medium)) /// 
        (rspike LOWnonlower LOWnonupper n in 1/6, vertical lcolor(black) /// 
        lwidth(thin)), graphregion(fcolor(white)) ///
        graphregion(lpattern(blank)) /// 
		plotregion(lcolor(black)) graphregion(margin(medsmall)) ///
		aspectratio(.67) ///
     	xlabel(1 "1980"  2 "1984" 3 "1988"  4 "1992" 5 "2000" 6 "2004", /// 
	  	labsize(medsmall)) /// 
		xtitle(" ", size(medsmall)) ///
		ylabel(.2(.2).8, labsize(medsmall) nogrid) ///
	    ytitle("Correlation for Least Sophisticated Strata", size(medsmall))

		
****************
*Correlations between ideological self-identifications and factor two* 
*for the moderately politically sophisticated strata of the mass public,*
*conditioned on partisan strength*
****************

twoway  (scatter MIDDLEstrong n in 1/6, mcolor(black) msymbol(circle) /// 
        msize(medium)) /// 
        (rspike MIDDLEstronglower MIDDLEstrongupper n in 1/6, /// 
        vertical lcolor(black) /// 
        lwidth(thin) legend(order(1 "Strong partisans"  ///
        3 "Non-strong partisans")) /// 
        legend(pos(6)col(1)) legend(symysize(*.5)) legend(symxsize(*.5)) /// 
        legend(size(small))) ///
		(scatter MIDDLEnon n in 1/6, mcolor(black) msymbol(circle_hollow) /// 
        msize(medium)) /// 
        (rspike MIDDLEnonlower MIDDLEnonupper n in 1/6, ///
        vertical lcolor(black) /// 
        lwidth(thin)), graphregion(fcolor(white)) ///
        graphregion(lpattern(blank)) /// 
		plotregion(lcolor(black)) graphregion(margin(medsmall)) ///
		aspectratio(.67) ///
     	xlabel(1 "1980"  2 "1984" 3 "1988"  4 "1992" 5 "2000" 6 "2004", /// 
	  	labsize(medsmall)) /// 
		xtitle(" ", size(medsmall)) ///
		ylabel(.2(.2).8, labsize(medsmall) nogrid) ///
	    ytitle("Correlation for Moderately Sophisticated Strata", ///
	    size(medsmall))

****************
*Correlations between ideological self-identifications and factor two* 
*for the most politically sophisticated strata of the mass public,*
*conditioned on partisan strength*
****************

twoway  (scatter HIGHstrong n in 1/6, mcolor(black) msymbol(circle) /// 
        msize(medium)) /// 
        (rspike HIGHstronglower HIGHstrongupper n in 1/6, ///
        vertical lcolor(black) /// 
        lwidth(thin) legend(order(1 "Strong partisans"  ///
        3 "Non-strong partisans")) /// 
        legend(pos(6)col(1)) legend(symysize(*.5)) legend(symxsize(*.5)) /// 
        legend(size(small))) ///
		(scatter HIGHnon n in 1/6, mcolor(black) msymbol(circle_hollow) /// 
        msize(medium)) /// 
        (rspike HIGHnonlower HIGHnonupper n in 1/6, ///
        vertical lcolor(black) /// 
        lwidth(thin)), graphregion(fcolor(white)) ///
        graphregion(lpattern(blank)) /// 
		plotregion(lcolor(black)) graphregion(margin(medsmall)) ///
		aspectratio(.67) ///
     	xlabel(1 "1980"  2 "1984" 3 "1988"  4 "1992" 5 "2000" 6 "2004", /// 
	  	labsize(medsmall)) /// 
		xtitle(" ", size(medsmall)) ///			
		ylabel(.2(.2).8, labsize(medsmall) nogrid) ///
		ytitle("Correlation for Most Sophisticated Strata", size(medsmall))

****************
*Correlations between the measure of political knowledge used in the analysis,*
*interviewer assessment of repondent's level of political information, and the*
*alternative operationalization suggested by Reviewer 1, respondents' factual*
*knowledge of political questions*
****************		

twoway  (scatter CORRest n in 1/4, mcolor(black) msymbol(circle) /// 
        msize(medium)) /// 
        (rspike CORRlower CORRupper n in 1/4, vertical lcolor(black) /// 
        lwidth(thin) legend(off)), ///
		graphregion(fcolor(white)) graphregion(lpattern(blank)) ///
		plotregion(lcolor(black)) graphregion(margin(medsmall)) ///
		aspectratio(.67) ///
     	xlabel(1 "1988"  2 "1992" 3 "2000" 4 "2004", /// 
	  	labsize(medsmall)) /// 
		xtitle(" ", size(medsmall)) ///
		ylabel(.3(.2).7, labsize(medsmall) nogrid) ///
	    ytitle("Correlation", size(medsmall))

