package harayoki.app.bitmapfont.pack
{
	import flash.display.BitmapData;
	import harayoki.app.data.LetterData;

	public interface IPackingAlgorithm
	{
		function execute(letters:Vector.<LetterData>,bitmapData:BitmapData,lineHeight:int):void;
	}
}