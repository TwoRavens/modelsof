testparm S_*
global P=r(p)
quietly {
levelsof contest, local(levels)
global n=wordcount("`levels'")
mat b=e(b)'
mat V=e(V)
mat b=b[1..$n,1]
mat V=V[1..$n,1..$n]
mat def AV=(1/$n)^2*vecdiag(I($n))*V*vecdiag(I($n))'
global V=AV[1,1]
mat def AB=(1/$n)*vecdiag(I($n))*b
global b=AB[1,1]
global V=sqrt($V)
}
disp $b
disp $V

quietly {
mat def AV_rms=4*(1/$n)^2*(b'*V*b)
mat def b_rms=(1/$n)*b'*b
global b_rms=b_rms[1,1]
global V_rms=AV_rms[1,1]
global V_rms=sqrt($V_rms)
}
disp $b_rms
disp $V_rms


