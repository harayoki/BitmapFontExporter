package harayoki.app.bitmapfont
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
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
						error = _createLetterData(_targetClips.pop());
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
			var charCodes:Vector.<int> = new Vector.<int>();
			_errorMessage = _getCharCodeList(mc,charCodes);
			if(_errorMessage)
			{
				return false;
			}
			
			var i:int = 0;
			for(i=0;i<charCodes.length;i++)
			{
				mc.gotoAndStop(i+1);
				var border:DisplayObject = mc.getChildByName(BORDER_CLIP_NAME);
				var charCode:int = charCodes[i];
				var letterData:LetterData = new LetterData();
				letterData.id = charCode;
				letterData.x = 0;
				letterData.y = 0;
				letterData.offsetX = 0;//TODO borderを消して計算できる
				letterData.offsetY = 0;
				letterData.width = border ? border.width : mc.width;
				letterData.height = border ? border.height : mc.height;
				letterData.advanceX = letterData.width;
				if(border)
				{
					border.visible = false;
				}
				var bmd:BitmapData = new BitmapData(letterData.width,letterData.height,true,0);
				bmd.drawWithQuality(mc,null,null,null,null,true,StageQuality.BEST);
				letterData.bitmapData = bmd;
				_fontData.letters.push(letterData);
			}
			return false;
		}
		
		private function _getCharCodeList(mc:MovieClip,fontIdList:Vector.<int>):String
		{
			fontIdList.length = 0;
			var labels:Vector.<FrameLabel> = Vector.<FrameLabel>(mc.currentScene.labels);
			if(labels.length==0)
			{
				return "labels not found ("+mc.name+")";
			}
			if(labels[0].frame!=1)
			{
				return "invalid labels ("+mc.name+")";
			}
			var arr:Array = new Array(mc.totalFrames);
			var i:int = 0;
			for(i=0;i<labels.length;i++)
			{
				var label:FrameLabel = labels[i];
				var charCode:int = _labelName2CharCode(label.name);
				if(charCode==-1)
				{
					return "invalid label name ("+mc.name+" "+label.name+")";
				}
				arr[label.frame-1] = charCode;
			}
			for(i=0;i<arr.length;i++)
			{
				if(arr[i]==null)
				{
					arr[i] = arr[i-1] + 1;
				}
				fontIdList.push(arr[i]);
			}
			trace("chars :",fontIdList);
			
			return null;
		}
		
		private function _labelName2CharCode(name:String):int
		{
			name = name.toLowerCase();
			var i:int = name.length;
			while(i--)
			{
				var code:int = name.charCodeAt(i)
					if(code != 120 && code <48 && code > 57)
					{
						//xでも数字でもない物があればはじく
						return -1;
					}
			}
			if(name.indexOf("0x")==0)
			{
				return parseInt(name,16);
			}
			return parseInt(name,10);
		}
		
		private function _finishParseing():void
		{
			_swf.removeEventListener(Event.ENTER_FRAME,_handleEnterFrame);
			onParseEnd.dispatch();
		}
	}
}