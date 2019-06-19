local msamacro="pho seattle dc denver sandiego chi sanfran vegas"

**************
**MAKE TABLE 1
**************

use temp11e_la_r2.dta,clear
gen cityid="la"

foreach j in `msamacro' {
append using temp11e_`j'_r2.dta, force
replace cityid="`j'" if cityid==""
}


*for phoenix and seattle, the first case shiller index value starts 13 and 25 months after the case shiller index for other cities
gen thresh=1
replace thresh=13 if cityid=="pho"
replace thresh=25 if cityid=="seattle"
sort lowaddress numdatel

*does the listing come on and off the market
gen modify1=(length_new[_n-1]<=4 & lowaddress==lowaddress[_n-1])
gen modify2=(length_new[_n-1]>4 & length_new[_n-1]<=26 & lowaddress==lowaddress[_n-1])
sort lowaddress timeid
gen chnglist=ln(price)-ln(price[_n-1]) if lowaddress==lowaddress[_n-1] 
gen timediff=timeid-timeid[_n-1] if lowaddress==lowaddress[_n-1] 
gen my0=(year(lastsaledate)-1988)*12+month(lastsaledate)
sort idl numdatel
by idl: gen index=_n

*month number of current list price
gen my=(year(numdatel)-1988)*12+month(numdatel)
gen weeknum=week(numdatel)+(year(numdatel)-1988)*52

**drop outliers
gen interval=my-my0
drop if interval<6 
gen temp=abs(ln(price)-ln(lastsalepr))/interval
drop if temp>.025
drop if price<10000
drop if price<50000 & lastsalepr>50000
drop if price>15000000
drop if my0<thresh


gen listdate=numdatel-TOM
keep if numdatel<19425
keep if  listdate>17457
save temp

collapse (p10) ratio10=ratio lpchng10=lpchng price10=price TOM10=TOM modify110=modify1 modify210=modify2 (p25) ratio25=ratio lpchng25=lpchng price25=price TOM25=TOM modify125=modify1 modify225=modify2 (p50) ratio50=ratio lpchng50=lpchng price50=price TOM50=TOM modify150=modify1 modify250=modify2 (p75)  ratio75=ratio lpchng75=lpchng price75=price TOM75=TOM modify175=modify1 modify275=modify2 (p90) ratio90=ratio lpchng90=lpchng price90=price TOM90=TOM modify190=modify1 modify290=modify2 ,by(cityid)
reshape long ratio lpchng price TOM modify1 modify2, i(cityid) j(pctile)
replace lpchng=lpchng-1
outsheet using summarstats.xls,replace

**************
**MAKE FIGURES A2-A4
**************
use temp,clear

*merge on case shiller index in month of previous sale
sort my0
merge my0 using cs.dta,nokeep
gen delta0=.
foreach j in `msamacrofull' {
replace delta0=`j' if cityid=="`j'"
}

gen wedge=salepr/price
gen lnpricehat=ln(price)-ln(lastsalepr)+delta0

gen monthl=month(numdatel)
gen quarter=1 if monthl<=3
replace quarter=2 if monthl>3 & monthl<=6 
replace quarter=3 if monthl>6 & monthl<=9 
replace quarter=4 if monthl>9 & monthl<=12 
gen qy=year(numdatel)*10+quarter

drop if qy==20124 |  qy==20123 | qy==20074

drop temp
gen temp=1
collapse  (median) wedge lnpricehat datediff_c (p25) p25wedge=wedge p25lnpricehat=lnpricehat p25datediff_c=datediff_c (p75) p75wedge=wedge p75lnpricehat=lnpricehat p75datediff_c=datediff_c (sum) temp,by (qy mergetype_c)

sort qy mergetype_c
gen ratio=-1*(lnpricehat-lnpricehat[_n-1])
gen ratio25=-1*(p25lnpricehat-p25lnpricehat[_n-1])
gen ratio75=-1*(p75lnpricehat-p75lnpricehat[_n-1])
gen share=temp/(temp+temp[_n-1])
drop if mergetype_c==0
drop lnpricehat

