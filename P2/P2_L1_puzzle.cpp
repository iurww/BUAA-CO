#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

const int N = 10;

int g[N][N], vis[N][N];
int dx[4] = {-1, 0, 1, 0}, dy[4] = {0, 1, 0, -1};
int n, m, sx, sy, ex, ey;
int ans;

void dfs(int nowx, int nowy) {
	if (nowx == ex && nowy == ey) {
		ans++;
		return;
	}
	vis[nowx][nowy] = 1;
	for (int i = 0; i < 4; i++) {
		int nx = nowx + dx[i];
		int ny = nowy + dy[i];
		if (nx >= 0 && nx < n && ny >= 0 && ny < m)
			if (!vis[nx][ny] && !g[nx][ny])
				dfs(nx, ny);
	}
	vis[nowx][nowy] = 0;
}

int main(int argc, char *argv[]) {
	cin >> n >> m;
	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++)
			cin >> g[i][j];
	cin >> sx >> sy >> ex >> ey;
	sx--;
	sy--;
	ex--;
	ey--;

	dfs(sx, sy);

	cout << ans;

	getchar();
	getchar();
	return 0;
}