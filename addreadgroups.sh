#!/bin/bash

# Directory containing the BAM files
BAM_DIR="/projects/dittrichia/mapped_reads/rm_dup_bams"

# Path to the Picard tool
PICARD_PATH="/software/picard/build/libs/picard.jar"

# Iterate over each BAM file in the directory
for BAM_FILE in $BAM_DIR/*rm_dup.bam; do
    # Extract the base name (without path and extension) for the RGID and RGSM tags
    BASE_NAME=$(basename $BAM_FILE .rm_dup.bam)

    # Construct the output file name
    OUTPUT_FILE="${BAM_DIR}/${BASE_NAME}.rg_added.bam"

    # Execute the Picard command to add or replace read groups
    java -jar $PICARD_PATH AddOrReplaceReadGroups \
        I=$BAM_FILE \
        O=$OUTPUT_FILE \
        RGID=$BASE_NAME \
        RGLB=lib1 \
        RGPL=ILLUMINA \
        RGPU=unit1 \
        RGSM=$BASE_NAME

    # Index the newly created BAM file using samtools
    samtools index $OUTPUT_FILE &

done

# Wait for all background processes to finish
wait
