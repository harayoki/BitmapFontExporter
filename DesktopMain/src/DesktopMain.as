package
{
	import flash.display.Sprite;
	
	[SWF(width='640', height='960', backgroundColor='#111111', frameRate='60')] 
	public class DesktopMain extends Sprite
	{
		public function DesktopMain()
		{
			MainSprite.main(stage);
		}
	}
}