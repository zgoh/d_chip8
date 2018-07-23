import std.string;
import std.stdio;

class Chip8
{
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
  this()
  {
    // Initialize registers and memory once

    // Basic fontset stored at 0x50 == 80 onwards

    // Application to be loaded at 0x200, pc set to 0x200 == 512
    pc = 0x200;

    opcode = 0; // Reset current opcode
    iReg   = 0; // Reset index register
    sp     = 0; // Reset stack pointer

    // Clear display
    // Clear stack
    vReg[]   = 0; // Clear registers v0-vF
    memory[] = 0; // Clear memory

    // Load fontset
    //for (int i = 0; i < 80; ++i)
      //memory[i] = chipFontset[i];

    // Reset timers
    delayTimer = 0;
    soundTimer = 0;
  }

  public void LoadGame(const string name)
  {
    // size_t bufferSize = 2048;
    
    // // Fopen with binary
    // auto f = File(name);
    // auto buf = f.rawRead(new char[bufferSize]);
    // f.close();

    // // Fill the memory at location 0x200 == 512
    // for(int i = 0; i < buf.length; ++i)
    //   memory[i + 512] = buf[i];
  }

  public void EmulateCycle()
  {
    // Fetch Opcode
    // opcode = memory[pc] << 8 | memory[pc + 1];

    // Decode Opcode
    // Execute Opcode

    pc += 2;
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