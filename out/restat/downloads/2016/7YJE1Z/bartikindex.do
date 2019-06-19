
/*do file name: Bartickindex.do

follow Bartick (1991),construct the Bartick index for each city, each year, 
follow appendix A in Saks (2008) JUE paper

This Bartik index is used to proxy for labor demand shock, which is the predicted
change (growth) in labor demand. It is a weighted average of national industry growth 
rates, the weights are the share of an indusry's employment (relative to total 
city employment).
Three indexes are generated in this do file:

bartikindex1: weighted national industry growth, weights are industry emp share
in a city (lagged one year);

bartikindex2: weighted national industry growth, weights are industry emp share
in a city (lagged one year); national ind emp growth excludes ind emp in a city


bartikindex3: weighted relative national industry growth, weights are industry emp share
in a city (lagged one year); relative national industry growth is national industry 
growth minus national emp growth;

bartikindex4: same as bartikindex2 but the national industry emp excludes ind 
emp of a particular city in question, this is Saks' appendix formula.

There may other ways to construct this index, but only need to edit this do
file slightly

Note: employment by industry is only for "unit" (danwei) emp, excluding
private sectors. Industry classification is consistent from 2003, so the final
bartik index is only available for 2004-2011*/

set more off
use CityYearsbook_1999_2011.dta

/*w*:whole city;  c*: inner city; consistent industry classification are 
available only from 2003-2011*/

rename a1153 wtotalemp /*全市年末单位从业人员数(万人)*/
rename a1154 ctotalemp /*市辖区年末单位从业人员数(万人)*/

rename a1013  windustry1 /* 全市第一产业(农.林.牧.渔业)单位从业人员统计(万人)*/
rename a1014  cindustry1  /*市辖区第一产业(农.林.牧.渔业)单位从业人员统计(万人)*/
 
rename a1015  windustry2  /* 全市采矿业单位从业人员统计(万人)*/
rename a1016  cindustry2  /* 市辖区采矿业单位从业人员统计(万人)*/

rename a1017  windustry3  /*全市制造业单位从业人员统计(万人)*/
rename a1018  cindustry3  /* 市辖区制造业单位从业人员统计(万人)*/

rename a1019  windustry4  /*全市电力.燃气及水的生产和供应业单位从业人员统计(万人)*/
rename a1020  cindustry4  /*市辖区电力.燃气及水的生产和供应业单位从业人员统计(万*/
                                           
rename a1021  windustry5  /* 全市建筑业单位从业人员统计(万人)*/
rename a1022  cindustry5  /* 市辖区建筑业单位从业人员统计(万人)*/

rename a1023  windustry6  /* 全市交通运输.仓储及邮政业单位从业人员统计(万人)*/
rename a1024  cindustry6   /*市辖区交通运输.仓储及邮政业单位从业人员统计(万人)*/

rename a1025  windustry7   /* 全市信息传输.计算机服务和软件业单位从业人员统计(万人)*/
rename a1026  cindustry7   /*  市辖区信息传输.计算机服务和软件业单位从业人员统计(万*/

rename a1027  windustry8  /* 全市批发和零售业单位从业人员统计(万人)*/
rename a1028  cindustry8  /* 市辖区批发和零售业单位从业人员统计(万人)*/

rename a1029 windustry9    /*全市住宿.餐饮业单位从业人员统计(万人)*/
rename a1030 cindustry9    /*市辖区住宿.餐饮业单位从业人员统计(万人)*/

rename a1031 windustry10   /*  全市金融业单位从业人员(万人)*/
rename a1032 cindustry10   /*市辖区金融业单位从业人员(万人)*/

rename a1033 windustry11    /*全市房地产业单位从业人员(万人)*/
rename a1034 cindustry11    /* 市辖区房地产业单位从业人员(万人)*/

rename a1035 windustry12     /*全市租赁和商业服务业单位从业人员(万人)*/
rename a1036 cindustry12      /*市辖区租赁和商业服务业单位从业人员(万人)*/

rename a1037 windustry13     /* 全市科学研究.技术服务和地质勘查业单位从业人员(万人)*/
rename a1038 cindustry13     /* 市辖区科学研究.技术服务和地质勘查业单位从业人员(万人*/

rename a1039 windustry14     /* 全市水利.环境和公共设施管理业单位从业人员(万人）*/
rename a1040 cindustry14     /*市辖区水利.环境和公共设施管理业单位从业人员(万人）*/
 
rename a1041 windustry15     /* 全市居民服务和其他服务业单位从业人员(万人)*/
rename a1042 cindustry15     /* 市辖区居民服务和其他服务业单位从业人员(万人)*/

rename a1043 windustry16     /*全市教育业单位从业人员(万人)*/
rename a1044 cindustry16     /* 市辖区教育业单位从业人员(万人)*/

rename a1045 windustry17     /* 全市卫生.社会保障和社会福利业(万人)*/
rename a1046 cindustry17     /* 市辖区卫生.社会保障和社会福利业(万人)*/

