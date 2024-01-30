#include <algorithm>
#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;

bool check(int n) {
	if (n % 4 != 0)
		return false;
	else if (n % 100 == 0 && n % 400 != 0)
		return false;
	else
		return true;
}

int main(int argc, char *argv[]) {
	int y = 2000;

	if (check(y))
		printf("yes");
	else
		printf("no");

	system("pause");
	return 0;
}