/*
This program esimtates the capture-recapture model using the formulae of Bishop et al.
It computes estimates for the seven possible models, if they exists, and selects the best model by the criteria of BASM
*/
scalar x100=a[1,1]
scalar x010=a[2,1]
scalar x110=a[3,1]
scalar x001=a[4,1]
scalar x101=a[5,1]
scalar x011=a[6,1]
scalar x111=a[7,1]

matrix onetotal=J(1, 7, 1)
scalar nx1=a[1,1]+a[3,1]+a[5,1]+a[7,1]
scalar nx2=a[2,1]+a[3,1]+a[6,1]+a[7,1]
scalar nx3=a[4,1]+a[5,1]+a[6,1]+a[7,1]
matrix ntotalm=onetotal*a
scalar ntotal=ntotalm[1,1]
matrix indi = J(7, 1, 0)
matrix indi[1,1]=nx1+nx2+nx3-ntotal
matrix indi[2,1]=(x101+x011+x111)*(ntotal-nx3)
matrix indi[3,1]=(x110+x011+x111)*(ntotal-nx2)
matrix indi[4,1]=(x110+x101+x111)*(ntotal-nx1)
matrix indi[5,1]=x101*nx2
matrix indi[6,1]=x011*nx1
matrix indi[7,1]=x110*nx3

matrix chi2ml=J(7, 1, 0)
matrix dfml=J(7, 1, 0)
matrix prm=J(7, 1, 0)


matrix jack=J(7, 7, 0)
matrix jmv=J(7, 2, 0)
matrix nmv=J(7, 2, 0)
matrix kvarm=J(7, 1, 0)
matrix jpseudo=J(7,7,0)
matrix mijk=J(8,7,0)

/* begin loop */
local i=1
while `i'<=7 {
  local j=1
  while `j'<=7 {
    matrix jack[`i' , `j'] = a[`i',1]
    local j = `j' + 1
  }
   local i = `i' + 1
} /* end loop */

