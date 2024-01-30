#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

int a[1005];

int bs(int a[], int l, int r, int x) {
	while (l <= r) {
		int mid = l + r >> 1;
		if (a[mid] < x)
			l = mid + 1;
		else if (a[mid] > x)
			r = mid - 1;
		else
			return 1;
	}
	return 0;
}

int main(int argc, char *argv[]) {
	int n, m, x;
	cin >> n;
	for (int i = 1; i <= n; i++)
		cin >> a[i];

	cin >> m;
	while (m--) {
		cin >> x;
		cout << bs(a, 1, n, x) << endl;
	}

	return 0;
}