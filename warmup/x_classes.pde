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

	void draw()
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

	void draw()
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