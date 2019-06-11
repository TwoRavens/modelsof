**********
*Table 1*
**********
*Complexity: Word Count
local controls = "ideoldis  legprof divgov percentcit ig_dom subject_restrict  bmc "
local states = "  s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23"
local year = " y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16"
reg wordcount sr gds tl `controls' `states' `year' , robust

*Complexity: FK Reading Ease Score
local controls = "ideoldis  legprof divgov percentcit ig_dom subject_restrict  bmc "
local states = "  s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23"
local year = " y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16"
reg FKDiff sr gds tl  `controls' `states' `year' , robust

*Complexity: FK Grade Level Score
local controls = "ideoldis  legprof divgov percentcit ig_dom subject_restrict  bmc "
local states = "  s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23"
local year = " y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16"
reg   fleschlincaidgradelevel sr gds tl `controls' `states' `year' , robust

**********
*Table 2*
**********
*Complexity: Word Count
local controls = "ideoldis  legprof  divgov percentcit ig_dom  subject_restrict  bmc"
local states = "  s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23"
local year = " y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16"
reg yespercent  wordcount sr gds tl  `controls' `states' `year' , robust

*Complexity: FK Reading Ease Score
local controls = "ideoldis  legprof  divgov percentcit ig_dom  subject_restrict  bmc"
local states = "  s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23"
local year = " y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16"
reg yespercent  FKDiff sr gds tl `controls' `states' `year' , robust

*Complexity: FK Grade Level Score
local controls = "ideoldis  legprof  divgov percentcit ig_dom  subject_restrict bmc"
local states = "  s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 s23"
local year = " y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16"
reg yespercent  fleschlincaidgradelevel sr gds tl `controls' `states' `year' , robust

**********
*Table A2*
**********
*Note: Use Milita_appendix.dta*
reg  nosigsvalid  radical easy, robust
logit madeballot radical easy, robust
