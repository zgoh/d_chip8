/*
    Tool to generate a test CHIP-8 rom
*/

#include <stdio.h>

char game[] = {
    // Opcode     // Functionality
    // 0x00, 0xEE,   // 00EE: Return from subroutine
    
    // 0x21, 0x23,   // 2NNN: Call subroutine at 123
    // 0x31, 0x00,   // 3XNN: Skips the next instruction if V1 equals 23
    // 0x41, 0x00,   // 4XNN: Skips the next instruction if V1 not equals 12
    // 0x51, 0x20,   // 5XY0: Skips the next instruction if V1 equals V2
    0x63, 0x81,   // 6XNN: Set V3 to FF
    0x64, 0x83,   // 6XNN: Set V4 to 128
    // 0x74, 0x30,   // 7XNN: Adds 30 to V4. (Carry flag is not changed) 
    // 0x83, 0x40,   // 8XY0: Sets V3 to the value of V4.
    // 0x83, 0x41,   // 8XY1: Sets V3 to V3 or V4. (Bitwise OR operation)
    // 0x83, 0x42,   // 8XY2: Sets V3 to V3 and V4. (Bitwise AND operation) 
    // 0x83, 0x43,   // 8XY3: Sets V3 to V3 xor V4. 
    // 0x83, 0x44,   // 8XY4: Adds V4 to V3. VF is set to 1 when there's a carry, and to 0 when there isn't. 
    // 0x83, 0x45,   // 8XY5: V4 is subtracted from V3. VF is set to 0 when there's a borrow, and 1 when there isn't. 
    // 0x83, 0x46,   // 8XY6: Shifts V4 right by one and stores the result to V3 (V4 remains unchanged). VF is set to the value of the least significant bit of VY before the shift.
    // 0x83, 0x47,   // 8XY7: Sets V3 to V4 minus V3. VF is set to 0 when there's a borrow, and 1 when there isn't. 
    // 0x83, 0x4E,   // 8XYE: Shifts V4 left by one and copies the result to V3. VF is set to the value of the most significant bit of VY before the shift.
    0x93, 0x40,   // 9XY1: Skips the next instruction if VX doesn't equal VY. (Usually the next instruction is a jump to skip a code block) 
    // 0xA1, 0x23    // ANNN: Set I to 291
};

int main(void)
{
    const size_t sz = sizeof(game);

    FILE *file = fopen("../roms/test.ch8", "wb");
    if (file)
    {
        fwrite(game, sizeof(char), sz, file);
    }

    fclose(file);
    return 0;
}