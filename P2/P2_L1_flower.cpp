#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

int main(int argc, char *argv[]) {
	// for (int i = 100; i <= 999; i++) {
	// 	int a = i / 100;
	// 	int b = i / 10 % 10;
	// 	int c = i % 10;
	// 	if (a * a * a + b * b * b + c * c * c == i)
	// 		printf("%d\n", i);
	// }

	int m, n;
	cin >> m >> n;

	if (153 >= m && 153 < n)
		cout << 153 << endl;
	if (370 >= m && 370 < n)
		cout << 370 << endl;
	if (371 >= m && 371 < n)
		cout << 371 << endl;
	if (407 >= m && 407 < n)
		cout << 407 << endl;

	return 0;
}