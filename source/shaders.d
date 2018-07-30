import std.string : toStringz;
import std.stdio;
import derelict.opengl;
import derelict.glfw3.glfw3;

const string vertexShader =
  "\n"
  ~"#version 330\n"
  ~"\n"
  ~"noperspective out vec2 TexCoord;\n"
  ~"\n"
  ~"void main(void){\n"
  ~"\n"
  ~"    TexCoord.x = (gl_VertexID == 2) ? 2.0: 0.0;\n"
  ~"    TexCoord.y = (gl_VertexID == 1) ? 2.0: 0.0;\n"
  ~"    \n"
  ~"    gl_Position = vec4(2.0 * TexCoord.x - 1.0, 1.0 - 2.0 * TexCoord.y, 0.0, 1.0);\n"
  ~"}\n";

const string fragmentShader =
  "\n"
  ~"#version 330\n"
  ~"\n"
  ~"uniform sampler2D buffer;\n"
  ~"noperspective in vec2 TexCoord;\n"
  ~"\n"
  ~"out vec3 outColor;\n"
  ~"\n"
  ~"void main(void){\n"
  ~"    outColor = texture(buffer, TexCoord).rgb;\n"
  ~"}\n";

void ValidateShader(GLuint shader, string file)
{
  static const uint BUFFER_SIZE = 512;
  char[BUFFER_SIZE] buffer;
  GLsizei length = 0;

  glGetShaderInfoLog(shader, BUFFER_SIZE, &length, cast(char*)buffer);

  if (length > 0)
  {
    writeln("Shader %d(%s) compile error: %s\n", shader, (file ? file : ""), buffer);
  }
}

bool ValidateProgram(GLuint program)
{
  static const GLsizei BUFFER_SIZE = 512;
  GLchar[BUFFER_SIZE] buffer;
  GLsizei length = 0;

  glGetProgramInfoLog(program, BUFFER_SIZE, &length, cast(char*)buffer);

  if (length > 0)
  {
    writeln("Program %d link error: %s\n", program, buffer);
    return false;
  }

  return true;
}

int CreateShaders()
{
  GLuint shaderID = glCreateProgram();
  AttachShader(shaderID, GL_VERTEX_SHADER, vertexShader);
  AttachShader(shaderID, GL_FRAGMENT_SHADER, fragmentShader);
  
  glLinkProgram(shaderID);

  if (!ValidateProgram(shaderID))
  {
    writeln("Error while validating shader.");
    throw new Exception("Error while validating shader.");
  }
  
  return shaderID;
}

void AttachShader(in GLuint shaderID, in GLenum shaderType, in string shaderSource)
{
  GLuint shader = glCreateShader(shaderType);

  const char* fileData = toStringz(shaderSource);
  glShaderSource(shader, 1, &fileData, null);
  glCompileShader(shader);
  
  ValidateShader(shader, shaderSource);
  glAttachShader(shaderID, shader);
  glDeleteShader(shader);
}