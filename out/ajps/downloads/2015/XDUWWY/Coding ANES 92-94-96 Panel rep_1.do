***Coding 92-94-96 ANES Panel
use "/Users/lily/Desktop/data/anes_panel_1992to1997_dta/anes_prunedforstata_1992to1996.dta"

***1992
***Political identities
///Party identity
gen pid92=V923634
recode pid92 9=. 8=. 7=.
replace pid92=(1-(pid92/6))
label variable pid92 "7-point PID Dem=hi"

///Ideological identity
gen ideo92=V923509
recode ideo92 9=. 8=. 0=.
replace ideo92=3 if V923512==1
replace ideo92=4 if V923512==3
replace ideo92=5 if V923512==5
replace ideo92=(1-((ideo92-1)/6))
label variable ideo92 "Ideology Liberal=hi"

///Party dummy
gen demrep92=1 if V923631==2 | V923633==5 
replace demrep92=0 if V923631==1 | V923633==1 
label variable demrep92 "Dem/Rep Dummy including leaners, 1=Dem"

///Partisan strength
gen pidstr92=3 if V923632==1 
replace pidstr92=2 if V923632==5
replace pidstr92=1 if V923633==1 | V923633==5
replace pidstr92=0 if V923633==3 
replace pidstr92=pidstr92/3
label variable pidstr92 "Partisan strength, hi=strong"

///Ideological strength
gen ideostr92=3 if V923509==1 | V923509 ==7
replace ideostr92 =2 if V923509 ==2 | V923509 ==6
replace ideostr92 =1 if V923509 ==3 | V923509 ==5 | V923512==1 | V923512==5
replace ideostr92 =0 if V923509 ==4 | V923512==3 
replace ideostr92=ideostr92/3
label variable ideostr92 "Ideological strength, hi=strong"

//Partisan strength coded 1-4
gen pidstr192=4 if V923632==1 
replace pidstr192=3 if V923632==5
replace pidstr192=2 if V923633==1 | V923633==5
replace pidstr192=1 if V923633==3 
label variable pidstr192 "Partisan strength, 1 to 4, 4=strong"

///Ideological strength coded 1-4
gen ideostr192=4 if V923509==1 | V923509 ==7
replace ideostr192 =3 if V923509 ==2 | V923509 ==6
replace ideostr192 =2 if V923509 ==3 | V923509 ==5 | V923512==1 | V923512==5
replace ideostr192 =1 if V923509 ==4 | V923512==3
label variable ideostr192 "Ideological strength, hi=strong"
label variable ideostr192 "Ideological strength, 1 to 4, 4=strong"

//Partisan and Ideological strength
gen pidideostr192=pidstr192*ideostr192

//Alignment between party and ideology
gen pid192=V923634
recode pid192 9=. 8=. 7=.
replace pid192= pid192+1

gen ideo192= V923509
recode ideo192 9=. 8=. 0=.
replace ideo192=3 if V923512==1
replace ideo192=4 if V923512==3
replace ideo192=5 if V923512==5

gen overlap92=abs(pid192-ideo192)+1

omscore overlap92
replace overlap92=rr_overlap92

label variable overlap92 "overlap between identities, hi=most overlap"

//Sorting 
gen overlapxstr92=overlap92*pidideostr192
gen idcomplexity92=(overlapxstr92)/112

***Thermometer Bias
recode V923317 999=. 998=.
recode V923318 999=. 998=.
gen demtherm92=V923317/100
gen reptherm92=V923318/100

gen thermbias92=abs(demtherm92-reptherm92)
label variable thermbias92 "Difference btwn Dem and Rep Party thermometers"

gen outtherm92=demtherm92 if demrep92==0
replace outtherm92=reptherm92 if demrep92==1

