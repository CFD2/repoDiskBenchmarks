#!/bin/bash

LOGNAME=$(date +%Y%m%d)"_"$(date +%H%M)".log"
echo "This script needs to be in the folder where you will perform the benchmark. Is it there? (y/n):"
read ANS
if [ "$ANS" != "y" ]
then
	echo "Exiting. Bye!"
	exit 1
fi
touch $LOGNAME
#numFiles=(1000 10000 50000 100000 250000 500000 750000 1000000 5000000 10000000)
#numFiles=(1000 10000 50000 100000 250000 500000 750000 1000000)
numFiles=(1000 10000 50000 100000)
#	numFiles=(1000 10000)
#for i in "${numFiles[@]}"
#do
#	echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" >> $LOGNAME
#	echo "Starting MDTest 1 thread, numFilesTotal="$i >> $LOGNAME
#	echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" >> $LOGNAME
#	mdtest -n=$i -i=10 -u --posix.odirect 2>&1 | tee -a $LOGNAME
#	echo "sleeping for 15s"
#	sleep 15s
#done 
#numThreads=(3 4 8 16 32 64 128 256 512)
numThreads=(3 4 8 12 16 20)
#numThreads=(8 16 32 64 128 256 512)
for k in "${numThreads[@]}"
do
	for i in "${numFiles[@]}"
	do
		files=$(( i/k ))
		echo "$files = $i / $k "
		#module load mpi/openmpi-x86_64
		mpirun --np=$numThreads --output-filename "/tmp/threads.$k.Files.$files.TotalFiles.$i" --allow-run-as-root mdtest -n=$files -i=10 -u --posix.odirect
		#module purge
		echo "sleeping for 15s"
		sleep 15s
	done
done
