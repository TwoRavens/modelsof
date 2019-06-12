* ==============================================================================
* PART II: Tables
* Date: Feb 2018
* 
* 2_tables
* Data: gstyping.dta
*
* produces the tables 1-6 and tables in appendix
* ==============================================================================
char ts_4[omit] 3
char term_t[omit] 1

*PREDICTING TEACHER BELIEFS WITH TEACHER CHARACTERISTICS
preserve
collapse Wtgender tmale ts_1 ts_4 ts_2 qual ts_3 tt_train ts_5 gms extrinsic constructive warmth proximity grade, by(teacher)
*teacher regression re-labelling
label variable tmale "Male"
label variable ts_2 "Years of Experience"
label variable ts_3 "Tenured"
label variable ts_1 "Number of Terms in the Same Class"
label variable tt_train "Number of Extra_C Programs"
label variable ts_5 "Number of Volunteer Activities"
label variable gms "Growth Mindset"
label variable extrinsic "Extrinsic Motivator"
label variable constructive "Modern Approach"
label variable warmth "Warm Approach"

xi: reg Wtgender tmale,r
estimates store spec0
xi: reg Wtgender tmale i.ts_4 ts_2 ts_1,r
estimates store spec1
xi: reg Wtgender tmale i.ts_4 ts_2 ts_1 i.qual,r
estimates store spec2
xi: reg Wtgender tmale i.ts_4 ts_2 ts_1 i.qual gms extrinsic constructive warmth ,r
estimates store spec3
xi: reg Wtgender tmale i.ts_4 ts_2 ts_1 i.qual gms extrinsic constructive warmth tt_train ts_5,r
estimates store spec4
#delimit ;
esttab spec0 spec1 spec2 spec3 spec4 using "table0.tex", replace label compress  b(%8.3f) se(2) nonumbers
coeflabels(Wtgender "Teacher G-Styping" _Its_4_3 "University Degree" _Its_4_4 "Graduate Degree"  _Iqual_2 "Education Degree"   _Iqual_3 "Linguistics" _Iqual_4 "Natural Sciences" _Iqual_5 "Social Sciences"
)
star(* 0.1 ** 0.05 *** 0.01) 
nonotes
nocons
s(N r2, fmt(%9.0g %9.2f) labels("N" "R-Squared"))
nogaps
nomtitles 
substitute(_ \_  \begin{tabular} "\adjustbox{max height=\dimexpr\textheight-5.5cm\relax,max width=\textwidth}{\begin{tabular}" \end{tabular} \end{tabular}})
;
#delimit cr
est clear
restore

*TABLE - BALANCE TEST ACROSS TRADITIONAL VS PROGRESSIVE TEACHERS
reg male hightbias, cluster(teachername)
bysort hightbias: sum male
reg age_m_mean hightbias, cluster(teachername)
bysort hightbias: sum age_m_mean
reg working_mom  hightbias, cluster(teachername)
bysort hightbias: sum working_mom 
reg computer  hightbias, cluster(teachername)
bysort hightbias: sum computer
reg hhgender hightbias, cluster(teachername)
bysort hightbias: sum hhgender
reg lowses hightbias, cluster(teachername)
bysort hightbias: sum lowses
reg medses hightbias, cluster(teachername)
bysort hightbias: sum medses
reg highses hightbias, cluster(teachername)
bysort hightbias: sum highses
reg raven_std hightbias, cluster(teachername)
bysort hightbias: sum raven_std

*Predicting achievemnt with family and correlating with teacher GR Score
xi: reg math_std tmale working_mom computer hhgender i.proximity if male==0, cluster(teachername) 
predict mathgirls
reg mathgirls Wtgender, cluster(teachername)
xi: reg math_std tmale working_mom computer hhgender i.proximity if male==1, cluster(teachername) 
predict mathboys
reg mathboys Wtgender, cluster(teachername)
xi: reg turkish_std tmale working_mom computer hhgender i.proximity if male==0, cluster(teachername) 
predict turkgirls
reg turkgirls Wtgender, cluster(teachername)
xi: reg turkish_std tmale working_mom computer hhgender i.proximity if male==1, cluster(teachername) 
predict turkboys
reg turkboys Wtgender, cluster(teachername)


*SUBSAMPLE BY GENDER - MATHS AND VERBAL
xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0, cluster(teachername) 
test  Wtgender+_IterXWtgen_2= Wtgender+_IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= Wtgender+_IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= Wtgender+_IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec1

xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1, cluster(teachername) 
test  Wtgender+_IterXWtgen_2= Wtgender+_IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= Wtgender+_IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= Wtgender+_IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec2

qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0
estimates store m1
qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1
estimates store m2
suest m1 m2, cluster(teachername)
test [m1_mean]_IterXWtgen_2+[m1_mean]Wtgender=[m2_mean]_IterXWtgen_2+[m2_mean]Wtgender 
estadd scalar p4=r(p),  : spec2 
test [m1_mean]_IterXWtgen_3+[m1_mean]Wtgender=[m2_mean]_IterXWtgen_3+[m2_mean]Wtgender
estadd scalar p5=r(p),  : spec2 
test [m1_mean]Wtgender=[m2_mean]Wtgender
estadd scalar p6=r(p),  : spec2 

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0, cluster(teachername) 
test  Wtgender+_IterXWtgen_2= Wtgender+_IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= Wtgender+_IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= Wtgender+_IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec3

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1, cluster(teachername) 
test  Wtgender+_IterXWtgen_2= Wtgender+_IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= Wtgender+_IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= Wtgender+_IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec4

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0
estimates store m3
qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 
estimates store m4
suest m3 m4, cluster(teachername)
test [m3_mean]_IterXWtgen_2+[m3_mean]Wtgender=[m4_mean]_IterXWtgen_2+[m4_mean]Wtgender
estadd scalar p4=r(p), : spec4 
test [m3_mean]_IterXWtgen_3+[m3_mean]Wtgender=[m4_mean]_IterXWtgen_3+[m4_mean]Wtgender
estadd scalar p5=r(p),  : spec4 
test [m3_mean]Wtgender=[m4_mean]Wtgender
estadd scalar p6=r(p),  : spec4 


#delimit ;
esttab spec1 spec2 spec3 spec4 using "table3a.tex", replace label compress  b(%8.3f) se(2) nonumbers
keep(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2  _IterXWtgen_3)
indicate("School Fixed Effects = *proximity*" "Student Characteristics = raven_std" "Family Characteristics = *ses*" "Teacher Characteristics = *ts_4*" "Teaching Styles = extrinsic" "Teacher Effort = ts_5", labels("\checkmark"  ""))
order(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2  _IterXWtgen_3)
coeflabels(Wtgender "Teacher G-Styping" _Iterm_t_2 "2-3 Year Exposure" _Iterm_t_3 "4 Year Exposure" _IterXWtgen_2 "2-3 Year Exposure*Teacher G-Styping"  _IterXWtgen_3 "4 Year Exposure*Teacher G-Styping")
star(* 0.1 ** 0.05 *** 0.01) 
nonotes 
s(p1 p2 p3 p6 p4 p5 N r2, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.0g %9.2f) labels("P-value: 2-3 Year E*G-Styp=Long*G-Styp" "P-value: 1 Year E*G-Styp=2-3 Year E*G-Styp" "P-value: 1 Year E*G-Styp=4 Year E*G-Styp" "P-value: 1 Year E*G-Sty[Girls=Boys]" "P-value: 2-3 Year E*G-Styp[Girls=Boys] " "P-value: 4 Year E*G-Sty[Girls=Boys]" "\hline N" "R-Squared") layout(@ @ @ "\multicolumn{2}{S}{@}" "\multicolumn{2}{S}{@}" "\multicolumn{2}{S}{@}" @ @))
nogaps
mtitles ("Girls" "Boys" "Girls" "Boys")
mgroups("Math Score" "Verbal Score", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
substitute(_ \_  \begin{tabular} "\adjustbox{max height=\dimexpr\textheight-5.5cm\relax,max width=\textwidth}{\begin{tabular}" \end{tabular} \end{tabular}} "&\multicolumn{2}{S}{" "\multicolumn{2}{c}{")
;
#delimit cr
est clear

*SUBSAMPLE WITH TEACHER GRADES*
qui xi: reg tss_grade_math tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==0, cluster(teachername)
test  Wtgender+_IterXWtgen_2= Wtgender+_IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= Wtgender+_IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= Wtgender+_IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec1

qui xi: reg tss_grade_math tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1, cluster(teachername) 
test  Wtgender+_IterXWtgen_2= Wtgender+_IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= Wtgender+_IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= Wtgender+_IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec2

qui xi: reg tss_grade_math tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==0
estimates store m1
qui xi: reg tss_grade_math tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 
estimates store m2
suest m1 m2, cluster(teachername)
test [m1_mean]_IterXWtgen_2+[m1_mean]Wtgender=[m2_mean]_IterXWtgen_2+[m2_mean]Wtgender
estadd scalar p4=r(p),  : spec2 
test [m1_mean]_IterXWtgen_3+[m1_mean]Wtgender=[m2_mean]_IterXWtgen_3+[m2_mean]Wtgender
estadd scalar p5=r(p),  : spec2 
test [m1_mean]Wtgender=[m2_mean]Wtgender
estadd scalar p6=r(p),  : spec2 

