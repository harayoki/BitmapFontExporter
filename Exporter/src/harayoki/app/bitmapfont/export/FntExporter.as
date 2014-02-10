package harayoki.app.bitmapfont.export
{
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import harayoki.app.data.FontData;
	
	import org.osflash.signals.Signal;

	public class FntExporter
	{
		private static const SO_KEY:String = "BitmapFOntExporter";
		private static const LAST_SAVED:String = "lastsaved";
		
		private var _onResult:Signal = new Signal();
		private var _errorMessage:String;
		private var _isSuccess:Boolean = false;
		private var _canceled:Boolean = false;
		
		public function FntExporter()
		{
			fntFileMaker = XmlFntFileMaker.getInstance();
		}
		
		private var _fntFileMaker:IFntFileMaker;
		
		public function get fntFileMaker():IFntFileMaker
		{
			return _fntFileMaker;
		}

		public function set fntFileMaker(value:IFntFileMaker):void
		{
			_fntFileMaker = value;
		}

		public function export(fntFileName:String,fontData:FontData,bitmapData:BitmapData):void
		{
			var bytes:ByteArray;
			var data:String = _fntFileMaker.makeFntFile(fontData,bitmapData);			
			trace(data);
			
			_errorMessage = "";
			_isSuccess = false;
			
			var file:File;
			var so:SharedObject = SharedObject.getLocal(SO_KEY);
			var path:String = so.data[LAST_SAVED];
			if(path)
			{
				file = new File(path);
				if(!file.exists)
				{
					file = File.userDirectory;
				}
			}
			else
			{
				file = File.userDirectory;
			}
			
			file.browseForDirectory("select save dirctory");
			file.addEventListener(Event.SELECT,onSelectDir);
			file.addEventListener(Event.CANCEL,onCancelSelectDir);
			
			function clearListener():void
			{
				file.removeEventListener(Event.SELECT,onSelectDir);
				file.removeEventListener(Event.CANCEL,onCancelSelectDir);
			}
			
			function onSelectDir(ev:Event):void
			{
				clearListener();
				writeFntData();
			}
			
			function onCancelSelectDir(ev:Event):void
			{
				clearListener();
				_isSuccess = false;
				_canceled = true;
				_onResult.dispatch();
			}
			
			function writeFntData():void
			{
				try
				{
					var fntFile:File = file.resolvePath(fntFileName)
					var fileStream:FileStream = new FileStream();
					fileStream.open(fntFile,FileMode.WRITE);
					fileStream.writeUTFBytes(data);
					fileStream.close();
					
					flash.utils.setTimeout(makePngData,1);
					
				} 
				catch(err:Error) 
				{
					_errorMessage = err.message;
					_isSuccess = false;
					_onResult.dispatch();
				}
			}
			
			function makePngData():void
			{
				try
				{
					bytes = new ByteArray();
					var option:PNGEncoderOptions = new PNGEncoderOptions();
					bitmapData.encode(bitmapData.rect,option,bytes);
					flash.utils.setTimeout(writePngData,1);
				}
				catch(err:Error)
				{
					_errorMessage = err.message;
					_isSuccess = false;
					_onResult.dispatch();
				}
				
			}
			
			function writePngData():void
			{
				try
				{
					var pngFile:File = file.resolvePath(fontData.file)
					var fileStream:FileStream = new FileStream();
					fileStream.open(pngFile,FileMode.WRITE);
					fileStream.writeBytes(bytes);
					fileStream.close();
					flash.utils.setTimeout(finish,1);
					
				} 
				catch(err:Error) 
				{
					_errorMessage = err.message;
					_isSuccess = false;
					_onResult.dispatch();
				}
			}
			
			function finish():void
			{
				so.data[LAST_SAVED] = file.nativePath;
				trace(file.nativePath);
				_isSuccess = true;
				_onResult.dispatch();
			}
			
		}
		
		public function get onResult():Signal
		{
			return _onResult;
		}
		
		public function get successed():Boolean
		{
			return _isSuccess;
		}
		
		public function get canceled():Boolean
		{
			return _canceled;
		}
		
		public function get errorMessage():String
		{
			return _errorMessage;
		}
		
	}
}