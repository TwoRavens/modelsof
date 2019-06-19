

set logtype text
log using c:\branko\interyd\where\sent_to_Restat\for_release\Restat_results.txt, replace

/* Table 1: key results */
/* use final08.dta */

sort contcod group
tab  contcod, gen(Dcont)

regress lninc lngdpppp gini if  maxgroup==100
regress lninc ayos gini if  maxgroup==100
regress	lninc Dcont1-Dcont117 gini if maxgroup==100


regress lninc lngdpppp gini if  maxgroup==100 [w=pop]
regress	lninc Dcont1-Dcont117 gini if maxgroup==100 [w=pop]
regress	lninc Dcont1-Dcont117 gini if maxgroup==100 [w=pop]


/* Table 4 and Annex Table 1: trade-off between income level and inequality, at different points of income distribution */

/* creation of ventiles out of percentiles and running of regressions for "where are you?" */
/* use final08.dta */


sort contcod group

gen ventile=.
replace ventile=1 if group<6
replace ventile=2 if group>5 & group<11
replace ventile=3 if group>10 & group<16
replace ventile=4 if group>15 & group<21
replace ventile=5 if group>20 & group<26
replace ventile=6 if group>25 & group<31
replace ventile=7 if group>30 & group<36
replace ventile=8 if group>35 & group<41
replace ventile=9 if group>40 & group<46
replace ventile=10 if group>45 & group<51
replace ventile=11 if group>50 & group<56
replace ventile=12 if group>55 & group<61
replace ventile=13 if group>60 & group<66
replace ventile=14 if group>65 & group<71
replace ventile=15 if group>70 & group<76
replace ventile=16 if group>75 & group<81
replace ventile=17 if group>80 & group<86
replace ventile=18 if group>85 & group<91
replace ventile=19 if group>90 & group<95
replace ventile=20 if group>95 

replace ventile=. if maxgroup~=100


by contcod: egen bb1=sum(inc) if ventile==1
by contcod: egen bb2=sum(inc) if ventile==2
by contcod: egen bb3=sum(inc) if ventile==3
by contcod: egen bb4=sum(inc) if ventile==4
by contcod: egen bb5=sum(inc) if ventile==5
by contcod: egen bb6=sum(inc) if ventile==6
by contcod: egen bb7=sum(inc) if ventile==7
by contcod: egen bb8=sum(inc) if ventile==8
by contcod: egen bb9=sum(inc) if ventile==9
by contcod: egen bb10=sum(inc) if ventile==10
by contcod: egen bb11=sum(inc) if ventile==11
by contcod: egen bb12=sum(inc) if ventile==12
by contcod: egen bb13=sum(inc) if ventile==13
by contcod: egen bb14=sum(inc) if ventile==14
by contcod: egen bb15=sum(inc) if ventile==15
by contcod: egen bb16=sum(inc) if ventile==16
by contcod: egen bb17=sum(inc) if ventile==17
by contcod: egen bb18=sum(inc) if ventile==18
by contcod: egen bb19=sum(inc) if ventile==19
by contcod: egen bb20=sum(inc) if ventile==20



for num 1/20: replace bbX=bbX/5

for num 1/20: gen lnbbX=ln(bbX)
gen gini2=gini*100

regress lnbb1 lngdpppp gini2 if group==1 & maxgroup==100, cluster(contcod)
regress lnbb2 lngdpppp gini2 if group==6 & maxgroup==100, cluster(contcod)
regress lnbb3 lngdpppp gini2 if group==11 & maxgroup==100, cluster(contcod)
regress lnbb4 lngdpppp gini2 if group==16 & maxgroup==100, cluster(contcod)
regress lnbb5 lngdpppp gini2 if group==21 & maxgroup==100, cluster(contcod)
regress lnbb6 lngdpppp gini2 if group==26 & maxgroup==100, cluster(contcod)
regress lnbb7 lngdpppp gini2 if group==31 & maxgroup==100, cluster(contcod)
regress lnbb8 lngdpppp gini2 if group==36 & maxgroup==100, cluster(contcod)
regress lnbb9 lngdpppp gini2 if group==41 & maxgroup==100, cluster(contcod)
regress lnbb10 lngdpppp gini2 if group==46 & maxgroup==100, cluster(contcod)
regress lnbb11 lngdpppp gini2 if group==51 & maxgroup==100, cluster(contcod)
regress lnbb12 lngdpppp gini2 if group==56 & maxgroup==100, cluster(contcod)
regress lnbb13 lngdpppp gini2 if group==61 & maxgroup==100, cluster(contcod)
regress lnbb14 lngdpppp gini2 if group==66 & maxgroup==100, cluster(contcod)
regress lnbb15 lngdpppp gini2 if group==71 & maxgroup==100, cluster(contcod)
regress lnbb16 lngdpppp gini2 if group==76 & maxgroup==100, cluster(contcod)
regress lnbb17 lngdpppp gini2 if group==81 & maxgroup==100, cluster(contcod)
regress lnbb18 lngdpppp gini2 if group==86 & maxgroup==100, cluster(contcod)
regress lnbb19 lngdpppp gini2 if group==91 & maxgroup==100, cluster(contcod)
regress lnbb20 lngdpppp gini2 if group==96 & maxgroup==100, cluster(contcod)


regress lnbb1 lngdpppp gini2 if group==1 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb2 lngdpppp gini2 if group==6 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb3 lngdpppp gini2 if group==11 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb4 lngdpppp gini2 if group==16 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb5 lngdpppp gini2 if group==21 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb6 lngdpppp gini2 if group==26 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb7 lngdpppp gini2 if group==31 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb8 lngdpppp gini2 if group==36 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb9 lngdpppp gini2 if group==41 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb10 lngdpppp gini2 if group==46 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb11 lngdpppp gini2 if group==51 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb12 lngdpppp gini2 if group==56 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb13 lngdpppp gini2 if group==61 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb14 lngdpppp gini2 if group==66 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb15 lngdpppp gini2 if group==71 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb16 lngdpppp gini2 if group==76 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb17 lngdpppp gini2 if group==81 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb18 lngdpppp gini2 if group==86 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb19 lngdpppp gini2 if group==91 & maxgroup==100 [w=pop], cluster(contcod)
regress lnbb20 lngdpppp gini2 if group==96 & maxgroup==100 [w=pop], cluster(contcod)



log close



