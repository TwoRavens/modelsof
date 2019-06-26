clear all
use TokdemirJPR_Surveys.dta

lab var antius "Anti-Americanism"
lab var antiusord "Anti-Americanism"
lab var totalaidlagpc "Total Aid pc"
lab var milaidlagpc "Military Aid pc"
lab var econaidlagpc "Economic Aid pc"
lab var author "Non-Democratic"
lab var dissatis "Dissatisfied"
lab var intmilaiddem "Mil.AidXNon-Dem."
lab var inteconaiddem "Econ.AidXNon-Dem."
lab var intmilaidsat "Mil.AidXDissatis."
lab var inteconaidsat "Econ.AidXDissatis"
lab var disaut "Non-Dem.XDissatis."
lab var milaiddisaut "Mil.AidXNon-Dem.XDissatis."
lab var econaiddisaut "Econ.AidXNon-Dem.XDissatis."
lab var physintlag "Physical Integrity"
lab var gdppc "GDP pc"
lab var gender "Male"
lab var age "Age"
lab var relig "Religious"
lab var employ "Employed"
lab var univ "High School Grad."
lab var meast "Middle East"
lab var Bush "Bush Admin."
lab var polity2 "Polity"
lab var milrep "Mil.AidXRepress"
lab var econrep "Econ.AidXRepress"
lab var disrep "Dissatis.XRepress."
lab var milrepdis "Mil.AidXDissatis.XRepress."
lab var econrepdis "Econ.AidXDissatis.XRepress."
lab var econcond "Economic Condition"

lab var cummilaid "Cumm. Mil.Aid"
lab var cumeconaid "Cumm. Econ.Aid"
lab var chanmilaid "Ch. in Mil.Aid"
lab var chaneconaid "Ch. in Econ.Aid"

lab var intcummilaiddis "Cumm.Mil.AidXDissatis."
lab var intcumecondis "Cumm.Econ.AidXDissatis."
lab var intchanmildis "Ch.in Mil.AidXDissatis."
lab var intchanecondis "Ch.in Econ.AidXDissatis."

lab var cummilaut "Cumm.Mil.AidXNon-Dem."
lab var cumeconaut "Cumm.Econ.AidXNon-Dem."
lab var chanmilaut "Ch.in Mil.AidXNon-Dem."
lab var chaneconaut "Ch.in Econ.AidXNon-Dem."

lab var cummilautdis "Cumm.Mil.AidXNon-Dem.XDissatis."
lab var cumeconautdis "Cumm.Econ.AidXNon-Dem.XDissatis"
lab var chanmilauddis "Ch.in Mil.AidXNon-Dem.XDissatis."
lab var chaneconauddis "Ch.in Econ.AidXNon-Dem.XDissatis"

lab var intmilaidws "Military Aid pc X W/S"
lab var inteconaidws "Economic Aid pc X W/S"
lab var disws "W/S X Dissatis."
lab var milaiddisws "Mil.AidX W/S XDissatis."
lab var econaiddisws "Econ.AidX W/S XDissatis."

replace gdppc=gdppc/1000
***Table 1.
eststo m2: ologit antiusord milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut i.year if count!=23, robust 
eststo m3: ologit antiusord milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust
eststo m4: ologit antiusord econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut i.year if count!=23, robust
eststo m5: ologit antiusord econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut physintlag gdppc gender age relig employ univ econcond meast Bush i.year if count!=23, robust
eststo m6: logit antius milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut i.year if count!=23, robust
eststo m7: logit antius milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust
eststo m8: logit antius econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut i.year if count!=23, robust
eststo m9:logit antius econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust
esttab m2 m3 m4 m5 m6 m7 m8 m9 using "Table1.tex", tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_cons Constant)

