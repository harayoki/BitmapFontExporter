package harayoki.app.bitmapfont
{
	import flash.display.BitmapData;

	public class LetterData
	{
		public var id:uint = 0;
		public var width:int = 0;
		public var height:int = 0;
		public var x:int = 0;
		public var y:int = 0;
		public var offsetX:int = 0;
		public var offsetY:int = 0;
		public var advanceX:int = 0;
		public var page:int = 0;
		public var chnl:int = 0;
		public var bitmapData:BitmapData
		
		public function LetterData()
		{
		}
		
		public function toString():String
		{
			return "[LetterData:"+[id+"('"+String.fromCharCode(id)+"')",width,height,offsetX,offsetY,advanceX]+"]";
		}
		
		public function reset():void
		{
			id = 0;
			width = 0;
			height = 0;
			x = y = 0;
			offsetX = offsetY = 0;
			advanceX = 0;
			page = 0;
			chnl = 0;
			if(bitmapData)
			{
				bitmapData.dispose();
			}
			bitmapData = null;
		}
		
		public function dispose():void
		{
			reset();
		}
	}
}