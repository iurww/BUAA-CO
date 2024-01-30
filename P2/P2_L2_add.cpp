#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

const int N = 10;
int a[N][N];

int main(int argc, char *argv[]) {
	int n, m;
	cin >> n >> m;

	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++)
			cin >> a[i][j];

	int x;
	for (int i = 0; i < n; i++)
		for (int j = 0; j < m; j++) {
			cin >> x;
			a[i][j] += x;
		}

	cout << "The result is:" << endl;
	for (int j = 0; j < m; j++) {
		for (int i = 0; i < n; i++)
			cout << a[i][j] << " ";
		cout << endl;
	}

	return 0;
}