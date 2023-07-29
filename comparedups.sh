#!/bin/bash

# Directory containing the .bam files
dir="/projects/dittrichia/mapped_reads1"

# Output file
output_file="comparison_table.txt"

# Print the header line of the output table
echo -e "Library\tSorted Total Reads\tDedup Total Reads" > $output_file

# Loop through each sorted.bam file in the directory
for sorted_file in $dir/*.sorted.bam
do
  # Get the basename of the sorted file (e.g., 2198_S313_L003)
  base_name=$(basename $sorted_file .sorted.bam)

  # Path to the corresponding .rm_dup.bam file
  rm_dup_file=$dir/$base_name.rm_dup.bam

  # Get total reads from samtools flagstat for each file
  sorted_total_reads=$(samtools flagstat $sorted_file | head -n 1 | cut -f 1 -d ' ')
  rm_dup_total_reads=$(samtools flagstat $rm_dup_file | head -n 1 | cut -f 1 -d ' ')

  # Print this information into the output table
  echo -e "$base_name\t$sorted_total_reads\t$rm_dup_total_reads" >> $output_file
done
