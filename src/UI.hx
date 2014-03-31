import Common;

class UI
{
	var game:Game;
	var inst:UI;
	
	var interactiveEasymode:h2d.Interactive;
	
	var backgroundEasymode:h2d.Graphics;
	
	public var time:h2d.Text;
	
	public function new() 
	{
		game = Game.inst;
		
		var font = Res.PressStart2P.build(12,{ antiAliasing : false });		
		
		time = new h2d.Text(font, game.boardUi);
		time.color = new h3d.Vector(0, 0, 0);
		time.x = 360;
		time.y = ( Const.SCENE_H - game.const.nbTroup * 32 ) / 2 - 40;
	}
	
}