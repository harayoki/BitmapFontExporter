package harayoki.app.bitmapfont.export
{
	import flash.display.BitmapData;
	
	import harayoki.app.data.FontData;
	import harayoki.app.data.LetterData;
	
	public class TextFntFileMaker implements IFntFileMaker
	{
		private static const INFO_TEMPLATE:String = 
			'info face="${face}" size=${size} bold=${bold} italic=${italic} charset="${charset}" unicode=${unicode} ' +
			'stretchH=${stretchH} smooth=${smooth} aa=${aa} padding=${padding} spacing=${spacing} outline=${outline}';
		
		private static const COMMON_TEMPLATE:String = 
			'common lineHeight=${lineHeight} base=${base} scaleW=${scaleW} scaleH=${scaleH} pages=${pages} packed=${packed}'+
			' alphaChnl=${alphaChnl} redChnl=${redChnl} greenChnl=${greenChnl} blueChnl=${blueChnl}';
		
		private static const PAGE_TEMPLATE:String = 
			'page id=${id} file="${file}"\n' +
			'chars count=${count}';
		
		private static const CHAR_TEMPLATE:String =
			'char id=${id} x=${x}    y=${y}   width=${width}    height=${height}'+
			'    xoffset=${xoffset}     yoffset=${yoffset}    xadvance=${xadvance}    page=${page}  chnl=${chnl}';
			
		private static const instance:TextFntFileMaker = new TextFntFileMaker();
		public static function getInstance():TextFntFileMaker
		{
			return instance;
		}
		
		public function TextFntFileMaker()
		{
		}
		
		public function makeFntFile(fontData:FontData, bitmapData:BitmapData):String
		{
			var str:String = "";
			str += _template(INFO_TEMPLATE,fontData) + "\n";
			str += _template(COMMON_TEMPLATE,fontData) + "\n";
			str += _template(PAGE_TEMPLATE,fontData,{count:fontData.letters.length}) + "\n";
			var i:int;
			for(i=0;i<fontData.letters.length;i++)
			{
				var letter:LetterData = fontData.letters[i];
				str += _template(CHAR_TEMPLATE,letter) + "\n";
			}
			return str;
		}
		
		private function _template(tmpl:String,data:*,data2:*=null):String
		{
			var reg1:RegExp = /\${.+?}/g;
			var reg2:RegExp = /\${(.+?)}/;
			var str:String = tmpl;
			var matchedList:Array = tmpl.match(reg1);
			for(var i:int=0;i<matchedList.length;i++)
			{
				var matched:String = matchedList[i];
				var key:String = matched.slice(2,-1);
				if(data.hasOwnProperty(key))
				{
					str = str.replace("${"+key+"}",data[key]+"");
				}
				else if(data2 && data2.hasOwnProperty(key))
				{
					str = str.replace("${"+key+"}",data2[key]+"");
				}
			}
			return str;
		}
	}
}

/*

sample

info face="小塚明朝 Pro R" size=32 bold=0 italic=0 charset="" unicode=1 stretchH=100 smooth=1 aa=1 padding=0,0,0,0 spacing=1,1 outline=0
common lineHeight=32 base=25 scaleW=256 scaleH=256 pages=1 packed=0 alphaChnl=1 redChnl=0 greenChnl=0 blueChnl=0
page id=0 file="test_0.png"
chars count=91
char id=12353 x=73    y=131   width=15    height=17    xoffset=4     yoffset=10    xadvance=24    page=0  chnl=15
char id=12354 x=22    y=25    width=20    height=22    xoffset=2     yoffset=5     xadvance=24    page=0  chnl=15
:
:
:


*/