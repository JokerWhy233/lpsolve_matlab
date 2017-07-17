#$NAME=$1
#$MATFILE=$2
#$OUT=$3
#$PARA=$4

#git pull && qsub h3.pbs -N $NAME -v matname="$MATFILE",outtxt="$OUT",x="$PARA"
git pull && qsub h3.pbs -N $1 -v matname="$2",outtxt="$3",x="$4"