qui xi: reg tss_grade_tr tmale male i.term_t*Wtgender age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0, cluster(teachername) 
test  Wtgender+_IterXWtgen_2= Wtgender+_IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= Wtgender+_IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= Wtgender+_IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec3

qui xi: reg tss_grade_tr tmale male i.term_t*Wtgender age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity   i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1, cluster(teachername) 
test  Wtgender+_IterXWtgen_2= Wtgender+_IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= Wtgender+_IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= Wtgender+_IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec4

qui xi: reg tss_grade_tr tmale male i.term_t*Wtgender age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 
estimates store m3
qui xi: reg tss_grade_tr tmale male i.term_t*Wtgender age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity   i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 
estimates store m4
suest m3 m4, cluster(teachername)
test [m3_mean]_IterXWtgen_2+[m3_mean]Wtgender=[m4_mean]_IterXWtgen_2+[m4_mean]Wtgender
estadd scalar p4=r(p), : spec4 
test [m3_mean]_IterXWtgen_3+[m3_mean]Wtgender=[m4_mean]_IterXWtgen_3+[m4_mean]Wtgender
estadd scalar p5=r(p),  : spec4 
test [m3_mean]Wtgender=[m4_mean]Wtgender
estadd scalar p6=r(p),  : spec4 

#delimit ;
esttab spec1 spec2 spec3 spec4 using "table6.tex", replace label compress  b(%8.3f) se(2) nonumbers
keep(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2  _IterXWtgen_3)
indicate("School Fixed Effects = *proximity*" "Student Characteristics = raven_std" "Family Characteristics = *ses*" "Teacher Characteristics = *ts_4*" "Teaching Styles = extrinsic" "Teacher Effort = ts_5", labels("\checkmark"  ""))
order(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2  _IterXWtgen_3)
coeflabels(Wtgender "Teacher G-Styping" _Iterm_t_2 "2-3 Year Exposure" _Iterm_t_3 "4 Year Exposure" _IterXWtgen_2 "2-3 Year Exposure*Teacher G-Styping"  _IterXWtgen_3 "4 Year Exposure*Teacher G-Styping")
star(* 0.1 ** 0.05 *** 0.01) 
nonotes 
s(p1 p2 p3 p6 p4 p5 N r2, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.0g %9.2f) labels("P-value: 2-3 Year E*G-Styp=Long*G-Styp" "P-value: 1 Year E*G-Styp=2-3 Year E*G-Styp" "P-value: 1 Year E*G-Styp=4 Year E*G-Styp" "P-value: 1 Year E*G-Sty[Girls=Boys]" "P-value: 2-3 Year E*G-Styp[Girls=Boys] " "P-value: 4 Year E*G-Sty[Girls=Boys]" "\hline N" "R-Squared") layout(@ @ @ "\multicolumn{2}{S}{@}" "\multicolumn{2}{S}{@}" "\multicolumn{2}{S}{@}" @ @))
nogaps
mtitles ("Girls" "Boys" "Girls" "Boys")
mgroups("Math Grade" "Verbal Grade", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
substitute(_ \_  \begin{tabular} "\adjustbox{max height=\dimexpr\textheight-5.5cm\relax,max width=\textwidth}{\begin{tabular}" \end{tabular} \end{tabular}} "&\multicolumn{2}{S}{" "\multicolumn{2}{c}{")
;
#delimit cr
est clear


*MEDIATION ANALYSIS
*the mediation model
xi: reg zstud_gender hightbias tmale tss_behavior age_m_mean conf zgms_stud raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==0, cluster(teachername)
estimates store spec1

xi: reg zstud_gender hightbias tmale tss_behavior age_m_mean conf zgms_stud raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==1, cluster(teachername)
estimates store spec2

xi: reg conf hightbias tmale tss_behavior age_m_mean zstud_gender zgms_stud raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==0, cluster(teachername)
estimates store spec3

xi: reg conf hightbias tmale tss_behavior age_m_mean zstud_gender zgms_stud raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==1, cluster(teachername)
estimates store spec4

xi: reg zgms_stud hightbias tmale tss_behavior age_m_mean zstud_gender conf raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==0, cluster(teachername)
estimates store spec5

