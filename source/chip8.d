import std.string;

// 35 opcodes which are all 2 bytes long
ushort opcode;

// 4K memory in total
char[4096] memory;

// 16 8-bit data registers, V0 - VF(Flag for some registers)
char[16] vReg;

// 16-bit wide Index register (address)
ushort iReg;

// 16-bit PC
ushort pc;

// 0x000-0x1FF - Chip 8 interpreter (contains font set in emu)
// 0x050-0x0A0 - Used for the built in 4x5 pixel font set (0-F)
// 0x200-0xFFF - Program ROM and work RAM

// Screen size: 64 x 32 = 2048 px
char[2048] screen;

// Interrupts and hardware registers, CHIP-8 has none, but there are two timer that count ay 60 Hz,
// will count down if set above zero.
char delayTimer;

// Buzzer will sound when sound timer reaches 0.
char soundTimer;

// Stack and stack pointer
ushort[16] stack;
ushort sp;

// Hex based keypad, 0x0 - 0xF
char[16] keys;

class Chip8
{
  this()
  {
    // Initialize registers and memory once
  }

  public void LoadGame(const string name)
  {
  }

  public void EmulateCycle()
  {
    // Fetch Opcode
    // opcode = memory[pc] << 8 | memory[pc + 1];

    // Decode Opcode
    // Execute Opcode

    // Update timers
  }

  bool drawFlag;
  public bool DrawFlag() 
  { 
    return drawFlag; 
  }

  public void SetKeys()
  {
  }
}