#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

int n, a[1005];

void qsort(int a[], int l, int r) {

	if (l >= r)
		return;
	int i = l - 1, j = r + 1, x = a[l + r >> 1];
	while (i < j) {
		do
			i++;
		while (a[i] < x);
		do
			j--;
		while (a[j] > x);
		if (i < j)
			swap(a[i], a[j]);
	}
	qsort(a, l, j);
	qsort(a, j + 1, r);
}

int main(int argc, char *argv[]) {
	cin >> n;
	for (int i = 1; i <= n; i++)
		cin >> a[i];

	qsort(a, 1, n);

	for (int i = 1; i <= n; i++)
		cout << a[i] << " ";

	getchar();
	getchar();
	return 0;
}