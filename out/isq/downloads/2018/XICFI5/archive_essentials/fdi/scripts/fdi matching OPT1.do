** 24 Jan 2011.
** Rewards FDI analysis.
** In this file, I start over with the FDI analysis
** I'm using the file "aid matching.do" as a template

/*
Grab treated.
1. Identify episodes of ratification
2. Pull them out as single observations where everything is a lagged covariate or a lead of an outcome.  Make it a single row in a matrix.

Grab controls
3. Identify the observations for countries that haven't yet ratified
4. Split them into chunks that are as long as the treated chunks (including not ratifying a treaty during the outcome period?).  This seems post-treatment, except that since we are not matching exactly on time, then the "post-treatment" period for control chunks is defined arbitrarily.
5. Make the chunks non-overlapping for simplicity.
6. Get the chunks into the right format -- as a single row in a data matrix.

Do the matching
7. Do the matching with CEM.  This way I can directly control how much weight I place on the lagged covariates.  Some covariate lags don't matter (like year) because one value of the covariate completely determines the lags.  Maybe, I should do one-by-one cem as follows.  Take a single treated unit.  Set the covariate widths as calipers around the covariate values for the treated unit.  Match to all control units that fall within the calipers.  Record which units are matched to which, so that we can re-weight the controls properly (if we re-use some of them).
  Or maybe try a more traditional CEM.
  Covariates:
   - Year
   - ratification of other treaties during the period
   - the controls I list in the paper
8. Graphically look at the average outcome trends in the matched sample.
9. Estimate some models predicting the outcomes.  Account for the multiple testing that is induced because we would accept a positive result in a number of time periods surrounding ratification.  Or don't, and just say that we are being generous to the material rewards hypothesis.
10. A big problem is that rewards could have different timing for different states.  But moving to the one row per chunk dataset suggests that we should just combine aid flows in the outcome period.  This gets around timing issue nicely.
*/

** I'm using the dataset "RR fdi data.dta" which is build by the file
** "Master RR build fdi data.do".

capture mkdir "fdi/results"
capture mkdir "fdi/madedata"
capture mkdir "fdi/junk"

log using "fdi/results/fdi_OPT1.smcl", replace

** load this data
clear
set more off

use "fdi/rawdata/RR fdi data.dta" , replace
run "pta/scripts/Standardize Country Names.do"

** There are some duplicate problems
** It looks like trade did not get merged in correctly.
** FIX THIS LATER ***
duplicates tag countryname year, gen(dup)
* edit if dup>0
egen tmp = max(ln_trade), by(countryname year)
replace ln_trade = tmp
drop if dup>0 & ln_rgdpc==.
drop dup tmp


** identify episodes of ratification
gen treat = 0
replace treat = 1 if opt1[_n]==1 & opt1[_n-1]==0 & (countryname[_n]==countryname[_n-1]) & ((year[_n-1]+1)==year[_n])

** treat==1 means that the country ratified in that year

** but if I want to look for aid increases preceding ratification...
gen treat2 = 0
replace treat2 = 1 if treat[_n+1]==1 & (countryname[_n]==countryname[_n+1]) & ((year[_n]+1)==year[_n+1])

** some countries aren't eligable because they didn't exist for 5 years before
gen elig = 0
replace elig = 1 if treat2==1 & (stateinyeart_g[_n-6]==1) & (countryname[_n]==countryname[_n-6])


** now, lag the controls so that I can just pull out the treated chunks
** My specification from APSA was 
** xi: xtreg  fdi2 i.year l.opt1 l.physint l.empinx l.ln_rgdpc l.ln_rgdpc_sq  l.ln_trade  l.polity2  l.durable  l.gdpgrowth  l.exratemdev_80_00  l.gdpdeflator  if OECD!=1, fe

keep if OECD!=1

** These controls don't need lags: year
local controls fdiin physint empinx ln_rgdpc ln_rgdpc_sq  ln_trade  polity2  durable  gdpgrowth  exratemdev_80_00  gdpdeflator  
foreach V of local controls {
  foreach i of numlist 1/5 {
    di "`V'"`i'
    gen l`i'`V' = l`i'.`V'
  }
}

** make leads of the outcome
local leads fdiin gdpcurrent
foreach V of local leads {
  foreach i of numlist 1/5 {
    di "`V'"`i'
    gen f`i'`V' = f`i'.`V'
  }
}


save "fdi/junk/all.dta", replace



** keep only the treated units
keep if elig==1

