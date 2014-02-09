package harayoki.app.bitmapfont
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	public class ParsedSwfData
	{
		
		private static const BORDER_CLIP_NAME:String = "border";
		
		private var _swf:MovieClip;
		private var _parseStep:int;
		public var onParseEnd:Signal = new Signal();
		
		private var _targetClips:Vector.<MovieClip>;
		
		private var _isValid:Boolean = false;
		
		public function ParsedSwfData()
		{
			_targetClips = new Vector.<MovieClip>();
		}
		
		public function get isValid():Boolean
		{
			return _isValid;
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
			_targetClips = null;
		}
		
		public function parse(swf:MovieClip):void
		{
			_swf = swf;
			_isValid = false;
			_targetClips.length=0;
			_parseStep = -1;
			_swf.addEventListener(Event.ENTER_FRAME,_handleEnterFrame);
			_handleEnterFrame();
		}
		
		private function _handleEnterFrame(ev:Event=null):void
		{
			var error:Boolean = false;
			var step:int = 1;
			switch(_parseStep)
			{
				case 0:
				{
					error = _serachTargetClips();
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
					_isValid = true;
					_finishParseing();
					break;
				}
			}
			if(error)
			{
				_finishParseing();
			}
			else
			{
				_parseStep += step;
			}
		}
		
		private function _serachTargetClips():Boolean
		{
			var i:int = _swf.numChildren;
			while(i--)
			{
				var child:MovieClip = _swf.getChildAt(i) as MovieClip;
				if(child && child.hasOwnProperty(BORDER_CLIP_NAME) && child.currentScene.labels.length>0)
				{
					_targetClips.push(child);
				}
			}
			
			return _targetClips.length > 0;
		}
		
		private function _finishParseing():void
		{
			_swf.removeEventListener(Event.ENTER_FRAME,_handleEnterFrame);
			onParseEnd.dispatch();
		}
	}
}