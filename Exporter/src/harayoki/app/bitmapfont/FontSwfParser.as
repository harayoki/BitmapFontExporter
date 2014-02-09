package harayoki.app.bitmapfont
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	public class FontSwfParser
	{
		
		private static const BORDER_CLIP_NAME:String = "border";
		
		private var _swf:MovieClip;
		private var _parseStep:int;
		private var _fontData:FontData;
		public var onParseEnd:Signal = new Signal();
		
		private var _targetClips:Vector.<MovieClip>;
		
		private var _isValid:Boolean = false;
		private var _errorMessage:String;
		
		public function FontSwfParser()
		{
			_targetClips = new Vector.<MovieClip>();
		}
		
		public function get isValid():Boolean
		{
			return _isValid;
		}
		
		public function reset():void
		{
			_isValid = false;
			_errorMessage = null;
			if(_swf)
			{
				_swf.removeEventListener(Event.ENTER_FRAME,_handleEnterFrame);
			}
			_swf = null;
			if(_targetClips)
			{
				_targetClips.length = 0;
			}
			if(_fontData)
			{
				_fontData.dispose();
			}
			_fontData = null;
			if(onParseEnd)
			{
				onParseEnd.removeAll();
			}
		}

		public function dispose():void
		{
			reset();
			_targetClips = null;
			onParseEnd = null;
		}
		
		public function parse(swf:MovieClip):void
		{
			_swf = swf;
			_fontData = new FontData();
			_isValid = false;
			_targetClips.length=0;
			_parseStep = -1;
			_swf.addEventListener(Event.ENTER_FRAME,_handleEnterFrame);
			_handleEnterFrame();
		}
		
		public function getFontData():FontData
		{
			return _fontData;
		}
		
		public function getErrorMessage():String
		{
			return _errorMessage ? _errorMessage : "";//errorInfo
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
					if(error) _errorMessage = "no valid clips (error#1)";
					break;
				}
				case 1:
				{
					if(_targetClips.length>0)
					{
						_createLetterData(_targetClips.pop());
					}
					else
					{
						error = (_fontData.letters.length == 0);
						if(error) _errorMessage = "no valid clips (error#2)";
					}
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
				if(child && child.currentScene.labels.length>0)
				{
					_targetClips.push(child);
				}
			}
			return _targetClips.length == 0;
		}
		
		private function _createLetterData(mc:MovieClip):Boolean
		{
			var error:Boolean = false;
			var letterData:LetterData = new LetterData();
			var border:DisplayObject = mc.getChildByName(BORDER_CLIP_NAME);
			if(error)
			{
				letterData.dispose();
			}
			else
			{
				_fontData.letters.push(letterData);
			}
			return error;
		}
		
		private function _finishParseing():void
		{
			_swf.removeEventListener(Event.ENTER_FRAME,_handleEnterFrame);
			onParseEnd.dispatch();
		}
	}
}