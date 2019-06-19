**********TABLE 3
clear all
set memory 500m
set matsize 1000
cd "C:\Dutt-Traca\Web-Data"
*use bilateral_aggregate.dta, clear

**********TABLE 3
*Baseline (Table 3, Column 1)

reg lnrimport icrgm tariffsfta tariffsftacorr icrgx lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm, cluster(clustervar)
outreg using table3, replace bdec(3) se coefastr 3aster 

*time dummies (Table 3, Column 2)
reg lnrimport icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm T* , cluster(clustervar)
outreg icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm using table3, append bdec(3) se coefastr 3aster 

*country dummies and time dummies (Table 3, Column 3)
reg lnrimport icrgx icrgm  tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm T* C*
outreg icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm using table3, append bdec(3) se coefastr 3aster 

*country-pair dummies and time dummies (Table 3, Column 4)
xtreg lnrimport icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  bothin onein polity2x polity2m px pm T*, fe cluster(clustervar)
outreg icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm bothin onein polity2x polity2m px pm using table3, append bdec(3) se coefastr 3aster 


**********TABLE 4
*Heckman estimates, time dummies; common religion as exclusion restriction (Table 4, Columns 1 and 2)
heckman lnrimport icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm T*, sel(importdummy= icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm commonreligion T*) cluster(clustervar)
outreg icrgm tariffsfta tariffsftacorr icrgx lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm using table4, replace bdec(3) se coefastr 3aster 

*Heckman estimates, time and country dummies; common religion as exclusion restriction (Table 4, Columns 3 and 4)
heckman lnrimport icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm T* C*, sel(importdummy= icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm commonreligion sumx T* C*)
outreg icrgm tariffsfta tariffsftacorr icrgx lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm  commonreligion using table4, append bdec(3) se coefastr 3aster

*Heckman estimates; common religion and regulation costs as exclusion restrictions (Tablle 4, Columns 5 and 6)
heckman lnrimport icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm, sel(importdummy= icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm commonreligion sumx) cluster(clustervar)
outreg icrgm tariffsfta tariffsftacorr icrgx lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm  commonreligion sumx using table4, append bdec(3) se coefastr 3aster


***TABLE 5 

*alternate measure of tariff (tariffWB); time dummies (Table 5; Column 1)
reg lnrimport icrgx icrgm tariffWB tariffWBcorr lgdpx lgdpm ldist contig comlang_off comlang_ethno colony comcol smctry  bothin onein polity2x polity2m px pm T* , cluster(clustervar)
outreg icrgm tariffWB tariffWBcorr icrgx lgdpx lgdpm ldist contig comlang_off comlang_ethno colony comcol smctry  bothin onein polity2x polity2m px pm using table5, replace bdec(3) se coefastr 3aster 

*alternate measure of tariff (tariffWB); time and country-pair dummies (Table 5; Column 2)
xtreg lnrimport icrgx icrgm tariffWB tariffWBcorr lgdpx lgdpm bothin onein polity2x polity2m px pm T*, fe cluster(clustervar)
outreg icrgx icrgm tariffWB tariffWBcorr lgdpx lgdpm bothin onein polity2x polity2m px pm using table5, append bdec(3) se coefastr 3aster 


*****TABLE 6 (Columns 3 and 4)

*OECD exporters (Table 6; Column 3)
reg lnrimport icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm if  oecd1==1, cluster(clustervar)
outreg icrgm tariffsfta tariffsftacorr icrgx using table6, append bdec(3) se coefastr 3aster 

*non-OECD exporters (Table 6; Column 4)
reg lnrimport icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm if  oecd1==0, cluster(clustervar)
outreg icrgm tariffsfta tariffsftacorr icrgx using table6, append bdec(3) se coefastr 3aster 


*****TABLE 7
use ratio_aggregate.dta, clear

*Ratios with USA as base country; Baseline (Table 7; Column 1)
reg importratio corruptratio tariffratio interactmduty gdpratio  distratio contigratio comlang_offratio comlang_ethnoratio colonyratio comcolratio smctryratio bothinratio oneinratio polity2mratio pmratio, cluster(clustervar)
outreg using table7, replace bdec(3) se coefastr 3aster 

