import Common;

enum State {
	STAND;
	FALSE_DEAD;
	DEAD;
	FIGHT;
	WIN;
}

class Soldier extends Ent
{
	public var owner:Owner;
	public var type:SoldierType;
	public var falseDead:Bool;
	public var state(default, set):State;
	var fighting:Int;
	var dying:Int;
	var i:Int;
	var j:Int;
	var gfx: {
		stand: Array<h2d.Tile>,
		falseDead: Array<h2d.Tile>,
	};

	var texte:h2d.Text;
	
	var goalCastle: {
		x:Int, 
		y:Int
	};
	
	var masque:h2d.Bitmap;
	
	var animWeapon:h2d.Anim;
	
	public function new(owner, i, j) 
	{
		super(0, 0);
		
		switch(owner) {
			case PLAYER : 
				x = game.playerCastle.x + Const.TS / 2;
				y = game.playerCastle.y;
				
				vx += (i * Const.TS - x) / 100 ;
				vy += (j * Const.TS - y) / 100 ;
				var d = Math.sqrt(Math.pow(vx, 2) + Math.pow(vy, 2));
				var coeff = Const.SUPPLYSPEED / d;
				vx *= coeff;
				vy *= coeff;

			case ENEMY : 
				x = game.enemyCastle.x + Const.TS / 2;
				y = game.enemyCastle.y;
				
				vx += (i * Const.TS - x) / 100 ;
				vy += (j * Const.TS - y) / 100 ;
				var d = Math.sqrt(Math.pow(vx, 2) + Math.pow(vy, 2));
				var coeff = Const.SUPPLYSPEED / d;
				vx *= coeff;
				vy *= coeff;
		}

		this.i = i;
		this.j = j;
		
		width = height = 32;
		
		this.owner = owner;
		var all = SoldierType.createAll();
		type = all[Std.random(all.length)];

		switch(type) {
			case WARRIOR : gfx = game.gfx.soldier.warrior;
			case ARCHER : gfx = game.gfx.soldier.archer;
			case MAGE : gfx = game.gfx.soldier.mage;
		}
		
		state = STAND;
		anim.colorKey = 0xFFFFFF;
		
		initAnim();
		
		fighting = 0;
		dying = 0;
		
		var tile = h2d.Tile.fromColor(0xFFFFFFFF, Std.int(width), Std.int(height));
		masque = new h2d.Bitmap(tile, this);
		masque.alpha = 0;
		this.addChild(masque);
	}
	
	function set_state(v:State) {
		state = v;
		switch(state) {
			case STAND, DEAD : anim.play(gfx.stand);
			case FALSE_DEAD : anim.play(gfx.falseDead);
			case FIGHT : anim.play(game.gfx.soldier.rien);
				masque.alpha = 1;
			case WIN: 
				game.matrix[i][j] = null;
				switch(owner) {
					case PLAYER: 
						goalCastle = {
							x: Std.int(game.enemyCastle.x + Std.random(100) - 50) , 
							y: Std.int(game.enemyCastle.y + Std.random(100) - 50) , 
						}
					case ENEMY:
						goalCastle = {
							x: Std.int(game.playerCastle.x + Std.random(100) - 50) , 
							y: Std.int(game.playerCastle.y + Std.random(100) - 50) , 
						}
				}
				vx += (goalCastle.x - x) / 100 ;
				vy += (goalCastle.y - y) / 100 ;
				var d = Math.sqrt(Math.pow(vx, 2) + Math.pow(vy, 2));
				var coeff = Const.ASSAULTSPEED / d;
				vx *= coeff;
				vy *= coeff;
				
				game.nbSoldierWin++;
		}
		return state;
	}
	
