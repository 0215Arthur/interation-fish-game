
PShape hook;//钩子形状
PImage []imgfish=new PImage[13];//小鱼的图片数组
PImage []imgshark=new PImage[2];//鲨鱼的图片数组
PShape []b=new PShape[8];//构建钩子的形状数组
PImage img;//背景图  
PImage end,newbegin,gamebegin;//游戏结束图 重新开始图标  进入游戏图标


int X0=900, Y0=50;//鱼线的起点
float hook_x, hook_y;//钩子尖端的坐标
float x0=900, y0=50;//钩子转动的圆心
int r0=65;//鱼线初长
int flag1=1;//线不停转动的标记 0 对应出线 -1（碰）-2 对应收线
int fishgot=0;//鱼未抓到的标记

float angle=0.0;//钩子转动的角度
float angleDirection=1;//钩子转动的方向
float speed_hook=0.010;//钩子转动的速度
float speed_go=2;//出线的速度
float speed_getfish=1;//捉鱼回线的速度

PFont font;//字体
int no=0;//计数使用 
int save;//记录游戏开始时间
int time;//记录当前游戏时间
boolean gameover=false;//游戏结束标记
boolean begin=false;//游戏重新开始标记
boolean endgame=false;//退出游戏标记
boolean begingame=false;//进入游戏标记

int bestScore=0;//最佳成绩
int nowScore=0;//当局得分
Shark shark;//鲨鱼对象
fish []FISH=new fish[8];//小鱼对象数组


void setup()
{
  frameRate(120);//每秒更新120帧
  size(1024, 632);//背景大小
  font=createFont("Algerian-40.vlw",40);
  textFont(font);
  noFill();
  strokeWeight(2);
  hook=createShape(GROUP);
  b[0]=createShape(ELLIPSE, 900, 120, 10, 10);
  b[1]=createShape(LINE, 900, 125, 900, 172);

  b[2]=createShape(LINE, 885, 135, 915, 135);

  b[3]=createShape(ARC, 900, 155, 50, 35, 0, PI);
  b[4]=createShape(LINE, 870, 165, 875, 155);
  b[5]=createShape(LINE, 875, 155, 885, 160);
  b[6]=createShape(LINE, 915, 160, 925, 155);
  b[7]=createShape(LINE, 930, 165, 925, 155);
  //形成组合图形 即钩子图形
  for (int i=0; i<8; i++)
    hook.addChild(b[i]);//把b0到7添加到hook这个图形里
   
  img=loadImage("background.jpg");//添加背景图片变量
  //添加小鱼的图片变量
  imgfish[1]=loadImage("fish01.png");
  imgfish[2]=loadImage("fish03.png");
  imgfish[3]=loadImage("fish05.png");
  imgfish[4]=loadImage("fish07.png");
  imgfish[5]=loadImage("fish01_.png");
  imgfish[6]=loadImage("fish03_.png");
  imgfish[7]=loadImage("fish05_.png");
  imgfish[8]=loadImage("fish07_.png");
  imgfish[9]=loadImage("fish02.png");
  imgfish[10]=loadImage("fish04.png");
  imgfish[11]=loadImage("fish06.png");
  imgfish[12]=loadImage("fish08.png");
  
  gamebegin=loadImage("begin.png");
  end=loadImage("关闭.png");
  newbegin=loadImage("重新开始.png");
  
  imgshark[0]=loadImage("shark02.png");
  imgshark[1]=loadImage("shark01.png");

  for(int i=0;i<8;i++)
  {
   int speed=(int )random(4)+2;//随机生成鱼 的速度
   FISH[i]=new fish(speed,i%4+1,-1);//鱼的位置 鱼的速度 鱼的种类 鱼的状态
  }
   shark=new Shark();//对象的初始化
   
   
   
   background(img);
   image(gamebegin,width/2-150,height/2-100,300,200);
}

void draw()
{
 if(!begingame)
  return;
  if(no==0)//记下开始游戏的时间
   save=millis();
  time=millis();//当前时间
  time=time-save;//得到游戏进行时间
  if(time>180000)//每局游戏时间为3分钟
    gameover=true;
   if(endgame)
      exit();//彻底退出游戏
    gameover();
 
  if(!gameover)
  {
   background(img);
   update();
  drawhook();//画钩子
  for(int i=0;i<8;i++)//显示小鱼
  {
  FISH[i].updata();
  FISH[i].move();
  FISH[i].newfish();
  }
  shark.updata();
  //鲨鱼出现概率被控制 通过随机数控制
  if(no%1020==0)//每执行1020次进行对鲨鱼能否出现进行判断
  {
    shark.show();//显示鲨鱼 
    shark.newcome();//鲨鱼重现
  }
  shark.move();
  no++;
  Score();//显示分数
  }
 newgame(begin);//是否要重新开始游戏
 
}

