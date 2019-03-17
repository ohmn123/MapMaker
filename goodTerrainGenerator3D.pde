float inc = 0.01;
float zOffset = 0;

int octaves = 4;
float persistance = 0.5, lacunarity = 2;
float scl = 1;

float offX = 0, offY = 0;

float seed = millis();

color waterDeep = color(52, 99, 144), waterShallow = color(55, 102, 199), sand = color(209, 208, 128), grass = color(86, 151, 26), grass2 = color(63, 106, 21), rock = color(93, 68, 63), rock2 = color(76, 58, 56), snow = color(255, 255, 255);
float waterDeepHeight = 0.3, waterShallowHeight = 0.4, sandHeight = 0.45, grassHeight = 0.55, grass2Height = 0.6, rockHeight = 0.7, rock2Height = 0.9; //, snowHeight = 1.1;

int w = 1920;
int h = 1080;

boolean _3d = false, wireframe = false;

float[][] elevation = new float[h][w];
//float[][] temprature = new float[h][w];
//float[][] elevation = new float[780][1200];

OpenSimplexNoise noise;

void setup(){
  size(1200, 780, P3D);
  noise = new OpenSimplexNoise();  
  
  noiseSeed(millis());
  frameRate(60);
  
  generateHeightMap();
}

void generateHeightMap(){
  float yOffset = 0, xOffset = 0, r;
  for(int y = 0; y < h; y++){
    xOffset = 0;
    for(int x = 0; x < w; x++){

      float amplitude = 1;
      float frequency = 1;
      float noiseHeight = 0;
      
      for(int i = 0; i < octaves; i++){
        r = (float) noise.eval((xOffset - w / 2) * scl * frequency, (yOffset - h / 2) * scl * frequency); // * 2 - 1;
        //r = map(r, -1, 1, 0, 1);
        noiseHeight += r * amplitude;
        
        
        amplitude *= persistance;
        frequency *= lacunarity;
      }
      float e = map(noiseHeight, -1, 1, 0, 1);
      elevation[y][x] = e;
      //float north = dist(x, y, x, 0);//sqrt((y-0)^2 + (x-w/2)^2);
      //float south = dist(x, y, x, height);//sqrt((y-h)^2 + (x-w/2)^2);
      //float dist = min(north, south);
      //float maxDist = dist(x, height/2, x, 0);//1101; //sqrt(((1080/2)^2)+(((-1920)/2)^2));
      //temprature[y][x] = map(dist, 0, maxDist, 0, 50);
      xOffset += inc;
      
    }
    yOffset += inc;
  }
}

void draw(){
  //if(frameCount % 2 == 0){
  //  offY -= 0.1;
  //  thread("generateHeightMap");
  //}
  
  drawTerrain();
  
  //noLoop();
}

void drawTerrain(){
  background(0);
  if(!wireframe) noStroke();
  else { strokeWeight(0.1); stroke(255); noFill(); }
  
  if(_3d){
    translate(width / 2 + offX, height / 2 + offY);
    rotateX(PI / 3);
    translate(-width / 2 + offX, -height / 2 + 50 + offY);
    
  } else {
    translate(offX, offY);
  }
  
  for(int y = 0; y < height / scl - 1; y++){
    beginShape(TRIANGLE_STRIP);
    for(int x = 0; x < width / scl; x++){
      if(!wireframe) fill(getBiomeColor(elevation[y][x]));
      vertex(x * scl, y * scl, 50 * elevation[y][x]);
      vertex(x * scl, (y + 1) * scl, 50 * elevation[y+1][x]);
    }
    endShape();
  }
}

color getBiomeColor(float e){
  if(e < waterDeepHeight)
    return waterDeep;
  else if(e < waterShallowHeight){
    return waterShallow;
  } else if(e < sandHeight){
    return sand;
  } else if(e < grassHeight){
    return grass;
  } else if(e < grass2Height){
    return grass2;
  } else if(e < rockHeight){
    return rock;
  } else if(e < rock2Height){
    return rock2;
  } else {
    return snow;
  }
}

void islandify(){
  float yOffset = 0, xOffset = 0, r;
  for(int y = 0; y < h; y++){
    xOffset = 0;
    for(int x = 0; x < w; x++){

      //float amplitude = 1;
      //float frequency = 1;
      //float noiseHeight = 0;
      
      //for(int i = 0; i < octaves; i++){
      //  r = (float) noise.eval((xOffset - w / 2 + offX) * scl * frequency, (yOffset - h / 2 + offY) * scl * frequency); // * 2 - 1;
      //  //r = map(r, -1, 1, 0, 1);
      //  noiseHeight += r * amplitude;
        
        
      //  amplitude *= persistance;
      //  frequency *= lacunarity;
      //}
      float e = elevation[y][x];
      float d = dist(x, y, width / 2, height / 2);
      d = map(d, 0, dist(0, 0, width /2, height/2), 0, 1);
      e = (1 + e - d) / 2;
      elevation[y][x] = e;
      //float north = dist(x, y, x, 0);//sqrt((y-0)^2 + (x-w/2)^2);
      //float south = dist(x, y, x, height);//sqrt((y-h)^2 + (x-w/2)^2);
      //float dist = min(north, south);
      //float maxDist = dist(x, height/2, x, 0);//1101; //sqrt(((1080/2)^2)+(((-1920)/2)^2));
      //temprature[y][x] = map(dist, 0, maxDist, 0, 50);
      xOffset += inc;
      
    }
    yOffset += inc;
  }
}

void keyPressed(){
  if(key == ' '){
    noiseSeed(millis());
    generateHeightMap();
  }
  
  //if(key == 'z'){
  //  scl *= 2;
  //}
  
  //if(key == 'x' && scl > 0.01){
  //  scl /= 2;
  //}
  
  if(key == 'h'){
    waterDeepHeight += 0.01;
    waterShallowHeight += 0.01;
  }
  
  if(key == 'j'){
    waterDeepHeight -= 0.01;
    waterShallowHeight -= 0.01;
  }
  
  if(key == 'w'){
    offY -= 0.1 * 100;
    //generateHeightMap();
  }
  
  if(key == 's'){
    offY += 0.1 * 100;
    //generateHeightMap();
  }
  
  if(key == 'a'){
    offX -= 0.1 * 100;
    //thread("generateHeightMap");
  }
  
  if(key == 'd'){
    offX += 0.1 * 100;
    //generateHeightMap();
  }
  
  if(key == '2'){
    _3d = false;
  }
  
  if(key == '3'){
    _3d = true;
  }
  
  if(key == 'g'){
    wireframe = !wireframe;
  }
  
  if(key == 'i'){
    islandify();
  }
  
}
