package harayoki.app.bitmapfont
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	public class FontSwfData
	{
		private var _swf:MovieClip;
		private var _parseStep:int;
		public var onParseEnd:Signal = new Signal();
		
		public var isValid:Boolean = false;
		
		public function FontSwfData()
		{
		}
		
		public function dispose():void
		{
			if(_swf)
			{
				_swf.removeEventListener(Event.ENTER_FRAME,_handleEnterFrame);
			}
			_swf = null;
			if(onParseEnd)
			{
				onParseEnd.removeAll();
			}
			onParseEnd = null;
		}
		
		public function parse(swf:MovieClip):void
		{
			_swf = swf;
			_parseStep = -1;
			_swf.addEventListener(Event.ENTER_FRAME,_handleEnterFrame);
			_handleEnterFrame();
		}
		
		private function _handleEnterFrame(ev:Event=null):void
		{
			_parseStep++;
			switch(_parseStep)
			{
				case 0:
				{
					
					break;
				}
				case 1:
				{
					
					break;
				}
				case 2:
				{
					
					break;
				}
				case 3:
				{
					_finishParseing();
					break;
				}
			}
		}
		
		private function _finishParseing():void
		{
			_swf.removeEventListener(Event.ENTER_FRAME,_handleEnterFrame);
			onParseEnd.dispatch();
		}
	}
}