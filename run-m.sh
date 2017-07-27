source /usr/usc/matlab/default/setup.sh
export LD_LIBRARY_PATH="/home/rcf-40/chen116/dynamo/lpsolve_matlab"
screen -S vc -d -m && screen -r vc -X stuff $' source /usr/usc/matlab/default/setup.sh \n export LD_LIBRARY_PATH="/home/rcf-40/chen116/dynamo/lpsolve_matlab" \n matlab -nodesktop \n' && screen -r
