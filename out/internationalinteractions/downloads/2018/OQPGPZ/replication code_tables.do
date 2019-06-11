/* Ethnicity, Political Survival, and the Exchange of Nationalist Foreign Policy */
/* replication code for tables */

/* open the data file */

cd "C:\Stata"
log using "log_tables.smcl"

set more off
set scheme s1manual


/* summary statistics */
sum(civicnrt1 ethnicnrt1 smlmegip highdemoc smlmegiphighdemoc smlmegiplowdemoc lrgmegiphighdemoc lrgmegiplowdemoc unrest1 majpow1 lnCapRatio alliance highdemoc2 demodyad2 tradedep) if Contig==1 & year>=1950 & year<=2007


/* main civic-nationalist models */
probit civicnrt1 smlmegip highdemoc, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using model1-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit civicnrt1 smlmegip highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using model1-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.highdemoc+1.highdemoc2+1.highdemoc#1.highdemoc2
estimates stats

probit civicnrt1 i.smlmegip##i.highdemoc, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using model1-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats

probit civicnrt1 i.smlmegip##i.highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using model1-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
lincom 1.highdemoc+1.highdemoc2+1.highdemoc#1.highdemoc2
estimates stats


/* main ethno-nationalist models */
probit ethnicnrt1 smlmegip highdemoc, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using model2-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 smlmegip highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using model2-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.highdemoc+1.highdemoc2+1.highdemoc#1.highdemoc2
estimates stats

probit ethnicnrt1 i.smlmegip##i.highdemoc, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using model2-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats

probit ethnicnrt1 i.smlmegip##i.highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using model2-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
lincom 1.highdemoc+1.highdemoc2+1.highdemoc#1.highdemoc2
estimates stats


/* first alternative measure of small MEGIP, high democracy */
probit civicnrt1 smlmegip_rob1 highdemoc_rob1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela1-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit civicnrt1 smlmegip_rob1 highdemoc_rob1 unrest1 majpow1 lnCapRatio alliance i.highdemoc_rob1##i.highdemoc2_rob1 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela1-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit civicnrt1 i.smlmegip_rob1##i.highdemoc_rob1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela1-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip_rob1+1.highdemoc_rob1+1.smlmegip_rob1#1.highdemoc_rob1
estimates stats

probit civicnrt1 i.smlmegip_rob1##i.highdemoc_rob1 unrest1 majpow1 lnCapRatio alliance i.highdemoc_rob1##i.highdemoc2_rob1 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela1-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip_rob1+1.highdemoc_rob1+1.smlmegip_rob1#1.highdemoc_rob1
estimates stats

probit ethnicnrt1 smlmegip_rob1 highdemoc_rob1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela2-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 smlmegip_rob1 highdemoc_rob1 unrest1 majpow1 lnCapRatio alliance i.highdemoc_rob1##i.highdemoc2_rob1 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela2-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 i.smlmegip_rob1##i.highdemoc_rob1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela2-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip_rob1+1.highdemoc_rob1+1.smlmegip_rob1#1.highdemoc_rob1
estimates stats

probit ethnicnrt1 i.smlmegip_rob1##i.highdemoc_rob1 unrest1 majpow1 lnCapRatio alliance i.highdemoc_rob1##i.highdemoc2_rob1 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela2-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip_rob1+1.highdemoc_rob1+1.smlmegip_rob1#1.highdemoc_rob1
estimates stats


/* second alternative measure of small MEGIP, high democracy */
probit civicnrt1 smlmegip Democracy1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela3-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit civicnrt1 smlmegip Democracy1 unrest1 majpow1 lnCapRatio alliance i.Democracy1##i.Democracy2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela3-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit civicnrt1 i.smlmegip##i.Democracy1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela3-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.Democracy1+1.smlmegip#1.Democracy1
estimates stats

probit civicnrt1 i.smlmegip##i.Democracy1 unrest1 majpow1 lnCapRatio alliance i.Democracy1##i.Democracy2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela3-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.Democracy1+1.smlmegip#1.Democracy1
estimates stats

probit ethnicnrt1 smlmegip Democracy1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela4-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 smlmegip Democracy1 unrest1 majpow1 lnCapRatio alliance i.Democracy1##i.Democracy2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela4-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 i.smlmegip##i.Democracy1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela4-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.Democracy1+1.smlmegip#1.Democracy1
estimates stats

probit ethnicnrt1 i.smlmegip##i.Democracy1 unrest1 majpow1 lnCapRatio alliance i.Democracy1##i.Democracy2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela4-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.Democracy1+1.smlmegip#1.Democracy1
estimates stats


/* Contiguity water <= 150 miles */
probit civicnrt1 smlmegip highdemoc, cluster(dyadid), if Contig150==1 & year>=1950
outreg2 using modela5-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit civicnrt1 smlmegip highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig150==1 & year>=1950
outreg2 using modela5-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit civicnrt1 i.smlmegip##i.highdemoc, cluster(dyadid), if Contig150==1 & year>=1950
outreg2 using modela5-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats

probit civicnrt1 i.smlmegip##i.highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig150==1 & year>=1950
outreg2 using modela5-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats

