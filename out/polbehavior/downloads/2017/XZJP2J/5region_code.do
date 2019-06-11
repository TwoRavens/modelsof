* FIVE-REGION STUDY
* Replication code for: "Pass the Buck If You Can: How Partisan Competition Triggers Attribution Bias in Multilevel Democracies"



* Dataset
// The study is copyrighted by the Centro de Investigaciones Sociologicas (www.cis.es). The dataset, questionaire, codebook, and related
// documentation are publicly available as Study no. 2734 at http://www.cis.es/cis/opencms/EN/formulario.jsp?dwld=/Microdatos/MD2734.zip.
// The 5region.dta file is a Stata version that includes only the variables used for the analyses in the paper.
// The variable names used here correspond to those in the original dataset.
use 5region_data.dta


* Data preparation

** Original variables
// p1301: national government attribution (1=A great deal, 4=Not at all)
// p1302: regional government attribution (1=A great deal, 4=Not at all)
// p12: regional economic performance (1=Much better, 5=Much worse)
// p901: regional government support (0-10)
// p38: territorial identity (1=Only Spanish, 5=Only region)
// p45: gender (1=male, 2=female)
// p46: age (in years, 99=NA)
// p47 p47a: education
// p33 p34 p35 p36 p3701 p3702: knowledge questions
// ccaa: region (1=Andalusia, 8=Castilla y León, 9=Catalonia, 12=Galicia, 16=Basque Country)
// peso: weight

** New variables
// compresp: net regional attribution (-1 to 1)
// econrret: regional economic performance (0-1)
// rgeval: regional government support (0-1)
// territid: territorial identity (0-1)
// educat4: educational attainment (4 levels, 0-1)
// polknow: political knowledge index
// regincumb: in-/out-party regional incumbent
// natrinc: nationalist/non-nationalist regional incumbent 

recode p1301 p1302 (1=1)(2=.67)(3=.33)(4=0)(*=.), gen(resp_nat resp_reg)
gen compresp=resp_reg-resp_nat

recode p12 (1=1) (2=.75) (3=.5) (4=.25) (5=0) (*=.), gen(econrret)

recode p901 (98 99=.), gen(rgeval)
replace rgeval=rgeval/10

recode p38 (1=0)(2=.25)(3=.5)(4=.75)(5=1)(*=.), gen(territid)

recode p45 (1=0)(2=1), gen(female)

recode p46 (99=.), gen(age)

recode p47a (1=0 "No")(2=1 "Primary")(3 4=2 "Secondary 1st")(5 6=3 "Secondary 2nd")(7 8=4 "Tertiary 1st")(9 10=5 "Tertiary 2nd") ///
 (11=6 "Postgraduate")(98 99=.), gen(education)
recode education (.=0) if p47==1 | p47==2
recode education (0 1=0 "Primary or less")(2=1 "Lower secondary")(3=2 "Higher secondary")(4/6=3 "University"), gen(educat4)

recode p33 p34 p35 p36 p3701 p3702 (1=1)(*=0), gen(know1 know2 know3 know4 know5a know5b)
alpha know*, item gen(polknow)

recode ccaa (1 9 12=0 "In-party")(8 16=1 "Out-party"), gen(regincumb)

recode ccaa (1 8 9 12=0 "Non-nationalist")(16=1 "Nationalist"), gen(natrinc)

gen region="Andalucia" if ccaa==1
replace region="Castilla y Leon" if ccaa==8
replace region="Catalonia" if ccaa==9
replace region="Galicia" if ccaa==12
replace region="Basque Country" if ccaa==16


* Table 4
levelsof region, local(levels)
foreach l of local levels {
 display "`l'"
 reg compresp female age i.educat4 polknow c.econrret##c.rgeval c.econrret##c.territid [iw=peso] if region=="`l'"
}


* Figure 3
levelsof region, local(levels)
foreach l of local levels {
 qui reg compresp female age i.educat4 polknow c.econrret##c.rgeval c.econrret##c.territid [iw=peso] if region=="`l'"
 margins, at(econrret=(0(.1)1) rgeval=(0 1))
 marginsplot, ylabel(-.8(.4).8) title("`l'") ytitle("Net regional attribution") xtitle("Regional economic performance") ///
  plot(rgeval, lab("Opponent" "Supporter")) legend(subtitle("Government support", size(small)) size(small))
 graph save "f3_`l'.gph", replace
}

graph combine "f3_Andalucia.gph" "f3_Castilla y Leon.gph" "f3_Catalonia.gph" "f3_Galicia.gph" "f3_Basque Country.gph", col(3)


* Figure 4
levelsof region, local(levels)
foreach l of local levels {
 qui reg compresp female age i.educat4 polknow c.econrret##c.rgeval c.econrret##c.territid [iw=peso] if region=="`l'"
 margins, at(econrret=(0(.1)1) territid=(0 1))
 marginsplot, ylabel(-.8(.4).8) title("`l'") ytitle("Net regional attribution") xtitle("Regional economic performance") ///
  plot(territid, lab("Only Spanish" "Only region")) legend(subtitle("Territorial identity", size(small)) size(small))
 graph save "f4_`l'.gph", replace
}

graph combine "f4_Andalucia.gph" "f4_Castilla y Leon.gph" "f4_Catalonia.gph" "f4_Galicia.gph" "f4_Basque Country.gph", col(3)


* Table C1
levelsof region, local(levels)
foreach l of local levels {
 display "`l'"
 reg compresp female age i.educat4 polknow c.econrret##c.rgeval [iw=peso] if region=="`l'" & territid<.
}


* Table C2
levelsof region, local(levels)
foreach l of local levels {
 display "`l'"
 reg compresp female age i.educat4 polknow c.econrret##c.territid [iw=peso] if region=="`l'" & rgeval<.
}


* Table D1
** Model 1
reg compresp female age i.educat4 polknow c.econrret##c.rgeval##regincumb [iw=peso] if territid<.

** Model 2
reg compresp female age i.educat4 polknow c.econrret##c.territid##natrinc [iw=peso] if rgeval<.

** Model 3
reg compresp female age i.educat4 polknow c.econrret##c.rgeval##regincumb c.econrret##c.territid##natrinc [iw=peso] 


* Figure D1
qui reg compresp female age i.educat4 polknow c.econrret##c.rgeval##regincumb c.econrret##c.territid##natrinc [iw=peso] 
margins regincumb, at(econrret=(0(.1)1) rgeval=(0 1))
marginsplot, by(regincumb) byopt(title("")) ylabel(-.6(.3).6) ytitle("Net regional attribution") xtitle("Regional economic performance") ///
  plot(rgeval, lab("Opponent" "Supporter")) legend(subtitle("Government support", size(small)) size(small))


* Figure D2
qui reg compresp female age i.educat4 polknow c.econrret##c.rgeval##regincumb c.econrret##c.territid##natrinc [iw=peso] 
margins natrinc, at(econrret=(0(.1)1) territid=(0 1))
marginsplot, by(natrinc) byopt(title("")) ylabel(-.6(.3).6) ytitle("Net regional attribution") xtitle("Regional economic performance") ///
  plot(territid, lab("Only Spanish" "Only region")) legend(subtitle("Territorial identity", size(small)) size(small))


