*****************************************************************
***This program runs the function in "Program.do" for different 
*** values of the parameters in produces in the results in section 5.
**********************************************************************

cd "XXXX define path to folders XXXX/MC"

do "do-files/Simulations/Program.do"


forvalues R=1(1)200 {

foreach a_b in "50 200"  { 
	
	foreach N in 25 100   {

		foreach c in 0.01 0.1 0.2 {

			forvalues power=0(2)20 {
			
			Simulation `N' `a_b' `c' `power' `R'		

			}
		}
	}

}
}

