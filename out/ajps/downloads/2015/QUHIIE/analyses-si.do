clear all

** Sample characteristics - Students
use "students_working.dta", clear
keep idno imp issuetag2 female democrat republican
reshape wide imp, i(idno female democrat republican) j(issuetag2) string // Reshape so there is one row per person
drop imp* // These were included just to make the reshape command work.

* The 100% for age 18-29 here was not measured, but instead comes from it being
* a student sample. (I saw them in person and there were no older students.)

prop female
prop democrat
prop republican

* The 100% for "some college" comes from these all being college students

** Sample characteristics - MTurkA
use "mturka_working.dta", clear
keep idno imp issuetag2 female democrat republican agebin educ2
reshape wide imp, i(idno female democrat republican agebin educ2) j(issuetag2) string // Reshape so there is one row per person
drop imp* // These were included just to make the reshape command work.

prop agebin
prop female
prop democrat
prop republican
prop educ2

* Sample characteristics - MTurkB
use "mturkb_working.dta", clear
keep idno imp issuetag2 agebin female
reshape wide imp, i(idno agebin female) j(issuetag2) string

prop agebin
prop female

* Sample characteristics - SSI
use "ssi_working.dta", clear
keep idno imp issuetag agebin female democrat republican educ incomee race
reshape wide imp, i(idno agebin female democrat republican educ incomee race) j(issuetag) string

prop agebin
prop female
prop democrat
prop republican
prop educ
prop incomee // Note that categories are not in order.
prop race

* Sample characteristics - GfK
use "GfKWorking.dta", clear
svyset [pw=weight]
svy: prop agebin
svy: prop female
svy: prop educcat
svy: prop inccat
svy: prop race

* Descriptive statistics, Student sample
use "students_working.dta", clear
* (AF=Afghanistan; CB=Collective bargaining; GM=Same-sex marriage; SC=Stem Cell; SS=Social Security)
* Provides the first row of each table in the SI.
table issue, c(mean extfold median extfold sd extfold)
* Provides the second row of each table
table issue, c(mean imp median imp sd imp)
* Provides the third row of each table
table issue, c(mean relev median relev sd relev)
* Provides the fourth row of each table
table issue, c(mean smor median smor sd smor)
* Provides the fifth row of each table
table issue, c(mean comp median comp sd comp)

* Descriptive statistics, MTurkA
use "mturka_working.dta", clear
* AF=Afghanistan; CB=Collective bargaining; GM=Same-sex marriage; SC=Stem Cell; SS=Social Security
* Provides the first row of each table
table issue, c(mean extfold median extfold sd extfold)
* Provides the second row of each table
table issue, c(mean imp median imp sd imp)
* Provides the third row of each table
table issue, c(mean relev median relev sd relev)
* Provides the fourth row of each table
table issue, c(mean smor median smor sd smor)
* Provides the fifth row of each table
table issue, c(mean comp median comp sd comp)

* Descriptive statistics, MTurkB
use "mturkb_working.dta", clear
* CB=Col. Bargaining; CT=Corporate Taxation; ep=renewable energy; sc=stem cell; ss=social security
table issue, c(mean extfold median extfold sd extfold)
* Provides the second row of each table
table issue, c(mean imp median imp sd imp)
* Provides the third row of each table
table issue, c(mean relev median relev sd relev)
* Provides the fourth row of each table
table issue, c(mean smor median smor sd smor)
* Provides the fifth row of each table
table issue, c(mean comp median comp sd comp)

* Descriptive statistics, SSI
use "ssi_working.dta", clear
* CB=Col. Bargaining; CT=Corporate Taxation; ep=renewable energy; sc=stem cell; ss=social security
table issue, c(mean extfold median extfold sd extfold)
* Provides the second row of each table
table issue, c(mean imp median imp sd imp)
* Provides the third row of each table
table issue, c(mean relev median relev sd relev)
* Provides the fourth row of each table
table issue, c(mean smor median smor sd smor)
* Provides the fifth row of each table
table issue, c(mean comp median comp sd comp)

* Descriptive statistics, GfK
use "GfKWorking.dta", clear
sum extfold, detail // Examine mean, 50%, and std. dev.
sum imp, detail
sum relev, detail
sum mc, detail
sum income, detail
sum dpidstr, detail
sum rpidstr, detail
sum church, detail
sum comppref, detail
sum wta, detail

