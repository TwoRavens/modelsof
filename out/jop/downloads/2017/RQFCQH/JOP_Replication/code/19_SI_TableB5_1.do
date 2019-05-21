

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Table B.5.1: Direct 
	**					Administration of Custom Houses by the Crown 
	**					in Mining and Non-Mining Treasuries by 1775
	**					
	**
	** 
	**
	**				
	**		Versi—n: 	Stata MP 12.1
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Data
*-------------------------------------------------------------------------------



clear all
local datadir $data
use "`datadir'NuevaEspana_cajas.dta", clear







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table B.5.1: 	Direct Administration of Custom Houses by the Crown 
*				in Mining and Non-Mining Treasuries by 1775
*-------------------------------------------------------------------------------


makematrix medi, 															///
	from(r(mu_1) r(mu_2) r(mu_1)-r(mu_2) r(se) r(p))						///
	listwise format(%04.3f): 												///
	ttest  praduana_adm if year==1775, by(evertribunal) unequal
	
makematrix qmedi, 															///
	from(r(mu_1) r(mu_2) r(mu_1)-r(mu_2) r(se) r(p))						///
	listwise format(%04.3f): 												///
	ttest  prqaduana_adm if year==1775, by(evertribunal) unequal

makematrix nmedias, 														///
	from(r(N_1) r(N_2) e(l) e(l) e(l))										///
	listwise format(%04.3f): 												///
	ttest  praduana_adm if year==1775, by(evertribunal) unequal	

matrix medias = medi\qmedi\nmedias
local cnam "Non-Mining Treasuries (mean)" "Mining Treasuries (mean)" 
local cnam "`cnam'" "Difference" "Std Error" "p-value"
mat colnames medias = "`cnam'"
local rnam "Aduanas (Direct Adm)" "Revenue (Direct Adm)" "Number of Treasuries"
mat rownames medias = "`rnam'"

local tablesdir $tables
esttab matrix(medias, fmt(a3)) using "`tablesdir'TableB5_1.tex", 			///
	replace nomtitles fragment 



		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		



