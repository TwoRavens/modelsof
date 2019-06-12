

******************************** REPLICATION CODE ****************************************************************************
******************************** Analysis for Hardt et al. Journal of Politics research note
******************************** "The Gender Readings Gap in Political Science Graduate Training"
******************************** Authors: Heidi Hardt, Amy Erica Smith, Hannah June Kim and Philippe Meister

******Questions about dataset? Contact Amy Erica Smith, amyericas@gmail.com *************************************
******************************************************************************************************************************

use "Hardt et al. JOP_Replication data.dta", clear
egen tag_syllabus = tag(syll_id) //this creates an indicator allowing each syllabus to "count" a single time
xtset syll_id //allowing the data to be used as panel, if we want

**************************************************************************************************	
******** CREATE A WEIGHT TO COUNT ALL SYLLABI/READING LISTS AS HAVING AN EQUAL NUMBER OF CITATIONS
******** Because the number of citations varies extremely across the syllabi, we "coarsen" their groups.
******** We are ONLY using this weight in analysis at the citation-level (which is not very many analyses in this paper)
egen numcitations = count(female1), by(syll_id) // THIS COUNTS ONLY CITATIONS WITH A CODABLE GENDER
egen numcit_grp = cut(numcitations), group(10)
	replace numcit_grp = numcit_grp + 1
g wt = 6/numcit_grp
drop numcit*
**************************************************************************************************	


**************************************************************************************************	
******** CREATE VARIABLES FOR THE GENDER MIX OF CITATIONS
reshape long surname givenname gender female, i(citationnum) j(authornum)
egen numallauthors = count(surname), by(citationnum)
recode female (0 = .), g(female2)
	recode female (0=1) (1=.), g(male2)
	egen numfemaleauthors = count(female2), by(citationnum)
	egen nummaleauthors = count(male2), by(citationnum)
	drop female2 male2
egen numbothgenders = count(female), by(citationnum)
	recode numfemaleauthors nummaleauthors numbothgenders (0 = .) if numbothgenders == 0
g propfemale = numfemaleauthors/numbothgenders
g femaleonly = (numfemaleauthors > 0 & numfemaleauthors < . & nummaleauthors == 0) if numbothgenders < .
g mixedgender = (numfemaleauthors > 0 & numfemaleauthors < . & nummaleauthors < . & nummaleauthors > 0) if numbothgenders < .
g maleonly = (nummaleauthors > 0 & nummaleauthors < . & numfemaleauthors == 0) if numbothgenders < .
reshape wide surname givenname gender female, i(citationnum) j(authornum)

g anyfemale = (numfemaleauthors > 0 & numfemaleauthors < .)
g anymale = (nummaleauthors > 0 & nummaleauthors < .)
**************************************************************************************************	


**************************************************************************************************	
******** CREATE VARIABLES FOR THE GENDER MIX OF SYLLABI
******** PERCENTAGE OF ASSIGNED AUTHORS WHO ARE FEMALE
egen syll_numfemale = sum(numfemaleauthors), by(syll_id)
egen syll_nummale = sum(nummaleauthors), by(syll_id)
g syll_propfemale = syll_numfemale/(syll_numfemale+syll_nummale)
g syll_percentfemale = syll_numfemale*100/(syll_numfemale+syll_nummale)
	
****** PERCENTAGE OF ASSIGNED *FIRST* AUTHORS WHO ARE FEMALE
g male1 = 1-female1
egen syll_numfemale2 = sum(female1), by(syll_id)
egen syll_nummale2 = sum(male1), by(syll_id)
g syll_percentfemale2 = syll_numfemale2*100/(syll_numfemale2+syll_nummale2)
g syll_propfemale2 = syll_numfemale2/(syll_numfemale2+syll_nummale2)

*** PERCENTAGE OF ASSIGNED WORKS THAT ARE FEMALE ONLY
egen syll_propfemaleonly = mean(femaleonly), by(syll_id)
	g syll_percentfemaleonly = syll_propfemaleonly *100