rename a1047 windustry18    /* 全市文化.体育和娱乐业(万人)*/
rename a1048 cindustry18    /* 市辖区文化.体育和娱乐业(万人)*/

rename a1049  windustry19   /* 全市公共管理和社会组织(万人)*/
rename a1050  cindustry19   /* 市辖区公共管理和社会组织(万人)*/

/*the following classification is available only in 1999-2002*/
/*a1309           double %10.0g                 全市社会服务业从业人员数（万人）
a1310           double %10.0g                 市辖区社会服务业从业人员数（万人）
a1311           double %10.0g                 全市卫生体育社会福利业从业人员数（万人）
a1312           double %10.0g                 市辖区卫生体育社会福利业从业人员数（万人）
a1313           double %10.0g                 全市教育文艺广播影视业从业人员数（万人）
a1314           double %10.0g                 市辖区教育文艺广播影视业从业人员数（万人）
a1315           double %10.0g                 全市科研综合技术服务业从业人员数（万人）
a1316           double %10.0g                 市辖区科研综合技术服务业从业人员数（万人）
a1317           double %10.0g                 全市机关和社会团体从业人员数（万人）
a1318           double %10.0g                 市辖区机关和社会团体从业人员数（万人）                                                > ?                                            > 
a1307           double %10.0g                 全市地质勘察，水利管理业从业人数（万人）
a1308           double %10.0g                 市辖区地质勘察，水利管理业从业人数（万人）
*/

/*use only data from 2003*/
keep if year>=2003
/*since obs for windustry is slightly larger than obs. for cindustry, use whole
city inudstry emp to compute Bartik index*/

keep city city_pinyin provc prov_cn year windustry*

order provc prov_cn city city_pinyin year windustry1-windustry19

sort provc prov_cn city city_pinyin year

reshape long windustry, i(provc prov_cn city city_pinyin year) j(inducode)

/*inducode: industry code
windustry: total employment of industry i*/

/*part 1: compute national, city level total employment, and their growth rates*/

/*generate national total employment for the whole country*/
sort year city inducode
by year: egen nationalemp=total(windustry)

/*growth rate of national employment*/
sort inducode city year
by inducode city: gen nationgrowth=(nationalemp-nationalemp[_n-1])/nationalemp[_n-1]

/*generate national total employment for each industry*/
sort inducode year city
by inducode year: egen nationalindemp=total(windustry)

/*generate growth rate of national employment by industry and by year*/
sort inducode city year
by inducode city: gen nationindgrowth=(nationalindemp-nationalindemp[_n-1])/nationalindemp[_n-1]
/*excluding industry emp in the city in question*/
by inducode city: gen nationindgrowth2=((nationalindemp-windustry) /// 
-(nationalindemp[_n-1]-windustry[_n-1]))/(nationalindemp[_n-1]-windustry[_n-1])


/*gen total city emp each year*/
sort city year inducode
by city year: egen cityemp=total(windustry)

/*gen share of city industry emp relative to city total emp*/
gen cityindshare=windustry/cityemp

/*gen lagged one year share of city industry emp relative to city total emp*/

sort city inducode year
gen cityindsharelag=cityindshare[_n-1]

/*part 2: gen predicted industry-city emp growth and compute bartik indexes*/
sort city year inducode

gen indcityempp1=cityindsharelag*(nationindgrowth)
/*simple weighted average: ind emp share in a city*national ind emp growth)*/

gen indcityempp2=cityindsharelag*(nationindgrowth2)
/*simple weighted average: ind emp share in a city*national ind emp growth,
but national ind emp growth excludes ind emp in a city*/

gen indcityempp3=cityindsharelag*(nationindgrowth-nationgrowth)
/*this is the term within the summation on page 194 of Saks(2008), but the 
national industry growth include industry emp in all cities*/

gen indcityempp4=cityindsharelag*(nationindgrowth2-nationgrowth)
/*this is the term within the summation on page 194 of Saks(2008), the 
national industry growth excludes industry emp in all cities*/

/*part 3: generate bartik index*/
/*generate the labor demand shock for each city*/
by city year: egen bartikindex1=total(indcityempp1)
by city year: egen bartikindex2=total(indcityempp2)
by city year: egen bartikindex3=total(indcityempp3)
by city year: egen bartikindex4=total(indcityempp4)

/*collaspe the bartik indexes by city year*/

sort city year
collapse (mean) bartikindex1 bartikindex2 bartikindex3 bartikindex4, by(city year)

/*
bartikindex1: weighted national industry growth, weights are industry emp share
in a city;

bartikindex2: weighted national industry growth, weights are industry emp share
in a city; national ind emp growth exclude ind emp in a particular city;


bartikindex3: weighted relative national industry growth, weights are industry emp share
in a city; relative national industry growth is national industry growth minus 
national emp growth;

bartikindex4: same as 2 but the national industry emp excludes ind emp of a particular
city, this is Saks' appendix formula*/

save bartikindex1234.dta, replace






