#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#define START 0
#define END   N-1
#define SIZE  N
#define R_END RSIZE-1 

long long int *heights, *L, *R;
long LSIZE, RSIZE; 

int main(int argc, char **argv) {
	
	if(argc != 2) {
		printf("Usage: %s input_file\n", argv[0]);
		exit(1);
	}

	FILE *fp;
	fp = fopen(argv[1], "r");

	long int N;
	if( fscanf(fp, "%ld", &N) < 0) {
		fprintf(stderr, "fscanf: Error reading N. Exiting...");
		return 1;
	}

	heights = (long long int *)malloc(N * sizeof(long long int));

	long int i;
	for(i = 0; i < N; i++)
		if(fscanf(fp, "%lld", &heights[i]) < 0) {
			fprintf(stderr, "fscanf: Error reading N. Exiting...");
			return 1;
		}
	fclose(fp);


	LSIZE = RSIZE = 1;

	L = (long long int *)malloc(sizeof(long long int));
	R = (long long int *)malloc(sizeof(long long int));

	L[START] = START;

	for(i = START + 1; i < SIZE; i++) {
		if(heights[L[LSIZE-1]] >= heights[i]) {
			LSIZE++;
			L    = (long long int *)realloc(L, LSIZE * sizeof(long long int));
			L[LSIZE-1] = i;
		}
	}

	if(LSIZE == N) {
		printf("0\n");
		return 0;
	}


	R[START] = END;
	for(i = END - 1; i >= 0; i--) {
		if(heights[R[RSIZE-1]] <= heights[i]) {
			RSIZE++;
			R    = (long long int *) realloc(R, RSIZE * sizeof(long long int));
			R[RSIZE-1] = i;
		}
	}


	i = START;
	long int j = R_END, posL = L[i], posR = R[j], max = INT_MIN;	
	
	while(i < LSIZE && j >=0) {
		if(heights[posR] >= heights[posL]) {
			max = max < posR - posL ? posR - posL : max;
			j--;
			posR = R[j];
		}
		else {
			i++;
			posL = L[i];
		}
	
	}

	printf("%ld\n", max);
	return 0;
}
