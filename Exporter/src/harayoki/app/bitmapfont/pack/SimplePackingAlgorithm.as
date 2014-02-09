package harayoki.app.bitmapfont.pack
{
	import flash.display.BitmapData;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	
	import harayoki.app.data.LetterData;
	
	public class SimplePackingAlgorithm implements IPackingAlgorithm
	{
		private static const MATRIX:Matrix = new Matrix();
		
		public function SimplePackingAlgorithm()
		{
		}
		
		public function execute(letters:Vector.<LetterData>, bitmapData:BitmapData, lineHeight:int):void
		{
			var _x:int = 0;
			var _y:int = 0;
			var i:int=0;
			for(i=0;i<letters.length;i++)
			{
				var letter:LetterData = letters[i];
				MATRIX.identity();
				if(_x + letter.width > bitmapData.width)
				{
					_x = 0;
					_y += lineHeight;
				}
				MATRIX.translate(_x,_y);
				
				if(_y <= bitmapData.height)
				{
					bitmapData.drawWithQuality(letter.bitmapData,MATRIX,null,null,null,true,StageQuality.BEST);
				}
				letter.x = _x;
				letter.y = _y;
				_x += letter.width;
			}
			
		}
	}
}