/*

Replication for: 
  Opportunities to Crash the Party:
  Advocacy Coalitions and the Nonpartisan Primary
  
  Journal of Public Policy
  
  J. Andrew Sinclair, NYU Wagner*
  Ian O'Grady, University of Oxford
  Brock McIntosh, NYU Wagner
  Carrie Nordlund, Brown University
  
  * Corresponding Author
  j.andrew.sinclair@nyu.edu
  
  
  Prepared 6.12.17
  

*/



/*
California and Washington recently replaced traditional partisan elections 
with nonpartisan “top-two” election procedures.  Some reform advocates hoped
that voters would behave in a way to support moderate candidates in the 
primary stage; the limited evidence for this behavior has led some scholars
to conclude that the reform has little chance to change meaningful policy 
outcomes.  Yet we find that the nonpartisan procedure has predictable and 
disparate political consequences: the general elections between two 
candidates of the same party, called copartisan general elections, tend to 
occur in districts absent meaningful cross-party competition.  Furthermore, 
copartisan elections are more likely to occur with open seats, when a new 
legislator will begin building a network of relationships.  The results, 
viewed through the lens of the Advocacy Coalition Framework, suggest that 
opportunities exist for coalitional rearrangement over time.
*/





/* File notes:

To run the replication file, you may wish to install packages:
   burd
   lean1
   estout
   clarify
   plotfds
   seqlogit
   combomarginsplot
These packages have been added to a standard copy of Stata 14 (Windows).

In addition, change your directory path to fit your own computer.

*/




clear all
capture log close
set more off



*cd "*** YOUR FILE PATH HERE ***"
log using "jpp_ctp_replication_log.log", replace
use "jpp_ctp_2017_replication_data_final.dta"



 /* Figure 1: Election Type Given District Extremity */

bys ca: tab copartisan dpvs5bins if elecyear>=2012 & legrace==1 & gwin==1, col
 

graph bar (sum) crosspartisan (sum) copartisan if elecyear>=2012 & legrace==1 & gwin==1 & ca==0, ///
   over(dpvs5bins) stack scheme(burd) ///
   bar(1, fcolor(white) lcolor(black) lwidth(medium)) ///
   bar(2, fcolor(black) lcolor(black) lwidth(medium)) ///
   legend(label(1 "Number Traditional Elections") label(2 "Number Copartisan Elections") rows(2)) ///
   b1title("District Democratic Presidential Vote Share" "(Washington 2012-2016)")	
  graph save "ctp_figure1wa.gph", replace   
graph bar (sum) crosspartisan (sum) copartisan if elecyear>=2012 & legrace==1 & gwin==1 & ca==1, ///
   over(dpvs5bins) stack scheme(burd) ///
   bar(1, fcolor(white) lcolor(black) lwidth(medium)) ///
   bar(2, fcolor(black) lcolor(black) lwidth(medium)) ///
   legend(label(1 "Number Traditional Elections") label(2 "Number Copartisan Elections") rows(2)) ///
   b1title("District Democratic Presidential Vote Share" "(California 2012-2016)")	
  graph save "ctp_figure1ca.gph", replace

graph combine "ctp_figure1wa.gph"  ///
              "ctp_figure1ca.gph", ///
       scheme(lean1) cols(1) iscale(1) ysize(7) xsize(4.125) ///
	   note("WA N=401, CA N=459; Using 2012 Presidential Vote") 
	   graph export "ctp_figure1.pdf",replace
	   graph export "f1tif_ctp_figure1.tif",replace

/* Figure 2: Copartisan Frequency */

twoway ///
   (line waddcounts ddrrcountsyears, sort ///
         lcolor(black) lwidth(medium) lpattern(dash) connect(direct)) ///
   (line waddrrcounts ddrrcountsyears, sort ///
         lcolor(black) lwidth(vthick) lpattern(dash) connect(direct)) ///
   (line caddcounts ddrrcountsyears, sort ///
	     lcolor(gray) lwidth(medium) lpattern(solid) connect(direct)) ///
   (line caddrrcounts ddrrcountsyears, sort ///
	     lcolor(gray) lwidth(vthick) lpattern(solid) connect(direct)), ///
		 ytitle(Number) xtitle(Year) xscale(range(2010 2018)) ///
		 xlabel(2012(2)2016, labels angle(horizontal)) ///
		 legend(position(6) symxsize(*1.5) ///
		 lab(1 "WA: D. vs. D. Copartisan") ///
		 lab(2 "WA: All Copartisan Elections") ///
		 lab(3 "CA: D. vs. D. Copartisan") ///
		 lab(4 "CA: All Copartisan Elections") ///
		   ) scheme(burd) ///
	note("Legislative Elections Only") 
  graph save "ctp_figure2.gph", replace
  graph export "ctp_figure2.pdf", replace
  graph export "f2tif_ctp_figure2.tif",replace




