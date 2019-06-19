
/*do file name: cleanlanddata.do,

read original land transaction data, clean the data to estimate
how floor-area ratio affect land price
Originally created by: Shihe Fu
Last modified by: Junfu Zhang on 2/10/2014

*/

clear matrix

log using cleanlanddata, t replace

set rmsg on
set more off
set matsize 800
set memory 1g
set varlabelpos 15


use landdata.dta
/*
              storage  display     value
variable name   type   format      label      variable label
---------------------------------------------------------------------------------------
id              str6   %9s                    
city            str20  %20s                   城市
parcelname      str200 %49s                   地块名称
landusage       str244 %40s                   规划用途
floorarea       str12  %12s                   建筑面积
plannedfloora~a str12  %12s                   规划建筑面积
startingprice   str10  %10s                   出让起始价
typeofsale      str8   %9s                    出让方式
parcelid        str192 %40s                   地块编号
floorarealots~o str179 %31s                   容积率, total floor area/total land
greencoverage   str140 %31s                   绿化率
address         str244 %40s                   位置
boundary        str244 %40s                   四至
district        str18  %18s                   区县
structuredens~y str176 %36s                   建筑密度
businessuage    str140 %21s                   商业比例
heightlimit     str162 %21s                   高度限制
startday        str10  %10s                   起始日期
endday          str10  %10s                   截止日期
priceperfloor~a str9   %9s                    楼面价
priceperunitl~d str11  %11s                   土地单价
deposit         str34  %24s                   保证金
minincreasefo~d str46  %36s                   最小加价幅度
winner          str187 %36s                   竞得方
sellingprice    str10  %10s                   成交价
premiumrate     str8   %9s                    溢价率
transactionday  str22  %22s                   交易日期
*/
drop id
count //Full sample size



/*part 1: standardize date*/
replace transactionday="2011-09-20" if transactionday=="葫芦岛天宝化工有限公司"


gen transyear=substr(transactionday, 1,4) if length(transactionday)>=4
//replace transyear="2011" if transyear=="葫芦"
/*typo in the original data*/
tab transyear
gen transmonth=substr(transactionday, 6,2) if length(transactionday)>=6
tab transmonth
//replace transmonth="09" if transmonth=="禾"
/*typo in the original data*/
gen transday=substr(transactionday, length(transactionday)-1,2) if length(transactionday)>=6
tab transday
replace transday="20" if transday=="˾"
/*typo in original data*/
gen transdatenew=transyear+transmonth+transday


  gen startyear=substr( startday,1,4) if length( startday)>=4
  gen endyear=substr( endday,1,4) if length( endday)>=4
  count if startyear==endyear
  count if startyear~=endyear
  count if startyear==""&endyear==""&transyear==""
  drop if startyear==""&endyear==""&transyear==""
  /*only one observation has missing date, drop it*/
/*may construct an imputed year, use endyear to replace missing transyear*/

count //2 obs. dropped because date info is unavailable


/*part 2: clean floorarearatio variable, generate minimum FAR*/
 
 order floorarealotsizeratio structuredensity

 count if  floorarealotsizeratio=="-"
 /*for these observation, floorarealotsizeratio is missing,8641 missing, drop them*/
 drop if floorarealotsizeratio=="-"
 
 drop if floorarealotsizeratio=="-01"
 drop if floorarealotsizeratio=="0"
 drop if floorarealotsizeratio=="≥0"
 
 count //Dropped obs. with FAR missing (8641) or not reasonable (<= 0, 16 obs.)
 
 
 /*clearn this case: &nbsp;≥0.8*/
 
 replace floorarealotsizeratio=substr(floorarealotsizeratio, strpos(floorarealotsizeratio,";")+1, ///
 length(floorarealotsizeratio)-strpos(floorarealotsizeratio,";"))
 
 
 /*generate minimum floor area-lot size ratio,greater or equal to a number*/

gen minfloorlotratio=real(floorarealotsizeratio)
order minfloorlotratio, after(floorarealotsizeratio)

replace minfloorlotratio=real(substr(floorarealotsizeratio, 3, length(floorarealotsizeratio)-2)) ///
if substr(floorarealotsizeratio,1,2)=="≥"|substr(floorarealotsizeratio,1,2)==">" ///
|substr(floorarealotsizeratio,1,2)=="≥"|substr(floorarealotsizeratio,1,2)=="≮"

