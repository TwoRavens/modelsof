***Author - Tim Vlandas
***Date - May 2018
***Title of paper - The political consequences of labour market dualization: Labour market status, occupation and policy preferences
***Journal: Political Science Research and Methods
***Note: This dofile reproduces the results shown in the paper and online appendix
/*Please insert path where two datasets ("psrm_vlandas_isspdata" and "psrm_vlandas_essdata") have been saved:
cd "insert path"
*/

****************
*** Figure 1 ***
****************
*load dataset
use psrm_vlandas_isspdata, clear
*Calculating results
quietly logit gvtsupportjobs occupationunemployment unemployed parttime spouseinsider c.ageinyears##c.ageinyears female unionmember yearseducationcompleted i.id , vce(cluster id)
estimates store A
quietly logit gvtresplivingstdunemp  occupationunemployment unemployed parttime spouseinsider c.ageinyears##c.ageinyears female unionmember yearseducationcompleted i.id , vce(cluster id)
estimates store B
quietly logit gvtspendonunempben occupationunemployment unemployed parttime spouseinsider c.ageinyears##c.ageinyears female unionmember yearseducationcompleted i.id , vce(cluster id)
estimates store C
*calculating standard deviations to rescale coefficients
foreach v of var occupationunemployment unemployed parttime spouseinsider female unionmember yearseducationcompleted {
quietly summarize `v'
local sd_`v' = r(sd)
}
*Graphing results
quietly coefplot (A, label(Government responsibility to provide job for everyone)) (B, label(Government responsbility to provide living standard for unemployed)) (C, label(Government should spend money on unemployment benefits)), xline(0) drop( _cons  ageinyears c.ageinyears#c.ageinyears 2.id 3.id 4.id 5.id 6.id 7.id 8.id 9.id 10.id 11.id 12.id 13.id 14.id 15.id 16.id 17.id 18.id 19.id 20.id 21.id 22.id )  xline(0) coeflabel(occupationunemployment =`""Occupational" "unemployment""' unemployed = "Unemployed" parttime = "Part time work" spouseinsider = "Spouse is insider" female = "Female" unionmember = "Union member" yearseducationcompleted = "Years in Education", wrap(20)) rescale (occupationunemployment = `sd_occupationunemployment' unemployed =  `sd_unemployed' parttime =  `sd_parttime' spouseinsider =  `sd_spouseinsider' female =  `sd_female' unionmember =  `sd_unionmember' yearseducationcompleted =  `sd_yearseducationcompleted') legend(col(1)) xsize(6) ysize(4)
graph save figure1

****************
*** Figure 2 ***
****************
*Calculating results
*Results without occupational dummies
quietly logit gvtspendonunempben occupationunemployment unemployed parttime spouseinsider c.ageinyears##c.ageinyears female unionmember married public nosecondarydegree i.id , vce(cluster id)
estimates store D
*Results with occupational dummies
quietly logit gvtspendonunempben unemployed parttime spouseinsider c.ageinyears##c.ageinyears female unionmember married public nosecondarydegree _Iisko88_1_2 _Iisko88_1_3 _Iisko88_1_4 _Iisko88_1_5 _Iisko88_1_6 _Iisko88_1_7 _Iisko88_1_8 _Iisko88_1_9 i.id , vce(cluster id)
estimates store E
*Calculating standard deviations to rescale coefficients
foreach v of var married public nosecondarydegree _Iisko88_1_2 _Iisko88_1_3 _Iisko88_1_4 _Iisko88_1_5 _Iisko88_1_6 _Iisko88_1_7 _Iisko88_1_8 _Iisko88_1_9 {
quietly summarize `v'
local sd_`v' = r(sd)
}
*Graphing results
coefplot (D, label(Model without occupational dummies)) (E, label(Model with occupational dummies)), xline(0) drop( _cons  ageinyears c.ageinyears#c.ageinyears 2.id 3.id 4.id 5.id 6.id 7.id 8.id 9.id 10.id 11.id 12.id 13.id 14.id 15.id 16.id 17.id 18.id 19.id 20.id 21.id 22.id ) xline(0) coeflabel(occupationunemployment ="Occupational unemployment" unemployed = "Unemployed" parttime = "Part time work" spouseinsider = "Spouse is insider" female = "Female" unionmember = "Union member" married = "Married" publicemployee = "Public Employee" nosecondarydegree = "No Secondary degree" _Iisko88_1_2 = "Professionals" _Iisko88_1_3 = "Technicians & associate professionals" _Iisko88_1_4 = "Clerks"  _Iisko88_1_5 = "Service workers & shop & market sales workers" _Iisko88_1_6 = "Skilled agricultural& fishery workers" _Iisko88_1_7 = "Craft & related trades workers" _Iisko88_1_8 = "Plant & machine operators & assemblers"  _Iisko88_1_9 = "Elementary occupations" )  rescale(occupationunemployment = `sd_occupationunemployment' unemployed =  `sd_unemployed' parttime =  `sd_parttime' spouseinsider =  `sd_spouseinsider'  female =  `sd_female' unionmember =  `sd_unionmember' nosecondarydegree = `sd_nosecondarydegree' married = `sd_married' publicemployee = `sd_publicemployee' _Iisko88_1_2=`sd__Iisko88_1_2' _Iisko88_1_3= `sd__Iisko88_1_3 '   _Iisko88_1_4=  `sd__Iisko88_1_4'   _Iisko88_1_5=  `sd__Iisko88_1_5'   _Iisko88_1_6=  `sd__Iisko88_1_6' _Iisko88_1_7=  `sd__Iisko88_1_7'   _Iisko88_1_8=  `sd__Iisko88_1_8'   _Iisko88_1_9=  `sd__Iisko88_1_9')  legend(col(1)) xsize(6) ysize(4)
graph save figure2

****************
*** Figure 3 ***
****************
*Running model with interaction between occupational unemployment and whether respondent is unemployed
quietly logit gvtspendonunempben c.occupationunemployment##i.unemployed parttime spouseinsider c.ageinyears##c.ageinyears female unionmember married public nosecondarydegree i.id , vce(cluster id)
*Calculating minimum and maximum values of occupational unemployment
sum occupationunemployment
*Calculating marginal effects of interaction term
quietly margins unemployed, at(occupationunemployment=(0.67(0.5)26)) atmeans
*Plotting interaction effects
marginsplot, ytitle(Prob(Government should spend on unemployment benefit))
graph save figure3
clear all

****************
*** Figure A1***
****************
*loading ESS dataset
use psrm_vlandas_essdata, clear
*calculating results
quietly logit unempgvtresp unemployed temporary uemplap c.age##c.age i.gndr education union i.id, vce(cluster id)
estimates store F
quietly logit unempgvtresp unemployed temporary uemplap c.age##c.age i.gndr education union i.id _Iisko88_1_2 - _Iisko88_1_9, vce(cluster id)
estimates store G
*Calculating standard deviations to rescale coefficients
foreach v of var unemployed temporary uemplap age gndr education union  _Iisko88_1_2 _Iisko88_1_3 _Iisko88_1_4 _Iisko88_1_5 _Iisko88_1_6 _Iisko88_1_7 _Iisko88_1_8 _Iisko88_1_9 {
quietly summarize `v'
local sd_`v' = r(sd)
}
*Graphing results
coefplot (F, label(Model without occupational dummies)) (G, label(Model with occupational dummies)), xline(0) drop( _cons  age c.age#c.age 2.id 3.id 4.id 5.id 6.id 7.id 8.id 9.id 10.id 11.id 12.id 13.id 14.id 15.id 16.id 17.id 18.id 19.id 20.id 21.id 22.id 23.id 24.id 25.id 26.id 27.id 28.id 29.id ) coeflabel(temporary = "Temporary worker" unemployed = "Unemployed" uemplap = "Partner unemployed" education = "Years of Education"  gndr = "Female" union = "Union member" _Iisko88_1_2 = "Professionals" _Iisko88_1_3 = "Technicians & associate professionals"  _Iisko88_1_4 = "Clerks"  _Iisko88_1_5 = "Service workers & shop & market sales workers" _Iisko88_1_6 = "Skilled agricultural & fishery workers"  _Iisko88_1_7 = "Craft & related trades workers" _Iisko88_1_8 = "Plant & machine operators & assemblers"  _Iisko88_1_9 = "Elementary occupations" ) rescale(unemployed =  `sd_unemployed' temporary = `sd_temporary' uemplap= `sd_uemplap' gndr =  `sd_gndr' union=  `sd_union' education = `sd_education' _Iisko88_1_2=`sd__Iisko88_1_2' _Iisko88_1_3= `sd__Iisko88_1_3 '   _Iisko88_1_4=  `sd__Iisko88_1_4'  _Iisko88_1_5=  `sd__Iisko88_1_5'   _Iisko88_1_6=  `sd__Iisko88_1_6' _Iisko88_1_7=  `sd__Iisko88_1_7'   _Iisko88_1_8=  `sd__Iisko88_1_8'  _Iisko88_1_9=  `sd__Iisko88_1_9')  legend(col(1)) xsize(6) ysize(4)
graph save figureA1
