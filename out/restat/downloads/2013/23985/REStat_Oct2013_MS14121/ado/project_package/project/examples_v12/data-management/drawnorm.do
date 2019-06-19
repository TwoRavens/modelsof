/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/

	version 12
	
	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name



* Example 1

	matrix M = 5, -6, 0.5
	matrix V = (9, 5, 2 \ 5, 4, 1 \ 2, 1, 1)
	matrix list M
	
	matrix list V
	
	drawnorm x y z, n(1000) cov(V) means(M)
	
	summarize
	
	correlate, cov
	
	
* Example 2

	
	matrix C = ( 1.0000, 0.3232, 0.1112, 0.0066 \ ///
		0.3232, 1.0000, 0.6608, -0.1572 \ ///
		0.1112, 0.6608, 1.0000, -0.1480 \ ///
		0.0066, -0.1572, -0.1480, 1.0000 )
		
		
	matrix rownames C = price trunk headroom rep78
	matrix colnames C = price trunk headroom rep78
	
	mat list C
	
	
	matrix C = ( 1.0000, ///
		0.3232, 1.0000, ///
		0.1112, 0.6608, 1.0000, ///
		0.0066, -0.1572, -0.1480, 1.0000)
		
	mat list C
	
		
	matrix C = ( 1, 0.3232, 1, 0.1112, 0.6608, 1, 0.0066, -0.1572, -0.1480, 1 )
	
	mat list C

	
	matrix C = ( 1.0000, 0.3232, 0.1112, 0.0066, ///
		1.0000, 0.6608, -0.1572, ///
		1.0000, -0.1480, ///
		1.0000 )
		
	mat list C

		
	matrix C = ( 1, 0.3232, 0.1112, 0.0066, 1, 0.6608, -0.1572, 1, -0.1480, 1 )
	
	mat list C
