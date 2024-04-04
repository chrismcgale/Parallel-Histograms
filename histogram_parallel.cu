__global__ void parallel_histogram_kernel(char *data, unsigned int length, unsigned int *histo) {
    unsigned int i = blockIdx.x*blockDim.x + threadIdx.x;
    if (i < length) {
        int alphabet_pos = data[i] - 'a';
        if (alphabet_pos >= 0 && alphabet_pos < 26) {
            // histo is shared between threads so we need atomicity
            atomicAdd(&(histo[alphabet_pos/4]), 1);
        }
    }
}