/* Figure 3 */

bys demdist: tab sanders_w crosspartisan if legrace==1 & gwin==1 & elecyear==2014
bys demdist: tab low_trump crosspartisan if legrace==1 & gwin==1 & elecyear==2014

graph bar (sum) crosspartisan (sum) copartisan if elecyear>=2012 & legrace==1 & gwin==1 & demdist==0, ///
   over(sanders_w) percentages stack scheme(burd) ///
   bar(1, fcolor(white) lcolor(black) lwidth(medium)) ///
   bar(2, fcolor(black) lcolor(black) lwidth(medium)) ///
   legend(off) ytitle("")  ///
   b1title("Republican-Leaning Districts")	
  graph save "ctp_f3a.gph", replace   
graph bar (sum) crosspartisan (sum) copartisan if elecyear>=2012 & legrace==1 & gwin==1  & demdist==1, ///
   over(sanders_w) percentages stack scheme(burd) ///
   bar(1, fcolor(white) lcolor(black) lwidth(medium)) ///
   bar(2, fcolor(black) lcolor(black) lwidth(medium)) ///
   legend(off) ytitle("") ///
   b1title("Democratic-Leaning Districts")	
  graph save "ctp_f3b.gph", replace
graph bar (sum) crosspartisan (sum) copartisan if elecyear>=2012 & legrace==1 & gwin==1 & demdist==0, ///
   over(low_trump) percentages stack scheme(burd) ///
   bar(1, fcolor(white) lcolor(black) lwidth(medium)) ///
   bar(2, fcolor(black) lcolor(black) lwidth(medium)) ///
   legend(off) ytitle("") ///
   b1title("Republican-Leaning Districts")	
  graph save "ctp_f3c.gph", replace   
graph bar (sum) crosspartisan (sum) copartisan if elecyear>=2012 & legrace==1 & gwin==1  & demdist==1, ///
   over(low_trump) percentages stack scheme(burd) ///
   bar(1, fcolor(white) lcolor(black) lwidth(medium)) ///
   bar(2, fcolor(black) lcolor(black) lwidth(medium)) ///
   legend(off) ytitle("") ///
   b1title("Democratic-Leaning Districts")	
  graph save "ctp_f3d.gph", replace

graph combine "ctp_f3a.gph" ///
              "ctp_f3b.gph" ///
			  "ctp_f3c.gph" ///
              "ctp_f3d.gph", ///
       scheme(lean1) cols(2) iscale(.8) ysize(5) xsize(7) ///
	   note("Shaded Region: Percent of Copartisan Elections of Total in Category" "Using All Districts 2012-2016") 
	   graph export "ctp_figure3.pdf",replace
       graph export "f3tif_ctp_figure3.tif",replace
	   
/* Table 1 */

* Models
logit lcop c.dpvs12##c.dpvs12 ctst_incumb lh ca yr14 yr16, r
  estimates store simplemodel
   estat classification
   estat classification, cut(.25)
   
 logit lcop c.dpvs12##c.dpvs12 i.demdist##i.sanders_w i.demdist##i.low_trump i.demdist##c.pctwhite i.demdist##c.agpct i.demdist##c.medinc ctst_incumb lh ca yr14 yr16, r 
   estimates store mainmodel
   estat classification
   estat classification, cut(.25)


estout simplemodel mainmodel using "ctp_table1.txt", ///
  cells(b(star fmt(4)) se(par fmt(3))) ///
  legend label varlabels (_cons Constant) ///
   stats(N, fmt(0) label(N)) replace
  */
  

