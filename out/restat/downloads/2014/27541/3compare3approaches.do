 *** OUTLINE ***
 *** Fujin Zhou and Remco Oostendorp
 *** Vrije Universiteit Amsterdam
 *** March 2013
 
 *** this dofile does the following:
 *** 1) PRODUCE TABLE 1: underreporting by direct approach across cities/sectors/firm size...
 *** 2) PRODUCE TABLE 2: underreporting by indirect approach across cities\sectors\firm size...
 *** 3) PRODUCE TABLE 4: calculate average(firm level)\aggregate underreporting from 3 approaches
 *** 4) PRODUCE TABLE 5: check underreporting by quantiles for the 3 approaches
 *** 5) run descritive regressions of underreporting from MIMIC and direct approaches ///
 ***    on city and sector dummies

  clear all
  set more off
  global path D:\Dropbox\FIRSTPAPERDRAFTSANDPROGRAMS\CleanFiles4SubmissionUpload\Data
  global path2 D:\Dropbox\FIRSTPAPERDRAFTSANDPROGRAMS\CleanFiles4SubmissionUpload\TABLES
  global path3 D:\Dropbox\FIRSTPAPERDRAFTSANDPROGRAMS\CleanFiles4SubmissionUpload\LOGS
  capture log close
  log using $path3\logcompare3approaches.log,replace
  use "$path\3underreport.dta",clear

  * if compared with sales reported to tax office ==>
  * underrp_d : firm level underreporting by direct approach 
  * underrp_n : firm level underreporting by indirect approach
  * underrp_m : firm level underreporting by MIMIC approach
  * underrp_ms: firm level underreporting in survey, by MIMIC approach
 
  *** ============================
  *** PRODUCE TABLE 1 IN THE PAPER
  *** ============================
  *** matrix mTable1
  egen cnt=rmiss(underrp_d w city_no fsize2003 sector0)
  tabstat underrp_d [aw=w] if cnt==0,stats(n mean sd min max) by(city_no) nototal save 
  matrix mcity=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)'
  tabstat underrp_d [aw=w] if cnt==0,stats(n mean sd min max) by(sector0) nototal save 
  matrix msect=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)' 
  tabstat underrp_d [aw=w] if cnt==0,stats(n mean sd min max) by(fsize2003) save 
  matrix msize=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(StatTotal)'
  matrix mTable1=mcity\msect\msize
  matrix drop mcity msect msize
  matrix list mTable1
  
  
  
  *logout, save("$path2\table1") word replace
  xml_tab mTable1,save("$path2\table") sheet(table1) /// 
  title(Table 1 Mean % of underreporting in sales by the direct approach) ///
  rnames(Ulaanbaatar Darkan Erdenet Hovd Manufacture Construction Tourism ///
  Service Small(<10) Medium(10-99) Large(>=100) Total) ///
  notes(Note: top/bottom 5% are trimmed off; ///
  figures are weighted by sampling weights; * denotes significance at 10% ///
  Source: WB PICS Mongolia (2004)) font("Times New Roman" 12) updateopts replace
  
  
  
 
  *** perform multiple group mean test ***
  
  foreach var of varlist city_no sector0 {
     tabstat underrp_d if cnt==0 [aw=w], by(`var') stat(n mean sd) save
	 matrix rall=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)'
	 
	 forvalue i=1/4 {
	   local n`i'=rall[`i',1]
	   local m`i'=rall[`i',2]
	   local sd`i'=rall[`i',3] 
	 }
	 ttesti `n1' `m1' `sd1' `n2' `m2' `sd2',unequal
	 ttesti `n1' `m1' `sd1' `n3' `m3' `sd3',unequal
	 ttesti `n1' `m1' `sd1' `n4' `m4' `sd4',unequal 
  }
	