/* begin loop */
local i=1
while `i'<=7 {
    matrix jack[`i' , `i'] = jack[`i' , `i']-1
   local i = `i' + 1
} /* end loop */


****************************

scalar im=1
if indi[im,1]>0{

scalar bb=nx2*nx3+nx1*nx3+nx1*nx2
scalar aa=indi[1,1]

scalar nctotal=(bb+sqrt(bb*bb-4*nx1*nx2*nx3*aa))/(2*aa)
scalar m000=nctotal-ntotal

*X 1 2 3 12 13 23
*Y 1 2 12 3 13 23 123 CVR	DP	D-C	ODH	O-C	D-O	O-D-C


scalar px1=nx1/nctotal
scalar px2=nx2/nctotal
scalar px3=nx3/nctotal

scalar m100=px1*(1-px2)*(1-px3)*nctotal
scalar m010=px2*(1-px1)*(1-px3)*nctotal
scalar m001=px3*(1-px1)*(1-px2)*nctotal
scalar m110=px1*px2*(1-px3)*nctotal
scalar m101=px1*px3*(1-px2)*nctotal
scalar m011=px2*px3*(1-px1)*nctotal
scalar m111=px1*px2*px3*nctotal

scalar vnctotal=nctotal*m000/(m110+m101+m011+m111)
di vnctotal


matrix mijk[1,im]=m100
matrix mijk[2,im]=m010
matrix mijk[3,im]=m110
matrix mijk[4,im]=m001
matrix mijk[5,im]=m101
matrix mijk[6,im]=m011
matrix mijk[7,im]=m111
matrix mijk[8,im]=m000
******************************
matrix b1=J(1, 4, 0)
matrix I=J(4, 4, 0)

matrix b1[1,4]=log(m000)
matrix b1[1,1]=log(m100)-log(m000)
matrix b1[1,2]=log(m010)-log(m000)
matrix b1[1,3]=log(m001)-log(m000)


matrix I[1,1]=nx1
matrix I[2,2]=nx2
matrix I[3,3]=nx3
matrix I[4,4]=ntotal


matrix I[4,1]=nx1
matrix I[4,2]=nx2
matrix I[4,3]=nx3

matrix I[2,1]=m110+m111
matrix I[3,1]=m101+m111
matrix I[3,2]=m011+m111

matrix I[1,4]=I[4,1]
matrix I[2,4]=I[4,2]
matrix I[3,4]=I[4,3]

matrix I[1,2]=I[2,1]
matrix I[1,3]=I[3,1]
matrix I[2,3]=I[3,2]

matrix V1=invsym(I)
matrix I1=I
******************************

******jacknife
scalar jmean=0
scalar jvar=0

/* begin loop */
local i=1
while `i'<=7 {

scalar z100=jack[1 ,`i'] 
scalar z010=jack[2 ,`i'] 
scalar z110=jack[3 ,`i'] 
scalar z001=jack[4 ,`i'] 
scalar z101=jack[5 ,`i'] 
scalar z011=jack[6 ,`i'] 
scalar z111=jack[7 ,`i'] 

scalar zx1=z100+z110+z101+z111
scalar zx2=z010+z110+z011+z111
scalar zx3=z001+z101+z011+z111

*****************
scalar bb=zx2*zx3+zx1*zx3+zx1*zx2
scalar aa=zx1+zx2+zx3-ntotal+1
if aa>0{
scalar jctotal=(bb+sqrt(bb*bb-4*zx1*zx2*zx3*aa))/(2*aa)
}
else {
scalar jctotal=0
}
*****************
scalar jctotalk=ntotal*nctotal-(ntotal-1)*jctotal

scalar jmean=jmean+a[`i',1]*jctotalk
scalar jvar=jvar+a[`i',1]*jctotalk*jctotalk

matrix jpseudo[im,`i']=jctotal

   local i = `i' + 1
} /* end loop */

scalar jmean=jmean/ntotal
scalar jvar=(jvar/ntotal-jmean*jmean)/(ntotal-1)

*****jacknife

scalar df=7-4
/* begin loop */
scalar chi2=0
local i=1
while `i'<=7 {
scalar chi2=chi2+(a[`i',1]-mijk[`i',im])*(a[`i',1]-mijk[`i',im])/mijk[`i',im]
   local i = `i' + 1
} /* end loop */

matrix chi2ml[im,1]=chi2
matrix kvarm[im,1]=4
matrix dfml[im,1]=df
matrix prm[im,1]=1 - chi2(df,chi2)
matrix jmv[im, 1]=jmean
matrix nmv[im, 1]=nctotal
matrix jmv[im, 2]=jvar
matrix nmv[im, 2]=vnctotal
di nctotal,jmean,m000
di vnctotal,jvar

}
***IM=1


***IM=2 12
scalar im=2
if indi[im,1]>0{

scalar ntotalp=ntotal-x001
scalar nx3p=nx3-x001
scalar xpp0=ntotal-nx3


*X 1 2 3 12 13 23
*Y 1 2 12 3 13 23 123 CVR	DP	D-C	ODH	O-C	D-O	O-D-C

scalar m000=x001*xpp0/nx3p
scalar nctotal=m000+ntotal
scalar vnctotal=m000*m000/nx3p+ m000*x001/nx3p+m000*xpp0/nx3p+m000

scalar m100=(x100+x101)*xpp0/ntotalp
scalar m010=(x010+x011)*xpp0/ntotalp
scalar m001=x001
scalar m110=(x110+x111)*xpp0/ntotalp

scalar m101=(x100+x101)*nx3p/ntotalp
scalar m011=(x010+x011)*nx3p/ntotalp
scalar m111=(x110+x111)*nx3p/ntotalp

matrix mijk[1,im]=m100
matrix mijk[2,im]=m010
matrix mijk[3,im]=m110
matrix mijk[4,im]=m001
matrix mijk[5,im]=m101
matrix mijk[6,im]=m011
matrix mijk[7,im]=m111
matrix mijk[8,im]=m000

***************************
matrix b2=J(1, 5, 0)
matrix I=J(5, 5, 0)


matrix b2[1,5]=log(m000)
matrix b2[1,1]=log(m100)-log(m000)
matrix b2[1,2]=log(m010)-log(m000)
matrix b2[1,3]=log(m001)-log(m000)
matrix b2[1,4]=log(m110)-log(m100)-log(m010)+log(m000)


matrix I[1,1]=nx1
matrix I[2,2]=nx2
matrix I[3,3]=nx3
matrix I[4,4]=m110+m111
matrix I[5,5]=ntotal


matrix I[5,1]=nx1
matrix I[5,2]=nx2
matrix I[5,3]=nx3
matrix I[5,4]=m110+m111

matrix I[2,1]=m110+m111
matrix I[3,1]=m101+m111
matrix I[3,2]=m011+m111
matrix I[4,1]=m110+m111
matrix I[4,2]=m110+m111
matrix I[4,3]=m111

matrix I[1,5]=I[5,1]
matrix I[2,5]=I[5,2]
matrix I[3,5]=I[5,3]
matrix I[4,5]=I[5,4]

matrix I[1,2]=I[2,1]
matrix I[1,3]=I[3,1]
matrix I[2,3]=I[3,2]
matrix I[1,4]=I[4,1]
matrix I[2,4]=I[4,2]
matrix I[3,4]=I[4,3]

matrix V2=invsym(I)
matrix I2=I
******************************



******jacknife
scalar jmean=0
scalar jvar=0

/* begin loop */
local i=1
while `i'<=7 {

scalar z100=jack[1 ,`i'] 
scalar z010=jack[2 ,`i'] 
scalar z110=jack[3 ,`i'] 
scalar z001=jack[4 ,`i'] 
scalar z101=jack[5 ,`i'] 
scalar z011=jack[6 ,`i'] 
scalar z111=jack[7 ,`i'] 

scalar zx1=z100+z110+z101+z111
scalar zx2=z010+z110+z011+z111
scalar zx3=z001+z101+z011+z111
**************
scalar zx3p=zx3-z001
scalar zpp0=ntotal-1-zx3
if zx3p>0{
scalar jctotal=z001*zpp0/zx3p+ntotal-1
}
else {
scalar jctotal=0
}
**************
scalar jctotalk=ntotal*nctotal-(ntotal-1)*jctotal

scalar jmean=jmean+a[`i',1]*jctotalk
scalar jvar=jvar+a[`i',1]*jctotalk*jctotalk

matrix jpseudo[im,`i']=jctotal

   local i = `i' + 1
} /* end loop */

scalar jmean=jmean/ntotal
scalar jvar=(jvar/ntotal-jmean*jmean)/(ntotal-1)

di jmean
di jvar

*****jacknife


scalar df=7-5
scalar chi2=0
local i=1
while `i'<=7 {
scalar chi2=chi2+(a[`i',1]-mijk[`i',im])*(a[`i',1]-mijk[`i',im])/mijk[`i',im]
   local i = `i' + 1
} /* end loop */

matrix chi2ml[im,1]=chi2
matrix kvarm[im,1]=5
matrix dfml[im,1]=df
matrix prm[im,1]=1 - chi2(df,chi2)
matrix jmv[im, 1]=jmean
matrix nmv[im, 1]=nctotal
matrix jmv[im, 2]=jvar
matrix nmv[im, 2]=vnctotal
di nctotal,jmean,m000
di vnctotal,jvar
}
***IM=2






***IM=3 13
scalar im=3
if indi[im,1]>0{

scalar ntotalp=ntotal-x010
scalar nx2p=nx2-x010
scalar xp0p=ntotal-nx2


*X 1 2 3 12 13 23
*Y 1 2 12 3 13 23 123 CVR	DP	D-C	ODH	O-C	D-O	O-D-C

scalar m000=x010*xp0p/nx2p
scalar nctotal=m000+ntotal
scalar vnctotal=m000*m000/nx2p+ m000*x010/nx2p+m000*xp0p/nx2p+m000

scalar m100=(x100+x110)*xp0p/ntotalp
scalar m001=(x001+x011)*xp0p/ntotalp
scalar m010=x010
scalar m101=(x101+x111)*xp0p/ntotalp

scalar m011=(x001+x011)*nx2p/ntotalp
scalar m110=(x100+x110)*nx2p/ntotalp
scalar m111=(x101+x111)*nx2p/ntotalp

matrix mijk[1,im]=m100
matrix mijk[2,im]=m010
matrix mijk[3,im]=m110
matrix mijk[4,im]=m001
matrix mijk[5,im]=m101
matrix mijk[6,im]=m011
matrix mijk[7,im]=m111
matrix mijk[8,im]=m000
****************************

matrix b3=J(1, 5, 0)
matrix I=J(5, 5, 0)


matrix b3[1,5]=log(m000)
matrix b3[1,1]=log(m100)-log(m000)
matrix b3[1,2]=log(m010)-log(m000)
matrix b3[1,3]=log(m001)-log(m000)
matrix b3[1,4]=log(m101)-log(m100)-log(m001)+log(m000)


matrix I[1,1]=nx1
matrix I[2,2]=nx2
matrix I[3,3]=nx3
matrix I[4,4]=m101+m111
matrix I[5,5]=ntotal


matrix I[5,1]=nx1
matrix I[5,2]=nx2
matrix I[5,3]=nx3
matrix I[5,4]=m101+m111

matrix I[2,1]=m110+m111
matrix I[3,1]=m101+m111
matrix I[3,2]=m011+m111
matrix I[4,1]=m101+m111
matrix I[4,2]=m111
matrix I[4,3]=m101+m111

matrix I[1,5]=I[5,1]
matrix I[2,5]=I[5,2]
matrix I[3,5]=I[5,3]
matrix I[4,5]=I[5,4]

matrix I[1,2]=I[2,1]
matrix I[1,3]=I[3,1]
matrix I[2,3]=I[3,2]
matrix I[1,4]=I[4,1]
matrix I[2,4]=I[4,2]
matrix I[3,4]=I[4,3]

matrix V3=invsym(I)
matrix I3=I
****************************

******jacknife
scalar jmean=0
scalar jvar=0

/* begin loop */
local i=1
while `i'<=7 {

scalar z100=jack[1 ,`i'] 
scalar z010=jack[2 ,`i'] 
scalar z110=jack[3 ,`i'] 
scalar z001=jack[4 ,`i'] 
scalar z101=jack[5 ,`i'] 
scalar z011=jack[6 ,`i'] 
scalar z111=jack[7 ,`i'] 

scalar zx1=z100+z110+z101+z111
scalar zx2=z010+z110+z011+z111
scalar zx3=z001+z101+z011+z111
**************
scalar zx2p=zx2-z010
scalar zp0p=ntotal-1-zx2
if zx2p>0{
scalar jctotal=z010*zp0p/zx2p+ntotal-1
}
else {
scalar jctotal=0
}
**************
scalar jctotalk=ntotal*nctotal-(ntotal-1)*jctotal

scalar jmean=jmean+a[`i',1]*jctotalk
scalar jvar=jvar+a[`i',1]*jctotalk*jctotalk
matrix jpseudo[im,`i']=jctotal

   local i = `i' + 1
} /* end loop */

scalar jmean=jmean/ntotal
scalar jvar=(jvar/ntotal-jmean*jmean)/(ntotal-1)
*****jacknife

scalar df=7-5
scalar chi2=0
local i=1
while `i'<=7 {
scalar chi2=chi2+(a[`i',1]-mijk[`i',im])*(a[`i',1]-mijk[`i',im])/mijk[`i',im]
   local i = `i' + 1
} /* end loop */

matrix chi2ml[im,1]=chi2
matrix kvarm[im,1]=5
matrix dfml[im,1]=df
matrix prm[im,1]=1 - chi2(df,chi2)
matrix jmv[im, 1]=jmean
matrix nmv[im, 1]=nctotal
matrix jmv[im, 2]=jvar
matrix nmv[im, 2]=vnctotal
di nctotal,jmean,m000
di vnctotal,jvar
}
***IM=3



***IM=4 23
scalar im=4
if indi[im,1]>0{

scalar ntotalp=ntotal-x100
scalar nx1p=nx1-x100
scalar x0pp=ntotal-nx1


*X 1 2 3 12 13 23
*Y 1 2 12 3 13 23 123 CVR	DP	D-C	ODH	O-C	D-O	O-D-C

scalar m000=x100*x0pp/nx1p
scalar nctotal=m000+ntotal
scalar vnctotal=m000*m000/nx1p+ m000*x100/nx1p+m000*x0pp/nx1p+m000

scalar m010=(x010+x110)*x0pp/ntotalp
scalar m001=(x001+x101)*x0pp/ntotalp
scalar m100=x100
scalar m011=(x011+x111)*x0pp/ntotalp

scalar m101=(x101+x001)*nx1p/ntotalp
scalar m110=(x010+x110)*nx1p/ntotalp
scalar m111=(x011+x111)*nx1p/ntotalp

matrix mijk[1,im]=m100
matrix mijk[2,im]=m010
matrix mijk[3,im]=m110
matrix mijk[4,im]=m001
matrix mijk[5,im]=m101
matrix mijk[6,im]=m011
matrix mijk[7,im]=m111
matrix mijk[8,im]=m000
************************************
matrix b4=J(1, 5, 0)
matrix I=J(5, 5, 0)


matrix b4[1,5]=log(m000)
matrix b4[1,1]=log(m100)-log(m000)
matrix b4[1,2]=log(m010)-log(m000)
matrix b4[1,3]=log(m001)-log(m000)
matrix b4[1,4]=log(m101)-log(m100)-log(m001)+log(m000)


matrix I[1,1]=nx1
matrix I[2,2]=nx2
matrix I[3,3]=nx3
matrix I[4,4]=m011+m111
matrix I[5,5]=ntotal


matrix I[5,1]=nx1
matrix I[5,2]=nx2
matrix I[5,3]=nx3
matrix I[5,4]=m011+m111

matrix I[2,1]=m110+m111
matrix I[3,1]=m101+m111
matrix I[3,2]=m011+m111
matrix I[4,1]=m111
matrix I[4,2]=m011+m111
matrix I[4,3]=m011+m111

matrix I[1,5]=I[5,1]
matrix I[2,5]=I[5,2]
matrix I[3,5]=I[5,3]
matrix I[4,5]=I[5,4]

matrix I[1,2]=I[2,1]
matrix I[1,3]=I[3,1]
matrix I[2,3]=I[3,2]
matrix I[1,4]=I[4,1]
matrix I[2,4]=I[4,2]
matrix I[3,4]=I[4,3]

matrix V4=invsym(I)
matrix I4=I
****************************

******jacknife
scalar jmean=0
scalar jvar=0

/* begin loop */
local i=1
while `i'<=7 {

scalar z100=jack[1 ,`i'] 
scalar z010=jack[2 ,`i'] 
scalar z110=jack[3 ,`i'] 
scalar z001=jack[4 ,`i'] 
scalar z101=jack[5 ,`i'] 
scalar z011=jack[6 ,`i'] 
scalar z111=jack[7 ,`i'] 

scalar zx1=z100+z110+z101+z111
scalar zx2=z010+z110+z011+z111
scalar zx3=z001+z101+z011+z111
**************
scalar zx1p=zx1-z100
scalar z0pp=ntotal-1-zx1
if zx1p>0{
scalar jctotal=z100*z0pp/zx1p+ntotal-1
}
else {
scalar jctotal=0
}
**************
scalar jctotalk=ntotal*nctotal-(ntotal-1)*jctotal

scalar jmean=jmean+a[`i',1]*jctotalk
scalar jvar=jvar+a[`i',1]*jctotalk*jctotalk
matrix jpseudo[im,`i']=jctotal

   local i = `i' + 1
} /* end loop */

scalar jmean=jmean/ntotal
scalar jvar=(jvar/ntotal-jmean*jmean)/(ntotal-1)
*****jacknife

scalar df=7-5

scalar chi2=0
local i=1
while `i'<=7 {
scalar chi2=chi2+(a[`i',1]-mijk[`i',im])*(a[`i',1]-mijk[`i',im])/mijk[`i',im]

   local i = `i' + 1
} /* end loop */
matrix chi2ml[im,1]=chi2
matrix kvarm[im,1]=5
matrix dfml[im,1]=df
matrix prm[im,1]=1 - chi2(df,chi2)
matrix jmv[im, 1]=jmean
matrix nmv[im, 1]=nctotal
matrix jmv[im, 2]=jvar
matrix nmv[im, 2]=vnctotal

di nctotal,jmean,m000
di vnctotal,jvar
}

***IM=4





***IM=5 12 23
scalar im=5
if indi[im,1]>0{

*X 1 2 3 12 13 23
*Y 1 2 12 3 13 23 123 CVR	DP	D-C	ODH	O-C	D-O	O-D-C

scalar m000=x001*x100/x101
scalar nctotal=m000+ntotal
*scalar vnctotal=m000*m000*(1/x001+ 1/x100+1/x101)+m000
scalar vnctotal=m000*x100/x101+ m000*x001/x101+m000*m000/x101+m000

scalar m001=x001
scalar m100=x100
scalar m101=x101


scalar m111=(x110+x111)*(x011+x111)/nx2
scalar m011=(x010+x011)*(x011+x111)/nx2
scalar m110=(x110+x111)*(x010+x110)/nx2
scalar m010=(x010+x011)*(x010+x110)/nx2


matrix mijk[1,im]=m100
matrix mijk[2,im]=m010
matrix mijk[3,im]=m110
matrix mijk[4,im]=m001
matrix mijk[5,im]=m101
matrix mijk[6,im]=m011
matrix mijk[7,im]=m111
matrix mijk[8,im]=m000
******************************
matrix b5=J(1, 6, 0)
matrix I=J(6, 6, 0)


matrix b5[1,6]=log(m000)
matrix b5[1,1]=log(m100)-log(m000)
matrix b5[1,2]=log(m010)-log(m000)
matrix b5[1,3]=log(m001)-log(m000)
matrix b5[1,4]=log(m110)-log(m100)-log(m010)+log(m000)
matrix b5[1,5]=log(m011)-log(m010)-log(m001)+log(m000)


matrix I[1,1]=nx1
matrix I[2,2]=nx2
matrix I[3,3]=nx3
matrix I[4,4]=m110+m111
matrix I[5,5]=m011+m111
matrix I[6,6]=ntotal


matrix I[6,1]=nx1
matrix I[6,2]=nx2
matrix I[6,3]=nx3
matrix I[6,4]=m110+m111
matrix I[6,5]=m011+m111

matrix I[2,1]=m110+m111
matrix I[3,1]=m101+m111
matrix I[3,2]=m011+m111

matrix I[4,1]=m110+m111
matrix I[4,2]=m110+m111
matrix I[4,3]=m111

matrix I[5,1]=m111
matrix I[5,2]=m011+m111
matrix I[5,3]=m011+m111
matrix I[5,4]=m111



matrix I[1,6]=I[6,1]
matrix I[2,6]=I[6,2]
matrix I[3,6]=I[6,3]
matrix I[4,6]=I[6,4]
matrix I[5,6]=I[6,5]

matrix I[1,2]=I[2,1]
matrix I[1,3]=I[3,1]
matrix I[2,3]=I[3,2]
matrix I[1,4]=I[4,1]
matrix I[2,4]=I[4,2]
matrix I[3,4]=I[4,3]

matrix I[1,5]=I[5,1]
matrix I[2,5]=I[5,2]
matrix I[3,5]=I[5,3]
matrix I[4,5]=I[5,4]

matrix V5=invsym(I)
matrix I5=I
*************************************

******jacknife
scalar jmean=0
scalar jvar=0

/* begin loop */
local i=1
while `i'<=7 {

scalar z100=jack[1 ,`i'] 
scalar z010=jack[2 ,`i'] 
scalar z110=jack[3 ,`i'] 
scalar z001=jack[4 ,`i'] 
scalar z101=jack[5 ,`i'] 
scalar z011=jack[6 ,`i'] 
scalar z111=jack[7 ,`i'] 
**************
if z101>0{
scalar jctotal=z001*z100/z101+ntotal-1
}
else {
scalar jctotal=0
}
**************
scalar jctotalk=ntotal*nctotal-(ntotal-1)*jctotal

scalar jmean=jmean+a[`i',1]*jctotalk
scalar jvar=jvar+a[`i',1]*jctotalk*jctotalk
matrix jpseudo[im,`i']=jctotal

   local i = `i' + 1
} /* end loop */

scalar jmean=jmean/ntotal
scalar jvar=(jvar/ntotal-jmean*jmean)/(ntotal-1)
*****jacknife

scalar df=7-6
scalar chi2=0
local i=1
while `i'<=7 {
scalar chi2=chi2+(a[`i',1]-mijk[`i',im])*(a[`i',1]-mijk[`i',im])/mijk[`i',im]
   local i = `i' + 1
} /* end loop */
matrix chi2ml[im,1]=chi2
matrix kvarm[im,1]=6
matrix dfml[im,1]=df
matrix prm[im,1]=1 - chi2(df,chi2)
matrix jmv[im, 1]=jmean
matrix nmv[im, 1]=nctotal
matrix jmv[im, 2]=jvar
matrix nmv[im, 2]=vnctotal

di nctotal,jmean,m000
di vnctotal,jvar
}
***IM=5



***IM=6 12 13
scalar im=6
if indi[im,1]>0{

*X 1 2 3 12 13 23
*Y 1 2 12 3 13 23 123 CVR	DP	D-C	ODH	O-C	D-O	O-D-C

scalar m000=x010*x001/x011
scalar nctotal=m000+ntotal
scalar vnctotal=m000*x001/x011+ m000*x010/x011+m000*m000/x011+m000

scalar m010=x010
scalar m001=x001
scalar m011=x011


scalar m111=(x110+x111)*(x101+x111)/nx1
scalar m101=(x100+x101)*(x101+x111)/nx1
scalar m110=(x110+x111)*(x100+x110)/nx1
scalar m100=(x100+x101)*(x100+x110)/nx1

matrix mijk[1,im]=m100
matrix mijk[2,im]=m010
matrix mijk[3,im]=m110
matrix mijk[4,im]=m001
matrix mijk[5,im]=m101
matrix mijk[6,im]=m011
matrix mijk[7,im]=m111
matrix mijk[8,im]=m000
********************************************
matrix b6=J(1, 6, 0)
matrix I=J(6, 6, 0)


matrix b6[1,6]=log(m000)
matrix b6[1,1]=log(m100)-log(m000)
matrix b6[1,2]=log(m010)-log(m000)
matrix b6[1,3]=log(m001)-log(m000)
matrix b6[1,4]=log(m110)-log(m100)-log(m010)+log(m000)
matrix b6[1,5]=log(m101)-log(m100)-log(m001)+log(m000)


matrix I[1,1]=nx1
matrix I[2,2]=nx2
matrix I[3,3]=nx3
matrix I[4,4]=m110+m111
matrix I[5,5]=m101+m111
matrix I[6,6]=ntotal


matrix I[6,1]=nx1
matrix I[6,2]=nx2
matrix I[6,3]=nx3
matrix I[6,4]=m110+m111
matrix I[6,5]=m101+m111

matrix I[2,1]=m110+m111
matrix I[3,1]=m101+m111
matrix I[3,2]=m011+m111

matrix I[4,1]=m110+m111
matrix I[4,2]=m110+m111
matrix I[4,3]=m111

matrix I[5,1]=m101+m111
matrix I[5,2]=m111
matrix I[5,3]=m101+m111
matrix I[5,4]=m111



matrix I[1,6]=I[6,1]
matrix I[2,6]=I[6,2]
matrix I[3,6]=I[6,3]
matrix I[4,6]=I[6,4]
matrix I[5,6]=I[6,5]

matrix I[1,2]=I[2,1]
matrix I[1,3]=I[3,1]
matrix I[2,3]=I[3,2]
matrix I[1,4]=I[4,1]
matrix I[2,4]=I[4,2]
matrix I[3,4]=I[4,3]

matrix I[1,5]=I[5,1]
matrix I[2,5]=I[5,2]
matrix I[3,5]=I[5,3]
matrix I[4,5]=I[5,4]

matrix V6=invsym(I)
matrix I6=I
**********************************



******jacknife
scalar jmean=0
scalar jvar=0

/* begin loop */
local i=1
while `i'<=7 {

scalar z100=jack[1 ,`i'] 
scalar z010=jack[2 ,`i'] 
scalar z110=jack[3 ,`i'] 
scalar z001=jack[4 ,`i'] 
scalar z101=jack[5 ,`i'] 
scalar z011=jack[6 ,`i'] 
scalar z111=jack[7 ,`i'] 
**************
if z011>0{
scalar jctotal=z010*z001/z011+ntotal-1
}
else {
scalar jctotal=0
}
**************
scalar jctotalk=ntotal*nctotal-(ntotal-1)*jctotal

scalar jmean=jmean+a[`i',1]*jctotalk
scalar jvar=jvar+a[`i',1]*jctotalk*jctotalk
matrix jpseudo[im,`i']=jctotal

   local i = `i' + 1
} /* end loop */

scalar jmean=jmean/ntotal
scalar jvar=(jvar/ntotal-jmean*jmean)/(ntotal-1)
*****jacknife


scalar df=7-6
scalar chi2=0
local i=1
while `i'<=7 {
scalar chi2=chi2+(a[`i',1]-mijk[`i',im])*(a[`i',1]-mijk[`i',im])/mijk[`i',im]
   local i = `i' + 1
} /* end loop */
matrix chi2ml[im,1]=chi2
matrix kvarm[im,1]=6
matrix dfml[im,1]=df
matrix prm[im,1]=1 - chi2(df,chi2)
matrix jmv[im, 1]=jmean
matrix nmv[im, 1]=nctotal
matrix jmv[im, 2]=jvar
matrix nmv[im, 2]=vnctotal

di nctotal,jmean,m000
di vnctotal,jvar
}
***IM=6


***IM=7 13 23
scalar im=7
if indi[im,1]>0{

*X 1 2 3 12 13 23
*Y 1 2 12 3 13 23 123 CVR	DP	D-C	ODH	O-C	D-O	O-D-C

scalar m000=x100*x010/x110
scalar nctotal=m000+ntotal
scalar vnctotal=m000*x100/x110+ m000*x010/x110+m000*m000/x110+m000

scalar m100=x100
scalar m010=x010
scalar m110=x110


scalar m111=(x101+x111)*(x011+x111)/nx3
scalar m011=(x011+x111)*(x001+x011)/nx3
scalar m101=(x111+x101)*(x001+x101)/nx3
scalar m001=(x001+x011)*(x001+x101)/nx3

matrix mijk[1,im]=m100
matrix mijk[2,im]=m010
matrix mijk[3,im]=m110
matrix mijk[4,im]=m001
matrix mijk[5,im]=m101
matrix mijk[6,im]=m011
matrix mijk[7,im]=m111
matrix mijk[8,im]=m000
**********************************
matrix b7=J(1, 6, 0)
matrix I=J(6, 6, 0)


matrix b7[1,6]=log(m000)
matrix b7[1,1]=log(m100)-log(m000)
matrix b7[1,2]=log(m010)-log(m000)
matrix b7[1,3]=log(m001)-log(m000)
matrix b7[1,4]=log(m101)-log(m100)-log(m001)+log(m000)
matrix b7[1,5]=log(m011)-log(m010)-log(m001)+log(m000)


matrix I[1,1]=nx1
matrix I[2,2]=nx2
matrix I[3,3]=nx3
matrix I[4,4]=m101+m111
matrix I[5,5]=m011+m111
matrix I[6,6]=ntotal


matrix I[6,1]=nx1
matrix I[6,2]=nx2
matrix I[6,3]=nx3
matrix I[6,4]=m101+m111
matrix I[6,5]=m011+m111

matrix I[2,1]=m110+m111
matrix I[3,1]=m101+m111
matrix I[3,2]=m011+m111

matrix I[4,1]=m101+m111
matrix I[4,2]=m111
matrix I[4,3]=m101+m111

matrix I[5,1]=m111
matrix I[5,2]=m011+m111
matrix I[5,3]=m011+m111
matrix I[5,4]=m111



matrix I[1,6]=I[6,1]
matrix I[2,6]=I[6,2]
matrix I[3,6]=I[6,3]
matrix I[4,6]=I[6,4]
matrix I[5,6]=I[6,5]

matrix I[1,2]=I[2,1]
matrix I[1,3]=I[3,1]
matrix I[2,3]=I[3,2]
matrix I[1,4]=I[4,1]
matrix I[2,4]=I[4,2]
matrix I[3,4]=I[4,3]

matrix I[1,5]=I[5,1]
matrix I[2,5]=I[5,2]
matrix I[3,5]=I[5,3]
matrix I[4,5]=I[5,4]

matrix V7=invsym(I)
matrix I7=I


**********************************

******jacknife
scalar jmean=0
scalar jvar=0

/* begin loop */
local i=1
while `i'<=7 {

scalar z100=jack[1 ,`i'] 
scalar z010=jack[2 ,`i'] 
scalar z110=jack[3 ,`i'] 
scalar z001=jack[4 ,`i'] 
scalar z101=jack[5 ,`i'] 
scalar z011=jack[6 ,`i'] 
scalar z111=jack[7 ,`i'] 
**************
if z110>0{
scalar jctotal=z100*z010/z110+ntotal-1
}
else {
scalar jctotal=0
}
**************
scalar jctotalk=ntotal*nctotal-(ntotal-1)*jctotal

scalar jmean=jmean+a[`i',1]*jctotalk
scalar jvar=jvar+a[`i',1]*jctotalk*jctotalk
matrix jpseudo[im,`i']=jctotal
   local i = `i' + 1
} /* end loop */

scalar jmean=jmean/ntotal
scalar jvar=(jvar/ntotal-jmean*jmean)/(ntotal-1)
*****jacknife

scalar df=7-6
scalar chi2=0
local i=1
while `i'<=7 {
scalar chi2=chi2+(a[`i',1]-mijk[`i',im])*(a[`i',1]-mijk[`i',im])/mijk[`i',im]
   local i = `i' + 1
} /* end loop */
matrix kvarm[im,1]=6
matrix chi2ml[im,1]=chi2
matrix dfml[im,1]=df
matrix prm[im,1]=1 - chi2(df,chi2)
matrix jmv[im, 1]=jmean
matrix nmv[im, 1]=nctotal
matrix jmv[im, 2]=jvar
matrix nmv[im, 2]=vnctotal
di nctotal,jmean,m000
di vnctotal,jvar

}
***IM=7

**************************
* Select Model
**************************

scalar kvar=0
scalar prhigh=0.5
scalar prlow=0.01

scalar modeli=0
matrix IF=J(4, 4, 0)
matrix b=J(1, 4, 0)
matrix V=IF

scalar criterion=100000.0
scalar pcriterion=100000.0
scalar pmodeli=0

/* begin loop */
scalar im=1
while im<=7{
if indi[im,1]>0{

scalar crit=chi2ml[im,1]/dfml[im,1]

scalar prcrit=min(abs(prm[im,1]-prlow),abs(prm[im,1] -prhigh))

if  prcrit < pcriterion  {
scalar pcriterion=prcrit
scalar pmodeli=im
}

if  crit < criterion & prm[im,1] >=prlow & prm[im,1] <= prhigh &  nmv[im, 2]>0{
scalar criterion=crit
scalar modeli=im
scalar kvar=kvarm[im,1]

}
}
scalar im=im+1
} 

if modeli==0{
scalar modeli=pmodeli
scalar kvar=kvarm[modeli,1]
}
else{
scalar pmodeli=0
} /* end if */

if modeli==1 {
matrix b=b1
matrix V=V1
matrix IF=I1
}
else if modeli==2 {
matrix b=b2
matrix V=V2
matrix IF=I2
}
else if modeli==3 {
matrix b=b3
matrix V=V3
matrix IF=I3
}
else if modeli==4 {
matrix b=b4
matrix V=V4
matrix IF=I4
}
else if modeli==5 {
matrix b=b5
matrix V=V5
matrix IF=I5
}
else if modeli==6 {
matrix b=b6
matrix V=V6
matrix IF=I6
}
else if modeli==7 {
matrix b=b7
matrix V=V7
matrix IF=I7
}