*** PERCENTAGE OF ASSIGNED WORKS THAT ARE MALE ONLY
egen syll_propmaleonly = mean(maleonly), by(syll_id)
	g syll_percentmaleonly = syll_propmaleonly *100

*** PERCENTAGE OF ASSIGNED WORKS THAT ARE MIXED GENDER
egen syll_propmixed = mean(mixedgender), by(syll_id)
	g syll_percentmixed = syll_propmixed *100
**************************************************************************************************	


**************************************************************************************************	
******** CREATE BENCHMARKS
******** Subfield % of Instructors Who are Female
foreach topic in comp ir am meth thr polecon pubpol polpsy gender {
	egen numfemaleinst_`topic' = total(instr_numfemale) if tag_syll == 1, by(syll_topic_`topic')
	egen nummaleinst_`topic' = total(instr_nummale) if tag_syll == 1, by(syll_topic_`topic')
	g inst_pctfemale_`topic' = (numfemaleinst_`topic'*100)/(numfemaleinst_`topic'+nummaleinst_`topic')
}
egen benchmark_instrs = rowmean(inst_pctfemale*)
	replace benchmark_instrs = inst_pctfemale_gender if syll_topic_gender == 1
drop inst_pctfemale* numfemaleinst* nummaleinst*
egen xx = mean(benchmark_instrs), by(syll_id)
	replace benchmark_instrs = xx
	drop xx
	
********  Subfield % Publications
g benchmark_teelethelen_am = .2094093 if syll_topic_am == 1
g benchmark_teelethelen_meth = .1553785 if syll_topic_meth == 1
g benchmark_teelethelen_ir = .2194266 if syll_topic_ir == 1
g benchmark_teelethelen_comp = .2783505 if syll_topic_comp == 1
g benchmark_teelethelen_thr = .3149254 if syll_topic_thr == 1
egen benchmark_teelethelen = rowmean(benchmark_teelethelen_*)
	drop benchmark_teelethelen_*
**************************************************************************************************	

	
**************************************************************************************************	
******** YEAR OF THE SYLLABUS, COARSENED INTO GROUPS
recode syll_year (999 = .)
recode syll_year (2004/2012 = 1) (2013/2014 = 2) (2015=3) (2016/2017=4), g(syll_yearr)
	lab def syll_yearr 1 "2004-2012" 2 "2013-2014" 3 "2015" 4 "2016-2017"
	lab val syll_yearr syll_yearr 
recode syll_year (2004/2009 = 0) (2010/2012 = 1) (2013/2014 = 2) (2015=3) (2016/2017=4), g(syll_year3)
	lab def syll_year3 0 "2004-2009" 1 "2010-2012" 2 "2013-2014" 3 "2015" 4 "2016"
	lab val syll_year3 syll_year3 
tab1 syll_yearr, g(year)
**************************************************************************************************	

	
***************************************************************************************************************************************************
**************************************************** ANALYSIS *************************************************************************************

***************** IN-TEXT: BASELINE GENDER REPRESENTATION
* 18.7% of first authors are female
tab1 gender1 [aweight=wt] // THIS INCLUDES 18 OBSERVATIONS WITH MISSING/UNCODABLE GENDER & 286 OBSERVATIONS WITH "CORPORATE" AUTHORS (E.G., UNDP)
tab1 gender1 if gender1 < 3 [aweight=wt] // THE TOPLINE RESULTS WE REPORT EXCLUDE THOSE 304 OBSERVATIONS
* 19.1% of all authors are female
preserve
reshape long surname givenname gender female, i(citationnum) j(authornum)
	tab1 gender if gender < 3 [aweight=wt] 
restore
* Women are in later places in author order
forvalues i = 1/6 {
	tab gender`i' if gender`i' < 3 [aweight=wt]
}
***********************************************************


