#!/usr/bin/bash


modeSeq=("rw" "read" "write")	#Sequential mode
sizeSeq="100G"	#Sequential mode size

modeRand=("randrw" "randread" "randwrite")	#Random mode
sizeRand="16G"	#Random mode size


LOGNAME="/tmp/fio.singledisk.$(date +%Y%m%d).$(date +%H%M).log"
printf "FIO TEST FOR 1 DISK: RANDOM AND SEQUENTIAL MODES (readwrites, reads, writes)\n"
printf "This script needs to be in the folder where you will perform the benchmark.\nIs it there? (y/n):"
read ANS
if [ "$ANS" != "y" ]
then
	echo "Exiting. Bye!"
	exit 1
fi
touch "$LOGNAME"
#echo "--------------------------------------------------------------------------------------------------------" >> "$LOGNAME"
#echo "FIO TEST FOR 1 DISK: RANDOM AND SEQUENTIAL MODES (reads, writes and readwrites)" >> "$LOGNAME"
#echo "--------------------------------------------------------------------------------------------------------" >> "$LOGNAME"



#Sequential benchmark begin
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" 2>&1 | tee -a "$LOGNAME"
echo "Sequential benchmark begin" 2>&1 | tee -a "$LOGNAME"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" 2>&1 | tee -a "$LOGNAME"
for i in "${modeSeq[@]}"
do
	case $i in
		"rw" | "read")
			echo "-------------------------------------------------------" 2>&1 | tee -a "$LOGNAME"
			echo "Mode: $i 	Size: $sizeSeq" 2>&1 | tee -a "$LOGNAME"
			echo "-------------------------------------------------------" 2>&1 | tee -a "$LOGNAME"
			fio --randrepeat=1 --ioengine=psync --direct=0 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size="$sizeSeq" --readwrite="$i" --rwmixread=75 --fallocate=0 --overwrite=0 --group_reporting=1 2>&1 | tee -a "$LOGNAME"
			;;
		"write")
			#if it is write
			echo "-------------------------------------------------------" 2>&1 | tee -a "$LOGNAME"
			echo "Mode: $i 	Size: $sizeSeq" 2>&1 | tee -a "$LOGNAME"
			echo "-------------------------------------------------------" 2>&1 | tee -a "$LOGNAME"
			fio --randrepeat=1 --ioengine=psync --direct=0 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size="$sizeSeq" --readwrite="$i" --fallocate=0 --group_reporting=1 2>&1 | tee -a "$LOGNAME"
			;;
		*)
			echo "-------->> ERROR: wrong param read from modeSeq[ ]. Test for mode: $i size=$sizeSeq is skipped" 2>&1 | tee -a "$LOGNAME"
			;;
	esac
done
echo "-------->>>> Sequential benchmark end" 2>&1 | tee -a "$LOGNAME"
#Sequential benchmark end


#Random benchmark begin
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" 2>&1 | tee -a "$LOGNAME"
echo "Random benchmark begin" 2>&1 | tee -a "$LOGNAME"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" 2>&1 | tee -a "$LOGNAME"
for i in "${modeRand[@]}"
do
	case $i in
		"randrw" | "randread")
			echo "-------------------------------------------------------" 2>&1 | tee -a "$LOGNAME"
			echo "Mode: $i 	Size: $sizeRand" 2>&1 | tee -a "$LOGNAME"
			echo "-------------------------------------------------------" 2>&1 | tee -a "$LOGNAME"
			fio --randrepeat=1 --ioengine=psync --direct=0 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size="$sizeRand" --readwrite="$i" --rwmixread=75 --fallocate=0 --overwrite=0 --group_reporting=1 2>&1 | tee -a "$LOGNAME"
			;;
		"randwrite")
			echo "-------------------------------------------------------" 2>&1 | tee -a "$LOGNAME"
			echo "Mode: $i 	Size: $sizeSeq" 2>&1 | tee -a "$LOGNAME"
			echo "-------------------------------------------------------" 2>&1 | tee -a "$LOGNAME"
			fio --randrepeat=1 --ioengine=psync --direct=0 --gtod_reduce=1 --name=test --filename=test --bs=4k --iodepth=64 --size="$sizeRand" --readwrite="$i" --fallocate=0 --group_reporting=1 2>&1 | tee -a "$LOGNAME"
			;;
		*)
			echo "-------->> ERROR: wrong param read from modeRand[ ]. Test for mode: $i size=$sizeRand is skipped" 2>&1 | tee -a "$LOGNAME"
			;;
	esac
done
echo "-------->>>> Random benchmark end" 2>&1 | tee -a "$LOGNAME"
#Random benchmark end