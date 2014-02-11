package 
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	import starling.utils.HAlign;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public class MainSprite extends Sprite
	{
		private static const CONTENTS_WIDTH:int = 640;
		private static const CONTENTS_HEIGHT:int = 480;
		private static var _starling:Starling;
		private static var _flashStage:Stage;
		
		private var _assetManager:AssetManager;
		private var _textField:TextField;
		private var _num:int = 0;
		

		public static function main(stage:Stage):void
		{
			
			trace("Starling version version : ",Starling.VERSION);
			_flashStage = stage;
			
			_flashStage.align = StageAlign.TOP_LEFT;
			_flashStage.scaleMode = StageScaleMode.NO_SCALE;
			Starling.handleLostContext = true;
			
			_starling = new Starling(MainSprite,_flashStage,new Rectangle(0,0,CONTENTS_WIDTH,CONTENTS_HEIGHT));
			_starling.showStats = true;
			_starling.showStatsAt("left","top",2);		
		}
		
		public function MainSprite()
		{			
			addEventListener(Event.ADDED_TO_STAGE,_handleAddedToStage);
		}
		
		private function _handleAddedToStage():void
		{
			removeEventListener(Event.ADDED_TO_STAGE,_handleAddedToStage);
			stage.color = _flashStage.color;
			stage.alpha = 0.999999;//for paerformance
			stage.addEventListener(Event.RESIZE,_handleStageResize);
			_handleStageResize();
			_starling.start();		
			
			_loadAssets();
		}
		
		private function _handleStageResize(ev:Event=null):void
		{
			var w:int = _flashStage.stageWidth;
			var h:int = _flashStage.stageHeight
			_starling.viewPort = RectangleUtil.fit(
				new Rectangle(0, 0, CONTENTS_WIDTH, CONTENTS_HEIGHT),
				new Rectangle(0, 0, w,h),
				ScaleMode.SHOW_ALL);			
		}
		
		private function _loadAssets():void
		{
			_assetManager = new AssetManager();
			_assetManager.verbose = true;
			_assetManager.enqueue("sampleFont.png");
			_assetManager.enqueue("sampleFont.fnt");
			_assetManager.loadQueue(function(num:Number):void{
				if(num==1.0)
				{
					_start();
				}
			});
		}
		
		private function _handleEnterFrame(ev:Event):void
		{
			if(_textField)
			{
				_num += 3;
				var str:String = _addComma(("0000000"+_num).slice(-8));
				_textField.text = str;
				
				if(_num>99999999)
				{
					_num = 0;
				}
			}
		}
		
		private function _addComma(str:String):String
		{
			var arr:Array = [];
			var res:String = "";
			var i:int = str.length;
			while(i--)
			{
				res = str.charAt(i) + res;
				if(res.length==3)
				{
					arr.unshift(res);
					res = "";
				}
			}
			if(res.length>0)
			{
				arr.unshift(res);
			}
			return arr.join(",");
		}
		
		private function _start():void
		{
			stage.addEventListener(Event.ENTER_FRAME,_handleEnterFrame);
						
			_textField = new TextField(640-20, 120, "","sampleFont", 90, 0xffffff);
			_textField.x = 10;
			_textField.y = 150;
			_textField.hAlign = HAlign.CENTER;
			addChild(_textField);
			
		}
	}
}