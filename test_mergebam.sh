#!/bin/bash

# Directory containing the .bam files
dir="/projects/dittrichia/mapped_reads1"

# Change to the directory containing the .bam files
cd $dir

# Find all unique library names
libraries=$(ls *.sorted.bam | cut -d '_' -f 1,2 | sort -u)

# For each library...
for lib in $libraries
do
  # Find all .sorted.bam files for this library
  files=$(ls ${lib}_*.sorted.bam)

  # Merge these files using samtools merge, output to library_name.merged.bam
  samtools merge ${lib}.merged.bam $files
done
