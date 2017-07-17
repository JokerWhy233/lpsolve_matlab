name=$1
matfile=$2
out=$3
para=$4

#git pull && qsub h3.pbs -N $NAME -v matname="$MATFILE",outtxt="$OUT",x="$PARA"
git pull && qsub h3.pbs -N $name -v matname="$matfile",outtxt="$out",x="$para"
