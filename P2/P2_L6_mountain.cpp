#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

int qpow(int a, int b) {
	int ans = 1;
	while (b) {
		if (b & 1)
			ans *= a;
		b >>= 1;
		a *= a;
	}
	return ans;
}

void dfs(int level, int size) {
	if (size == 1) {
		if (level == 0)
			cout << " /\\ ";
		else
			cout << "/__\\";
	} else {
		// int buf=1<<(size-1);
		int buf = qpow(2, size - 1);
		if (level < buf) {
			for (int i = 0; i < buf; i++)
				cout << " ";
			dfs(level, size - 1);
			for (int i = 0; i < buf; i++)
				cout << " ";
		} else {
			dfs(level - buf, size - 1);
			dfs(level - buf, size - 1);
		}
	}
}

int main(int argc, char *argv[]) {
	int total;
	cin >> total;
	// int n=(1<<total);
	int n = qpow(2, total);

	for (int i = 0; i < n; i++) {
		dfs(i, total);
		cout << endl;
	}

	getchar();
	getchar();
	return 0;
}