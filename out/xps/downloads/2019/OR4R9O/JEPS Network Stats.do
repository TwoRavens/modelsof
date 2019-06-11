/*To Calculate Network Stats for the analyses in "Coordination, Communication and Information"
Place the following files: mixture.txt; 2leaders.txt; dis2leaders.txt; 
noleader.txt; star.txt into the same folder as this .do file */

/*For these commands to work the nwcommands package must be installed in STATA. 
Instructions  to do so can be found here: https://nwcommands.wordpress.com/installation/ */


// Load each network matrix in to STATA
nwimport star.txt, type(matrix)
nwimport noleader.txt, type(matrix)
nwimport mixture.txt, type(matrix)
nwimport dis2leaders.txt, type(matrix)
nwimport 2leaders.txt, type(matrix)

//compute network statistics of number edges & degree centralization
nwsummarize star, detail
nwsummarize noleader, detail 
nwsummarize mixture, detail 
nwsummarize dis2leaders, detail 
nwsummarize _2leaders, detail

//compute betweenness centrality
nwbetween star, standardize
nwbetween noleader, standardize 
nwbetween mixture , standardize
nwbetween dis2leaders , standardize
nwbetween _2leaders, standardize

//compute network clustering coefficient
nwclustering star 
nwclustering noleader 
nwclustering mixture 
nwclustering dis2leaders 
nwclustering _2leaders

// Computer degree variance, example for Star Network 
nwdegree star, generate(_degree)
sum _degree, detail

// Take the reported variance and multiple by 15/16 to account for the
// fact that STATA computes the sample variance and we used the population 
//example below is for the Star network