xi: reg zgms_stud hightbias tmale tss_behavior age_m_mean zstud_gender conf raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==1, cluster(teachername)
estimates store spec6

#delimit ;
esttab spec1 spec2 spec3 spec4 spec5 spec6 using "table7.tex", replace label compress  b(%8.3f) se(2) nonumbers
keep(hightbias)
indicate("School Fixed Effects = *proximity*" "Student Characteristics = raven_std" "Family Characteristics = *ses*" "Teacher Characteristics = *ts_4*" "Teaching Styles = extrinsic" "Teacher Effort = ts_5", labels("\checkmark"  ""))
coeflabels(hightbias "Traditional Teacher")
star(* 0.1 ** 0.05 *** 0.01) 
nonotes 
s(N, fmt(%9.0g) labels("N"))
nogaps
mgroups("Gender Role Beliefs" "Self Confidence" "Growth Mindset", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
mtitles ("Girls" "Boys" "Girls" "Boys" "Girls" "Boys")
substitute(_ \_  \begin{tabular} "\adjustbox{max height=\dimexpr\textheight-5.5cm\relax,max width=\textwidth}{\begin{tabular}" \end{tabular} \end{tabular}})
;
#delimit cr
est clear

*ACME-ADE
*Math Scores
*Gender role beliefs
medeff (regress zstud_gender hightbias age_m_mean tss_behavior conf zgms_stud raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) ///
(regress math_std hightbias lterm termbiasl age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) if male==0, mediate(zstud_gender) treat(hightbias)  sims(1000) seed(1000)
*Confidence
medeff (regress conf hightbias age_m_mean tss_behavior zstud_gender zgms_stud raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) ///
(regress math_std hightbias lterm termbiasl age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) if male==0, mediate(conf) treat(hightbias)  sims(1000) seed(1000)
*mindset
medeff (regress zgms_stud zstud_gender hightbias age_m_mean tss_behavior conf  raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) ///
(regress math_std hightbias lterm termbiasl age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) if male==0, mediate(zgms_stud) treat(hightbias)  sims(1000) seed(1000)

*Turkish Scores
*Gender Role Beliefs
medeff (regress zstud_gender hightbias age_m_mean tss_behavior conf zgms_stud raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) ///
(regress turkish_std hightbias lterm termbiasl age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) if male==0, mediate(zstud_gender) treat(hightbias)  sims(1000) seed(1000)
*Confidence
medeff (regress conf hightbias age_m_mean tss_behavior zstud_gender zgms_stud raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) ///
(regress turkish_std hightbias lterm termbiasl age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) if male==0, mediate(conf) treat(hightbias)  sims(1000) seed(1000)
*mindset
medeff (regress zgms_stud zstud_gender hightbias age_m_mean tss_behavior conf  raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) ///
(regress turkish_std hightbias lterm termbiasl age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std lowses medses working_mom computer hhgender educ1 educ2 ts_2 qual1-qual4 ts_3 tt_train ts_5 gms extrinsic constructive warmth prox2-prox30) if male==0, mediate(zgms_stud) treat(hightbias)  sims(1000) seed(1000)




