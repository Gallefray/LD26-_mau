hero player;
mush enm;

void resources()
{

}

void setup()
{
	size(1024, 768);
	smooth();
	resources();
	variables();
}

void update()
{
	inputHandle();
}

void draw()
{
	scale(2, 2);
	update();
	clear();

	player.draw();
	enm.draw();
}

void variables()
{
	int scrW = displayWidth/2;
	int scrH = displayHeight/2;
	println("scrW: "+scrW);
	println("scrH: "+scrH);

	player = new hero(200, 200, 16, 16, 5);
	enm = new mush(400, 200, 'n');

	Boolean gravity = true;
	int gravitySpeed = 2;
}

void inputHandle()
{
	if(keyPressed)
	{
		if (key == CODED)
		{
			if (keyCode == LEFT)
			{
				player.x = player.x - player.speed;
			}
			else if (keyCode == RIGHT) 
			{
				player.x = player.x + player.speed;			
			}
		}
	}
}