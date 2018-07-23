import std.stdio;
import std.string : format, fromStringz;

import derelict.glfw3.glfw3;
import derelict.opengl;

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

void main()
{
  // Using Derelict to load openGL/GLFW
  DerelictGL3.load();
  DerelictGLFW3.load("dlls\\glfw3.dll");

  // Setting error callbacks
  glfwSetErrorCallback(&ErrorCallback);

  if (!glfwInit())
  {
    throw new Exception("glfw failed to init");
  }

  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
  
  auto window = glfwCreateWindow(800, 600, "CHIP-8", null, null);
  if (window is null)
  {
    glfwTerminate();
    throw new Exception("glfw failed to create window");
  }

  // Setting key callbacks
  glfwSetKeyCallback(window, &KeyCallback);

  glfwShowWindow(window);
  glfwMakeContextCurrent(window);

  // Turning on vsync
  glfwSwapInterval(1);

  // Reload after making context to use GL 3 core features
  DerelictGL3.reload();

  while (!glfwWindowShouldClose(window))
  {
    glfwSwapBuffers(window);
    glfwPollEvents();
  }

  glfwDestroyWindow(window);
  glfwTerminate();
}

extern(C) nothrow
{
	void ErrorCallback(int error, const(char)* description)
	{
		throw new Error(format("Error: %s : %s", error, fromStringz(description)));
  }

  void KeyCallback(GLFWwindow* window, int key, int scancode, int action, int mods)
  {
    switch(key)
    {
    case GLFW_KEY_ESCAPE:
      // if (action == GLFW_PRESS) 
      //   Game.Stop();
      break;

    case GLFW_KEY_D:
    case GLFW_KEY_RIGHT:
      // if (action == GLFW_PRESS) 
      //   playerDir += 1;
      // else if (action == GLFW_RELEASE) 
      //   playerDir -= 1;
      break;

    case GLFW_KEY_A:
    case GLFW_KEY_LEFT:
      // if (action == GLFW_PRESS) 
      //   playerDir -= 1;
      // else if (action == GLFW_RELEASE) 
      //   playerDir += 1;
      break;
    
    case GLFW_KEY_SPACE:
      //if (action == GLFW_RELEASE) 
        //firePressed = true;
      break;

    default:
      break;
    }
  } 
}