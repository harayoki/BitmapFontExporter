package harayoki.app.bitmapfont
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.InteractiveObject;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	import org.osflash.signals.Signal;

	public class DragAndDropDetector
	{
		private var _target:InteractiveObject;
		private var _dropFiles:Vector.<File>;
		private var _enabled:Boolean = true;
		
		public var onDrop:Signal = new Signal();
		
		public function DragAndDropDetector(target:InteractiveObject=null)
		{
			_dropFiles = new Vector.<File>();
			setTarget(target);
		}

		private function _cleanTarget():void
		{
			if(_target)
			{
				_target.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER , _handleDragEnter);
				_target.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP , _handleDragDrop);
			}
			if(_dropFiles)
			{
				_dropFiles.length = 0;
			}
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function dispose():void
		{
			_cleanTarget();
			_target = null;
			_dropFiles = null;
			if(onDrop)
			{
				onDrop.removeAll();
			}
			onDrop = null;
		}
		
		public function setTarget(target:InteractiveObject):void
		{
			_cleanTarget();
			_target = target;
			if(!_target)
			{
				return;
			}
			_target.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER , _handleDragEnter);
			_target.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP , _handleDragDrop);			
		}
		
		public function getLastDropFiles():Vector.<File>
		{
			return _dropFiles.slice();
		}
		
		private function _handleDragEnter(ev:NativeDragEvent):void{
			
			if(!_enabled) return;
			
			var clipboard : Clipboard = ev.clipboard;
			var formats:Array = clipboard.formats;
			var i:int;
			var num:int = formats.length;
			for(i=0;i < num;i++){
				if(formats[i] == ClipboardFormats.FILE_LIST_FORMAT){
					NativeDragManager.acceptDragDrop(_target);
					break;
				}
			}
		}
		
		private function _handleDragDrop(ev:NativeDragEvent):void{
			
			if(!_enabled) return;

			var clipboard : Clipboard = ev.clipboard;
			var arr:Array = clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			var i:int;
			var num:int = arr.length;
			_dropFiles.length = 0;
			for(i=0;i < num;i++){
				var file:File = arr[i] as File;
				var index:int = file.name.lastIndexOf(".swf")
				if(index == file.name.length - 4)
				{
					_dropFiles.push(file);
				}
			}
			if(_dropFiles.length>0)
			{
				onDrop.dispatch();
			}
		}
		
	}
}