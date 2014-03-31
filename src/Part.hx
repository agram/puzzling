import Common;

class Part extends Ent {
	
	public var fadeLimit:Int;
	
	public function new ()
	{
		super(0, 0, Const.L_BG);
		fadeLimit = 10;
		pv = 10;
		mc = new h2d.Graphics(this);		
		vx = 0;
		vy = 0;

		pv = 20;
		var angle = Math.random() * 2 * Math.PI;
		var speed = Math.random()*3;
		vx = Math.cos(angle)*speed;
		vy = Math.sin(angle)*speed;
		mc.beginFill(0x000000, 1);
		mc.drawCircle(0, 0, 1);
		mc.endFill();
	}
	
	override function kill() {
		super.kill();
		mc.clear();
	}
	
	override public function update (dt:Float)
	{
		super.update(dt);
		
		pv--;
		
		if (pv == 0) kill();
		
		if (pv < fadeLimit ) 
		{
			var coef = pv / fadeLimit;
			mc.colorAdd = new h3d.Vector(1 - coef, 1 - coef, 1 - coef, coef-1);
		}
		
	}
}