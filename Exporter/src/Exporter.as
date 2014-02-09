package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import harayoki.app.bitmapfont.MainSprite;
	
	[SWF(width='640', height='480', backgroundColor='#111111', frameRate='30')] 
	public class Exporter extends Sprite
	{
		
		public function Exporter()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addChild(new MainSprite());
		}

	}
}