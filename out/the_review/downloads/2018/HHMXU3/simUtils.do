
capture program drop _simp
program define _simp, rclass
   version 6.0

   di _n "Simulating main parameters.  Please wait...."
   syntax [, B(string) V(string) Sims(int 1000) Genname(string) ANTIsim DRAWT]

   * GENERATE RANDOM NORMAL OR RANDOM T VARIABLES
   if `sims' > _N {                                 /* expand ds to fit sims*/
      di in y _n "Note: Clarify is expanding your dataset from " _N /*
         */ " observations to `sims'" _n "observations in order to " /*
         */ "accommodate the simulations.  This will append" _n "missing " /*
         */ "values to the bottom of your original dataset." _n
      qui set obs `sims'
   }            
   if "`antisim'"~="" {                             /* antithetical sims    */
      local top = int(`sims'/2 + .5)                /*   calculate boundary */
      local bot = `top' + 1                         /*   for top&bottom half*/
   }
   if "`drawt'" ~= "" {                             /* for drawing from T   */
      tempvar u tfactor                             /* rather than Normal   */
      qui g `u' = uniform() in 1/`sims'
      if "`antisim'"~="" { qui replace `u'=1-`u'[_n-`top'] in `bot'/`sims' }
      qui gen `tfactor' = sqrt(e(df_r)/invchi(e(df_r),`u')) in 1/`sims'
   }
   local numpVC = colsof(`v')
   local i 1
   while `i' <= `numpVC' {
      tempvar u c`i'
      qui g `u' = uniform() in 1/`sims'
      if "`antisim'"~="" { qui replace `u'=1-`u'[_n-`top'] in `bot'/`sims' }
      if "`drawt'" == "" { qui gen `c`i''= invnorm(`u') in 1/`sims' }
      else { qui gen `c`i'' = invnorm(`u')*`tfactor' in 1/`sims' }
      local cnames `cnames' `c`i''                  /* collect names of vars*/
      local newvars `newvars' `genname'`i'          /* collect names newvars*/
      local i = `i' + 1
   }

   * SIMULATE BETAS FROM NORMAL OR T DISTRIBUTION
   tempname A row
   _chol `v' `numpVC'                              /* Cholesky decomp of V */
   matrix `A' = r(chol)
   matrix colnames `A' = `cnames'                /* cols to `c1'..`c`numpVC'' */
   matrix colnames `A' = sameeq:                 /* Thx to Randy Stevenson */
   di "% of simulations completed: " _c        
   local i 1
   while `i' <= `numpVC' {
      di int(`i'*100/`numpVC') "% " _c             /* display progress     */
      matrix `row' = `A'[`i',1...]                  /* get i^th row of A    */
      tempvar b`i'                                  /* temporary variable   */
      matrix score `b`i'' = `row'                   /* c(NxK) * row(1xK)'   */
      qui replace `b`i'' = `b`i'' + `b'[1,`i']      /* add mean             */
      local i = `i' + 1
   }

   * SAVE AND LABEL THE PARAMETERS
   local namepVC : colnames(`v')                    /* all parameters in VC */
   local eqnames : coleq(`v')                       /* all equs             */
   tokenize "`eqnames'"                             /* check for distinct   */
   if "`1'" ~= "_" { local haseqnm 1 }              /*   equation names in  */
   else { local haseqnm 0 }                         /*   the var-cov matrix */
   local i 1
   while `i' <= `numpVC' {                          /* for each parameter:  */
      qui gen `genname'`i' = `b`i''                 /*   save sims to dset  */
      local pname : word `i' of `namepVC'           /*   fetch name of param*/
      * if has equation name, add eqname to label
      if `haseqnm' {                                
         local eqname : word `i' of `eqnames'       
         label var `genname'`i' "Simulated `eqname':`pname' parameter"
      }                              
      * otherwise use simple label w/o an eqname
      else { label var `genname'`i' "Simulated `pname' parameter" }
      local i = `i' + 1
   }
   order `newvars'
   di _n
   return local newvars `newvars'  /* names of newvars that were created */

end


************************** COMPUTATION UTILITIES ****************************

*! version 1.3  April 24, 1999  Michael Tomz
* Cholesky decomposition of an arbitrary matrix
* Input: V, the original matrix
*        k, the dimension of the matrix
* Output: chol, the lower-triangle cholesky of V

capture program drop _chol
program define _chol, rclass
   version 6.0
   args V k
   tempname A
   capt matrix `A' = cholesky(`V')             /* square root of VC matrix  */
   if _rc == 506 {                             /* If VC ~ pos definite, ... */
      tempname eye transf varianc vcd tmp
      mat `eye' = I(`k')                       /* identity matrix           */
      mat `transf' = J(1,`k',0)                /* initialize transf matrix  */
      local i 1
      while `i' <= `k' {
         scalar `varianc' = `V'[`i',`i']       /* variance of parameter `i' */
         if `varianc' ~= 0 {                   /* if has variance, add row  */
            mat `tmp' = `eye'[`i',1...]        /* of `eye' to transf matrix */
            mat `transf' = `transf' \ `tmp'
         }
         local i = `i' + 1
      }
      mat `transf' = `transf'[2...,1...]       /* drop 1st row of transf mat*/
      mat `vcd' = `transf'*`V'*`transf''       /* decomposed VC (no 0 rows) */
      mat `A' = cholesky(`vcd')                /* square root of decomp VC  */
      mat `A' = `transf''*`A'*`transf'         /* rebuild full sq root mat  */               
   }
   else if _rc { matrix `A' = cholesky(`V') }  /* redisplay error message   */
   return matrix chol `A'
end
