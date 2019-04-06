/**
 * Created by sxc on 2016/11/23 0018.
 *
 */

 var nRichDataType = {
    nText : 1, //纯文本
    nImg  : 2, //图片
    nAni  : 3, //动画
    nLink : 4 //超链接
};

var nRichKeys = {
    nKey : "|",
    nColorKey : "color",
    nSizeKey : "size",
    nImgKey : "img",
    nAniKey : "ani",
    nLineSpaceKey : "linespace",
    nFontKey : "font",
    nEnt : "n"
};

var RichTexts = ccui.Widget.extend({
    _root:null,
    m_img_Path:null,
    nTag:0,
    m_RichType:0,
    m_Parent:null,
    m_IsScale:1,
    nRichData:null,
    nRichText:null,
    nRichDimensions:null,
    nFontSize:null,
    nFontType:null,
    nColorText:null,
    nImgPath:null,
    nAniName:null,
    nLineSpace:0,
    nEnt:0,
    _richLabel:null,
    ctor:function(nData , nDimensions ,nType, nAnchorPt, nScaleNum) {

        this.m_RichType         = nType;
        this.nRichData 			= nData; 					//用户输入的字符
        this.nRichText 			= "";						//用户输入的纯文字
        this.nRichDimensions	= nDimensions;				//富文本的边界尺寸
        this.nFontSize 			= 20;						//文本要求字体尺寸
        this.nFontType 			= "default"	;				//字体类型
        this.nColorText 		= cc.color.WHITE;				//当前字体颜色
        this.nImgPath			= "";						//插入的图片路径
        this.nAniName			= "";						//插入的动画路径
        this.nLineSpace 		= 0	;						//文件间隙（空格）
        this.nEnt 				= 0;							//文本换行数

        if (nScaleNum != null){
            m_IsScale = nScaleNum;
        }
        //判断是否有转义字符
        this.JudgeEscapeStr();

        //var _richLabel = RichText.create();
        this._richLabel = new ccui.RichText();
        this._richLabel.ignoreContentAdaptWithSize(false);
        this._richLabel.setSize(cc.size(nDimensions,0));
        this._richLabel.setTouchEnabled(true);
        this._richLabel.setTag(10000);
        //this._richLabel.addTouchEventListener(_Image_Click_CallBack);
        if (nAnchorPt != null){
            this._richLabel.setAnchorPoint(nAnchorPt)
        } else{
            this._richLabel.setAnchorPoint(cc.p(0,1))
        }

        var nAttrIdx = this.nRichData.indexOf(nRichKeys.nKey,1);
        if (nAttrIdx != null && nAttrIdx > 1){ //--说明数据开头没有属性标识
            var str = this.nRichData.substring(1,nAttrIdx - 1);
            this.InsertRichLabelTextItem( this.nTag, str , this.nFontSize, this.nColorText, this.nFontType, this._richLabel);
        }
        //1.解析nData数据
        this.nRichData = this.FindAttrKeys(this.nRichData);
        this.AnalyzeData(this.nRichData);
        this.nTag = 1;
        this._richLabel.formatText();
        this.m_Parent = this._richLabel;
        return true;//this._richLabel
    },

    //判断是否有转义字符
    JudgeEscapeStr:function(){
        var ntmpStr = this.nRichData;
        var nEscapeStrIdx = ntmpStr.indexOf("#");

        if (nEscapeStrIdx !=-1) {
            var nfaceStr = ntmpStr.substring(nEscapeStrIdx + 1, nEscapeStrIdx + 2);
            var nfaceId = parseInt(nfaceStr);
            if (nfaceId && nfaceId < 23) {
                //var nfacePath = string.format("|ani|biaoqing%03d|", nfaceId);
                var nfacePath = "|img|res/ui/image/chat/biaoqing/"+nfaceId.toFixed(3)+".png|";
                this.nRichData = this.nRichData.replace("#" + nfaceStr, nfacePath);
                this.JudgeEscapeStr()
            } else {
                cc.log("id no find")
            }
        }else{
            cc.log("no Face!")
        }
    },

    FindAttrKeys:function( nRichData ){
        var nAttrIdx = nRichData.indexOf(nRichKeys.nKey,1);							//--找到属性的起始 "|"
        if (nAttrIdx != -1){
            var nAttrEndIdx = nRichData.indexOf(nRichKeys.nKey,nAttrIdx + 1);		  		//--找到属性的结束 "|"
            var nAttrType   = nRichData.substring(nAttrIdx + 1,nAttrEndIdx - 1); 				//--找到属性类型
            var nNumEndIdx 	= nRichData.indexOf(nRichKeys.nKey,nAttrEndIdx + 1);
            if (nAttrType == nRichKeys.nColorKey){
                var nDivInx1 = nRichData.indexOf( ",", nAttrEndIdx + 1);
                var nR 		= nRichData.substring(nAttrEndIdx + 1, nDivInx1 - 1);
                var nDivInx2  = nRichData.indexOf( ",", nDivInx1 + 1);
                var nG 	= nRichData.substring( nDivInx1 + 1, nDivInx2 - 1);
                var nDivEndInx   = nRichData.find( "|", nDivInx2 + 1);
                var nB 	= nRichData.substring( nDivInx2 + 1, nDivEndInx - 1);
                this.nColorText   = cc.color(parseInt(nR), parseInt(nG), parseInt(nB));
            }else if (nAttrType == "size" ){
                var sizeStr		= nRichData.substring( nAttrEndIdx + 1, nNumEndIdx - 1);
                this.nFontSize 	= parseInt(sizeStr);
            }else if (nAttrType == nRichKeys.nImgKey){
                if (nNumEndIdx != -1){
                    this.nImgPath 	= nRichData.substring( nAttrEndIdx + 1, nNumEndIdx - 1);
                    this.InsertRichLabelImageItem(this.nTag ,this.nImgPath , this._richLabel)
                }else if (nAttrType == nRichKeys.nAniKey ){
                    if (nNumEndIdx != -1){
                        this.nAniName 	= nRichData.substring( nAttrEndIdx + 1, nNumEndIdx - 1);
                        this.InsertRichLabelAnimationItem(this.nTag ,this.nAniName , this._richLabel)
                    }
                }else if (nAttrType == nRichKeys.nLineSpaceKey) {
                    var lineSpaceStr	= nRichData.substring(nAttrEndIdx + 1, nNumEndIdx - 1);
                    this.nLineSpace 	= parseInt(lineSpaceStr);
                    var str = "";
                    for (var i = 1;i<=nLineSpace;i++) {
                        str = str+"  ";
                    }
                    this.InsertRichLabelTextItem( this.nTag, str , this.nFontSize, this.nColorText, this.nFontType, this._richLabel);
                }else if (nAttrType == nRichKeys.nFontKey){
                    var fontStr		= nRichData.substring(nAttrEndIdx + 1, nNumEndIdx - 1);
                    if (fontStr == "font1" ){
                        this.nFontType = CommonData.g_FONT1;
                    }else if (fontStr == "font2"){
                        this.nFontType = CommonData.g_FONT2;
                    }else{
                        cc.log("font error !");
                    }
                }else if (nAttrType == nRichKeys.nEnt){
                    var entSpaceStr	= nRichData.substring(nAttrEndIdx + 1, nNumEndIdx - 1);
                    this.nEnt = parseInt(entSpaceStr);
                    addNewLine = function( nNewLineNum ){
                        for (var i=1;i<=nNewLineNum;i++){
                            this._richLabel.pushNewLineElement()
                        }
                    };
                    addNewLine(this.nEnt)
                } else{
                    cc.log("key error !")
                }
                var nDataLength = nRichData.len;
                var DivData 	= nRichData.substring(nNumEndIdx + 1,nDataLength);
                return DivData
            }else{
                return nRichData
            }
        }
    },

    AnalyzeData:function( nRichData ){
        var nKeyIndex = nRichData.indexOf("|",1);
        var nEndIndex = null;
        if (nKeyIndex != null){
            nEndIndex = nRichData.indexOf("|",nKeyIndex + 1);
        }
        if (nKeyIndex == 1){
            //--此时有属性
            if (nEndIndex != null){
                nRichData   = FindAttrKeys(nRichData);
                this.AnalyzeData(nRichData);
            }
        }else if (nKeyIndex == -1){
            //--此时无属性并且之后也不再有属性
            this.nRichText   = nRichData;
            this.InsertRichLabelTextItem( this.nTag, this.nRichText , this.nFontSize, this.nColorText, this.nFontType, this._richLabel);
        }else{
            //--此时Data里有"|"
            if (nEndIndex > 0){
                //--此时在文本之后有属性改变
                this.nRichText   = nRichData.substring(1,nKeyIndex - 1);
                this.InsertRichLabelTextItem( this.nTag, this.nRichText , this.nFontSize, this.nColorText, this.nFontType, this._richLabel);
                nRichData   = this.FindAttrKeys(nRichData);
                this.AnalyzeData(nRichData);
            }else{
                this.nRichText   = nRichData;
                this.InsertRichLabelTextItem( this.nTag, this.nRichText , this.nFontSize, this.nColorText, this.nFontType, this._richLabel);
            }
        }
    },

    _Image_Click_Callback:function(sender){

    },

    //add Animation
    InsertRichLabelAnimationItem:function( nAniTag ,nAniName ,nParent ){
        CCArmatureDataManager.sharedArmatureDataManager().addArmatureFileInfo("Image/imgres/chat/biaoqing/biaoqing.ExportJson");
        var PayArmature = CCArmature.create("biaoqing");
        if (m_IsScale != 1){
            var size = PayArmature.getContentSize();
            var width = size.width * m_IsScale;
            var height = size.height * m_IsScale;
            PayArmature.setScale(m_IsScale);
            PayArmature.setContentSize(CCSize(width,height));
        }

        PayArmature.getAnimation().play(nAniName);
        var recustom = RichElementCustomNode.create(1, COLOR_White, 255, PayArmature);
        nParent.pushBackElement(recustom);
        nTag = nTag + 1;
    },

    //add Image
    InsertRichLabelImageItem:function( nImgTag, nImgPath ,nParent ){
        var reimg = new ccui.RichElementImage(nImgTag,cc.color(255,255,255),255,nImgPath);
        if (m_RichType == 0){
            nParent.pushBackElement(reimg);
        } else if (m_RichType == 1) {
                //nParent.pushTouchElement(reimg)
                nParent.pushBackElement(reimg);
        }
        this.nTag = this.nTag + 1
    },
    //add Text
    InsertRichLabelTextItem:function( nTextTag, nStrText , nFontSize, nColorText, nFontType, nParent){
        var re1 = new ccui.RichElementText(1,cc.color(255,255,255),255,nStrText,"Helvetica",nFontSize);
        if (nParent == null){
            this.m_Parent.pushBackElement(re1);
        }else{
            nParent.pushBackElement(re1)
        }
        this.nTag = this.nTag + 1;
    },

    //add CustomNode
    InsertRichLabelCoustomItem:function( nNodeTag,nParent ){
        var cus1 = RichElementCustomNode.create(nNodeTag,cc.color(0,0,0),255,img);
        nParent.pushBackElement(cus1);
        nTag = nTag + 1;
    },

    AddCustomItem:function( nNode ,nScale){
        var pNode = CCNode.create();
        pNode.setContentSize(nNode.getContentSize());
        nNode.setPosition(cc.p(nNode.getContentSize().width * 0.5 , nNode.getContentSize().height * 0.5));
        pNode.addChild(nNode);
        pNode.setScale(nScale);
        var cus1 = RichElementCustomNode.create(this.nTag,cc.color(0,0,0),255,pNode);
        m_Parent.pushBackElement(cus1);
    },

    CreateLabelItem:function( nStrText , nFontSize, nColorText, nFontType, nParent, nRichDimensions ){
        //创建label前先判断自己还有多少空间可以添加字符
        var nSurplusWidth = nRichDimensions - nCurrWidth;
        //取得所有单个字符
        var nCharList,strLen = ComminuteText(nStrText);

        var _Label_ = Label.create();
        _Label_.setFontSize(nFontSize);
        _Label_.setColor(nColorText);

        if (nFontType != "default" ){
            _Label_.setFontName(nFontType)
        }

        var nLabelRender = tolua.cast(_Label_.getVirtualRenderer(),"CCLabelTTF");

        var Size = _Label_.getContentSize();
        nCurrWidth = nCurrWidth + Size.width;

        _Label_.setText(nStrText);
        _Label_.setPosition(cc.p(nPosX, nPosY));
        _Label_.setAnchorPoint(cc.p(0,0.5));
        nParent.addChild(_Label_);
        nPosX = nPosX + Size.width;
    }

});