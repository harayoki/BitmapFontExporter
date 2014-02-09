package harayoki.app.bitmapfont.export
{
	import flash.display.BitmapData;
	
	import harayoki.app.data.FontData;

	public interface IFntFileMaker
	{
		function makeFntFile(fontData:FontData,bitmapData:BitmapData):String;
	}
}