***Table 2.
eststo m2: ologit antiusord milaidlagpc WoverS dissatis intmilaidws intmilaidsat disws milaiddisws i.year if count!=23, robust 
eststo m3: ologit antiusord milaidlagpc WoverS dissatis intmilaidws intmilaidsat disws milaiddisws physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust
eststo m4: ologit antiusord econaidlagpc WoverS dissatis inteconaidws inteconaidsat disws econaiddisws i.year if count!=23, robust
eststo m5: ologit antiusord econaidlagpc WoverS dissatis inteconaidws inteconaidsat disws econaiddisws physintlag gdppc gender age relig employ univ econcond meast Bush i.year if count!=23, robust
eststo m6: logit antius milaidlagpc WoverS dissatis intmilaidws intmilaidsat disws milaiddisws i.year if count!=23, robust
eststo m7: logit antius milaidlagpc WoverS dissatis intmilaidws intmilaidsat disws milaiddisws physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust
eststo m8: logit antius econaidlagpc WoverS dissatis inteconaidws inteconaidsat disws econaiddisws i.year if count!=23, robust
eststo m9:logit antius econaidlagpc WoverS dissatis inteconaidws inteconaidsat disws econaiddisws physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust
esttab m2 m3 m4 m5 m6 m7 m8 m9 using "TableRRSelectorate.tex", tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_cons Constant)

***Table 6.
eststo m10: ologit antiusord milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut physintlag gdppc gender age relig employ univ econcond Bush i.year if count!=23 & meast==1, robust
eststo m11: ologit antiusord milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut physintlag gdppc gender age relig employ univ econcond Bush i.year if count!=23 & meast==0, robust
eststo m12: ologit antiusord econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut physintlag gdppc gender age relig employ univ econcond Bush i.year if count!=23 & meast==1, robust
eststo m13: ologit antiusord econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut physintlag gdppc gender age relig employ univ econcond Bush i.year if count!=23 & meast==0, robust
esttab m10 m11 m12 m13 using "TableA.tex", tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_cons Constant)

***Table 7.
eststo m2: ologit antiusord milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23 & oecd!=1, robust
eststo m3: ologit antiusord econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut physintlag gdppc gender age relig employ univ econcond meast Bush i.year if count!=23 & oecd!=1, robust
eststo m4: ologit antiusord milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23 & ally!=1, robust
eststo m5: ologit antiusord econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut physintlag gdppc gender age relig employ univ econcond meast Bush i.year if count!=23 & ally!=1, robust
esttab m2 m3 m4 m5 using "TableE.tex", tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_cons Constant)

***Table 8.
eststo m2: ologit antiusord milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut i.year, robust 
eststo m3: ologit antiusord milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush i.year, robust
eststo m4: ologit antiusord econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut i.year, robust
eststo m5: ologit antiusord econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut physintlag gdppc gender age relig employ univ econcond meast Bush i.year, robust
eststo m6: logit antius milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut i.year, robust
eststo m7: logit antius milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush i.year, robust
eststo m8: logit antius econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut i.year, robust
eststo m9: logit antius econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush i.year, robust
esttab m2 m3 m4 m5 m6 m7 m8 m9 using "TableRRApp.tex", tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_cons Constant)

***Table 9.
recode antiamer (8 9=.)
eststo m2: ologit antiamer milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut i.year if count!=23, robust 
eststo m3: ologit antiamer milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust
eststo m4: ologit antiamer econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut i.year if count!=23, robust
eststo m5: ologit antiamer econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut physintlag gdppc gender age relig employ univ econcond meast Bush i.year if count!=23, robust
esttab m2 m3 m4 m5 using "TableG.tex", tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_cons Constant)

***Table 10.
eststo m11: ologit antiusord milaidlagpc repressive dissatis milrep intmilaidsat disrep milrepdis i.year if count!=23, robust 
eststo m12: ologit antiusord milaidlagpc repressive dissatis milrep intmilaidsat disrep milrepdis  physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust
eststo m13: ologit antiusord econaidlagpc repressive dissatis econrep inteconaidsat disrep econrepdis  i.year if count!=23, robust
eststo m14: ologit antiusord econaidlagpc repressive dissatis econrep inteconaidsat disrep econrepdis  physintlag gdppc gender age relig employ univ econcond meast Bush i.year if count!=23, robust
esttab m11 m12 m13 m14 using "TableB.tex",  tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_cons Constant)