**ONLINE APPENDIX - TABLES**
*PROBABILITY OF TEACHING LONG TERM
preserve
collapse Wtgender tmale ts_1 ts_4 ts_2 qual ts_3 tt_train ts_5 gms extrinsic constructive warmth proximity grade, by(teacher)
ge lt=0
replace lt=1 if ts_1==7 | ts_1==8
replace lt=1 if (ts_1==5 | ts_1==6) & grade==3
*teacher regression re-labelling
label variable tmale "Male"
label variable ts_2 "Years of Experience"
label variable ts_3 "Tenured"
label variable ts_1 "Number of Terms in the Same Class"
label variable tt_train "Number of Extra_C Programs"
label variable ts_5 "Number of Volunteer Activities"
label variable gms "Growth Mindset"
label variable extrinsic "Extrinsic Motivator"
label variable constructive "Modern Approach"
label variable warmth "Warm Approach"
xi: logit lt Wtgender, r
scalar i1=e(r2_p)
scalar i2=e(p)
margins, dydx(*) post
estimates store spec5
estadd scalar pr2=i1 : spec5
estadd scalar p=i2 : spec5
xi: logit lt Wtgender tmale ts_2 i.qual, r
scalar i1=e(r2_p)
scalar i2=e(p)
margins, dydx(*) post
estimates store spec6
estadd scalar pr2=i1 : spec6
estadd scalar p=i2 : spec6
xi: logit lt Wtgender tmale ts_2 i.qual gms extrinsic constructive warmth, r
scalar i1=e(r2_p)
scalar i2=e(p)
margins, dydx(*) post
estimates store spec7
estadd scalar pr2=i1 : spec7
estadd scalar p=i2 : spec7
xi: logit lt Wtgender tmale ts_2 i.qual gms extrinsic constructive warmth tt_train ts_5, r
scalar i1=e(r2_p)
scalar i2=e(p)
margins, dydx(*) post
estimates store spec8
estadd scalar pr2=i1 : spec8
estadd scalar p=i2 : spec8
#delimit ;
esttab spec5 spec6 spec7 spec8 using "table0AP.tex", replace label compress  b(%8.3f) se(2) nonumbers
coeflabels(Wtgender "Teacher G-Styping" _Its_4_3 "University Degree" _Its_4_4 "Graduate Degree"  _Iqual_2 "Education Degree"   _Iqual_3 "Linguistics" _Iqual_4 "Natural Sciences" _Iqual_5 "Social Sciences"
)
star(* 0.1 ** 0.05 *** 0.01) 
nonotes
nocons
s(N pr2 p, fmt(%9.0g %9.2f %9.2f) labels("N" "Pseudo-R-squared" "Significance of model test"))
nogaps
nomtitles 
substitute(_ \_  \begin{tabular} "\adjustbox{max height=\dimexpr\textheight-5.5cm\relax,max width=\textwidth}{\begin{tabular}" \end{tabular} \end{tabular}})
;
#delimit cr
est clear
restore


*SUBSAMPLE BY GENDER - DETAILED TABLE
qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0, cluster(teachername) 
test  _IterXWtgen_2= _IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec1

qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1, cluster(teachername) 
test  _IterXWtgen_2= _IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec2

qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0
estimates store m1
qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1
estimates store m2
suest m1 m2, cluster(teachername)
test [m1_mean]_IterXWtgen_2=[m2_mean]_IterXWtgen_2
estadd scalar p4=r(p),  : spec2 
test [m1_mean]_IterXWtgen_3=[m2_mean]_IterXWtgen_3
estadd scalar p5=r(p),  : spec2 
test [m1_mean]Wtgender=[m2_mean]Wtgender
estadd scalar p6=r(p),  : spec2 

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0, cluster(teachername) 
test  _IterXWtgen_2= _IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec3

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1, cluster(teachername) 
test  _IterXWtgen_2= _IterXWtgen_3
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3
estadd scalar p3=r(p)
estimates store spec4

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0
estimates store m3
qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 
estimates store m4
suest m3 m4, cluster(teachername)
test [m3_mean]_IterXWtgen_2=[m4_mean]_IterXWtgen_2
estadd scalar p4=r(p), : spec4 
test [m3_mean]_IterXWtgen_3=[m4_mean]_IterXWtgen_3
estadd scalar p5=r(p),  : spec4 
test [m3_mean]Wtgender=[m4_mean]Wtgender
estadd scalar p6=r(p),  : spec4 

#delimit ;
esttab spec1 spec2 spec3 spec4 using "appendix3a.tex", replace label compress  b(%8.3f) se(2) nonumbers
keep(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2  _IterXWtgen_3 age_m_mean raven_std tss_behavior conf zstud_gender zgms_stud working_mom computer hhgender _Ises_2 _Ises_3 tmale _Its_4_2 _Its_4_4 ts_2 _Iqual_2 _Iqual_3 _Iqual_4 _Iqual_5 gms extrinsic constructive warmth tt_train ts_5)
order(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2  _IterXWtgen_3 age_m_mean raven_std tss_behavior conf zstud_gender zgms_stud _Ises_2 _Ises_3 working_mom computer hhgender tmale _Its_4_2 _Its_4_4 ts_2 _Iqual_2 _Iqual_3 _Iqual_4 _Iqual_5 gms extrinsic constructive warmth tt_train ts_5)
coeflabels(Wtgender "Teacher G-Styping" _Iterm_t_2 "Medium Term" _Iterm_t_3 "Long-Term" _IterXWtgen_2 "Medium Term*Teacher G-Styping"  _IterXWtgen_3 "Long Term*Teacher G-Styping" age_m_mean "Age(months)" raven_std "Raven Score" zstud_gender "Student G-Styping" conf "Academic Self-confidence" zgms_stud "Student GMS" tss_behavior "Teacher's assesment: well-behaved" working_mom "Working Mother" computer "Computer at Home" hhgender "G-Styping at Home" _Ises_2 "Middle SES" _Ises_3 "High SES" tmale "Male Teacher" _Its_4_2 "Teacher Qual - 2 Year College" _Its_4_4 "Teacher Qual - Grad S" ts_2 "Years of Teaching" _Iqual_2 "Linguistics" _Iqual_3 "Sciences" _Iqual_4 "Social Sciences" _Iqual_5 "Other" ts_3 "Tenure" tt_train "Occupational Trainings" ts_5 "Extra-curricular" gms "GMS" extrinsic "Extrinsic Motivation" constructive "Modern Approach" warmth "Teacher Warmth")
indicate("School Fixed Effects = *proximity*", labels("\checkmark"  ""))
refcat(age_m_mean "\textbf{Student Characteristics:}" _Ises_2 "\textbf{Family Characteristics:}" tmale "\textbf{Teacher Characteristics:}" gms "\textbf{Teacher Styles:}" tt_train "\textbf{Teacher Effort:}", nolabel)
star(* 0.1 ** 0.05 *** 0.01) 
nonotes
s(N r2, fmt(%9.0g %9.2f) labels("N" "R-Squared"))
nogaps
mtitles ("Girls" "Boys" "Girls" "Boys")
mgroups("Math Score" "Verbal Score", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
substitute(_ \_  \begin{tabular} "\adjustbox{max totalheight=\dimexpr\textheight-1.5cm\relax,max width=\textwidth}{\begin{tabular}" \end{tabular} \end{tabular}} "&\multicolumn{2}{S}{" "\multicolumn{2}{c}{")
;
#delimit cr
est clear

