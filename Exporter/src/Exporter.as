package
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	[SWF(width='640', height='410', backgroundColor='#111111', frameRate='30')] 
	public class Exporter extends Sprite
	{
		private var _app:NativeApplication;
		private var _nativeWindow:NativeWindow;
		private var _panel:AppPanel = new AppPanel();
		
		public function Exporter()
		{
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_app  = NativeApplication.nativeApplication;
			_nativeWindow = stage.nativeWindow;
			
			addChild(_panel);
			_panel.btnClose.addEventListener(MouseEvent.CLICK,function(ev:MouseEvent):void{
				_app.exit();
			});
			_panel.bg.addEventListener(MouseEvent.MOUSE_DOWN,function(ev:MouseEvent):void
			{
				_nativeWindow.startMove();
			});
			
		}
	}
}