*Ratios with USA as base country; Time dummies (Table 7; Column 2)
reg importratio corruptratio tariffratio interactmduty gdpratio  distratio contigratio comlang_offratio comlang_ethnoratio colonyratio comcolratio smctryratio bothinratio oneinratio polity2mratio pmratio  T*, cluster(clustervar)
outreg corruptratio tariffratio interactmduty gdpratio  distratio contigratio comlang_offratio comlang_ethnoratio colonyratio comcolratio smctryratio bothinratio oneinratio polity2mratio pmratio using table7, append bdec(3) se coefastr 3aster 

*Ratios with USA as base country; Time dummies and import country dummies (Table 7; Column 3)
reg importratio corruptratio tariffratio interactmduty gdpratio  distratio contigratio comlang_offratio comlang_ethnoratio colonyratio comcolratio smctryratio bothinratio oneinratio polity2mratio pmratio T* C2*, cluster(clustervar)
outreg corruptratio tariffratio interactmduty gdpratio  distratio contigratio comlang_offratio comlang_ethnoratio colonyratio comcolratio smctryratio bothinratio oneinratio polity2mratio pmratio using table7, append bdec(3) se coefastr 3aster 

*Ratios with USA as base country; Time dummies and country-pair dummies (Table 7; Column 4)
xtreg importratio corruptratio tariffratio interactmduty gdpratio  distratio contigratio comlang_offratio comlang_ethnoratio colonyratio comcolratio smctryratio bothinratio oneinratio polity2mratio pmratio  T*, fe cluster(clustervar)
outreg corruptratio tariffratio interactmduty gdpratio bothinratio oneinratio polity2mratio pmratio  using table7, append bdec(3) se coefastr 3aster 

*Ratios with USA as base country; Heckman estimates with time dummies and import-country dummies (Table 7; Column 5)
heckman importratio corruptratio tariffratio interactmduty gdpratio distratio contigratio comlang_offratio comlang_ethnoratio colonyratio comcolratio smctryratio bothinratio oneinratio polity2mratio pmratio T* C2*, select(importdummynew=corruptratio tariffratio interactmduty gdpratio  distratio contigratio comlang_offratio comlang_ethnoratio colonyratio comcolratio smctryratio bothinratio oneinratio polity2mratio pmratio religionratio T* C2*) cluster(clustervar)
outreg corruptratio tariffratio interactmduty gdpratio distratio contigratio comlang_offratio comlang_ethnoratio colonyratio comcolratio smctryratio bothinratio oneinratio polity2mratio pmratio  religionratio using table7, append bdec(3) se coefastr 3aster 


*****TABLE 8
use bilateral_aggregate.dta, clear

*Export as dependent variable; Baseline; (Table 8; Column 1)
reg exportfob icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm , cluster(clustervar)
outreg icrgm  tariffsfta tariffsftacorr icrgx lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm using table8, replace bdec(3) se coefastr 3aster 

*Export as dependent variable; Time dummies; (Table 8; Column 2)
reg exportfob icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm T*, cluster(clustervar)
outreg icrgm  tariffsfta tariffsftacorr icrgx lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm using table8, append bdec(3) se coefastr 3aster 

*Export as dependent variable; Time and Country dummies; (Table 8; Column 3)
reg exportfob icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm C* T*, cluster(clustervar)
outreg icrgm  tariffsfta tariffsftacorr icrgx lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm using table8, append bdec(3) se coefastr 3aster

*Export as dependent variable; Heckman estimates with time dummies; (Table 8; Column 4)
xtreg exportfob icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  bothin onein polity2x polity2m px pm T*, fe cluster(clustervar)
outreg icrgm  tariffsfta tariffsftacorr icrgx lngdpx lngdpm bothin onein polity2x polity2m px pm using table8, append bdec(3) se coefastr 3aster 

*Export as dependent variable; Time and Country-pair dummies; Common religion as exclusion restriction (Table 8; Column 3)
heckman exportfob icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm T* , sel(exportdummy= icrgx icrgm tariffsfta tariffsftacorr lngdpx lngdpm  ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm commonreligion T* ) cluster(clustervar)
outreg  icrgm  tariffsfta tariffsftacorr icrgx lngdpx lngdpm ldist contig comlang_off comlang_ethno colony comcol smctry bothin onein polity2x polity2m px pm commonreligion using table8, append bdec(3) se coefastr 3aster
