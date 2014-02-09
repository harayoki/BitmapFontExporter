package harayoki.app.bitmapfont
{
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import harayoki.app.SimpleState;

	public class MainSprite extends Sprite
	{
		private var _app:NativeApplication;
		private var _nativeWindow:NativeWindow;
		private var _panel:AppPanel = new AppPanel();
		private var _state:SimpleState;
		private var _ddd:DragAndDropDetector;
		private var _swffile:File;
		
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
			
			_panel.messages.mouseEnabled = false;
			_panel.messages.mouseChildren = false;
			_panel.preview.mouseEnabled = false;
			
			_panel.uiFontHeight.value = 12;
			
			_panel.uiImageWidth.selectedIndex = 2;//256
			_panel.uiImageHeight.selectedIndex = 2;//256
			
			_ddd = new DragAndDropDetector(_panel.dropTaeget);
			_ddd.onDrop.add(_onDropSwf);
			
			_state = new SimpleState();
			_state.onUpdate.add(_update);
			_state.value = AppState.WAIT_FILE;
			
		}
		
		private function _update():void
		{
			var uiEnabled:Boolean = false;
			var acceptDragDrop:Boolean = false;
			_panel.dropTaeget.visible = false;
 
			switch(_state.value)
			{
				case AppState.WAIT_FILE:
				{
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
		}
		
		private function _setUiEnabled(enabled:Boolean):void
		{
			_panel.uiFntFileName.enabled = enabled;
			_panel.uiFntFormat.enabled = enabled;
			_panel.uiFontHeight.enabled = enabled;
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
			_updateUiValues();
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
				_changeStateAndNextState(AppState.ERROR,AppState.WAIT_FILE);
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
			_state.value = AppState.EDIT;
		}
		
		private function _changeStateAndNextState(currentState:int,nextState:int,wait:uint=3000):void
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
			
			_panel.uiFntFileName.text = name+".fnt";
			_panel.uiFontName.text = name;
			_panel.uiImageFileName.text = name+".png";
		}
	}
}