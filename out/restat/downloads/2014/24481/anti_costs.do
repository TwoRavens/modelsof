
/*bertrand first order conditions for logit demand.  
s a number of brands x 1 vector of pre-merger volume shares 
p a nbrnds x 1 vector of pre-merger prices
b is a scalar price coefficient from the logit model.  It is the marginal utility of income (a positive number).
e is the "aggregate elasticity of demand for inside goods".  It should be positive.
preM is a nbrands x nbrands matrix of dummies, with 1's on the diagonal and entry (i,j) equal to 1 if brands i and j are 
produced by the same firm pre-merger.
postM is a nbrands x nbrands matrix of dummies, with 1's on the diagonal and entry (i,j) equal to 1 if brands i and j are 
produced by the same firm post-merger.
Reference is Werden and Froeb "The Effects of Mergers in Differentiated Products Industries: Logit Demand and Merger Policy", 
JLEO, V10 N2*/

mata
function anti_costs(s,p,b,e,preM)
{
    /*create intercepts such that premerger prices predict pre-merger shares perfectly (won't always use sample means, so this is necessary*/
    n=rows(s)
    c=J(n+1,1,0)
    pbar=s'*p
    prn=e/(b*pbar)
    pr=J(n+1,1,0)
    pr[n+1,1]=prn
    for(i=1;i<=n;i++){
        pr[i,1]=s[i,1]*(1-prn)
    }
    cept=J(n+1,1,0)
    /*arbitrarily set intercept of outside option equal to 1*/	
    cept[n+1,1]=1
    for(i=1;i<=n;i++){
        cept[i,1]=cept[n+1,1]+b*p[i,1]+ln(pr[i,1]/prn)
    }
    for(i=1;i<=n;i++){
        c[i,1]=p[i,1]-pbar*1/(b*pbar*(1-s[i,1])+e*s[i,1])
    }	

    for(i=1;i<=n;i++){
        c[i,1]=p[i,1]-pbar*1/(b*pbar*(1-preM[i,.]*s[.,1])+e*preM[i,.]*s[.,1])
    }	
return(c[1..n,1])
}
end
