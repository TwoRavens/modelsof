** Primary equations for tables 1-3 of Taming the Leviathan by Brandon Prins and David Lektzian **

** Table1: These equations show the effect on gov. revenue collection   **
** s05f3 is Nat Gov't Rev PerCap  s:0.01 from Banks				**
	xtreg D.s05f3  D.hoodt2all  D.hoodallinternal  D.hoodpolity2_2 D.hoodmaxmilex_2scaled D.polity2_2 D.gdppercap1995 majpow, robust

	xtreg FD.s05f3  D.hoodt2all  D.hoodallinternal  D.hoodpolity2_2   D.hoodmaxmilex_2scaled D.polity2_2 D.gdppercap1995 majpow, robust
		** Substantive effect of a one unit increase in neighborhood conflicts **
			mfx, at(D.hoodt2all=0 D.polity2_2=0 majpow=0)
			mfx, at(D.hoodt2all=1 D.polity2_2=0 majpow=0)

	xtreg F2D.s05f3  D.hoodt2all D.hoodallinternal D.hoodpolity2_2   D.hoodmaxmilex_2scaled D.polity2_2 D.gdppercap1995 majpow, robust
	

** Table2: These equations show the effect on gov. spending	**
** First we look at all spending					**
** s05f6 is  Nat Gov't Expend PerCap  s:0.01			**
	xtreg D.s05f6 D.hoodt2all  D.hoodallinternal  D.hoodpolity2_2  D.hoodmaxmilex_2scaled D.polity2_2 D.gdppercap1995 majpow, robust
		** Substantive effect of a large change toward autocracy in neighboring states (at the 75th percentile)**
			mfx, at(D.hoodpolity2_2=-6.5 D.polity2_2=0 majpow=0)
			mfx, at(D.hoodpolity2_2=0 D.polity2_2=0 majpow=0)
	
	xtreg FD.s05f6 D.hoodt2all  D.hoodallinternal D.hoodpolity2_2  D.hoodmaxmilex_2scaled D.polity2_2 D.gdppercap1995 majpow, robust
		** Substantive effect of a one unit increase in neighborhood conflicts **
			mfx, at(D.hoodt2all=0 D.polity2_2=0 majpow=0)
			mfx, at(D.hoodt2all=1 D.polity2_2=0 majpow=0)

	xtreg F2D.s05f6 D.hoodt2all  D.hoodallinternal  D.hoodpolity2_2   D.hoodmaxmilex_2scaled D.polity2_2 D.gdppercap1995 majpow, robust
	
** Table3: Then we look at Military spending	**
** milex is military expenditures s:0.01		**
	xtreg D.milexscaled D.hoodt2all  D.hoodallinternal  D.hoodpolity2_2  D.hoodmaxmilex_2scaled D.polity2_2 D.gdppercap1995 majpow, robust
		** Substantive effect of a one unit increase in neighborhood conflicts **
			mfx, at(D.hoodt2all=0 D.polity2_2=0 majpow=0)
			mfx, at(D.hoodt2all=1 D.polity2_2=0 majpow=0)

	xtreg FD.milexscaled  D.hoodt2all  D.hoodallinternal  D.hoodpolity2_2  D.hoodmaxmilex_2scaled D.polity2_2 D.gdppercap1995 majpow, robust
		** Substantive effect of a one standard deviation increase in the largest military expenditures by a neighboring state **
			mfx, at(D.polity2_2=0 majpow=0 D.hoodmaxmilex_2scaled=10000)
			mfx, at(D.polity2_2=0 majpow=0 D.hoodmaxmilex_2scaled=0)

	xtreg F2D.milexscaled  D.hoodt2all  D.hoodallinternal D.hoodpolity2_2  D.hoodmaxmilex_2scaled D.polity2_2 D.gdppercap1995 majpow, robust
