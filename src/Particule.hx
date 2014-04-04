enum FadeType {
	NONE;
	COLOR_ALPHA_FADE(color:Int);	
}
class Particule extends Ent {
	
	public var fadeLimit:Int;
	public var fadeType:FadeType;
	public var graph:h2d.Graphics;
	
	public function new (type: PartType, layer:Int = -1)
	{
		if(layer == -1)
			super(Const.L_UI);
		else 
			super(layer);
		fadeType = NONE;
		fadeLimit = 10;
		pv = 10;
		
		graph = new h2d.Graphics(this);
		vx = 0;
		vy = 0;
		this.type = type;
	}
	
	override function kill() {
		super.kill();
		graph.clear();
	}
	
	override public function update ()
	{
		super.update();
		
		pv -= vpv;
		if (pv == 0) kill();
		if (pv < fadeLimit ) 
		{
			var coef = pv / fadeLimit;
			switch(fadeType) {
				case NONE:
				case COLOR_ALPHA_FADE(c): 
					graph.colorAdd = new h3d.Vector(1 - coef, 1 - coef, 1 - coef, coef-1);
			}
		}
		
		switch(type) {
			case STAR: if (x < 0 ) x = Const.WIDTH;
			default:
		}
	}
	
}