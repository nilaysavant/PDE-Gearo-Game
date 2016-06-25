/* GEARO GAME V0.1 Beta
 *
 * Author: Nilay Savant
 *
 * Description : 2D game with some physics and my first game
 * 
 * 
 */


// screen 0, 1, or 2
int screen = 0;

float sw = width*height/pow(10,4) + 1.5; 
//long init_time=0;
boolean jump = false, forward = false, backward = false;


// Declare Game Objects
World world;
Ground ground;
Gearo gearo;
Button start_button;


//Button Class
class Button 
{
  String label;
  float x;    // top left corner x position
  float y;    // top left corner y position
  float w;    // width of button
  float h;    // height of button
  
  Button(String labelB, float xpos, float ypos, float widthB, float heightB) 
  {
    label = labelB;
    x = xpos;
    y = ypos;
    w = widthB;
    h = heightB;
  }
  
  void draw() 
  {
    fill(218);
    stroke(141);
    rectMode(CENTER);
    rect(x,y, w, h, 10);
    textAlign(CENTER, CENTER);
    fill(0);
    textSize((w+h)/10);
    text(label, x, y);
  }
  
  boolean mouseIsOver() 
  {
    if (mouseX > (x-(w/2)) && mouseX < (x + (w/2)) && mouseY > (y-(h/2)) && mouseY < (y + (h/2))) 
    {
      return true;
    }
    return false;
  }
  boolean pressed()
  {
    if(mousePressed)
    {
    if (mouseIsOver())
    {
      return true;
    }
    }
      return false;
    
  }
}


class World
{
  float gravity = 3.5; // pixels per second square
  float air_friction = 0.002; // friction of air
  float surface_friction = 0.35; // friction of surface
  int max_height = 0; //pixels
}

// Ground Object Class
class Ground 
{
  int y = height - height/6;
  float elastic_jump_acc = 90.0;//65.0; // the higher the value, gearo jumps higher when jump button is clicked on ground
  float horizontal_acc = 15.0;//10.0; // the higher the value, gearo moves faster horizontally when foward/backward button(s) are cliked on ground
  void draw()
  {
    line(0, y, width, y);
  }
}

// Gearo Object Class
class Gearo 
{
  int size = height/10;
  
  //Position
  int X,Y; //pixels
  
  //velocity 
  float Vy, Vx;
  
  void draw()
  {
    fill(0);
    ellipse(X, Y, size, size);
  }
}


// Setup function
public void setup() 
{
  // Initilaise Game Objects
  world = new World();
  ground = new Ground();
  gearo = new Gearo();
  start_button = new Button("START" , width/2, height/2, width/2, height/4);
  
  // Size of the window
  size(800, 800, P2D); 
  
  // Initialise position of Gearo
  gearo.X = width/2; // center of screen
  gearo.Y = height/2;
  
   
}


// KEYBOARD CONTROL OF GEARO
void keyPressed()
{
  if (key == 'w') // if 'w' is pressed
  {
    jump = true;
  }
  if (key == 'd') // if 'd' is pressed
  {
    forward = true;
  }
  if (key == 'a') // if 'd' is pressed
  {
    backward = true;
  }
}
void keyReleased()
{
   if (key == 'w') // if 'w' is released
  {
    jump = false;
  }
   if (key == 'd') // if 'd' is released
  {
    forward = false;
  }
  if (key == 'a') // if 'd' is released
  {
    backward = false;
  }
  
}
//For Mouse
void mousePressed()
{
  if (screen == 1)
  {
    if ( (mouseX < width/4) && (mouseY > height/4)) // if left side down pressed
    {
      backward = true;
    }
    else if ( (mouseX > (width - width/4)) && (mouseY > height/4)) // if right side down pressed
    {
      forward = true;
    }
    else if ( (mouseX > width/4) && (mouseX < (width - width/4)) && (mouseY > (height - height/4))) // if middle down pressed
    {
      jump = true;
    }
  }
}
void mouseReleased()
{
  if (screen == 1)
  {
    if ( (mouseX < width/4) && (mouseY > height/4)) // if left side down pressed
    {
      backward = false;
    }
    else if ( (mouseX > (width - width/4)) && (mouseY > height/4)) // if right side down pressed
    {
      forward = false;
    }
    else if ( (mouseX > width/4) && (mouseX < (width - width/4)) && (mouseY > (height - height/4))) // if middle down pressed
    {
      jump = false;
    }
  }
}

// For Gravity in world 
void applyGravity()
{
  gearo.Vy += (world.gravity);   // Increases velocity by adding gravity as extra velocity gained during fall
  gearo.Y += gearo.Vy; // adds velocity to Y cordinate of Gearo
  gearo.Vy -= (gearo.Vy * world.air_friction); // Air friction to dampen increase in velocity
}
//Bounce over Ground/Surface
void makeBounceBottom(int surface)  //Argument = y cordinate of surface
{
  gearo.Y = surface - gearo.size/2; //sets Y cordinate of Gearo to just above ground surface touching ground
  gearo.Vy *=-1; // reverses the velocity 
  gearo.Vy -= (gearo.Vy * world.surface_friction); // ground friction to dampen the velocity
}
void makeBounceTop(int surface)  //Argument = y cordinate of surface
{
  gearo.Y = surface + gearo.size/2; //sets Y cordinate of Gearo to just below top surface touching top
  gearo.Vy *=-1; // reverses the velocity 
  gearo.Vy -= (gearo.Vy * world.surface_friction); // ground friction to dampen the velocity
}

