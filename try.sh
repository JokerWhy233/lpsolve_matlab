name=en
matfile=en.m
out=en.txt
m=$1
a=$2
A=1e-$a


fullname=$name$m$a
outfile=$fullname$out


noname=no$fullname
nomatfile=no$matfile
nooutfile=no$fullname$out

qsub h3.pbs -N $noname -v matname="$nomatfile",outtxt="$nooutfile",m="$m",A="$a"
qsub h3.pbs -N $fullname -v matname="$matfile",outtxt="$outfile",m="$m",A="$a"
