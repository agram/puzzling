import Common;

class Titre extends hxd.App {
	public static var inst : Titre;	
	var bmp:h2d.Bitmap;
	var bmpOmbre:h2d.Bitmap;
	var mode:Array<Mybouton>;
	public var const:Const;
	
	public var board:h2d.Layers;
	public var anims:Array<h2d.Anim>;
	
	public static var deblocage:ModeJeu = FACILE;

	override function init() {
		s2d.setFixedSize(Const.SCENE_W, Const.SCENE_H);
		engine.backgroundColor = 0xFFF1F7C1;
		board = new h2d.Layers();
		s2d.add(board, 1);
		
		bmpOmbre = new h2d.Bitmap(Res.titre.toTile());
		bmpOmbre.x = (Const.SCENE_W - 512) / 2 + 20;
		bmpOmbre.y = (Const.SCENE_H - 256) / 2 + 10 - 100;
		bmpOmbre.colorKey = 0xFFFFFF;
		bmpOmbre.alpha = 0.3;
		s2d.addChild(bmpOmbre);
		
		bmp = new h2d.Bitmap(Res.titre.toTile());
		bmp.x = (Const.SCENE_W - 512) / 2;
		bmp.y = (Const.SCENE_H - 256) / 2 - 100;
		bmp.colorKey = 0xFFFFFF;
		s2d.addChild(bmp);

		initMenuNiveau();
		
		initGfx();
		
		initAnimIntro();
	}		
	
	override function update(dt:Float) {
		if( bmp.x > (Const.SCENE_W - 512) / 2 ) bmp.x -= 10;
		if ( bmpOmbre.x < (Const.SCENE_W - 512) / 2 + 20 ) bmpOmbre.x += 10;
	}
	
	function startGame (chosenMode:ModeJeu) {
		for (b in mode) b.remove();
		bmp.remove();
		bmpOmbre.remove();
		const = new Const(chosenMode);
		
		s2d.dispose();
		Game.inst = new Game(engine);
	}
	