***Likes/Dislikes
gen demlike192=1 if V923402>0
replace demlike192=0 if demlike192==.
gen demlike292=1 if V923403>0
replace demlike292=0 if demlike292==.
gen demlike392=1 if V923404>0
replace demlike392=0 if demlike392==.
gen demlike492=1 if V923405>0
replace demlike492=0 if demlike492==.
gen demlike592=1 if V923406>0
replace demlike592=0 if demlike592==.

gen demlikes92=demlike192+demlike292+demlike392+demlike492+demlike592

gen demdislike192=1 if V923408>0
replace demdislike192=0 if demdislike192==.
gen demdislike292=1 if V923409>0
replace demdislike292=0 if demdislike292==.
gen demdislike392=1 if V923410>0
replace demdislike392=0 if demdislike392==.
gen demdislike492=1 if V923411>0
replace demdislike492=0 if demdislike492==.
gen demdislike592=1 if V923412>0
replace demdislike592=0 if demdislike592==.

gen demdislikes92=demdislike192+demdislike292+demdislike392+demdislike492+demdislike592

gen replike192=1 if V923414>0
replace replike192=0 if replike192==.
gen replike292=1 if V923415>0
replace replike292=0 if replike292==.
gen replike392=1 if V923416>0
replace replike392=0 if replike392==.
gen replike492=1 if V923417>0
replace replike492=0 if replike492==.
gen replike592=1 if V923418>0
replace replike592=0 if replike592==.

gen replikes92=replike192+replike292+replike392+replike492+replike592

gen repdislike192=1 if V923420>0
replace repdislike192=0 if repdislike192==.
gen repdislike292=1 if V923421>0
replace repdislike292=0 if repdislike292==.
gen repdislike392=1 if V923422>0
replace repdislike392=0 if repdislike392==.
gen repdislike492=1 if V923423>0
replace repdislike492=0 if repdislike492==.
gen repdislike592=1 if V923424>0
replace repdislike592=0 if repdislike592==.

gen repdislikes92=repdislike192+repdislike292+repdislike392+repdislike492+repdislike592


gen demlikesminusdis92=(demlikes92-demdislikes92)+5
gen replikesminusdis92=(replikes92-repdislikes92)+5


gen likebias92=abs(demlikesminusdis92-replikesminusdis92)
replace likebias92=likebias92/10
label variable likebias92 "Dif between Dem and Rep like scores(#like minus #dis), hi=biggest diff, lo=same# of likes/dislikes for each party"

***ACTIVISM
gen talk92=1 if V925807==1
replace talk92=0 if talk92==.

gen button92=1 if V925809==1
replace button92=0 if button92==.

gen rallies92=1 if V925810==1
replace rallies92=0 if rallies92==.

gen work92=1 if V925812==1
replace work92=0 if work92==.

gen givecand92=1 if V925815==1
replace givecand92=0 if givecand92==.

gen giveparty92=1 if V925817==1
replace giveparty92=0 if giveparty92==.

gen pastactiv92=talk92+button92+rallies92+work92+givecand92+giveparty92
replace pastactiv92=pastactiv92/6


***ANGER
gen bushanger92=1 if V923501==1 
replace bushanger92=0 if bushanger92==.

gen clintonanger92=1 if V923505==1
replace clintonanger92=0 if clintonanger92==.

gen angercand92=1 if bushanger92==1 & demrep92==1 | clintonanger92==1 & demrep==0
replace angercand92=0 if angercand92==.
label variable angercand92 "anger at outgroup pres candidate, 1=felt anger"

***Issues

***strong abortion position dummy
gen abortionstr92=1 if V923732==4 | V923732==1
replace abortionstr92=0 if V923732==2 | V923732==3

***abortion position
gen abortion92=V923732
recode abortion92 9=. 8=. 7=. 6=.
replace abortion92=(abortion92-1)/3
label variable abortion92 "1992 when should abortion be allowed by law, 1=always"



