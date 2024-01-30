#include <bits/stdc++.h>
#define maxn 100086
using namespace std;
vector<string> v, w;
char s[maxn];
int main() {
	freopen("v.out", "r", stdin);
	gets(s);
	while (gets(s) != NULL) {
		string S = s;
		v.push_back(s + 20);
	}
	freopen("v.out", "w", stdout);

	sort(v.begin(), v.end());

	for (int i = 0; i < v.size(); i++)
		printf("%s\n", v[i].c_str());

	printf("\n");

	return 0;
}
