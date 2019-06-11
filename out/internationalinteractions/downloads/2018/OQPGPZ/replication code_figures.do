/* Ethnicity, Political Survival, and the Exchange of Nationalist Foreign Policy */
/* replication code for figures */


/* Figure 1 */
/* open the data file */

cd "C:\Stata"
log using "log_figure1.smcl"

set more off
set scheme s1manual

probit civicnrt1 i.smlmegip##i.highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1

replace smlmegip=1
replace highdemoc=1
replace unrest1=1
replace majpow1=0
replace lnCapRatio=-1.936979
replace alliance=0
replace highdemoc2=0
replace tradedep=.2491212
replace NonCNRyrst1=0
replace NonCNRyrs2t1=0
replace NonCNRyrs3t1=0
replace CNRyrst1=0
replace CNRyrs2t1=0
replace CNRyrs3t1=0
predict p1
predict ihat, xb
predict error, stdp
generate lb = ihat - invnormal(0.975)*error
generate ub = ihat + invnormal(0.975)*error
generate plb1 = normal(lb)
generate pub1 = normal(ub)
drop ihat error lb ub

replace smlmegip=1
replace highdemoc=0
predict p2
predict ihat, xb
predict error, stdp
generate lb = ihat - invnormal(0.975)*error
generate ub = ihat + invnormal(0.975)*error
generate plb2 = normal(lb)
generate pub2 = normal(ub)
drop ihat error lb ub

replace smlmegip=0
replace highdemoc=1
predict p3
predict ihat, xb
predict error, stdp
generate lb = ihat - invnormal(0.975)*error
generate ub = ihat + invnormal(0.975)*error
generate plb3 = normal(lb)
generate pub3 = normal(ub)
drop ihat error lb ub

replace smlmegip=0
replace highdemoc=0
predict p4
predict ihat, xb
predict error, stdp
generate lb = ihat - invnormal(0.975)*error
generate ub = ihat + invnormal(0.975)*error
generate plb4 = normal(lb)
generate pub4 = normal(ub)
drop ihat error lb ub

duplicates drop p1 plb1 pub1 p2 plb2 pub2 p3 plb3 pub3 p4 plb4 pub4, force
keep p1 plb1 pub1 p2 plb2 pub2 p3 plb3 pub3 p4 plb4 pub4
stack p1 plb1 pub1 p2 plb2 pub2 p3 plb3 pub3 p4 plb4 pub4 , group(4) clear
rename _stack type
label define type 1 "S Size, High Democ" 2 "S Size, Low Democ" 3 "L Size, High Democ" 4 "L Size, Low Democ"
label values type type
eclplot p1 plb1 pub1 type, scale(1.25) aspectratio(.65) ytitle("") xtitle("") xsize(4) xlabel(1 2 3 4)
graph save Graph figure1.gph, replace

clear
log close


/* Figure 2 */
/* open the data file */

cd "C:\Stata"
log using "log_figure2.smcl"

set more off
set scheme s1manual

probit ethnicnrt1 i.smlmegip##i.highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1

replace smlmegip=1
replace highdemoc=1
replace unrest1=1
replace majpow1=0
replace lnCapRatio=-1.936979
replace alliance=0
replace highdemoc2=0
replace tradedep=.2491212
replace NonENRyrst1=0
replace NonENRyrs2t1=0
replace NonENRyrs3t1=0
replace ENRyrst1=0
replace ENRyrs2t1=0
replace ENRyrs3t1=0
predict p1
predict ihat, xb
predict error, stdp
generate lb = ihat - invnormal(0.975)*error
generate ub = ihat + invnormal(0.975)*error
generate plb1 = normal(lb)
generate pub1 = normal(ub)
drop ihat error lb ub

replace smlmegip=1
replace highdemoc=0
predict p2
predict ihat, xb
predict error, stdp
generate lb = ihat - invnormal(0.975)*error
generate ub = ihat + invnormal(0.975)*error
generate plb2 = normal(lb)
generate pub2 = normal(ub)
drop ihat error lb ub

replace smlmegip=0
replace highdemoc=1
predict p3
predict ihat, xb
predict error, stdp
generate lb = ihat - invnormal(0.975)*error
generate ub = ihat + invnormal(0.975)*error
generate plb3 = normal(lb)
generate pub3 = normal(ub)
drop ihat error lb ub

replace smlmegip=0
replace highdemoc=0
predict p4
predict ihat, xb
predict error, stdp
generate lb = ihat - invnormal(0.975)*error
generate ub = ihat + invnormal(0.975)*error
generate plb4 = normal(lb)
generate pub4 = normal(ub)
drop ihat error lb ub

duplicates drop p1 plb1 pub1 p2 plb2 pub2 p3 plb3 pub3 p4 plb4 pub4, force
keep p1 plb1 pub1 p2 plb2 pub2 p3 plb3 pub3 p4 plb4 pub4
stack p1 plb1 pub1 p2 plb2 pub2 p3 plb3 pub3 p4 plb4 pub4 , group(4) clear
rename _stack type
label define type 1 "S Size, High Democ" 2 "S Size, Low Democ" 3 "L Size, High Democ" 4 "L Size, Low Democ"
label values type type
eclplot p1 plb1 pub1 type, scale(1.25) aspectratio(.65) ytitle("") xtitle("") xsize(4) xlabel(1 2 3 4)
graph save Graph figure2.gph, replace

clear
log close