foreach var of varlist fsize2003 {
     tabstat underrp_d if cnt==0 [aw=w], by(`var') stat(n mean sd) save
	 matrix rall=r(Stat1)'\r(Stat2)'\r(Stat3)'
	 
	 forvalue i=1/3 {
	   local n`i'=rall[`i',1]
	   local m`i'=rall[`i',2]
	   local sd`i'=rall[`i',3] 
	 }
	 ttesti `n1' `m1' `sd1' `n2' `m2' `sd2',unequal
	 ttesti `n1' `m1' `sd1' `n3' `m3' `sd3',unequal
	  
  }	
  drop cnt
   
  *** ============================
  *** PRODUCE TABLE 2 IN THE PAPER
  *** ============================
  *** matrix mTable2
  egen cnt=rmiss(underrp_n w city_no fsize2003 sector0)
  count if cnt==0&underrp_n<0
  tabstat underrp_n [aw=w] if cnt==0,stats(n mean sd min max) by(city_no) nototal save 
  matrix mcity=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)'
  tabstat underrp_n [aw=w] if cnt==0,stats(n mean sd min max) by(sector0) nototal save 
  matrix msect=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)' 
  tabstat underrp_n [aw=w] if cnt==0,stats(n mean sd min max) by(fsize2003) save 
  matrix msize=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(StatTotal)'
  matrix mTable2=mcity\msect\msize
  matrix drop mcity msect msize
  matrix list mTable2
 
  
  *logout, save("$path2\table2") word replace
 
  xml_tab mTable2,save("$path2\table") sheet(table2) ///
  title(Table 2 Average % of Sales Underreported by the Indirect Approach) ///
  rnames(Ulaanbaatar Darkan Erdenet Hovd Manufacture Construction Tourism ///
  Service Small(<10) Medium(10-99) Large(>=100) Total) ///
  notes(Note: top/bottom 5% are trimmed off; figures are weighted by sampling weights; *, ** ///
  denote significance at 10% and 5% respectively; ///
  Source: WB PICS Mongolia (2004) & Tax Office Data 2003) ///
  font("Times New Roman" 12) append
  
  *** perform multiple group mean test ***
  
 foreach var of varlist city_no sector0 {
     tabstat underrp_n if cnt==0 [aw=w], by(`var') stat(n mean sd) save
	 matrix rall=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)'
	 
	 forvalue i=1/4 {
	   local n`i'=rall[`i',1]
	   local m`i'=rall[`i',2]
	   local sd`i'=rall[`i',3] 
	 }
	 ttesti `n1' `m1' `sd1' `n2' `m2' `sd2',unequal
	 ttesti `n1' `m1' `sd1' `n3' `m3' `sd3',unequal
	 ttesti `n1' `m1' `sd1' `n4' `m4' `sd4',unequal 
  }
	
