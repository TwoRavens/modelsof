***********
* Table 1 *
***********

* use data

use "Extended data"

* inspect StackRand

inspect session if treatment == 4
inspect idfirst if treatment == 4 & session == 5
inspect idfirst if treatment == 4 & session == 6
inspect idsec if treatment == 4 & session == 5
inspect idsec if treatment == 4 & session == 6

* inspect LOADED

inspect session if treatment == 2
inspect idfirst if treatment == 2 & session == 3
inspect idsec if treatment == 2 & session == 3

* inspect NEUTRAL

inspect session if treatment == 1
inspect idfirst if treatment == 1 & session == 1
inspect idfirst if treatment == 1 & session == 2
inspect idsec if treatment == 1 & session == 1
inspect idsec if treatment == 1 & session == 2

* inspect TEAM

inspect session if treatment == 3
inspect idfirst if treatment == 3 & session == 4
inspect idsec if treatment == 3 & session == 4

* clear data

clear
