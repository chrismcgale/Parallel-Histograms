__global__ void parallel_private_histogram_kernel(char *data, unsigned int length, unsigned int *histo) {
    __shared__ unsigned int histo_s[NUM_BINS]
    for (unsigned int bin = threadIdx.x; bin < NUM_BINS; bin += blockDim.x) {
        histo_s[bin] = 0u;
    }

    unsigned int i = blockIdx.x*blockDim.x + threadIdx.x;
    if (i < length) {
        int alphabet_pos = data[i] - 'a';
        if (alphabet_pos >= 0 && alphabet_pos < 26) {
            atomicAdd(&(histo_s[blockIdx.x*NUM_BINS + alphabet_pos/4]), 1);
        }
    }
    if (blockIdx.x > 0) {
        __syncthreads();
        for (unsigned int bin = threadIdx.x; bin < NUM_BINS; bin += blockDim.x) {
            unsigned int binValue = histo_s[blockIdx.x*NUM_BINS + bin];
            if (binValue > 0) {
                atmoicAdd(&(histo[bin]), binValue);
            }
        }
    }
}