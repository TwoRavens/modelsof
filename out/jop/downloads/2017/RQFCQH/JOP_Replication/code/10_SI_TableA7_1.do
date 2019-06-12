

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
	** 	
	**		DETAILS: 	This code produces Table A.7.1: Descriptives 
	**					by Royal Treasury
	**					
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
use "`datadir'desc_mining_cajas.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table A.7.1: Descriptives by Royal Treasury
*-------------------------------------------------------------------------------


local tablesdir $tables
texsave using "`tablesdir'TableA7_1.tex", frag replace nofix				///
	size(2) varlabels width(\textwidth) location(htbp) align(l|ccc|cc|cc)	///
	title("Descriptives by Royal Treasury") marker(table:descriptives)		///
	footnote(\specialcell{\scriptsize Note: \textit{Initial Total Revenue}	///
	corresponds to 1714 or the first year with data. Mining revenue in 		///
	Mexico City includes \\\scriptsize the minting for all the colony 	 	///
	and thus exaggerates the relative importance of mining in that treasury.})	


		
		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		



