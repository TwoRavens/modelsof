**Replication File for Kimball, A.L. "Political Survival, Policy Distribution & Alliance Formation"

set mem 350m
use "Political Survival & Alliance Formation Data"

*This base data file includes all variables used in the published analyses and they variables used to create them.
*Time splines and alliance years were calculated based on the AF_new variable

sum AF_new  IMRlevel IncDmdIMR cap sumrival1 WoverS1 allyrs _spline1 _spline2 _spline3

**Model Replications
*Table 1 Model 1A
probit  AF_new  IMRlevel cap sumrival1 WoverS1 allyrs _spline1 _spline2 _spline3 , robust
*T1M1B
probit  AF_new  IMRlevel cap sumrival1 WoverS1 allyrs _spline1 _spline2 _spline3 if year>1899, robust
*T1M2A
probit  AF_new  IMRlevel IncDmdIMR cap sumrival1 WoverS1 allyrs _spline1 _spline2 _spline3 , robust
*T1M2B
probit  AF_new  IMRlevel IncDmdIMR cap sumrival1 WoverS1 allyrs _spline1 _spline2 _spline3 if year>1899, robust

*Table 2 Model 1A
probit  AF_new  IMRlevel cap sumrival1 WoverS1 envmids1 allyrs _spline1 _spline2 _spline3 , robust
*T2M1B
probit  AF_new  IMRlevel cap sumrival1 WoverS1 envmids1 allyrs _spline1 _spline2 _spline3 if year>1899, robust
*T2M2A
probit  AF_new  IMRlevel IncDmdIMR cap sumrival1 envmids1 WoverS1 allyrs _spline1 _spline2 _spline3 , robust
*T2M2B
probit  AF_new  IMRlevel IncDmdIMR cap sumrival1 envmids1 WoverS1 allyrs _spline1 _spline2 _spline3 if year>1899, robust
