#include <stdio.h>
#include <math.h>

int keepe(int n, char *fname) {
    FILE *fp;
    int m;
    int temp;
    int carry;
    signed long test;

    m = 4.0;
    int d[n];
    test = (n+1)*2.30258509;

    while (m*(log(m)-1.0) + 0.5*log(6.2831852*m) < test) {
        m++;
    }

    int coef[m+1];

    // initialize digits
    for(int i=2; i<m+1; i++) {
        coef[i] = 1;
    }
    d[0] = 2;

    carry = 0;
    for(int j=1; j<n; j++) {
        carry = 0;
        for(int k=m; k>1; k--) {
            temp = coef[k] * 10 + carry;
            carry = temp / k;
            coef[k] = temp - carry * k;
        }
        d[j] = carry;
    }

    fp = fopen(fname, "w");
    for(int x=0; x<n; x++) {
        fprintf(fp, "%d", d[x]);
        if (n>1 && x==0) {
            fprintf(fp, "%s", ".");
        }
    }
    fprintf(fp, "%s", "\n");
    fclose(fp);
    return 0;
}

int file_exists(const char *fname) {
    // return true if the file specified by the filename exists
    FILE *fp = fopen(fname, "r");
    if (fp != NULL) {
        printf("File exists and it will be overwritten.\n");
        fclose(fp);
    }
    else {
        printf("File does not exist - will be created.\n");
    }
    return 0;
}

int main(void) {
    char fname[30];
    int n;

    printf("CALCULATE e TO MANY DIGITS!\n");
    printf("Enter the number of significant digits to calculate:\n");
    scanf("%d", &n);
    printf("Enter the filename you wish to store the value of e:\n");
    scanf("%s", fname);
    file_exists(fname);
    keepe(n, fname);
}