//钩子绘制
void drawhook()
{
  if (flag1==1)  //钩子不停转动
  {
    line(X0-r0*sin(angle), Y0+r0*cos(angle), X0, Y0);
    pushMatrix();//
    translate(X0, Y0);
    rotate(angle); //转动钩子
    shape(hook, -X0, -Y0);//显示

    popMatrix();
    angle+=speed_hook*angleDirection;
    if ((angle>4*PI/9)||(angle<0))  //当转动角度大于80或者小于0度时要反向转动 
      angleDirection*=-1;
  } else if (flag1==0)  //出钩捕鱼
  {
    line(X0-r0*sin(angle), Y0+r0*cos(angle), X0, Y0);
    //钩子向外伸出
    pushMatrix(); 
    translate(x0, y0);
    rotate(angle);
    x0=x0-speed_go*sin(angle);
    y0=y0+speed_go*cos(angle);//测试结果
    shape(hook, -X0, -Y0);//显示
    shapeMode(CORNER);
    popMatrix();
    r0+=speed_go;//线不断伸长
  } else if (flag1==-1)   //钩子碰倒边界后收线
  {
    line(X0-r0*sin(angle), Y0+r0*cos(angle), X0, Y0);
    //钩子向外伸出
    pushMatrix(); 
    translate(x0, y0);
    rotate(angle);
    x0=x0+speed_go*sin(angle);
    y0=y0-speed_go*cos(angle);
    shape(hook, -X0, -Y0);
    shapeMode(CORNER);
    popMatrix();
    r0-=speed_go;//线不断收回
    if (r0<=65)
      flag1=1;
  } else if (flag1==-2)//抓到鱼
  {
    line(X0-r0*sin(angle), Y0+r0*cos(angle), X0, Y0);
    //钩子向外伸出
    pushMatrix(); 
    translate(x0, y0);
    rotate(angle);
    x0=x0+speed_getfish*sin(angle);
    y0=y0-speed_getfish*cos(angle  );
    shape(hook, -X0, -Y0);
    shapeMode(CORNER);
    popMatrix();
    r0-=speed_getfish;//线不断收回
    if (r0<=65)
      flag1=1;
  }

}

//更新数据
void update()
{
  hook_x=X0-(r0+47)*sin(angle);
  hook_y=Y0+(r0+47)*cos(angle);
  if (hook_x<=0|hook_y>=632)
    flag1=-1;//收线
}

//坐标变换

//建立鱼类
class fish {
  float x, y;//鱼的位置坐标
  float speed;//鱼的游动速度
  int  speice;//鱼的种类  1 blue right 2 blue left  3 yellow right   4 yellow left
  //int direction;//鱼游动的方向  1 right  2left
  float depth;//深度
  float loc;//位置
  int caught;//鱼是否被捕捉到 -1未被捉到
  int i=0;
  fish( float s, int sp, int ca) {//构造函数
     speed=s;
    speice=sp;
    if(speice%2==1)
    {
    x=(int )random(51);//随机生成坐标
    y=(int )random(120,415);
    }
     else
     {
     x=(int )random(1020,1030);
     y=(int )random(130,415);
     }
   
    loc=x;//记录最初的坐标值
    depth=y;
    caught=ca;
  }

  void move()
  {
    //鱼未被抓到
    if (caught==-1)
    {
      if (speice%2==1)//往右移
      {
        if (i%20>=10)//i是帧数
          image(imgfish[speice+4], x, y, 140, 140);//张闭嘴
        else 
        image(imgfish[speice], x, y, 140, 140);
        i++;
        x=x+speed;
        if (x>1023)//出界
          x=0;
      } else
      {
        if (i%20>=10)
          image(imgfish[speice+4], x, y, 140, 140);
        else 
        image(imgfish[speice], x, y, 140, 140);
        i++;
        x=x-speed;
        if (x<=0)
          x=1024;
      }
    }
    //鱼已经被抓到
    else if (caught==0)
    {

      image(imgfish[speice+8], x, y, 140, 140);//
      x=x+speed_getfish*sin(angle);
      y=y-speed_getfish*cos(angle);
    }
    else {
      // caught=-1;
      x=loc;//初始位置
      y=depth;
    }
  }
  void updata()//检测有没有被抓到
  {
    //caught=-1鱼没被抓，fishgot=0钩子上没鱼
    if (x+40<hook_x&hook_x<x+100&y+40<hook_y&hook_y<y+100&caught==-1&fishgot==0)
    { 
      caught=0;//鱼抓到
      flag1=-2;//收线 
      fishgot=1;
      
    }
    if (r0<=65&caught==0)
    {
      caught=1;//鱼抓到不再显示
      fishgot=0;//鱼钩可以重新抓鱼
      nowScore=nowScore+10;
    }
  }
  //重新初始化数据
  void update()
  {
    //重新生成坐标 并记录
    if(speice%2==1)
    {
    x=(int )random(51);
    y=(int )random(100,415);
    }
     else
     {
     x=(int )random(1020,1030);
     y=(int )random(100,415);
     }
    loc=x;//记录初始值  用于复活
    depth=y;
  }
  //复活
  void newfish()
  {
    //被抓后
    if (caught==1)
    {
      //一次机会复活的概率为1/5
      int m=(int) random(5);
      if(m==1)
         caught=-1;
    }
  }
  
  
}
class Shark{
   float x,y;//鲨鱼的初始坐标
   boolean touched=false;//被勾到的标记
   int speed;//游动速度
   boolean go=false;//出现的标记
   int i=0;
   Shark()//对象初始化
   {
   speed=(int) random(2)+1;//速度随机赋值
   x=0;
   y=360;
   }
   