/* Figure 4: Estimates for CA AD5 */
   * Vary dpvs, vary incumbent status. (2 separate lines). */
 list dpvs12 demdist sanders_w low_trump pctwhite agpct medinc ctst_incumb if level==1 & ca==1 & gwin==1 & elecyear==2012 & distnum==5, nolabel
 logit lcop c.dpvs12##c.dpvs12 i.demdist##i.sanders_w i.demdist##i.low_trump i.demdist##c.pctwhite i.demdist##c.agpct i.demdist##c.medinc ctst_incumb lh ca yr14 yr16, r 
   margins, at(dpvs12=(28(5)53) demdist=0 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=0 lh=1 ca=1 yr14=0 yr16=0) saving(f4marg1, replace)
   margins, at(dpvs12=(53(5)93) demdist=1 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=0 lh=1 ca=1 yr14=0 yr16=0) saving(f4marg2, replace)
	combomarginsplot f4marg1 f4marg2, legend(col(2) pos(6)) labels("Rep. District" "Dem. District") xlabel(0(10)100) xline(42) ylabel(0(.5)1) ytitle("Pr(Copartisan|2012)") title("") ///
	      scheme(lean1) recast(line) recastci(rarea) plot1opts(lpattern(longdash) lwidth(medium)) plot2opts( lpattern(solid) lwidth(thick)) ci1opts(lcolor(black) lpattern(solid) lwidth(medium) fcolor(gs12)) ci2opts(lcolor(black) lpattern(solid) lwidth(medium) fcolor(gs12)) 
        graph save "ctp_figure4_AD5in2012_varydpvs.gph", replace
        graph export "ctp_figure4_AD5in2012_varydpvs.pdf", replace

 logit lcop c.dpvs12##c.dpvs12 i.demdist##i.sanders_w i.demdist##i.low_trump i.demdist##c.pctwhite i.demdist##c.agpct i.demdist##c.medinc ctst_incumb lh ca yr14 yr16, r 
   margins, at(dpvs12=(28(5)53) demdist=0 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=1 lh=1 ca=1 yr14=1 yr16=0) saving(f4marg3, replace)
   margins, at(dpvs12=(53(5)93) demdist=1 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=1 lh=1 ca=1 yr14=1 yr16=0) saving(f4marg4, replace)
	combomarginsplot f4marg3 f4marg4, legend(col(2) pos(6)) labels("Rep. District" "Dem. District") xlabel(0(10)100) xline(42) ylabel(0(.5)1) ytitle("Pr(Copartisan|2014)") title("") ///
	      scheme(lean1) recast(line) recastci(rarea) plot1opts(lpattern(longdash) lwidth(medium)) plot2opts( lpattern(solid) lwidth(thick)) ci1opts(lcolor(black) lpattern(solid) lwidth(medium) fcolor(gs12)) ci2opts(lcolor(black) lpattern(solid) lwidth(medium) fcolor(gs12)) 
        graph save "ctp_figure4_AD5in2014_varydpvs.gph", replace
        graph export "ctp_figure4_AD5in2014_varydpvs.pdf", replace

   graph combine "ctp_figure4_AD5in2012_varydpvs.gph" "ctp_figure4_AD5in2014_varydpvs.gph", ///
       scheme(lean1) cols(1) iscale(1) ysize(6) xsize(4.125) ///
	   note("Vertical lines represent true CA AD5 value." "Estimates for ranges in sample only.") 
	   graph export "ctp_figure4_combine.pdf",replace
	   graph export "f4tif_ctp_figure4.tif",replace