* Correlations among attitude measures, Student sample
use "students_working.dta", clear
* (AF=Afghanistan; CB=Collective bargaining; GM=Same-sex marriage; SC=Stem Cell; SS=Social Security)
corr extfold imp relev smor if issuetag2=="cb"
corr extfold imp relev smor if issuetag2=="ss"
corr extfold imp relev smor if issuetag2=="gm"
corr extfold imp relev smor if issuetag2=="sc"
corr extfold imp relev smor if issuetag2=="af"

* Correlations among attitude measures, MTurkA sample
use "mturka_working.dta", clear
* (AF=Afghanistan; CB=Collective bargaining; GM=Same-sex marriage; SC=Stem Cell; SS=Social Security)
corr extfold imp relev smor if issuetag2=="cb"
corr extfold imp relev smor if issuetag2=="ss"
corr extfold imp relev smor if issuetag2=="gm"
corr extfold imp relev smor if issuetag2=="sc"
corr extfold imp relev smor if issuetag2=="af"

* Correlations among attitude measures, MTurkB sample
use "mturkb_working.dta", clear
* CB=Col. Bargaining; CT=Corporate Taxation; ep=renewable energy; sc=stem cell; ss=social security
corr extfold imp relev smor if issuetag2=="cb"
corr extfold imp relev smor if issuetag2=="ss"
corr extfold imp relev smor if issuetag2=="ct"
corr extfold imp relev smor if issuetag2=="sc"
corr extfold imp relev smor if issuetag2=="ep"

* Correlations among attitude measures, SSI sample
use "ssi_working.dta", clear
* CB=Col. Bargaining; CT=Corporate Taxation; ep=renewable energy; sc=stem cell; ss=social security
corr extfold imp relev smor if issuetag2=="cb"
corr extfold imp relev smor if issuetag2=="ss"
corr extfold imp relev smor if issuetag2=="ct"
corr extfold imp relev smor if issuetag2=="sc"
corr extfold imp relev smor if issuetag2=="ep"

* Factor analysis, Student sample
* (Examine rotated factor loadings)
use "students_working.dta", clear
keep idno issuetag2 extfold imp relev *smor*
reshape wide extfold imp relev smor*, i(idno) j(issuetag2) string // Reshape so there is one row per person
factor extfoldcb impcb relevcb smor1cb smor2cb smor3cb // Collective bargaining
rotate, oblimin oblique blank(.1)
factor extfoldss impss relevss smor1ss smor2ss smor3ss // Social Security
rotate, oblimin oblique blank(.1)
factor extfoldsc impsc relevsc smor1sc smor2sc smor3sc // Stem cell
rotate, oblimin oblique blank(.1)
factor extfoldgm impgm relevgm smor1gm smor2gm smor3gm // Same-sex marriage
rotate, oblimin oblique blank(.1)
factor extfoldaf impaf relevaf smor1af smor2af smor3af // Afghanistan
rotate, oblimin oblique blank(.1)

* Factor analysis, MTurkA sample
* (Examine rotated factor loadings)
use "mturka_working.dta", clear
keep idno issuetag2 extfold imp relev *smor*
reshape wide extfold imp relev smor*, i(idno) j(issuetag2) string // Reshape so there is one row per person
factor extfoldcb impcb relevcb smor1cb cbsmor2  // Collective bargaining
rotate, oblimin oblique blank(.1)
factor extfoldss impss relevss smor1ss sssmor2  // Social Security
rotate, oblimin oblique blank(.1)
factor extfoldsc impsc relevsc smor1sc scsmor2  // Stem cell
rotate, oblimin oblique blank(.1)
factor extfoldgm impgm relevgm smor1gm gmsmor2  // Same-sex marriage
rotate, oblimin oblique blank(.1)
factor extfoldaf impaf relevaf smor1af afsmor2  // Afghanistan
rotate, oblimin oblique blank(.1)

