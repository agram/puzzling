import hxd.Key in K;
import Common;

class Game extends hxd.App {
	public static var inst : Game;	
	public var ents:Array<Ent>;
	
	public var boardBackground:h2d.Layers;
	public var board:h2d.Layers;
	public var boardUi:h2d.Layers;

	public var keysActive : AllKeys;
	public var pause:Bool;

	public var width:Int;
	public var height:Int;
	public var PW:Int;
	
	public var matrix:Array<Array<Soldier>>;
	public var battle:Int;
	public var gameOver:Bool;
	
	public var playerCastle:Castle;
	public var enemyCastle:Castle;
	
	public var const:Const;
	public var ui:UI;
	
	public var timer:Float;
	public var next:Int;
	var lastY:Int;

	var easy:Bool;
	
	var position:Int;
	public var nbSoldierWin:Int;	
	
	override function init() {
		
		s2d.setFixedSize(Const.SCENE_W, Const.SCENE_H);

		const = Titre.inst.const;
		
		engine.backgroundColor = 0xFFF1F7C1;
		ents = [];

		width = const.playerWave + const.battleground + const.enemyWave;
		height = const.nbTroup;
	
		PW = const.playerWave;

		if (width * Const.TS > Const.SCENE_W) throw ('Scene de jeu plus grande que la scene');
		
		boardBackground = new h2d.Layers();
		boardUi = new h2d.Layers();
		board = new h2d.Layers();
		board.x = Std.int( (Const.SCENE_W - width * Const.TS) / 2);
		board.y = Std.int((Const.SCENE_H - height * Const.TS) / 2);
		
		s2d.add(boardBackground, Const.L_BG);
		s2d.add(board, Const.L_GAME);
		s2d.add(boardUi, Const.L_UI);
		
		//var tile = h2d.Tile.fromColor(0xFFF1F7C1, Const.SCENE_W, Const.SCENE_H);
		//new h2d.Bitmap(tile,  boardBackground);
		var tile2 = h2d.Tile.fromColor(0xFFA5C882, width * Const.TS, height * Const.TS);
		new h2d.Bitmap(tile2,  board);
		
		pause = false;
		
		initGfx();

		battle = 0;
		gameOver = false;

		matrix = [];
		for (i in 0...width) {
			matrix[i] = [];
			for (j in 0...width)
				matrix[i][j] = null;
		}

		playerCastle = new Castle(const.CASTLE_PLAYER, PLAYER);
		enemyCastle = new Castle(const.CASTLE_ENEMY, ENEMY);
		
		create(PLAYER);
		create(ENEMY, const.enemyWave);
		
		timer = const.TIMER;
		next = const.enemySupply;
		lastY = 0;

		//initInteractive();
		
		ui = new UI();
		easy = false;
		
		position = 0;
		nbSoldierWin = 0;
	}
	
	override function update( dt : Float ) {
		if ( gameOver ) {
			for (oneEnt in ents.copy()) {
				oneEnt.update(dt);
			}
			return;
		}
		
		if (enemyCastle.pv <= 0 || playerCastle.pv <= 0 ) { 
			gameOver = true;  
			var m = new Message();
			if (playerCastle.pv <= 0) {
				m.texte.text = 'Perdu !\n\nCliquer pour revenir au menu';
				m.i.onClick = function (_) {
					m.i.remove();
					m.remove();
					s2d.dispose();
					Titre.inst = new Titre(engine);
				}
			}
			else {
				m.texte.text = 'Gagné !\n\n\nCliquer pour revenir au menu';
				m.i.onClick = function (_) {
					m.i.remove();
					m.remove();
					s2d.dispose();
					switch(const.chosenMode) {
						case IMPOSSIBLE, EXPERT: 
							Titre.deblocage = IMPOSSIBLE;
						case DIFFICILE: 
							switch(Titre.deblocage) {
								case IMPOSSIBLE :
								default : Titre.deblocage = EXPERT;
							}
						case MOYEN: 
							switch(Titre.deblocage) {
								case IMPOSSIBLE, EXPERT :
								default : Titre.deblocage = DIFFICILE;
							}
						case FACILE: 
							switch(Titre.deblocage) {
								case IMPOSSIBLE, EXPERT, DIFFICILE :
								default : Titre.deblocage = MOYEN;
							}
					}
					Titre.inst = new Titre(engine);
				}
			}
			return;
		}

		if ( hxd.Key.isPressed("P".code) ) pause = !pause;
		if (pause) return;

		if ( hxd.Key.isDown("S".code) ) dt *= 0.2;
		
		traitementClavier();
		
		if (!gameOver && !soldierMoving() && !isBattle()) {
			if (keysActive.up) {
				moveUp();
			}
			else if (keysActive.down) {
				moveDown();
			}
			else if (keysActive.right) {
				moveRight();
			}
		}
		
		// Si tous les soldats sont arrivés à destination, on résoud le combat. 
		// Sinon, cela signifie simplement que le joueur est train de réfléchir, donc on met à jour le timer.
		if (!soldierMoving()) {
			if (isBattle())	resolveBattle();
			else updateTimer();
		}
		
		for (oneEnt in ents.copy()) {
			oneEnt.update(dt);
		}
		//engine.render(s2d);
	}

