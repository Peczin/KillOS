#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

unsigned int cursor_row = 0;
unsigned int cursor_col = 0;
unsigned char* video_memory = (unsigned char*) VIDEO_ADDRESS;

void update_cursor() {}

void clear_screen() {
    for (int i = 0; i < MAX_ROWS * MAX_COLS; i++) {
        video_memory[i * 2] = ' ';
        video_memory[i * 2 + 1] = 0x07;
    }
    cursor_row = 0;
    cursor_col = 0;
    update_cursor();
}

void print_char(char c, char color) {
    if (c == '\n') {
        cursor_col = 0;
        cursor_row++;
    } else {
        int pos = (cursor_row * MAX_COLS + cursor_col) * 2;
        video_memory[pos] = c;
        video_memory[pos + 1] = color;
        cursor_col++;
        if (cursor_col >= MAX_COLS) {
            cursor_col = 0;
            cursor_row++;
        }
    }

    if (cursor_row >= MAX_ROWS) {
        for (int row = 1; row < MAX_ROWS; row++) {
            for (int col = 0; col < MAX_COLS; col++) {
                int from = (row * MAX_COLS + col) * 2;
                int to = ((row - 1) * MAX_COLS + col) * 2;
                video_memory[to] = video_memory[from];
                video_memory[to + 1] = video_memory[from + 1];
            }
        }
        int last_line = (MAX_ROWS - 1) * MAX_COLS * 2;
        for (int i = 0; i < MAX_COLS; i++) {
            video_memory[last_line + i * 2] = ' ';
            video_memory[last_line + i * 2 + 1] = 0x07;
        }
        cursor_row = MAX_ROWS - 1;
    }

    update_cursor();
}

void print(const char* str, char color) {
    for (int i = 0; str[i] != 0; i++) {
        print_char(str[i], color);
    }
}

void start_kernel(void) {
    clear_screen();
    print(">> KERNEL RODANDO <<\n", 0x0A);
    print("Digite comandos...\n", 0x0E);
    while (1) {}
}
