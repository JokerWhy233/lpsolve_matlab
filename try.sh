name=$1
matfile=$2
out=$3
m=$4
A=$5

fullname=$name$m$A
outfile=$fullname$out


noname=no$fullname
nomatfile=no$matfile
nooutfile=no$fullname$out

qsub h3.pbs -N $noname -v matname="$nomatfile",outtxt="$nooutfile",m="$m",A="$A"
qsub h3.pbs -N $fullname -v matname="$matfile",outtxt="$outfile",m="$m",A="$A"
