

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Figure B.4: Municipios
	**					with Haciendas in 1930
	**					
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
use "`datadir'datageomun1940.dta", clear




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figure B.4: Municipios with Haciendas in 1930
*-------------------------------------------------------------------------------


#delimit;
spmap hac1930 using "`datadir'coordgeomun1940", id(newid) 
fcolor(Greys2) ocolor(Greys2) osize(vvthin) clmethod(unique) 
legtitle({stSans:Ranges by color}) legend(pos(7) symxsize(10) size(3.5)) 
ndlabel(" ") ndfcolor(white) ndocolor(white) 
plotregion(icolor(none)) graphregion(icolor(none)) title("", size(4));
local figuresdir $figures;
graph export "`figuresdir'17_FigureB4.pdf", replace;
graph export "`figuresdir'17_FigureB4.png", height(600) replace;
#delimit cr