foreach var of varlist fsize2003 {
     tabstat underrp_n if cnt==0 [aw=w], by(`var') stat(n mean sd) save
	 matrix rall=r(Stat1)'\r(Stat2)'\r(Stat3)'
	 
	 forvalue i=1/4 {
	   local n`i'=rall[`i',1]
	   local m`i'=rall[`i',2]
	   local sd`i'=rall[`i',3] 
	 }
	 ttesti `n1' `m1' `sd1' `n2' `m2' `sd2',unequal
	 ttesti `n1' `m1' `sd1' `n3' `m3' `sd3',unequal
	  
  }	
  drop cnt
 
  replace underrp_d = underrp_d/100
  replace underrp_n = underrp_n/100
  g underrp_ms = 1 - sale_s/y_p

  egen rmiss=rowmiss(underrp_d underrp_n underrp_m)
  sum underrp_* [aw=w] if rmiss==0
 
  count if rmiss==0&underrp_d==0
  
  *** produce TABLE 4 in the paper ***
  *** Underreport to tax office and in the survey ///
  *** across cities,sectors,size,corruption and credit constraint
  *** ===========================================================
  *** with sampling weights
 
  * to tax office
  tabstat underrp_m [aw=w], by(city_no) stats(n mean sd) nototal save
  *return list
  matrix mcity=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)'
  tabstat underrp_m [aw=w], by(sector0) stats(n mean sd) nototal save
  matrix msect=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)'
  tabstat underrp_m [aw=w], by(fsize2003) stats(n mean sd) nototal save
  matrix msize=r(Stat1)'\r(Stat2)'\r(Stat3)'
  tabstat underrp_m [aw=w], by(bribe) stats(n mean sd) nototal save
  matrix mbrib=r(Stat1)'\r(Stat2)'
  tabstat underrp_m [aw=w], by(credit) stats(n mean sd) save
  matrix mcred=r(Stat1)'\r(Stat2)'\r(StatTotal)'
 
  matrix munderrp_tax=mcity\msect\msize\mbrib\mcred
  matrix list munderrp_tax
  matrix drop mcity msect msize mbrib mcred
  
   *** perform multiple group mean test ***
 foreach var of varlist city_no sector0 {
     tabstat underrp_m [aw=w], by(`var') stat(n mean sd) save
	 matrix rall=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)'
	 
	 forvalue i=1/4 {
	   local n`i'=rall[`i',1]
	   local m`i'=rall[`i',2]
	   local sd`i'=rall[`i',3] 
	 }
	 ttesti `n1' `m1' `sd1' `n2' `m2' `sd2',unequal
	 ttesti `n1' `m1' `sd1' `n3' `m3' `sd3',unequal
	 ttesti `n1' `m1' `sd1' `n4' `m4' `sd4',unequal 
  }
	
foreach var of varlist fsize2003 {
     tabstat underrp_m [aw=w], by(`var') stat(n mean sd) save
	 matrix rall=r(Stat1)'\r(Stat2)'\r(Stat3)'
	 
	 forvalue i=1/3 {
	   local n`i'=rall[`i',1]
	   local m`i'=rall[`i',2]
	   local sd`i'=rall[`i',3] 
	 }
	 ttesti `n1' `m1' `sd1' `n2' `m2' `sd2',unequal
	 ttesti `n1' `m1' `sd1' `n3' `m3' `sd3',unequal
	  
  }	
  
  foreach var of varlist credit bribe{
     tabstat underrp_m [aw=w], by(`var') stat(n mean sd) save
	 matrix rall=r(Stat1)'\r(Stat2)'
	 
	 forvalue i=1/2 {
	   local n`i'=rall[`i',1]
	   local m`i'=rall[`i',2]
	   local sd`i'=rall[`i',3] 
	 }
	 ttesti `n1' `m1' `sd1' `n2' `m2' `sd2',unequal
  }	
  
 * in the survey
  tabstat underrp_ms [aw=w], by(city_no) stats(n mean sd) nototal save
 *return list
  matrix mcity=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)'
  tabstat underrp_ms [aw=w], by(sector0) stats(n mean sd) nototal save
  matrix msect=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)'
  tabstat underrp_ms [aw=w], by(fsize2003) stats(n mean sd) nototal save
  matrix msize=r(Stat1)'\r(Stat2)'\r(Stat3)'
  tabstat underrp_ms [aw=w], by(bribe) stats(n mean sd) nototal save
  matrix mbrib=r(Stat1)'\r(Stat2)'
  tabstat underrp_ms [aw=w], by(credit) stats(n mean sd) save
  matrix mcred=r(Stat1)'\r(Stat2)'\r(StatTotal)'
 
  matrix munderrp_svy=mcity\msect\msize\mbrib\mcred
  matrix list munderrp_svy
  matrix drop mcity msect msize mbrib mcred 
 
   *** perform multiple group mean test ***
foreach var of varlist city_no sector0 {
     tabstat underrp_ms [aw=w], by(`var') stat(n mean sd) save
	 matrix rall=r(Stat1)'\r(Stat2)'\r(Stat3)'\r(Stat4)'
	 
	 forvalue i=1/4 {
	   local n`i'=rall[`i',1]
	   local m`i'=rall[`i',2]
	   local sd`i'=rall[`i',3] 
	 }
	 ttesti `n1' `m1' `sd1' `n2' `m2' `sd2',unequal
	 ttesti `n1' `m1' `sd1' `n3' `m3' `sd3',unequal
	 ttesti `n1' `m1' `sd1' `n4' `m4' `sd4',unequal 
  }
	