***Government services/spending strength
gen govspendstr92=0 if V923701==4
replace govspendstr92=1 if V923701==5 | V923701==3
replace govspendstr92=2 if V923701==2 | V923701==6
replace govspendstr92=3 if V923701==1 | V923701==7
replace govspendstr92=(govspendstr92)/3

***Government services/spending
gen govspend92=V923701
recode govspend92 9=. 8=. 0=.
replace govspend92=(govspend92-1)/6
label variable govspend92 "gov services vs spending, 1=many more servic&spending"


***Government health insurance strength
gen govhealthstr92=0 if V923716==4
replace govhealthstr92=1 if V923716==5 | V923716==3
replace govhealthstr92=2 if V923716==2 | V923716==6
replace govhealthstr92=3 if V923716==1 | V923716==7
replace govhealthstr92=(govhealthstr92)/3

***Government health insurance
gen govhealth92=V923716
recode govhealth92 9=. 8=. 0=.
replace govhealth92=(1-((govhealth92-1)/6))
label variable govhealth92 "gov/private health insurance, 1=gov insurance plan"



***Aid to Blacks Strength
gen aidblackstr92=0 if V923724 ==4
replace aidblackstr92=1 if V923724 ==5 | V923724 ==3
replace aidblackstr92=2 if V923724 ==2 | V923724 ==6
replace aidblackstr92=3 if V923724 ==1 | V923724 ==7
replace aidblackstr92=. if V923724==.
replace aidblackstr92=(aidblackstr92)/3
label variable aidblackstr92 "strength of aid to black opinion, 1=strong"

***Aid to Blacks
gen aidblack92=V923724 
recode aidblack92 9=. 8=. 0=.
replace aidblack92=(1-((aidblack92-1)/6))
label variable aidblack92 "govt aid to minorities, 1=gov should help"


***Govt guarantee jobs
gen govtjobs92=V923718
recode govtjobs92 9=. 8=. 0=.
replace govtjobs92 =(1-((govtjobs92-1)/6))
label variable govtjobs92 "govt guarantee jobs, 1=govt should guarantee jobs"

***Govt guarantee jobs strength
gen govtjobsstr92 =0 if V923718 ==4
replace govtjobsstr92 =1 if V923718 ==5 | V923718 ==3
replace govtjobsstr92 =2 if V923718 ==2 | V923718 ==6
replace govtjobsstr92 =3 if V923718 ==1 | V923718 ==7
replace govtjobsstr92 =(govtjobsstr92)/3


***Defense Spending
gen defense92= V923707
recode defense92 9=. 8=. 0=.
replace defense92 =(1-((defense92-1)/6))
label variable defense92 "defense spending, 1=greatly decrease defense spending"

***Defense spending strength
gen defensestr92 =0 if V923707 ==4
replace defensestr92 =1 if V923707 ==5 | V923707 ==3
replace defensestr92 =2 if V923707 ==2 | V923707 ==6
replace defensestr92 =3 if V923707 ==1 | V923707 ==7
replace defensestr92 =(defensestr92)/3

***Index of Issue Strength
egen issuestr92=rmean(govtjobsstr92 defensestr92 abortionstr92 govspendstr92 govhealthstr92 aidblackstr92)
label variable issuestr92 "index of issue strength, 6 items, 1=strongest positions"

***Index if Issue Positions, 1=Liberal
egen issues92=rmean(govtjobs92 defense92 abortion92 govspend92 govhealth92 aidblack92)

***Issue constraint
egen issconstraint92=rowsd(defense92 abortion92 govspend92 govhealth92 aidblack92 govtjobs92)
omscore issconstraint92
replace issconstraint92=rr_issconstraint92


***1996

***Political ids
///Partisan identity
gen pid96=V960420
recode pid96 9=. 8=. 7=.
replace pid96=(1-(pid96/6))
label variable pid96 "7-point PID Dem=hi"