*DROPPING EXTREMELY PROGRESSIVE TEACHERS
qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & Wtgender>-1.59, cluster(teachername) 
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec1

qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & Wtgender>-1.59, cluster(teachername) 
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec2

qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & Wtgender>-1.59
estimates store m1
qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & Wtgender>-1.59
estimates store m2
suest m1 m2, cluster(teachername)
test [m1_mean]_IterXWtgen_2+[m1_mean]Wtgender=[m2_mean]_IterXWtgen_2+[m2_mean]Wtgender
estadd scalar p4=r(p),  : spec2 
test [m1_mean]_IterXWtgen_3+[m1_mean]Wtgender=[m2_mean]_IterXWtgen_3+[m2_mean]Wtgender
estadd scalar p5=r(p),  : spec2 
test [m1_mean]Wtgender=[m2_mean]Wtgender
estadd scalar p6=r(p),  : spec2 

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & Wtgender>-1.59, cluster(teachername) 
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec3

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & Wtgender>-1.59, cluster(teachername) 
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec4

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & Wtgender>-1.59
estimates store m3
qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & Wtgender>-1.59
estimates store m4
suest m3 m4, cluster(teachername)
test [m3_mean]_IterXWtgen_2+[m3_mean]Wtgender=[m4_mean]_IterXWtgen_2+[m4_mean]Wtgender
estadd scalar p4=r(p), : spec4 
test [m3_mean]_IterXWtgen_3+[m3_mean]Wtgender=[m4_mean]_IterXWtgen_3+[m4_mean]Wtgender
estadd scalar p5=r(p),  : spec4 
test [m3_mean]Wtgender=[m4_mean]Wtgender
estadd scalar p6=r(p),  : spec4 

#delimit ;
esttab spec1 spec2 spec3 spec4 using "table3a_noex.tex", replace label compress  b(%8.3f) se(2) nonumbers
keep(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2 _IterXWtgen_3)
indicate("School Fixed Effects = *proximity*" "Student Characteristics = raven_std" "Family Characteristics = *ses*" "Teacher Characteristics = *ts_4*" "Teaching Styles = extrinsic" "Teacher Effort = ts_5", labels("\checkmark"  ""))
order(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2 _IterXWtgen_3)
coeflabels(Wtgender "Teacher G-Styping" _Iterm_t_2 "2-3 Year Exposure" _Iterm_t_3 "4 Year Exposure" _IterXWtgen_2 "2-3 Year Exposure*Teacher G-Styping"  _IterXWtgen_3 "4 Year Exposure*Teacher G-Styping")
star(* 0.1 ** 0.05 *** 0.01) 
nonotes 
s(p1 p2 p3 p6 p4 p5 N r2, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.0g %9.2f) labels("P-value: 2-3 Year E*G-Styp=Long*G-Styp" "P-value: 1 Year E*G-Styp=2-3 Year E*G-Styp" "P-value: 1 Year E*G-Styp=4 Year E*G-Styp" "P-value: 1 Year E*G-Sty[Girls=Boys]" "P-value: 2-3 Year E*G-Styp[Girls=Boys] " "P-value: 4 Year E*G-Sty[Girls=Boys]" "\hline N" "R-Squared") layout(@ @ @ "\multicolumn{2}{S}{@}" "\multicolumn{2}{S}{@}" "\multicolumn{2}{S}{@}" @ @))
nogaps
mtitles ("Girls" "Boys" "Girls" "Boys")
mgroups("Math Score" "Verbal Score", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
substitute(_ \_  \begin{tabular} "\adjustbox{max height=\dimexpr\textheight-5.5cm\relax,max width=\textwidth}{\begin{tabular}" \end{tabular} \end{tabular}} "&\multicolumn{2}{S}{" "\multicolumn{2}{c}{")
;
#delimit cr
est clear

