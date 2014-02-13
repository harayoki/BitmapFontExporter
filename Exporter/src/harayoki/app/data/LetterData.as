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
		
		public static function updateLetterData(letter:LetterData,scale:Number):void
		{
			var source:MovieClip = letter._source;
			source.gotoAndStop(letter._frame);
			var border:DisplayObject = source.getChildByName(BORDER_MC_NAME);
			var clip:DisplayObject = source.getChildByName(CLIPPING_MC_NAME);
			if(border)
			{
				border.visible = false;
				//原点置きに強制
				if(border.x!=0 || border.y != 0)
				{
					trace("caution border mocie clip is not located at 0,0 !");
					//ここでサイズを変えると全フレームのborderの大きさがそろってしまう
					//border.width = border.x + border.width;
					//border.height = border.y + border.height;
					//border.x = 0;
					//border.y = 0;
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
			letter.width = Math.ceil(clip ? clip.width *scale : source.width *scale);
			letter.height = Math.ceil(clip ? clip.height *scale : source.height *scale);
			
			letter.xadvance = Math.ceil(border ? border.width*scale : source.width *scale);
			
			if(letter.bitmapData)
			{
				letter.bitmapData.dispose();
			}
			
			letter._bottom = source.height *scale;
			if(border)
			{
				letter._bottom = Math.ceil(Math.max(border.height*scale,(clip.y+clip.height)+scale));
			}
			
			letter.xoffset = 0;
			letter.yoffset = 0;
			if(clip)
			{
				letter.xoffset = clip.x;
				letter.yoffset = clip.y;
			}
			MATRIX.identity();
			MATRIX.translate(-letter.xoffset,-letter.yoffset);
			MATRIX.scale(scale,scale);
			
			letter.xoffset *= scale;
			letter.yoffset *= scale;
			
			letter.bitmapData = new BitmapData(letter.width,letter.height,true,0);
			letter.bitmapData.drawWithQuality(source,MATRIX,null,null,null,true,StageQuality.BEST);
		}
		
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
		
		public var _bottom:int;//piublicです 出力文字データと直接関係ないので
		
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