/* Table 2 */
/* Table 2: Predicted Probabilities for Selected Districts
    And actual outcomes   */
 logit lcop c.dpvs12##c.dpvs12 i.demdist##i.sanders_w i.demdist##i.low_trump i.demdist##c.pctwhite i.demdist##c.agpct i.demdist##c.medinc ctst_incumb lh ca yr14 yr16, r
	predict mainpredict, pr
	sort ca office distnum pos
   list ca distnum office  pos elecyear name copartisan mainpredict dpvs12 pctwhite agpct medinc ctst_incumb ///
      if (ca==1 & level==1 & distnum == 5 & elecyear==2012 & gwin==1) | ///
	     (ca==1 & level==1 & distnum == 5 & elecyear==2014 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 50 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 47 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 8 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 39 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==3 & distnum == 4 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==1 & distnum == 13 & pos==1 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==1 & distnum == 14 & pos==1 & elecyear==2014 & gwin==1)	  
	  
   outsheet ca distnum office  pos elecyear name copartisan mainpredict dpvs12 pctwhite agpct medinc ctst_incumb using "ctp_table2.txt" ///
      if (ca==1 & level==1 & distnum == 5 & elecyear==2012 & gwin==1) | ///
	     (ca==1 & level==1 & distnum == 5 & elecyear==2014 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 50 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 47 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 8 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 39 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==3 & distnum == 4 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==1 & distnum == 13 & pos==1 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==1 & distnum == 14 & pos==1 & elecyear==2014 & gwin==1), replace	

  
     *** Alternative Information ***
	 
	    list ca distnum office  pos elecyear name copartisan mainpredict dpvs12 low_trump sanders_w ///
      if (ca==1 & level==1 & distnum == 5 & elecyear==2012 & gwin==1) | ///
	     (ca==1 & level==1 & distnum == 5 & elecyear==2014 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 50 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 47 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 8 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 39 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==3 & distnum == 4 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==1 & distnum == 13 & pos==1 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==1 & distnum == 14 & pos==1 & elecyear==2014 & gwin==1)	  
	  
  
     * and:
	 
	 kdensity mainpredict if legrace==1 & gwin==1, xtitle(Pr (Copartisan) in Main Model) scheme(burd)
	 
  
 /* Figure 5, Illustration */

tab final_configtype copartisan if legrace==1 & gwin==1	   

