name=$1
matfile=$2
out=$3
para=$4

noname=no$name
nomatfile=no$matfile
noout=no$out


#git pull && qsub h3.pbs -N $name -v matname="$matfile",outtxt="$out",m="$para"
git pull && qsub h3.pbs -N $noname -v matname="$nomatfile",outtxt="$noout",m="$para" && qsub h3.pbs -N $name -v matname="$matfile",outtxt="$out",m="$para"
