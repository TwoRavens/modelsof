/*Estimating the effect of Trade, FDI, Globalization and Economic Freedom on the prevalence of obesity among children and youth (ages 2-19)*/

use repdata_II_desoysa, replace
sort id year
tsset id year

/*testing the effect of trade openness on obesity of persons aged 2-19*/
newey mean lntrade  lngdppc urbanpop lnpop i.year, force lag(1)
outreg2 using table1_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel replace

newey mean lntrade  lngdppc urbanpop lnpop i.year i.id, force lag(1)
outreg2 using table1_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel append

xtpcse mean l.mean lntrade lngdppc urbanpop lnpop year, pairwise corr(ar1)
outreg2 using table1_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel append


/*testing the effect of FDI flows  on obesity of persons aged 2-19*/
newey mean lnfdigdp  lngdppc urbanpop lnpop i.year, force lag(1)
outreg2 using table1_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel append

newey mean lnfdigdp  lngdppc urbanpop lnpop i.year i.id, force lag(1)
outreg2 using table1_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel append

xtpcse mean l.mean lnfdigdp lngdppc urbanpop lnpop year, pairwise corr(ar1)
outreg2 using table1_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel append


/*testing the effect of Economic Globalization on obesity of persons aged 2-19*/

newey mean a  lngdppc urbanpop lnpop i.year i.id, force lag(1)
outreg2 using table2_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel replace


/*testing the effect of Social Globalization on obesity of persons aged 2-19*/

newey mean b  lngdppc urbanpop lnpop i.year i.id, force lag(1)
outreg2 using table2_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel append

/*testing the effect of Political Globalization on obesity of persons aged 2-19*/

newey mean c  lngdppc urbanpop lnpop i.year i.id, force lag(1)
outreg2 using table2_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel append


/*testing the effect of Total Globalization KOF INDEX on obesity of persons aged 2-19*/

newey mean index  lngdppc urbanpop lnpop i.year i.id , force lag(1)
outreg2 using table2_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel append




/*testing the effect of Economic freedom on obesity of persons aged 2-19*/
newey mean iefw  lngdppc urbanpop lnpop i.year, force lag(1)
outreg2 using table3_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel replace

newey mean iefw  lngdppc urbanpop lnpop i.year i.id, force lag(1)
outreg2 using table3_rep.xls, bdec(2) sdec(2) sym(***,**,*) onecol nolabel append


*************ROBUSTNESS CHECKS******************
newey mean index  lngdppc urbanpop lnpop i.year i.id, force lag(1)

newey mean a  lngdppc urbanpop lnpop i.year i.id, force lag(1)

newey mean a lngdppc urbanpop lnpop i.year i.id if western==0, force lag(1)

newey mean a healthexpgdp lngdppc urbanpop lnpop i.year i.id, force lag(1)

newey mean a foodimp lngdppc urbanpop lnpop i.year i.id , force lag(1)

newey mean a igini lngdppc urbanpop lnpop i.year i.id , force lag(1)

newey mean a democ lngdppc urbanpop lnpop i.year i.id , force lag(1)

******************ROBUSTNESS CHECKS FOR obesity in 20+ age group************************

newey mean20 lntrade  lngdppc urbanpop lnpop i.year i.id, force lag(1)
newey mean20 lnfdigdp  lngdppc urbanpop lnpop i.year i.id, force lag(1)
newey mean20 a lngdppc urbanpop lnpop i.year i.id, force lag(1)
newey mean20 b lngdppc urbanpop lnpop i.year i.id, force lag(1)
newey mean20 c  lngdppc urbanpop lnpop i.year i.id, force lag(1)
newey mean20 index  lngdppc urbanpop lnpop i.year i.id, force lag(1)
newey mean20 iefw  lngdppc urbanpop lnpop i.year i.id, force lag(1)


exit