    void show()//确定鲨鱼是否出现
   {
     if(!go)//如果尚未出现过    若已经出现过则函数无用
     {
     int m=(int) random(10)+1;//随机生成数 其出现的概率为3/5
      if(m>4)
       go= true;
     }
   }
   
   void move()//鲨鱼移动的规律
   {
     if(x<1020&go==true&touched==false)//未游出画面且可以出现且未被抓到 时 可以向左移动
    {
      if(i%30>15)
      image(imgshark[0],x,y,300,250); //张嘴
      else 
      image(imgshark[1],x,y,300,250);//闭嘴
      x=x+speed;                       //游动
      i++;
    }
    if(touched&y<630)//鲨鱼被碰倒  且还未离开画面
    {
     x=x-speed*sin(angle);//鲨鱼下沉
     y=y+speed*cos(angle); 
    }
   }
   void updata()//检测各项数据
   {
   if (x+100<hook_x&hook_x<x+245&y+80<hook_y&hook_y<y+200&!touched&fishgot==0)// 检测鲨鱼是否被碰触到 
    { 
      touched=true;//鱼碰到 
      fishgot=1;//钩子上有鱼
      speed_go=speed;//下线速度与鲨鱼速度相同
    }
    if(touched&y>=630)
    {
      gameover=true;
    }
   }
   //重新初始化数据
   void update()
   {
    speed=(int) random(2)+1;//速度随机赋值
    x=0;
    y=360;
   }
   void newcome()//鲨鱼重生
   {
     if(x>=1020&!touched)//如果鲨鱼游出画面且没有被碰倒
        {
          int m=(int )random(8)+1;//鲨鱼再现的概率变为3/4
          if(m>2)
          {
            x=0;
            y=360;
          }
        }
   }

}
//显示成绩
void Score()
{

  fill(50);
  text("Now Score:",15,50);
  text(nowScore,250,50);
}

//基本数据全部更新
void newgame(boolean b)
{
  if(b)
  {
    save=millis();
  nowScore=0;
 angle=0.0;//钩子转动的角度
 angleDirection=1;//钩子转动的方向
 speed_hook=0.010;//钩子转动的速度
 speed_go=2;//出线的速度
 no=0;
  gameover=false;
  begin=false;
  shark.update();
  for(int i=0;i<8;i++)
  FISH[i].update();
  } 
}

//游戏结束判断
void gameover()
{
  if(gameover)
  {
    background(img);
    background(255);
    textSize(60);
    text("GAME OVER",width/2-200,height/2-100);
    textSize(40);
    text("Your score:"+nowScore,width/2-110,height/2-50);
    bestScore=bestScore<nowScore?nowScore:bestScore;
    //比较最高分和本局得分  若本局得分高于最高分 则更新最高分
    text("Best score:"+bestScore,width/2-110,height/2);
    image(newbegin,width/2-150,height/2+50,100,100);
    image(end,width/2,height/2+50,100,100);
    if(begin)//若 游戏重新开始  修改游戏结束标志
     gameover=false;
  }
}


void keyPressed()
{

  if (key==32)//按下空格键 抛线 
  //当鱼被抓到且回线时不能再抛线
  if(fishgot==0)//钩子上没有鱼
    flag1=0;
}


void mousePressed()
{
  if(mousePressed&mouseX>=width/2-150&mouseX<=width/2-50&mouseY>=height/2+50&mouseY<=height/2+150)
    begin=true;//游戏重新开始  
  if(mousePressed&mouseX>=width/2&mouseX<=width/2+100&mouseY>=height/2+50&mouseY<=height/2+150)
    endgame=true;//退出游戏
  if(mousePressed&!begingame&mouseX>=width/2-150&mouseX<=width/2+150&mouseY>=height/2-100&mouseY<=height/2+100)
    begingame=true;//重新开始游戏
}