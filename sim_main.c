// mainという名前の関数を外部から探してくる宣言
extern int app_main(void);

int main() {
    // app/main.c に記述された main() を呼び出す
    app_main();
    return 0;
}