foreach var of varlist fsize2003 {
     tabstat underrp_ms [aw=w], by(`var') stat(n mean sd) save
	 matrix rall=r(Stat1)'\r(Stat2)'\r(Stat3)'
	 
	 forvalue i=1/3 {
	   local n`i'=rall[`i',1]
	   local m`i'=rall[`i',2]
	   local sd`i'=rall[`i',3] 
	 }
	 ttesti `n1' `m1' `sd1' `n2' `m2' `sd2',unequal
	 ttesti `n1' `m1' `sd1' `n3' `m3' `sd3',unequal  
  }	
  
  foreach var of varlist credit bribe{
     tabstat underrp_ms [aw=w], by(`var') stat(n mean sd) save
	 matrix rall=r(Stat1)'\r(Stat2)'
	 
	 forvalue i=1/2 {
	   local n`i'=rall[`i',1]
	   local m`i'=rall[`i',2]
	   local sd`i'=rall[`i',3] 
	 }
	 ttesti `n1' `m1' `sd1' `n2' `m2' `sd2',unequal
  }	
  
  *** ================
  ***  PRODUCE TABLE 4
  *** ================
  *** matrix mTable4 provides the figures in Table 4 in the paper
  matrix mTable4=munderrp_tax,munderrp_svy
  matrix list mTable4
  *logout, save("$path2\table4") word replace
  matrix drop munderrp_tax munderrp_svy
  
  xml_tab mTable4,save("$path2\table") sheet(table4) ///
  title(Table 4 Mean % of Total Sales Underreported by MIMIC Approach) ///
  rnames(Ulaanbaatar Darkan Erdenet Hovd Manufacture Construction Tourism ///
  Service Small(<10) Medium(10-99) Large(>=100) nobribe bribe notconstraned constrained Total) ///
  notes(Note: figures are weighted by sampling weights; ///
  denote significance of two-sample t-tests for equal means with different observations and variances at 10%\5% level by *\** respectively; ///
  Source: calculated using MIMIC estimation results of Table 3 (column (4))) ///
  font("Times New Roman" 12) append
  
  *** ============================================================= 
  *** COMPARE THE UNDERREPORTING BY 3 APPROACHES ON THE SAME SAMPLE
  *** Produce Table 5 in the paper
  *** =============================================================
  *y_p: predicted sales by MIMIC model conditional on indicators and X
  *y_d: sales inferred by underrp_d and sales reported to tax office

  g y_d=sale_t/(1-underrp_d)
 
  * with sampling weight, rmiss=0 ==> common sample
  tabstat sale_t sale_s y_d y_p [aw=w] if rmiss==0,stats(sum) save
  matrix magg=r(StatTotal)
 
  *** CALCULATE AGGREGATE UNDERREPORTING FROM 3 APPROACHES ***
  * with suffix _m ==> MIMIC approach
  * with suffix _n ==> indirect approach
  * with suffix _d ==> direct approach
 
  scalar aggundrp_m=1-magg[1,1]/magg[1,4]
  scalar aggundrp_n=1-magg[1,1]/magg[1,2]
  scalar aggundrp_d=1-magg[1,1]/magg[1,3]
  scalar list aggundrp_m aggundrp_n aggundrp_d
 
  * matrix aggundrp ==> the last column of TABLE 5 in the paper
  matrix aggundrp=aggundrp_m\aggundrp_n\aggundrp_d
  
  
  *** Below Produce Columns 2-6 of Table 5 in the paper
  *** ======================================================
  *** Check distributions of underreporting across quantiles 
  *** defined by survey sales for the 3 approaches
  *** ======================================================
  
  * first define quantiles
  tabstat lsale_s if rmiss==0,stats(p25 p50 p75) save
  matrix mqn=r(StatTotal)
  
  g quartile=1 if lsale_s<=mqn[1,1]&rmiss==0
  replace quartile=2 if lsale_s>mqn[1,1]&lsale_s<=mqn[2,1]&rmiss==0
  replace quartile=3 if lsale_s>mqn[2,1]&lsale_s<=mqn[3,1]&rmiss==0
  replace quartile=4 if lsale_s>mqn[3,1]&lsale_s~=.&rmiss==0
  
  * second summarize firm-level mean of underreporting by quartiles defined above
  tabstat underrp_d [aw = w] if rmiss==0, stat(mean) by(quartile) save
  matrix undrpbyqrt_d=r(Stat1),r(Stat2),r(Stat3),r(Stat4),r(StatTotal)
  
  tabstat underrp_n [aw = w] if rmiss==0, stat(mean) by(quartile) save
  matrix undrpbyqrt_n=r(Stat1),r(Stat2),r(Stat3),r(Stat4),r(StatTotal)
  
  tabstat underrp_m [aw = w] if rmiss==0, stat(mean) by(quartile) save
  matrix undrpbyqrt_m=r(Stat1),r(Stat2),r(Stat3),r(Stat4),r(StatTotal)
 
  tabstat underrp_m [aw = w] if rmiss==0, stat(n) by(quartile) save
  matrix mcount=r(Stat1),r(Stat2),r(Stat3),r(Stat4),r(StatTotal)
  
  
  
  * third count the number of firms underreport in each quartile for the 3 approaches
  g index1=(underrp_d>0&underrp_d~=.)
  g index2=(lsale_s>lsale_t&lsale_s~=.)
  g index3=(y_p>lsale_t&y_p~=.)
  
  * direct approach
  tabstat index1 if rmiss==0, stat(sum) by(quartile) save
  matrix cn1 = r(Stat1)\r(Stat2)\r(Stat3)\r(Stat4)\r(StatTotal)
  
  * indirect approach
  tabstat index2 if rmiss==0, stat(sum) by(quartile) save
  matrix cn2 = r(Stat1)\r(Stat2)\r(Stat3)\r(Stat4)\r(StatTotal)
  
  * MIMIC approach
  tabstat index3 if rmiss==0, stat(sum) by(quartile) save
  matrix cn3 = r(Stat1)\r(Stat2)\r(Stat3)\r(Stat4)\r(StatTotal)
  
  matrix cnall=cn1'\cn2'\cn3'\mcount
  *matrix list cnall
  
  * create share of underreporting firms in each quartile
  matrix mpct=J(4,5,0)
  forvalues i = 1/4 {
	   forvalues j = 1/5 {
		  matrix mpct[`i',`j']= 100*cnall[`i',`j']/cnall[4,`j']
	   }
	}
  matrix list mpct
  matrix drop cn1 cn2 cn3 cnall
  drop index*
  
  *** ===============
  *** PRODUCE TABLE 5 
  *** ===============
  *** NOW produce columns 2-6 of TABLE 5 in the paper (mTable5)
  *** matrix aggundrp is column 7 of TABLE 5!
  
  matrix mTable5=undrpbyqrt_d\mpct[1,1..5]\undrpbyqrt_n\mpct[2,1..5] ///
                 \undrpbyqrt_m\mpct[3,1..5]\mcount
  matrix list mTable5
  *logout, save("$path2\table5") word replace
  
  xml_tab mTable5,save("$path2\table") sheet(table5) ///
  title(Table 5 Comparison of Three Approaches  to Measuring Underreporting ///
  (% of firms underreporting in each quantile in brackets)) ///
  rnames(Direct Indirect MIMIC N) ///
  notes(Note: quantiles are defined for sales reported in the survey; ///
  all figures are weighted by sampling weights) ///
  font("Times New Roman" 12) append
  
  matrix list aggundrp
  * ==================================================
  * check for any sample selection bias for TABLE 5!!!
  * ==================================================
  * for footnote 39 in the paper
  * are the different results from the 3 approaches driven by sample selection effect??
  * indexd = 1 if all 3 underreporting measures are nonmissing (belong to the 186 group) 
  * indexd = 0 otherwise 
  * coefficient for indexd nonsiginficant indicates no sample selection issue 
	 	
  g indexd = 1 if rmiss == 0 
  replace indexd = 0 if rmiss != 0 
  reg underrp_d indexd 
  reg underrp_n indexd 
  reg underrp_m indexd
	
  *** ==========================
  ***  DO DESCRPTIVE REGRESSIONS 
  *** ==========================
  * for footnote 42 in the paper, check which measure has most explantory power!
  * conclusion is the MIMIC model based on R-square.
 
  * direct approach
  reg underrp_d industryd2 industryd3 industryd4 cityd2 cityd3 cityd5 if rmiss==0,robust
  ereturn list
  scalar r2a=e(r2)
  
  reg underrp_d industryd2 industryd3 industryd4 cityd2 cityd3 cityd5  ///
      sized2 sized3 lmwage lksflow manexp bribe credit if rmiss==0, robust
  ereturn list
  scalar r2b=e(r2)
  
  * for underrp_d>0
  reg underrp_d industryd2 industryd3 industryd4 cityd2 cityd3 cityd5 if rmiss==0&underrp_d~=0,robust
  ereturn list
  scalar r2c=e(r2)
  reg underrp_d industryd2 industryd3 industryd4 cityd2 cityd3 cityd5 ///
      sized2 sized3 lmwage lksflow manexp bribe credit if rmiss==0&underrp_d~=0, robust	
  ereturn list
  scalar r2d=e(r2)
  
  scalar r2ba=r2b-r2a
  scalar r2dc=r2d-r2c
  
  * MIMIC approach
  * Descriptive regression for footnote 37 in the paper!
  reg underrp_m industryd2 industryd3 industryd4 cityd2 cityd3 cityd5 if rmiss==0, robust
  ereturn list
  scalar r2e=e(r2)
  reg underrp_m industryd2 industryd3 industryd4 cityd2 cityd3 cityd5 ///
      sized2 sized3 lmwage lksflow manexp bribe credit if rmiss==0, robust
  ereturn list
  scalar r2f=e(r2)
  
 reg underrp_m industryd2 industryd3 industryd4 cityd2 cityd3 cityd5 if rmiss==0&underrp_d~=0,robust
  ereturn list
  scalar r2g=e(r2)
  reg underrp_m industryd2 industryd3 industryd4 cityd2 cityd3 cityd5 ///
      sized2 sized3 lmwage lksflow manexp bribe credit if rmiss==0&underrp_d~=0, robust	
  ereturn list
  scalar r2h=e(r2)  
  
  scalar r2fe=r2f-r2e
  scalar r2hg=r2h-r2g
  
  
  scalar list r2a r2b r2ba
  scalar list r2c r2d r2dc
  scalar list r2e r2f r2fe
  scalar list r2g r2h r2hg
  scalar list r2ba r2fe r2dc r2hg
  
  * Indirect approach
  reg underrp_n industryd2 industryd3 industryd4 cityd2 cityd3 cityd5 if rmiss==0, robust
  reg underrp_n industryd2 industryd3 industryd4 cityd2 cityd3 cityd5 ///
      sized2 sized3 lmwage lksflow manexp bribe credit if rmiss==0, robust  
  
  * test for the difference of underreporting between direct approach and MIMIC approach
  preserve
  keep if rmiss==0
  g diff=underrp_d-underrp_m
  reg diff industryd2 industryd3 industryd4 cityd2 cityd3 cityd5 ///
      sized2 sized3 lmwage lksflow manexp bribe credit, robust 
  test industryd2 industryd3 industryd4 cityd2 cityd3 cityd5
  test sized2 sized3 lmwage lksflow manexp bribe credit
  restore
  
  drop rmiss indexd
  log close
  * end of dofile

 
