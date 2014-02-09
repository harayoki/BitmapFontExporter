package harayoki.app.bitmapfont.pack
{
	import flash.display.BitmapData;
	
	import harayoki.app.data.FontData;

	public class LetterPacker
	{
		public var imageWidth:int = 256; 
		public var imageHeight:int = 256; 
		
		private var _algorithm:SimplePackingAlgorithm;
		
		public function LetterPacker()
		{
			_algorithm = new SimplePackingAlgorithm();
		}
		
		public function execute(fontData:FontData,scale:Number=1.0):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData(imageWidth,imageHeight,true,0);
			_algorithm.execute(fontData.letters,bitmapData,fontData.lineHeight,scale);
			return bitmapData;
		}
		
	}
}

/*

fnt format
http://noriki.cocolog-nifty.com/blog/2012/04/xcod.html

Max rects
http://wiki.unity3d.com/index.php?title=MaxRectsBinPack

unicode 
http://www.tamasoft.co.jp/ja/general-info/unicode.html

*/