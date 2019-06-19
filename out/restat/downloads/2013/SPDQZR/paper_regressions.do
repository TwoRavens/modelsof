clear
clear matrix
set mem 500m



/* NOTE: xtpqml from http://people.bu.edu/tsimcoe/code/xtpqml.txt should be installed in the ado files */

use ready, clear

/**********Generate numbers reported in table 1 - descriptive statistics on scientific output ***********/

foreach x in  pub_first w_pub_first cites_first pub w_pub cites  {
display "Chinese student"
sum `x' if chineseboth==1
display "NSF fellow"
sum `x' if nsffellow==1
display "Other student"
sum `x' if chineseboth==0 & nsffellow==0
}


/**********Generate numbers reported in table 2 - panel A *************/

foreach x in pub pub_first w_pub w_pub_first cites cites_first {
xi: poisson  `x' chineseboth nsffellow i.year i.subject, robust
}

/**********Generate numbers reported in table 2 - panel B *************/

/******** Following line is to make sure xtpqml will take code as group identifier*******/
xi: xtreg  w_pub_first chineseboth i.year i.subject, fe i(code) cluster(code)

foreach x in pub pub_first w_pub w_pub_first cites cites_first {
xi: xtpqml  `x' chineseboth nsffellow i.year i.subject
}

/**********Generate numbers reported in table 2 - panel C *************/

/******** Following line is to make sure xtpqml will take profid as group identifier*******/
xi: xtreg  w_pub_first chineseboth i.year i.subject, fe i(profid) cluster(profid)

foreach x in pub pub_first w_pub w_pub_first cites cites_first{
xi: xtpqml  `x' chineseboth nsffellow i.year i.subject
}







