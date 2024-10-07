#include <stdint.h>
#include "main.h"

void print_string(const char* str);
void kernel_main(void);
void panic(const char* message);

void init_vga_buffer() {
    uint16_t* vga_control = (uint16_t*)0x3D4;
    *vga_control = 0x03;
    uint16_t* vga_buffer = (uint16_t*)0xB8000;
    for (int i = 0; i < 80 * 25; i++) {
        vga_buffer[i] = 0x0200;
    }
}

void print_string(const char* str) {
    uint16_t* vga_buffer = (uint16_t*)0xB8000;
    int offset = 0;
    while (*str) {
        if (offset >= 80 * 25) {
            break;
        }
        vga_buffer[offset] = (*str & 0xFF) | (0x0F << 8);
        offset++;
        str++;
    }
    if (offset < 80 * 25) {
        vga_buffer[offset] = ('\n' & 0xFF) | (0x0F << 8);
    }
}

void kernel_main() {
    init_vga_buffer();
    print_string("Hello niggaOS");
    while (1) {}
}

void panic(const char* message) {
    print_string("Panic");
    while (1) {}
}