*TEACHER SORTING: AGE
qui xi: reg math_std tmale male i.term_t*Wtgender  age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==0 & ts_2<=25, cluster(teachername)
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec1

qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & ts_2<=25, cluster(teachername) 
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec2

qui xi: reg math_std tmale male i.term_t*Wtgender  age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==0 & ts_2<=25
estimates store m1
qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & ts_2<=25
estimates store m2
suest m1 m2, cluster(teachername)
test [m1_mean]_IterXWtgen_2+[m1_mean]Wtgender=[m2_mean]_IterXWtgen_2+[m2_mean]Wtgender
estadd scalar p4=r(p),  : spec2 
test [m1_mean]_IterXWtgen_3+[m1_mean]Wtgender=[m2_mean]_IterXWtgen_3+[m2_mean]Wtgender
estadd scalar p5=r(p),  : spec2 
test [m1_mean]Wtgender=[m2_mean]Wtgender
estadd scalar p6=r(p),  : spec2 

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & ts_2<=25, cluster(teachername) 
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec3

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & ts_2<=25, cluster(teachername) 
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec4

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & ts_2<=25
estimates store m3
qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & ts_2<=25
estimates store m4
suest m3 m4, cluster(teachername)
test [m3_mean]_IterXWtgen_2+[m3_mean]Wtgender=[m4_mean]_IterXWtgen_2+[m4_mean]Wtgender
estadd scalar p4=r(p), : spec4 
test [m3_mean]_IterXWtgen_3+[m3_mean]Wtgender=[m4_mean]_IterXWtgen_3+[m4_mean]Wtgender
estadd scalar p5=r(p),  : spec4 
test [m3_mean]Wtgender=[m4_mean]Wtgender
estadd scalar p6=r(p),  : spec4 

#delimit ;
esttab spec1 spec2 spec3 spec4 using "table4a.tex", replace label compress  b(%8.3f) se(2) nonumbers
keep(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2  _IterXWtgen_3)
indicate("School Fixed Effects = *proximity*" "Student Characteristics = raven_std" "Family Characteristics = *ses*" "Teacher Characteristics = *ts_4*" "Teaching Styles = extrinsic" "Teacher Effort = ts_5", labels("\checkmark"  ""))
order(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2  _IterXWtgen_3)
coeflabels(Wtgender "Teacher G-Styping" _Iterm_t_2 "2-3 Year Exposure" _Iterm_t_3 "4 Year Exposure" _IterXWtgen_2 "2-3 Year Exposure*Teacher G-Styping"  _IterXWtgen_3 "4 Year Exposure*Teacher G-Styping")
star(* 0.1 ** 0.05 *** 0.01) 
nonotes 
s(p1 p2 p3 p6 p4 p5 N r2, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.0g %9.2f) labels("P-value: 2-3 Year E*G-Styp=Long*G-Styp" "P-value: 1 Year E*G-Styp=2-3 Year E*G-Styp" "P-value: 1 Year E*G-Styp=4 Year E*G-Styp" "P-value: 1 Year E*G-Sty[Girls=Boys]" "P-value: 2-3 Year E*G-Styp[Girls=Boys] " "P-value: 4 Year E*G-Sty[Girls=Boys]" "\hline N" "R-Squared") layout(@ @ @ "\multicolumn{2}{S}{@}" "\multicolumn{2}{S}{@}" "\multicolumn{2}{S}{@}" @ @))
nogaps
mtitles ("Girls" "Boys" "Girls" "Boys")
mgroups("Math Score" "Verbal Score", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
substitute(_ \_  \begin{tabular} "\adjustbox{max height=\dimexpr\textheight-5.5cm\relax,max width=\textwidth}{\begin{tabular}" \end{tabular} \end{tabular}} "&\multicolumn{2}{S}{" "\multicolumn{2}{c}{")
;
#delimit cr
est clear

