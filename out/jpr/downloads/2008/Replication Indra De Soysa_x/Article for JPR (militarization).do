/*Testing the effects of ethnicity on state militarization militarization */
clear
set mem 100m
use ethmil, clear
sort cow year
tsset cow year 

* Table 1
corr iethfrac irelfrac cultf ethf relf linf roederelf ETHFRAG RELFRAG ETHPOL RELPOL

* Table 2
quietly regress milexpgdp  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, r cluster(cow)
su milexpgdp iethfrac irelfrac cultf ethf relf linf roederelf ETHFRAG RELFRAG ETHPOL RELPOL nstar lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar if e(sample)
quietly regress milperlf  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, r cluster(cow)
su milperlf contigmilperlf if e(sample)
quietly regress armsimptototimp  lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, r cluster(cow)
su armsimptototimp contigarmsimptototimp if e(sample)

* Table 3
xtreg milexpgdp  iethfrac irelfrac lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table3, bdec(3) coefastr  3aster onecol nolabel replace
xtgee milexpgdp  iethfrac irelfrac lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table3, bdec(3) coefastr  3aster onecol nolabel append
xtreg milperlf   iethfrac irelfrac lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table3, bdec(3) coefastr   3aster onecol nolabel append
xtgee milperlf  iethfrac irelfrac lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*,  robust corr(exchangeable)
outreg using table3, bdec(3) coefastr   3aster onecol nolabel append
 
outreg using table3, bdec(3) coefastr   3aster onecol nolabel append
xtgee armsimptototimp  iethfrac irelfrac lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*,  robust corr(exchangeable)
outreg using table3, bdec(3) coefastr   3aster onecol nolabel append

* Table 4
xtreg milexpgdp  ETHFRAG RELFRAG  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table4, bdec(3) coefastr  3aster onecol nolabel replace
xtgee milexpgdp  ETHFRAG RELFRAG  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table4, bdec(3) coefastr   3aster onecol nolabel append
xtreg milperlf  ETHFRAG RELFRAG  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table4, bdec(3) coefastr   3aster onecol nolabel append
xtgee milperlf  ETHFRAG RELFRAG  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table4, bdec(3) coefastr   3aster onecol nolabel append
xtreg armsimptototimp  ETHFRAG RELFRAG  lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table4, bdec(3) coefastr   3aster onecol nolabel append
xtgee armsimptototimp  ETHFRAG RELFRAG  lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table4, bdec(3) coefastr   3aster onecol nolabel append

* Table 5
xtreg milexpgdp  roederelf  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table5, bdec(3) coefastr  3aster onecol nolabel replace
xtgee milexpgdp  roederelf  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table5, bdec(3) coefastr   3aster onecol nolabel append
xtreg milperlf  roederelf  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table5, bdec(3) coefastr   3aster onecol nolabel append
xtgee milperlf  roederelf  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table5, bdec(3) coefastr   3aster onecol nolabel append
xtreg armsimptototimp  roederelf  lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table5, bdec(3) coefastr   3aster onecol nolabel append
xtgee armsimptototimp  roederelf  lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table5, bdec(3) coefastr   3aster onecol nolabel append

* Table 6
xtreg milexpgdp  ethf relf linf  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table6, bdec(3) coefastr  3aster onecol nolabel replace
xtgee milexpgdp  ethf relf linf  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table6, bdec(3) coefastr   3aster onecol nolabel append
xtreg milperlf  ethf relf linf  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table6, bdec(3) coefastr   3aster onecol nolabel append
xtgee milperlf  ethf relf linf  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table6, bdec(3) coefastr   3aster onecol nolabel append
xtreg armsimptototimp  ethf relf linf  lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table6, bdec(3) coefastr   3aster onecol nolabel append
xtgee armsimptototimp  ethf relf linf  lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table6, bdec(3) coefastr   3aster onecol nolabel append

* Table 7
xtreg milexpgdp  cultf irelfrac  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table7, bdec(3) coefastr  3aster onecol nolabel replace
xtgee milexpgdp  cultf irelfrac  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table7, bdec(3) coefastr   3aster onecol nolabel append
xtreg milperlf  cultf irelfrac  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table7, bdec(3) coefastr   3aster onecol nolabel append
xtgee milperlf  cultf irelfrac  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table7, bdec(3) coefastr   3aster onecol nolabel append
xtreg armsimptototimp  cultf irelfrac  lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table7, bdec(3) coefastr   3aster onecol nolabel append
xtgee armsimptototimp  cultf irelfrac  lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table7, bdec(3) coefastr   3aster onecol nolabel append


* Table 8
xtreg milexpgdp  ETHPOL RELPOL  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table8, bdec(3) coefastr  3aster onecol nolabel replace
xtgee milexpgdp  ETHPOL RELPOL  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table8, bdec(3) coefastr   3aster onecol nolabel append
xtreg milperlf  ETHPOL RELPOL  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table8, bdec(3) coefastr   3aster onecol nolabel append
xtgee milperlf  ETHPOL RELPOL  lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table8, bdec(3) coefastr   3aster onecol nolabel append
xtreg armsimptototimp  ETHPOL RELPOL  lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table8, bdec(3) coefastr   3aster onecol nolabel append
xtgee armsimptototimp  ETHPOL RELPOL  lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table8, bdec(3) coefastr   3aster onecol nolabel append

* Table 9 
xtreg milexpgdp  nstar lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table9, bdec(3) coefastr  3aster onecol nolabel replace
xtgee milexpgdp  nstar lngnipc gnipcgrowth  polity2 govt lnpop   contigmilexpgdp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, robust corr(exchangeable)
outreg using table9, bdec(3) coefastr  3aster onecol nolabel append
xtreg milperlf   nstar lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table9, bdec(3) coefastr   3aster onecol nolabel append
xtgee milperlf  nstar lngnipc gnipcgrowth  polity2 govt lnpop   contigmilperlf UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*,  robust corr(exchangeable)
outreg using table9, bdec(3) coefastr   3aster onecol nolabel append
xtreg armsimptototimp   nstar lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*, re robust cluster(cow)
outreg using table9, bdec(3) coefastr   3aster onecol nolabel append
xtgee armsimptototimp  nstar lngnipc gnipcgrowth  polity2 govt lnpop   contigarmsimptototimp UPpeaceyrs intwarpeaceyears  civwar major_intwar  year19*,  robust corr(exchangeable)
outreg using table9, bdec(3) coefastr   3aster onecol nolabel append

