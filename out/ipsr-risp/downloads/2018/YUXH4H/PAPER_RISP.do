****************************************************************************************************************************************
****Syntax to replicate analyses from "The (Party) Politics of Attention. Party Competition and Decentralist Reforms: the Italian Case.
****Datasets: DI_INDEX dataset + TERRISS_DATASET (Territorial Issues Dataset)
****Created by Linda Basile (for inquiries: basile7@unisi.it)
*****************************************************************************************************************************************

*******************************************************************
*use "/PATHNAME/DI_Index_2018.dta"
*******************************************************************

/*Fig.1 year-to-year policy change on decentralization in Italy*/

*use "/PATHNAME/DI_Index_2018.dta"

*gen DI= ST_Aut+LEG_Aut+ADM_Aut+FIN_Aut
*label var DI "Decentralization Index"

*validate DI with RAI index (region and country scores) 

pwcorr DI RAI, star (0.001)
pwcorr DI RAI_2, star (0.001)

*Increase DI by one to allow the calculation of percentage change (values cannot be divided by zero)
*gen DI_1=DI+1
*label var DI_1 "Decentralization Index (annual policy change)"

*calculate yearly percentage change
*gen per_DI_1=100*(DI_1[_n]-DI_1[_n-1])/(DI_1[_n-1])

hist per_DI_1, normal frequency width(20)
sum per_DI_1, d

*************************************************************************************************************************************

* use "/PATHNAME/TERRISS_ISPR.dta"

*************************************
/*Fig.2 Salience of decentralization in party manifestos and percentage change on decentralization*/

/* Dummy to exclude parties that are counted twice when both coalition manifestos and party manifestos have been coded
1996. TERRISS coded Ulivo and PdL manifestos, but also the documents of all the parties that composed the alliance (they are often leaflets or other non programmatic documents)
To calculate the median salience without counting twice the same parties, all the individual coalition members could be excluded.
2001. I have CDL and CCD (coalition member): CCD can be excluded*/

/*gen d_exclude=9999
replace d_exclude=1 if (manifesto_code<= 199426) | (manifesto_code>= 200109 & manifesto_code!=200113) | (manifesto_code==199621 | manifesto_code==199620 | manifesto_code==199610) 
recode d_exclude (9999=.)*/
tab d_exclude
list year partylabel d_exclude
list year partylabel if d_exclude==. 

*gen SALIENCE_wise= SALIENCE if d_exclude==1
tab SALIENCE_wise
label var SALIENCE_wise "Salience with wise-selection of cases"
sort year
list partylabel SALIENCE SALIENCE_wise

bysort year: egen w_MEDIAN_SALIENCE=median(SALIENCE_wise)
label var w_MEDIAN_SALIENCE "Median salience with wise-selection of cases"

list year w_MEDIAN_SALIENCE
*to plot median salience with percentage change (Fig. 2), copy yearly values on an Excel sheet from "TERRISS_ISPR_2018" dataset and combine them with yearly values from "DI_Index_2018" dataset.

****************************************************************************************************************************************************************************************************

/*Fig.3/4 Issue entrepreneurship on decentralization in the First Republic (1948-1992) and Second Republic (1994-2013)*/

*Calculate issue entrepreneurship
*Normalize POSITION by scaling between 0 and 1

/*foreach v of var POSITION {
      su `v', meanonly
        gen n_`v' = (`v' - r(min))/(r(max) - r(min))
}
*/

sum n_POSITION POSITION
list partylabel n_POSITION POSITION
corr n_POSITION POSITION


*calculate the average position for each year
*bysort year:egen MEAN_POSITION=mean(n_POSITION)
label var MEAN_POSITION "Average party position on decentralization for each electoral year"


*generate issue entrepreneurship as the difference between position and the average position*salience (Hobolt & De Vries 2015)
*gen ENTREP=SALIENCE*(n_POSITION- MEAN_POSITION)
label var ENTREP "Party issue entrepreneurship role"

*create Fig.3/4 (report values on Excel sheet)
bysort year: list partylabel ENTREP, clean

***********************************************************************************************************************************************

/*Fig. 5 Issue entrepreneurship on decentralization – PCI/PDS (1948-1992)*/

*Median without PCI/PD 

*bysort year: egen MED_NOPCI_DS=median(SALIENCE) if party_id!=2 & party_id!=21 & party_id!=22  & party_id!=23 & d_exclude==1
list year partyname pervote ENTREP if (party_id==2 | party_id==21 | party_id==22 | party_id==23) & d_exclude==1, clean
list year partyname MED_NOPCI_DS, clean

