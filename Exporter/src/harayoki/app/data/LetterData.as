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
		public var xoffset:int = 0;
		public var yoffset:int = 0;
		public var xadvance:int = 0;
		public var page:int = 0;
		public var chnl:int = 15;//ARGBの各ビットの意味ではないか？
		public var bitmapData:BitmapData
		
		public var _bottom:int;
		
		private var _source:MovieClip;
		private var _frame:int;
		
		private static const BORDER_MC_NAME:String = "border";
		private static const CLIPPING_MC_NAME:String = "clip";
		
		public function LetterData()
		{
		}
		
		public function toString():String
		{
			return "[LetterData:"+[id+"('"+String.fromCharCode(id)+"')",width,height,xoffset,yoffset,xadvance]+"]";
		}
		
		public function applySourceClip(clip:MovieClip,frame:int):void
		{
			_source = clip;
			_frame = frame;
		}
		
		public function draw(scale:Number=1.0):void
		{
			_source.gotoAndStop(_frame);
			var border:DisplayObject = _source.getChildByName(BORDER_MC_NAME);
			var clip:DisplayObject = _source.getChildByName(CLIPPING_MC_NAME);
			if(border)
			{
				border.visible = false;
				//原点置きに強制
				if(border.x!=0 || border.y != 0)
				{
					border.width = border.x + border.width;
					border.height = border.y + border.height;
					border.x = 0;
					border.y = 0;
				}
			}
			if(clip)
			{
				clip.visible = false;
			}
			if(!clip)
			{
				clip = border;
			}
			width = Math.ceil(clip ? clip.width *scale : _source.width *scale);
			height = Math.ceil(clip ? clip.height *scale : _source.height *scale);
			
			xadvance = Math.ceil(border ? border.width*scale : _source.width *scale);
			
			if(bitmapData)
			{
				bitmapData.dispose();
			}
			
			_bottom = _source.height *scale;
			if(border)
			{
				_bottom = Math.ceil(Math.max(border.height*scale,(clip.y+clip.height)+scale));
			}
			
			xoffset = 0;
			yoffset = 0;
			if(clip)
			{
				xoffset = clip.x;
				yoffset = clip.y;
			}
			MATRIX.identity();
			MATRIX.translate(-xoffset,-yoffset);
			MATRIX.scale(scale,scale);
			
			xoffset *= scale;
			yoffset *= scale;

			bitmapData = new BitmapData(width,height,true,0);
			bitmapData.drawWithQuality(_source,MATRIX,null,null,null,true,StageQuality.BEST);
		}
		
		public function reset():void
		{
			id = 0;
			width = 0;
			height = 0;
			x = y = 0;
			xoffset = yoffset = 0;
			xadvance = 0;
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