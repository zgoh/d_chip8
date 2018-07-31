import std.stdio;
import std.string : format, fromStringz;

import derelict.glfw3.glfw3;
import derelict.opengl;
import chip8;
import shaders;
import core.thread;

static bool isRunning = true;
static GLFWwindow *window;
static Chip8 emulator;

static GLuint fullscreenTriangleVAO;

const static bool stepMode = false;
static bool hasStep = false;

void main()
{
  Init();
  Frame();
  Destroy();
}

void Init()
{
  // Load the designated rom and run the emulator
  emulator = new Chip8();
  emulator.LoadGame("roms/pong.ch8");

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

  const auto width = emulator.GetWidth();
  const auto height = emulator.GetHeight();
  const auto buffer = GetBuffer(emulator.GetScreen(), width, height);
  
  window = glfwCreateWindow(width * 5, height * 5, "CHIP-8", null, null);
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

  // Create textures for the buffer
  GLuint bufferTexture;
  glGenTextures(1, &bufferTexture);
  glBindTexture(GL_TEXTURE_2D, bufferTexture);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB8, width, height, 0, GL_RGBA, GL_UNSIGNED_INT_8_8_8_8, cast(char *)buffer);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

  // Create a triangular mesh for drawing background
  glGenVertexArrays(1, &fullscreenTriangleVAO);

  // Create a default shader
  const auto shaderID = CreateShaders();
  glUseProgram(shaderID);

  GLint location = glGetUniformLocation(shaderID, "buffer");
  glUniform1i(location, 0);

  glDisable(GL_DEPTH_TEST);
  glActiveTexture(GL_TEXTURE0);
  glBindVertexArray(fullscreenTriangleVAO);
}

void Frame()
{
  const auto width = emulator.GetWidth();
  const auto height = emulator.GetHeight();

  while (isRunning && !glfwWindowShouldClose(window))
  {
    if (stepMode)
    {
      // Wait for key press before proceed to emulate
      if (!hasStep)
      {
        // Get buffer to draw from Chip-8
        glfwSwapBuffers(window);
        glfwPollEvents();

        continue;
      }
      hasStep = false;
    }
    emulator.Run();
    if (emulator.DrawFlag())
    {
      const auto buffer = GetBuffer(emulator.GetScreen(), width, height);
      glTexSubImage2D(
        GL_TEXTURE_2D, 0, 0, 0,
        width, height,
        GL_RGBA, GL_UNSIGNED_INT_8_8_8_8,
        cast(char *)buffer
      );
    }

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    // Get buffer to draw from Chip-8
    glfwSwapBuffers(window);
    glfwPollEvents();

    //Thread.sleep(dur!("msecs")(1));
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

uint[] GetBuffer(const char[] screen, size_t width, size_t height)
{
  uint[] buffer = new uint[width * height];

  for (int i = 0; i < screen.length; ++i)
  {
    // CHIP 8 supports Black/White
    buffer[i] = screen[i] == 0 ? 0x000000FF : 0xFFFFFFFF;
  }

  return buffer;
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
    char keyState = 0;

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

    case GLFW_KEY_SPACE:
      if (action == GLFW_PRESS)
        hasStep = true;
      break;
    
    /*
      CHIP-8 Keys
    */
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