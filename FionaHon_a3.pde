PCGraph graph;

class PCGraph {
  Table graphData;
  String columnName = "";
  String topData = "";
  String bottomData = "";
 
  float graphWidth;
  float graphHeight;
  float xAxis;
  float yAxis;

  PCGraph(Table graphData) {
    this.graphData = graphData;
    this.xAxis = xAxis;
    this.yAxis = yAxis;
  }
 
  void makeResizable(float x, float y, float w, float h) {
      graphWidth = w;
      graphHeight = h;
      xAxis = x;
      yAxis = y;
  }
  
  int findMin(int n) {
    int min = Integer.MAX_VALUE;
    for (TableRow row : graphData.rows()) {
      int val = row.getInt(n);
      if (val < min) {
        min = val;
      }
    }
    return min;
  }
  
  int findMax(int n) {
    int max = Integer.MIN_VALUE;
    for (TableRow row : graphData.rows()) {
      int val = row.getInt(n);
      if (val > max) {
        max = val;
      }
    }
    return max;
  }
  
  int rounder(int n) {
    return (n * 10) / 10;
  }
  
  float horizontalAxis() {
    return (rightXCoords() - leftXCoords()) / graphData.getColumnCount();
  }

  float leftXCoords() {
    return xAxis + 10;
  }
  
  float rightXCoords() {
    return xAxis + graphWidth + 100;
  }
  
  float btmYCoords() {
    return yAxis + graphHeight + 10; 
  }
  
  float yAxisCoords() {
    return btmYCoords() - yAxis;
  }
  
  void drawAxes() {   
    int drawLineCounter = 2;
    while (drawLineCounter < graphData.getColumnCount() + 1) {
      line((drawLineCounter * horizontalAxis()) + leftXCoords(), btmYCoords(), (drawLineCounter * horizontalAxis()) + leftXCoords(), yAxis - 20);
      drawLineCounter++;
    }
  }
  
  void drawLabels() {
    int labelCounter = 2;
    while (labelCounter < graphData.getColumnCount() + 1) {
      columnName = graphData.getRow(labelCounter - 1).getColumnTitle(labelCounter - 1); 
      topData = str(rounder(findMax(labelCounter - 1) + 1));
      bottomData = str(rounder(findMin(labelCounter - 1)));
      
      text(columnName, (labelCounter * horizontalAxis()) + leftXCoords() - 10, yAxis - 40);
      text(topData, (labelCounter * horizontalAxis()) + leftXCoords() - 10, yAxis - 26);
      text(bottomData, (labelCounter * horizontalAxis()) + leftXCoords() - 10, btmYCoords() + 15);
      labelCounter++;
    }
  }

  void drawLineThruRow() {   
    int colCounter = 2;
    while (colCounter < graphData.getColumnCount()) {
      float firstPoint = rounder(findMax(colCounter - 1) + 15);
      float secondPoint = rounder(findMax(colCounter) + 15);
      drawLineThruCol(colCounter, firstPoint, secondPoint);
      colCounter++;
    }
  }
  
  float firstVal, secondVal, startX, startY, endX, endY;
  void drawLineThruCol(int colCounter, float firstPoint, float secondPoint) {
    int rowCounter = 1;
    while (rowCounter < graphData.getRowCount()) {
      TableRow currRow = graphData.getRow(rowCounter);
      firstVal = currRow.getFloat(currRow.getColumnTitle(colCounter - 1));
      secondVal = currRow.getFloat(currRow.getColumnTitle(colCounter)); 
      float first = firstVal / firstPoint;
      float second = secondVal / secondPoint;
      startX = (colCounter * horizontalAxis()) + leftXCoords();
      startY = btmYCoords() - (first * (yAxisCoords() - 20));         
      endX = (horizontalAxis() * (colCounter + 1)) + leftXCoords();
      endY = btmYCoords() - (second * (yAxisCoords() - 20));           
      line(startX, startY, endX, endY);   
      rowCounter++;
    }
  }
} 

void setup() {
  size(1000, 800);
  background(255, 255, 255);
  fill(0, 0, 0);
  surface.setResizable(true);
  Table graphData = loadTable("data.csv", "header");
  graph = new PCGraph(graphData);
}

void draw() {
  graph.makeResizable(.1 * width, .1 * height, .7 * width, .7 * height); 
  graph.drawAxes();
  graph.drawLabels();
  graph.drawLineThruRow();
}