/* for this type: 0.7-1.2; 2.0～3.0  */
replace minfloorlotratio=real(substr(floorarealotsizeratio, 1, strpos(floorarealotsizeratio,"-")-1)) ///
if strpos(floorarealotsizeratio,"-")>=2& minfloorlotratio==.

replace minfloorlotratio=real(substr(floorarealotsizeratio, 1, strpos(floorarealotsizeratio,"～")-1)) ///
if strpos(floorarealotsizeratio,"～")>=2& minfloorlotratio==.

/*clearn this case: 1.2－1.8*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 1, strpos(floorarealotsizeratio,"－")-1)) ///
if strpos(floorarealotsizeratio,"－")>=2& minfloorlotratio==.

/*clearn this case: 介于0.7至2.0之间*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 5, strpos(floorarealotsizeratio,"至")-5)) ///
if substr(floorarealotsizeratio,1,4)=="介于"& minfloorlotratio==.

/*clean this case: 大于0.8小于1.2*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 5, 3)) ///
if substr(floorarealotsizeratio,1,4)=="大于"& minfloorlotratio==.


/*clean for this case: 1≤容积率≤1.8*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 1, strpos(floorarealotsizeratio,"＜容")-1)) ///
if strpos(floorarealotsizeratio,"＜容")>=2& minfloorlotratio==.

replace minfloorlotratio=real(substr(floorarealotsizeratio, 1, strpos(floorarealotsizeratio,"≤容")-1)) ///
if strpos(floorarealotsizeratio,"≤容")>=2& minfloorlotratio==.

/*clean for this case: 等于3.3, treat as both minimum and maximum*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 5, length(floorarealotsizeratio)-4)) ///
if substr(floorarealotsizeratio,1,4)=="等于"& minfloorlotratio==.

/*clearn this case: 1.0以上、2.0以下*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 1, strpos(floorarealotsizeratio,"以上")-1)) ///
if strpos(floorarealotsizeratio,"以上")>=2& minfloorlotratio==.


/*clearn this case: 不小于0.7*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 7, length(floorarealotsizeratio)-6)) ///
if substr(floorarealotsizeratio,1,6)=="不小于"& minfloorlotratio==.
/*clearn this case: 不小于0.7，不大于1.6*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 7,3)) ///
if substr(floorarealotsizeratio,1,6)=="不小于"& minfloorlotratio==.


/*clean this case: ≥0.8且≤2.0*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 3, 3)) ///
if substr(floorarealotsizeratio,1,2)=="≥" & minfloorlotratio==.

/*clean this case: ≧0.7*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 3, length(floorarealotsizeratio)-2)) ///
if substr(floorarealotsizeratio,1,2)=="≧" & minfloorlotratio==.
/*clearn this case: ＞1.0*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 3, length(floorarealotsizeratio)-2)) ///
if substr(floorarealotsizeratio,1,2)=="＞" & minfloorlotratio==.


/*clean this case: 0.6<容积率≤0.8*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 1, strpos(floorarealotsizeratio,"<容")-1)) ///
if strpos(floorarealotsizeratio,"<容")>=2& minfloorlotratio==.

 /*clean this case: 不低于1.0*/
 replace minfloorlotratio=real(substr(floorarealotsizeratio, 7, length(floorarealotsizeratio)-6)) ///
if substr(floorarealotsizeratio,1,6)=="不低于" & minfloorlotratio==.
/*clean this case: 不低于1.0不高于3.0*/
replace minfloorlotratio=real(substr(floorarealotsizeratio, 7, 3)) ///
if substr(floorarealotsizeratio,1,6)=="不低于" & minfloorlotratio==.

/*needs to do more clearning, but we care more about maximum*/
count //Dropped obs. with FAR missing (8641) or not reasonable (<= 0, 16 obs.)



/*part 3: generate maximum floor area-lot size ratio,greater or equal to a number*/

gen maxfloorlotratio=real(floorarealotsizeratio)
order floorarealotsizeratio maxfloorlotratio