///Ideological identity
gen ideo96=V960365
recode ideo96 9=. 8=. 0=.
replace ideo96=3 if V960366==1
replace ideo96=4 if V960366==3
replace ideo96=5 if V960366==2
replace ideo96=(1-((ideo96-1)/6))
label variable ideo96 "Ideology Liberal=hi"

///Party dummy
gen demrep96=1 if V960417==1 | V960419==5 
replace demrep96=0 if V960417==2 | V960419==1 
label variable demrep96 "Dem/Rep Dummy including leaners, 1=Dem"

///Partisan strength
gen pidstr96=3 if V960418==1 
replace pidstr96=2 if V960418==5
replace pidstr96=1 if V960419==1 | V960419==5
replace pidstr96=0 if V960419==3 
replace pidstr96=pidstr96/3
label variable pidstr96 "Partisan strength, hi=strong"

///Ideological strength
gen ideostr96=3 if V960365==1 | V960365==7
replace ideostr96 =2 if V960365 ==2 | V960365 ==6
replace ideostr96 =1 if V960365 ==3 | V960365 ==5 | V960366==1 | V960366==2
replace ideostr96 =0 if V960365 ==4 | V960366==3
replace ideostr96=ideostr96/3
label variable ideostr96 "Ideological strength, hi=strong"

//strength 1-4
gen pidstr196=4 if V960418==1 
replace pidstr196=3 if V960418 ==5
replace pidstr196=2 if V960419 ==1 | V960419 ==5
replace pidstr196=1 if V960419 ==3 
label variable pidstr196 "Partisan strength, 1 to 4, 4=strong"

gen ideostr196=4 if V960365==1 | V960365==7
replace ideostr196 =3 if V960365 ==2 | V960365 ==6
replace ideostr196 =2 if V960365 ==3 | V960365 ==5 | V960366==1 | V960366==2
replace ideostr196 =1 if V960365 ==4 | V960366==3
label variable ideostr196 "Ideological strength, hi=strong"
label variable ideostr196 "Ideological strength, 1 to 4, 4=strong"

//Partisan and Ideological strength
gen pidideostr196=pidstr196*ideostr196

//Overlap
gen pid196=V960420
recode pid196 9=. 8=. 7=.
replace pid196= pid196+1

gen ideo196=V960365
recode ideo196 9=. 8=. 0=.
replace ideo196=3 if V960366==1
replace ideo196=4 if V960366==3
replace ideo196=5 if V960366==2

gen overlap96=abs(pid196-ideo196)+1

omscore overlap96
replace overlap96=rr_overlap96

label variable overlap96 "overlap between identities, hi=most overlap"

//Sorting score
gen overlapxstr96=overlap96*pidideostr196
gen idcomplexity96=(overlapxstr96)/112

***Thermometer Bias
recode V960292 999=. 998=.
recode V960293 999=. 998=.
gen demtherm96=V960292/100
gen reptherm96=V960293/100

gen thermbias96=abs(demtherm96-reptherm96)
label variable thermbias96 "Difference btwn Dem and Rep Party thermometers"


***Likes/Dislikes
gen demlike196=1 if V960326>0
replace demlike196=0 if demlike196==. & V960312==1
gen demlike296=1 if V960327>0
replace demlike296=0 if demlike296==. & V960312==1
gen demlike396=1 if V960328>0
replace demlike396=0 if demlike396==. & V960312==1
gen demlike496=1 if V960329>0
replace demlike496=0 if demlike496==. & V960312==1
gen demlike596=1 if V960330>0
replace demlike596=0 if demlike596==. & V960312==1

gen demlikes96=demlike196+demlike296+demlike396+demlike496+demlike596

gen demdislike196=1 if V960332>0
replace demdislike196=0 if demdislike196==. & V960312==1
gen demdislike296=1 if V960333>0
replace demdislike296=0 if demdislike296==. & V960312==1
gen demdislike396=1 if V960334>0
replace demdislike396=0 if demdislike396==. & V960312==1
gen demdislike496=1 if V960335>0
replace demdislike496=0 if demdislike496==. & V960312==1
gen demdislike596=1 if V960336>0
replace demdislike596=0 if demdislike596==. & V960312==1

