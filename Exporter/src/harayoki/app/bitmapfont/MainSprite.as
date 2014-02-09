package harayoki.app.bitmapfont
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import harayoki.app.SimpleState;

	public class MainSprite extends Sprite
	{
		private var _app:NativeApplication;
		private var _nativeWindow:NativeWindow;
		private var _panel:AppPanel = new AppPanel();
		private var _state:SimpleState;
		
		public function MainSprite()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		public function init(ev:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
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
			
			_state = new SimpleState();
			_state.onUpdate.add(_update);
			_state.value = AppState.STATE_WAIT_FILE;
			
		}
		
		private function _update():void
		{
			
		}
	}
}