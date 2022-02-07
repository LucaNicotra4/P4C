class LvlManager {
  int playerLevelX = 0, playerLevelY = 0;
  
  Lvl adjacentLvls[] = new Lvl[4];
  ArrayList<Lvl> lvls = new ArrayList<>();
  Lvl currentLvl;

  LvlManager() {
    Lvl startLvl = new Lvl(0, 0);
    this.currentLvl = startLvl;
    startLvl.unlocked = true;
    lvls.add(startLvl);
  }

  void changeLevels(String direction) {
    //allows the player to move to a new level if they've killed every enemy in the current level
    if(currentLvl.enemsKilled == currentLvl.enems.length){
      currentLvl.unlocked = true;
    }
    
    //moves levels
    if (currentLvl.unlocked) {
      switch(direction) {
      case  "up":
        playerLevelY++;
        break;
      case "down":
        playerLevelY--;
        break;
      case "left":
        playerLevelX--;
        break;
      case "right":
        playerLevelX++;
        break;
      }
      
      //queues up next lvl
      boolean hasBeenMade = false;
      int originalIndex = 0;
      for(int i = 0; i < lvls.size(); i++){
        if(lvls.get(i).lvlX == playerLevelX && lvls.get(i).lvlY == playerLevelY){
          hasBeenMade = true;
          originalIndex = i;
        }
      }
      if(hasBeenMade){
        currentLvl = lvls.get(originalIndex);
        //updates 
        currentLvl.updateLvl();
      } else{
        currentLvl = new Lvl(playerLevelX, playerLevelY);
        lvls.add(currentLvl);
      }
      
      //variable to store previous location of player
      int playerX = game.player.x;
      int playerY = game.player.y;
      
      //loads new level
      game.levelLoad();
      
      //changes location of player to "transition" between levels
      switch(direction){
        case "up":
        game.player.y = 600;
        game.player.x = playerX;
        break;
        case "down":
        game.player.y = 0;
        game.player.x = playerX;
        break;
        case "left":
        game.player.x = 800;
        game.player.y = playerY;
        break;
        case "right":
        game.player.x = 0;
        game.player.y = playerY;
      }
    }
  }
  
  //places all adjacent levels into an array 
  void setAdjacent(){
    Arrays.fill(adjacentLvls, null);
    for(int i = 0; i < lvls.size(); i++){
      //checks above level
      if(lvls.get(i).lvlX == currentLvl.lvlX && lvls.get(i).lvlY == currentLvl.lvlY + 1){
        adjacentLvls[0] = lvls.get(i);
      }
      //checks below level
      if(lvls.get(i).lvlX == currentLvl.lvlX && lvls.get(i).lvlY == currentLvl.lvlY - 1){
        adjacentLvls[1] = lvls.get(i);
      }
      //checks left level
      if(lvls.get(i).lvlX == currentLvl.lvlX - 1 && lvls.get(i).lvlY == currentLvl.lvlY){
       adjacentLvls[2] = lvls.get(i);
      }
      //checks right level
      if(lvls.get(i).lvlX == currentLvl.lvlX + 1 && lvls.get(i).lvlY == currentLvl.lvlY){
       adjacentLvls[3] = lvls.get(i);
      }
    }
  }
  
  //places visual queues showing which levels are cleared/accessible
  void addSymbols(){
    setAdjacent();
    //places a symbol based on the status of adjacent rooms 
    for(int i = 0; i < adjacentLvls.length; i++){
     if(currentLvl.unlocked){
       if(adjacentLvls[i] == null || !(adjacentLvls[i].unlocked)){
         spawnSymbols(i, "danger");
       } else {
         spawnSymbols(i, "unlocked");
       }
      } else {
        if(adjacentLvls[i] == null || !(adjacentLvls[i].unlocked)){
         spawnSymbols(i, "locked");
        } else {
         spawnSymbols(i, "unlocked");
        }
      }
    }
  }
  //method to assist addSymbols
  void spawnSymbols(int i, String name){
    switch(i){
      case 0:
       game.spawn(new StationarySprite(width/2, 0, "assets/" + name + ".png"));
       break;
       case 1:
       game.spawn(new StationarySprite(width/2, height - 50, "assets/" + name + ".png"));
       break;
       case 2:
       game.spawn(new StationarySprite(0, height/2, "assets/" + name + ".png"));
       break;
       case 3:
       game.spawn(new StationarySprite(width - 50, height/2, "assets/" + name + ".png"));
       break;
    }
  }
}
