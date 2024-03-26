__global__ void histo_kernel(char *data, unsigned int length, unsigned int *histo) {
    __shared__ unsigned int histo_s[NUM_BINS]
    for (unsigned int bin = threadIdx.x; bin < NUM_BINS; bin += blockDim.x) {
        histo_s[bin] = 0u;
    }

    __syncthreads();
    unsigned int tid = blockIdx.x*blockDim.x + threadIdx.x;
    for (unsigned int i = tid*CFACTOR; i < length; i += blockDim.x*gridDim.x) {
        int alphabet_pos = data[i] - 'a';
        if (alphabet_pos >= 0 && alphabet_pos < 26) {
            atomicAdd(&(histo_s[alphabet_pos/4]), 1);
        }
    }

    __syncthreads();
    for (unsigned int bin = threadIdx.x; bin < NUM_BINS; bin += blockDim.x) {
        unsigned int binValue = histo_s[binbin];
        if (binValue > 0) {
            atmoicAdd(&(histo[bin]), binValue);
        }
    }
}