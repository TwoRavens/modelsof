use "KSAJPSgallup.dta", clear

* Table 5 *
probit iraqamistake totantiwarthroughjune16   gop3 dem3 age education4 male white, robust
oprobit staythecourseindex totantiwarthroughjune16  gop3 dem3 age education4 male white, robust
probit iraqamistake totantiwarthroughjune16 totantiwarxknowparty   gop3 dem3 age education4 male white knowparty, robust
oprobit staythecourseindex totantiwarthroughjune16 totantiwarxknowparty   gop3 dem3 age education4 male white knowparty, robust

* Table 6 *
ivprobit iraqamistake gop3 dem3 white male age education4  (totantiwarthroughjune16 =seniorityinchamber), first
rivtest
ivprobit staybin gop3 dem3 white male age education4  (totantiwarthroughjune16 =seniorityinchamber), first
rivtest