list ca elecyear distnum office pos name party dpvs12 demdist if legrace==1 & gwin==1 & final_config == 1 & copartisan==1   
 
 /* Table 3 and some text */
 seqlogit final_configtype c.dpvs12##c.dpvs12 i.demdist##i.sanders_w i.demdist##i.low_trump i.demdist##c.pctwhite i.demdist##c.agpct i.demdist##c.medinc ctst_incumb lh ca yr14 yr16, tree(1 : 2 3 4, 2: 3 4, 3:4) r
  est store modelseqlogit 
  
 estout modelseqlogit using "ctp_table3.txt", ///
  cells(b(star fmt(4)) se(par fmt(2))) ///
  legend label varlabels (_cons Constant) ///
  stats(N, fmt(0) label(N)) replace
  
   predict mseqlogit_pr1, pr outcome(1)
   predict mseqlogit_pr2, pr outcome(2)
   predict mseqlogit_pr3, pr outcome(3)
   predict mseqlogit_pr4, pr outcome(4)

   
 list  mseqlogit_pr1 mseqlogit_pr2 mseqlogit_pr3 mseqlogit_pr4 if ca==1 & level==1 & distnum == 5 & elecyear==2012 & gwin==1
 seqlogitdecomp dpvs12, table at(dpvs12 42 demdist 0 sanders_w 1 low_trump 0 pctwhite 66 agpct 7.6 medinc 51.716 ctst_incumb 0 lh 1 ca 1 yr14 0 yr16 0)  

 tab ctst_defincumb copartisan if gwin==1 & legrace==1 & ctst_incumb==1, row
 
 /* Figure 6 */
 
    tab lev1clearfail
    logit lev1clearfail c.dpvs12##c.dpvs12 i.demdist##i.sanders_w i.demdist##i.low_trump i.demdist##c.pctwhite i.demdist##c.agpct i.demdist##c.medinc ctst_incumb lh ca yr14 yr16, r
     estat classification
   predict lev1clearfail_pr1, pr
    list  lev1clearfail_pr1 if ca==1 & level==1 & distnum == 5 & elecyear==2012 & gwin==1
 
   margins, at(dpvs12=(28(5)53) demdist=0 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=0 lh=1 ca=1 yr14=0 yr16=0) saving(f6marg1, replace)
   margins, at(dpvs12=(53(5)93) demdist=1 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=0 lh=1 ca=1 yr14=0 yr16=0) saving(f6marg2, replace)
   
   *incumb:
   margins, at(dpvs12=(28(5)53) demdist=0 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=1 lh=1 ca=1 yr14=1 yr16=0) saving(f6marg1i, replace)
   margins, at(dpvs12=(53(5)93) demdist=1 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=1 lh=1 ca=1 yr14=1 yr16=0) saving(f6marg2i, replace)
   
   tab lev2minorityenter
    logit lev2minorityenter c.dpvs12##c.dpvs12 i.demdist##i.sanders_w i.demdist##i.low_trump i.demdist##c.pctwhite i.demdist##c.agpct i.demdist##c.medinc ctst_incumb lh ca yr14 yr16, r
     estat classification
   margins, at(dpvs12=(28(5)53) demdist=0 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=0 lh=1 ca=1 yr14=0 yr16=0) saving(f6marg3, replace)
   margins, at(dpvs12=(53(5)93) demdist=1 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=0 lh=1 ca=1 yr14=0 yr16=0) saving(f6marg4, replace)
     *incumb:
   margins, at(dpvs12=(28(5)53) demdist=0 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=1 lh=1 ca=1 yr14=1 yr16=0) saving(f6marg3i, replace)
   margins, at(dpvs12=(53(5)93) demdist=1 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=1 lh=1 ca=1 yr14=1 yr16=0) saving(f6marg4i, replace) 
 
    * change low_trump to high trump for a dem_dist
    margins, at(dpvs12=40 demdist=1 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=0 lh=1 ca=0 yr14=1 yr16=0) saving(f6marg4i, replace) 
    margins, at(dpvs12=40 demdist=1 sanders_w=1 low_trump=1 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=0 lh=1 ca=0 yr14=1 yr16=0) saving(f6marg4i, replace) 
       tab lev2minorityenter demdist if gwin==1 & legrace==1, col
 
   tab lev3copartisansadvance
    logit lev3copartisansadvance c.dpvs12##c.dpvs12 i.demdist##i.sanders_w i.demdist##i.low_trump i.demdist##c.pctwhite i.demdist##c.agpct i.demdist##c.medinc ctst_incumb lh ca yr14 yr16, r
     estat classification
   margins, at(dpvs12=(28(5)53) demdist=0 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=0 lh=1 ca=1 yr14=0 yr16=0) saving(f6marg5, replace)
   margins, at(dpvs12=(53(5)93) demdist=1 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=0 lh=1 ca=1 yr14=0 yr16=0) saving(f6marg6, replace)
 
    *incumb:
   margins, at(dpvs12=(28(5)53) demdist=0 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=1 lh=1 ca=1 yr14=1 yr16=0) saving(f6marg5i, replace)
   margins, at(dpvs12=(53(5)93) demdist=1 sanders_w=1 low_trump=0 pctwhite=66 agpct=7.6 medinc=51.716 ctst_incumb=1 lh=1 ca=1 yr14=1 yr16=0) saving(f6marg6i, replace)

   * first plot
   combomarginsplot f6marg1 f6marg2 f6marg3 f6marg4 f6marg5 f6marg6, ///
	      legend(col(2) pos(6)) labels("Rep. (Maj. Fail to Clear)" "Dem. (Maj. Fail to Clear)" ///
		                               "Rep. (Min. Enter)"         "Dem. (Min. Enter)" ///
									   "Rep. (Contested Copart.)"  "Dem. (Contested Copart.)" ///
								 ) ///
		  xlabel(0(10)100) xline(42) ylabel(0(.5)1) ytitle("Pr(Outcome | Node)" "2012 - Open") title("") ///
	      scheme(lean1) ///
		  recast(line) noci ///
		  plot1opts(lpattern(shortdash) lwidth(medium)) plot2opts( lpattern(shortdash) lwidth(medthick) lcolor(gray)) ///
		  plot3opts(lpattern(longdash) lwidth(medium)) plot4opts( lpattern(longdash) lwidth(medthick) lcolor(gray)) ///
		  plot5opts(lpattern(solid) lwidth(thick)) plot6opts( lpattern(solid) lwidth(vthick) lcolor(gray)) 		  		  
          graph save "ctp_figure6_AD5in2012_levels_small.gph", replace	 

   * second plot
   combomarginsplot f6marg1i f6marg2i f6marg3i f6marg4i f6marg5i f6marg6i, ///
	      legend(col(2) pos(6)) labels("Rep. (Maj. Fail to Clear)" "Dem. (Maj. Fail to Clear)" ///
		                               "Rep. (Min. Enter)"         "Dem. (Min. Enter)" ///
									   "Rep. (Contested Copart.)"  "Dem. (Contested Copart.)" ///
								 ) ///
		  xlabel(0(10)100) xline(42) ylabel(0(.5)1) ytitle("Pr(Outcome | Node)" "2014 - Incumbent") title("") ///
	      scheme(lean1) ///
		  recast(line) noci ///
		  plot1opts(lpattern(shortdash) lwidth(medium)) plot2opts( lpattern(shortdash) lwidth(medthick) lcolor(gray)) ///
		  plot3opts(lpattern(longdash) lwidth(medium)) plot4opts( lpattern(longdash) lwidth(medthick) lcolor(gray)) ///
		  plot5opts(lpattern(solid) lwidth(thick)) plot6opts( lpattern(solid) lwidth(vthick) lcolor(gray)) 		  		  
          graph save "ctp_figure6_AD5in2012_levels_small_i.gph", replace	 

	   graph combine "ctp_figure6_AD5in2012_levels_small.gph" "ctp_figure6_AD5in2012_levels_small_i.gph", ///
       scheme(lean1) cols(1) iscale(.7) ysize(6) xsize(4.125) ///
	   note("Vertical lines represent true CA AD5 value." "Estimates for ranges in sample only.") 
	   graph export "ctp_figure6_combine.pdf",replace	
	   graph export "f6tif_ctp_figure6.tif",replace


	/* Table 4 */
		sort ca office distnum pos
   list ca distnum office  pos elecyear name copartisan mseqlogit_pr1 mseqlogit_pr2 mseqlogit_pr3 mseqlogit_pr4 dpvs12 pctwhite agpct medinc ctst_incumb ///
      if (ca==1 & level==1 & distnum == 5 & elecyear==2012 & gwin==1) | ///
	     (ca==1 & level==1 & distnum == 5 & elecyear==2014 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 50 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 47 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 8 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 39 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==3 & distnum == 4 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==1 & distnum == 13 & pos==1 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==1 & distnum == 14 & pos==1 & elecyear==2014 & gwin==1)	  
	  
   outsheet ca distnum office  pos elecyear name copartisan mseqlogit_pr1 mseqlogit_pr2 mseqlogit_pr3 mseqlogit_pr4 dpvs12 pctwhite agpct medinc ctst_incumb using "ctp_table4.txt" ///
      if (ca==1 & level==1 & distnum == 5 & elecyear==2012 & gwin==1) | ///
	     (ca==1 & level==1 & distnum == 5 & elecyear==2014 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 50 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 47 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 8 & elecyear==2012 & gwin==1) | ///
		 (ca==1 & level==1 & distnum == 39 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==3 & distnum == 4 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==1 & distnum == 13 & pos==1 & elecyear==2014 & gwin==1) | ///
		 (ca==0 & level==1 & distnum == 14 & pos==1 & elecyear==2014 & gwin==1), replace	

  
 


 
 /* Figure 7 */
   /* Note: originally this was in an appendix
            but was added to the final version of the text. */
