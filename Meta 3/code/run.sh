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
M=$(seq 1 1 1)

# Seed (incremental)
SEED=0

# Algorithms: Dinic EK MPM
ALGORITHMS="Dinic EK MPM"

# Maximum CPU Time (in seconds)
TIMEOUT=10

# Maximum Range of Capacity
RANGE=100

# Number of Vertices
VERTICES=$(seq 100 50 1000)

# Arc Probability (0 <= p <= 1)
PROBABILITIES=$(seq 0.1 0.1 0.7)

# Directories
INPUT="inputs"
OUTPUT="outputs"

# Create directories if they do not exist
mkdir -p $INPUT
mkdir -p $OUTPUT

# Header of CSV File
FILENAME="results.csv"
csv measurement instance algorithm seed vertices probability arcs max-capacity max-cpu result time >> $FILENAME


for A in $ALGORITHMS
do
    for V in $VERTICES
    do
        for P in $PROBABILITIES
        do
            for I in $N
            do  
                INPUT_FILE="$INPUT/input,$V,$P,$RANGE,$SEED.in"
                python gen.py $V $P $RANGE $SEED $INPUT_FILE 2>&1
                read LINE < $INPUT_FILE
                
                while [ "$LINE" == "-1" ]
                do
                    rm $INPUT_FILE
                    ((++SEED))
                    INPUT_FILE="$INPUT/input,$V,$P,$RANGE,$SEED.in"
                    python gen.py $V $P $RANGE $SEED $INPUT_FILE 2>&1
                    read LINE < $INPUT_FILE
                done    
                
                OIFS=$IFS
                IFS=' '
                read -r IGNORE ARCS < $INPUT_FILE
                IFS=$OIFS

                for J in $M
                do
                    OUTPUT_FILE="$OUTPUT/$A,$J,$I,$V,$P,$RANGE,$SEED.out"
                    ./$A $TIMEOUT $INPUT_FILE > $OUTPUT_FILE
                    exec 6< "$OUTPUT_FILE"
                    read RESULT <&6
                    read TIME <&6
                    csv $J $I $A $SEED $V $P $ARCS $RANGE $TIMEOUT $RESULT $TIME >> $FILENAME
                done
                
                ((++SEED))
            done
        done
    done
done

echo "DONE!"
