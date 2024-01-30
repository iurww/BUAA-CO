#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

const int N = 15;

int m1, n1, m2, n2;
int f[N][N], g[N][N], h[N][N];

int main(int argc, char *argv[]) {
	cin >> m1 >> n1 >> m2 >> n2;
	for (int i = 0; i < m1; i++)
		for (int j = 0; j < n1; j++)
			cin >> f[i][j];
	for (int i = 0; i < m2; i++)
		for (int j = 0; j < n2; j++)
			cin >> h[i][j];

	int i, j, k, l;
	for (i = 0; i <= m1 - m2; i++)
		for (int j = 0; j <= n1 - n2; j++)
			for (k = 0; k < m2; k++)
				for (l = 0; l < n2; l++)
					g[i][j] += f[i + k][j + l] * h[k][l];

	for (i = 0; i <= m1 - m2; i++) {
		for (int j = 0; j <= n1 - n2; j++)
			printf("%d ", g[i][j]);
		printf("\n");
	}

	return 0;
}