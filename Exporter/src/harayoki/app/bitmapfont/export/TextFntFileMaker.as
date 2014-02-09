package harayoki.app.bitmapfont.export
{
	import flash.display.BitmapData;
	
	import harayoki.app.data.FontData;
	
	public class TextFntFileMaker implements IFntFileMaker
	{
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
			return null;
		}
	}
}