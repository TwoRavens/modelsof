*----------------------------
* names pre-war (Cols. 1-2)
*----------------------------
 
use FNIdataset if german==1, clear

collapse (count) totalno=pernum (mean) FNI if birthyear<1917, by(firstname)
sort FNI

* list all names appearing over 1000 times sorted by FNI value
list firstname FNI if FNI!=.&totalno>1000

*----------------------------
* names post-war (Cols. 3-4)
*----------------------------

use FNIdataset if german==1, clear

collapse (count) totalno=pernum (mean) FNI if birthyear>=1917, by(firstname)
sort FNI

* list all names appearing over 1000 times sorted by FNI value
list firstname FNI if FNI!=.&totalno>1000