graph hbar (sum) majority_w (sum) majority_l if legrace==1 & gwin==1, over(final_configtype) stack scheme(burd) bar(1, fcolor(white) lcolor(black) lwidth(medium)) bar(2, fcolor(black) lcolor(black) lwidth(medium)) legend(label(1 "Majority Party Wins") label(2 "Other Party Wins"))
    graph export "ctp_figure7.pdf",replace
   graph export "f7tif_ctp_figure7.tif",replace

tab final_config majority_w if legrace==1 & gwin==1, row






/* 
A few notes about the data.  The underlying dataset here was collected using 
the official election returns in California and Washington.  The 2016 California
returns were not available for district-by-district analysis of Trump/Sanders
vote.  We obtained this for California by using the initial county-level results
and then adding these up by district.  In most cases this information is 
available online; if not, it was available by directly contacting the county
election officials (this was all done in January 2017).  That data may differ
slightly from the final results certified by the secretary of state in the
supplement to the statement of vote (although not likely by much).  Future 
research should use the supplement to the SOV as the most authoritative source. 

One other complication: Washington does not count write-in ballots in the same
way California does it.  Washington will count how many write-in ballots there
were but will stop counting for whom they were for once it becomes impossible
for the election result to change.  This makes "entry" a bit less obvious in 
Washington than in California; we only know about w/i candidates that actually
make it in Washington.

If you wish to count district winners, set "gwin==1" and "level<=3".  There 
are a handful of observations in the data that contain information for Fig. 2
but otherwise are not useful for this analysis.  

*/



log close
exit
