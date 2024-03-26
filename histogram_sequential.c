// Records frequency of chars in data with and groups by every 4 letters
void histogram_sequential(char *data, unsigned int length, unsigned int *histo) {
    for (unsigned int i = 0; i < length; i++) {
        int alphabet_pos = data[i] - 'a';
        if (alphabet_pos >= 0 && alphabet_pos < 26) {
            histo[alphabet_pos/4]++;
        }
    }
}