*to reproduce Fig.5,copy values of pervote, ENTREP (with if condition), and MED_NOPCI_DS on an Excel file, for each electoral year.

***********************************************************************************************************************************************

/*Fig. 6 Issue entrepreneurship on decentralization – PSI (1948-1992)*/

*Median without PSI

*bysort year: egen MED_NOPSI=median(SALIENCE) if party_id!=3 & party_id!=34 & party_id!=23 & d_exclude==1
list year partyname pervote ENTREP if (party_id==3 | party_id==34 | party_id==23) & d_exclude==1, clean
list year partyname MED_NOPSI, clean

*to reproduce Fig.6,copy values of pervote, ENTREP (with if condition), and MED_NOPSI on an Excel file, for each electoral year.

***********************************************************************************************************************************************

/*Fig. 7 Issue entrepreneurship on decentralization – LN (1992-2013)*/

*Median without LN

*bysort year: egen MED_NOLN=median(SALIENCE) if manifesto_code!=199210 & manifesto_code!=199410 & manifesto_code!=199610 & manifesto_code!=200124 & manifesto_code!=200810 & manifesto_code!=201310 & d_exclude==1
list year partyname pervote ENTREP if (manifesto_code==199210 | manifesto_code==199410 | manifesto_code==199610 | manifesto_code==200124 | manifesto_code==200620 |manifesto_code==200810 | manifesto_code==201310) & d_exclude==1 , clean
list year partyname MED_NOLN if year>=1992, clean

*to reproduce Fig.7,copy values of pervote, ENTREP (with if condition), and MED_NOLN on an Excel file, for each electoral year.
*NOTE: for 2006, the % votes of Lega only was 4.6% (Home Affairs official data) --> substitute with this value in pervalue when creating the figure.

***********************************************************************************************************************************************

/*Table 1. Determinants of parties’ issue entrepreneurship*/

*generate vote lagged
sort partyname2 year
*by partyname2: gen lagvote=pervote[_n-1]
tab lagvote
bysort year: list partylabel year pervote lagvote
*label var lagvote "Vote obtained at previous election"

*calculate difference from one election to another
/*gen votediff=pervote-lagvote
label var votediff "Difference between vote current and vote at previous election (negative values mean loss)"*/

*generate variable to measure how much a party was in government/opposition during a legislature (footnote 16) 
list partylabel year Government_1 Government_2 Government_3 Government_4 Government_5 Government_6 number_governments, clean
/*egen gov_index=rowtotal(Government_1 Government_2 Government_3 Government_4 Government_5 Government_6)
recode gov_index (0=.)*/
tab gov_index
sum gov_index
list partylabel gov_index, clean
/*gen ratio_gov_index= gov_index/number_governments*
label var ratio_gov_index "Role in government during legislature - ratio"*/
list partylabel gov_index ratio_gov_index

*generate government lagged
sort partyname2 year
/*by partyname2: gen laggov=ratio_gov_index[_n-1]
label var laggov "Role in government during past legislature"*/

tab laggov
bysort year: list partylabel laggov

sort year
list partylabel year ratio_gov_index laggov, clean 


*average distance fromlr
/*bysort year: egen MEAN_LR=mean(lr)
gen distance=abs(lr-MEAN_LR)*/
tab distance

sort distance
list partylabel distance, clean


*recode party family so that PCI and PDS are together
/*gen parfam2=parfam
recode parfam2 (2 4=2) (3=3) (5=4) (6=5) (7=6) (8=7)(9 10 11=8)
label val parfam2 parfam2
label define parfam2 1 "Christian Democrats" 2"Socialistsocial dem" 3"Socialists" 4"Conservatives" 5"Right wing/nationalists" 6"Autonomists" 7"Liberals" 8"Others", replace*/
tab parfam2 parfam

*Reg models

reg ENTREP votediff ib1.parfam2 republic2, robust
estimate store Model1
reg ENTREP laggov ib1.parfam2 republic2, robust
estimate store Model2
reg ENTREP distance ib1.parfam2 republic2, robust
estimate store Model3
reg ENTREP votediff laggov distance ib1.parfam2 republic2, robust
estimate store Model4

esttab Model1 Model2 Model3 Model4,se pr2 label nonumber scalars ("r2")