/*some has 4 digit*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, 3,4)) ///
if (substr(floorarealotsizeratio, 1,2)=="≤"|substr(floorarealotsizeratio,1,2)=="<" /// 
|substr(floorarealotsizeratio,1,2)=="＜"|substr(floorarealotsizeratio,1,2)=="≯") &maxfloorlotratio==. ///
&length(floorarealotsizeratio)==6

/*then, truncate the 3 digit*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, 3, 3)) ///
if (substr(floorarealotsizeratio, 1,2)=="≤"|substr(floorarealotsizeratio,1,2)=="<" /// 
|substr(floorarealotsizeratio,1,2)=="＜"|substr(floorarealotsizeratio,1,2)=="≯")& maxfloorlotratio==. ///
&length(floorarealotsizeratio)==5

/*clearn this case: 1.01-1.05*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio, "-")+1, /// 
length(floorarealotsizeratio)-strpos(floorarealotsizeratio, "-"))) if /// 
strpos( floorarealotsizeratio, "-")>1&maxfloorlotratio==.

replace maxfloorlotratio=-maxfloorlotratio if maxfloorlotratio<0
/*some items has two -- in between*/
/*clearn this case: 0.7—1.5, two bytes*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio, "—")+2, /// 
length(floorarealotsizeratio)-strpos(floorarealotsizeratio, "—")-1)) if /// 
strpos( floorarealotsizeratio, "—")>1&maxfloorlotratio==.

/*clean this case: ＞0.8、＜2.0*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio, "＜")+2, /// 
length(floorarealotsizeratio)-strpos(floorarealotsizeratio, "＜")-1)) if /// 
strpos( floorarealotsizeratio, "＜")>4&maxfloorlotratio==.


/*clearn this case: 0.8－1.2*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio,"－")+2, /// 
length(floorarealotsizeratio)-strpos(floorarealotsizeratio, "－")+1)) if /// 
strpos(floorarealotsizeratio,"－")>1 & maxfloorlotratio==.
/*clearn this case: 1.0～1.5*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio,"～")+2, /// 
length(floorarealotsizeratio)-strpos(floorarealotsizeratio, "～")+1)) if /// 
strpos(floorarealotsizeratio,"～")>1 & maxfloorlotratio==.

/*clean this case: <1.20, <1.3takes one byte*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio,"<")+1,3)) if /// 
strpos(floorarealotsizeratio,"<")>1 & maxfloorlotratio==.

replace maxfloorlotratio=real(substr(floorarealotsizeratio, 2,3)) if /// 
substr(floorarealotsizeratio,1,1)=="<" & maxfloorlotratio==.

/*clean this case: 1.0以上2.0以下 */
/*four digit first, then 3 digit*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio,"以下")-4,4)) if /// 
strpos(floorarealotsizeratio,"以下")>3 & maxfloorlotratio==.
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio,"以下")-3,3)) if /// 
strpos(floorarealotsizeratio,"以下")>3 & maxfloorlotratio==.


/*clean this case: 等于2.4, treat this as maximum too*/
replace maxfloorlotratio=real(substr( floorarealotsizeratio,5,length(floorarealotsizeratio)-4)) /// 
if substr( floorarealotsizeratio, 1,4)=="等于"&maxfloorlotratio==.
 
 /*clearn this case: 不大于1.5 不高于"  */
replace maxfloorlotratio=real(substr( floorarealotsizeratio, 7, 3)) /// 
if substr( floorarealotsizeratio, 1,6)=="不大于"&maxfloorlotratio==.
/*clearn this case: 不小于1.6,不大于2.0*/
replace maxfloorlotratio=real(substr( floorarealotsizeratio,strpos(floorarealotsizeratio,"不大于")+6, 3)) /// 
if strpos(floorarealotsizeratio,"不大于")>6 &maxfloorlotratio==.


replace maxfloorlotratio=real(substr( floorarealotsizeratio, 7, 3)) /// 
if substr( floorarealotsizeratio, 1,6)=="不高于"&maxfloorlotratio==.

/*clearn this case: 不低于6.0，不高于6.7*/
replace maxfloorlotratio=real(substr( floorarealotsizeratio,strpos(floorarealotsizeratio,"不高于")+6, 3)) /// 
if strpos(floorarealotsizeratio,"不高于")>6 &maxfloorlotratio==.

/*clean this case: 小于或等于1.5*/
replace maxfloorlotratio=real(substr( floorarealotsizeratio,11,length(floorarealotsizeratio)-10)) /// 
if substr(floorarealotsizeratio,1,10)=="小于或等于" &maxfloorlotratio==.

