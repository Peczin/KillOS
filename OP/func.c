#define FRAMEBUFFER ((volatile unsigned short*)0xA0000) 
#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480

void clear_screen() {
    int pixels = SCREEN_WIDTH * SCREEN_HEIGHT;
    for (int i = 0; i < pixels; i++) {
        FRAMEBUFFER[i] = 0x0000;  
    }
}

