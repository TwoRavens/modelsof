capture prog drop DRDpvalue
program DRDpvalue

version 13
tempname pvalue
if (side==2){
scalar pvalue=0
forval seq = 1/200{
scalar pvalue=pvalue+2*((-1)^(`seq'-1)*exp(-2*`seq'^2*ksstat^2))
} 
}
else if (side==1){
scalar pvalue=exp(-2*ksstat^2)	
} 
else {
display "side must be 1 or 2"
}
display "P-value=" pvalue

end
