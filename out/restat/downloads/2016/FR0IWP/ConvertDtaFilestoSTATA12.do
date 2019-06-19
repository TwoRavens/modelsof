#delimit ;
set more off;

/*NOTE: For a Mac, file path names use a forward slash (/) but for 
PC's they require a backward slash (\). Make these changes below 
if necessary depending on your computer type. 
*/

*Dropbox paths by user;
if c(username)=="shayaksarkar" {;
	local path "/Users/shayaksarkar/Desktop/ReStat_Data_Publication/dta/STATA12versions";
};


*This do file with run all the do files at once;
cd `path';


/*Run all tables at once*/;
foreach dtafile in agentsurvey competition disclosure sophistication {;
cd `path';
use final_`dtafile'.dta, replace;
saveold final_`dtafile'.dta, version(12) replace;
};
