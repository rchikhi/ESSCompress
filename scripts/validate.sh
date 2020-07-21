
function abspath {
    if [[ -d "$1" ]]
    then
        pushd "$1" >/dev/null
        pwd
        popd >/dev/null
    elif [[ -e "$1" ]]
    then
        pushd "$(dirname "$1")" >/dev/null
        echo "$(pwd)/$(basename "$1")"
        popd >/dev/null
    else
        echo "$1" does not exist! >&2
        return 127
    fi
}
Help()
{
   # Display Help
   echo
   echo "Syntax: ./validate.sh [k] [file1] [file2]"
   echo "This scripts takes as input the value of k-mer size, and 2 fasta files. It outputs SUCCESS if they represent the same set of k-mers, and gives a WARNING otherwise."
   echo
   exit
   # echo "-m [0|1|2]        compression mode (default:0); 0=ess(high compression), 1=ess-tip(low memory compression), 2=no compression (plain spss)"
   #echo "-t [0|1]          Specify input type (default 1): 0=fasta/fastq file, 1=cdbG by bcalm"
}

PPATH=$(abspath $(dirname $0))
PPATH=$(abspath $(echo "$(dirname $PPATH)/bin"))

validate(){
   K=$1
   UNITIG_FILE=$2
   DECOMPRESSED_FILE=$3
   echo "Validating file '$2' and file '$3' with k=$1";
   $PPATH/dskESS -file $UNITIG_FILE -kmer-size $K -abundance-min 1  -verbose 0 -out unitigs.h5
   $PPATH/dskESS -file $DECOMPRESSED_FILE -kmer-size $K -abundance-min 1  -verbose 0 -out spss.h5
   $PPATH/dsk2asciiESS -file unitigs.h5 -out unitigs.txt  -verbose 0
   $PPATH/dsk2asciiESS -file spss.h5 -out spss.txt  -verbose 0
   #echo "doing highly  accurate validation................"
   echo "Sorting k-mers for validation................"
   #sort unitigs.txt -o sorted_unitigs.txt; sort spss.txt -o sorted_spss.txt
   sort  -k 1 -n unitigs.txt -o sorted_unitigs.txt; sort  -k 1 -n  spss.txt -o sorted_spss.txt
   
   
   cmp sorted_unitigs.txt sorted_spss.txt && echo '### SUCCESS: The two files contain same k-mers! ###' || echo '### WARNING: Files contain different k-mers! ###'

    DDEBUG=0
   if [[ DDEBUG -eq 0 ]];  then
    rm -rf sorted_spss.txt spss.txt unitigs.txt unitigs.h5 spss.h5
    rm -rf sorted_unitigs.txt
   fi
   
}

if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
    Help
fi

validate $1 $2 $3