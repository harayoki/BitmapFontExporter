package harayoki.app.bitmapfont.export
{
	import flash.display.BitmapData;
	
	import harayoki.app.data.FontData;
	import harayoki.app.data.LetterData;
	
	public class XmlFntFileMaker implements IFntFileMaker
	{
		public static const XML_HEADER:String = '<?xml version="1.0"?>\n';
		
		public static var TEMPLATE_XML:String = '<font> \
			<info face="" size="" bold="" italic="" charset="" unicode="" stretchH="" smooth="" aa="" padding="" spacing="" outline=""/> \
			<common lineHeight="" base="25" scaleW="" scaleH="" pages="" packed="" alphaChnl="1" redChnl="0" greenChnl="0" blueChnl="0"/> \
			<pages> \
			<page id="0" file="" /> \
			</pages> \
			<chars count=""> \
			</chars> \
			</font>';
		public static var TEMPLATE_XML_ITEM:String = '<char id="" x="" y="" width="" height="" xoffset="" yoffset="" xadvance="" page="" chnl="" />';
		
		private static const instance:XmlFntFileMaker = new XmlFntFileMaker();
		public static function getInstance():XmlFntFileMaker
		{
			return instance;
		}
		
		public function XmlFntFileMaker()
		{
		}
		
		public function makeFntFile(fontData:FontData, bitmapData:BitmapData):String
		{
			
			var xml:XML = new XML(TEMPLATE_XML);
			xml.info.@face = fontData.face;
			xml.info.@size= fontData.size;
			xml.info.@bold = fontData.bold;
			xml.info.@italic = fontData.italic;
			xml.info.@charset = fontData.charset;
			xml.info.@unicode = fontData.unicode;
			xml.info.@stretchH = fontData.stretchH;
			xml.info.@smooth = fontData.smooth;
			xml.info.@aa = fontData.aa;
			xml.info.@padding = fontData.padding.join(",");
			xml.info.@spacing = fontData.spacing.join(",");
			xml.info.@outline = fontData.outline;
			
			xml.common.@lineHeight = fontData.lineHeight;
			xml.common.@base = fontData.base;
			xml.common.@scaleW = fontData.scaleW;
			xml.common.@scaleH = fontData.scaleH;
			xml.common.@pages = fontData.pages;
			xml.common.@packed = fontData.packed;
			xml.common.@alphaChnl= fontData.alphaChnl;
			xml.common.@redChnl= fontData.redChnl;
			xml.common.@greenChnl= fontData.greenChnl;
			xml.common.@blueChnl= fontData.blueChnl;
			
			xml.pages.page.@id = fontData.id;
			xml.pages.page.@file = fontData.file;
			
			xml.chars.@count = fontData.letters.length;
			
			var i:int;
			for(i=0;i<fontData.letters.length;i++)
			{
				var l:LetterData = fontData.letters[i];
				var item:XML = new XML(TEMPLATE_XML_ITEM);
				item.@id = l.id;
				item.@x = l.x;
				item.@y = l.y;
				item.@width = l.width;
				item.@height = l.height;
				item.@xoffset = l.xoffset;
				item.@yoffset = l.yoffset;
				item.@xadvance = l.xadvance;
				item.@page = l.page;
				item.@chnl = l.chnl;
				
				xml.chars[0].appendChild(item);
				
			}
			
			return XML_HEADER + xml.toXMLString();
			
		}
	}
}