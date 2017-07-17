name=$1
matfile=$2
out=$3
m=$4
A=$5

noname=no$name
nomatfile=no$matfile
noout=no$out

qsub h3.pbs -N $noname -v matname="$nomatfile",outtxt="$noout",m="$m",A="$A"
qsub h3.pbs -N $name -v matname="$matfile",outtxt="$out",m="$m",A="$A"
