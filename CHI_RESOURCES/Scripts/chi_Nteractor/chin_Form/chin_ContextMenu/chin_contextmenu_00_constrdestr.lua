--######################################################### Constructor
function ContextMenuClass.New(name)
    local this=setmetatable({},ContextMenuClass);
    ContextMenuCount=ContextMenuCount+1;
    
    local objName="ContextMenuCount"..string.format("%03d",ContextMenuCount);
    this.name=name;
    this.xpos=100;
    this.ypos=100;
    this.xSize=200;
    this.ySize=20;
    this.zDepth=2.3;
    
    this.paddingTop=0;
    this.paddingBot=0;
    this.paddingLeft=0;
    this.paddingRight=0;
    
    this.marginTop=0;
    this.marginBot=3;
    this.marginLeft=3;
    this.marginRight=0;
    
    this.eventCallbacks     = {}
    this.eventCallbackCount = 0;
    
    this.cursorPosition=0;
    this.cursorX=0;
    this.lastBlinkUpdated=0.0;
    this.cursorShown=false;
    
    this.float=true;
    this.inputBox=false;
    this.showOutline=false;
    this.fontType=2;
    this.fontColor={0,0,0,1};
    this.inputfontColor={0.5,0.5,0.5,1}
    this.selectfontColor={0,0,0.8,1}
    this.text=name;
    this.inputText="ContextMenuCount"..string.format("%02d",ContextMenuCount);
    r=this.fontColor[1];
    g=this.fontColor[2];
    b=this.fontColor[3];
    a=this.fontColor[4];
    this.master=nil;
    
    this.selected=false;
    this.previousSelected=false;
    this.shiftDown=false;
    
    this.iconSize           = 21;
    this.iconTextureSize    = chinGlobal.Icons.iconTextureSize;
    this.iconCutOutSize     = chinGlobal.Icons.iconsCutSize;
    this.iconPadding        = chinGlobal.Icons.iconPadding;
    this.iconOffset         = chinGlobal.Icons.iconOffset;
    this.iconScale          = chinGlobal.Icons.iconScale;
    this.iconTypeFolder     = chinIconExpander;
    
    this.panelxSize         = 235;
    
    --=========================================== Creating base object
    this.obj1Num=chiObjectCreate(objName);
    chiObjectAddSurface(this.obj1Num,PanelSurface);
    
    this.transform1=chiTransformCreate(objName.."_Transform");
    chiObjectSetProperty(this.obj1Num,"Transform",objName.."_Transform");
    chiTransformSetScale(this.transform1,this.xSize-1,this.ySize-1,1.0)
    chiTransformSetTranslation(this.transform1,this.xpos,this.ypos,this.zDepth)
    
    this.matlNum=chiMaterialCreate(objName .. "_Material");
    chiMaterialSetProperty(this.matlNum,"DisableShading",true);
    ambient=0.97;
    --ambient=1;
    chiMaterialSetProperty(this.matlNum,CHI_DIFFUSE_COLOR,ambient,ambient,ambient,1.0);
    chiObjectSetProperty(this.obj1Num,"Material",objName .. "_Material");
    chiObjectSetProperty(this.obj1Num,"Hidden",true);
    chiObjectSetProperty(this.obj1Num,"donotList",true);
    
    --=========================================== Creating outline    
    this.lineNum=chi3DLineCreate(objName.."outline");
    chi3DLineAddVertex(this.lineNum,this.xpos+this.paddingLeft,this.ypos+this.paddingBot,this.zDepth+0.01);
    chi3DLineAddVertex(this.lineNum,this.xpos+this.paddingLeft,this.ypos+this.ySize-1+this.paddingBot,this.zDepth+0.01);
    chi3DLineAddVertex(this.lineNum,this.xpos+this.xSize-1+this.paddingLeft,this.ypos+this.ySize-1+this.paddingBot,this.zDepth+0.01);
    chi3DLineAddVertex(this.lineNum,this.xpos+this.xSize-1+this.paddingLeft,this.ypos+this.paddingBot,this.zDepth+0.01);
    chi3DLineAddVertex(this.lineNum,this.xpos-1+this.paddingLeft,this.ypos+this.paddingBot,this.zDepth+0.01);

    if (this.showOutline) then
        chi3DLineChangeColor(this.lineNum,0.0,0.0,0.0,1.0);
    else
        chi3DLineChangeColor(this.lineNum,0.0,0.0,0.0,0.0);
    end
    
    --=========================================== Creating text
    this.textNum=chiSetLabel3D(objName,this.text,this.xpos+this.paddingLeft+this.marginLeft,this.ypos+this.paddingBot+this.marginBot,r,g,b,0,this.fontType);
    chiSetLabelProperty(this.textNum,"ViewportEnable",true);
    chiSetLabelProperty(this.textNum,"Viewport",this.xpos+this.paddingLeft,this.ypos+this.paddingBot,this.xpos+this.xSize-1+this.paddingLeft-this.iconSize,this.ypos+this.ySize-1+this.paddingBot);
    chiSetLabelProperty3D(this.textNum,"Depth",this.zDepth+0.01);
    
    --=========================================== Panel for list
    this.panel1=PanelClass.New(objName.."Panel");
    this.panel1.zDepth=this.zDepth;
    this.panel1.xmin=this.xpos;
    this.panel1.ymax=this.ypos+1;
    this.panel1.xmax=this.panel1.xmin+this.panelxSize+1;
    this.panel1.ymin=this.panel1.ymax-this.ySize;
    this.panel1.SizeChanged(this.panel1);
    ambient=0.97;
    chiMaterialSetProperty(this.panel1.matlNum,CHI_DIFFUSE_COLOR,ambient,ambient,ambient,1.0);
    
    this.list={};
    this.listCount=0;
    
    chiObjectSetProperty(this.panel1.obj1Num,"Hidden",true);
    this.panel1.Hide(this.panel1);
    
    for k=1,this.listCount do
        this.list[k].Hide(this.list[k]);
    end
    
    
    return this;
end