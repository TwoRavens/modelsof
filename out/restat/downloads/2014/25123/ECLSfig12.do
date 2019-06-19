/*This program will make figures 1 and 2 (Transformation Densities) for the ECLS paper*/

clear all

set mem 250m

cd "C:\Users\bond10\Desktop\RA\Test Scores\Paper\replication files"

use ECLSbondlang.dta, clear


keep if weights!=.0 & black!=. & hispanic!=. & white!=. & asian!=. & other!=. & readfallk!=. & readspring3!=. & readspring1!=. & readspringk!=.

/*Generate weighted normalized baselines test scores*/


foreach x in fallk springk spring1 spring3  {
qui: reg read`x'std black hispanic asian other [pweight=weights], robust
est sto A`x'
                                        }


/*apply normalization*/
replace readspring3 = readspring3/180
replace readfallk = readfallk/180
replace readspringk = readspringk/180
replace readspring1 = readspring1/180
										
										
/*Minimizing Transformation*/
scalar B1 = 59.8183438089138
scalar B2 = -150.712988667491
scalar B3 = 133.052138026368
scalar B4 = -654.160995681869
scalar B5 = 1307.7864463404
scalar B6 = 1078.9278199586
scalar k = -0.3414266539
scalar N1 = -47.1499167878298

foreach x in fallk springk spring1 spring3         {
gen mintransform`x' = B1*(read`x' + k) + B2*(read`x' + k)^2 + B3*(read`x' + k)^3 + B4*(read`x' + k)^4 + B5*(read`x' + k)^5 + B6*(read`x' + k)^6 - N1
                                                       }
foreach x in fallk springk spring1 spring3  {
qui: summ mintransform`x' [aweight=weights]
scalar mn = r(mean)
scalar stnd = r(sd)
qui:gen mintransform`x'std = (mintransform`x'-mn)/stnd
qui:reg mintransform`x'std black hispanic asian other [pweight=weights], robust
est sto B`x'
                                        }
/*Maximizing Transformation*/
scalar B1 = 43.799320378222
scalar B2 = 335.609232031174
scalar B3 = 688.559923214134
scalar B4 = -1096.7722196637
scalar B5 = -476.790031091736
scalar B6 = 626.360970505262
scalar k = -0.2784345
scalar N1 = -16.4208945492854

foreach x in fallk springk spring1 spring3         {
gen maxtransform`x' = B1*(read`x' + k) + B2*(read`x' + k)^2 + B3*(read`x' + k)^3 + B4*(read`x' + k)^4 + B5*(read`x' + k)^5 + B6*(read`x' + k)^6 - N1
                                                       }
foreach x in fallk springk spring1 spring3  {
qui: summ maxtransform`x' [aweight=weights]
scalar mn = r(mean)
scalar stnd = r(sd)
qui: gen maxtransform`x'std = (maxtransform`x'-mn)/stnd
qui: reg maxtransform`x'std black hispanic asian other [pweight=weights], robust
est sto C`x'
}
kdensity readfallkstd [aweight=weights] if maxtransformfallkstd<7, kernel(epan) nograph gen(x basek)
kdensity mintransformfallkstd [aw=weights] if maxtransformfallkstd<7, kernel(epan) nograph gen(x2 mink)
kdensity maxtransformfallkstd [aw=weights] if maxtransformfallkstd<7, kernel(epan) nograph gen(x3 maxk)
label var basek "Baseline"
label var mink "Growth Minimizing"
label var maxk "Growth Maximizing"

line basek x||line maxk x3||line mink x2, scheme(s2mono) ytitle(Density) xtitle(Standard Deviations from Mean) sort legend(style(column)) note(Outlying values beyond seven standard deviations above the mean are not displayed) name(Figure1) saving(Figure1,replace)

drop x x2 x3

kdensity mintransformspring3std if mintransformspring3std<7 [aw=weights] , kernel(epan) nograph gen(x2 min3)
kdensity readspring3std [aw=weights] if mintransformspring3std<7, kernel(epan) nograph gen(x base3)
kdensity maxtransformspring3std [aw=weights] if mintransformspring3std<7, kernel(epan) nograph gen(x3 max3)
label var base3 "Baseline"
label var max3 "Growth Maximizing"
label var min3 "Growth Minimizing"

line base3 x|| line max3 x3|| line min3 x2, scheme(s2mono) ytitle(Density) xtitle(Standard Deviations from Mean) sort legend(style(column)) note(Outlying values beyond seven standard deviations above the mean are not displayed) name(Figure2) saving(Figure2,replace)

/*Table 4 Column 1*/
est tab Afallk Aspringk Aspring1 Aspring3, b se keep(black)

/*Table 4 Column 2*/
est tab Bfallk Bspringk Bspring1 Bspring3, b se keep(black)

/*Table 4 Column 3*/
est tab Cfallk Cspringk Cspring1 Cspring3, b se keep(black)
