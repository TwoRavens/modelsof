***Coding for Figure 7, using ANES 1992-1996 Panel data, Mason AJPS

egen miss=rmiss(idcomplexity92 idcomplexity94 idcomplexity96 thermbias92 thermbias96 likebias92 likebias96 pastactiv92 pastactiv96 angercand92 angercand96 issuestr92 issuestr96)

gen sorted3=1 if idcomplexity92<idcomplexity96 
replace sorted3=0 if sorted3==.

mean thermbias92 thermbias96 if sorted3==1 & miss==0
mean likebias92 likebias96 if sorted3==1 & miss==0
mean pastactiv92 pastactiv96 if sorted3==1 & miss==0
mean angercand92 angercand96 if sorted3==1 & miss==0
mean issuestr92 issuestr96 if sorted3==1 & miss==0

***Those whose sorting decreased
gen unsorted3=1 if idcomplexity92>idcomplexity96
replace unsorted3=0 if unsorted3==.
mean thermbias92 thermbias96 if unsorted3==1 & miss==0
mean likebias92 likebias96 if unsorted3==1 & miss==0
mean pastactiv92 pastactiv96 if unsorted3==1 & miss==0
mean angercand92 angercand96 if unsorted3==1 & miss==0
mean issuestr92 issuestr96 if unsorted3==1 & miss==0







