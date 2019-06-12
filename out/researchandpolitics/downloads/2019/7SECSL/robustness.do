
//ROBUSTNESS TESTS IN APPENDIX

**Test for influence of particular provinces on non-effect of immigration (Figure A1)
mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso], r base(6) 
margins, dydx(*) predict(outcome(5)) post
estimates store full_vox

mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso] if prov!=4, r base(6) 
margins, dydx(*) predict(outcome(5)) post
estimates store vox4

mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso] if prov!=11, r base(6) 
margins, dydx(*) predict(outcome(5)) post
estimates store vox11

mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso] if prov!=14, r base(6) 
margins, dydx(*) predict(outcome(5)) post
estimates store vox14

mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso] if prov!=18, r base(6) 
margins, dydx(*) predict(outcome(5)) post
estimates store vox18

mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso] if prov!=21, r base(6) 
margins, dydx(*) predict(outcome(5)) post
estimates store vox21

mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso] if prov!=23, r base(6) 
margins, dydx(*) predict(outcome(5)) post
estimates store vox23

mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso] if prov!=29, r base(6) 
margins, dydx(*) predict(outcome(5)) post
estimates store vox29

mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad  i.gender ib(1).employment [pweight=peso] if prov!=41, r base(6) 
margins, dydx(*) predict(outcome(5)) post
estimates store vox41


set scheme plottig
coefplot full_vox vox4 vox11 vox14 vox18 vox21 vox23 vox29 vox41, keep(*.migration *.spain diaz sanchez) vertical yline(0)


****Test with PP as baseline
mlogit vote18 i.migration i.spain diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad i.gender ib(1).employment [pweight=peso], r base(2) 



***Test of support for Vox using a binary variable and a former vote indicator
logit votevox i.migration i.spain##ib(97).recuerdo diaz sanchez ideology i.distrust i.protest i.churchgoer i.education pincome c.edad i.gender ib(1).employment [pweight=peso], r 