void makeBounceLeft(int surface) //Argument = x cordinate of surface----BOUNCES LEFT
{
  gearo.X = surface - gearo.size/2; //sets X cordinate of Gearo
  gearo.Vx *= -1; //reverses the direction of velocity
  gearo.Vx -= (gearo.Vx * world.surface_friction);
}
void makeBounceRight(int surface) //Argument = x cordinate of surface----BOUNCES RIGHT
{
  gearo.X = surface + gearo.size/2; //sets X cordinate of Gearo
  gearo.Vx *= -1; //reverses the direction of velocity
  gearo.Vx -= (gearo.Vx * world.surface_friction);
  
}


void keepInScreen()
{
  if ((gearo.Y+gearo.size/2) > ground.y)  // if gearo moves below ground **adjusted for accuracy**
  {
    makeBounceBottom(ground.y);
  }
  if ((gearo.Y-gearo.size/2) < world.max_height)  // if gearo moves above max_height **adjusted for accuracy**
  {
    makeBounceTop(world.max_height);
  }
  if (gearo.X+(gearo.size/2) > width)  // if gearo moves beyond right end of screen
  {
    makeBounceLeft(width);
  }
  if (gearo.X-(gearo.size/2) < 0)  // if gearo moves beyond left end of screen
  {
    makeBounceRight(0);
  }
}

void applyHorizontalvelocity() // To keep Gearo moving horizontally
{
  if ((gearo.Y+gearo.size/2) >= ground.y)
  {
    gearo.X += gearo.Vx;
    gearo.Vx -= (gearo.Vx * world.surface_friction); // Surface friction to dampen increase in velocity
  }
  else if ((gearo.Y+gearo.size/2) < ground.y)
  {
    gearo.X += gearo.Vx;
    gearo.Vx -= (gearo.Vx * world.air_friction); // Air friction to dampen increase in velocity
  }
}


// Command functions
void jump() // Jump
{
  if ((gearo.Y+gearo.size/2) >= ground.y)
  {
    gearo.Vy = ground.elastic_jump_acc;
    makeBounceBottom(ground.y);
  }
}
void forward() // Forward
{
  if ((gearo.Y+gearo.size/2) >= ground.y)
  {
    gearo.Vx = ground.horizontal_acc; // Increase horizontal vel +ve X
    gearo.X += gearo.Vx; // Add vel to X cordinate
    gearo.Vx -= (gearo.Vx * world.surface_friction); // Surface friction to dampen increase in velocity
  }
  else if ((gearo.Y+gearo.size/2) < ground.y)
  {
    gearo.Vx = ground.horizontal_acc; // Increase horizontal vel +ve X
    gearo.X += gearo.Vx;
    gearo.Vx -= (gearo.Vx * world.air_friction); // Air friction to dampen increase in velocity
  }
  if (gearo.Vx < 0) //prevent Vx fro beocming negative
  {
    gearo.Vx = 0;
  }
}

void backward() // Backward
{
  if ((gearo.Y+gearo.size/2) >= ground.y)
  {
    gearo.Vx = -1 * ground.horizontal_acc; // // Increase horizontal vel -ve X
    gearo.X += gearo.Vx; // Add vel to X cordinate
    gearo.Vx -= (gearo.Vx * world.surface_friction); // Surface friction to dampen increase in velocity
  }
  else if ((gearo.Y+gearo.size/2) < ground.y)
  {
    gearo.Vx = -1 * ground.horizontal_acc; // // Increase horizontal vel -ve X
    gearo.X += gearo.Vx;
    gearo.Vx -= (gearo.Vx * world.air_friction); // Air friction to dampen increase in velocity
  }
  if (gearo.Vx > 0) //prevent Vx fro beocming positive
  {
    gearo.Vx = 0;
  }
}

// Moves gearo accordingly to jump, forward, backward, if they are true
void moveGearo()
{
  if (jump)
  {
    jump();
  }
  else if (forward)
  {
    forward();
  }
  else if (backward)
  {
    backward();
  }
  
}

void initScreen() //Initial Start Screen
{
 start_button.draw();
 if (start_button.pressed())
 {
   screen = 1;
 }
  
}

void gameScreen() //Game Screen
{
  background(255);
  stroke(0);
  noFill();
  smooth();
  strokeWeight(sw);
  
  applyGravity();
  keepInScreen();
  moveGearo();
  //applyHorizontalvelocity();
  gearo.draw();
  ground.draw();
  
}

void gameOverScreen() // Game Over Screen
{
  
}

public void draw() 
{   
  if (screen == 0)
  {
    initScreen();
  }
  else if (screen == 1)
  {
    gameScreen();
  }
  else if (screen == 2)
  {
    gameOverScreen();
  }
  
  
 
  //if (frameCount % 10 == 0) println(frameRate);
}