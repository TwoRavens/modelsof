* BIVARIATE ORDERED PROBITS FOR 3-LEVEL OUTCOME WITH TWO-WAY FEEDBACK 
* FEEDBACK EFFECTS FOR CHOOSING SAME LEVEL OF INTENSITY AS FRIEND
*--------------------------------------------------------------------------------------------------* VERSION 1a : Prob High EQU = .5*--------------------------------------------------------------------------------------------------#delimit ;
program define bivoprob_v1a;
	
	args lnf xb1 xb2 k1 g1 dk g2 rho;	tempvar thrho p02 p20 p01 p10 p12 p21 p00all p22all p11all pme1 pme2 pup ek1 ek2 ek3 ek4;
	quietly gen `thrho' = tanh(`rho');	quietly gen `pup'=.5;
	quietly gen `ek1' = `k1';
	quietly gen `ek2' = `ek1'+exp(`g1');
	quietly gen `ek3' = `ek2'+exp(`dk');
	quietly gen `ek4' = `ek3'+exp(`g2');
	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek4'+`xb2',-`thrho');	quietly gen double `p20' = binormal(-`ek4'+`xb1',`ek1'-`xb2',-`thrho');

	quietly gen double `p01' = binormal(`ek1'-`xb1',-`ek2'+`xb2',-`thrho')-`p02';
	quietly gen double `p10' = binormal(-`ek2'+`xb1',`ek1'-`xb2',-`thrho')-`p20';

	quietly gen double `p12' = binormal(`ek3'-`xb1',-`ek4'+`xb2',-`thrho')-`p02';
	quietly gen double `p21' = binormal(-`ek4'+`xb1',`ek3'-`xb2',-`thrho')-`p20';

	quietly gen double `p00all' = binormal(`ek2'-`xb1',`ek2'-`xb2',`thrho');
	quietly gen double `p22all' = binormal(-`ek3'+`xb1',-`ek3'+`xb2',`thrho');

	quietly gen double `pme1' = `p00all' 
						- binormal(`ek2'-`xb1',`ek1'-`xb2',`thrho')
						- binormal(`ek1'-`xb1',`ek2'-`xb2',`thrho')
						+ binormal(`ek1'-`xb1',`ek1'-`xb2',`thrho');

	quietly gen double `pme2' = `p22all' 
						- binormal(-`ek3'+`xb1',-`ek4'+`xb2',`thrho')
						- binormal(-`ek4'+`xb1',-`ek3'+`xb2',`thrho')
						+ binormal(-`ek4'+`xb1',-`ek4'+`xb2',`thrho');

	quietly gen double `p11all' = binormal(`ek4'-`xb1',`ek4'-`xb2',`thrho')
						- `p01' - `p10' - `p00all' + `pme1';
	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
 	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);

	quietly replace `lnf' = ln(`p01') if ($ML_y1==0 & $ML_y2==1); 	
	quietly replace `lnf' = ln(`p10') if ($ML_y1==1 & $ML_y2==0); 

	quietly replace `lnf' = ln(`p12') if ($ML_y1==1 & $ML_y2==2); 	
	quietly replace `lnf' = ln(`p21') if ($ML_y1==2 & $ML_y2==1); 

	quietly replace `lnf' = ln(`p00all'-`pup'*`pme1') if ($ML_y1==0 & $ML_y2==0);
	quietly replace `lnf' = ln(`p22all'-(1-`pup')*`pme2') if ($ML_y1==2 & $ML_y2==2);
	quietly replace `lnf' = ln(`p11all'-(1-`pup')*`pme1'-`pup'*`pme2') if ($ML_y1==1 & $ML_y2==1); 

end;

#delimit ;
program define bivoprob_v1aa;
	
	args lnf xb1 xb2 k1 g1 k2 g2 rho;	tempvar thrho p02 p20 p01 p10 p12 p21 p00all p22all p11all pme1 pme2 pup ek1 ek2 ek3 ek4;
	quietly gen `thrho' = tanh(`rho');	quietly gen `pup'=.5;
	quietly gen `ek1' = `k1';
	quietly gen `ek2' = `ek1'+exp(`g1');
	quietly gen `ek3' =  `k2';
	quietly gen `ek4' = `ek3'+exp(`g2');
	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek4'+`xb2',-`thrho');	quietly gen double `p20' = binormal(-`ek4'+`xb1',`ek1'-`xb2',-`thrho');

	quietly gen double `p01' = binormal(`ek1'-`xb1',-`ek2'+`xb2',-`thrho')-`p02';
	quietly gen double `p10' = binormal(-`ek2'+`xb1',`ek1'-`xb2',-`thrho')-`p20';

	quietly gen double `p12' = binormal(`ek3'-`xb1',-`ek4'+`xb2',-`thrho')-`p02';
	quietly gen double `p21' = binormal(-`ek4'+`xb1',`ek3'-`xb2',-`thrho')-`p20';

	quietly gen double `p00all' = binormal(`ek2'-`xb1',`ek2'-`xb2',`thrho');
	quietly gen double `p22all' = binormal(-`ek3'+`xb1',-`ek3'+`xb2',`thrho');

	quietly gen double `pme1' = `p00all' 
						- binormal(`ek2'-`xb1',`ek1'-`xb2',`thrho')
						- binormal(`ek1'-`xb1',`ek2'-`xb2',`thrho')
						+ binormal(`ek1'-`xb1',`ek1'-`xb2',`thrho');

	quietly gen double `pme2' = `p22all' 
						- binormal(-`ek3'+`xb1',-`ek4'+`xb2',`thrho')
						- binormal(-`ek4'+`xb1',-`ek3'+`xb2',`thrho')
						+ binormal(-`ek4'+`xb1',-`ek4'+`xb2',`thrho');

	quietly gen double `p11all' = binormal(`ek4'-`xb1',`ek4'-`xb2',`thrho')
						- `p01' - `p10' - `p00all' + `pme1';
	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
 	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);

	quietly replace `lnf' = ln(`p01') if ($ML_y1==0 & $ML_y2==1); 	
	quietly replace `lnf' = ln(`p10') if ($ML_y1==1 & $ML_y2==0); 

	quietly replace `lnf' = ln(`p12') if ($ML_y1==1 & $ML_y2==2); 	
	quietly replace `lnf' = ln(`p21') if ($ML_y1==2 & $ML_y2==1); 

	quietly replace `lnf' = ln(`p00all'-`pup'*`pme1') if ($ML_y1==0 & $ML_y2==0);
	quietly replace `lnf' = ln(`p22all'-(1-`pup')*`pme2') if ($ML_y1==2 & $ML_y2==2);
	quietly replace `lnf' = ln(`p11all'-(1-`pup')*`pme1'-`pup'*`pme2') if ($ML_y1==1 & $ML_y2==1); 

end;

*--------------------------------------------------------------------------------------------------;* VERSION 1b : Prob High EQU = .5 -- No gammas*--------------------------------------------------------------------------------------------------;#delimit ;
program define bivoprob_v1b;
	
	args lnf xb1 xb2 k1 dk rho;	tempvar thrho p02 p20 p01 p10 p12 p21 p00all p22all p11all pme1 pme2 pup ek1 ek2 ek3 ek4;
	quietly gen `thrho' = tanh(`rho');	quietly gen `pup'=.5;
	quietly gen `ek1' = `k1';
	quietly gen `ek2' = `ek1';
	quietly gen `ek3' = `ek2'+exp(`dk');
	quietly gen `ek4' = `ek3';
	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek4'+`xb2',-`thrho');	quietly gen double `p20' = binormal(-`ek4'+`xb1',`ek1'-`xb2',-`thrho');

	quietly gen double `p01' = binormal(`ek1'-`xb1',-`ek2'+`xb2',-`thrho')-`p02';
	quietly gen double `p10' = binormal(-`ek2'+`xb1',`ek1'-`xb2',-`thrho')-`p20';

	quietly gen double `p12' = binormal(`ek3'-`xb1',-`ek4'+`xb2',-`thrho')-`p02';
	quietly gen double `p21' = binormal(-`ek4'+`xb1',`ek3'-`xb2',-`thrho')-`p20';

	quietly gen double `p00all' = binormal(`ek2'-`xb1',`ek2'-`xb2',`thrho');
	quietly gen double `p22all' = binormal(-`ek3'+`xb1',-`ek3'+`xb2',`thrho');

	quietly gen double `pme1' = `p00all' 
						- binormal(`ek2'-`xb1',`ek1'-`xb2',`thrho')
						- binormal(`ek1'-`xb1',`ek2'-`xb2',`thrho')
						+ binormal(`ek1'-`xb1',`ek1'-`xb2',`thrho');

	quietly gen double `pme2' = `p22all' 
						- binormal(-`ek3'+`xb1',-`ek4'+`xb2',`thrho')
						- binormal(-`ek4'+`xb1',-`ek3'+`xb2',`thrho')
						+ binormal(-`ek4'+`xb1',-`ek4'+`xb2',`thrho');

	quietly gen double `p11all' = binormal(`ek4'-`xb1',`ek4'-`xb2',`thrho')
						- `p01' - `p10' - `p00all' + `pme1';

	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
 	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);

	quietly replace `lnf' = ln(`p01') if ($ML_y1==0 & $ML_y2==1); 	
	quietly replace `lnf' = ln(`p10') if ($ML_y1==1 & $ML_y2==0); 

	quietly replace `lnf' = ln(`p12') if ($ML_y1==1 & $ML_y2==2); 	
	quietly replace `lnf' = ln(`p21') if ($ML_y1==2 & $ML_y2==1); 

	quietly replace `lnf' = ln(`p00all'-`pup'*`pme1') if ($ML_y1==0 & $ML_y2==0);
	quietly replace `lnf' = ln(`p22all'-(1-`pup')*`pme2') if ($ML_y1==2 & $ML_y2==2);
	quietly replace `lnf' = ln(`p11all'-(1-`pup')*`pme1'-`pup'*`pme2') if ($ML_y1==1 & $ML_y2==1); 

end;

*--------------------------------------------------------------------------------------------------* VERSION 2 : Prob High EQU = 1*--------------------------------------------------------------------------------------------------#delimit ;
program define bivoprob_v2;
	
	args lnf xb1 xb2 k1 g1 dk g2 rho;	tempvar thrho p02 p20 p01 p10 p12 p21 p00all p22all p11all pme1 pme2 pup ek1 ek2 ek3 ek4;
	quietly gen `thrho' = tanh(`rho');	quietly gen `pup'=1;
	quietly gen `ek1' = `k1';
	quietly gen `ek2' = `ek1'+exp(`g1');
	quietly gen `ek3' = `ek2'+exp(`dk');
	quietly gen `ek4' = `ek3'+exp(`g2');
	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek4'+`xb2',-`thrho');	quietly gen double `p20' = binormal(-`ek4'+`xb1',`ek1'-`xb2',-`thrho');

	quietly gen double `p01' = binormal(`ek1'-`xb1',-`ek2'+`xb2',-`thrho')-`p02';
	quietly gen double `p10' = binormal(-`ek2'+`xb1',`ek1'-`xb2',-`thrho')-`p20';

	quietly gen double `p12' = binormal(`ek3'-`xb1',-`ek4'+`xb2',-`thrho')-`p02';
	quietly gen double `p21' = binormal(-`ek4'+`xb1',`ek3'-`xb2',-`thrho')-`p20';

	quietly gen double `p00all' = binormal(`ek2'-`xb1',`ek2'-`xb2',`thrho');
	quietly gen double `p22all' = binormal(-`ek3'+`xb1',-`ek3'+`xb2',`thrho');

	quietly gen double `pme1' = `p00all' 
						- binormal(`ek2'-`xb1',`ek1'-`xb2',`thrho')
						- binormal(`ek1'-`xb1',`ek2'-`xb2',`thrho')
						+ binormal(`ek1'-`xb1',`ek1'-`xb2',`thrho');

	quietly gen double `pme2' = `p22all' 
						- binormal(-`ek3'+`xb1',-`ek4'+`xb2',`thrho')
						- binormal(-`ek4'+`xb1',-`ek3'+`xb2',`thrho')
						+ binormal(-`ek4'+`xb1',-`ek4'+`xb2',`thrho');

	quietly gen double `p11all' = binormal(`ek4'-`xb1',`ek4'-`xb2',`thrho')
						- `p01' - `p10' - `p00all' + `pme1';
	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
 	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);

	quietly replace `lnf' = ln(`p01') if ($ML_y1==0 & $ML_y2==1); 	
	quietly replace `lnf' = ln(`p10') if ($ML_y1==1 & $ML_y2==0); 

	quietly replace `lnf' = ln(`p12') if ($ML_y1==1 & $ML_y2==2); 	
	quietly replace `lnf' = ln(`p21') if ($ML_y1==2 & $ML_y2==1); 

	quietly replace `lnf' = ln(`p00all'-`pup'*`pme1') if ($ML_y1==0 & $ML_y2==0);
	quietly replace `lnf' = ln(`p22all'-(1-`pup')*`pme2') if ($ML_y1==2 & $ML_y2==2);
	quietly replace `lnf' = ln(`p11all'-(1-`pup')*`pme1'-`pup'*`pme2') if ($ML_y1==1 & $ML_y2==1); 
end;

*--------------------------------------------------------------------------------------------------* VERSION 3 : Prob High EQU = 0*--------------------------------------------------------------------------------------------------#delimit ;
program define bivoprob_v3;
	
	args lnf xb1 xb2 k1 g1 dk g2 rho;	tempvar thrho p02 p20 p01 p10 p12 p21 p00all p22all p11all pme1 pme2 pup ek1 ek2 ek3 ek4;
	quietly gen `thrho' = tanh(`rho');	quietly gen `pup'=0;
	quietly gen `ek1' = `k1';
	quietly gen `ek2' = `ek1'+exp(`g1');
	quietly gen `ek3' = `ek2'+exp(`dk');
	quietly gen `ek4' = `ek3'+exp(`g2');
	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek4'+`xb2',-`thrho');	quietly gen double `p20' = binormal(-`ek4'+`xb1',`ek1'-`xb2',-`thrho');

	quietly gen double `p01' = binormal(`ek1'-`xb1',-`ek2'+`xb2',-`thrho')-`p02';
	quietly gen double `p10' = binormal(-`ek2'+`xb1',`ek1'-`xb2',-`thrho')-`p20';

	quietly gen double `p12' = binormal(`ek3'-`xb1',-`ek4'+`xb2',-`thrho')-`p02';
	quietly gen double `p21' = binormal(-`ek4'+`xb1',`ek3'-`xb2',-`thrho')-`p20';

	quietly gen double `p00all' = binormal(`ek2'-`xb1',`ek2'-`xb2',`thrho');
	quietly gen double `p22all' = binormal(-`ek3'+`xb1',-`ek3'+`xb2',`thrho');

	quietly gen double `pme1' = `p00all' 
						- binormal(`ek2'-`xb1',`ek1'-`xb2',`thrho')
						- binormal(`ek1'-`xb1',`ek2'-`xb2',`thrho')
						+ binormal(`ek1'-`xb1',`ek1'-`xb2',`thrho');

	quietly gen double `pme2' = `p22all' 
						- binormal(-`ek3'+`xb1',-`ek4'+`xb2',`thrho')
						- binormal(-`ek4'+`xb1',-`ek3'+`xb2',`thrho')
						+ binormal(-`ek4'+`xb1',-`ek4'+`xb2',`thrho');

	quietly gen double `p11all' = binormal(`ek4'-`xb1',`ek4'-`xb2',`thrho')
						- `p01' - `p10' - `p00all' + `pme1';
	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
 	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);

	quietly replace `lnf' = ln(`p01') if ($ML_y1==0 & $ML_y2==1); 	
	quietly replace `lnf' = ln(`p10') if ($ML_y1==1 & $ML_y2==0); 

	quietly replace `lnf' = ln(`p12') if ($ML_y1==1 & $ML_y2==2); 	
	quietly replace `lnf' = ln(`p21') if ($ML_y1==2 & $ML_y2==1); 

	quietly replace `lnf' = ln(`p00all'-`pup'*`pme1') if ($ML_y1==0 & $ML_y2==0);
	quietly replace `lnf' = ln(`p22all'-(1-`pup')*`pme2') if ($ML_y1==2 & $ML_y2==2);
	quietly replace `lnf' = ln(`p11all'-(1-`pup')*`pme1'-`pup'*`pme2') if ($ML_y1==1 & $ML_y2==1); 

end;

*--------------------------------------------------------------------------------------------------;* VERSION 4: Partial Likelihood   - rho = 0, gammas free*--------------------------------------------------------------------------------------------------;#delimit ;
program define bivoprob_v4;
	args lnf xb1 xb2 k1 g1 dk g2 rho;	tempvar thrho p02 p20 p01 p10 p12 p21 p00all p22all p11all pme1 pme2 pup ek1 ek2 ek3 ek4;
	quietly gen `thrho' = tanh(`rho');	quietly gen `pup'=0;
	quietly gen `ek1' = `k1';
	quietly gen `ek2' = `ek1'+exp(`g1');
	quietly gen `ek3' = `ek2'+exp(`dk');
	quietly gen `ek4' = `ek3'+exp(`g2');
	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek4'+`xb2',-`thrho');	quietly gen double `p20' = binormal(-`ek4'+`xb1',`ek1'-`xb2',-`thrho');

	quietly gen double `p01' = binormal(`ek1'-`xb1',-`ek2'+`xb2',-`thrho')-`p02';
	quietly gen double `p10' = binormal(-`ek2'+`xb1',`ek1'-`xb2',-`thrho')-`p20';

	quietly gen double `p12' = binormal(`ek3'-`xb1',-`ek4'+`xb2',-`thrho')-`p02';
	quietly gen double `p21' = binormal(-`ek4'+`xb1',`ek3'-`xb2',-`thrho')-`p20';

	quietly gen double `p00all' = binormal(`ek2'-`xb1',`ek2'-`xb2',`thrho');
	quietly gen double `p22all' = binormal(-`ek3'+`xb1',-`ek3'+`xb2',`thrho');

	quietly gen double `pme1' = `p00all' 
						- binormal(`ek2'-`xb1',`ek1'-`xb2',`thrho')
						- binormal(`ek1'-`xb1',`ek2'-`xb2',`thrho')
						+ binormal(`ek1'-`xb1',`ek1'-`xb2',`thrho');

	quietly gen double `pme2' = `p22all' 
						- binormal(-`ek3'+`xb1',-`ek4'+`xb2',`thrho')
						- binormal(-`ek4'+`xb1',-`ek3'+`xb2',`thrho')
						+ binormal(-`ek4'+`xb1',-`ek4'+`xb2',`thrho');

	quietly gen double `p11all' = binormal(`ek4'-`xb1',`ek4'-`xb2',`thrho')
						- `p01' - `p10' - `p00all' + `pme1';

	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
 	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);

	quietly replace `lnf' = ln(`p01') if ($ML_y1==0 & $ML_y2==1); 	
	quietly replace `lnf' = ln(`p10') if ($ML_y1==1 & $ML_y2==0); 

	quietly replace `lnf' = ln(`p12') if ($ML_y1==1 & $ML_y2==2); 	
	quietly replace `lnf' = ln(`p21') if ($ML_y1==2 & $ML_y2==1); 

	quietly replace `lnf' = ln(`p00all'+`p11all'+`p22all'-`pme1'-`pme2') 
		if ($ML_y1==0 & $ML_y2==0)|($ML_y1==1 & $ML_y2==1)|($ML_y1==2 & $ML_y2==2);
end;

*--------------------------------------------------------------------------------------------------;* VERSION 4b: Partial Likelihood   - rho free, no gammas *--------------------------------------------------------------------------------------------------;#delimit ;
program define bivoprob_v4b;
	args lnf xb1 xb2 k1 dk rho;	tempvar thrho p02 p20 p01 p10 p12 p21 p00all p22all p11all pme1 pme2 pup ek1 ek2 ek3 ek4;
	quietly gen `thrho' = tanh(`rho');	quietly gen `pup'=0;
	quietly gen `ek1' = `k1';
	quietly gen `ek2' = `ek1';
	quietly gen `ek3' = `ek2'+exp(`dk');
	quietly gen `ek4' = `ek3';
	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek4'+`xb2',-`thrho');	quietly gen double `p20' = binormal(-`ek4'+`xb1',`ek1'-`xb2',-`thrho');

	quietly gen double `p01' = binormal(`ek1'-`xb1',-`ek2'+`xb2',-`thrho')-`p02';
	quietly gen double `p10' = binormal(-`ek2'+`xb1',`ek1'-`xb2',-`thrho')-`p20';

	quietly gen double `p12' = binormal(`ek3'-`xb1',-`ek4'+`xb2',-`thrho')-`p02';
	quietly gen double `p21' = binormal(-`ek4'+`xb1',`ek3'-`xb2',-`thrho')-`p20';

	quietly gen double `p00all' = binormal(`ek2'-`xb1',`ek2'-`xb2',`thrho');
	quietly gen double `p22all' = binormal(-`ek3'+`xb1',-`ek3'+`xb2',`thrho');

	quietly gen double `pme1' = `p00all' 
						- binormal(`ek2'-`xb1',`ek1'-`xb2',`thrho')
						- binormal(`ek1'-`xb1',`ek2'-`xb2',`thrho')
						+ binormal(`ek1'-`xb1',`ek1'-`xb2',`thrho');

	quietly gen double `pme2' = `p22all' 
						- binormal(-`ek3'+`xb1',-`ek4'+`xb2',`thrho')
						- binormal(-`ek4'+`xb1',-`ek3'+`xb2',`thrho')
						+ binormal(-`ek4'+`xb1',-`ek4'+`xb2',`thrho');

	quietly gen double `p11all' = binormal(`ek4'-`xb1',`ek4'-`xb2',`thrho')
						- `p01' - `p10' - `p00all' + `pme1';

	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
 	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);

	quietly replace `lnf' = ln(`p01') if ($ML_y1==0 & $ML_y2==1); 	
	quietly replace `lnf' = ln(`p10') if ($ML_y1==1 & $ML_y2==0); 

	quietly replace `lnf' = ln(`p12') if ($ML_y1==1 & $ML_y2==2); 	
	quietly replace `lnf' = ln(`p21') if ($ML_y1==2 & $ML_y2==1); 

	quietly replace `lnf' = ln(`p00all'+`p11all'+`p22all'-`pme1'-`pme2') 
		if ($ML_y1==0 & $ML_y2==0)|($ML_y1==1 & $ML_y2==1)|($ML_y1==2 & $ML_y2==2);
end;

*--------------------------------------------------------------------------------------------------;* VERSION 5a: Asymmetric gammas  *--------------------------------------------------------------------------------------------------;#delimit ;
program define bivoprob_v5a;
	
	args lnf xb1 xb2 xb3 xb4 xb5 xb6 k1 k2;	tempvar thrho p02 p20 p01 p10 p12 p21 p00all p22all p11all pme1 pme2 pup 
				ek1 ek2_1 ek2_2 ek3 ek4_1 ek4_2;
	quietly gen `thrho' = 0;	quietly gen `pup'=.5;

	quietly gen `ek1' = `k1';
	quietly gen `ek3' = `k2';

	quietly gen `ek2_1' = `ek1' + exp(`xb3') ;
	quietly gen `ek2_2' = `ek1' + exp(`xb5') ;

	quietly gen `ek4_1' = `ek3' + exp(`xb4');
	quietly gen `ek4_2' = `ek3' + exp(`xb6');

	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek4_2'+`xb2',-`thrho');	quietly gen double `p20' = binormal(-`ek4_1'+`xb1',`ek1'-`xb2',-`thrho');
	quietly gen double `p01' = binormal(`ek1'-`xb1',-`ek2_2'+`xb2',-`thrho')-`p02';
	quietly gen double `p10' = binormal(-`ek2_1'+`xb1',`ek1'-`xb2',-`thrho')-`p20';

	quietly gen double `p12' = binormal(`ek3'-`xb1',-`ek4_2'+`xb2',-`thrho')-`p02';
	quietly gen double `p21' = binormal(-`ek4_1'+`xb1',`ek3'-`xb2',-`thrho')-`p20';

	quietly gen double `p00all' = binormal(`ek2_1'-`xb1',`ek2_2'-`xb2',`thrho');
	quietly gen double `p22all' = binormal(-`ek3'+`xb1',-`ek3'+`xb2',`thrho');

	quietly gen double `pme1' = `p00all' 
						- binormal(`ek2_1'-`xb1',`ek1'-`xb2',`thrho')
						- binormal(`ek1'-`xb1',`ek2_2'-`xb2',`thrho')
						+ binormal(`ek1'-`xb1',`ek1'-`xb2',`thrho');

	quietly gen double `pme2' = `p22all' 
						- binormal(-`ek3'+`xb1',-`ek4_2'+`xb2',`thrho')
						- binormal(-`ek4_1'+`xb1',-`ek3'+`xb2',`thrho')
						+ binormal(-`ek4_1'+`xb1',-`ek4_2'+`xb2',`thrho');

	quietly gen double `p11all' = binormal(`ek4_1'-`xb1',`ek4_2'-`xb2',`thrho')
						- `p01' - `p10' - `p00all' + `pme1';

	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
 	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);

	quietly replace `lnf' = ln(`p01') if ($ML_y1==0 & $ML_y2==1); 	
	quietly replace `lnf' = ln(`p10') if ($ML_y1==1 & $ML_y2==0); 

	quietly replace `lnf' = ln(`p12') if ($ML_y1==1 & $ML_y2==2); 	
	quietly replace `lnf' = ln(`p21') if ($ML_y1==2 & $ML_y2==1); 

	quietly replace `lnf' = ln(`p00all'-`pup'*`pme1') if ($ML_y1==0 & $ML_y2==0);
	quietly replace `lnf' = ln(`p22all'-(1-`pup')*`pme2') if ($ML_y1==2 & $ML_y2==2);
	quietly replace `lnf' = ln(`p11all'-(1-`pup')*`pme1'-`pup'*`pme2') if ($ML_y1==1 & $ML_y2==1); 

end;


*--------------------------------------------------------------------------------------------------;* VERSION 5b: For Reciprocated vs Non-Reciprocated *--------------------------------------------------------------------------------------------------;#delimit ;
program define bivoprob_v5b;
	
	args lnf xb1 xb2 xb3 xb4 g1 g2 k1 dk;	tempvar thrho p02 p20 p01 p10 p12 p21 p00all p22all p11all pme1 pme2 pup 
				ek1 ek2_1 ek2_2 ek3 ek4_1 ek4_2;
	quietly gen `thrho' = 0;	quietly gen `pup'=.5;

	quietly gen `ek1' = `k1';
	quietly gen `ek2_1' = `ek1'+exp(`g1');
	quietly gen `ek3' = `ek2_1'+exp(`dk');
	quietly gen `ek4_1' = `ek3'+exp(`g2');
	quietly gen `ek2_2' = `ek1'+exp(`g1'+`xb3');
	quietly gen `ek4_2' = `ek3'+exp(`g2'+`xb4');
	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek4_2'+`xb2',-`thrho');	quietly gen double `p20' = binormal(-`ek4_1'+`xb1',`ek1'-`xb2',-`thrho');
	quietly gen double `p01' = binormal(`ek1'-`xb1',-`ek2_2'+`xb2',-`thrho')-`p02';
	quietly gen double `p10' = binormal(-`ek2_1'+`xb1',`ek1'-`xb2',-`thrho')-`p20';

	quietly gen double `p12' = binormal(`ek3'-`xb1',-`ek4_2'+`xb2',-`thrho')-`p02';
	quietly gen double `p21' = binormal(-`ek4_1'+`xb1',`ek3'-`xb2',-`thrho')-`p20';

	quietly gen double `p00all' = binormal(`ek2_1'-`xb1',`ek2_2'-`xb2',`thrho');
	quietly gen double `p22all' = binormal(-`ek3'+`xb1',-`ek3'+`xb2',`thrho');

	quietly gen double `pme1' = `p00all' 
						- binormal(`ek2_1'-`xb1',`ek1'-`xb2',`thrho')
						- binormal(`ek1'-`xb1',`ek2_2'-`xb2',`thrho')
						+ binormal(`ek1'-`xb1',`ek1'-`xb2',`thrho');

	quietly gen double `pme2' = `p22all' 
						- binormal(-`ek3'+`xb1',-`ek4_2'+`xb2',`thrho')
						- binormal(-`ek4_1'+`xb1',-`ek3'+`xb2',`thrho')
						+ binormal(-`ek4_1'+`xb1',-`ek4_2'+`xb2',`thrho');

	quietly gen double `p11all' = binormal(`ek4_1'-`xb1',`ek4_2'-`xb2',`thrho')
						- `p01' - `p10' - `p00all' + `pme1';
	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
 	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);

	quietly replace `lnf' = ln(`p01') if ($ML_y1==0 & $ML_y2==1); 	
	quietly replace `lnf' = ln(`p10') if ($ML_y1==1 & $ML_y2==0); 

	quietly replace `lnf' = ln(`p12') if ($ML_y1==1 & $ML_y2==2); 	
	quietly replace `lnf' = ln(`p21') if ($ML_y1==2 & $ML_y2==1); 

	quietly replace `lnf' = ln(`p00all'-`pup'*`pme1') if ($ML_y1==0 & $ML_y2==0);
	quietly replace `lnf' = ln(`p22all'-(1-`pup')*`pme2') if ($ML_y1==2 & $ML_y2==2);
	quietly replace `lnf' = ln(`p11all'-(1-`pup')*`pme1'-`pup'*`pme2') if ($ML_y1==1 & $ML_y2==1); 
end;

*--------------------------------------------------------------------------------------------------* VERSION 6 : Heterogeneous gammas
* Prob High EQU = .5* rho = 0
*--------------------------------------------------------------------------------------------------#delimit ;
program define bivoprob_v6;
	
	args lnf xb1 xb2 xb3 xb4 k1 k2;	tempvar thrho p02 p20 p01 p10 p12 p21 p00all p22all p11all pme1 pme2 pup 
				ek1 ek2 ek3 ek4 ;
	quietly gen `thrho' = 0;
	quietly gen `pup'=.5;
	quietly gen `ek1' = `k1';
	quietly gen `ek2' = `ek1'+exp(`xb3');
	quietly gen `ek3' = `k2';
	quietly gen `ek4' = `ek3'+exp(`xb4');
	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek4'+`xb2',-`thrho');	quietly gen double `p20' = binormal(-`ek4'+`xb1',`ek1'-`xb2',-`thrho');

	quietly gen double `p01' = binormal(`ek1'-`xb1',-`ek2'+`xb2',-`thrho')-`p02';
	quietly gen double `p10' = binormal(-`ek2'+`xb1',`ek1'-`xb2',-`thrho')-`p20';

	quietly gen double `p12' = binormal(`ek3'-`xb1',-`ek4'+`xb2',-`thrho')-`p02';
	quietly gen double `p21' = binormal(-`ek4'+`xb1',`ek3'-`xb2',-`thrho')-`p20';

	quietly gen double `p00all' = binormal(`ek2'-`xb1',`ek2'-`xb2',`thrho');
	quietly gen double `p22all' = binormal(-`ek3'+`xb1',-`ek3'+`xb2',`thrho');

	quietly gen double `pme1' = `p00all' 
						- binormal(`ek2'-`xb1',`ek1'-`xb2',`thrho')
						- binormal(`ek1'-`xb1',`ek2'-`xb2',`thrho')
						+ binormal(`ek1'-`xb1',`ek1'-`xb2',`thrho');

	quietly gen double `pme2' = `p22all' 
						- binormal(-`ek3'+`xb1',-`ek4'+`xb2',`thrho')
						- binormal(-`ek4'+`xb1',-`ek3'+`xb2',`thrho')
						+ binormal(-`ek4'+`xb1',-`ek4'+`xb2',`thrho');

	quietly gen double `p11all' = binormal(`ek4'-`xb1',`ek4'-`xb2',`thrho')
						- `p01' - `p10' - `p00all' + `pme1';

	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
 	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);

	quietly replace `lnf' = ln(`p01') if ($ML_y1==0 & $ML_y2==1); 	
	quietly replace `lnf' = ln(`p10') if ($ML_y1==1 & $ML_y2==0); 

	quietly replace `lnf' = ln(`p12') if ($ML_y1==1 & $ML_y2==2); 	
	quietly replace `lnf' = ln(`p21') if ($ML_y1==2 & $ML_y2==1); 

	quietly replace `lnf' = ln(`p00all'-`pup'*`pme1') if ($ML_y1==0 & $ML_y2==0);
	quietly replace `lnf' = ln(`p22all'-(1-`pup')*`pme2') if ($ML_y1==2 & $ML_y2==2);
	quietly replace `lnf' = ln(`p11all'-(1-`pup')*`pme1'-`pup'*`pme2') if ($ML_y1==1 & $ML_y2==1); 
end;


*--------------------------------------------------------------------------------------------------* VERSION 7 - four shift parameters*--------------------------------------------------------------------------------------------------#delimit ;
program define bivoprob_v7;
	
	args lnf xb1 xb2 k1 dk g11 dg1 g21 dg2 rho;
	tempvar thrho p02 p20 pa pb pc pd pe pf pg ph p00all p22all p11all pme1 pme2 pme3 pme4 
			ek1 ek2 ek3 ek4 ek5 ek6;

	quietly gen `ek1' = `k1';
	quietly gen `ek2' = `ek1' + exp(`dg1');
	quietly gen `ek3' = `ek2' + exp(`g11');
	quietly gen `ek4' = `ek3' + exp(`dk');
	quietly gen `ek5' = `ek4' + exp(`dg2');
	quietly gen `ek6' = `ek5' + exp(`g21');
	quietly gen `thrho' = tanh(`rho');

	quietly gen double `p02' = binormal(`ek1'-`xb1',-`ek6'+`xb2',-`thrho'); 	

	quietly gen double `p20' = binormal(-`ek6'+`xb1',`ek1'-`xb2',-`thrho'); 	
	
	quietly gen double `pa' =  binormal(`ek1'-`xb1',-`ek5'+`xb2',-`thrho') - `p02'; 

	quietly gen double `pf' =  binormal(-`ek5'+`xb1',`ek1'-`xb2',-`thrho') - `p20'; 

	quietly gen double `pb' =  binormal(`ek2'-`xb1',`ek5'-`xb2',`thrho') - binormal(`ek2'-`xb1',`ek3'-`xb2',`thrho'); 

	quietly gen double `pe' =  binormal(`ek5'-`xb1',`ek2'-`xb2',`thrho') - binormal(`ek3'-`xb1',`ek2'-`xb2',`thrho'); 

	quietly gen double `pc' =  binormal(`ek2'-`xb1',-`ek6'+`xb2',-`thrho') - `p02';

	quietly gen double `ph' =  binormal(-`ek6'+`xb1',`ek2'-`xb2',-`thrho') - `p20';

	quietly gen double `pd' = binormal(`ek4'-`xb1',-`ek5'+`xb2',-`thrho') - binormal(`ek2'-`xb1',-`ek5'+`xb2',-`thrho');

	quietly gen double `pg' = binormal(-`ek5'+`xb1',`ek4'-`xb2',-`thrho') - binormal(-`ek5'+`xb1',`ek2'-`xb2',-`thrho');

	quietly gen double `p00all' = binormal(`ek3'-`xb1',`ek3'-`xb2',`thrho');

	quietly gen double `p22all' = binormal(-`ek4'+`xb1',-`ek4'+`xb2',`thrho');

	quietly gen double `pme1' = binormal(`ek3'-`xb1',`ek3'-`xb2',`thrho') 
					 - binormal(`ek3'-`xb1',`ek2'-`xb2',`thrho') 
					 - binormal(`ek2'-`xb1',`ek3'-`xb2',`thrho') 
					 + binormal(`ek2'-`xb1',`ek2'-`xb2',`thrho'); 

	quietly gen double `pme2' = binormal(-`ek4'+`xb1',-`ek4'+`xb2',`thrho') 
					 - binormal(-`ek4'+`xb1',-`ek5'+`xb2',`thrho') 
					 - binormal(-`ek5'+`xb1',-`ek4'+`xb2',`thrho') 
					 + binormal(-`ek5'+`xb1',-`ek5'+`xb2',`thrho'); 

	quietly gen double `pme3' = binormal(`ek2'-`xb1',-`ek5'+`xb2',-`thrho')- `pa' - `pc' - `p02';
	quietly gen double `pme4' = binormal(-`ek5'+`xb1',`ek2'-`xb2',-`thrho')- `pf' - `ph' - `p20';
	quietly gen double `p11all' = binormal(`ek5'-`xb1',`ek5'-`xb2',`thrho') - `p00all' - `pb' - `pe' + `pme1';	
	 	quietly replace `lnf' = ln(`p00all' - .5*`pme1') if ($ML_y1==0 & $ML_y2==0);
	quietly replace `lnf' = ln(`p11all' - .5*`pme1' - .5*`pme2') if ($ML_y1==1 & $ML_y2==1);
	quietly replace `lnf' = ln(`p22all' - .5*`pme2') if ($ML_y1==2 & $ML_y2==2);
	quietly replace `lnf' = ln(`pa' + `pb' + (1-.5)*`pme3') if ($ML_y1==0 & $ML_y2==1);
	quietly replace `lnf' = ln(`pe' + `pf' + (1-.5)*`pme4') if ($ML_y1==1 & $ML_y2==0);
	quietly replace `lnf' = ln(`pc' + `pd' + .5*`pme3') if ($ML_y1==1 & $ML_y2==2);
	quietly replace `lnf' = ln(`pg' + `ph' + .5*`pme4') if ($ML_y1==2 & $ML_y2==1);
	quietly replace `lnf' = ln(`p02') if ($ML_y1==0 & $ML_y2==2);
	quietly replace `lnf' = ln(`p20') if ($ML_y1==2 & $ML_y2==0);
end;







