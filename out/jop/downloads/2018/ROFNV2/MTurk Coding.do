*************** MTurk Survey Coding ***************

* Note: Open-ended items are named econ_open1-econ_open3. See the online appendix for the coding rubric and results.

*Demographics*

gen age=d1
recode age 2727=27
recode01 age

gen male=d2 
recode male 2=0

gen black=d3
recode black 2=1 else=0

gen hisp=d3
recode hisp 3=1 else=0

gene educ=d4
tab educ, gen(educ)
recode01 educ

gen unemp=d5
recode unemp 2=1 3=1 else=0

gen union=d6
recode union 2=0

gen income=d7
recode01 income

*Basic Politics*

gen interest=d8
recode01 interest

gen pid=.
replace pid=0 if d10==1 & d11a==1
replace pid=1 if d10==1 & d11a==2
replace pid=2 if (d10==3|d10==4|d10==5) & d12==2
replace pid=3 if (d10==3|d10==4|d10==5) & d12==3
replace pid=4 if (d10==3|d10==4|d10==5) & d12==1
replace pid=5 if d10==2 & d11b==2
replace pid=6 if d10==2 & d11b==1
recode01 pid

gen ideo=d13
recode01 ideo

*General Political Knowledge*

gen know1=d14
recode know1 2=1 else=0

gen know2=d15
recode know2 4=1 else=0

gen know3=d16
recode know3 1=1 else=0

gen know4=d17
recode know4 1=1 else=0

gen know5=d18
recode know5 1=1 else=0

gen know6=d19
recode know6 5=5 else=0

gen know7=d20
recode know7 3=1 else=0

drop know
gen know=know1+know2+know3+know4+know5+know6+know7
recode01 know

*** Closed-ended economist items ***

* Which of the following is closest to 'professional economist'?"
*1=Academic or professor
*2=Investor or banker
*3=Journalist
*4=Govt. official
*5=Think tank researcher
*6=Blogger
*7=Politician
*8=Consultant

gen econ_job=econ_clos1

* Ideology of typical economist (only 3% DKs) *

gen econ_ideo=econ_clos2
recode econ_ideo 8=.

* How often read articles by economists? *

gen econ_read=econ_clos3

* How often see on cable or network news? *

gen econ_tv=econ_clos4

*** Identification of prominant economists ***

gen krugman=econ_id1
recode krugman 1=1 2/10=0

gen yellen=econ_id2
recode yellen 1=1 2/10=0

gen cowen=econ_id3
recode cowen 1=1 2/10=0

gen piketty=econ_id4
recode piketty 1=1 2/10=0

gen mankiw=econ_id5
recode mankiw 1=1 2/10=0

gen bernanke=econ_id6
recode bernanke 1=1 2/10=0

gen greenspan=econ_id7
recode greenspan 1=1 2/10=0

gen econ_know=krugman+yellen+cowen+piketty+mankiw+bernanke+greenspan





































