/*A New Cox Table for AJPS RR*/

*Model 1: base model*
	stcox I contigdum minmin lcaprat smldmat S, cl(dyadid) nohr

*Model 2: RISc standalone model*
	stcox RISc_min, cl(dyadid) nohr

*Model 3: full model*
	stcox RISc_min I RI contigdum minmin lcaprat smldmat S, cl(dyadid) nohr