	function traitementClavier() {
		keysActive = {
			up : K.isPressed(K.UP),
			down : K.isPressed(K.DOWN),
			right : K.isPressed(K.RIGHT),
		}
				
	}
	
	function moveRight() {
		next = const.enemySupply + ((timer < const.TIMER / 2 ) ? 1 : 0);
		ui.time.text = 'Attack !';
		clean();
		battle = 1;	
		easy = false;
	}
	
	function moveUp() {
		if (position == 0) position = const.nbTroup - 1;
		else position -= 1;
		scroll(position); 
		clean();
		if(easy) {
			falseCharge();
		}
		for (i in 0...width) {
			for (j in 0...height) {
				var soldier = matrix[i][j];
				if(soldier != null && soldier.owner == PLAYER)
					soldier.put(i,j);
			}
		}
	}
	
	function moveDown () {
		if (position == const.nbTroup) position = 1;
		else position += 1;
		scroll(position); 
		clean();
		if(easy) {
			falseCharge();
		}
		for (i in 0...width) {
			for (j in 0...height) {
				var soldier = matrix[i][j];
				if(soldier != null && soldier.owner == PLAYER)
					soldier.put(i,j);
			}
		}
	}
	
	public function create(owner, nb = 0) 
	{
		switch(owner) {
			case PLAYER:
				for (i in 0...PW) {
					for (j in 0...height) {
						matrix[i][j] = new Soldier(owner, i, j);
					}
				}
			case ENEMY:
				for (i in 0...width) {
					for (j in 0...height) {
						var soldier = matrix[i][j];
						if (soldier != null && soldier.owner == ENEMY && soldier.state != WIN) {
							soldier.chargeEnemyPlusRenfort(i, j, nb);
						}
					}
				}
				
				for (i in 0...nb) {
					for (j in 0...height) {
						var ii = width + i - nb;
						if(matrix[ii][j] != null) matrix[ii][j].kill();
							matrix[ii][j] =  new Soldier(owner,ii, j);
					}
				}
		}
	}

	public function soldierMoving()	{		
		var nbMovingSoldier = 0;
		for (i in 0...width) {
			for (j in 0...height) {
				var soldier = matrix[i][j];
				if (soldier != null ) {
					nbMovingSoldier += soldier.isMoving(i, j);
				}
			}
		}
		return (nbMovingSoldier > 0);
	}

	public function scroll(numCase:Int) {
		if (numCase != lastY) {
			var mtemp = [];
			for (i in 0...PW) 
				mtemp[i] = [];
				
			for (i in 0...PW) {
				for (j in 0...height) {
					var newNum = (numCase - lastY + j + height) % height;
					mtemp[i][newNum] = matrix[i][j];
					matrix[i][j] = null;
				}
			}
			for (i in 0...PW) {
				for (j in 0...height) {
					matrix[i][j] = mtemp[i][j];
				}
			}
			lastY = numCase;
		}
	}
		
	function resolveBattle() {
		if( battle == 1) {
			var count = 0;
			var i = width - 1;
			
			while( i >= 0) {
				var j = height - 1;
				while( j >= 0 ){
					var soldier = matrix[i][j];
					if(soldier != null && soldier.owner == PLAYER) {
						count += soldier.moveOneStepFighting(i, j);
					}
					j--;
				}
				i--;
			}
			
			if (count == 0) battle = 2;
		}
		if (battle == 2 && nbSoldierWin == 0) {
			battle = 3;
			create(ENEMY, next);
		}
		
		if (battle == 3 && nbSoldierWin == 0) {
			create(PLAYER);
			timer = const.TIMER;
			
			battle = 0;
		}
	}
	
	function isBattle() {
		return battle > 0;
	}
	
	function falseCharge() {
		var i = PW-1;
		while (i != -1) {
			for (j in 0...height)
				matrix[i][j].falseCharge(j);
			i--;
		}
	}
	
	function updateTimer() {
		timer = Math.round((timer - 1 / 60) * 100) / 100; 
		ui.time.text = 'Charge dans ' + Std.string(timer) + ' s';
		if (timer <= const.TIMER / 2) {
			if (easy == false) {
				falseCharge();
			}
			easy = true;
		}
		if (timer < 0) {
			next = const.enemySupply + 2;
			timer = 0;
			ui.time.text = 'Attack !';
			clean();
			battle = 1;	
			easy = false;
		}
	}
	
	public function clean() {
		for (i in 0...width)
			for (j in 0...height)
				if(matrix[i][j] != null)
					matrix[i][j].state = STAND;
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
					weapon: Tools.split(tileGfx, 0, 3, 5, 64, 64),
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
					finalAttack: Tools.split(tileGfx, 6, 2, 5, 32, 32),
					weapon: Tools.split(tileGfx, 0, 7, 5, 64, 64),
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

	function js( s : String ) {
		if( !flash.external.ExternalInterface.available )
				return;
		flash.external.ExternalInterface.call("eval", s);
	}
		
	// --- 
	public static function main() {	
		//hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create(null,{compressSounds:true}));
		inst = new Game();
	}	
	
}