import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class warmup extends PApplet {

hero player;
mush enm;

public void resources()
{

}

public void setup()
{
	size(1024, 768);
	smooth();
	resources();
	variables();
}

public void update()
{
	inputHandle();
}

public void draw()
{
	scale(2, 2);
	update();
	clear();

	player.draw();
	enm.draw();
}

public void variables()
{
	int scrW = displayWidth/2;
	int scrH = displayHeight/2;
	println("scrW: "+scrW);
	println("scrH: "+scrH);

	player = new hero(200, 200, 16, 16, 5);
	enm = new mush(400, 200, 'n');
}

public void inputHandle()
{
	if(keyPressed)
	{
		if (key == CODED)
		{
			if (keyCode == LEFT)
			{
				player.x = player.x - player.speed;
				// println("hahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahahaha");
			}
			else if (keyCode == RIGHT) 
			{
				player.x = player.x + player.speed;			
			}
		}
	}
}
class hero
{
	float x, y, h, w, speed;

	hero(float tmpX, float tmpY, float tmpH, float tmpW, float tmpSpeed)
	{
		x = tmpX;
		y = tmpY;
		h = tmpH;
		w = tmpW;
		speed = tmpSpeed;
	}

	public void draw()
	{
		fill(255, 0, 0);
		rect(x, y, h, w, 5);
	}
};

class mush
{
	float x, y;
	char dir;

	mush(float tmpX, float tmpY, char tmpDir)
	{
		x = tmpX;
		y = tmpY;
		dir = tmpDir;
	}

	public void draw()
	{
		fill(0, 0, 255);
		rect(x, y, 8, 8);
	}

	// void findPlayer()
	// {
	// 	if (player.x < x)
	// 	{
	// 		dir = "l";
	// 	}
	// 	else if (player.x > x)
	// 	{
	// 		dir = "r";
	// 	}
	// }

	// void move()
	// {

	// }

};
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "warmup" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
