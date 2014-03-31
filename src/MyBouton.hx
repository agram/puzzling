import Common;

class Mybouton extends h2d.Text
{
	var titre:Titre;
	public var interactive:h2d.Interactive;
	
	public function new(y, t, actif = true) 
	{
		
		titre = Titre.inst;
		var font = Res.PressStart2P.build(14, { antiAliasing : false } );
		super(font, titre.board);

		this.y = y + 250;
		
		color = new h3d.Vector();
		text = t;
		x = Std.int(( Const.SCENE_W - text.length * 14) / 2);
		
		if(actif) {
			interactive = new h2d.Interactive(text.length * 14, 20, this);
			interactive.onOver = function (_) {
				alpha = 0.6;
			}
			interactive.onOut = function (_) {
				alpha = 1;
			}
			interactive.onPush = function (_) {
				alpha = 0.3;
			}
		}
		else 
			alpha = 0.3;
	}
	
}