*FACTUAL BELIEFS, REVERSE CAUSALITY
*remove teachers who (in their experience saw boys better at math)
tab ts_6

xi: reg math_std tmale male i.term_t*Wtgender  age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==0 & ts_6>1, cluster(teachername)
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec1

qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & ts_6>1, cluster(teachername) 
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec2

qui xi: reg math_std tmale male i.term_t*Wtgender  age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std  i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth  if male==0 & ts_6>1
estimates store m1
qui xi: reg math_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & ts_6>1
estimates store m2
suest m1 m2, cluster(teachername)
test [m1_mean]_IterXWtgen_2+[m1_mean]Wtgender=[m2_mean]_IterXWtgen_2+[m2_mean]Wtgender
estadd scalar p4=r(p),  : spec2 
test [m1_mean]_IterXWtgen_3+[m1_mean]Wtgender=[m2_mean]_IterXWtgen_3+[m2_mean]Wtgender
estadd scalar p5=r(p),  : spec2 
test [m1_mean]Wtgender=[m2_mean]Wtgender
estadd scalar p6=r(p),  : spec2 

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & ts_6>1, cluster(teachername) 
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec3

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & ts_6>1, cluster(teachername) 
test  _IterXWtgen_2+Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p1=r(p)
test  Wtgender= _IterXWtgen_2+Wtgender
estadd scalar p2=r(p)
test  Wtgender= _IterXWtgen_3+Wtgender
estadd scalar p3=r(p)
estimates store spec4

qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & ts_6>1
estimates store m3
qui xi: reg turkish_std tmale male i.term_t*Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses working_mom computer hhgender i.ts_4 ts_2 i.proximity  i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & ts_6>1 
estimates store m4
suest m3 m4, cluster(teachername)
test [m3_mean]_IterXWtgen_2+[m3_mean]Wtgender=[m4_mean]_IterXWtgen_2+[m4_mean]Wtgender
estadd scalar p4=r(p), : spec4 
test [m3_mean]_IterXWtgen_3+[m3_mean]Wtgender=[m4_mean]_IterXWtgen_3+[m4_mean]Wtgender
estadd scalar p5=r(p),  : spec4 
test [m3_mean]Wtgender=[m4_mean]Wtgender
estadd scalar p6=r(p),  : spec4 


#delimit ;
esttab spec1 spec2 spec3 spec4 using "table4.tex", replace label compress  b(%8.3f) se(2) nonumbers
keep(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2  _IterXWtgen_3)
indicate("School Fixed Effect = *proximity*" "Student Characteristics = raven_std" "Family Characteristics = *ses*" "Teacher Characteristics = *ts_4*" "Teaching Styles = extrinsic" "Teacher Effort = ts_5", labels("\checkmark"  ""))
order(Wtgender _Iterm_t_2 _Iterm_t_3 _IterXWtgen_2  _IterXWtgen_3)
coeflabels(Wtgender "Teacher G-Styping" _Iterm_t_2 "2-3 Year Exposure" _Iterm_t_3 "4 Year Exposure" _IterXWtgen_2 "2-3 Year Exposure*Teacher G-Styping"  _IterXWtgen_3 "4 Year Exposure*Teacher G-Styping")
star(* 0.1 ** 0.05 *** 0.01) 
nonotes 
s(p1 p2 p3 p6 p4 p5 N r2, fmt(%9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.0g %9.2f) labels("P-value: 2-3 Year E*G-Styp=Long*G-Styp" "P-value: 1 Year E*G-Styp=2-3 Year E*G-Styp" "P-value: 1 Year E*G-Styp=4 Year E*G-Styp" "P-value: 1 Year E*G-Sty[Girls=Boys]" "P-value: 2-3 Year E*G-Styp[Girls=Boys] " "P-value: 4 Year E*G-Sty[Girls=Boys]" "\hline N" "R-Squared") layout(@ @ @ "\multicolumn{2}{S}{@}" "\multicolumn{2}{S}{@}" "\multicolumn{2}{S}{@}" @ @))
nogaps
mtitles ("Girls" "Boys" "Girls" "Boys")
mgroups("Math Score" "Verbal Score", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 
substitute(_ \_  \begin{tabular} "\adjustbox{max height=\dimexpr\textheight-5.5cm\relax,max width=\textwidth}{\begin{tabular}" \end{tabular} \end{tabular}} "&\multicolumn{2}{S}{" "\multicolumn{2}{c}{")
;
#delimit cr
est clear
