int fps = 60;
int centerPos[] = new int[2];
int loop;
int interval = 30;
float param = 0;
float threshold = 180, threshold2 = 1000, threshold3 = 1100;;
boolean hasClicked = false, isShrink = false;

void setup() 
{
    size(900,900);
    colorMode(RGB);
    background(255);
    smooth();
    frameRate(fps);
    strokeWeight(1);
    noFill();
    ellipseMode(RADIUS);
    strokeWeight(2);
    
    loop = width / interval;   
}

void draw()
{
    if (hasClicked && !isShrink)
    {   
        if (param < threshold)
        {
            for (int i = -loop; i < loop * 2; i++)
            {
                if (param > sqrt(sq((float)centerPos[0] - centerPos[1] + interval * i) / 2))
                {
                    float pos[] = getDiagIntersection(1, interval * i, param);
                    line(pos[0], pos[1], pos[2], pos[3]);
                }
                
                if (param > sqrt(sq((float)centerPos[0] + centerPos[1] - interval * i) / 2))
                {
                    float pos[] = getDiagIntersection( -1, interval * i, param);
                    line(pos[0], pos[1], pos[2], pos[3]);
                }
            }     
            param += 1;
        }
        else if ((int)param == (int)threshold)
        {
            param++;
        }
        else if (param < threshold2)
        {
            for (int i = 0; i < loop; i++) //方眼
            {
                float pos[] = getIntersectionX(interval * i,(int)param);
                line(pos[0], pos[1], pos[2], pos[3]);
                float pos2[] = getIntersectionY(interval * i,(int)param);
                line(pos2[0], pos2[1], pos2[2], pos2[3]);
            }
            
            noStroke();
            fill(255);
            ellipse(centerPos[0], centerPos[1], threshold, threshold);
            stroke(0);
            strokeWeight(3);
            
            for (int i = -loop; i < loop * 2; i++)
            {
                if (param > sqrt(sq((float)centerPos[0] - centerPos[1] + interval * i) / 2)) //斜線
                {
                    float pos[] = getDiagIntersection(1, interval * i, threshold);
                    line(pos[0], pos[1], pos[2], pos[3]);
                }
                
                if (param > sqrt(sq((float)centerPos[0] + centerPos[1] - interval * i) / 2)) //斜線
                {
                    float pos[] = getDiagIntersection( -1, interval * i, threshold);
                    line(pos[0], pos[1], pos[2], pos[3]);
                }


                if ((centerPos[0] + threshold) > interval * i && (centerPos[0] - threshold) < interval * i) //縦向き
                {
                    float pos[] = getIntersectionY(interval * i,(int)param);
                    float innerPos[] = getIntersectionY(interval * i,(int)threshold);
                    line(pos[0], pos[1], innerPos[0], innerPos[1]);
                    line(pos[2], pos[3], innerPos[2], innerPos[3]);
                }            
                if ((centerPos[1] + threshold) > interval * i && (centerPos[1] - threshold) < interval * i) //横向き
                {
                    float pos[] = getIntersectionX(interval * i,(int)param);
                    float innerPos[] = getIntersectionX(interval * i,(int)threshold);
                    line(pos[0], pos[1], innerPos[0], innerPos[1]);
                    line(pos[2], pos[3], innerPos[2], innerPos[3]);
                }
            }
            
            param += 2;
        }
        else if(param <= threshold3)
        {
            param ++;
        }
        else
        {
            isShrink = true;
        }
    }
    else if (isShrink)
    {
        noFill();
        strokeWeight(15);
        stroke(255);
        ellipse(centerPos[0], centerPos[1], param, param);
        param -= 6;
        if (param < 0)
        {
            fill(255);
            ellipse(centerPos[0], centerPos[1], 10, 10);
            noFill();
            param = 0;
            hasClicked = false;
            isShrink = false;
            strokeWeight(2);
            stroke(0);
        }
    } 
}

void mousePressed()
{
    if (!hasClicked)
    {
        centerPos[0] = mouseX;
        centerPos[1] = mouseY;
        
        hasClicked = true;
    }
}

float[] getIntersectionX(int y0, int r)
{
    float intersections[] = new float[4];
    intersections[0] = centerPos[0] - sqrt(sq(r) - sq(centerPos[1] - y0)); //x1
    intersections[1] = y0; //y1
    intersections[2] = centerPos[0] + sqrt(sq(r) - sq(centerPos[1] - y0)); //x2
    intersections[3] = y0; //y2
    
    return intersections;
}

float[] getIntersectionY(int x0, int r)
{
    float intersections[] = new float[4];
    intersections[0] = x0; //x1
    intersections[1] = centerPos[1] - sqrt(sq(r) - sq(centerPos[0] - x0)); //y1
    intersections[2] = x0; //x2
    intersections[3] = centerPos[1] + sqrt(sq(r) - sq(centerPos[0] - x0)); //y2
    
    return intersections;
}

float[] getDiagIntersection(int a, int b, float r)
{
    float intersections[] = new float[4];
    int o1 = centerPos[0];
    int o2 = centerPos[1];
    
    if (a == 1)
    {
        intersections[0] = -sqrt( -sq(o1) + 2 * o1 * o2 - 2 * o1 * b - sq(o2) + 2 * o2 * b - sq(b) + 2 * sq(r)) + o1 + o2 - b;
        intersections[1] = -sqrt( -sq(o1) + 2 * o1 * o2 - 2 * o1 * b - sq(o2) + 2 * o2 * b - sq(b) + 2 * sq(r)) + o1 + o2 + b;
        intersections[2] = sqrt( -sq(o1) + 2 * o1 * o2 - 2 * o1 * b - sq(o2) + 2 * o2 * b - sq(b) + 2 * sq(r)) + o1 + o2 - b;
        intersections[3] = sqrt( -sq(o1) + 2 * o1 * o2 - 2 * o1 * b - sq(o2) + 2 * o2 * b - sq(b) + 2 * sq(r)) + o1 + o2 + b;
        
    }
    else if (a == -1)
    {
        intersections[0] = -sqrt( -sq(o1) - 2 * o1 * o2 + 2 * o1 * b - sq(o2) + 2 * o2 * b - sq(b) + 2 * sq(r)) + o1 - o2 + b;
        intersections[1] = sqrt( -sq(o1) - 2 * o1 * o2 + 2 * o1 * b - sq(o2) + 2 * o2 * b - sq(b) + 2 * sq(r)) - o1 + o2 + b;
        intersections[2] = sqrt( -sq(o1) - 2 * o1 * o2 + 2 * o1 * b - sq(o2) + 2 * o2 * b - sq(b) + 2 * sq(r)) + o1 - o2 + b;
        intersections[3] = -sqrt( -sq(o1) - 2 * o1 * o2 + 2 * o1 * b - sq(o2) + 2 * o2 * b - sq(b) + 2 * sq(r)) - o1 + o2 + b;
    }
    
    for (int i = 0; i < 4; i++)
    {
        intersections[i] /= 2;
    }
    
    return intersections;
}

float delta(float a, float r)
{
    float div = a / r;
    return a / div * div * sqrt(1 - (div * div));
}