gen demdislikes96=demdislike196+demdislike296+demdislike396+demdislike496+demdislike596

gen replike196=1 if V960314>0
replace replike196=0 if replike196==. & V960312==1
gen replike296=1 if V960315>0
replace replike296=0 if replike296==. & V960312==1
gen replike396=1 if V960316>0
replace replike396=0 if replike396==. & V960312==1
gen replike496=1 if V960317>0
replace replike496=0 if replike496==. & V960312==1
gen replike596=1 if V960318>0
replace replike596=0 if replike596==. & V960312==1

gen replikes96=replike196+replike296+replike396+replike496+replike596

gen repdislike196=1 if V960320>0
replace repdislike196=0 if repdislike196==. & V960312==1
gen repdislike296=1 if V960321>0
replace repdislike296=0 if repdislike296==. & V960312==1
gen repdislike396=1 if V960322>0
replace repdislike396=0 if repdislike396==. & V960312==1
gen repdislike496=1 if V960323>0
replace repdislike496=0 if repdislike496==. & V960312==1
gen repdislike596=1 if V960324>0
replace repdislike596=0 if repdislike596==. & V960312==1

gen repdislikes96=repdislike196+repdislike296+repdislike396+repdislike496+repdislike596


gen demlikesminusdis96=(demlikes96-demdislikes96)+5
gen replikesminusdis96=(replikes96-repdislikes96)+5


gen likebias96=abs(demlikesminusdis96-replikesminusdis96)
replace likebias96=likebias96/10
label variable likebias96 "Dif between Dem and Rep like scores(#like minus #dis), hi=biggest diff, lo=same# of likes/dislikes for each party"

***ACTIVISM
gen talk96=1 if V961165==1
replace talk96=0 if talk96==.

gen button96=1 if V961166==1
replace button96=0 if button96==.

gen rallies96=1 if V961167==1
replace rallies96=0 if rallies96==.

gen work96=1 if V961168==1
replace work96=0 if work96==.

gen givecand96=1 if V961169==1
replace givecand96=0 if givecand96==.

gen giveparty96=1 if V961171==1
replace giveparty96=0 if giveparty96==.

gen pastactiv96=talk96+button96+rallies96+work96+givecand96+giveparty96
replace pastactiv96=pastactiv96/6


***ANGER
gen doleanger96=1 if V960349==1 
replace doleanger96=0 if doleanger96==.

gen clintonanger96=1 if V960341==1
replace clintonanger96=0 if clintonanger96==.

gen angercand96=1 if doleanger96==1 & demrep96==1 | clintonanger96==1 & demrep96==0
replace angercand96=0 if angercand96==.
label variable angercand96 "anger at outgroup pres candidate, 1=felt anger"

gen clintonangerlong96=0 if V960341==5
replace clintonangerlong96=1 if V960342==4
replace clintonangerlong96=2 if V960342==3
replace clintonangerlong96=3 if V960342==2
replace clintonangerlong96=4 if V960342==1

gen doleangerlong96=0 if V960349==5
replace doleangerlong96 =1 if V960350==4
replace doleangerlong96 =2 if V960350==3
replace doleangerlong96 =3 if V960350==2
replace doleangerlong96 =4 if V960350==1

gen clangerlongout=clintonangerlong96 if demrep96==0
gen doangerlongout=doleangerlong96 if demrep96==1

egen angercandlong96=rmean (clangerlongout doangerlongout)
replace angercandlong96=angercandlong96/4
label variable angercandlong96 "anger at outgroup pres candidate, 1=felt anger"

***Issues

***strong abortion position dummy
gen abortionstr96=1 if V960503==4 | V960503==1
replace abortionstr96=0 if V960503==2 | V960503==3

