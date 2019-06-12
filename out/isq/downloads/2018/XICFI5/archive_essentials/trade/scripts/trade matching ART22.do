

** 19 Jan 2011.
** In this file, I start over with the trade analysis
** This file starts on the RCE because the data are too big

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

** THIS IS ON THE RCE

** Get the dyadic data
clear
clear matrix
set more off


capture mkdir "trade/results"
capture mkdir "trade/madedata"
capture mkdir "trade/junk"


use "trade/rawdata/trade rewards.dta", clear



** unlog the outcome for now
gen  eimports = exp(imports)


** identify episodes of ratification
gen treat = 0 
replace treat = 1 if art22name_2[_n]==1 & art22name_2[_n-1]==0 & (name_1[_n]==name_1[_n-1]) & (name_2[_n]==name_2[_n-1]) & ((year[_n-1]+1)==year[_n])

** treat==1 means that the country ratified in that year

** but if I want to look for aid increases preceding ratification...
gen treat2 = 0
replace treat2 = 1 if treat[_n+1]==1 & (name_1[_n]==name_1[_n-1]) & (name_2[_n]==name_2[_n-1])  & ((year[_n]+1)==year[_n+1])

** some countries aren't eligable because they didn't exist for 5 years before
gen elig = 0
replace elig = 1 if treat2==1 & (stateinyeart_g[_n-6]==1) & (name_1[_n]==name_1[_n-1]) & (name_2[_n]==name_2[_n-1]) 


** now, lag the controls so that I can just pull out the treated chunks
** My specification from APSA was 
** xi: areg imports i.year art22name_2 physint1 empinx1 gattFF gattFO ptarecip ptanonrecip gsp currencyunion colorbit gdp distance share_language share_border landlocked island land_area if OECD==1 & OECDname2==0, absorb(directed_dyad_id) cluster(directed_dyad_id) robust

** There is some problem tsseting it because some dyads are missing a
** dyad id number
** For the moment, I'm just dropping them
egen directed_dyad_id_tmp = max(directed_dyad_id), by(name_1 name_2)
replace directed_dyad_id = directed_dyad_id_tmp
drop if directed_dyad_id==.

tsset directed_dyad_id year

local controls imports art22name_2 physint1 empinx1 gattFF gattFO ptarecip ptanonrecip gsp currencyunion colorbit gdp distance share_language share_border landlocked island land_area 

foreach V of local controls {
  foreach i of numlist 1/5 {
    di "`V'"`i'
    gen l`i'`V' = l`i'.`V'
  }
}

** make leads of the outcome
local leads eimports
foreach V of local leads {
  foreach i of numlist 1/5 {
    di "`V'"`i'
    gen f`i'`V' = f`i'.`V'
  }
}

** keep only the treated units

local keepme name_1 name_2 directed_dyad_id year f1* f2* f3* f4* f5* l1* l2* l3* l4* l5*  ///
             imports art22name_2 physint1 empinx1 gattFF gattFO ptarecip ptanonrecip gsp currencyunion colorbit gdp distance share_language share_border landlocked island land_area ///
             elig art22name_1 eimports

keep `keepme'

compress
save "trade/junk/tradetmp.dta", replace

keep if elig==1

gen treated = 1
save "trade/junk/treated.dta", replace



** find control chunks
use "trade/junk/tradetmp.dta", clear

** first, rule out all the observations I can't use
gen dropme = 0
replace dropme = 1 if art22name_2==1
foreach i of numlist 1/6 {
  replace dropme = 1 if art22name_2[_n+`i']==1 & (name_1[_n]==name_1[_n+`i']) & (name_2[_n]==name_2[_n+`i']) & (year[_n]+`i'==year[_n+`i'])
}

** keep only the eligible control chunks
drop if dropme==1

