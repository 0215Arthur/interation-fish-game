PImage img_fist;
int step= 20;
int fist_x=900,fist_y=200;//拳头的位置
int score=0;//记录分数
boolean change=false;//doge放大标志
boolean gameover=false;//游戏结束标志

PFont font;//字体

actor []PIC=new actor[8];//图片对象数组

void setup()
{
  int [][] a=new int[6][4];//二维数组  用于辅助生成不重复的位置坐标
  frameRate(60);//每秒更新60帧
  font=createFont("ArialNarrow-Bold-48.vlw",40);
  textFont(font);
  noFill();
  strokeWeight(2);
  //设置字体
  size(1050,700);
  background(255);
  img_fist=loadImage("quantou.png");
 
  image(img_fist,fist_x,fist_y,150,150);
  //初始化图片对象  赋以随机的位置 和图片类型
  for(int i=0;i<8;i++)
  {
      int type=(int )random(3);
      int x=(int )random(0,6);
      int y=(int )random(0,4);
      if(a[x][y]!=1)//等于0 说明该位置还没被占用 可以放图片
        { a[x][y]=1;
          PIC[i]=new actor(150*x,150*y,type);
        }
        else
        {//等于1说明该位置已经被生成 是其他图片的位置 需要重新选择位置
        i--;
        continue;
        }
  }

}

void draw()
{
  //游戏结束标志
  if(gameover)
  {
    background(255);
    textSize(60);
    text("GAME OVER",width/2-200,height/2-100);
    textSize(40);
    text("Your score:"+score,width/2-110,height/2-50);
    //打印相关信息
     //当鼠标点击屏幕后 退出游戏
     if(mousePressed)
        exit();//退出程序
    return;
  }
  
  background(255);
  //循环显示各个图片  并检测是否与拳头相遇
  for(int i=0;i<8;i++)
  {
     PIC[i].show();
     PIC[i].check();
  }
  //显示拳头
  image(img_fist,fist_x,fist_y,150,150);
  Score();
  //显示得分

}
//显示成绩
void Score()
{
  fill(50);
  text("Now Score:",15,50);
  text(score,250,50);
}
//监测
void keyPressed(){
  
  if (key ==  'a' ){
    fist_x -= step;
  }
  else if(key=='w')
  {
    fist_y-=step;
  }
  else if (key ==  'd' ){
    fist_x += step;
  }
  else if(key=='s')
  {
    fist_y+=step;
  }
}
//图片类   自己查阅资料
class actor
{
  
  //类的成员变量
  int ax,ay;//图片显示的位置
  int type;//图片的类型 1：coin  0：bomb  2 ：doge
  int size;//图片的大小
  int count;//计数器
  boolean flag=true;
  boolean show=true;//图片显示与否的标志
  //boolean tx=false;
  PImage a_img;
  //构造函数  初始化图片  初始化  第一步
  actor(int _x,int _y,int _type)
  {
    ax=_x;
    ay=_y;
    type=_type;
    size=1;
    count=-1;
    
    if(_type==1)
       a_img=loadImage("coin.png");
     else if(_type==2)
        a_img=loadImage("doge.png");
     else 
         a_img=loadImage("bomb.png");
  }
  //显示图片
  void show()
  {
    //如果图片已经相遇 不能再显示
    if(!show)
    return ;//退出该子函数
    
    //当doge可以变化  且当前图片为doge 且之前这张图片没有变da
    if(flag&change&type==2)
     {
       count=10;//数10帧  即变大10帧
       flag=false;
      //change=false;
     }
    if(count>0)
     {
       //a_img=loadImage("2-doge.png");
       size=3;//变大3倍
       count--;
       
     }
     else
     {
        if(count ==0)
        {   
          //10帧后 还原图片状态
          change=false;
          flag=true;
        
        }
        size=1;
        
        
     }
    //到标志为真时  显示图片
     image(a_img,ax,ay,140*size,140*size);
    
    
  }
  //检测是否与拳头相撞
  void check()
  {
    //当图片还显示着 且拳头与其相遇时         自己画图演算
       if(show&(fist_x+75>ax-55)&fist_x+75<ax+195&fist_y+75>ay-55&fist_y+75<ay+195)
         {
           
           if(type==1)
           {//碰到金币
           change=true;//doge可以变化
           score=10+score*2;//分数加倍
           }
           else if(type==2)
           {//碰到doge
           change=false;
           score=score+10;
           }
           else
           {//碰到bomb
           change=false;
           gameover=true;
           }
           show=false;//图片不再显示
           
          }
  }

  
  
} 
    