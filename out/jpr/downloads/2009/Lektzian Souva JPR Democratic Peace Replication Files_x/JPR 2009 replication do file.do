* Replication do file for Lektzian and Souva "A comparative theory test of democratic peace arguments, 1946-2000" Journal of Peace Research

set mem 375m
set more off
 
* Table 2 (cross-tabs): Regime type and MIDs 
use "JPR replication file 1--no joiners mids" 

tab jointd6 midjt1, exp chi
tab socialist midjt1, exp chi
tab monarchy midjt1, exp chi
tab military midjt1, exp chi
tab personal midjt1, exp chi

* Table 3

* Model 3A: Reciprocation, no joiners
use "JPR replication file 1--no joiners mids" 
heckprob recipt1 monarchy personal socialist military jointd6 powerratio lndist majdyad allies tradeweak devweak, select (midjt1 = monarchy personal socialist military jointd6 powerratio majdyad tradeweak devweak lndist allies midjpyr midspline1 midspline2 midspline3) cluster(dyadid) nolog 

* Model 3B: Escalation to Fatal Dispute, no joiners
use "JPR replication file 1--no joiners mids" 
heckprob fatalt1 monarchy personal socialist military jointd6 powerratio lndist majdyad allies tradeweak devweak, select (midjt1 = monarchy personal socialist military jointd6 powerratio majdyad tradeweak devweak lndist allies midjpyr midspline1 midspline2 midspline3) cluster(dyadid) nolog 

* Model 3C: Reciprocation, joiners
use "JPR replication file 2--joiners mids"
heckprob recipt1 monarchy personal socialist military jointd6 powerratio lndist majdyad allies tradeweak devweak, select (midjt1 = monarchy personal socialist military jointd6 powerratio majdyad tradeweak devweak lndist allies midjpyr midspline1 midspline2 midspline3) cluster(dyadid) nolog 

* Model 3D: Escalation to Fatal Dispute, joiners
use "JPR replication file 2--joiners mids"
heckprob fatalt1 monarchy personal socialist military jointd6 powerratio lndist majdyad allies tradeweak devweak, select (midjt1 = monarchy personal socialist military jointd6 powerratio majdyad tradeweak devweak lndist allies midjpyr midspline1 midspline2 midspline3) cluster(dyadid) nolog 


* Table 2 (cross-tabs): Regime type and ICB crises 
use "JPR replication file 3--no joiners icb"

tab jointd6 crisist1, exp chi
tab socialist crisist1, exp chi
tab monarchy crisist1, exp chi
tab military crisist1, exp chi
tab personal crisist1, exp chi

* Table 4

* Model 4A: ICB crises, no joiners
use "JPR replication file 3--no joiners icb"

heckprob twosidext1 monarchy personal socialist jointd6 powerratio lndist majdyad allies tradeweak devweak, select (crisist1 = monarchy personal socialist jointd6 powerratio lndist majdyad tradeweak devweak allies icbyrs _spline1 _spline2 _spline3) cluster(dyadid) nolog 

* Model 4B: ICB data, joiners
use "JPR replication file 4--joiners icb" 

heckprob twosidext1 monarchy personal socialist jointd6 powerratio lndist majdyad allies tradeweak devweak, select (crisist1 = monarchy personal socialist jointd6 powerratio lndist majdyad tradeweak devweak allies icbyrs _spline1 _spline2 _spline3) cluster(dyadid) nolog 

* Table 5
* Models with Cheibub and Gandhi democracy measure

* Model 5A: Reciprocation, no joiners
use "JPR replication file 1--no joiners mids"

heckprob recipt1 monarchycg personalcg socialistcg militarycg jointdemcg powerratio lndist majdyad allies tradeweak devweak, select (midjt1 = monarchycg personalcg socialistcg militarycg jointdemcg powerratio majdyad tradeweak devweak lndist allies midjpyr midspline1 midspline2 midspline3) cluster(dyadid) nolog 

* Model 5B:  Escalation to Fatal MID, no joiners
use "JPR replication file 1--no joiners mids"

heckprob fatalt1 monarchycg personalcg socialistcg militarycg jointdemcg powerratio lndist majdyad allies tradeweak devweak, select (midjt1 = monarchycg personalcg socialistcg militarycg jointdemcg powerratio majdyad tradeweak devweak lndist allies midjpyr midspline1 midspline2 midspline3) cluster(dyadid) nolog 

* Model 5C: ICB, no joiners 
use "JPR replication file 3--no joiners icb"

heckprob twosidext1 monarchycg personalcg socialistcg jointdemcg powerratio lndist majdyad allies tradeweak devweak, select (crisist1 = monarchycg personalcg socialistcg jointdemcg powerratio lndist majdyad tradeweak devweak allies icbyrs _spline1 _spline2 _spline3) cluster(dyadid) nolog 

