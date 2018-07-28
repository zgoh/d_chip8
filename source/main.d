import std.stdio;
import std.string : format, fromStringz;

import derelict.glfw3.glfw3;
import derelict.opengl;
import chip8;

static bool isRunning = true;
static GLFWwindow *window;
static Chip8 emulator;

void main()
{
  Init();
  Frame();
  Destroy();
}

void Init()
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
  
  window = glfwCreateWindow(800, 600, "CHIP-8", null, null);
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

  // Load the designated rom and run the emulator
  emulator = new Chip8();
  emulator.LoadGame("roms/test.ch8");
}

void Frame()
{
  while (isRunning && !glfwWindowShouldClose(window))
  {
    emulator.Run();

    // Get buffer to draw from Chip-8
    glfwSwapBuffers(window);
    glfwPollEvents();
  }
}

void Destroy()
{
  glfwDestroyWindow(window);
  glfwTerminate();
}

void Stop() nothrow
{
  isRunning = false;
}

extern(C) nothrow
{
	void ErrorCallback(int error, const(char)* description)
	{
		throw new Error(format("Error: %s : %s", error, fromStringz(description)));
  }

  void KeyCallback(GLFWwindow* window, int key, int scancode, int action, int mods)
  {
    // Keypad                   Keyboard
    // +-+-+-+-+                +-+-+-+-+
    // |1|2|3|C|                |1|2|3|4|
    // +-+-+-+-+                +-+-+-+-+
    // |4|5|6|D|                |Q|W|E|R|
    // +-+-+-+-+       =>       +-+-+-+-+
    // |7|8|9|E|                |A|S|D|F|
    // +-+-+-+-+                +-+-+-+-+
    // |A|0|B|F|                |Z|X|C|V|
    // +-+-+-+-+                +-+-+-+-+

    char keyCode = 0x1;
    char keyState;

    if (action == GLFW_PRESS)
      keyState = 1;
    else if (action == GLFW_RELEASE)
      keyState = 0;

    switch (key)
    {
    case GLFW_KEY_ESCAPE:
      if (action == GLFW_PRESS) 
        Stop();
      break;

    case GLFW_KEY_X:
      keyCode = 0x0;
      break;

    case GLFW_KEY_1:
      keyCode = 0x1;
      break;

    case GLFW_KEY_2:
      keyCode = 0x2;
      break;

    case GLFW_KEY_3:
      keyCode = 0x3;
      break;

    case GLFW_KEY_Q:
      keyCode = 0x4;
      break;

    case GLFW_KEY_W:
      keyCode = 0x5;
      break;

    case GLFW_KEY_E:
      keyCode = 0x6;
      break;

    case GLFW_KEY_A:
      keyCode = 0x7;
      break;

    case GLFW_KEY_S:
      keyCode = 0x8;
      break;

    case GLFW_KEY_D:
      keyCode = 0x9;
      break;

    case GLFW_KEY_Z:
      keyCode = 0xA;
      break;

    case GLFW_KEY_C:
      keyCode = 0xB;
      break;

    case GLFW_KEY_4:
      keyCode = 0xC;
      break;

    case GLFW_KEY_R:
      keyCode = 0xD;
      break;

    case GLFW_KEY_F:
      keyCode = 0xE;
      break;

    case GLFW_KEY_V:
      keyCode = 0xF;
      break;

    default:
      break;
    }

    if (keyCode <= 0xF)
      emulator.SetKeys(keyCode, keyState);
  } 
}