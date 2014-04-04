class Tools
{
	public inline static function distance(x1:Float, x2:Float, y1:Float, y2:Float) 
	{
		return hxd.Math.distance(x2 - x1, y2 - y1);
	}

	public inline static function distanceSquare(x1:Float, x2:Float, y1:Float, y2:Float) 
	{
		return hxd.Math.distanceSq(x2 - x1, y2 - y1);
	}

	public static function split(t, startX, y, nb, w = 32, h = 21, dx = 0, dy = 0 ) {
		var tab = [];
		for (i in 0...nb) {
			tab.push(t.sub(startX*w + i*w, y*h, w, h, dx, dy));
		}
		return tab;
	}

	public static function splitAdd(t, tab, startX, y, nb, w = 32, h = 21, dx = 0, dy = 0 ) {
		for (i in 0...nb) {
			tab.push(t.sub(startX*w + i*w, y*h, w, h, dx, dy));
		}
	}
	
}