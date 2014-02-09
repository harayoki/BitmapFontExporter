package harayoki.app.bitmapfont
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.NativeWindow;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import harayoki.app.SimpleState;
	import harayoki.app.bitmapfont.export.FntExporter;
	import harayoki.app.bitmapfont.export.TextFntFileMaker;
	import harayoki.app.bitmapfont.export.XmlFntFileMaker;
	import harayoki.app.bitmapfont.pack.LetterPacker;
	import harayoki.app.data.FontData;
	import harayoki.app.data.LetterData;

	public class MainSprite extends Sprite
	{
		private var _app:NativeApplication;
		private var _nativeWindow:NativeWindow;
		private var _panel:AppPanel = new AppPanel();
		private var _state:SimpleState;
		private var _ddd:DragAndDropDetector;
		private var _swffile:File;
		private var _fontSwfParser:FontSwfParser;
		private var _letterPacker:LetterPacker;		
		private var _preview:Bitmap;
		private var _previewBg:Shape;
		
		public function MainSprite()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		public function init(ev:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			_app  = NativeApplication.nativeApplication;
			_nativeWindow = stage.nativeWindow;
			
			_nativeWindow.alwaysInFront = true;
			
			addChild(_panel);
			_panel.btnClose.addEventListener(MouseEvent.CLICK,function(ev:MouseEvent):void{
				_app.exit();
			});
			_panel.btnLoad.addEventListener(MouseEvent.CLICK,function(ev:MouseEvent):void{
				_state.value = AppState.WAIT_FILE;
			});
			_panel.bg.addEventListener(MouseEvent.MOUSE_DOWN,function(ev:MouseEvent):void
			{
				_nativeWindow.startMove();
			});
			_panel.dropTaeget.addEventListener(MouseEvent.MOUSE_DOWN,function(ev:MouseEvent):void
			{
				_nativeWindow.startMove();
			});
			_panel.btnPreview.addEventListener(MouseEvent.CLICK,function(ev:MouseEvent):void
			{
				_showPreview();
			});
			_panel.btnExport.addEventListener(MouseEvent.CLICK,function(ev:MouseEvent):void
			{
				_expottData();
			});
			
			_panel.messages.mouseEnabled = false;
			_panel.messages.mouseChildren = false;
			_panel.preview.mouseEnabled = false;
			
			_panel.uiFontHeight.value = 12;
			
			_ddd = new DragAndDropDetector(_panel.dropTaeget);
			_ddd.onDrop.add(_onDropSwf);
			
			_fontSwfParser = new FontSwfParser();
			_letterPacker = new LetterPacker();
			
			_previewBg = new Shape();
			_preview = new Bitmap();
			_panel.preview.addChild(_previewBg);
			_panel.preview.addChild(_preview);
			_panel.preview.scrollRect = new Rectangle(0,0,_panel.preview.width,_panel.preview.height);
			
			_state = new SimpleState();
			_state.onUpdate.add(_update);
			_state.value = AppState.WAIT_FILE;
			
		}
		
		private function _update():void
		{
			var uiEnabled:Boolean = false;
			var acceptDragDrop:Boolean = false;
			var cleanPreview:Boolean;
			_panel.dropTaeget.visible = false;
 
			switch(_state.value)
			{
				case AppState.WAIT_FILE:
				{
					cleanPreview = true;
					acceptDragDrop = true;
					break;
				}
				case AppState.LOAD_AND_PARSE_SWF:
				{
					break;
				}
				case AppState.EDIT:
				{
					uiEnabled = true;
					break;
				}
				case AppState.EXPORT:
				{
					break;
				}
				case AppState.DONE:
				{
					break;
				}
				case AppState.ERROR:
				{
					break;
				}
			}
			_setUiEnabled(uiEnabled);
			_panel.messages.gotoAndStop(_state.value+1);
			_ddd.enabled = acceptDragDrop;
			_panel.dropTaeget.visible = acceptDragDrop;
			if(cleanPreview)
			{
				_cleanPreview();
			}
		}
		
		private function _setUiEnabled(enabled:Boolean):void
		{
			_panel.uiFntFileName.enabled = enabled;
			_panel.uiFntFormat.enabled = enabled;
			_panel.uiFontHeight.enabled = enabled;
			_panel.uiScale.enabled = enabled;
			_panel.uiFontName.enabled = enabled;
			_panel.uiImageFileName.enabled = enabled;
			_panel.uiImageHeight.enabled = enabled;
			_panel.uiImageWidth.enabled = enabled;
			_panel.btnLoad.enabled = enabled
			_panel.btnPreview.enabled = enabled;
			_panel.btnExport.enabled = enabled;
		}
		
		private function _onDropSwf():void
		{
			_swffile = _ddd.getLastDropFiles()[0];
			_loadSwf();
		}
		
		private function _loadSwf():void
		{
			_state.value = AppState.LOAD_AND_PARSE_SWF;
			
			var loader:Loader = new Loader();
			var req:URLRequest = new URLRequest(_swffile.url);
			function onLoadError(ev:ErrorEvent):void
			{
				cleanLoader();
				_showErrorAndNextState(AppState.WAIT_FILE,"swf load error");
			};
			function onLoadComplete(ev:Event):void
			{
				cleanLoader();
				_parseSwf(loader.content as MovieClip);
			};
			function cleanLoader():void
			{
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLoadError);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLoadComplete);
			}
			loader.load(req);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
		}
		
		private function _parseSwf(swf:MovieClip):void
		{
			_fontSwfParser.reset()
			_fontSwfParser.parse(swf);
			_fontSwfParser.onParseEnd.addOnce(
				function():void{
					
					if(_fontSwfParser.isValid)
					{
						_updateUiValues();
						//念のため負荷分散
						flash.utils.setTimeout(function():void{
							_showPreview();
						},1);
						flash.utils.setTimeout(function():void{
							_state.value = AppState.EDIT;
						},2);
					}
					else
					{
						_showErrorAndNextState(AppState.WAIT_FILE,_fontSwfParser.getErrorMessage());
					}
				});
		}
		
		private function _showErrorAndNextState(nextState:int,errorMessage:String,wait:uint=5000):void
		{
			_panel.messages.errorInfo.text = errorMessage;
			_state.value = AppState.ERROR;
			flash.utils.setTimeout(function():void{
				_panel.messages.errorInfo.text = "";
				_state.value = nextState;
			},wait);
		}
		
		private function _changeStateAndNextState(currentState:int,nextState:int,wait:uint=5000):void
		{
			_state.value = currentState;
			flash.utils.setTimeout(function():void{
				_state.value = nextState;
			},wait);
		}
		
		private function _updateUiValues():void
		{
			var arr:Array = _swffile.name.split(".");
			arr.pop();
			var name:String = arr.join(".");
			
			var fontData:FontData = _fontSwfParser.getFontData();
			
			_panel.uiImageWidth.selectedIndex = 2;//256
			_panel.uiImageHeight.selectedIndex = 2;//256
			
			_panel.uiFntFileName.text = name+".fnt";
			_panel.uiFontName.text = name;
			_panel.uiImageFileName.text = name+".png";
			
			var h:int = 0;
			var i:int = 0;
			for(i=0;i<fontData.letters.length;i++)
			{
				h = Math.max(fontData.letters[i].height);
			}
			
			_panel.uiFontHeight.value = h;
		}

		private function getNearest2N(_n:uint):uint
		{
			return _n & _n - 1?1 << _n.toString(2).length:_n;
		}
		
		private function _cleanPreview():void
		{
			if(_preview.bitmapData)
			{
				_preview.bitmapData.dispose();
			}
		}
		
		private function _showPreview():void
		{
			_cleanPreview();
			var w:int = parseInt(_panel.uiImageWidth.selectedLabel,10)
			var h:int = parseInt(_panel.uiImageHeight.selectedLabel,10);
			var scale:Number = _panel.uiScale.value;
			
			_letterPacker.imageWidth = w;;
			_letterPacker.imageHeight = h;
			var fontData:FontData = _fontSwfParser.getFontData();
			fontData.lineHeight = _panel.uiFontHeight.value * scale;
			var bmd:BitmapData = _letterPacker.execute(fontData,scale);
			_preview.bitmapData = bmd;
			var preViewScale:Number = Math.min(256/w,256/h);
			preViewScale = Math.min(preViewScale,1.0);
			_preview.scaleX = _preview.scaleY = preViewScale;
			_previewBg.scaleX = _previewBg.scaleY = preViewScale;
			
			_previewBg.graphics.clear();
			_previewBg.graphics.lineStyle(0,0,0.5);
			_previewBg.graphics.drawRect(0,0,w,h);
			_previewBg.graphics.lineStyle(0,0,0.25);
			for(var i:int=0;i<fontData.letters.length;i++)
			{
				var letter:LetterData = fontData.letters[i];
				_previewBg.graphics.drawRect(letter.x,letter.y,letter.width,letter.height);
			}
		}
		
		private function _expottData():void
		{
			
			_state.value = AppState.EXPORT;
			
			_showPreview();
			
			setTimeout(__expottData,1);
			
		}
		
		private function __expottData():void
		{
			
			var fontData:FontData = _fontSwfParser.getFontData();
			var bmd:BitmapData = _preview.bitmapData;
			fontData.face = _panel.uiFontName.text;
			fontData.size = _panel.uiFontHeight.value * _panel.uiScale.value;
			
			fontData.lineHeight = fontData.size;
			fontData.scaleW = _preview.bitmapData.width;
			fontData.scaleH = _preview.bitmapData.height;
			fontData.file = _panel.uiImageFileName.text;
			
			var exporter:FntExporter = new FntExporter();
			if(_panel.uiFntFormat.text.toLowerCase() == "xml")
			{
				exporter.fntFileMaker = XmlFntFileMaker.getInstance();
			}
			else
			{
				exporter.fntFileMaker = TextFntFileMaker.getInstance();
			}
			
			function onExportData():void
			{
				if(exporter.canceled)
				{
					_state.value = AppState.EDIT;
				}
				else if(exporter.successed)
				{
					_changeStateAndNextState(AppState.DONE,AppState.EDIT,3000);
				}
				else
				{
					_showErrorAndNextState(AppState.EDIT,exporter.errorMessage);
				}
			}
			
			exporter.onResult.addOnce(onExportData);
			exporter.export(_panel.uiFntFileName.text,fontData,bmd);
		}
		
		private function _debugDrawFontData(fontData:FontData):void
		{
			trace("fontData :",fontData);
			var xx:int = 0;
			for(var i:int=0;i<fontData.letters.length;i++)
			{
				var letterData:LetterData = fontData.letters[i];
				trace("letterData :",letterData);
				var bmp:Bitmap = new Bitmap(letterData.bitmapData);
				bmp.x = xx;
				stage.addChild(bmp);
				xx += bmp.width;
			}
		}
	}
}