// Anaísa Forti da Fonseca - 11811ECP012

// os "console.log" no código estão presentes apenas para fins de teste
// definição de variáveis
var gCanvas = document.getElementById("gCanvas");
var gCanvasOffset;
var gctx = gCanvas.getContext("2d"); // gctx determina que estaremos trabalhando no plano (2D)
var canvasWidth = gCanvas.width;
var canvasHeight = gCanvas.height;
var nodeSize = 20;
var path;
var openSet = new Set();
var closedSet = new Set();
var gridPointsByPosition = [];
var gridPoints = [];
var setWall = new Set();
var start;
var end;
var selected = null;

// qualquer ponto 2D
class Vec2{
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }}

// grade, início e fim
gCanvasOffset = new Vec2(gCanvas.offsetLeft, gCanvas.offsetTop);  // 800x800
start = new Vec2(0, 0);                                           // no canto superior esquerdo
end = new Vec2(780, 780);                                         // no canto inferior direito

// classe que lida com os quadrados
class Node{
  // construtor de cada quadrado
  constructor(id, size, positionX, positionY, walkable) {
    this.id = id;
    this.size = size;
    this.positionX = positionX;
    this.positionY = positionY;
    this.walkable = walkable;
    this.inPath = false;
    this.getG = this.getValueG;
    this.getH = this.getValueH;
  }

  // quadrado do início
  createStartNode(){
    nodeDrawer(gctx, this, 1, "#bbbbbb", "yellow");
  }
  // quadrado do fim
  createEndNode(){
    nodeDrawer(gctx, this, 1, "#bbbbbb", "orange");
  }
  // permitido ou não passar
  toggleWalkable(){
    this.walkable = !this.walkable;
  }

  // f = g + h (do algoritmo a*)
  getValueF(){
    var fValue = this.getValueG() + this.getValueH();
    return fValue;
  }
  getValueG(){
    var startPosition = {
      positionX: start.x,
      positionY: start.y };
      return getDistance(this, startPosition);
    }
  getValueH(){
    var endPosition = {
      positionX: end.x,
      positionY: end.y };
    return getDistance(this, endPosition);
  }

  // obstáculo
  createWall(){
    nodeDrawer(gctx, this, 1, "#bbbbbb", "#ededed");
  }
  // caminho final
  drawPath(){
    nodeDrawer(gctx, this, 1, "#bbbbbb", "violet");
  }

  /* caso queira que a "varredura" apareça basta descomentar esta seção
  // quadrados em aberto
  drawOpenNode(){
    nodeDrawer(gctx, this, 1, "#bbbbbb", "gray");
  }
  // quadrados fechados (percorridos)
  drawClosedNode(){
    nodeDrawer(gctx, this, 1, "#bbbbbb", "red");
  }
  */

  // desenha o quadrado especificado (início, fim, etc)
  drawNode(){
    gctx.beginPath();
    gctx.lineWidth = "1";
    gctx.strokeStyle = "#ededed";
    gctx.fillStyle = "#282828";
    gctx.fillRect(this.positionX, this.positionY, this.size, this.size);
    gctx.rect(this.positionX, this.positionY, this.size, this.size);
    gctx.closePath();
    gctx.stroke();
    if(this.inPath === true){
      this.drawPath();
    }
    if(this.walkable === false){
      this.createWall();
      console.log("\nPosição da parede:")
      console.log(this.positionX);
      console.log(this.positionY);
    }
    if(this.positionX == start.x && this.positionY == start.y){
      this.createStartNode();
    }
    if(this.positionX == end.x && this.positionY == end.y){
      this.createEndNode();
    }
  }}

// classe que lida com a busca de um caminho
class PathFindingAlg{
  // construtor da grade
  constructor(grid, startNode, endNode) {
    this.grid = grid;
    this.startNode = gridPointsByPosition[startNode.x][startNode.y];
    this.endNode = gridPointsByPosition[endNode.x][endNode.y];
    this.currentNode = null;
    this.openSet = [];
    this.closedset = [];
  }

