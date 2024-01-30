#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

int f[2005] = {1};
int cnt = 0;

void print06(int x) {
	if (x > 99999)
		cout << x;
	else if (x > 9999)
		cout << "0" << x;
	else if (x > 999)
		cout << "00" << x;
	else if (x > 99)
		cout << "000" << x;
	else if (x > 9)
		cout << "0000" << x;
	else
		cout << "00000" << x;
}

int main(int argc, char *argv[]) {
	int n;
	cin >> n;

	int d = 0, x = 0;
	for (int i = 2; i <= n; i++) {
		int j, t;
		x = 0;
		for (j = 0; j <= d; j++) {
			t = f[j] * i + x;
			x = t / 1000000;
			f[j] = t % 1000000;
		}
		while (x) {
			d++;
			f[d] = x % 1000000;
			x = x / 1000000;
		}
	}
	printf("%d", f[d]);
	for (int j = d - 1; j >= 0; j--)
		print06(f[j]);
	return 0;
}