class Button {
  Vector pos; //POSITION DU VECTEUR
  Vector size; //TAILLE DU VECTEUR
  color textColors; //COULEUR DU TEXTE DU BOUTTON
  color borderColor; //COULEUR DE LA BORDURE
  int fontSize; //TAILLE DE LA POLICE
  String text; //TEXTE A AFFICHER DANS LE BOUTTON

  Action action; //ACTION DU BOUTTON
  Activity act; // ACTIVITEE DU BOUTTON
  ButtonType type; //TYPE DE BOUTTON

  Button(ButtonType pType, Vector pPos, Vector pSize, String pText, int pFont, color pTextColor) { //BOUTTON JUSTE AVEC UN TEXTE
    type = pType;
    pos=pPos;
    size=pSize;
    text=pText;
    fontSize = pFont;
    textColors=pTextColor;
  }
  Button(ButtonType pType, Vector pPos, Vector pSize, String pText, int pFont, Activity pAct, color pTextColor) { //BOUTTON QUI PEUT CHANGER L'ACTIVITEE
    this(pType, pPos, pSize, pText, pFont, pTextColor);
    action=Action.CHANGE_ACTIVITY;
    act=pAct;
  }
  Button(ButtonType pType, Vector pPos, Vector pSize, String pText, int pFont, Action pAction, color pTextColor) { //BOUTTON QUI PEUT CHANGER L'ACTION
    this(pType, pPos, pSize, pText, pFont, pTextColor);
    action=pAction;
  }
  boolean isOnMe() { //VERIFICATION DU SURVOL DU BOUTTON RECTANGLE
    if (type==ButtonType.RECTA)
      return (mouseX>=pos.x && mouseX<=pos.x+size.x) && (mouseY>=pos.y && mouseY<=pos.y+size.y);
    else if (type==ButtonType.TRIANG) {
      Vector cursor=minus(new Vector(mouseX, mouseY, false), pos);

      return (cursor.getNorm()<size.getNorm()/2);
    }
    return false;
  }
  void click() { //VERIFICATION DU CLIC SUR UN BOUTTON
    switch(action) {
    case CHANGE_ACTIVITY:
      changeActivity(act);
      break;
    case CHANGE_SKIN_P:
    uploadSkin((getSkin()+1)%playableVessels.length);
    break;
    case CHANGE_SKIN_M:
    uploadSkin((playableVessels.length+getSkin()-1)%playableVessels.length);
    break;
    }
  }

  void draw() {
    switch(type) { //VERIFICATION DU TYPE DE BOUTTON
    case RECTA:
      pushStyle();
      stroke(255);
      noFill();
      rect(pos.x-10, pos.y, size.x+10, size.y);
      fill(textColors);
      textSize(fontSize);
      text(text, (pos.x - text.length() +10), pos.y + size.y);
      popStyle();
      break;
    case TRIANG:
      if (text == "D") {
        pushStyle();
        stroke(255);
        noFill();
        triangle(pos.x+size.x/2+size.x/10, pos.y, pos.x-size.x/2+size.x/10, pos.y-size.y/2, pos.x-size.x/2+size.x/10, pos.y+size.y/2);

        popStyle();
      } else if (text == "G") {
        pushStyle();
        stroke(255);
        noFill();
        triangle(pos.x-size.x/2-size.x/10, pos.y, pos.x+size.x/2-size.x/10, pos.y+size.y/2, pos.x+size.x/2-size.x/10, pos.y-size.y/2);
      }
      break;
    }
  }
}