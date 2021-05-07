int soma(int a, int b) {
    return a + b;
}

void main() {
    int a, b;

    printf("Digite o primeiro número: ");
    scanf("%d", &a);
    printf("Digite o segundo número: ");
    scanf("%d", &b);

    printf("%d", soma(a, b));
}