package harayoki.app
{
	import org.osflash.signals.Signal;

	public class SimpleState
	{
		private var _value:int = -1;
		
		public var onUpdate:Signal = new Signal();
		
		public function SimpleState()
		{
		}
		
		public function reset(val:int):void
		{
			_value = val;
		}
		
		public function set value(val:int):void
		{
			if(_value == val) return;
			_value = val;
			onUpdate.dispatch();
		}
		
		public function get value():int
		{
			return _value;
		}

		
	}
}