/*clearn this case:《1.3*/
replace maxfloorlotratio=real(substr( floorarealotsizeratio, 3, 3)) /// 
if substr( floorarealotsizeratio, 1,2)=="《"&maxfloorlotratio==.
/*clean this case:≦3.0*/
replace maxfloorlotratio=real(substr( floorarealotsizeratio,strpos(floorarealotsizeratio,"≦")+2, 3)) /// 
if strpos(floorarealotsizeratio,"≦")>=1 &maxfloorlotratio==.


/*clearn this ≥1.0、≤1.8*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio,"≤")+2,3)) if /// 
strpos(floorarealotsizeratio,"≤")>1 & maxfloorlotratio==.
/*clean this case﹤2.0, two bytes*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, 3, length(floorarealotsizeratio)-2)) if /// 
substr(floorarealotsizeratio,1,2)=="﹤" & maxfloorlotratio==.

/*clean this case: 1.0≤FAR≤1.6*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio,"R≤")+3, ///
length(floorarealotsizeratio)-strpos(floorarealotsizeratio,"R≤")-2)) if /// 
strpos(floorarealotsizeratio,"FAR≤")>1 & maxfloorlotratio==.

/*clearn this case: 1≤容积率≤2.50*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio,"率≤")+4, ///
length(floorarealotsizeratio)-strpos(floorarealotsizeratio,"率≤")-3)) if /// 
strpos(floorarealotsizeratio,"率≤")>1 & maxfloorlotratio==.
/*clean this case: 0.8＜容积率＜1.5*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, strpos(floorarealotsizeratio,"率＜")+4, ///
length(floorarealotsizeratio)-strpos(floorarealotsizeratio,"率＜")-3)) if /// 
strpos(floorarealotsizeratio,"率＜")>1 & maxfloorlotratio==.


/*clearn this case: 介于0.80与1.50*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio, length(floorarealotsizeratio)-3,4)) if /// 
substr(floorarealotsizeratio,1,4)=="介于"& maxfloorlotratio==.

/*clean this case: 最大3.0，最小2.4*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio,5,4)) if /// 
substr(floorarealotsizeratio,1,4)=="最大"& maxfloorlotratio==.

replace maxfloorlotratio=real(substr(floorarealotsizeratio,5,3)) if /// 
substr(floorarealotsizeratio,1,4)=="最大"& maxfloorlotratio==.

/*clearn this case: 小于2.37*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio,5,length(floorarealotsizeratio)-4)) if /// 
substr(floorarealotsizeratio,1,4)=="小于"& maxfloorlotratio==.

/*clearn this case: ≤3, 3 bytes*/
replace maxfloorlotratio=real(substr(floorarealotsizeratio,3,length(floorarealotsizeratio)-2)) if /// 
substr(floorarealotsizeratio,1,2)=="≤"& maxfloorlotratio==.

/*part 3: other variables*/

/*selling price*/
gen saleprice=real(sellingprice)    /*in 10000 RBM, many of is close to pricefar*floorareas*/

gen pricefar=real(priceperfloorarea)   /*RMB, land price averaged to per square meter floor area*/

gen landprice=real(priceperunitland)    /*price of land: RMB per square meter unit of land*/

gen floorareas=real(floorarea)   

/*land uage*/
gen residential=0
replace residential=1 if strpos(landusage, "住")>0

gen commercial=0
replace commercial=1 if strpos(landusage,"商")>0|strpos(landusage,"办")>0|strpos(landusage,"酒店")>0

replace commercial=0 if strpos(landusage,"商品住房")>0 & strpos(landusage,"商业")==0 ///
& strpos(landusage,"商服")==0        //This line added to Shihe's code by Junfu 12/19/2014

replace commercial=1 if strpos(landusage,"住宿餐饮")>0 //These two lines are added by Junfu 12/19/2014
replace residential=0 if strpos(landusage,"住宿餐饮")>0 & strpos(landusage,"住宅")==0 ///
& strpos(landusage,"住房")==0


count // Dropped obs. with FAR missing (8641) or not reasonable (<= 0, 16 obs.) 
 
 
 
 /*part 4: merge with city level attributes data*/
 gen year=real(transyear)
 order city year
 replace city=substr(address, 1,6) if city==""
 
 replace year=real(endyear) if year==.&endyear~=""
 
 drop if landprice==.
 drop if maxfloorlotratio==.
 count // Dropped obs. with missing land price or missing FAR
 
 
 order city year landprice maxfloorlotratio residential commercial district
  
 sort city year
 

 
 merge m:1 city year using citylevelupdated_2 
 
 /*
  Result                           # of obs.
    -----------------------------------------
    not matched                         3,158
        from master                       603  (_merge==1)
        from using                      2,555  (_merge==2)

    matched                            63,889  (_merge==3)

*/

