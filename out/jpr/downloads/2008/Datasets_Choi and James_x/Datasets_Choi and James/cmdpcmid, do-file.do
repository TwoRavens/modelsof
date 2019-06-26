/* December 27, 2006 */

/* cmdpcmid, do-file */

set matsize 240
set memory 200m
set more off

use "E:\research, journal papers\peace\JPR\JPR data submission\cmdpcmid"

describe
summarize

duplicates drop dyadid year, force
tsset dyadid year, yearly

*Correlation

spearman smldmat amoab

*Multicollinearity

collin mixedcmr2 conscrab sdrecgdp amoab smldmat smldep smigoabi lcaprat allies noncontig logdstab nonmajpw 

/* Model 2, Table II */

btscs mzmid1 year dyadid, gen(py) nspline(2)
sort dyadid year
logit mzmid1 mixedcmr2 conscrab sdrecgdp amoab smldmat smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py _spline*, cluster (dyadid) nolog

*PRVALUES
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=1 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=0 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=0.442 amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=1 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=2.784 smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=0.006 smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=42.603 lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

/* Model 8, Table III */

logit mzmid1 mixedcmr2 conscrab sdrecgdp amoab smldmat smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py _spline* if nonmajpw==0 | noncontig==0, cluster (dyadid) nolog

*PRVALUES
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=1 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=0 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=0.280 amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=1 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=4.134 smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=0.010 smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=51.256 lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

/* Model 5, Table II */

drop py _spline*
btscs mzcowwar1 year dyadid, gen(py) nspline(3)
sort dyadid year
logit mzcowwar1 mixedcmr2 conscrab sdrecgdp /*amoab*/ smldmat smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py _spline*, cluster (dyadid) nolog

*PRVALUES
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=1 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=0 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=0.442 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=2.784 smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=0.006 smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=42.603 lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

/* Model 11, Table III */

logit mzcowwar1 mixedcmr2 conscrab sdrecgdp /*amoab*/ smldmat smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py _spline* if nonmajpw==0 | noncontig==0, cluster (dyadid) nolog

*PRVALUES
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=1 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=0 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=0.280 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=4.134 smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=0.010 smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean smldmat=mean smldep=mean smigoabi=51.256 lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif


/* separate the media openness effect from the Polity democracy effect */
/* creating Polity = f(Media) */
/* that is, residuals = smldmat - alpha - beta (amoab) */ 
regress smldmat amoab
predict usmldmat, resid
summarize

/* Model 3, Table II and Model 9, Table III */

drop py _spline*
btscs mzmid1 year dyadid, gen(py) nspline(2)
sort dyadid year
logit mzmid1 mixedcmr2 conscrab sdrecgdp amoab usmldmat smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py _spline*, cluster (dyadid) nolog
logit mzmid1 mixedcmr2 conscrab sdrecgdp amoab usmldmat smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py _spline* if nonmajpw==0 | noncontig==0, cluster (dyadid) nolog


/* without smldmat or usmldmat */

/* Model 4, Table II and Model 10, Table III */

drop py _spline*
btscs mzmid1 year dyadid, gen(py) nspline(2)
sort dyadid year
logit mzmid1 mixedcmr2 conscrab sdrecgdp amoab smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py _spline*, cluster (dyadid) nolog
logit mzmid1 mixedcmr2 conscrab sdrecgdp amoab smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py _spline* if nonmajpw==0 | noncontig==0, cluster (dyadid) nolog


/* Replication */

/* Model 1, Table II and Model 7, Table III */

drop py _spline*
btscs mzmid1 year dyadid, gen(py) nspline(2)
sort dyadid year
logit mzmid1 smldmat smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py _spline*, cluster (dyadid) nolog
logit mzmid1 smldmat smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py _spline* if nonmajpw==0 | noncontig==0, cluster (dyadid) nolog