***Table 11.
eststo m15: ologit antiusord cummilaid author dissatis cummilaut intcummilaiddis disaut cummilautdis meast physintlag gdppc gender age relig employ univ econcond Bush, robust
eststo m16: ologit antiusord cumeconaid author dissatis cumeconaut intcumecondis disaut cumeconautdis meast physintlag gdppc gender age relig employ univ econcond Bush, robust
eststo m17: ologit antiusord chanmilaid author dissatis chanmilaut intchanmildis disaut chanmilauddis meast physintlag gdppc gender age relig employ univ econcond Bush, robust
eststo m18: ologit antiusord chaneconaid author dissatis chaneconaut intchanecondis disaut chaneconauddis meast physintlag gdppc gender age relig employ univ econcond Bush, robust
esttab m15 m16 m17 m18 using "TableC.tex", tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_cons Constant)

***Table 12.
eststo m19: xtreg antiusord milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut i.year if count!=23, re i(count)
eststo m20: xtreg antiusord milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, re i(count)
eststo m21: xtreg antiusord econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut i.year if count!=23, re i(count)
eststo m22: xtreg antiusord econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, re i(count)
esttab m19 m20 m21 m22 using "TableD.tex", tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_cons Constant)

***Table 13.
cd "/Users/efetokdemir/Desktop/DevilisinDetail/Data"
clear all
use TokdemirJPR_CountryYear.dta
eststo m1: reg totalaidpc totalaidlagpc antiamerlag physint polity2 meast gdppc, robust
eststo m2: reg milaidpc milaidlagpc antiamerlag physint polity2 meast gdppc, robust
eststo m3: reg econaidpc econaidlagpc antiamerlag physint polity2 meast gdppc, robust
esttab m1 m2 m3 using "TableZ.tex", tex replace b(%10.3f) se scalars("r2 \$R^2\$" "chi2 $\chi^2$") label starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_cons Constant)

***Table 14.
eststo m1: ologit antiusord totalaidlagpc physintlag polity2 meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust 
eststo m2: ologit antiusord milaidlagpc physintlag polity2 meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust 
eststo m3: ologit antiusord econaidlagpc physintlag polity2 meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust 
eststo m4: logit antius totalaidlagpc physintlag polity2 meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust 
eststo m5: logit antius milaidlagpc physintlag polity2 meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust 
eststo m6: logit antius econaidlagpc physintlag polity2 meast gdppc gender age relig employ univ econcond Bush i.year if count!=23, robust 
esttab m1 m2 m3 m4 m5 m6 using "TableF.tex", tex replace b(%10.3f) se scalars("r2_p Pseudo \$R^2\$" "ll Log likelihood" "chi2 $\chi^2$") label starlevels(* 0.10 ** 0.05 *** 0.01) varlabels(_cons Constant)