	public static function main() {	
		hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create(null,{compressSounds:true}));
		inst = new Titre();
	}
	
	function initMenuNiveau() {
		mode = [];
		
		//var a = new Mybouton(-30, 'Aventure');
		//a.setActif();
		//a.interactive.onRelease = function (_) { 
			//startGame(AVENTURE);
		//}
		//mode.push(a);

		var a = new Mybouton(20, 'Facile');
		a.setActif();
		a.interactive.onRelease = function (_) { 
			startGame(FACILE);
		}
		mode.push(a);

		var a = new Mybouton(50, 'Moyen');
		switch(deblocage) {
			case IMPOSSIBLE, EXPERT, DIFFICILE, MOYEN :
				a.setActif();
				a.interactive.onRelease = function (_) { 
					startGame(MOYEN);
				}
			default:
		}
		mode.push(a);

		var a = new Mybouton(80, 'Difficile');
		switch(deblocage) {
			case IMPOSSIBLE, EXPERT, DIFFICILE :
				a.setActif();
				a.interactive.onRelease = function (_) { 
					startGame(DIFFICILE);
				}
			default:
		}				
		mode.push(a);
				
		var a = new Mybouton(110, 'Expert');
		switch(deblocage) {
			case IMPOSSIBLE, EXPERT :
				a.setActif();
				a.interactive.onRelease = function (_) { 
					startGame(EXPERT);
				}
			default:		
		}				
		mode.push(a);
				
		var a = new Mybouton(140, 'Impossible');
		switch(deblocage) {
			case IMPOSSIBLE :
				a.setActif();
				a.interactive.onRelease = function (_) { 
					startGame(IMPOSSIBLE);
				}
			default:
		}				
		mode.push(a);
	}
	
	function initAnimIntro () {
		anims = [];
		var a = new h2d.Anim(gfx.soldier.warrior.stand, 4, board);
		a.x = Const.SCENE_W / 3 - 16;
		a.y = 265;
		a.colorKey = 0xFFFFFF;
		anims.push(a);
		
		var a = new h2d.Anim(gfx.soldier.archer.stand, 4, board);
		a.x = Const.SCENE_W / 3 - 16;
		a.y = 315;
		a.colorKey = 0xFFFFFF;
		anims.push(a);
		
		var a = new h2d.Anim(gfx.soldier.mage.stand, 4, board);
		a.x = Const.SCENE_W / 3 - 16;
		a.y = 365;
		a.colorKey = 0xFFFFFF;
		anims.push(a);
		
		var a = new h2d.Anim(gfx.soldier.warrior.stand, 4, board);
		a.scaleX = -1;
		a.x = Const.SCENE_W * 2 / 3 + 16;
		a.y = 265;
		a.colorKey = 0xFFFFFF;
		anims.push(a);
		
		var a = new h2d.Anim(gfx.soldier.archer.stand, 4, board);
		a.scaleX = -1;
		a.x = Const.SCENE_W * 2 / 3 + 16;
		a.y = 315;
		a.colorKey = 0xFFFFFF;
		anims.push(a);
		
		var a = new h2d.Anim(gfx.soldier.mage.stand, 4, board);
		a.scaleX = -1;
		a.x = Const.SCENE_W * 2 / 3 + 16;
		a.y = 365;
		a.colorKey = 0xFFFFFF;
		anims.push(a);
		
	}
	
	public var gfx : {
		soldier: {
			warrior: {
				stand: Array<h2d.Tile>,
				falseDead: Array<h2d.Tile>,
				finalAttack: Array<h2d.Tile>,
				weapon: Array<h2d.Tile>,
			},
			archer: {
				stand: Array<h2d.Tile>,
				falseDead: Array<h2d.Tile>,
				finalAttack: Array<h2d.Tile>,
				weapon: Array<h2d.Tile>,
			},
			mage: {
				stand: Array<h2d.Tile>,
				falseDead: Array<h2d.Tile>,
				finalAttack: Array<h2d.Tile>,
				weapon: Array<h2d.Tile>,
			},
			rien:Array<h2d.Tile>,
		},
		castle:Array<h2d.Tile>,
		message: {
			main: Array<h2d.Tile>,
			second: Array<h2d.Tile>,
		},
	};
	
	function initGfx() {
		var tileGfx = Res.gfx2.toTile();

		gfx = {
			soldier: {
				warrior: {
					stand: Tools.split(tileGfx, 0, 0, 2, 32, 32),
					falseDead: Tools.split(tileGfx, 2, 0, 2, 32, 32 ),
					finalAttack: Tools.split(tileGfx, 6, 0, 1, 32, 32),
					weapon: Tools.split(tileGfx, 0, 4, 5, 64, 64),
				},
				archer: {
					stand: Tools.split(tileGfx, 0, 1, 2, 32, 32),
					falseDead: Tools.split(tileGfx, 2, 1, 2, 32, 32),
					finalAttack: Tools.split(tileGfx, 6, 1, 2, 32, 32),
					weapon: Tools.split(tileGfx, 0, 5, 5, 64, 64),
				},
				mage: {
					stand: Tools.split(tileGfx, 0, 2, 2, 32, 32),
					falseDead: Tools.split(tileGfx, 2, 2, 2, 32, 32),
					finalAttack: Tools.split(tileGfx, 6, 2, 2, 32, 32),
					weapon: Tools.split(tileGfx, 0, 6, 5, 64, 64),
				},
				rien: Tools.split(tileGfx, 0, 3, 1),
			},
			castle: Tools.split(tileGfx, 0, 2, 1, 64, 64),
			message: {
				main: Tools.split(tileGfx, 0, 4, 1, 24, 24),
				second: Tools.split(tileGfx, 1, 11, 1, 24, 24),
			},
		};
	}
}