	override public function update(dt:Float) {
		super.update(dt);
		
		masque.alpha *= 0.93;

		switch(state) {
			case WIN :
				if (Tools.distanceSquare(x, goalCastle.x, y, goalCastle.y) < 900 && !dead) {
					vx = vy = 0;
					dead = true;
					death = 30;
					anim.play(
						switch(type) {
							case WARRIOR : game.gfx.soldier.warrior.finalAttack;
							case ARCHER : game.gfx.soldier.archer.finalAttack;
							case MAGE : game.gfx.soldier.mage.finalAttack;
						});
					anim.speed = 20;
					anim.loop = false;
					animWeapon = new h2d.Anim();
					animWeapon.colorKey = 0xFFFFFF;
					animWeapon.speed = 10;
					animWeapon.y = -32;
					animWeapon.loop = false;
					if (owner == ENEMY) {
						animWeapon.scaleX = -1;
						animWeapon.x = 32;
					}
					this.addChild(animWeapon);
					animWeapon.play(
						switch(type) {
							case WARRIOR : game.gfx.soldier.warrior.weapon;
							case ARCHER : game.gfx.soldier.archer.weapon;
							case MAGE : game.gfx.soldier.mage.weapon;
						});
						//switch(owner) {
							//case PLAYER:game.enemyCastle.animShake();
							//case ENEMY:game.playerCastle.animShake();
						//}
					}
					
			case DEAD :
				anim.scaleY = dying / Const.DEATHSPEED;
				anim.y += Const.TS / Const.DEATHSPEED;
				if (dying == 0) {
					kill();
				}
				else dying--;
			case FIGHT:
				anim.colorAdd = new h3d.Vector (0.1);
				if (fighting == 0) {
					var opponent = game.matrix[i + 1][j];
					state = STAND;
					var res = fight(opponent.type);
					switch(res) {
						case WIN : 
							opponent.die(); 
						case DEFEAT : 
							die(); 
						case NUL : 
							opponent.die(); 
							die(); 
					}
				}
				else {
					fighting--;
				}
			default:
		}
	}
	
	function initAnim() {
		if (owner == ENEMY) { 
			anim.scaleX = -1;
			anim.x += Const.TS;
		}
		switch(type) {
			case WARRIOR : anim.speed = 2;
			case ARCHER : anim.speed = 1.5;
			case MAGE : anim.speed = 1;
			default : anim.speed = 1;
		}
	}
	
	public function falseCharge(j) {
		for (k in 0...game.width) {
			var opponent = game.matrix[k][j];
			if (opponent != null && opponent.owner == ENEMY && opponent.state != DEAD && opponent.state != FALSE_DEAD) {
				var res = fight(opponent.type);
				switch(res) {
					case WIN : 
						opponent.state = FALSE_DEAD;
					case DEFEAT : 
						state = FALSE_DEAD;
						return false;
					case NUL : 
						opponent.state = FALSE_DEAD;
						state = FALSE_DEAD;
						return false;
				}
			}
		}
			
		return true;
	}
		
	public function fight(opponentType) {
		switch (type) {
			case WARRIOR :
				switch (opponentType) {
					case WARRIOR: return NUL;
					case ARCHER: return WIN;
					case MAGE: return DEFEAT;
				}
			case ARCHER:
				switch (opponentType) {
					case WARRIOR: return DEFEAT;
					case ARCHER: return NUL;
					case MAGE: return WIN;
				}
			case MAGE:
				switch (opponentType) {
					case WARRIOR: return WIN;
					case ARCHER: return DEFEAT;
					case MAGE: return NUL;
				}
		}
	}
	
	public function chargeEnemyPlusRenfort(i, j, nb) {
		if (i - nb < game.const.playerWave) state = WIN;
		else {
			game.matrix[i - nb][j] = this;
			this.i = i - nb;
			this.j = j;
			game.matrix[i][j] = null;
			x = i * Const.TS;
			y = j * Const.TS;
			vx = -Const.SUPPLYSPEED;
			vy = 0;
		}

	}
	
	public function moveOneStepFighting(i, j) {
		this.i = i;
		this.j = j;

		if (state == DEAD) return 1;
		
		if (i >= game.width - 1) {
			state = WIN;
			return 1;
		}

		var opponent = game.matrix[i + 1][j];
		
		if (opponent == null) {
			game.matrix[i + 1][j] = this;
			game.matrix[i][j] = null;
			vx = Const.MOVESPEED;
			return 1;
		}
		
		if (opponent.state == DEAD) {
			return 1;
		}
		
		switch(opponent.owner) {
			case PLAYER: return 1;
			case ENEMY:
				if ( state != FIGHT) {
					state = FIGHT;
					opponent.masque.alpha = 1;
				}
				return 1;
		}
	}

	public function isMoving(i, j) {
		if(state != WIN && Tools.distance(i * Const.TS, x, j * Const.TS, y) < 10) {
			x = i * Const.TS;
			y = j * Const.TS;
			vx = 0;
			vy = 0;
			return 0;
		}
		return 1;
	}
	
	function die() {
		state = DEAD;
		dying = Const.DEATHSPEED;
	}
	
	override public function kill () {
		if (state == WIN) {
			game.nbSoldierWin--;
			if(owner == PLAYER) game.enemyCastle.looseLife();
			else if(owner == ENEMY) game.playerCastle.looseLife();
		}
		
		if(state != WIN) game.matrix[i][j] = null;
		anim.remove();
		super.kill();
	}
	
	public function put (i, j) {
		x = i * Const.TS;
		y = j * Const.TS;
	}
	
	
}