** this macro is defined above
keep `keepme'

gen treated = 0
save "trade/junk/control.dta", replace

** append the treated
append using "trade/junk/treated.dta"


** make a few aid outcome variables
gen imports012 = eimports + f1eimports + f2eimports
gen imports123 = f1eimports + f2eimports + f3eimports
gen imports012345 = eimports + f1eimports + f2eimports + f3eimports + f4eimports + f5eimports

replace imports012 = log(imports012)
replace imports123 = log(imports123)
replace imports012345 = log(imports012345)

** We need to make some quick fixes to the data first
/*  This adds an OECD variable, as defined by the World Bank, 2006 */
gen OECD=1 if name_1=="United States of America" | name_1=="Austria" | name_1=="Belgium" | name_1=="Canada" | name_1=="Denmark" | name_1=="France" | name_1=="German Federal Republic" | name_1=="Greece" | name_1=="Iceland" | name_1=="Ireland" | name_1=="Italy/Sardinia" | name_1=="Luxembourg" | name_1=="Netherlands" | name_1=="Norway" | name_1=="Portugal" | name_1=="Spain" | name_1=="Sweden" | name_1=="Switzerland" | name_1=="United Kingdom"
replace OECD=1 if name_1=="Japan" | name_1=="Finland" | name_1=="Australia" | name_1=="New Zealand"
replace OECD=1 if name_1=="Germany West (1945-1990)" | name_1=="Germany (1991+)"
/*Not sure about these ones--these are the new members?*/
*replace OECD=1 if name_1=="Turkey/Ottoman Empire" | name_1=="Mexico" | name_1=="Czech Republic"  | name_1=="Hungary" | name_1=="Poland" | name_1=="Korea, Republic of" | name_1=="Slovakia"
replace OECD=0 if OECD!=1

/*  This adds an OECDname2 variable, as defined by the World Bank, 2006 */
gen OECDname2=1 if name_2=="United States of America" | name_2=="Austria" | name_2=="Belgium" | name_2=="Canada" | name_2=="Denmark" | name_2=="France" | name_2=="German Federal Republic" | name_2=="Greece" | name_2=="Iceland" | name_2=="Ireland" | name_2=="Italy/Sardinia" | name_2=="Luxembourg" | name_2=="Netherlands" | name_2=="Norway" | name_2=="Portugal" | name_2=="Spain" | name_2=="Sweden" | name_2=="Switzerland" | name_2=="United Kingdom"
replace OECDname2=1 if name_2=="Japan" | name_2=="Finland" | name_2=="Australia" | name_2=="New Zealand"
replace OECDname2=1 if name_2=="Germany West (1945-1990)" | name_2=="Germany (1991+)"
/*Not sure about these ones--these are the new members?*/
*replace OECDname2=1 if name_2=="Turkey/Ottoman Empire" | name_2=="Mexico" | name_2=="Czech Republic"  | name_2=="Hungary" | name_2=="Poland" | name_2=="Korea, Republic of" | name_2=="Slovakia"
replace OECDname2=0 if OECDname2!=1


save "trade/madedata/alltradeART22.dta", replace


** Now, run the R code on the RCE -- it runs in 5 minutes instead of 45 min


########################################
## R code


#setwd("C:\\Documents and Settings\\Rich\\Desktop\\Rewards for Ratification\\Matching analysis")
#setwd("/nfs/home/R/rnielsen/shared_space/rewards/traderewards")

library(foreign)
dat <- read.dta("trade/madedata/alltradeART22.dta", convert.underscore=T)

head(dat)

dim(dat)
table(dat$treated)

  ## Not all of the observations have all of the lags and leads
dim(na.omit(dat))
table(na.omit(dat)$treated)

## We are losing a ton of observations by dropping everything that doesn't
## have the lags.  But I'm not using the lags for the matching.

## this is the matching formula
ftmp <- "treated ~ year "

## pull out all the l1vars
l1vars <- c()
for(i in 1:ncol(dat)){
  if(length(grep("l1",names(dat)[i]))>0){
    ## we skip a couple of the variables that have no variation
    if(names(dat)[i]=="l1art22name.2"){next}
    if(names(dat)[i]=="l1colorbit"){next}
    l1vars <- c(l1vars,names(dat)[i])
  }
}

ftmp1 <- as.formula(paste(ftmp, "+",paste(l1vars,collapse=" + ")))
## add the outcome variable so we can na.omit the data
l1vars <- c(l1vars,"imports012345")
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
#pdf("ART22diffsTRADE.pdf")
par(mar=c(5,10,5,1))
plot(t.means-c.means,rev(1:length(t.means)),
     type="n", ylab="",xlab="mean(T) - mean(C)",
     axes=F,
     ylim=c(0,20), main="ART22")
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

mm <- cbind(mout$dist.matrix,as.numeric(mout$match.matrix))
head(mm)
hist(mm[,1])
  ## these are the matches that have distances
  ## greater than 10
bad <- cbind(mout$dist.matrix,as.numeric(mout$match.matrix))[mout$dist.matrix[,1]>10,]

## These are the matches
cbind(dat[rownames(bad),c(1:2,4)],dat[as.character(bad[,2]),c(1:2,4)], bad[,1])

## Make a calipered matched dataset
dropme <- which(rownames(mout$match.dat)%in%(c(rownames(bad),as.character(bad[,2]))))
cdat <- mout$match.dat[-dropme,]

## I'm writing out the full matched dataset
#setwd("C:\\Documents and Settings\\Rich\\Desktop\\Rewards for Ratification\\Matching analysis")
library(foreign)
#write.dta(mout$match.dat,"trade/madedata/mahmatches_ART22trade.dta")

write.dta(cdat,"trade/madedata/mahmatchescaliper_ART22trade.dta")


## Can't do the caliper matching from aid because the matrix is too
## big for the memory.  The "outer" command crashes.

#####################################################

** 1-to-1 matching 

use "trade/madedata/mahmatchescaliper_ART22trade.dta", clear

xtset directed_dyad_id


** This is trade between OECD treaty ratifiers and non-OECD countries
xtreg imports012345 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
table treated if e(sample)==1

xtreg imports012345 treated l1* l2* l3* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
table treated if e(sample)==1

** This is all trade with all countries
xtreg imports012345 treated l1* l2* l3* if art22name_1==1, cluster(directed_dyad_id) robust re
table treated if e(sample)==1

** with OECDname2==0 and treaty members
xtreg imports012345 treated l1* l2* l3* if OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
table treated if e(sample)==1



** 21 May 2012 -- Additional robustness checks
log using "trade/results/trade_ART22.smcl", replace

clear
set mem 1000M
set more off

use "trade/madedata/mahmatchescaliper_ART22trade.dta", clear
xtset directed_dyad_id

** Original Models
xtreg imports012345 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
outreg2 using "trade/results/trade table.doc", word append
xtreg imports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg imports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re

xtreg imports012345 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg imports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg imports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re

** No controls
reg imports012345 treated if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust
reg imports012 treated if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust
reg imports123 treated if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust

reg imports012345 treated if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust
reg imports012 treated if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust
reg imports123 treated if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust



** Fixed effects
areg imports012345 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, a(directed_dyad_id)
areg imports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, a(directed_dyad_id)
areg imports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, a(directed_dyad_id)

areg imports012345 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, a(directed_dyad_id)
areg imports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, a(directed_dyad_id)
areg imports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, a(directed_dyad_id)



** look at differenced aid, rather than levels

gen diffimports01234 = (eimports + f1eimports + f2eimports + f3eimports + f4eimports) - (exp(l1imports) + exp(l2imports) + exp(l3imports) + exp(l4imports) + exp(l5imports))
gen diffimports012 = (eimports + f1eimports + f2eimports) - (exp(l1imports) + exp(l2imports) + exp(l3imports) )
gen diffimports123 = (f1eimports + f2eimports + f3eimports) - (eimports + exp(l1imports) + exp(l2imports) )

xtreg diffimports01234 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg diffimports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg diffimports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re

xtreg diffimports01234 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg diffimports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg diffimports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re


  ** maybe controlling for past aid levels is bad here
drop l1imports l2imports l3imports l4imports l5imports 

xtreg diffimports01234 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg diffimports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg diffimports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re

xtreg diffimports01234 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg diffimports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg diffimports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re


use "trade/madedata/mahmatchescaliper_ART22trade.dta", clear
xtset directed_dyad_id


** run the model without chunks -- country year observations

  ** year before ratification
xtreg imports treated l1* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg imports treated l1* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re

  ** year of ratification
gen f1imports = log(f1eimports)
xtreg f1imports treated imports physint1 empinx1 gattFF gattFO ptarecip ptanonrecip gsp currencyunion gdp distance  share_language  share_border  landlocked island land_area if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg f1imports treated imports physint1 empinx1 gattFF gattFO ptarecip ptanonrecip gsp currencyunion gdp distance  share_language  share_border  landlocked island land_area if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re

** Look at aid bumps preceeding ratification
gen imports21012 = log(exp(l2imports) + exp(l1imports) + eimports + f1eimports + f2eimports)
gen imports210 = log(exp(l2imports) + exp(l1imports) + eimports)
drop l2imports l1imports

xtreg imports21012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg imports210 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re

xtreg imports21012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg imports210 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re




** Models without the matching
use "trade/madedata/alltradeART22.dta", clear
xtset directed_dyad_id

** Original Models
xtreg imports012345 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg imports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg imports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re

xtreg imports012345 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg imports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg imports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re

** No controls
reg imports012345 treated if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust
reg imports012 treated if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust
reg imports123 treated if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust

reg imports012345 treated if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust
reg imports012 treated if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust
reg imports123 treated if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust



** Fixed effects
areg imports012345 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, a(directed_dyad_id)
areg imports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, a(directed_dyad_id)
areg imports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, a(directed_dyad_id)

areg imports012345 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, a(directed_dyad_id)
areg imports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, a(directed_dyad_id)
areg imports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, a(directed_dyad_id)



** look at differenced aid, rather than levels

gen diffimports01234 = (eimports + f1eimports + f2eimports + f3eimports + f4eimports) - (exp(l1imports) + exp(l2imports) + exp(l3imports) + exp(l4imports) + exp(l5imports))
gen diffimports012 = (eimports + f1eimports + f2eimports) - (exp(l1imports) + exp(l2imports) + exp(l3imports) )
gen diffimports123 = (f1eimports + f2eimports + f3eimports) - (eimports + exp(l1imports) + exp(l2imports) )

xtreg diffimports01234 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg diffimports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg diffimports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re

xtreg diffimports01234 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg diffimports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg diffimports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re


  ** maybe controlling for past aid levels is bad here
drop l1imports l2imports l3imports l4imports l5imports 

xtreg diffimports01234 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg diffimports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg diffimports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re

xtreg diffimports01234 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg diffimports012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg diffimports123 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re


use "trade/madedata/alltradeART22.dta", clear
xtset directed_dyad_id


** run the model without chunks -- country year observations

  ** year before ratification
xtreg imports treated l1* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg imports treated l1* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re

  ** year of ratification
gen f1imports = log(f1eimports)
xtreg f1imports treated imports physint1 empinx1 gattFF gattFO ptarecip ptanonrecip gsp currencyunion gdp distance  share_language  share_border  landlocked island land_area if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg f1imports treated imports physint1 empinx1 gattFF gattFO ptarecip ptanonrecip gsp currencyunion gdp distance  share_language  share_border  landlocked island land_area if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re

** Look at aid bumps preceeding ratification
gen imports21012 = log(exp(l2imports) + exp(l1imports) + eimports + f1eimports + f2eimports)
gen imports210 = log(exp(l2imports) + exp(l1imports) + eimports)
drop l2imports l1imports

xtreg imports21012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re
xtreg imports210 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0 & art22name_1==1, cluster(directed_dyad_id) robust re

xtreg imports21012 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re
xtreg imports210 treated l1* l2* l3* l4* l5* if OECD==1 & OECDname2==0, cluster(directed_dyad_id) robust re


log close
