name=en
matfile=en.m
out=en.txt
m=$1
A=1e-$2

fullname=$name$m$A
outfile=$fullname$out


noname=no$fullname
nomatfile=no$matfile
nooutfile=no$fullname$out

qsub h3.pbs -N $noname -v matname="$nomatfile",outtxt="$nooutfile",m="$m",A="$A"
qsub h3.pbs -N $fullname -v matname="$matfile",outtxt="$outfile",m="$m",A="$A"
