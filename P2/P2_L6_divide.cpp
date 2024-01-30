#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

int ans[1005];
int n, cnt;

void dfs(int sum, int depth, int st) {
	if (sum > n)
		return;
	if (sum == n) {
		for (int i = 1; i < depth; i++) {
			if (i < depth - 1)
				cout << ans[i] << "+";
			else
				cout << ans[i];
		}
		cout << endl;
		cnt++;
		return;
	}
	for (int i = st; i < n; i++) {
		ans[depth] = i;
		dfs(sum + i, depth + 1, i);
	}
}

int main(int argc, char *argv[]) {
	cin >> n;
	dfs(0, 1, 1);
	cout << cnt << endl;

	return 0;
}