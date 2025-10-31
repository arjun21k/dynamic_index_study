DATA_BIN=<path to data bin>
QUERY_BIN=<path to query bin>
GT_FILE=<path to ground truth file>
NUM_DEL=100000
NUM_INS=100000
NUM_ITERS=10
MERGE_THREADS=20
LOG_FILE=<path to log file>

WORKING_PATH=<path where initial index resides on SSD>

BASE_PREFIX=${WORKING_PATH}/<indec name>
MEM_PREFIX=${WORKING_PATH}/mem_prefix
MERGE_PREFIX=${WORKING_PATH}/merge_prefix

BIN_PATH=build/tests

# Values used from FreshDiskANN system
L_MEM=75
ALPHA_MEM=1.2
L_DISK=75
ALPHA_DISK=1.2
SINGLE_FILE=1
RANGE=64
RECALL_K=5
L_S=100

sudo ${BIN_PATH}/test_concurr_merge_insert float ${WORKING_PATH}/ $BASE_PREFIX $MERGE_PREFIX $MEM_PREFIX $L_MEM $ALPHA_MEM $L_DISK $ALPHA_DISK $DATA_BIN $SINGLE_FILE $QUERY_BIN $GT_FILE $NUM_ITERS $NUM_INS $NUM_DEL $RANGE $RECALL_K $L_S | tee $LOG_FILE