***abortion position
gen abortion96= V960503
recode abortion96 9=. 8=. 7=. 6=.
replace abortion96=(abortion96-1)/3
label variable abortion96 "1996 when should abortion be allowed by law, 1=always"



***Government services/spending strength
gen govspendstr96=0 if V960450==4
replace govspendstr96=1 if V960450 ==5 | V960450 ==3
replace govspendstr96=2 if V960450 ==2 | V960450 ==6
replace govspendstr96=3 if V960450 ==1 | V960450 ==7
replace govspendstr96=(govspendstr96)/3


***Government services/spending
gen govspend96= V960450
recode govspend96 9=. 8=. 0=.
replace govspend96=(govspend96-1)/6
label variable govspend96 "gov services vs spending, 1=many more servic&spending"


***Government health insurance strength
gen govhealthstr96=0 if V960479==4
replace govhealthstr96=1 if V960479 ==5 | V960479 ==3
replace govhealthstr96=2 if V960479 ==2 | V960479 ==6
replace govhealthstr96=3 if V960479 ==1 | V960479 ==7
replace govhealthstr96=(govhealthstr96)/3

***Government health insurance
gen govhealth96= V960479
recode govhealth96 9=. 8=. 0=.
replace govhealth96=(1-((govhealth96-1)/6))
label variable govhealth96 "gov/private health insurance, 1=gov insurance plan"



***Aid to Blacks Strength
gen aidblackstr96=0 if V960487 ==4
replace aidblackstr96=1 if V960487 ==5 | V960487 ==3
replace aidblackstr96=2 if V960487 ==2 | V960487 ==6
replace aidblackstr96=3 if V960487 ==1 | V960487 ==7
replace aidblackstr96=. if V960487 ==.
replace aidblackstr96=(aidblackstr96)/3
label variable aidblackstr96 "strength of aid to black opinion, 1=strong"

***Aid to Blacks
gen aidblack96= V960487 
recode aidblack96 9=. 8=. 0=.
replace aidblack96=(1-((aidblack96-1)/6))
label variable aidblack96 "govt aid to minorities, 1=gov should help"


***Govt guarantee jobs
gen govtjobs96=V960483
recode govtjobs96 9=. 8=. 0=.
replace govtjobs96 =(1-((govtjobs96-1)/6))
label variable govtjobs96 "govt guarantee jobs, 1=govt should guarantee jobs"

***Govt guarantee jobs strength
gen govtjobsstr96 =0 if V960483 ==4
replace govtjobsstr96 =1 if V960483 ==5 | V960483 ==3
replace govtjobsstr96 =2 if V960483 ==2 | V960483 ==6
replace govtjobsstr96 =3 if V960483 ==1 | V960483 ==7
replace govtjobsstr96 =(govtjobsstr96)/3


***Defense Spending
gen defense96= V960463
recode defense96 9=. 8=. 0=.
replace defense96 =(1-((defense96-1)/6))
label variable defense96 "defense spending, 1=greatly decrease defense spending"

***Defense spending strength
gen defensestr96 =0 if V960463 ==4
replace defensestr96 =1 if V960463 ==5 | V960463 ==3
replace defensestr96 =2 if V960463 ==2 | V960463 ==6
replace defensestr96 =3 if V960463 ==1 | V960463 ==7
replace defensestr96 =(defensestr96)/3


***Index of Issue Strength
egen issuestr96=rmean(defensestr96 govtjobsstr96 abortionstr96 govspendstr96 govhealthstr96 aidblackstr96)
label variable issuestr96 "index of issue strength, 6 items, 1=strongest positions"

***Issue constraint
egen issconstraint96=rowsd(defense96 abortion96 govspend96 govhealth96 aidblack96 govtjobs96)
omscore issconstraint96
replace issconstraint96=rr_issconstraint96























