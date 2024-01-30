#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

int a[105];

int main(int argc, char *argv[]) {
	int n, m;
	cin >> n >> m;

	for (int i = 1; i <= n; i++)
		a[i] = 1;

	int cnt = 0, res = n;
	while (res > 0) {
		for (int i = 1; i <= n; i++) {
			if (a[i]) {
				cnt++;
				if (cnt == m) {
					a[i] = 0;
					cnt = 0;
					res--;
					cout << i << endl;
				}
			}
		}
	}

	return 0;
}