keep if _merge==3
drop _merge


/*************************************************************************
Before dropping outliers, saving all observations for Beijing, so that it
can be merged with FAR change data for Beijing.
12/5/2014
**************************************************************************
keep if city == "北京市" & (residential == 1 | commercial == 1)
count if residential == 1
count if commercial == 1
save BeijingLandData, replace
*/


/*****************************************************************************
Before dropping outliers, saving all observations for residential land sales,
so that we can explore the matched-pairs approach.
12/6/2014
******************************************************************************
keep if residential == 1
count

sort city district year landusage address

ge address12 =  substr( address, 1, 24)
count if city==city[_n-1] & district==district[_n-1] & year==year[_n-1] & ///
landusage== landusage[_n-1]& address12== address12[_n-1]

ge address10 =  substr( address, 1, 20)
count if city==city[_n-1] & district==district[_n-1] & year==year[_n-1] & ///
landusage== landusage[_n-1]& address10== address10[_n-1]

ge pair = .
replace pair = _n if city==city[_n-1] & district==district[_n-1] & year==year[_n-1] & ///
landusage== landusage[_n-1]& address12== address12[_n-1]

replace pair = _n if city==city[_n+1] & district==district[_n+1] & year==year[_n+1] & ///
landusage== landusage[_n+1]& address12== address12[_n+1]

replace pair = pair[_n-1] if pair != . & pair[_n-1] != . ///
& city==city[_n-1] & district==district[_n-1] & year==year[_n-1] & ///
landusage== landusage[_n-1]& address12== address12[_n-1]

ge lnlandprice=log(landprice)
ge lnmaxfar=log(maxfloorlotratio)
xi: areg lnlandprice lnmaxfar, a(pair) cl(city)

save ResidentialLandSales, replace
*/

/*****************************************************************************
Before dropping outliers, saving all observations for commercial land sales,
so that we can explore the matched-pairs approach.
12/9/2014
******************************************************************************
keep if commercial == 1
count

sort city district year landusage address

ge address12 =  substr( address, 1, 24)
count if city==city[_n-1] & district==district[_n-1] & year==year[_n-1] & ///
landusage== landusage[_n-1]& address12== address12[_n-1]

ge address10 =  substr( address, 1, 20)
count if city==city[_n-1] & district==district[_n-1] & year==year[_n-1] & ///
landusage== landusage[_n-1]& address10== address10[_n-1]

ge pair = .
replace pair = _n if city==city[_n-1] & district==district[_n-1] & year==year[_n-1] & ///
landusage== landusage[_n-1]& address12== address12[_n-1]

replace pair = _n if city==city[_n+1] & district==district[_n+1] & year==year[_n+1] & ///
landusage== landusage[_n+1]& address12== address12[_n+1]

replace pair = pair[_n-1] if pair != . & pair[_n-1] != . ///
& city==city[_n-1] & district==district[_n-1] & year==year[_n-1] & ///
landusage== landusage[_n-1]& address12== address12[_n-1]

ge lnlandprice=log(landprice)
ge lnmaxfar=log(maxfloorlotratio)
xi: areg lnlandprice lnmaxfar, a(pair) cl(city)

save CommercialLandSales, replace
*/



sum landprice, detail
sum maxfloorlotratio, detail
/*drop outliers in top and bottom 1% of landprice or maxfloorlotratio*/
drop if landprice<90.71 | landprice>26457.67 | maxfloorlotratio<0.3 | maxfloorlotratio>7.5
count // Dropped outliers in top and bottom 1% of landprice or maxfloorlotratio

tab year
drop if year==2000|year==2001  /*too few observations in these years*/
count // Dropped if year = 2000 or 2001


gen population=popinnercity //This is now 市辖区年末总人（万人）, updated by Junfu 3/4/2014

gen lnlandprice=log(landprice)
gen lnmaxfar=log(maxfloorlotratio)

sort city
egen cityid=group(city)

sort city district
egen locationcode=group(city district)
replace locationcode=cityid*10000 if locationcode==.


tab year,generate(yearcode)
tab city, generate(citycode)

sum landprice maxfloorlotratio residential commercial
count if residential == 1
count if commercial == 1
count if residential*commercial == 1

save CleanedLandData.dta, replace

clear

log close

