#delim;
qui {;
pause on;
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*Oct-15-2009*/ 
/*fills up gaps at prespecified aggregation levels*/
/*there must be at least 1 obs in every $yr by $ind*/
/*Reason: It may be that there is not exiter or entrant in an
industry but there is at least one in another. The current 
code writes the component value to the en/ex observation only
even though it is valid for other  industries as we aggregate 
up to overall manufacturing. Therefore we need to look for every
year-ind observation in the current setup*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/

tab $yr, matrow($yr);   loc ryr=rowsof($yr);
tab $ind, matrow($ind); loc rind=rowsof($ind);
local mylist "$filluplist";

foreach var of local mylist{;
	preserve;
		noi collapse (mean) "`var'", by($yr);
		mkmat _all, mat(X);
	restore;
	loc rX=rowsof(X);
	if "`ryr'"!="`rX'" {;
		"ERROR: some years are missing";
		break;
	};
	*noi matrix list X;
	
	forvalues num1=1/`ryr'{;
		loc n2 = $yr[`num1',1];
		forvalues num2=1/`rX'{;
			loc n3=X[`num2',1];
			if "`n2'" == "`n3'" {;
				replace `var'=X[`num2',2] if $yr==`n2';
				break;
			};
		};		
	};
};


}; /*end of qui block*/
