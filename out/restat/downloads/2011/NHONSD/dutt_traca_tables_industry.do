clear all
set memory 500m
set matsize 1000
cd "C:\Dutt-Traca\Web-Data"
use bilateral_industry.dta, clear

**********TABLE 2

***Value-Added and consumption

*Baseline (Table 2A, Column 1)
reg lflow2  tariff icrgm tariffcorr icrgx  lva lac ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1, cluster(clustervar)
outreg icrgm tariffcorr tariff icrgx lva lac ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1 using table2A, replace bdec(3) se coefastr 3aster 

*Time dummies (Table 2A, Column 2)
reg lflow2 tariff icrgm tariffcorr icrgx  lva lac ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1 T*, cluster(clustervar)
outreg tariff icrgm tariffcorr icrgx lva lac ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1 using table2A, append bdec(3) se coefastr 3aster 

*Time +country dummies (Table 2A, Column 3)
reg lflow2  tariff icrgm tariffcorr icrgx  lva lac ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1 C* T*, cluster(clustervar)
outreg tariff icrgm tariffcorr icrgx lva lac ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1 using table2A, append bdec(3) se coefastr 3aster 

*Time +country-pair dummies (Table 2A, Column 4)
areg lflow2  tariff icrgm tariffcorr icrgx  lva lac bothin onein polity2x polity2m  ltisic2 ltisic1 T*, absorb(pairid) cluster(clustervar)
outreg tariff icrgm tariffcorr icrgx lva lac bothin onein polity2x polity2m  ltisic2 ltisic1 using table2A, append bdec(3) se coefastr 3aster 

***GDP

*Baseline (Table 2B, Column 1)
reg lflow2 icrgm tariff tariffcorr icrgx lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1, cluster(clustervar)
outreg using table2B, replace bdec(3) se coefastr 3aster addstat("Joint significance test", e(F))

*Time dummies (Table 2B, Column 2)
reg lflow2  icrgm tariff tariffcorr icrgx lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1 T*, cluster(clustervar)
outreg icrgm tariff tariffcorr icrgx lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1 using table2B, append bdec(3) se coefastr 3aster addstat("Joint significance test", e(F))

*Time +country dummies (Table 2B, Column 3)
reg lflow2  icrgm tariff tariffcorr icrgx lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1 T* C*, cluster(clustervar)
outreg icrgm tariff tariffcorr icrgx lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1 using table2B, append bdec(3) se coefastr 3aster

*Time +country-pair dummies (Table 2B, Column 4)
xtreg lflow2  tariff icrgm tariffcorr icrgx lngdpx lngdpm bothin onein polity2x polity2m  ltisic2 ltisic1 T* , fe cluster(clustervar)
outreg icrgm tariff tariffcorr icrgx lngdpx lngdpm bothin onein polity2x polity2m  ltisic2 ltisic1 using table2B, append bdec(3) se coefastr 3aster addstat("Joint significance test", e(F))


**********TABLE 5
use bilateral_MAcMap.dta, clear
*McMAP data (Table 5; Column 3)
reg ltrade icrgm protectRGicrg protectRG icrgx lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry both one polity2x polity2m px pm , cluster(clustervar)
outreg icrgm protectRG protectRGicrg icrgx lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry both one polity2x polity2m px pm using table5, append bdec(3) se coefastr 3aster addstat("Joint significance test", e(F))


***TABLE 6 
use bilateral_industry.dta, clear
*OECD exporters (Table 6; Column 1)
reg lflow2 icrgm tariff tariffcorr icrgx lva lac ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1  if oecd1==1, cluster(clustervar)
outreg icrgm tariff tariffcorr icrgx using table6, replace bdec(3) se coefastr 3aster 

*non-OECD exporters (Table 6; Column 1)
reg lflow2 icrgm tariff tariffcorr icrgx lva lac  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m  ltisic2 ltisic1  if oecd1==0, cluster(clustervar)
outreg icrgm tariff tariffcorr icrgx using table6, append bdec(3) se coefastr 3aster 



