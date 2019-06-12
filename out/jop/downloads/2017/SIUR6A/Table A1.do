*TOP PORTION OF TABLE A1
local demog female c.age c.age2 i.educat i.inc4 hisp c.perc_hispanic c.perc_hispanic2

local econ i.econ_country i.econ_house

local feeling c.ft_hisp c.ft_as

local pol i.pid3 i.ideo3

local X reform_support5 w2 w3

local X1 immvote w2 w3

local inter whiteevan w2_whiteevan w3_whiteevan

foreach j of numlist 1 2 3{
eststo clear
qui reg `X' whiteevan if w`j'==1 [aw=finalweight1], r
est store a1
qui reg `X' whiteevan `demog'  if w`j'==1 [aw=finalweight1], r
est store a2
qui reg `X' whiteevan `demog' `econ'  if w`j'==1 [aw=finalweight1], r
est store a3
qui reg `X' whiteevan `demog' `econ' `feeling'  if w`j'==1 [aw=finalweight1], r
est store a4
qui reg `X' whiteevan `demog' `econ' `feeling' `pol'  if w`j'==1 [aw=finalweight1], r
est store a5

esttab a1 a2 a3 a4 a5, keep(whiteevan) sfmt(4) se(2) b(2) star(* .10 ** 0.05)
}




*BOTTOM PORTION OF TABLE A1
local demog female c.age c.age2 i.educat i.inc4 hisp c.perc_hispanic c.perc_hispanic2

local econ i.econ_country i.econ_house

local feeling c.ft_hisp c.ft_as

local pol i.pid3 i.ideo3

local X reform_support5 w2 w3

local X1 immvote w2 w3

local inter whiteevan w2_whiteevan w3_whiteevan

eststo clear
qui reg `X'  `inter' [aw=finalweight1], cluster(wustlid)
est store a2
qui reg `X'  `inter'  `demog' w2#(`demog') w3#(`demog') [aw=finalweight1], cluster(wustlid)
est store a3
qui reg `X'  `inter'  `demog' `econ' w2#(`demog' `econ') w3#(`demog' `econ') [aw=finalweight1], cluster(wustlid)
est store a4
qui reg `X'  `inter'  `demog' `econ' `feeling' w2#(`demog' `econ' `feeling') w3#(`demog' `econ' `feeling') [aw=finalweight1], cluster(wustlid)
est store a5
qui reg `X'  `inter'  `demog' `econ' `feeling' `pol' w2#(`demog' `econ' `feeling' `pol') w3#(`demog' `econ' `feeling' `pol')  [aw=finalweight1], cluster(wustlid)
est store a6

esttab a2 a3 a4 a5 a6, ///
keep(w2_whiteevan w3_whiteevan _cons) ///
star(* .10 ** 0.05) ///
sfmt(4) se(2) b(2) 
