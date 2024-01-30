#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

const int N = 25;

char s[N];

int main(int argc, char *argv[]) {
	int n;
	cin >> n;
	for (int i = 0; i < n; i++)
		cin >> s[i];

	int ans = 1;
	for (int i = 0, j = n - 1; i < j; i++, j--) {
		if (s[i] != s[j]) {
			ans = 0;
			break;
		}
	}

	printf("%d", ans);
	return 0;
}