***************** FIGURE 1. Percentage female by subfield
foreach topic in comp ir am meth thr polecon {
	tempfile tf_`topic'
	preserve
		drop if tag_syllabus != 1	
		collapse mn=syll_percentfemale2 (semean) se=syll_percentfemale2 (sum) numfemaleinst=instr_numfemale nummaleinst=instr_nummale, by(syll_topic_`topic')
		drop if syll_topic_`topic' != 1
		save `tf_`topic'', replace
	restore
}
preserve
clear
append using `tf_comp' `tf_ir' `tf_am' `tf_meth' `tf_thr' `tf_polecon' 
drop syll_top*
g lb = mn-2*se
g ub = mn+2*se
g topic = _n
	lab def topic 1 "Comparative" 2 "IR" 3 "American" 4 "Methodology" 5 "Theory" 6 "Political Economy" 
	lab val topic topic
g inst_pctfemale = (numfemaleinst*100)/(numfemaleinst+nummaleinst)
g benchmark_teelethelen = 19.06722 if topic == 3
	replace benchmark_teelethelen = 11.36364 if topic == 4
	replace benchmark_teelethelen = 22.41888 if topic == 2
	replace benchmark_teelethelen = 28.76165 if topic == 1
	replace benchmark_teelethelen = 29.39322 if topic == 5
g benchmark_apsamember = 34.96 if topic == 3
	replace benchmark_apsamember = 19.15 if topic == 4
	replace benchmark_apsamember = 36.33 if topic == 2
	replace benchmark_apsamember = 43.18 if topic == 1
	replace benchmark_apsamember = 32.01 if topic == 5
graph twoway (bar mn topic, lcolor(black) fcolor(gs10) barwidth(.5)) ///
			(scatter benchmark_teelethelen topic, msymbol(Th) msize(large) mcolor(gs8)) ///
			(scatter benchmark_apsamember topic, msymbol(Sh) msize(large) mcolor(gs8)) ///
			(scatter inst_pctfemale topic, msymbol(X) msize(large) mcolor(black)) ///
			(rspike lb ub topic, lcolor(black)), ///
	graphregion(fcolor(white) lcolor(black)) ///
	legend(order(1 "Mean Percentage of" "Assigned Readings with" "Female First Authors" ///
				3 "Percentage of APSA Members" "Who are Female" ///
				4 "Percentage of Instructors" "Who are Female" ///
				2 "Percentage of Published Top" "Works with Female First Authors"	) ///
				col(2) width(140) size(small)) ///
	yline(38, lcolor(black) lpattern(longdash)) text(40 3.5 "Female % of PhDs (2016)") ///
	xlabel(1(1)6, valuelabel angle(45) labsize(small)) ///
	xtitle("") ylabel(0(10)40, gmin gmax) ymlabel(0(05)45, notick nolabel grid) ///
	ytitle("Gender Representation", margin(medium)) ysize(4.5)
restore
***************** END FIGURE 1. Percentage female by subfield


***************** IN-TEXT: CORRELATION BETWEEN PROGRAM RANK AND FACULTY PROPORTION FEMALE
pwcorr univ_rank univ_propfem if tag_syll == 1, sig
preserve
drop if tag_syll != 1
reg univ_propfem univ_rank 
	margins, at(univ_rank=(1 2 3 4 5 6))
restore
***********************************************************


***************** FIGURE 2. Gender composition, by program percentage female and gender: mixed v. female only
global sylltopics syll_topic_comp syll_topic_ir syll_topic_am syll_topic_meth syll_topic_thr syll_topic_polecon syll_topic_gender
preserve 
xtset univ_id
xtreg syll_propfemaleonly  c.univ_propfem##i.instr_anyfemale syll_yearr univ_rank syll_readinglist $sylltopics if tag_syll == 1
	margins instr_anyfemale, at(univ_propfem=(.11 .16 .21 .26 .31 .37 .42 .47 .53)) l(89) post //89% CI equivalent of a p=.05 test of stat sig
	parmest, norestore
egen univ_propfem = seq(), f(1) t(9) block(2)
	recode univ_propfem (1=.11) (2=.16) (3=.21) (4=.26) (5=.31) (6=.37) (7=.42) (8=.47) (9=.53)
egen female = seq(), f(0) t(1)
graph twoway (rarea min95 max95 univ_propfem if female == 0, lcolor(gs10) fcolor(none) lwidth(thin)) ///
			 (rarea min95 max95 univ_propfem if female == 1, lcolor(gs10) fcolor(none) lwidth(thin)) ///
			 (line estimate univ_propfem if female == 0, lcolor(black) lpattern(longdash) lwidth(thick)) ///
			 (line estimate univ_propfem if female == 1, lcolor(gs8) lwidth(thick)), ///
	graphregion(fcolor(white) lcolor(white)) legend(off) ///
	xtitle("") ///
	ytitle("Only Female Authors" " ", margin(medium)) ///
	note("") name(femaleonly, replace)
restore
preserve 
xtset univ_id
xtreg syll_propmixed 	c.univ_propfem##i.instr_anyfemale syll_yearr univ_rank syll_readinglist $sylltopics if tag_syll == 1
	margins instr_anyfemale, at(univ_propfem=(.11 .16 .21 .26 .31 .37 .42 .47 .53)) l(89) post //89% CI equivalent of a p=.05 test of stat sig
	parmest, norestore
egen univ_propfem = seq(), f(1) t(9) block(2)
	recode univ_propfem (1=.11) (2=.16) (3=.21) (4=.26) (5=.31) (6=.37) (7=.42) (8=.47) (9=.53)
egen female = seq(), f(0) t(1)
graph twoway (rarea min95 max95 univ_propfem if female == 0, lcolor(gs10) fcolor(none) lwidth(thin)) ///
			 (rarea min95 max95 univ_propfem if female == 1, lcolor(gs10) fcolor(none) lwidth(thin)) ///
			 (line estimate univ_propfem if female == 0, lcolor(black) lpattern(longdash) lwidth(thick)) ///
			 (line estimate univ_propfem if female == 1, lcolor(gs8) lwidth(thick)), ///
	graphregion(fcolor(white) lcolor(white)) legend(order(4 "Female Instructors" 3 "Male Instructors")) ///
	xtitle("Proportion Female Among Graduate Faculty", margin(medium)) ///
	ytitle("Mixed Gender" "Author Teams", margin(medium)) ylabel(0(.1).2) ///
	note("") name(mixed, replace) fysize(45)
restore
graph combine femaleonly mixed, col(1) ///
	graphregion(fcolor(white) lcolor(black)) ///
	title("Proportion of Readings in Syllabi/Reading Lists with:", size(medium) color(black)) ysize(6)
***************** END FIGURE 2. Gender composition, by program percentage female and gender: mixed v. female only


************************************************** ONLINE APPENDIX ***************************************************************

*** info on variable coding
*Missingness for gender
count if surname1 == ""
tab1 gender*
tab1 year, mi

**** descriptive statistics for key variables
summ syll_yearr univ_rank univ_propfem if tag_syll == 1
tab topjournal [iweight=wt], mi


***************** TABLE A5. NUMBERS OF SYLLABI, BY PROGRAM RANK
tab1 univ_rank if tag_syll == 1

***************** TABLE A6. NUMBERS OF SYLLABI IN EACH SUBFIELD
tab syll_readinglist if tag_syllabus == 1
foreach topic in syll_topic_comp syll_topic_ir syll_topic_am syll_topic_meth syll_topic_thr syll_topic_polecon syll_topic_pubpol syll_topic_polpsy syll_topic_gender {
tab `topic' syll_readinglist if tag_syllabus == 1
}

