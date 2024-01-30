#include <cstdio>
#include <cstdlib>
#include <iostream>

using namespace std;

char s[10086];
int cnt = 0;
int main() {
	do {
		system("data.exe");
		system("java -jar .\\Mars.jar lg db mc CompactDataAtZero nc test.asm > m.out");
		system("java -jar .\\Mars.jar mc CompactDataAtZero a dump .text HexText "
		       "code.txt test.asm > log.txt");
		system("iverilog -o tb.out -y ..\\P6 "
		       "..\\P6\\mips_tb.v");
		system("vvp tb.out > v.out");
		system("format.exe");
		system("fc v.out m.out > log.txt");
		freopen("log.txt", "r", stdin);
		gets(s), gets(s);
		printf("test%d:", ++cnt);
		if (s[0] != 'F') {
			puts("Wrong Answer!");
			break;
		}
		puts("Accepted!");

	} while (1);

	system("pause");
	return 0;
}