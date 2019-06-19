#delimit ;
set more off;

/*NOTE: For a Mac, file path names use a forward slash (/) but for 
PC's they require a backward slash (\). Make these changes below 
if necessary depending on your computer type. 
*/

*Dropbox paths by user;
if c(username)=="shayaksarkar" {;
	local path "/Users/shayaksarkar/Desktop/ReStat_Data_Publication/do";
};


*This do file with run all the do files at once;
cd `path';


/*Run all tables at once*/;
foreach dofile in 1 2 3 4 5 6 A3 A4 A5 A6 {;
cd `path';
do table`dofile'.do;
};

/*Run all figures at once*/
foreach dofile in 1 2 A1 {;
cd `path';
do figure`dofile'.do;
};
