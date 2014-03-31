import hxd.Key in K;

enum ModeJeu {
	FACILE;
	MOYEN;
	DIFFICILE;
	EXPERT;
	IMPOSSIBLE;
}

typedef AllKeys = { 
	up : Bool, 
	down : Bool, 
	right : Bool, 
};

enum SoldierType {
	WARRIOR;
	ARCHER;
	MAGE;
}

enum Owner {
	PLAYER;
	ENEMY;
}

typedef Res = hxd.Res;

enum ResFight {
	NUL;
	WIN;
	DEFEAT;
}

enum MoveType {
	
}