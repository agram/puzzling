import Common;

class Castle extends Ent
{
	var textePv:h2d.Text;
	var shake:Int;
	var owner:Owner;

	public function new(pv, owner) 
	{
		super(x, y, 0);
		this.owner = owner;
		
		width = 128;
		height = 128;
		
		if(owner == PLAYER) x =  - 6 * Const.TS;
		else x = Std.int(game.width + 4) * Const.TS;
			
		y = Std.int(game.const.nbTroup / 2 - 2 ) * Const.TS + 64;
		
		this.pv = pv;
		
		anim.play(game.gfx.castle);
		anim.colorKey = 0xFFFFFF;
		anim.scale(2);
		anim.x = -32;
		anim.y = -128;
		
		var font = Res.PressStart2P.build(10,{ antiAliasing : false });		
		var tf = new h2d.Text(font, this);
		tf.text = "DEFENSE";
		tf.color = new h3d.Vector(0, 0, 0);
		tf.x = Std.int((Const.TS*2 - tf.text.length*8)/2);
		tf.y = 20;

		textePv = new h2d.Text(font, this);
		textePv.text = Std.string(pv);
		textePv.color = new h3d.Vector(0, 0, 0);
		textePv.x = Std.int((Const.TS*2 - textePv.text.length*8)/2);
		textePv.y = 40;
		
		shake = 0;
	}
	
	override function update(dt:Float) {
		if (shake > 0) {
			x += Std.random(5) - 2;
			y += Std.random(5) - 2;
			shake--;
		}
		else {
			if(owner == PLAYER) x =  - 6 * Const.TS;
			else x = Std.int(game.width + 4) * Const.TS;
			y = Std.int(game.const.nbTroup / 2 - 2 ) * Const.TS + 64;
		}
	}
	
	public function animShake() {
		shake = 30;
		var cr = 5;
		for ( i in 0...100 ) {
			var part = new Part();
			part.pv = Std.random(10)+40;
			part.x = Std.random(128) + x + part.vx * cr;
			part.y = -Std.random(128) + y + part.vy * cr;
			part.frict = 0.92 + Math.random()*0.04;
		}
	}
	
	override public function looseLife(nb:Float = 1) {
		pv -= nb;
		if (pv < 0) pv = 0;
		textePv.text = Std.string(pv);
		
		animShake();
	}
}