  // função que busca o caminho
  findPath() {
    openSet.clear();   // limpa os quadrados em aberto
    closedSet.clear(); // limpa os quadrados percorridos

    var currentNode = this.startNode;
    var endNode = gridPoints[this.endNode];
    var startNode = gridPoints[this.startNode];
    var tempArray;
    var newMovementCost; // custo de um novo movimento

    openSet.add(gridPoints[currentNode]);

    while(openSet.size > 0){
      tempArray = Array.from(openSet);
      currentNode = tempArray[0];
      // garante que ele vá na direção da menor distância
      for(var i=1; i<tempArray.length; i++){
        if(tempArray[i].getValueF()<currentNode.getValueF() || tempArray[i].getValueF() == currentNode.getValueF() && tempArray[i].getValueH()<currentNode.getValueH()){
          currentNode = tempArray[i];
        }
      }
      openSet.delete(currentNode);
      // currentNode.drawClosedNode(); // caso queira que mostre os quadrados percorridos basta descomentar esta linha
      closedSet.add(currentNode);

      // desenha os quadrados iniciais e retraca o caminho
      if(currentNode.id == startNode.id){
        currentNode.drawNode();
      }
      if(currentNode.id == endNode.id){
        currentNode.drawNode();
      }
      if(currentNode.walkable == false){
        currentNode.drawNode();
      }
      if(currentNode.id == endNode.id){
        console.log("\nInício:");
        console.log(startNode);
        console.log("\nFim: ");
        console.log(endNode);
        retracePath(startNode, endNode);
        return;
      }

      // analisa os quadrados vizinhos (varredura)
      getNeighbors(currentNode).forEach(function (neighbor){
        var neighborNode = gridPoints[neighbor];
        var neighborH = neighborNode.getH();
        var neighborG = neighborNode.getG();
        var currentG = currentNode.getG();
        var currentH = currentNode.getH();

        if(!neighborNode.walkable || closedSet.has(neighborNode)){
          return; // não continua se o obstáculo já foi verificado
        }

        // custo de um novo movimento
        newMovementCost = currentG + getDistance(currentNode, neighborNode);

        // compara custos com vizinhos
        if(newMovementCost<neighborG || !openSet.has(neighborNode)){
          neighborNode.gCost = newMovementCost;
          neighborNode.hCost = neighborH;
          neighborNode.parent = currentNode;

          if(!openSet.has(neighborNode)){
            // joga o vizinho no openSet para comparar com outros valores em aberto
            openSet.add(neighborNode);
            //neighborNode.drawOpenNode(); // caso queira que mostre os quadrados em aberto basta descomentar esta linha
          }}});
          console.log("\nQuadrados em aberto relativo à lista de vizinhos acima: ");
          console.log(openSet);
    }
  }}

// classe que lida com a grade
class Grid{
  // construtor da grade
  constructor(width, height, positionX, positionY, gridPoints){
    this.width = width;
    this.height = height;
    this.positionX = positionX;
    this.positionY = positionY;
    this.gridPoints = gridPoints;
  }

  // criando a grade
  createGrid(){
    var tempNode;
    var countNodes = 0;
    gctx.beginPath();
    gctx.lineWidth = "1";
    gctx.strokeStyle = "#ededed";
    gctx.rect(0, 0, this.width, this.height);
    gctx.stroke();

    for(var i=0; i<this.width; i+=nodeSize){
      gridPointsByPosition[i] = [];
      for(var j=0; j<this.height; j+=nodeSize){
        gridPointsByPosition[i][j] = countNodes;
        tempNode = new Node(countNodes, nodeSize, i, j, true);
        if(setWall.has(countNodes)){
          tempNode.walkable = false;
        }
        tempNode.drawNode();
        tempNode.F = tempNode.getValueF();
        gridPoints.push(tempNode);
        countNodes++;
      }
    }
    console.log("\nNúmero de quadrados: ")
    console.log(countNodes);
  }}

var grid = new Grid(canvasWidth, canvasHeight, 0, 0); // grade do tamanho do canvas (800x800)
grid.createGrid();
var myPath = new PathFindingAlg(grid, start, end);

