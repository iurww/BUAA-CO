#include <bits/stdc++.h>
using namespace std;
vector<int> r;
mt19937 mt(time(0));
uniform_int_distribution<int> u16(0, (1 << 16) - 1), s16(-(1 << 15), (1 << 15) - 1),
    address(0, 0x2dfc), siz(0, 15), reg(0, 2), grf(1, 30), shift(0, 31), I(1, 36), J(33, 36),
    IJ(1, 32), one(11, 32);
int cnt, tot;
int getR() {
	return r[reg(mt)];
}
void solve(int i) {
	int x, X;
	int addr;
	switch (i) {
	case 1: // lb
		x = getR();
		addr = address(mt);
		printf("ori $%d, $0, %d\n", x, addr);
		printf("lb $%d, %d($%d)\n", getR(), siz(mt), x);
		tot += 2;
		break;
	case 2: // lbu
		x = getR();
		addr = address(mt);
		printf("ori $%d, $0, %d\n", x, addr);
		printf("lbu $%d, %d($%d)\n", getR(), siz(mt), x);
		tot += 2;
		break;
	case 3: // lh
		x = getR();
		addr = address(mt);
		printf("ori $%d, $0, %d\n", x, addr >> 1 << 1);
		printf("lh $%d, %d($%d)\n", getR(), siz(mt) >> 1 << 1, x);
		tot += 2;
		break;
	case 4: // lhu
		x = getR();
		addr = address(mt);
		printf("ori $%d, $0, %d\n", x, addr >> 1 << 1);
		printf("lhu $%d, %d($%d)\n", getR(), siz(mt) >> 1 << 1, x);
		tot += 2;
		break;
	case 5: // lw
		x = getR();
		addr = address(mt);
		printf("ori $%d, $0, %d\n", x, addr >> 2 << 2);
		printf("lw $%d, %d($%d)\n", getR(), siz(mt) >> 2 << 2, x);
		tot += 2;
		break;
	case 6: // sb
		x = getR();
		addr = address(mt);
		printf("ori $%d, $0, %d\n", x, addr);
		printf("sb $%d, %d($%d)\n", getR(), siz(mt), x);
		tot += 2;
		break;
	case 7: // sh
		x = getR();
		addr = address(mt);
		printf("ori $%d, $0, %d\n", x, addr >> 1 << 1);
		printf("sh $%d, %d($%d)\n", getR(), siz(mt) >> 1 << 1, x);
		tot += 2;
		break;
	case 8: // sw
		x = getR();
		addr = address(mt);
		printf("ori $%d, $0, %d\n", x, addr >> 2 << 2);
		printf("sw $%d, %d($%d)\n", getR(), siz(mt) >> 2 << 2, x);
		tot += 2;
		break;
	case 9: // div
		x = getR();
		printf("ori $%d, $%d, 1\n", x, x);
		printf("div $%d, $%d\n", getR(), x);
		tot += 2;
		break;
	case 10: // divu
		x = getR();
		printf("ori $%d, $%d, 1\n", x, x);
		printf("divu $%d, $%d\n", getR(), x);
		tot += 2;
		break;
	case 11: // add
		printf("add $%d, $0, $%d\n", getR(), getR());
		tot++;
		break;
	case 12: // addu
		printf("addu $%d, $%d, $%d\n", getR(), getR(), getR());
		tot++;
		break;
	case 13: // sub
		x = getR();
		printf("sub $%d, $%d, $%d\n", getR(), getR(), getR());
		tot++;
		break;
	case 14: // subu
		printf("subu $%d, $%d, $%d\n", getR(), getR(), getR());
		tot++;
		break;
	case 15: // mult
		printf("mult $%d, $%d\n", getR(), getR());
		tot++;
		break;
	case 16: // multu
		printf("multu $%d, $%d\n", getR(), getR());
		tot++;
		break;
	case 17: // madd
		printf("madd $%d, $%d\n", getR(), getR());
		tot++;
		break;
	case 18: // maddu
		printf("maddu $%d, $%d\n", getR(), getR());
		tot++;
		break;
	case 19: // msub
		printf("msub $%d, $%d\n", getR(), getR());
		tot++;
		break;
	case 20: // msub
		printf("msubu $%d, $%d\n", getR(), getR());
		tot++;
		break;
	case 21: // slt
		printf("slt $%d, $%d, $%d\n", getR(), getR(), getR());
		tot++;
		break;
	case 22: // sltu
		printf("sltu $%d, $%d, $%d\n", getR(), getR(), getR());
		tot++;
		break;
	case 23: // and
		printf("and $%d, $%d, $%d\n", getR(), getR(), getR());
		tot++;
		break;
	case 24: // or
		printf("or $%d, $%d, $%d\n", getR(), getR(), getR());
		tot++;
		break;
	case 25: // addi
		printf("addi $%d, $%d, %d\n", getR(), getR(), 0);
		tot++;
		break;
	case 26: // andi
		printf("andi $%d, $%d, %d\n", getR(), getR(), u16(mt));
		tot++;
		break;
	case 27: // ori
		printf("ori $%d, $%d, %d\n", getR(), getR(), u16(mt));
		tot++;
		break;
	case 28: // lui
		printf("lui $%d, %d\n", getR(), u16(mt));
		tot++;
		break;
	case 29: // mfhi
		printf("mfhi $%d\n", getR());
		tot++;
		break;
	case 30: // mflo
		printf("mflo $%d\n", getR());
		tot++;
		break;
	case 31: // mthi
		printf("mthi $%d\n", getR());
		tot++;
		break;
	case 32: // mtlo
		printf("mtlo $%d\n", getR());
		tot++;
		break;
	case 33: // beq
		printf("beq $%d, $%d, label%d\n", getR(), getR(), ++cnt);
		solve(I(mt));
		solve(I(mt));
		printf("label%d: ", cnt);
		solve(I(mt));
		tot++;
		break;
	case 34: // bne
		printf("bne $%d, $%d, label%d\n", getR(), getR(), ++cnt);
		solve(I(mt));
		solve(I(mt));
		printf("label%d: ", cnt);
		solve(I(mt));
		tot++;
		break;
	case 35: // j
		printf("j label%d\n", ++cnt);
		solve(I(mt));
		solve(I(mt));
		printf("label%d: ", cnt);
		solve(I(mt));
		tot++;
		break;
	case 36: // jal jr
		printf("jal label%d\n", ++cnt);
		X = getR();
		printf("ori $%d, $0, 16\n", X);
		solve(one(mt));
		printf("label%d: addu $%d, $%d, $31\n", cnt, X, X);
		printf("jr $%d\n", X);
		printf("%s\n", "nop"); // solve(I(mt));\n
		tot += 4;
		break;
	}
}
int main() {
	r.push_back(grf(mt)), r.push_back(grf(mt)), r.push_back(grf(mt));
	freopen("test.asm", "w", stdout);
	printf("%s\n", "ori $2, $0, 0x132");
	printf("%s\n", "ori $4, $0, 0x234");
	printf("%s\n", "ori $4, $0, 0x47");
	printf("%s\n", "ori $5, $0, 0x914");
	printf("%s\n", "ori $6, $0, 0x42");
	printf("%s\n", "ori $7, $0, 0x4324");
	printf("%s\n", "ori $8, $0, 0x1111");
	printf("%s\n", "ori $9, $0, 0xf73");
	printf("%s\n", "ori $10, $0, 0xa3");
	printf("%s\n", "ori $11, $0, 0x3284");
	printf("%s\n", "ori $12, $0, 0x134c");
	printf("%s\n", "ori $13, $0, 0x231");
	printf("%s\n", "ori $14, $0, 0x2345");
	printf("%s\n", "ori $15, $0, 0x2842");
	printf("%s\n", "ori $16, $0, 0x23c");
	printf("%s\n", "ori $17, $0, 0x81d");
	printf("%s\n", "ori $18, $0, 0x34e");
	printf("%s\n", "ori $19, $0, 0x18b");
	printf("%s\n", "ori $20, $0, 0x124e");
	printf("%s\n", "ori $21, $0, 0x1212");
	printf("%s\n", "ori $22, $0, 0x239d");
	printf("%s\n", "ori $23, $0, 0x1384");
	printf("%s\n", "ori $24, $0, 0x172");
	printf("%s\n", "ori $25, $0, 0x1983");
	printf("%s\n", "ori $26, $0, 0x1926");
	printf("%s\n", "ori $28, $0, 0");
	printf("%s\n", "ori $29, $0, 0");
	while (tot < 900)
		solve(IJ(mt));

	return 0;
}
