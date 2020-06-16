#!/bin/bash

exec < "list"
while read LINE
do

	FN=$LINE
	blastn -task megablast -query $FN -db ~/scratch/raw/digitifera -evalue 1e-5 -num_threads 1  -max_target_seqs 1 -outfmt 6 -out $LINE.sym

done