//distância de um quadrado a outro
function getDistance(nodeA, nodeB){
  var distX = Math.abs(nodeA.positionX - nodeB.positionX);
  var distY = Math.abs(nodeA.positionY - nodeB.positionY);
  var dist = 0;

  if(distX>distY){
    dist = 14*distY + 10*(distX-distY);
    return dist;
  }else{
    dist = 14*distX + 10*(distY-distX);
    return dist;
  }
}

// função para retraçar o caminho
function retracePath(startNode, endNode){
  path = new Set();
  var currentNode = endNode;
  var reverseArray;

  while (currentNode != startNode){
    path.add(currentNode);
    currentNode = currentNode.parent;
    currentNode.inPath = true;
    if(currentNode != startNode)
    currentNode.drawPath();
  }

  reverseArray = Array.from(path);
  reverseArray.reverse();
  path = new Set(reverseArray);
  console.log("\nArray do caminho final traçado:")
  console.log(reverseArray);
}

// quadrados vizinhos (determinados pela varredura)
function getNeighbors(node){
  var checkX;
  var checkY;
  var neighborList = [];
  var tempList = [];

  for(var x=-nodeSize; x<=nodeSize; x+=nodeSize){
    for (var y=-nodeSize; y<=nodeSize; y+=nodeSize){
      if (x == 0 && y == 0){
        continue;
      }
      checkX = node.positionX + x;
      checkY = node.positionY + y;
      if (checkX>=0 && checkX<=canvasWidth-nodeSize && checkY>=0 && checkY<=canvasHeight-nodeSize){
        tempList.push(gridPointsByPosition[checkX][checkY]);
      }}}

  neighborList = tempList;
  console.log("\nLista de vizinhos:")
  console.log(neighborList);
  return neighborList;
}

// especifica como "desenhar" o quadrado
function nodeDrawer(context, target, lineW, strokeS, fillS){
  context.beginPath();
  context.lineWidth = lineW;
  context.strokeStyle = strokeS;
  context.fillStyle = fillS;
  context.fillRect(target.positionX, target.positionY, target.size, target.size);
  context.rect(target.positionX, target.positionY, target.size, target.size);
  context.closePath();
  context.stroke();
}

// limpa apenas o caminho mostrado (não limpa os obstáculos posicionados)
function reset(){
  gridPoints = [];
  gridPointsByPosition = [];
  openSet.clear();
  closedSet.clear();
  gctx.clearRect(0, 0, canvasWidth, canvasHeight);
  grid.createGrid();
}

// limpa tudo (caminho e obstáculos)
function resetWalls(){
  setWall.clear();
  reset();
}

// funções de cada botão de controle
document.getElementById("buttonWall").addEventListener("click", function (event){
  selected = "wall";
});
document.getElementById("buttonStart").addEventListener("click", function (event){
  selected = "start";
});
document.getElementById("buttonEnd").addEventListener("click", function (event){
  selected = "end";
});
document.getElementById("buttonBegin").addEventListener("click", function (event){
  reset();
  myPath = new PathFindingAlg(grid, start, end);
  myPath.findPath();
});
document.getElementById("buttonClear").addEventListener("click", function (event){
  reset();
});
document.getElementById("resetAll").addEventListener("click", function (event){
  resetWalls();
});

// especifica ao canvas o que fazer quando clicado
gCanvas.addEventListener('click', function (event){
  var x = event.pageX - $(gCanvas).position().left;
  var y = event.pageY - $(gCanvas).position().top;

  gridPoints.forEach(function (element){
    if(y>element.positionY && y<element.positionY+element.size && x>element.positionX && x<element.positionX+element.size){
      if (selected === "wall"){
          setWall.add(element.id);
          element.toggleWalkable();
          element.drawNode();
      }
      else if (selected === "start"){
        start = new Vec2(element.positionX, element.positionY);
        reset();
      } 
      else if (selected === "end"){
        end = new Vec2(element.positionX, element.positionY);
        reset();
      }
      else{
        alert("Selecione o que posicionar nos controles à esquerda!");
      }
    }
  });
}, false);