gen m=_n
scatter p25wedge wedge p75wedge m, connect( l l l) legend(order(1 "p25" 2 "p50" 3 "p75")) xtitle("")   saving(saletolist.gph,replace) xlabel( 1 "Q1-2008" 2 "Q2-2008" 3  "Q3-2008" 4 "Q4-2008"  5 "Q1-2009"  6 "Q2-2009"  7 "Q3-2009"  8 "Q4-2009"  9 "Q1-2010"  10 "Q2-2010"  11 "Q3-2010"  12 "Q4-2010"  13 "Q1-2011"  14 "Q2-2011"  15 "Q3-2011"  16 "Q4-2011"  17 "Q1-2012"  18  "Q2-2012",angle(90))
graph export saletolist.ps,replace
!ps2pdf saletolist.ps saletolist.pdf

scatter ratio m, connect( l ) xtitle("")   saving(pricehat.gph,replace) ytitle("") xlabel( 1 "Q1-2008" 2 "Q2-2008" 3  "Q3-2008" 4 "Q4-2008"  5 "Q1-2009"  6 "Q2-2009"  7 "Q3-2009"  8 "Q4-2009"  9 "Q1-2010"  10 "Q2-2010"  11 "Q3-2010"  12 "Q4-2010"  13 "Q1-2011"  14 "Q2-2011"  15 "Q3-2011"  16 "Q4-2011"  17 "Q1-2012"  18  "Q2-2012",angle(90))
graph export pricehat.ps,replace
!ps2pdf pricehat.ps pricehat.pdf

scatter share m, connect( l )  xtitle("")   saving(shareleadingtosales.gph,replace) xlabel( 1 "Q1-2008" 2 "Q2-2008" 3  "Q3-2008" 4 "Q4-2008"  5 "Q1-2009"  6 "Q2-2009"  7 "Q3-2009"  8 "Q4-2009"  9 "Q1-2010"  10 "Q2-2010"  11 "Q3-2010"  12 "Q4-2010"  13 "Q1-2011"  14 "Q2-2011"  15 "Q3-2011"  16 "Q4-2011"  17 "Q1-2012"  18  "Q2-2012",angle(90))
graph export shareleadingtosales.ps,replace
!ps2pdf shareleadingtosales.ps shareleadingtosales.pdf



************
**MAKE FIGURE 2
************
local msamacro="pho seattle dc denver sandiego chi sanfran vegas"

use tempmatchla.dta,clear
foreach j in `msamacro' {
append using tempmatch`j'.dta, force
}
drop foreauction
reshape wide match, i(qy) j(cityid) string
drop in 1/77
gen m=_n
scatter matchchi matchdc matchdenver matchla matchpho matchsandiego matchsanfran matchseattle matchvegas m if m>=6, connect(l l l l l l l l l) legend(order(1 "chi" 2 "dc" 3 "denver" 4 "la" 5 "pho" 6 "sandiego"  7 "sanfran" 8 "seattle" 9 "vegas")) xtitle("") msymbol(O + T D X Oh Dh Xh Sh)  saving(t1.gph,replace) xlabel(6 "Q1-2009"  7 "Q2-2009"  8 "Q3-2009"  9 "Q4-2009"  10 "Q1-2010"  11 "Q2-2010"  12 "Q3-2010"  13 "Q4-2010"  14 "Q1-2011"  15 "Q2-2011"  16 "Q3-2011"  17 "Q4-2011"  18 "Q1-2012"  19  "Q2-2012" 20  "Q3-2012" 21  "Q4-2012",angle(90)) ylabel(0 (.1) 1)  
graph export matchrates.ps,replace
!ps2pdf matchrates.ps matchrates.pdf


**************************
**MAKE FIGURE 1
************************

use temp11e_la_r2.dta,clear
gen cityid="la"

foreach j in `msamacro' {
append using temp11e_`j'_r2.dta, force
replace cityid="`j'" if cityid==""
}

keep if mergetype_c==1
gen closingtime=2
replace closingtime=4 if datediff_c>14 & datediff_c<=28
replace closingtime=6 if datediff_c>28 & datediff_c<=56
replace closingtime=8 if datediff_c>56 & datediff_c<=70
replace closingtime=10 if datediff_c>70 &datediff <=84
replace closingtime=12 if datediff_c>84 
gen temp=1
collapse (sum) temp,by(closingtime)
egen temp2=sum(temp)
gen share=temp/temp2
graph bar share,over( closingtime,relabel( 1 "<=2" 2 "2 to 4" 3 "4 to 6" 4 "6 to 8" 5 "8 to 10" 6 ">10"))  ytitle("Fraction") saving(closing.gph,replace)
graph export closinglag.ps,replace logo(off)
!ps2pdf closinglag.ps closinglag.pdf



