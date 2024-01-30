#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

int main(int argc, char *argv[]) {
	int n;
	cin >> n;

	int ans = 0;
	for (int i = 1; i <= n; i++) {
		int res = 1;
		for (int j = 1; j <= i; j++)
			res *= j;
		ans += res;
	}
	printf("%u", ans);
	return 0;
}