* ==============================================================================
* PART II: Constructing the measures
* Date: Feb 2018
* 
* 1_measures
* Data: gstyping.dta
* 
*
* ==============================================================================
*STUDENT GENDER STYPING SCORE*
order ss_gender_1, before(ss_gender_2)
order ss_gender_3, after(ss_gender_2)
order ss_gender_4, after(ss_gender_3)
order ss_gender_5, after(ss_gender_4)
order ss_gender_6, after(ss_gender_5)
order ss_gender_7, after(ss_gender_6)
egen raw_gender= rowtotal(ss_gender_1-ss_gender_7)
*reverse the measuer: 4-likert scale, 7 questions 7*4=28
gen sum_stu_gender= 35-raw_gender
egen zstud_gender= std(sum_stu_gender)


*STUDENT GROWTH MINDSET SCORE*
gen gms_stud=ss_gms_1+ss_gms_2
replace gms_stud=. if missing(ss_gms_1) | missing(ss_gms_2)
egen zgms_stud= std(gms_stud)

*TEACHER GENDER STYPING SCORE*
preserve
collapse ts_gender_1-ts_gender_9 , by(teachername)
sem (ts_gender_1-ts_gender_9 <- Gender1), var(Gender1@1) method(mlmv) nolog	   
predict t1, latent(Gender1) 
egen tgender_sem1=std(t1)
tempfile formerge
save `formerge', replace
restore
merge m:m teachername using `formerge'
drop _merge
*winsoring the measure
winsor tgender_sem1, gen(Wtgender) p(0.05) high

*TEACHER GROWTH MINDSET SCORE*
egen gms = rowtotal(ts_gms_1-ts_gms_5)
*TEACHER EXTRINSIC VS INTRINSIC MOTIVATOR*
egen extrinsic = rowtotal(ts_ext_1-ts_ext_4)
*TEACHER CONSTRUCTIVE TEACHING SCORE*
egen constructive = rowtotal(ts_modern_1-ts_modern_6)
*TEACHER WARMTH*
egen warmth = rowtotal(ts_warmth_1-ts_warmth_4)

*TRADITIONAL VS PROGRESSIVE TEACHERS* 
sum Wtgender,d
egen medtbias=pctile(Wtgender), p(50)
ge hightbias=1 if Wtgender>=medtbias
replace hightbias=0 if Wtgender<medtbias

*LOW/MEDIUM/HIGH SES*
ge lowses=1 if ses==1
replace lowses=0 if ses==2 | ses==3
ge medses=1 if ses==2
replace medses=0 if ses==1 | ses==3
ge highses=1 if ses==3
replace highses=0 if ses==1 | ses==2

*SHORT/MEDIUM/LONG TERM TEACHING*
gen term_t=0
replace term_t=1 if tss_no_teach==1 | tss_no_teach==1.5 | tss_no_teach==2 
replace term_t=2 if tss_no_teach==3| tss_no_teach==4 | tss_no_teach==5 | tss_no_teach==6
replace term_t=3 if tss_no_teach==7 | tss_no_teach==8
replace term_t=. if missing(tss_no_teach)

*LONG TERM DUMMY
ge lterm=1 if term_t==3
replace lterm=0 if term_t~=3
ge termbiasl=hightbias*lterm 

label define term_t 1 "Short Term" 2 "Medium Term" 3 "Long Term"
label values term_t term_t
label variable zstud_gender "standardized  student gender styping scores measure:7 items" 
label variable gms  "sum score for teacher GMS" 
label variable extrinsic  "sum score for teacher extrinsic motivator" 
label variable constructive  "sum score for constructive teaching styles" 
label variable warmth  "sum score for teacher warmth" 
label variable tgender_sem1  "estimated latent variable for teacher's gender bias:9 items" 
label variable zgms_stud  "standardized student growth mindset score" 
label variable Wtgender " Winsorized Teacher gender styping score"
label variable hightbias "Traditional Teachers - derived from teacher gender styping score"
label variable term_t "Short/Medium/Long Term - Teacher"
label variable lterm "Long term dummy"
label variable termbiasl "lterm*hightbias"
