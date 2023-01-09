
Button[][] testButtons;
PImage bomb, flag;
boolean hasLost, hasWon, allBombsAreFlagged, allNonBombsAreNotFlagged, firstClick;


void setup(){
  size(1000,1000);
  background(255);
  strokeWeight(1.5);
  textAlign(CENTER);
  textSize(40);
  bomb = loadImage("bomb.png");
  flag = loadImage("flag.png");
  hasLost = false;
  hasWon = false;
  firstClick = true;
  
  testButtons = new Button[20][20];
  for(int row = 0; row<20; row++){
    for(int col = 0; col<20; col++){
      if(Math.random()<0.25)
        testButtons[row][col] = new Button(col*50+25, row*50+25, 50, true, row, col);
      else
        testButtons[row][col] = new Button(col*50+25, row*50+25, 50, false, row, col);
    }
  }
}
void draw(){
  background(255);
  allBombsAreFlagged = true;
  allNonBombsAreNotFlagged = true;
  fill(255,0,0);
  for(Button[] row:testButtons){
    for(Button button:row){
      button.show();
      button.setNum(4);
      if(button.isBomb() && !button.isFlagged()){
        allBombsAreFlagged = false;
      }
      if(button.isFlagged() && !button.isBomb())
        allNonBombsAreNotFlagged = false;
    }
  }
  if(allBombsAreFlagged && allNonBombsAreNotFlagged)
    hasWon = true;
  if(hasLost){
    fill(255,0,0);
    textSize(100);
    text("YOU LOSE", 500, 500);
    textSize(40);
  }
  if(hasWon){
    fill(0,255,0);
    textSize(100);
    text("YOU WIN", 500, 500);
    textSize(40);
  }
}
void mousePressed(){
  if(!hasLost || !hasWon){
    for(Button[] row:testButtons){
      for(Button button:row){
        if(Math.abs(mouseX-button.getX())<25 && Math.abs(mouseY-button.getY())<25){
          if(mouseButton == LEFT){
            if(firstClick){
              button.removeAdjacentBombs();
              button.setNum(0); 
              firstClick = false;
              setNums();
            }
            button.onLClick();
          }
          if(mouseButton == RIGHT)
            button.onRClick();
        }
      }
    }
  }
}

public int adjacentBombs(int row, int col){
  int count = 0;
  for(int r = row-1; r<=row+1;r++){
    for(int c = col-1; c<=col+1;c++){
      if(!(r==row && c==col) && isValidOnNbyN(20, 20, r,c) && testButtons[r][c].isBomb())
        count++;
    }
  }
  return count;
}

public boolean allAdjacentBombsAreFlagged(int row, int col){
  for(int r = row-1; r<=row+1;r++){
    for(int c = col-1; c<=col+1;c++){
      if(!(r==row && c==col) && isValidOnNbyN(20, 20, r,c) && testButtons[r][c].isBomb() && !testButtons[r][c].isFlagged())
        return false;
    }
  }
  return true;
}

public void removeBombs(int row, int col){
  for(int r = row-1; r<=row+1;r++){
    for(int c = col-1; c<=col+1;c++){
      if(isValidOnNbyN(20, 20, r,c) && testButtons[r][c].isBomb())
        testButtons[r][c].setIsBomb(false);
    }
  }
}
public void uncoverAdjacent(int row, int col){
  for(int r = row-1; r<=row+1;r++){
    for(int c = col-1; c<=col+1;c++){
      if(isValidOnNbyN(20, 20, r,c) && !testButtons[r][c].isFlagged()){
        if(testButtons[r][c].getNum() == 0)
          uncover0s(r, c);
        testButtons[r][c].uncover(); 
      }
    }
  }
}

public boolean hasAdjacent0(int row, int col){
  for(int r = row-1; r<=row+1;r++){
    for(int c = col-1; c<=col+1;c++){
      if(!(r==row && c==col) && isValidOnNbyN(20, 20, r,c) && testButtons[r][c].getNum()==0)
        return true;
    }
  }
  return false;
}

public boolean isValidOnNbyN(int NUM_ROWS, int NUM_COLS, int row, int col){
  return (!(row<0 || row>=NUM_ROWS || col<0 || col>=NUM_COLS));
}

public void uncover0s(int row, int col){
  if(!isValidOnNbyN(20, 20, row, col))
    return;
  Button button = testButtons[row][col];
  if(button.getNum()==0 && button.isCovered && !button.isBomb()){
    button.uncover();
    for(int r = row-1; r<=row+1;r++){
      for(int c = col-1; c<=col+1;c++){
        uncover0s(r, c);
      }
    }
  }
  if(hasAdjacent0(row, col))
    button.uncover();
  return;
}


public void lost(){
  hasLost = true;
  for(Button[] row:testButtons)
    for(Button button:row)
      if(button.isBomb())
        button.uncover();
}

public void setNums(){
  for(int row = 0; row<20; row++)
    for(int col = 0; col<20; col++)
      testButtons[row][col].setNum(adjacentBombs(row, col));
}
