#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

int h[26], c[26];

int main(int argc, char *argv[]) {
	int n, cnt = 0;
	char x;
	cin >> n;
	for (int i = 0; i < n; i++) {
		cin >> x;
		int flag = 0;
		for (int j = 1; j <= cnt; j++) {
			if (h[j] == x) {
				c[j]++;
				flag = 1;
				break;
			}
		}
		if (!flag) {
			cnt++;
			h[cnt] = x;
			c[cnt] = 1;
		}
	}

	for (int i = 1; i <= cnt; i++)
		cout << char(h[i]) << " " << c[i] << endl;
	return 0;
}