***************** TABLE A7. Syllabus Years
tab1 syll_year if tag_syll == 1


***************** FIGURE A4. Percentage female by subfield: All Subfields
foreach topic in am comp gender ir meth polecon polpsy pubpol thr {
	tempfile tf_`topic'
	preserve
		drop if tag_syllabus != 1	
		collapse mn=syll_percentfemale2 (semean) se=syll_percentfemale2 (sum) numfemaleinst=instr_numfemale nummaleinst=instr_nummale, by(syll_topic_`topic')
		drop if syll_topic_`topic' != 1
		save `tf_`topic'', replace
	restore
}
preserve
clear
append using `tf_am' `tf_comp' `tf_gender' `tf_ir' `tf_meth' `tf_polecon' `tf_polpsy' `tf_pubpol' `tf_thr' 
drop syll_top*
g lb = mn-2*se
g ub = mn+2*se
g topic = _n
	lab def topic 1 "American" 2 "Comparative" 3 "Gender/Identity" 4 "IR" 5 "Methodology" 6 "Political Economy" 7 "Pol. Psychology" 8 "Public Policy/Admin." 9 "Theory" 
	lab val topic topic
g inst_pctfemale = (numfemaleinst*100)/(numfemaleinst+nummaleinst)
graph twoway (bar mn topic, lcolor(black) fcolor(gs10) barwidth(.5)) ///
			(scatter inst_pctfemale topic, msymbol(X) msize(large) mcolor(black)) ///
			(rspike lb ub topic, lcolor(black)), ///
	graphregion(fcolor(white) lcolor(black)) ///
	legend(order(1 "Mean Percentage of" "Assigned Readings with" "Female (v. Male) First Authors" ///
				2 "Percentage of Syllabus" "Instructors Who are" "Female (v. Male)") ///
				width(140) size(small)) ///
	xlabel(1(1)9, valuelabel angle(45) labsize(small)) ///
	xtitle("Syllabus/Reading List Subfield") ylabel(0(20)100, gmin gmax) ymlabel(0(10)100, notick nolabel grid) ///
	ytitle("Gender Representation", margin(medium)) ///
	note("Source: GRADS. Whiskers represent 95% confidence intervals.", span size(vsmall)) ysize(4.5)
restore
***************** END FIGURE A4. Percentage female by subfield

		
***************** FIGURE A5. Percentage female by subfield: All authors, not just first authors
foreach topic in am comp gender ir meth polecon polpsy pubpol thr {
	tempfile tf_`topic'
	preserve
		replace syll_percentfemale=syll_percentfemale2
		drop if tag_syllabus != 1	
		collapse mn=syll_percentfemale2 (semean) se=syll_percentfemale2 (sum) numfemaleinst=instr_numfemale nummaleinst=instr_nummale, by(syll_topic_`topic')
		drop if syll_topic_`topic' != 1
		save `tf_`topic'', replace
	restore
}
preserve
clear
append using `tf_am' `tf_comp' `tf_gender' `tf_ir' `tf_meth' `tf_polecon' `tf_polpsy' `tf_pubpol' `tf_thr' 
drop syll_top*
g lb = mn-2*se
g ub = mn+2*se
g topic = _n
	lab def topic 1 "American" 2 "Comparative" 3 "Gender/Identity" 4 "IR" 5 "Methodology" 6 "Political Economy" 7 "Pol. Psychology" 8 "Public Policy/Admin." 9 "Theory" 
	lab val topic topic
g inst_pctfemale = (numfemaleinst*100)/(numfemaleinst+nummaleinst)
graph twoway (bar mn topic, lcolor(black) fcolor(blue) barwidth(.5)) ///
			(scatter inst_pctfemale topic, msymbol(X) msize(large) mcolor(black)) ///
			(rspike lb ub topic, lcolor(black)), ///
	graphregion(fcolor(white) lcolor(black)) ///
	legend(order(1 "Mean Percentage of" "Assigned Readings with" "Female (v. Male) Authors (Any Order)" ///
				2 "Percentage of Syllabus" "Instructors Who are" "Female (v. Male)") ///
				width(140) size(small)) ///
	xlabel(1(1)9, valuelabel angle(45) labsize(small)) ///
	xtitle("Syllabus/Reading List Subfield") ylabel(0(20)100, gmin gmax) ymlabel(0(10)100, notick nolabel grid) ///
	ytitle("Gender Representation", margin(medium)) ///
	note("Source: GRADS. Whiskers represent 95% confidence intervals.", span size(vsmall)) ysize(4.5)
restore
***************** END FIGURE A5. Percentage female by subfield


***************** FIGURE A6. Gender mix, by subfield
foreach topic in am comp gender ir meth polecon polpsy pubpol thr {
	tempfile tf_`topic'
	preserve
		drop if tag_syllabus != 1	
		collapse mn1=syll_percentfemaleonly mn2=syll_percentmixed mn3=syll_percentmaleonly, by(syll_topic_`topic')
		drop if syll_topic_`topic' != 1
		save `tf_`topic'', replace
	restore
}
preserve
clear
append using `tf_am' `tf_comp' `tf_gender' `tf_ir' `tf_meth' `tf_polecon' `tf_polpsy' `tf_pubpol' `tf_thr' 
drop syll_top*
g topic = _n
	lab def topic 1 "American" 2 "Comparative" 3 "Gender/Identity" 4 "IR" 5 "Methodology" 6 "Political Economy" 7 "Pol. Psychology" 8 "Public Policy/Admin." 9 "Theory" 
	lab val topic topic
graph bar mn1 mn2 mn3, ///
	stack over(topic, label(labsize(small) angle(45))) ///
	bar(1, lcolor(black) fcolor(gs3)) ///
	bar(2, lcolor(black) fcolor(gs15)) ///
	bar(3, lcolor(black) fcolor(gs10)) ///
	graphregion(fcolor(white) lcolor(black)) legend(order(1 "Female Only" 2 "Mixed Gender" 3 "Male Only") col(3) symxsize(6)) ///
	ytitle("Mean Percentage of Assigned" "Readings with Single and Mixed" "Gender Authorship", margin(small)) ///
	ymlabel(0(10)100, nolabel notick grid) ///
	note("Source: GRADS.", span)
restore
***************** END FIGURE A6. Gender mix, by subfield

***************** FIGURE A7. Percentage female first author, by year of publication
***************** NOTE: This is at the level of the reading, not the syllabus.
preserve
	collapse mn=female1 (semean) se=female1, by(yeargroup)
	drop if yeargroup == . 
	replace mn = mn*100
	replace se = se*100
	g lb = mn-2*se
	g ub = mn+2*se
graph twoway (rspike lb ub year , lcolor(black)) ///
			 (connected mn year, lcolor(black) mcolor(black)) , ///
	graphregion(fcolor(white) lcolor(black)) legend(off) xlabel(0(1)10, valuelabel angle(45)) ///
	xtitle("Publication Year of Assigned Reading", margin(medium)) ylabel(0(5)30) ///
	ytitle("Percentage of Assigned Readings" "with Female First Authors", margin(medium)) 
restore
***************** END FIGURE A7. Percentage female first author over time


***************** FIGURE A8. Percentage female first author, by year of syllabus/reading list
foreach year in year1 year2 year3 year4 {
	tempfile tf_`year'
	preserve
		drop if tag_syllabus != 1	
		collapse mn=syll_percentfemale2 (semean) se=syll_percentfemale2 if `year' == 1
		save `tf_`year'', replace
	restore
}
preserve
clear
append using `tf_year1' `tf_year2' `tf_year3' `tf_year4' 
tab1 mn
g lb = mn-2*se
g ub = mn+2*se
g year = _n
	lab def year 1 "2004-2012" 2 "2013-2014" 3 "2015" 4 "2016-2017" 
	lab val year year 
graph twoway (rspike lb ub year, lcolor(black)) ///
			(connected mn year, lcolor(black) mcolor(black)) , ///
	graphregion(fcolor(white) lcolor(black)) legend(off) xlabel(1(1)4, valuelabel) xscale(r(1 4.2)) ///
	xtitle("Year of Syllabus/Reading List", margin(medium)) ylabel(0(10)20, gmin ) ymlabel(0(5)20, notick nolabel grid) ///
	ytitle("Mean Percentage of Assigned Readings" "with Female First Authors", margin(medium)) ///
	note("Source: GRADS. Whiskers Represent 95% confidence intervals.", span size(small))
restore
***************** END FIGURE A8. Percentage female first author, by year of syllabus/reading list


***************** FIGURE A9. Percentage female first author, by program percentage female AND GENDER
global sylltopics syll_topic_comp syll_topic_ir syll_topic_am syll_topic_meth syll_topic_thr syll_topic_polecon syll_topic_gender
preserve 
xtset univ_id
xtreg syll_propfemale c.univ_propfem##i.instr_anyfemale syll_yearr univ_rank syll_readinglist $sylltopics if tag_syll == 1
	margins instr_anyfemale, at(univ_propfem=(.11 .16 .21 .26 .31 .37 .42 .47 .53)) l(89) post
	parmest, norestore
egen univ_propfem = seq(), f(1) t(9) block(2)
	recode univ_propfem (1=.11) (2=.16) (3=.21) (4=.26) (5=.31) (6=.37) (7=.42) (8=.47) (9=.53)
egen female = seq(), f(0) t(1)
graph twoway (rarea min95 max95 univ_propfem if female == 0, lcolor(gs10) fcolor(none) lwidth(thin)) ///
			 (rarea min95 max95 univ_propfem if female == 1, lcolor(gs10) fcolor(none) lwidth(thin)) ///
			 (line estimate univ_propfem if female == 0, lcolor(black) lpattern(longdash) lwidth(thick)) ///
			 (line estimate univ_propfem if female == 1, lcolor(gs8) lwidth(thick)), ///
	graphregion(fcolor(white) lcolor(black)) legend(order(4 "Female Instructors" 3 "Male Instructors")) ///
	xtitle("Proportion Female Among Graduate Faculty", margin(medium)) ylabel(0(.1).4) ///
	ytitle("Predicted Proportion of Assigned" "Readings with Female First Authors", margin(medium)) 
restore
***************** END FIGURE A9. Percentage female first author, by program percentage female AND GENDER


***************** FIGURE A10. Percentage female first author, by program rank
preserve
	collapse mn1=syll_propfemaleonly mn2=syll_propmixed mn3=syll_propfemale ///
			(semean) se1=syll_propfemaleonly se2=syll_propmixed se3=syll_propfemale ///
			if tag_syllabus == 1, by(univ_rank)
	drop if univ_rank == .
	g lb1 = mn1-2*se1
	g ub1 = mn1+2*se1
	g lb2 = mn2-2*se2
	g ub2 = mn2+2*se2
	g lb3 = mn3-2*se3
	g ub3 = mn3+2*se3
graph twoway (rcap lb1 ub1 univ_rank, lcolor(gs12) lwidth(thin)) ///
			 (rcap lb2 ub2 univ_rank, lcolor(gs12) lwidth(thin)) ///
			 (rcap lb3 ub3 univ_rank, lcolor(gs12) lwidth(thin)) ///
			 (connected mn1 univ_rank, lcolor(gs8) mcolor(gs8)) ///
			 (connected mn2 univ_rank, lcolor(gs8) lwidth(thick) lpattern(longdash) mcolor(gs12)) ///
			 (connected mn3 univ_rank, lcolor(black) lwidth(thick) mcolor(black)) , ///
	graphregion(fcolor(white) lcolor(black)) ///
	legend(order(6 "Female" "First Authors" 4 "Female Only" "Authors" 5 "Mixed Gender" "Authors") col(3) size(small) symxsize(7)) ///
	xlabel(1 "1-10" 2 "11-20" 3 "21-30" 4 "31-40" 5 "41-50" 6 "51+") ///
	xtitle("Political Science Program Rank (US News & World Reports 2017)", margin(medium)) ylabel(0(.05).30) ///
	ytitle("Mean Percentage of Assigned" "Readings with Female First Authors", margin(medium)) ///
	note("Source: GRADS. Whiskers Represent 95% confidence intervals.", span)
restore
***************** END FIGURE A10. Percentage female first author, by program rank


**************** Table A8. Rate of assigning work by women in different journals
mean female1 [iweight=wt], over(topjournal)
mean anyfemale [iweight=wt], over(topjournal)
mean anymale [iweight=wt], over(topjournal)
mean female1 [iweight=wt], over(venuetype)
mean anyfemale [iweight=wt], over(venuetype)
mean anymale [iweight=wt], over(venuetype)
**************** Table A8. Rate of assigning work by women in different journals

		
***************** TABLE A9. DETERMINANTS of proportion female first author
preserve
foreach var in syll_yearr univ_rank univ_propfem benchmark {
	summ `var'
	replace `var' = (`var'-r(min))/(r(max)-r(min))
}
global sylltopics syll_topic_comp syll_topic_ir syll_topic_am syll_topic_meth syll_topic_thr syll_topic_polecon syll_topic_gender
eststo clear
glm syll_propfemale syll_readinglist syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1, link(logit) family(binomial) robust nolog
eststo
glm syll_propfemale instr_anyfemale syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1, link(logit) family(binomial) robust nolog
eststo
glm syll_propfemale syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1 & instr_anyfemale == 0, link(logit) family(binomial) robust nolog
eststo
glm syll_propfemale syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1 & instr_anyfemale == 1, link(logit) family(binomial) robust nolog
eststo
esttab, b(3) se(3) nopar nogaps star(* .10 ** .05)
restore
***************** END TABLE A9. INSTITUTIONAL DETERMINANTS, PLUS INSTRUCTOR GENDER
/** checking to see if things vary by whether we use a multilevel model
xtset univ_id
xtreg syll_propfemale syll_readinglist syll_yearr univ_rank univ_propfem $sylltopics if tag_syllabus == 1
eststo
xtreg syll_propfemale instr_anyfemale syll_yearr univ_rank univ_propfem $sylltopics if tag_syllabus == 1
eststo
*/


***************** TABLE A10. DETERMINANTS of proportion female only author
preserve
foreach var in syll_yearr univ_rank univ_propfem benchmark {
	summ `var'
	replace `var' = (`var'-r(min))/(r(max)-r(min))
}
global sylltopics syll_topic_comp syll_topic_ir syll_topic_am syll_topic_meth syll_topic_thr syll_topic_polecon syll_topic_gender
eststo clear
glm syll_propfemaleonly syll_readinglist syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1, link(logit) family(binomial) robust nolog
eststo
glm syll_propfemaleonly instr_anyfemale syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1, link(logit) family(binomial) robust nolog
eststo
glm syll_propfemaleonly syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1 & instr_anyfemale == 0, link(logit) family(binomial) robust nolog
eststo
glm syll_propfemaleonly syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1 & instr_anyfemale == 1, link(logit) family(binomial) robust nolog
eststo
esttab, b(3) se(3) nopar nogaps star(* .10 ** .05)
restore
***************** END TABLE A10. DETERMINANTS of proportion female only author


***************** TABLE A11. DETERMINANTS of proportion mixed gender
preserve
foreach var in syll_yearr univ_rank univ_propfem benchmark {
	summ `var'
	replace `var' = (`var'-r(min))/(r(max)-r(min))
}
global sylltopics syll_topic_comp syll_topic_ir syll_topic_am syll_topic_meth syll_topic_thr syll_topic_polecon syll_topic_gender
eststo clear
glm syll_propmixed syll_readinglist syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1, link(logit) family(binomial) robust nolog
eststo
glm syll_propmixed instr_anyfemale syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1, link(logit) family(binomial) robust nolog
eststo
glm syll_propmixed syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1 & instr_anyfemale == 0, link(logit) family(binomial) robust nolog
eststo
glm syll_propmixed syll_yearr univ_rank univ_propfem benchmark $sylltopics if tag_syllabus == 1 & instr_anyfemale == 1, link(logit) family(binomial) robust nolog
eststo
esttab, b(3) se(3) nopar nogaps star(* .10 ** .05)
restore
***************** END TABLE A11. DETERMINANTS of proportion mixed gender
