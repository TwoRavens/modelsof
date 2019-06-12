*******************************
* Elimination of observations *
*******************************

* use data

use "Extended data"

* drop observations of individuals who do not understand the instructions (derived from the post-experimental questionnaires)

drop if unstandfirst == 0 
drop if unstandsec == 0

* save data

save "Prepared data"

* clear data

clear
