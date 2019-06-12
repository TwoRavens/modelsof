***************
** Table C-1 **
***************

** Descriptive statistics for entries in the three right columns can be obtained with the following:
use "FP voting records.dta", clear
by cong,sort: sum foreign_policy
by cong,sort: sum foreign_policy if party==200
by cong,sort: sum foreign_policy  if party==100

***************
** Table C-2 **
***************

use "FP voting records.dta", clear

reg foreign_policy preclearance  i.st_id i.cong ,cl(member)
reg foreign_policy preclearance  competitive dempres rep ind  i.st_id i.cong,cl(member)
reg foreign_policy preclearance  competitive dempres rep ind  percentblack black_l i.st_id i.cong,cl(member)


***************
** Table C-3 **
***************

use "coverage level.dta",clear

** Partially covered districts (columns 1-3)
reg civil_rights preclearance  i.st_id i.cong if substantial==0,cl(member)
reg civil_rights preclearance dempres rep ind  i.st_id i.cong if substantial==0,cl(member)
reg civil_rights preclearance c.competitive dempres rep ind percentblack black_l i.st_id i.cong if substantial==0,cl(member)
** Substantially covered districts (columns 4-6)
reg civil_rights preclearance  i.st_id i.cong if  partly==0,cl(member)
reg civil_rights preclearance dempres rep ind  i.st_id i.cong if partly==0,cl(member)
reg civil_rights preclearance c.competitive dempres rep ind percentblack black_l i.st_id i.cong if partly==0,cl(member)


***************
** Table C-4 **
***************

use "electoral competitiveness.dta",clear

reg uncontested preclearance competitive dempres rep ind black_legis percentblack i.st_id i.cong,cl(member)
reg margin10 preclearance competitive dempres rep ind percentblack black_legis i.st_id i.cong,cl(member)