* Factor analysis, MTurkb sample
* (Examine rotated factor loadings)
use "mturkb_working.dta", clear
keep idno issuetag2 extfold imp relev *smor*
reshape wide extfold imp relev smor*, i(idno) j(issuetag2) string // Reshape so there is one row per person
factor extfoldcb impcb relevcb smor1cb smor2cb  // Collective bargaining
rotate, oblimin oblique blank(.1)
factor extfoldss impss relevss smor1ss smor2ss  // Social Security
rotate, oblimin oblique blank(.1)
factor extfoldct impct relevct smor1ct smor2ct  // Corporate taxes
rotate, oblimin oblique blank(.1)
factor extfoldsc impsc relevsc smor1sc smor2sc  // Stem cell
rotate, oblimin oblique blank(.1)
factor extfoldep impep relevep smor1ep smor2ep  // Environment
rotate, oblimin oblique blank(.1)

* Factor analysis, SSI sample
* (Examine rotated factor loadings)
use "ssi_working.dta", clear
keep idno issuetag2 extfold imp relev *smor*
reshape wide extfold imp relev smor*, i(idno) j(issuetag2) string // Reshape so there is one row per person
factor extfoldcb impcb relevcb smor1cb smor2cb  // Collective bargaining
rotate, oblimin oblique blank(.1)
factor extfoldss impss relevss smor1ss smor2ss  // Social Security
rotate, oblimin oblique blank(.1)
factor extfoldct impct relevct smor1ct smor2ct  // Corporate taxes
rotate, oblimin oblique blank(.1)
factor extfoldsc impsc relevsc smor1sc smor2sc  // Stem cell
rotate, oblimin oblique blank(.1)
factor extfoldep impep relevep smor1ep smor2ep  // Environment
rotate, oblimin oblique blank(.1)

* Single Moral Conviction measure
use "students_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor1 i.issue, fe vce(cluster idno)
use "mturka_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor1 i.issue, fe vce(cluster idno)
use "mturkb_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor2 i.issue, fe vce(cluster idno)
use "ssi_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor2 i.issue, fe vce(cluster idno)

* Summary intensity measure
use "students_working.dta", clear
alpha extfold imp, gen(intense) // Alpha = .52
xtset idno
xtreg comp intense relev smor i.issue, fe vce(cluster idno)
use "mturka_working.dta", clear
alpha extfold imp, gen(intense) // Alpha = .56
xtset idno
xtreg comp intense relev smor i.issue, fe vce(cluster idno)
use "mturkb_working.dta", clear
alpha extfold imp, gen(intense) // Alpha = .65
xtset idno
xtreg comp intense relev smor i.issue, fe vce(cluster idno)
use "ssi_working.dta", clear
alpha extfold imp, gen(intense) // Alpha = .58
xtset idno
xtreg comp intense relev smor i.issue, fe vce(cluster idno)

* The interaction of extremity and importance
use "students_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor i.issue, fe vce(cluster idno)
xtreg comp c.extfold##c.imp relev smor i.issue, fe vce(cluster idno)
use "mturka_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor i.issue, fe vce(cluster idno)
xtreg comp c.extfold##c.imp relev smor i.issue, fe vce(cluster idno)
use "mturkb_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor i.issue, fe vce(cluster idno)
xtreg comp c.extfold##c.imp relev smor i.issue, fe vce(cluster idno)
use "ssi_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor i.issue, fe vce(cluster idno)
xtreg comp c.extfold##c.imp relev smor i.issue, fe vce(cluster idno)


* Study 5
use "deliberate.dta", clear
xtset subjid
xtreg compromise issmor issrelev issimp issextfoldt1, vce(cluster subjid)
xtreg compromise issmor issrelev issimp issextfoldt1, fe vce(cluster subjid) // fixed effects model discussed in footnote

* Seemingly unrelated regression models
* Students
use "students_working.dta", clear
keep idno imp comp extfold relev smor issuetag2
reshape wide imp comp extfold relev smor, i(idno) j(issuetag2) string // Reshape so there is one row per person
sureg   (compcb extfoldcb impcb relevcb smorcb) ///
		(compss extfoldss impss relevss smorss) ///
		(compgm extfoldgm impgm relevgm smorgm) ///
		(compsc extfoldsc impsc relevsc smorsc) ///
		(compaf extfoldaf impaf relevaf smoraf) 

est store uncons
di e(ll)

