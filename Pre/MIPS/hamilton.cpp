#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

int g[10][10];
int f[1 << 10][10];

int main(int argc, char *argv[]) {
	int n, m;
	scanf("%d%d", &n, &m);
	for (int i = 1, a, b; i <= m; i++) {
		scanf("%d%d", &a, &b);
		a -= 1;
		b -= 1;
		g[a][b] = g[b][a] = 1;
	}

	f[1][0] = 1;

	for (int i = 0; i < 1 << n; i++)
		for (int j = 0; j < n; j++)
			if (i >> j & 1)
				for (int k = 0; k < n; k++)
					if (i - (1 << j) >> k & g[k][j])
						f[i][j] |= f[i - (1 << j)][k];

	int ans = 0;
	for (int i = 0; i < n; i++)
		ans |= f[(1 << n) - 1][i] & g[i][0];

	printf("%d\n", ans);
	for (int i = 0; i < 1 << n; i++) {
		for (int j = 0; j < n; j++)
			printf("%d ", f[i][j]);
		printf("\n");
	}

	// system("pause");
	return 0;
}