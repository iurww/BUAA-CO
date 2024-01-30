#include <ctype.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int a[55][55];

int main(int argc, char *argv[]) {

	int n, m;
	scanf("%d%d", &n, &m);

	for (int i = 1; i <= n; i++)
		for (int j = 1; j <= m; j++)
			scanf("%d", &a[i][j]);

	for (int i = n; i >= 1; i--)
		for (int j = m; j >= 1; j--)
			if (a[i][j] > 0)
				printf("%d %d %d\n", i, j, a[i][j]);

	getchar();
	getchar();
	return 0;
}