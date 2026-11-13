// Alena 16.03.26

class HScrollbar {
  int swidth, sheight;     // width and height of the scrollbar track
  float xpos, ypos;         // position of the scrollbar track
  float spos, newspos;        // current and target positions of the handle
  float sposMin, sposMax;        // min and max positions handle can move
  int loose;                      // smoothness factor for easing movement
  boolean over;                   // is mouse hovering over the handle?
  boolean locked;                // is the handle being dragged?


  // Constructor: sets up track size, position, handle min/max, and easing
HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;

    xpos = xp - swidth/2;       // center the track at xp
    ypos = yp;

    sposMin = ypos;              // top of scrollbar
    sposMax = ypos + sheight - swidth;

    spos = sposMin;   // start handle at top
    newspos = spos;

    loose = l;       // higher = smoother (slower) movement
  }

  void update() {
    over = overEvent();     // check if mouse is hovering over handle

    if (firstMousePress && over) {
      locked = true;        // lock handle when clicked
    }
    if (!mousePressed) {
      locked = false;            // release handle when mouse is released
    }

    if (locked) {           // move handle to mouseY, constrained within min and max positions
      newspos = constrain(mouseY - swidth/2, sposMin, sposMax);
    }

    // smooth movement of handle toward target position
    if (abs(newspos - spos) > 1) {
      spos += (newspos - spos) / loose;
    }
  }

  // helper to keep values within min/max
  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  // returns true if mouse is over scrollbar
  boolean overEvent() {
    return (mouseX > xpos && mouseX < xpos + swidth &&
            mouseY > ypos && mouseY < ypos + sheight);
  }

  // draws scrollbar track and handle
  void display() {
    fill(204);
    rect(xpos, ypos, swidth, sheight);

    if (over || locked) {
      fill(0);      // dark handle if hovered or dragging
    } else {
      fill(102);      // normal color otherwise
    }

    rect(xpos, spos, swidth, swidth);
  }

  // Returns value between 0 and 1
  float getPercent() {
    return (spos - sposMin) / (sposMax - sposMin);
  }
}
