#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

const int N = 10;
int a[N][N], b[N][N], c[N][N];

int main(int argc, char *argv[]) {
	int n;
	scanf("%d", &n);

	for (int i = 0; i < n; i++)
		for (int j = 0; j < n; j++)
			scanf("%d", &a[i][j]);
	for (int i = 0; i < n; i++)
		for (int j = 0; j < n; j++)
			scanf("%d", &b[i][j]);

	for (int i = 0; i < n; i++)
		for (int j = 0; j < n; j++)
			for (int k = 0; k < n; k++)
				c[i][j] += a[i][k] * b[k][j];

	for (int i = 0; i < n; i++) {
		for (int j = 0; j < n; j++)
			printf("%d ", c[i][j]);
		printf("\n");
	}

	return 0;
}