enum ModeTwin {
	TWIN;
	SPEED;
}

class Twin
{
	var game:Game;
	public var e:Ent;
	var x:Float;
	var y:Float;
	var x2:Float;
	var y2:Float;
	var time:Int; // ceci est le temps en frames
	var compteur:Int;
	var f:Float -> Float;
	var fFinish:Void -> Void;
	var mode:ModeTwin;
	var vx:Float;
	var vy:Float;
	var frict:Float;
	
	public function new( e:Ent, x2, y2, time = 0, f:Float -> Float = null) 
	{
		game = Game.inst;
		mode = TWIN;
		this.e = e;
		this.x = e.x;
		this.y = e.y;
		this.x2 = x2;
		this.y2 = y2;
		this.time = time;
		
		frict = 1;
		
		if (f != null) this.f = f;
		else this.f = function(e) { return e; }; 
		
		fFinish = function() { };
		
		compteur = 0;
		
		for ( t in game.twins ) if (t.e == e) { game.twins.remove(t); break; }
		game.twins.push(this);
	}
	
	public function update(dt:Float) {
		switch (mode) {
		case TWIN :
			var coef = f(compteur / time);

			e.x = x + (x2 - x) * coef;
			e.y = y + (y2 - y) * coef;

			compteur++;
			if (compteur > time) kill();
		
		case SPEED :
			var tf = Math.pow(frict, dt);
			vx *= tf;
			e.x += vx * dt;
			vy *= tf;
			e.y += vy * dt;
			
			if (Tools.distanceSquare(e.x, x2, e.y, y2) < vx * vx + vy * vy + 50) {
				e.x = x2;
				e.y = y2;
				kill();
			}
			
		}
	}

	public function setTime(time) { this.time = time; }
	
	public function setToTime(time, f:Float -> Float = null) {
		mode = TWIN;
		this.time = time;
		this.f = f;
	}
	
	public function setToSpeed(coef:Float) {
		mode = SPEED;
		vx = x2 - x;
		vy = y2 - y ;
		var d = Math.sqrt(Math.pow(vx, 2) + Math.pow(vy, 2));
		var c = coef / d;
		vx *= c;
		vy *= c;
	}
	
	public function setFunction(f:Float -> Float) { this.f = f; }
	
	public function onFinish (f:Void -> Void) { this.fFinish = f;  }
	
	public function kill() {
		fFinish();
		game.twins.remove(this);
	}
	
}