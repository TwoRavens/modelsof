*-------------------------------------------------------------------------------
* Load 1910 complete count data from IPUMS
*-------------------------------------------------------------------------------

gen german=(bpl==453)

* Create variables
gen naturalized=(citizen==2)
replace naturalized=. if citizen==.|citizen==0

gen english=(speakeng>1)
replace english=. if speakeng==0

gen literate=(lit==4)
replace literate=. if lit==0

gen ILPA=(statefip==17|statefip==42)
gen Ancestry=(statefip==42|statefip==24|statefip==6|statefip==51)
gen nonAncestry=(Ancestry==0)
gen nonILPA=(ILPA==0)

* Column 1
sum age yrsusa1 naturalized english literate occscore

* Column 2
sum age yrsusa1 naturalized english literate occscore if statefip==42|statefip==24|statefip==6|statefip==51  //States in Ancestry.com data: CA, MD, PA, VI 

* Column 3
sum age yrsusa1 naturalized english literate occscore if statefip==17|statefip==42  //IL/PA

* Column 4
foreach x in age yrsusa1 naturalized english literate occscore {
	estpost ttest `x', by(nonAncestry)
	esttab ., se star(* 0.1 ** 0.05 *** 0.01)
}

* Column 5
foreach x in age yrsusa1 naturalized english literate occscore {
	estpost ttest `x', by(nonILPA)
	esttab ., se star(* 0.1 ** 0.05 *** 0.01)
}
