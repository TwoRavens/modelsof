* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Settings
*********************

**** 1) newregime == 1 & kei == 0
if $regime == 1 & $kei == 0 {

global notchlist "980 1090 1200 1320 1430 1540 1660 1770 1880 2000 2110 2280"

global dataset "DataStata/data_20092013"
global rawdataset "DataStata/raw_data_20092013"

global lst_notch860 = 840
global next_notch860 = 980

global lst_notch980 = 860
global next_notch980 = 1090

global lst_notch1090 = 980
global next_notch1090 = 1200

global lst_notch980 = 860
global next_notch980 = 1090

global lst_notch1090 = 980
global next_notch1090 = 1200

global lst_notch1200 = 1090
global next_notch1200 = 1320

global lst_notch1320 = 1200
global next_notch1320 = 1430

global lst_notch1430 = 1320
global next_notch1430 = 1540

global lst_notch1540 = 1430
global next_notch1540 = 1660

global lst_notch1660 = 1540
global next_notch1660 = 1770

global lst_notch1770 = 1660
global next_notch1770 = 1880

global lst_notch1880 = 1770
global next_notch1880 = 2000

global lst_notch2000 = 1880
global next_notch2000 = 2110

global lst_notch2110 = 2000
global next_notch2110 = 2280

global lst_notch2280 = 2110
global next_notch2280 = 9999

global final_notch = 2280

loc e1 = 20.8
loc e2 = 20.5
loc e3 = 18.7
loc e4 = 17.2
loc e5 = 15.8
loc e6 = 14.4
loc e7 = 13.2
loc e8 = 12.2
loc e9 = 11.1
loc e10 = 10.2
loc e11 = 9.4
loc e12 = 8.7
loc e13 = 7.4

loc i = 1
foreach notch in $notchlist {
loc j = `i'+1
global e0_notch`notch' = `e`i''
global e1_notch`notch' = `e`j''
loc i = `i'+1
}

}
****

**** 2) newregime == 0 & kei == 0
if $regime == 0 & $kei == 0 {

global notchlist "830 1020 1270  1520 1770 2020 2270"
global dataset "DataStata/data_20002008"
global rawdataset "DataStata/raw_data_20002008"

global lst_notch830 = 700
global next_notch830 = 1020

global lst_notch1020 = 830
global next_notch1020 = 1270

global lst_notch1270 = 1020
global next_notch1270 = 1520

global lst_notch1520 = 1270
global next_notch1520 = 1770

global lst_notch1770 = 1520
global next_notch1770 = 2020

global lst_notch2020 = 1770
global next_notch2020 = 2270

global lst_notch2270 = 2020
global next_notch2270 = 9999

global final_notch = 2270

loc e1 = 18.8
loc e2 = 17.9
loc e3 = 16
loc e4 = 13
loc e5 = 10.5
loc e6 = 8.9
loc e7 = 7.8
loc e8 = 6.4

loc i = 1
foreach notch in $notchlist {
loc j = `i'+1
global e0_notch`notch' = `e`i''
global e1_notch`notch' = `e`j''
loc i = `i'+1
}

}
****

**** 2) newregime == 1 & kei == 1
if $regime == 1 & $kei == 1 {

global notchlist "860 980"

global dataset "DataStata/data_20092013_kei"
global rawdataset "DataStata/raw_data_20092013_kei"

global lst_notch860 = 710
global next_notch860 = 980

global lst_notch980 = 860
global next_notch980 = 1090

global final_notch = 980

loc e1 = 21
loc e2 = 20.8
loc e3 = 20.5

loc i = 1
foreach notch in $notchlist {
loc j = `i'+1
global e0_notch`notch' = `e`i''
global e1_notch`notch' = `e`j''
loc i = `i'+1
}


}
****

**** 2) newregime == 0 & kei == 1
if $regime == 0 & $kei == 1 {

global notchlist "710 830 1020"
global dataset "DataStata/data_20002008_kei"
global rawdataset "DataStata/raw_data_20002008_kei"

global lst_notch710 = 560
global next_notch710 = 830

global lst_notch830 = 710
global next_notch830 = 1020

global lst_notch1020 = 830
global next_notch1020 = 1270

global final_notch = 1020

loc e1 = 21.2
loc e2 = 18.8
loc e3 = 17.9
loc e4 = 16

loc i = 1
foreach notch in $notchlist {
loc j = `i'+1
global e0_notch`notch' = `e`i''
global e1_notch`notch' = `e`j''
loc i = `i'+1
}

}
****

*** END
