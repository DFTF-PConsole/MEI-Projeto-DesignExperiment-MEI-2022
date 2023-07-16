#!/bin/bash
#   n = number of vertices
#   p = arc probability (0 <= p <= 1)
#   r = maximum range of capacity
#   s = random seed 
#   f = output file name
#  example: python3 gen.py 10 0.4 100 1234 data.in

# https://stackoverflow.com/questions/40175868/how-to-create-csv-file-using-shell-script
csv()
{
    local items=("$@")

    (
    IFS=,
    echo "${items[*]}"
    )
}

# Decimal Separator
LC_NUMERIC=en_US.UTF-8

# Number of Instances
N=$(seq 1 1 30)

# Number of Measurements
M=$(seq 1 1 30)

# Seed (using RANDOM)
RANDOM=0
SEED=$RANDOM

# Seed Array to ensure that all the generated seeds are different
SEEDS=($SEED)

# Algorithms: Dinic EK MPM
ALGORITHMS="Dinic EK MPM"

# Maximum CPU Time (in seconds)
TIMEOUT=10

# Maximum Range of Capacity
RANGE=100

# Number of Vertices
VERTICES=500
#$(seq 100 50 1000)

# Arc Probability (0 <= p <= 1)
PROBABILITIES=0.5
#$(seq 0.1 0.1 0.7)

# Directories
INPUT="inputs4"
OUTPUT="outputs4"

# Create directories if they do not exist
mkdir -p $INPUT
mkdir -p $OUTPUT

# Header of CSV File
FILENAME="results_paired4.csv"
csv measurement instance algorithm seed vertices probability arcs max-capacity max-cpu result time > $FILENAME


for VERTICE in $VERTICES
do
    for PROBABILITY in $PROBABILITIES
    do
        for I in $N
        do  
            INPUT_FILE="$INPUT/input,$VERTICE,$PROBABILITY,$RANGE,$SEED.in"
            python gen.py $VERTICE $PROBABILITY $RANGE $SEED $INPUT_FILE 2>&1
            read LINE < $INPUT_FILE
            
            while [ "$LINE" == "-1" ]
            do
                rm $INPUT_FILE

                # Update Seed Value
                SEED=$RANDOM
                
                # While new Seed has the same value than the previous ones
                while [[ " ${SEEDS[*]} " =~ " ${SEED} " ]]
                do
                    # Generate a new Seed
                    SEED=$RANDOM
                done
                
                INPUT_FILE="$INPUT/input,$VERTICE,$PROBABILITY,$RANGE,$SEED.in"
                python gen.py $VERTICE $PROBABILITY $RANGE $SEED $INPUT_FILE 2>&1
                read LINE < $INPUT_FILE
            done    
            
            # Add new Seed to the Seed Array
            SEEDS+=($SEED)

            OIFS=$IFS
            IFS=' '
            read -r IGNORE ARCS < $INPUT_FILE
            IFS=$OIFS

            for ALGORITHM in $ALGORITHMS
            do
                for J in $M
                do
                    OUTPUT_FILE="$OUTPUT/$ALGORITHM,$J,$I,$VERTICE,$PROBABILITY,$RANGE,$SEED.out"
		    echo "$ALGORITHM,$I,$VERTICE,$PROBABILITY,$SEED\n"
                    ./$ALGORITHM $TIMEOUT $INPUT_FILE > $OUTPUT_FILE
                    exec 6< "$OUTPUT_FILE"
                    read RESULT <&6
                    read TIME <&6
                    csv $J $I $ALGORITHM $SEED $VERTICE $PROBABILITY $ARCS $RANGE $TIMEOUT $RESULT $TIME >> $FILENAME
                done
            done
            
            # Update Seed Value
            SEED=$RANDOM
            
            # While new Seed has the same value than the previous ones
            while [[ " ${SEEDS[*]} " =~ " ${SEED} " ]]
            do
            	# Generate a new Seed
            	SEED=$RANDOM
            done
            
	        # Add new Seed to the Seed Array
            SEEDS+=($SEED)
        done
    done
done


echo "DONE!"
