# SSD-based Dynamic Graph Vector Index Study

This repository is a clone of FreshDiskANN (https://github.com/microsoft/DiskANN/tree/diskv2) system, which is a variant of DiskANN (NeurIPS 2019) supporting both vector search and vector updates. The compile and build instructions can be followed from the FreshDiskANN repo. 

We add code to log the `delete`, `insert`, and `patch` in order to extract the search performance in different phases of vector updates. We also modified FreshDiskANN to fix some bugs. 

All experiments are run on two different NVMe SSDs - NAND (3.84 TB Samsung PM9A1 SSD) and Optane (750 GB Intel P4800X NVMe SSD).

To test with Linux I/O schedulers (Kyber and BFQ). Kyber does not require any code changes, and Kyber experiments were run on the `main` branch. We created another branch (`main_bfq`), which sets the priority of search and update threads to high-priority and best-effort, respectively, to test BFQ.

The script (`sift_run.sh`) aids in running `test_concurr_merge_insert` from FreshDiskANN, which performs the concurrent vector search and vector update. This script helps modify the number of vectors inserted and deleted, and other parameters, while updating the index.

## Further instructions

### Test_concurr_merge_insert

1. Performs merge concurrently with search
2. `sift_run.sh` script can be used to run test_concurr_merge_insert
3. Modifying threads  
   - Search threads  
		- Set NUM_SEARCH_THREADS to 8 in tests/test_concurr_merge_insert.cpp (line 35)  
		- Set disk_search_nthreads to 8 in tests/test_concurr_merge_insert.cpp (line 760)  
		- params[std::string("disk_search_nthreads")] = 8;  
	- Delete threads
		- Set NUM_DELETE_THREADS to 1 in tests/test_concurr_merge_insert.cpp (line 34)
	- Insert threads
		- Set NUM_INSERT_THREADS to 2 in tests/test_concurr_merge_insert.cpp (line 33)
	- Merge threads
		- Set the following to 10 or 20 based on the experiment in src/v2/index_merger.cpp (lines 30 - 32)

	  	```
		#define MAX_INSERT_THREADS (uint64_t) 10  
		#define MAX_N_THREADS (uint64_t) 10  
		#define NUM_INDEX_LOAD_THREADS (uint64_t) 10
   		``` 

	- Ensure all three variables have the same value

4. Running test_concurr_merge_insert binary can be done by changing the threads as above and then updating sift_run.sh file based on appropriate configuration.
5. Logs can be parsed using freshdiskann/search_phase.py as follows:
```
python3 search_phase.py <file>
```
6. To do `ramp-up`, set the number of vectors to be deleted to 0 in `sift_run.sh`. For `steady-state`, set the number of vectors to be inserted and deleted to the same values
7. Modifying the number of merge threads and vectors inserted/deleted (e.g., 30,000 or 100,000 or 300,000) generate different workloads.

### How to set/unset Linux I/O schedulers

1. Check where the NVMe SSD is mounted and you are using for experiments (e.g., nvme0n1 or nvme1n1)
2. Verify the current I/O scheduler on this disk (e.g., for nvme1n1)
```
cat /sys/block/nvme1n1/queue/scheduler
```

The output should be:
```
[none] mq-deadline kyber bfq
```

The above indicates that no I/O scheduler is active

3. To change from ‘none’ to kyber (for example), run the following:
```
echo kyber | sudo tee /sys/block/nvme1n1/queue/scheduler
```

Verify if scheduler changed:
```
cat /sys/block/nvme1n1/queue/scheduler
none mq-deadline [kyber] bfq
```

4. Repeat steps 1-3 to enable BFQ scheduler. Modify the BFQ parameters according to experiments-
```
low_latency
strict_guarantees
slice_idle
```
5. `low_latency` should be 0 and `strict_guarantees` should be 0
To change `low_latency` from 1 change to 0 can be done and verified as follows:
```
cat /sys/block/nvme1n1/queue/iosched/low_latency
1
echo 0 | sudo tee /sys/block/nvme1n1/queue/iosched/low_latency
cat /sys/block/nvme1n1/queue/iosched/low_latency 
0
```

5. Like step #5, ensure strict_guarantees to 0.
```
cat /sys/block/nvme1n1/queue/iosched/strict_guarantees 
0
```

6. Similarly, change `slice_idle` based on the experiment and verify as follows:

```
cat /sys/block/nvme1n1/queue/iosched/slice_idle
8
echo 4 | sudo tee /sys/block/nvme1n1/queue/iosched/slice_idle
cat /sys/block/nvme1n1/queue/iosched/slice_idle
4
```

### fio experiments
