package harayoki.app.data
{

	public class FontData
	{
		// info section
		public var face:String="";
		public var size:int = 0;
		public var bold:int=0;
		public var italic:int=0;
		public var charset:String = "";
		public var unicode:int = 1;
		public var stretchH:int = 100;//用途不明
		public var smooth:int = 1;
		public var aa:int = 1;//用途不明
		public var padding:Array = [0,0,0,0];//用途不明
		public var spacing:Array = [1,1];//用途不明
		public var outline:int = 0;
		
		//common section
		public var lineHeight:int = 0;
		public var base:int = 0;
		public var scaleW:int = 0;
		public var scaleH:int = 0;
		public var pages:int = 1;//複数ファイルにまたがる際に使う？？
		public var packed:int = 0;//用途不明
		
		public var alphaChnl:int = 1;
		public var redChnl:int = 1;//0？
		public var greenChnl:int = 1;//0？
		public var blueChnl:int = 1;//0？
		
		//pages section
		public var id:int = 0;//page id ページだけしかないので0
		public var file:String = "";
		
		public var letters:Vector.<LetterData>;
		
		public function FontData()
		{
			letters = new Vector.<LetterData>();
		}
		
		public function toString():String
		{
			return "[FontData:"+[id,face,lineHeight,"("+(letters ? letters.length : 0)+")"]+"]";
		}
		
		public function dispose():void
		{
			for each(var letter:LetterData in letters)
			{
				letter.dispose();
			}
			letters = null;
		}
	}
}