/* December 27, 2006 */

/* cmdpcicb, do-file */

set matsize 240
set memory 200m
set more off

use "E:\research, journal papers\peace\JPR\JPR data submission\cmdpcicb"

describe
summarize

/* Model 6, Table II */

btscs icbonset1 year dyadid, gen(py) nspline(0)
sort dyadid year
logit icbonset1 mixedcmr2 conscrab sdrecgdp amoab smldmat smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py /*_spline**/, cluster (dyadid) nolog

*PRVALUES
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=1 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=0 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=0.447 amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=1 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=2.810 smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=0.006 smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=43.083 lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

/* Model 12, Table III */

logit icbonset1 mixedcmr2 conscrab sdrecgdp amoab smldmat smldep smigoabi lcaprat allies noncontig logdstab nonmajpw py /*_spline**/ if nonmajpw==0 | noncontig==0, cluster (dyadid) nolog

*PRVALUES
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=1 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=0 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=0.283 amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=1 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=4.168 smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=0.010 smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=mean lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)save
prvalue, x(mixedcmr2=0 conscrab=1 sdrecgdp=mean amoab=0 smldmat=mean smldep=mean smigoabi=51.860 lcaprat=mean allies=0 noncontig=0 logdstab=mean nonmajpw=1)dif