probit ethnicnrt1 smlmegip highdemoc, cluster(dyadid), if Contig150==1 & tektarget_d1==1 & year>=1950
outreg2 using modela6-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 smlmegip highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig150==1 & tektarget_d1==1 & year>=1950
outreg2 using modela6-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 i.smlmegip##i.highdemoc, cluster(dyadid), if Contig150==1 & tektarget_d1==1 & year>=1950
outreg2 using modela6-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats

probit ethnicnrt1 i.smlmegip##i.highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig150==1 & tektarget_d1==1 & year>=1950
outreg2 using modela6-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats


/* ethno-nationalist models specifying the transborder ethnic members of any senior partners */
probit ethnicnrt1 smlmegip highdemoc, cluster(dyadid), if Contig==1 & tektargetallsen_d1==1 & year>=1950
outreg2 using modela7-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 smlmegip highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektargetallsen_d1==1 & year>=1950
outreg2 using modela7-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 i.smlmegip##i.highdemoc, cluster(dyadid), if Contig==1 & tektargetallsen_d1==1 & year>=1950
outreg2 using modela7-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats

probit ethnicnrt1 i.smlmegip##i.highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektargetallsen_d1==1 & year>=1950
outreg2 using modela7-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats


/* major power targets included */
probit civicnrt1 smlmegip highdemoc unrest1 majpow1 majpow2 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela8-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit civicnrt1 i.smlmegip##i.highdemoc unrest1 majpow1 majpow2 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela8-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats

probit ethnicnrt1 smlmegip highdemoc unrest1 majpow1 majpow2 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela8-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 i.smlmegip##i.highdemoc unrest1 majpow1 majpow2 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela8-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats



/* additive interaction models */
set more off
probit civicnrt1 smlmegiplowdemoc lrgmegiphighdemoc lrgmegiplowdemoc, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela9-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit civicnrt1 smlmegiplowdemoc lrgmegiphighdemoc lrgmegiplowdemoc unrest1 majpow1 lnCapRatio alliance highdemoc2 demodyad2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela9-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 smlmegiplowdemoc lrgmegiphighdemoc lrgmegiplowdemoc, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela9-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit ethnicnrt1 smlmegiplowdemoc lrgmegiphighdemoc lrgmegiplowdemoc unrest1 majpow1 lnCapRatio alliance highdemoc2 demodyad2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela9-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats


/* rare event logit */
/* AIC cannot be calculated for rare event logit */
relogit civicnrt1 smlmegip highdemoc, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela10-x.doc, alpha(0.01,0.05,0.1) dec(2)

relogit civicnrt1 smlmegip highdemoc unrest1 majpow1 lnCapRatio alliance highdemoc2 demodyad2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela10-x.doc, alpha(0.01,0.05,0.1) dec(2)

relogit civicnrt1 smlmegip highdemoc smlmegiphighdemoc, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela10-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom smlmegip+highdemoc+smlmegiphighdemoc

relogit civicnrt1 smlmegip highdemoc smlmegiphighdemoc unrest1 majpow1 lnCapRatio alliance highdemoc2 demodyad2 tradedep NonCNRyrst1 NonCNRyrs2t1 NonCNRyrs3t1 CNRyrst1 CNRyrs2t1 CNRyrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela10-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom smlmegip+highdemoc+smlmegiphighdemoc

relogit ethnicnrt1 smlmegip highdemoc, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela11-x.doc, alpha(0.01,0.05,0.1) dec(2)

relogit ethnicnrt1 smlmegip highdemoc unrest1 majpow1 lnCapRatio alliance highdemoc2 demodyad2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela11-x.doc, alpha(0.01,0.05,0.1) dec(2)

relogit ethnicnrt1 smlmegip highdemoc smlmegiphighdemoc, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela11-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom smlmegip+highdemoc+smlmegiphighdemoc

relogit ethnicnrt1 smlmegip highdemoc smlmegiphighdemoc unrest1 majpow1 lnCapRatio alliance highdemoc2 demodyad2 tradedep NonENRyrst1 NonENRyrs2t1 NonENRyrs3t1 ENRyrst1 ENRyrs2t1 ENRyrs3t1, cluster(dyadid), if Contig==1 & tektarget_d1==1 & year>=1950
outreg2 using modela11-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom smlmegip+highdemoc+smlmegiphighdemoc


/* Indonesia coded as a civic-nationalist in the Dutch-Indonesian rivalry */
probit civicnr2t1 smlmegip highdemoc, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela12-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit civicnr2t1 smlmegip highdemoc unrest1 majpow1 lnCapRatio alliance i.highdemoc##i.highdemoc2 tradedep NonCNR2yrst1 NonCNR2yrs2t1 NonCNR2yrs3t1 CNR2yrst1 CNR2yrs2t1 CNR2yrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela12-x.doc, alpha(0.01,0.05,0.1) dec(2)
estimates stats

probit civicnr2t1 i.smlmegip##i.highdemoc, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela12-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats

probit civicnr2t1 i.smlmegip##i.highdemoc unrest1 majpow1 lnCapRatio i.highdemoc##i.highdemoc2 alliance tradedep NonCNR2yrst1 NonCNR2yrs2t1 NonCNR2yrs3t1 CNR2yrst1 CNR2yrs2t1 CNR2yrs3t1, cluster(dyadid), if Contig==1 & year>=1950
outreg2 using modela12-x.doc, alpha(0.01,0.05,0.1) dec(2)
lincom 1.smlmegip+1.highdemoc+1.smlmegip#1.highdemoc
estimates stats

log close