constraint 1 [compcb]smorcb = [compss]smorss
constraint 2 [compss]smorss = [compsc]smorsc
constraint 3 [compsc]smorsc = [compgm]smorgm
constraint 4 [compgm]smorgm = [compaf]smoraf

sureg   (compcb extfoldcb impcb relevcb smorcb) ///
		(compss extfoldss impss relevss smorss) ///
		(compgm extfoldgm impgm relevgm smorgm) ///
		(compsc extfoldsc impsc relevsc smorsc) ///
		(compaf extfoldaf impaf relevaf smoraf), c(1 2 3 4) 
est store cons
di e(ll)
lrtest uncons cons

* MTurkA
use "mturka_working.dta", clear
keep idno imp comp extfold relev smor issuetag2
reshape wide imp comp extfold relev smor, i(idno) j(issuetag2) string // Reshape so there is one row per person
sureg   (compcb extfoldcb impcb relevcb smorcb) ///
		(compss extfoldss impss relevss smorss) ///
		(compgm extfoldgm impgm relevgm smorgm) ///
		(compsc extfoldsc impsc relevsc smorsc) ///
		(compaf extfoldaf impaf relevaf smoraf) 

est store uncons
di e(ll)

constraint 1 [compcb]smorcb = [compss]smorss
constraint 2 [compss]smorss = [compsc]smorsc
constraint 3 [compsc]smorsc = [compgm]smorgm
constraint 4 [compgm]smorgm = [compaf]smoraf

sureg   (compcb extfoldcb impcb relevcb smorcb) ///
		(compss extfoldss impss relevss smorss) ///
		(compgm extfoldgm impgm relevgm smorgm) ///
		(compsc extfoldsc impsc relevsc smorsc) ///
		(compaf extfoldaf impaf relevaf smoraf), c(1 2 3 4) 
est store cons
di e(ll)
lrtest uncons cons

* MTurkB
use "mturkb_working.dta", clear
keep idno imp comp extfold relev smor issuetag2
reshape wide imp comp extfold relev smor, i(idno) j(issuetag2) string // Reshape so there is one row per person
sureg   (compcb extfoldcb impcb relevcb smorcb) ///
		(compss extfoldss impss relevss smorss) ///
		(compct extfoldct impct relevct smorct) ///
		(compsc extfoldsc impsc relevsc smorsc) ///
		(compep extfoldep impep relevep smorep) 

est store uncons
di e(ll)

constraint 1 [compcb]smorcb = [compss]smorss
constraint 2 [compss]smorss = [compsc]smorsc
constraint 3 [compsc]smorsc = [compct]smorct
constraint 4 [compct]smorct = [compep]smorep

sureg   (compcb extfoldcb impcb relevcb smorcb) ///
		(compss extfoldss impss relevss smorss) ///
		(compct extfoldct impct relevct smorct) ///
		(compsc extfoldsc impsc relevsc smorsc) ///
		(compep extfoldep impep relevep smorep), c(1 2 3 4) 
est store cons
di e(ll)
lrtest uncons cons

* SSI
use "ssi_working.dta", clear
keep idno imp comp extfold relev smor issuetag2
reshape wide imp comp extfold relev smor, i(idno) j(issuetag2) string // Reshape so there is one row per person
sureg   (compcb extfoldcb impcb relevcb smorcb) ///
		(compss extfoldss impss relevss smorss) ///
		(compct extfoldct impct relevct smorct) ///
		(compsc extfoldsc impsc relevsc smorsc) ///
		(compep extfoldep impep relevep smorep) 

est store uncons
di e(ll)

constraint 1 [compcb]smorcb = [compss]smorss
constraint 2 [compss]smorss = [compsc]smorsc
constraint 3 [compsc]smorsc = [compct]smorct
constraint 4 [compct]smorct = [compep]smorep

sureg   (compcb extfoldcb impcb relevcb smorcb) ///
		(compss extfoldss impss relevss smorss) ///
		(compct extfoldct impct relevct smorct) ///
		(compsc extfoldsc impsc relevsc smorsc) ///
		(compep extfoldep impep relevep smorep), c(1 2 3 4) 
est store cons
di e(ll)
lrtest uncons cons

* Full Models for Table 5
* Please see analyses.do. Full results are produced there.
