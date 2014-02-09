package harayoki.app.data
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.geom.Matrix;

	public class LetterData
	{
		private static const MATRIX:Matrix = new Matrix();
		
		public var id:uint = 0;
		public var width:int = 0;
		public var height:int = 0;
		public var x:int = 0;
		public var y:int = 0;
		public var offsetX:int = 0;
		public var offsetY:int = 0;
		public var advanceX:int = 0;
		public var page:int = 0;
		public var chnl:int = 0;
		public var bitmapData:BitmapData
		
		private var _source:MovieClip;
		private var _frame:int;
		
		private static const BORDER_CLIP_NAME:String = "border";
		
		public function LetterData()
		{
		}
		
		public function toString():String
		{
			return "[LetterData:"+[id+"('"+String.fromCharCode(id)+"')",width,height,offsetX,offsetY,advanceX]+"]";
		}
		
		public function applySourceClip(clip:MovieClip,frame:int):void
		{
			_source = clip;
			_frame = frame;
			trace(_frame);
		}
		
		public function draw(scale:Number=1.0):void
		{
			_source.gotoAndStop(_frame);
			var border:DisplayObject = _source.getChildByName(BORDER_CLIP_NAME);
			width = border ? border.width *scale : _source.width *scale;
			height = border ? border.height *scale : _source.height *scale;
			advanceX = width;
			if(border)
			{
				border.visible = false;
			}
			if(bitmapData)
			{
				bitmapData.dispose();
			}
			
			MATRIX.identity();
			MATRIX.scale(scale,scale);

			bitmapData = new BitmapData(width,height,true,0);
			bitmapData.drawWithQuality(_source,MATRIX,null,null,null,true,StageQuality.BEST);
		}
		
		public function reset():void
		{
			id = 0;
			width = 0;
			height = 0;
			x = y = 0;
			offsetX = offsetY = 0;
			advanceX = 0;
			page = 0;
			chnl = 0;
			if(bitmapData)
			{
				bitmapData.dispose();
			}
			bitmapData = null;
			_source = null;
		}
		
		public function dispose():void
		{
			reset();
		}
	}
}