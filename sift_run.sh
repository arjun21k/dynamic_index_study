DATA_BIN=/localscratch/arjun/freshdiskann/sift1M/sift_base.fbin
QUERY_BIN=/localscratch/arjun/freshdiskann/sift1M/sift_query.fbin
#GT_FILE=/localscratch/arjun/freshdiskann/sift1M/sift_query_base_gt5
GT_FILE=/localscratch/arjun/freshdiskann/sift1M/sift100k/sift_base_100k_query_gt5
NUM_DEL=100000
NUM_INS=100000
NUM_ITERS=10
MERGE_THREADS=20
#LOG_FILE=/home/arjun/vectorDB/freshdiskann/DiskANN/logs/node07/sift1M_streaming_merge_${NUM_DEL}_del_${NUM_INS}_ins_iter_${NUM_ITERS}_merge_20
LOG_FILE=/home/arjun/vectorDB/freshdiskann/DiskANN/logs/steady_state_800k_concurr_merge_insert_${NUM_DEL}_del_${NUM_INS}_ins_iter_${NUM_ITERS}_merge_${MERGE_THREADS}

#WORKING_PATH=/localscratch/arjun/freshdiskann/sift1M/test_concurr_merge_insert_${NUM_DEL}_del_${NUM_INS}_ins_iter_${NUM_ITERS}
WORKING_PATH=/localscratch/arjun/freshdiskann/sift1M/steady_state_800k_concurr_merge_insert_${NUM_DEL}_del_${NUM_INS}_ins_iter_${NUM_ITERS}_merge_${MERGE_THREADS}

BASE_PREFIX=${WORKING_PATH}/initial_index_100k_r64_l75_pq_32
MEM_PREFIX=${WORKING_PATH}/mem_prefix
MERGE_PREFIX=${WORKING_PATH}/merge_prefix

BIN_PATH=/home/arjun/vectorDB/freshdiskann/DiskANN/build/tests

L_MEM=75
ALPHA_MEM=1.2
L_DISK=75
ALPHA_DISK=1.2
SINGLE_FILE=1
RANGE=64
RECALL_K=5
L_S=100

sudo ${BIN_PATH}/test_concurr_merge_insert float ${WORKING_PATH}/ $BASE_PREFIX $MERGE_PREFIX $MEM_PREFIX $L_MEM $ALPHA_MEM $L_DISK $ALPHA_DISK $DATA_BIN $SINGLE_FILE $QUERY_BIN $GT_FILE $NUM_ITERS $NUM_INS $NUM_DEL $RANGE $RECALL_K $L_S | tee $LOG_FILE
