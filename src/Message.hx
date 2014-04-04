import Common;

class Message extends h2d.ScaleGrid
{
	public var texte:h2d.Text;
	public var i:h2d.Interactive;
	var game:Game;
	
	public function new() 
	{
		game = Game.inst;
		super(game.gfx.message.main[0], 8, 8);
		visible = true;
		colorKey = 0xFFFFFFFF;
		width = 400;
		height = 100;
		
		x = Const.SCENE_W / 2 - width / 2;
		y = Const.SCENE_H / 2 - height / 2;
		
		var font = Res.PressStart2P.build(12, { antiAliasing : false } );
		texte = new h2d.Text(font);
		texte.color = new h3d.Vector();
		texte.x = 20;
		texte.y = 20;
		this.addChild(texte);

		i = new h2d.Interactive(Const.SCENE_W, Const.SCENE_H, game.boardUi);
		i.onClick = function (_) {
			i.remove();
			remove();
		}
		
		game.boardUi.addChild(this);
	}
	
}

class Levelup extends h2d.ScaleGrid
{
	public var texte:h2d.Text;
	public var i:h2d.Interactive;
	var game:Game;
	
	public function new() 
	{
		game = Game.inst;
		super(game.gfx.message.main[0], 8, 8);
		visible = true;
		colorKey = 0xFFFFFFFF;
		width = 400;
		height = 100;
		
		x = Const.SCENE_W / 2 - width / 2;
		y = Const.SCENE_H / 2 - height / 2;
		
		var font = Res.PressStart2P.build(12, { antiAliasing : false } );
		texte = new h2d.Text(font);
		texte.color = new h3d.Vector();
		texte.x = 20;
		texte.y = 20;
		this.addChild(texte);

		i = new h2d.Interactive(Const.SCENE_W, Const.SCENE_H, game.boardUi);
		i.onClick = function (_) {
			i.remove();
			remove();
		}
		
		game.boardLevelup.addChild(this);
	}	
}