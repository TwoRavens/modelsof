use "data.dta", clear
teffects nnmatch (note absx2 absy2) (postin)  ///
		,  nneighbor(1)  biasadj(absx2 absy2)   metric(euclidean)

teffects nnmatch (sumnoteseason absx2 absy2) (postin)  ///
		if   note!=. ///
		,  nneighbor(1)  biasadj(absx2 absy2)   metric(euclidean)
		
teffects nnmatch (avteamnote2 absx2 absy2) (postin)  ///
		if  note!=. ///
		,  nneighbor(1)  biasadj(absx2 absy2)   metric(euclidean)
		
teffects nnmatch (sumteamnoteseason absx2 absy2) (postin)  ///
		if  note!=. ///
		,  nneighbor(1)  biasadj(absx2 absy2)   metric(euclidean)
