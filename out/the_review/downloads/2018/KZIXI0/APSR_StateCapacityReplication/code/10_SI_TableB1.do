

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Table B.1: Average Spot 
	**					Prices (USD per metric tonne), 
	**					Before and After the Great Depression
	**					
	** 
	**
	**				
	**		Version: 	Stata MP 12.1
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Prepare data
*-------------------------------------------------------------------------------


local datadir $data
use "`datadir'DPanel_Mun1940.dta", clear
tsset cve_geoest year




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Table B.1: 		Average Spot Prices (USD per metric tonne),
*					Before and After the Great Depression
*-------------------------------------------------------------------------------


* Table information entered by hand from the following output
makematrix, from(r(mean)) vector format(%04.2f): su ma10_banana 			///
	ma10_barley ma10_cacao ma10_coffeerio ma10_cotton ma10_maize 			///
	ma10_riceus ma10_sugar ma10_wheat if year==1930, meanonly
makematrix, from(r(mean)) vector format(%04.2f): su ma10_banana 			///
	ma10_barley ma10_cacao ma10_coffeerio ma10_cotton ma10_maize 			///
	ma10_riceus ma10_sugar ma10_wheat if year==1940, meanonly
