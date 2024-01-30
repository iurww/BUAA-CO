#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

const int N = 10;

int n;
int ans[N], vis[N];

void dfs(int cur) {
	if (cur == n) {
		for (int i = 0; i < n; i++)
			printf("%d ", ans[i]);
		printf("\n");
		return;
	}
	for (int i = 1; i <= n; i++) {
		if (!vis[i]) {
			vis[i] = 1;
			ans[cur] = i;
			dfs(cur + 1);
			vis[i] = 0;
		}
	}
}

int main(int argc, char *argv[]) {
	cin >> n;
	dfs(0);

	return 0;
}