***Military Aid Simulation***
clear all
use TokdemirJPR_Surveys.dta
logit antius milaidlagpc author dissatis intmilaiddem intmilaidsat disaut milaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush if count!=23, robust
preserve
drawnorm MG_b1-MG_b18, n(1000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 prob_hat2 lo2 hi2 prob_hat3 lo3 hi3 diff_hat diff_lo diff_hi ///
            using sim , replace 
noisily display "start"
forval a=0/55 { 
    {
scalar h_dissatis=0
scalar h_author=0
scalar h_meast=0
scalar h_physintlag=3
scalar h_gdppc=9307
scalar h_age=39
scalar h_relig=1 
scalar h_univ=0
scalar h_econcond=3 
scalar h_gender=1 
scalar h_Bush=0
scalar h_employ=1
scalar h_constant=1

    generate x_betahat0 = MG_b1*`a' ///
                            + MG_b2*h_author ///
                            + MG_b3*h_dissatis ///
                            + MG_b4*h_author*`a' ///
                            + MG_b5*h_dissatis*`a' ///
                            + MG_b6* h_author*h_dissatis ///
                            + MG_b7* h_author*h_dissatis*`a' ///
							+ MG_b8* h_physintlag ///
							+ MG_b9* h_meast ///
							+ MG_b10* h_gdppc ///
							+ MG_b12* h_age ///
							+ MG_b13* h_relig ///
							+ MG_b15* h_univ ///
							+ MG_b16* h_econcond ///
							+ MG_b11* h_gender ///
							+ MG_b14* h_employ ///
							+ MG_b17* h_Bush ///
							+ MG_b18* h_constant
    
	generate x_betahat1 = MG_b1*`a' ///
                            + MG_b2*(h_author+1) ///
                            + MG_b3*(h_dissatis+1) ///
                            + MG_b4*(h_author+1)*`a' ///
                            + MG_b5*(h_dissatis+1)*`a' ///
                            + MG_b6*(h_author+1)*(h_dissatis+1) ///
                            + MG_b7* (h_author+1)*(h_dissatis+1)*`a' ///
							+ MG_b8* h_physintlag ///
							+ MG_b9* h_meast ///
							+ MG_b10* h_gdppc ///
							+ MG_b12* h_age ///
							+ MG_b13* h_relig ///
							+ MG_b15* h_univ ///
							+ MG_b16* h_econcond ///
							+ MG_b11* h_gender ///
							+ MG_b14* h_employ ///
							+ MG_b17* h_Bush ///
							+ MG_b18* h_constant
							
	generate x_betahat2 = MG_b1*`a' ///
                            + MG_b2*(h_author) ///
                            + MG_b3*(h_dissatis+1) ///
                            + MG_b4*(h_author)*`a' ///
                            + MG_b5*(h_dissatis+1)*`a' ///
                            + MG_b6*(h_author)*(h_dissatis+1) ///
                            + MG_b7* (h_author)*(h_dissatis+1)*`a' ///
							+ MG_b8* h_physintlag ///
							+ MG_b9* h_meast ///
							+ MG_b10* h_gdppc ///
							+ MG_b12* h_age ///
							+ MG_b13* h_relig ///
							+ MG_b15* h_univ ///
							+ MG_b16* h_econcond ///
							+ MG_b11* h_gender ///
							+ MG_b14* h_employ ///
							+ MG_b17* h_Bush ///
							+ MG_b18* h_constant
	
	generate x_betahat3 = MG_b1*`a' ///
                            + MG_b2*(h_author+1) ///
                            + MG_b3*(h_dissatis) ///
                            + MG_b4*(h_author+1)*`a' ///
                            + MG_b5*(h_dissatis)*`a' ///
                            + MG_b6*(h_author+1)*(h_dissatis) ///
                            + MG_b7* (h_author+1)*(h_dissatis)*`a' ///
							+ MG_b8* h_physintlag ///
							+ MG_b9* h_meast ///
							+ MG_b10* h_gdppc ///
							+ MG_b12* h_age ///
							+ MG_b13* h_relig ///
							+ MG_b15* h_univ ///
							+ MG_b16* h_econcond ///
							+ MG_b11* h_gender ///
							+ MG_b14* h_employ ///
							+ MG_b17* h_Bush ///
							+ MG_b18* h_constant

    
    gen prob0=normal(x_betahat0)
    gen prob1=normal(x_betahat1)
    gen prob2=normal(x_betahat2)
    gen prob3=normal(x_betahat3)

    gen diff=prob1-prob0
    
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen probhat2=mean(prob2)
    egen probhat3=mean(prob3)

    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 prob_hat2 lo2 hi2 prob_hat3 lo3 hi3 diff_hat diff_lo diff_hi   

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)  
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)  
    
    _pctile prob2, p(2.5,97.5)
    scalar `lo2'= r(r1)
    scalar `hi2'= r(r2)
    
    _pctile prob3, p(2.5,97.5)
    scalar `lo3'= r(r1)
    scalar `hi3'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2)  

    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `prob_hat2'=probhat2
    scalar `prob_hat3'=probhat3
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`prob_hat2') (`lo2') (`hi2') (`prob_hat3') (`lo3') (`hi3') ///
                (`diff_hat') (`diff_lo') (`diff_hi') 
    }      
    drop x_betahat0 x_betahat1 x_betahat2 x_betahat3 prob0 prob1 prob2 prob3 diff probhat0 probhat1 probhat2 probhat3 diffhat 
    local a=`a' 
    display "." _c
    
   	} 

      
postclose mypost
use sim, clear
gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line diff_lo  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||   line diff_hi  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||  , saving(JPR1b, replace) ///    
            xlabel(0(10)50) ylabel(0(0.2)1) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Marginal Effect of Military Aid Conditional of Dissatisfaction in Non-Democracy", size(3)) ///
            xtitle("Military Aid pc($)", size(3)) ///
            ytitle("Difference in Probability of Anti-Americanism", size(3)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))

graph twoway line prob_hat0 MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line prob_hat1 MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||	 line prob_hat2 MV, clpattern(dash) clwidth(red) clcolor(black) ///
        ||   line prob_hat3 MV, clpattern(dash) clwidth(green) clcolor(black) ///
        ||   rspike lo0 hi0 MV ///
        ||	 rspike lo1 hi1 MV ///
        ||	 rspike lo2 hi2 MV ///
        ||	 rspike lo3 hi3 MV ///
        ||  , saving(JPR1a, replace) ///    
            xlabel(0(10)50) ylabel(0(0.2)1) yscale(noline) xscale(noline) yline(0) ///
            legend(order(1 "Satisfied in Democracy" 2 "Dissatisfied in Non-Democracy" 3 "Dissatisfied in Democracy" 4 "Satisfied in Non-Democracy")) ///
            title("Effect of Military Aid on Anti-Americanism Conditional on Satisfaction and Regime Type", size(3)) ///
            xtitle("Military Aid pc($)", size(3)) ///
            ytitle("Pr(Anti-Americanism=1)", size(3)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))
			
			
			
****Economic Aid-Simulation***
clear all
use TokdemirJPR_Surveys
logit antius econaidlagpc author dissatis inteconaiddem inteconaidsat disaut econaiddisaut physintlag meast gdppc gender age relig employ univ econcond Bush if count!=23, robust
preserve
drawnorm MG_b1-MG_b18, n(1000) means(e(b)) cov(e(V)) clear
postutil clear
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 prob_hat2 lo2 hi2 prob_hat3 lo3 hi3 diff_hat diff_lo diff_hi ///
            using sim , replace 
noisily display "start"     
           
forval a=0/102 { 
    {
scalar h_dissatis=0
scalar h_author=0
scalar h_meast=0
scalar h_physintlag=3
scalar h_gdppc=9307
scalar h_age=39
scalar h_relig=1 
scalar h_univ=0
scalar h_econcond=3 
scalar h_gender=1 
scalar h_Bush=0
scalar h_employ=1
scalar h_constant=1

    generate x_betahat0 = MG_b1*`a' ///
                            + MG_b2*h_author ///
                            + MG_b3*h_dissatis ///
                            + MG_b4*h_author*`a' ///
                            + MG_b5*h_dissatis*`a' ///
                            + MG_b6* h_author*h_dissatis ///
                            + MG_b7* h_author*h_dissatis*`a' ///
							+ MG_b8* h_physintlag ///
							+ MG_b9* h_meast ///
							+ MG_b10* h_gdppc ///
							+ MG_b12* h_age ///
							+ MG_b13* h_relig ///
							+ MG_b15* h_univ ///
							+ MG_b16* h_econcond ///
							+ MG_b11* h_gender ///
							+ MG_b14* h_employ ///
							+ MG_b17* h_Bush ///
							+ MG_b18* h_constant
    
	generate x_betahat1 = MG_b1*`a' ///
                            + MG_b2*(h_author+1) ///
                            + MG_b3*(h_dissatis+1) ///
                            + MG_b4*(h_author+1)*`a' ///
                            + MG_b5*(h_dissatis+1)*`a' ///
                            + MG_b6*(h_author+1)*(h_dissatis+1) ///
                            + MG_b7* (h_author+1)*(h_dissatis+1)*`a' ///
							+ MG_b8* h_physintlag ///
							+ MG_b9* h_meast ///
							+ MG_b10* h_gdppc ///
							+ MG_b12* h_age ///
							+ MG_b13* h_relig ///
							+ MG_b15* h_univ ///
							+ MG_b16* h_econcond ///
							+ MG_b11* h_gender ///
							+ MG_b14* h_employ ///
							+ MG_b17* h_Bush ///
							+ MG_b18* h_constant
    generate x_betahat2 = MG_b1*`a' ///
                            + MG_b2*h_author ///
                            + MG_b3*h_dissatis+1 ///
                            + MG_b4*h_author*`a' ///
                            + MG_b5*(h_dissatis+1)*`a' ///
                            + MG_b6* h_author*(h_dissatis+1) ///
                            + MG_b7* h_author*(h_dissatis+1)*`a' ///
							+ MG_b8* h_physintlag ///
							+ MG_b9* h_meast ///
							+ MG_b10* h_gdppc ///
							+ MG_b12* h_age ///
							+ MG_b13* h_relig ///
							+ MG_b15* h_univ ///
							+ MG_b16* h_econcond ///
							+ MG_b11* h_gender ///
							+ MG_b14* h_employ ///
							+ MG_b17* h_Bush ///
							+ MG_b18* h_constant
    
	generate x_betahat3 = MG_b1*`a' ///
                            + MG_b2*(h_author+1) ///
                            + MG_b3*(h_dissatis) ///
                            + MG_b4*(h_author+1)*`a' ///
                            + MG_b5*(h_dissatis)*`a' ///
                            + MG_b6*(h_author+1)*(h_dissatis) ///
                            + MG_b7* (h_author+1)*(h_dissatis)*`a' ///
							+ MG_b8* h_physintlag ///
							+ MG_b9* h_meast ///
							+ MG_b10* h_gdppc ///
							+ MG_b12* h_age ///
							+ MG_b13* h_relig ///
							+ MG_b15* h_univ ///
							+ MG_b16* h_econcond ///
							+ MG_b11* h_gender ///
							+ MG_b14* h_employ ///
							+ MG_b17* h_Bush ///
							+ MG_b18* h_constant
							
    gen prob0=normal(x_betahat0)
    gen prob1=normal(x_betahat1)
    gen prob2=normal(x_betahat2)
    gen prob3=normal(x_betahat3)

    gen diff=prob1-prob0
    
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen probhat2=mean(prob2)
    egen probhat3=mean(prob3)

    egen diffhat=mean(diff)
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 prob_hat2 lo2 hi2 prob_hat3 lo3 hi3 diff_hat diff_lo diff_hi   

    _pctile prob0, p(2.5,97.5) 
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)  
    
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2)  
	
	 _pctile prob2, p(2.5,97.5)
    scalar `lo2'= r(r1)
    scalar `hi2'= r(r2)
    
    _pctile prob3, p(2.5,97.5)
    scalar `lo3'= r(r1)
    scalar `hi3'= r(r2)
    
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2)  

    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `prob_hat2'=probhat2
    scalar `prob_hat3'=probhat3
    scalar `diff_hat'=diffhat
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') ///
                (`prob_hat2') (`lo2') (`hi2') (`prob_hat3') (`lo3') (`hi3') ///
                (`diff_hat') (`diff_lo') (`diff_hi')  
    }      
    drop x_betahat0 x_betahat1 x_betahat2 x_betahat3 prob0 prob1 prob2 prob3 diff probhat0 probhat1 probhat2 probhat3 diffhat 
    local a=`a' 
    display "." _c
   	} 

      
postclose mypost                          
use sim, clear
gen MV = _n-1

graph twoway line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line diff_lo  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||   line diff_hi  MV, clpattern(dash) clwidth(medium) clcolor(black) ///
        ||  , saving(JPR2b, replace) ///    
            xlabel(0(20)100) ylabel(0(0.2)1) yscale(noline) xscale(noline) yline(0) legend(off) ///
            title("Marginal Effect of Economic Aid Conditional of Dissatisfaction in Non-Democracy", size(3)) ///
            xtitle("Economic Aid pc($)", size(3)) ///
            ytitle("Difference in Probability of Anti-Americanism", size(3)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))

graph twoway line prob_hat0 MV, clwidth(medium) clcolor(blue) clcolor(black) ///
        ||   line prob_hat1 MV, clpattern(dash) clwidth(medium) clcolor(black) ///
		||   line prob_hat2 MV, clpattern(dash) clwidth(red) clcolor(black) ///
        ||   line prob_hat3 MV, clpattern(dash) clwidth(green) clcolor(black) ///
        ||   rspike lo0 hi0 MV ///
        ||	 rspike lo1 hi1 MV ///
		||	 rspike lo2 hi2 MV ///
		||	 rspike lo3 hi3 MV ///
        ||  , saving(JPR2a, replace) ///    
            xlabel(0(20)100) ylabel(0(0.2)1) yscale(noline) xscale(noline) yline(0) ///
            legend(order(1 "Satisfied in Democracy" 2 "Dissatisfied in Non-Democracy" 3 "Dissatisfied in Democracy" 4 "Satisfied in Non-Democracy")) ///
			title("Effect of Economic Aid on Anti-Americanism Conditional on Satisfaction and Regime Type", size(3)) ///
            xtitle("Economic Aid pc ($)", size(3)) ///
            ytitle("Pr(Anti-Americanism=1)", size(3)) ///
            xsca(titlegap(2)) ysca(titlegap(2)) graphregion(fcolor(white))