local keepme countryname year f1* f2* f3* f4* f5* l1* l2* l3* l4* l5* year ///
      physint empinx ln_rgdpc ln_rgdpc_sq  ln_trade  polity2  durable  gdpgrowth  exratemdev_80_00  gdpdeflator ///
      fdiin gdpcurrent

keep `keepme'

gen treated = 1
save "fdi/junk/treated.dta", replace


** find control chunks
use "fdi/junk/all.dta", clear

** first, rule out all the observations I can't use
gen dropme = 0
replace dropme = 1 if opt1==1
foreach i of numlist 1/6 {
  replace dropme = 1 if opt1[_n+`i']==1 & (countryname[_n]==countryname[_n+`i']) & (year[_n]+`i'==year[_n+`i'])
}

** keep only the eligible control chunks
drop if dropme==1

** this macro is defined above
keep `keepme'

gen treated = 0
save "fdi/junk/control.dta", replace

** append the treated
append using "fdi/junk/treated.dta"

** make a few aid outcome variables
gen fdi012 = fdiin + f1fdiin + f2fdiin
gen fdi123 = f1fdiin + f2fdiin + f3fdiin
gen fdi012345 = fdiin + f1fdiin + f2fdiin + f3fdiin + f4fdiin + f5fdiin

gen gdp012 = gdpcurrent + f1gdpcurrent + f2gdpcurrent
gen gdp123 = f1gdpcurrent + f2gdpcurrent + f3gdpcurrent
gen gdp012345 = gdpcurrent + f1gdpcurrent + f2gdpcurrent + f3gdpcurrent + f4gdpcurrent + f5gdpcurrent

** ratio of gdp outcome
gen fdigdp012345 = fdi012345/gdp012345
gen fdigdp012 = fdi012/gdp012
gen fdigdp123 = fdi123/gdp123

gen fdibil012345 = fdi012345/1000000000
gen fdibil012 = fdi012/1000000000
gen fdibil123 = fdi123/1000000000

gen lnfdi012345 = log(fdi012345 + 1)
gen lnfdi012 = log(fdi012 + 1)
gen lnfdi123 = log(fdi123 + 1)

gen lnfdibil012345 = log(fdibil012345 + 1)
gen lnfdibil012 = log(fdibil012 + 1)
gen lnfdibil123 = log(fdibil123 + 1)



save "fdi/madedata/alldata.dta", replace


** Move to R to do the matching

########################################
## R code


library(foreign)
dat <- read.dta("fdi/madedata/alldata.dta", convert.underscore=T)


head(dat)

dim(dat)
table(dat$treated)

  ## Not all of the observations have all of the lags and leads
dim(na.omit(dat))
table(na.omit(dat)$treated)

## We are losing a ton of observations by dropping everything that doesn't
## have the lags.  But I'm not using the lags for the matching.

## this is the matching formula
ftmp <- "treated ~ year +"

## pull out all the l1vars
l1vars <- c()
for(i in 1:ncol(dat)){
  if(length(grep("l1",names(dat)[i]))>0){
    l1vars <- c(l1vars,names(dat)[i])
  }
}

## 24 may 2012 -- switched from controlling for "fdi2" to "fdiin" but 
##   "l1fdiin" crashes MDM as colinear, so I don't match on it here.
l1vars <- l1vars[-which(l1vars=="l1fdiin")]

ftmp1 <- as.formula(paste(ftmp, "+",paste(l1vars,collapse=" + ")))
## add the outcome variable so we can na.omit the data
l1vars <- c(l1vars,"fdi012345")
ftmp2 <- as.formula(paste(ftmp, "+",paste(l1vars,collapse=" + ")))

ftmp2
names(na.omit(model.frame(ftmp2, dat)))
table(na.omit(model.frame(ftmp2, dat))$treated)
  ## grab these observations to do the na.omit
mframe <- rownames(na.omit(model.frame(ftmp2, dat)))

#dat <- na.omit(dat)
dat <- dat[mframe,]


## compare treated to untreated
t.means <- apply(model.frame(ftmp1, dat[dat$treated==1,]), MAR=2,FUN=mean)
c.means <- apply(model.frame(ftmp1, dat[dat$treated==0,]), MAR=2,FUN=mean)

t.means-c.means

## make a figure showing the differences
#pdf("OPT1diffsFDI.pdf")
par(mar=c(5,10,5,1))
plot(t.means-c.means,rev(1:length(t.means)),
     type="n", ylab="",xlab="mean(T) - mean(C)",
     axes=F,
     ylim=c(0,13), main="OPT1")
abline(h=rev(1:length(t.means)), col="gray85")
abline(v=0,lty=2)
points(t.means-c.means,rev(1:length(t.means)),
       col= as.numeric(t.means-c.means>0)+1, pch=20)
axis(1)
axis(2,at=rev(1:length(t.means))[which(t.means-c.means>0)],
     names(t.means)[which(t.means-c.means>0)],las=2, 
     col.axis="red")
axis(2,at=rev(1:length(t.means))[which(t.means-c.means<=0)],
     names(t.means)[which(t.means-c.means<=0)],las=2, 
     col.axis="black")
dev.off()
## End of figure


  ## a mahalanobis function
  ## myMH function from http://www.stat.lsa.umich.edu/~bbh/optmatch/doc/mahalanobisMatching.pdf

  ## the second stopifnot condition was in ben hansen's code
  ## but the code seems to work fine for even one variable
  ## and I have samples with just one covariate.
myMH <- function(Tnms, Cnms, inv.cov, data) {
 stopifnot(!is.null(dimnames(inv.cov)[[1]]),# dim(inv.cov)[1] > 1,
 all.equal(dimnames(inv.cov)[[1]], dimnames(inv.cov)[[2]]),
 all(dimnames(inv.cov)[[1]] %in% names(data)))
 covars <- dimnames(inv.cov)[[1]]
 xdiffs <- as.matrix(data[Tnms, covars])
 xdiffs <- xdiffs - as.matrix(data[Cnms, covars])
 rowSums((xdiffs %*% inv.cov) * xdiffs)
}


  ## This is the FAST m-dist function for large data
myMH4 <- function(Tnms, Cnms, inv.cov, data,k){
    ## the basic idea now is that we do the distance calculation
    ## and matching all in one step, so that we don't have to
    ## make a huge distance matrix and then cycle through it.
    ## This also means that as we get fewer and fewer available
    ## control units, the distance calculation should get faster.
  icv <- inv.cov
  mdist <- matrix(NA,length(Tnms),length(Cnms))
  ixnay <- c()
  t0 <- Sys.time()
    ## make some holders
  match.matrix <- matrix(NA, length(Tnms), k)
  rownames(match.matrix) <- Tnms
  dist.matrix <- match.matrix
    ## loop over the match ratio
  for(j in 1:k){
      ## loop over the treated units
    for(i in 1:length(Tnms)){
      if(i%%100==0){
        print(paste("Match",j,"of",k,", T",i,"of",length(Tnms),":",round(Sys.time()-t0,2)))
      }
        ## define a vector of the Cnms that are still available
      elig <- Cnms[(Cnms%in%ixnay)==F]
      #if(i%%500==0){print(paste("treated unit",i,"of",length(Tnms)))}
        ## make the distance vector for treated t and all the eligable
        ## controls
      x <- outer(Tnms[i], elig, FUN = myMH, inv.cov = icv, data = data)
        ## capture the colnames of the ones that have
        ## minimum distances and take the first
      min.x <- min(x)
      m <- (elig[(x==min.x)==T])[1]
        ## add the things to the output matrices
      match.matrix[i,j] <- m
      dist.matrix[i,j] <- min.x
        ## add the new match to ixnay
      ixnay <- c(ixnay, m)
        ## stop the iterations if there are no more control units
      if(length(ixnay)==length(Cnms)){break}
    }
    ## stop the iterations if there are no more control units
    if(length(ixnay)==length(Cnms)){break}
  }
  return(list("match.matrix"=match.matrix,
              "dist.matrix"=dist.matrix))
}


  
mhmatch <- function(formula, data, ratio=1){

  ## I think this function has a dependence on "tvar"

    ## pull out the covariates
  X1 <- data
  X2 <- data.frame(model.frame(formula, data))
  tvar <- as.character(formula)[2]
    ## just the covariates
  X3 <- subset(data.frame(model.matrix(formula,data)),select=-1)
  mvrs <- colnames(X3)
    ## covariates and treatment variable
  X <- cbind(X2[,1],X3)
  names(X) <- c(tvar,mvrs)

    ## set the number of matches, 1-to-k
  k <- ratio

    ## if it can't invert, this is where it will fail
  try(icv <- solve(cov(subset(X,select=mvrs))))
  #if(exists("icv")==F){
  #  stop
  #  print("VCOV matrix can't invert with these covariates")
  #}
  stopifnot(exists("icv"))
  trtnms <- row.names(X)[X[[tvar]]==1]
  ctlnms <- row.names(X)[X[[tvar]]==0]
    ## use the data X3 that has just the covariates

    ## run the main internal function
  try(mydist <- myMH4(trtnms, ctlnms, inv.cov=icv, data=X3,k=k))
  stopifnot(exists("mydist"))
  match.matrix <- mydist$match.matrix
  dist.matrix <- mydist$dist.matrix

  ## make the matched data
    ## first, select all the treated obs
  mh.data <- data[rownames(match.matrix)[is.na(match.matrix[,1])==F],]
    ## then add the control obs
  for(i in 1:ncol(match.matrix)){
    mh.data <- rbind(mh.data,data[na.omit(match.matrix[,i]),])
  }

  ## PROBLEM HERE WITH THE DISTANCES -- NEED TO GET THIS RIGHT

  ## add distances -- mean of all distances for a matched group
  dd <- apply(dist.matrix, MAR=1, mean, na.rm=T)
  distance <- matrix(NA,nrow(mh.data),1)
  rownames(distance) <- rownames(mh.data)
  distance[names(na.omit(dist.matrix[,1])),] <- dd[names(na.omit(dist.matrix[,1]))]
  for(i in 1:ncol(dist.matrix)){
    names(dd) <- match.matrix[,i]
    distance[na.omit(match.matrix[,i]),] <- dd[na.omit(match.matrix[,i])]
  }
  mh.data$distance <- distance

    ## add weights to the data
  weights <- matrix(NA,nrow(mh.data),1)
  rownames(weights) <- rownames(mh.data)
  weights[names(na.omit(match.matrix[,1])),]<-1
    ## calculate the weights
  countf <- function(x){sum(is.na(x))}
  wts <- 1/(k-apply(match.matrix, MAR=1, countf))
    ## fill in the weights
    ## this has me all mixed up, but I think it works
  for(i in 1:ncol(dist.matrix)){
    names(wts) <- match.matrix[,i]
    weights[na.omit(match.matrix[,i]),] <-wts[na.omit(match.matrix[,i])]
  }
  mh.data$weights <- weights

  
    ## RETURN
  return(list("match.matrix"=match.matrix, "dist.matrix"=dist.matrix,
              "match.dat"=mh.data))
}

## End of mahalanobis function

ftmp <- ftmp1

set.seed(1234)
mout <- mhmatch(ftmp, data = dat)

cbind(mout$dist.matrix,as.numeric(mout$match.matrix))
  ## these are the matches that have distances
  ## greater than 10
bad <- cbind(mout$dist.matrix,as.numeric(mout$match.matrix))[mout$dist.matrix[,1]>10,]

## These are the matches
cbind(dat[rownames(bad),1:2],dat[as.character(bad[,2]),1:2], bad[,1])

## Make a calipered matched dataset
dropme <- which(rownames(mout$match.dat)%in%(c(rownames(bad),as.character(bad[,2]))))
cdat <- mout$match.dat[-dropme,]

## I'm writing out the full matched dataset
library(foreign)
#write.dta(mout$match.dat,"fdi/madedata/mahmatches.dta")

#write.dta(cdat,"fdi/madedata/mahmatchescaliper.dta")


## This is my attempt to do unlimited caliper matching with mah distance
## Based on the one-to-one matching, it looks like I want a caliper of
## 10 or so.

data <- dat

formula <- ftmp1

## This is modified code that started as part of the "mhmatch" function
  ## pull out the covariates
X1 <- data
X2 <- data.frame(model.frame(formula, data))
tvar <- as.character(formula)[2]
  ## just the covariates
X3 <- subset(data.frame(model.matrix(formula,data)),select=-1)
mvrs <- colnames(X3)
  ## covariates and treatment variable
X <- cbind(X2[,1],X3)
names(X) <- c(tvar,mvrs)
  ## make the vcov matrix
try(icv <- solve(cov(subset(X,select=mvrs))))
  ## get the treated names and control names
trtnms <- row.names(X)[X[[tvar]]==1]
ctlnms <- row.names(X)[X[[tvar]]==0]
  ## use the data X3 that has just the covariates

  ## make the mah dist matrix
dmatrix <- outer(trtnms, ctlnms, FUN = myMH, inv.cov = icv, data = X3)
  ## this function doesn't put names on the distance matrix
  ## so I do it now
rownames(dmatrix) <- trtnms
colnames(dmatrix) <- ctlnms
  ## for each treated unit, grab only the control units
  ## that fall within the caliper.  I could use this to 
  ## see which units are matched to which and what the average
  ## distance was.
mlist1 <- list()
mlist2 <- list()
for(i in 1:nrow(dmatrix)){
  trtunit <- rownames(dmatrix)[i]  
  mlist1[[i]] <- trtunit
  mlist2[[i]] <- dmatrix[i,][dmatrix[i,]<=10]  ## THIS IS THE CALIPER!!!
} 

  ## look at the matches for each treated unit
  ## This prints the treated country and all of its matches
for(i in 1:length(mlist2)){
  print("********")
  print(dat[mlist1[[i]],c(1,2)])
  print("----->")
  print(cbind(dat[names(mlist2[[i]]),c(1,2)],mlist2[[i]]))
}

  ## make an index of the treated units that have at least one match
matches.found <- c()
for(i in 1:length(mlist2)){
  matches.found[i] <- as.numeric(length(mlist2[[i]]) > 0)
}

  ## grab only the treated units that have matched controls and the
  ## control units
t.units <- unlist(mlist1)[matches.found==1]
c.units <- unique(names(unlist(mlist2)))

keepme <- c(t.units,c.units)

write.dta(dat[keepme,], "fdi/madedata/mdat.dta")


#####################################################



** The matching I like best -- all units within a given caliper

use "fdi/madedata/mdat.dta", clear

egen countrynum = group(countryname)
xtset countrynum


xtreg lnfdi012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re
outreg2 using "fdi/results/fdi table.doc", word append
table treated if e(sample)==1


** other outcomes
xtreg fdigdp012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re

xtreg fdibil012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re

xtreg lnfdibil012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re


  ** a fixed effects model
areg fdi012345 treated l1* l2* l3* l4* l5*, a(countryname)


** 21 May 2012 -- Additional robustness checks
use "fdi/madedata/mdat.dta", clear
egen countrynum = group(countryname)
xtset countrynum

** Original Models
xtreg lnfdi012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg lnfdi012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg lnfdi123 treated l1* l2* l3* l4* l5*, cluster(countryname) re

** No controls
reg lnfdi012345 treated, cluster(countryname)
reg lnfdi012 treated, cluster(countryname)
reg lnfdi123 treated, cluster(countryname)


** Fixed effects
areg lnfdi012345 treated l1* l2* l3* l4* l5*, a(countryname)
areg lnfdi012 treated l1* l2* l3* l4* l5*, a(countryname)
areg lnfdi123 treated l1* l2* l3* l4* l5*, a(countryname)


** other outcome variable
xtreg fdigdp012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg fdigdp012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg fdigdp123 treated l1* l2* l3* l4* l5*, cluster(countryname) re

xtreg fdibil012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg fdibil012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg fdibil123 treated l1* l2* l3* l4* l5*, cluster(countryname) re

xtreg lnfdibil012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg lnfdibil012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg lnfdibil123 treated l1* l2* l3* l4* l5*, cluster(countryname) re


** look at differenced fdi, rather than levels

gen difffdi01234 = (fdiin + f1fdiin + f2fdiin + f3fdiin + f4fdiin) - (l1fdiin + l2fdiin + l3fdiin + l4fdiin + l5fdiin)
gen difffdi012 = (fdiin + f1fdiin + f2fdiin) - (l1fdiin + l2fdiin + l3fdiin)
gen difffdi123 = (f1fdiin + f2fdiin + f3fdiin) - (fdiin + l1fdiin + l2fdiin)

xtreg difffdi01234 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg difffdi012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg difffdi123 treated l1* l2* l3* l4* l5*, cluster(countryname) re

  ** maybe controlling for past fdi levels is bad here
drop l1fdiin l2fdiin l3fdiin l4fdiin l5fdiin 

xtreg difffdi01234 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg difffdi012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg difffdi123 treated l1* l2* l3* l4* l5*, cluster(countryname) re

use "fdi/madedata/mdat.dta", clear
egen countrynum = group(countryname)
xtset countrynum



** run the model without chunks -- country year observations

  ** year before ratification
xtreg fdiin treated l1*, cluster(countryname) re
gen lnfdiin = log(fdiin + 1)
xtreg lnfdiin treated l1*, cluster(countryname) re

  ** year of ratification
xtreg f1fdiin treated fdiin physint empinx ln_rgdpc ln_rgdpc_sq ln_trade polity2 durable gdpgrowth  exratemdev_80_00 gdpdeflator, cluster(countryname) re
gen lnf1fdiin = log(f1fdiin + 1)
xtreg lnf1fdiin treated fdiin physint empinx ln_rgdpc ln_rgdpc_sq ln_trade polity2 durable gdpgrowth  exratemdev_80_00 gdpdeflator, cluster(countryname) re

** Look at fdi bumps preceeding ratification
gen fdi21012 = l2fdiin + l1fdiin + fdiin + f1fdiin + f2fdiin
gen fdi210 = l2fdiin + l1fdiin + fdiin
drop l2fdiin l1fdiin

gen lnfdi21012 = log(fdi21012 + 1)
gen lnfdi210 = log(fdi210 + 1)

xtreg fdi21012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg fdi210 treated l1* l2* l3* l4* l5*, cluster(countryname) re

xtreg lnfdi21012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg lnfdi210 treated l1* l2* l3* l4* l5*, cluster(countryname) re




** Models without the matching
use "fdi/madedata/alldata.dta", clear
egen countrynum = group(countryname)
di _N
xtset countrynum

** Original Models
xtreg lnfdi012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg lnfdi012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg lnfdi123 treated l1* l2* l3* l4* l5*, cluster(countryname) re

** No controls
reg lnfdi012345 treated, cluster(countryname)
reg lnfdi012 treated, cluster(countryname)
reg lnfdi123 treated, cluster(countryname)

** Fixed effects
areg lnfdi012345 treated l1* l2* l3* l4* l5*, a(countryname)
areg lnfdi012 treated l1* l2* l3* l4* l5*, a(countryname)
areg lnfdi123 treated l1* l2* l3* l4* l5*, a(countryname)


** other outcome variable
xtreg fdigdp012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg fdigdp012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg fdigdp123 treated l1* l2* l3* l4* l5*, cluster(countryname) re

xtreg fdibil012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg fdibil012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg fdibil123 treated l1* l2* l3* l4* l5*, cluster(countryname) re

xtreg lnfdibil012345 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg lnfdibil012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg lnfdibil123 treated l1* l2* l3* l4* l5*, cluster(countryname) re


** look at differenced fdi, rather than levels

gen difffdi01234 = (fdiin + f1fdiin + f2fdiin + f3fdiin + f4fdiin) - (l1fdiin + l2fdiin + l3fdiin + l4fdiin + l5fdiin)
gen difffdi012 = (fdiin + f1fdiin + f2fdiin) - (l1fdiin + l2fdiin + l3fdiin)
gen difffdi123 = (f1fdiin + f2fdiin + f3fdiin) - (fdiin + l1fdiin + l2fdiin)

xtreg difffdi01234 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg difffdi012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg difffdi123 treated l1* l2* l3* l4* l5*, cluster(countryname) re

  ** maybe controlling for past fdi levels is bad here
drop l1fdiin l2fdiin l3fdiin l4fdiin l5fdiin 

xtreg difffdi01234 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg difffdi012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg difffdi123 treated l1* l2* l3* l4* l5*, cluster(countryname) re

use "fdi/madedata/alldata.dta", clear
egen countrynum = group(countryname)
di _N
xtset countrynum



** run the model without chunks -- country year observations

  ** year before ratification
xtreg fdiin treated l1*, cluster(countryname) re
gen lnfdiin = log(fdiin + 1)
xtreg lnfdiin treated l1*, cluster(countryname) re

  ** year of ratification
xtreg f1fdiin treated fdiin physint empinx ln_rgdpc ln_rgdpc_sq ln_trade polity2 durable gdpgrowth  exratemdev_80_00 gdpdeflator, cluster(countryname) re
gen lnf1fdiin = log(f1fdiin + 1)
xtreg lnf1fdiin treated fdiin physint empinx ln_rgdpc ln_rgdpc_sq ln_trade polity2 durable gdpgrowth  exratemdev_80_00 gdpdeflator, cluster(countryname) re

** Look at fdi bumps preceeding ratification
gen fdi21012 = l2fdiin + l1fdiin + fdiin + f1fdiin + f2fdiin
gen fdi210 = l2fdiin + l1fdiin + fdiin
drop l2fdiin l1fdiin

gen lnfdi21012 = log(fdi21012 + 1)
gen lnfdi210 = log(fdi210 + 1)

xtreg fdi21012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg fdi210 treated l1* l2* l3* l4* l5*, cluster(countryname) re

xtreg lnfdi21012 treated l1* l2* l3* l4* l5*, cluster(countryname) re
xtreg lnfdi210 treated l1* l2* l3* l4* l5*, cluster(countryname) re

log close
