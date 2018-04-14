#include <cstdio>
#include <algorithm>

#define SZ 1000001
#define MD 1000000009

using namespace std;

struct ways {
	int value  = 0;
	int broken = 0;
} ways[SZ];

int steps_nr[SZ];

int main(int argc, char **argv) {

	FILE *fp;
	fp = fopen(argv[1], "r");

	int N, K, B;

	fscanf(fp, "%d %d %d", &N, &K, &B);

	for(int i = 0; i < K; i++)
		fscanf(fp, "%d", &steps_nr[i]);

	for(int i = 0; i < B; i++) {
		int broken_step;
		fscanf(fp, "%d", &broken_step);
		ways[broken_step].broken = 1;
	}

	sort(steps_nr, steps_nr + K);

	ways[1].value = 1;
	for(int i = 2; i < N + 1; i++) {

		for(int j = 0; j < K && steps_nr[j] < i; j++) {
			int position = i - steps_nr[j];
			if(!ways[position].broken) {
				ways[i].value = (ways[i].value + ways[position].value) % MD;
			}
		}
	}

	printf("%d\n", ways[N].value);
	return 0;
}

