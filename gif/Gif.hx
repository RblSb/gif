package gif;

import openfl.display.BitmapData;
import openfl.net.FileReference;
import haxe.io.BytesOutput;
import haxe.io.UInt8Array;
import gif.GifEncoder;

class Gif {
	
	public var width:Int;
	public var height:Int;
	public var delay = 0.03;
	public var repeat = GifRepeat.Infinite;
	public var quality = GifQuality.VeryHigh;
	public var skip = 1;
	var output:BytesOutput;
	var encoder:GifEncoder;
	var count = 0;
	
	public function new(width:Int, height:Int, delay=0.03, repeat=-1, quality=10, skip=1) {
		this.width = width;
		this.height = height;
		this.delay = delay;
		this.repeat = repeat;
		this.quality = quality;
		this.skip = skip;
		count = 0;
		init();
	}
	
	function init() {
		output = new BytesOutput();
		encoder = new GifEncoder(width, height, delay, repeat, quality);
		encoder.start(output);
	}
	
	public function addFrame(bmd:BitmapData) {
		count++;
		if (count % skip != 0) return;
		
		var pixels = new UInt8Array(width * height * 3);
		var i = 0;
		
		for (iy in 0...height) {
			for (ix in 0...width) {
				var pixel:UInt = bmd.getPixel(ix, iy);
				pixels[i] = (pixel & 0xFF0000) >> 16;
				i++;
				pixels[i] = (pixel & 0x00FF00) >> 8;
				i++;
				pixels[i] = (pixel & 0x0000FF);
				i++;
			}
		}
			
		var frame:GifFrame = {
			delay: delay,
			flippedY: false,
			data: pixels
		}
		encoder.add(output, frame);
	}
	
	public function save(name:String) {
		encoder.commit(output);
		var bytes = output.getBytes();
		
		#if sys
		//sys.io.File.saveBytes(name, bytes);
		var fr = new FileReference();
		fr.save(bytes, name);
		
		#elseif js
		//var imageElement:js.html.ImageElement = cast js.Browser.document.createElement("img");
		//js.Browser.document.body.appendChild(imageElement);
		//imageElement.src = "data:image/gif;base64," + haxe.crypto.Base64.encode(bytes);
		
		var data = toArrayBuffer(bytes);
		var blob = new js.html.Blob([data], {
			type: "image/gif"
		});
		var url = js.html.URL.createObjectURL(blob);
		var a = js.Browser.document.createElement("a");
		untyped a.download = name;
		untyped a.href = url;
		a.onclick = function(e) {
			e.cancelBubble = true;
			e.stopPropagation();
		}
		js.Browser.document.body.appendChild(a);
		a.click();
		js.Browser.document.body.removeChild(a);
		js.html.URL.revokeObjectURL(url);
		
		#else
		throw "Unsupported platform!";
		#end
	}
	
	#if js
	public function toArrayBuffer(bytes):js.html.ArrayBuffer {
		var buffer = new js.html.ArrayBuffer(bytes.length);
		var view = new js.html.DataView(buffer, 0, buffer.byteLength);
		for (i in 0...bytes.length) {
			view.setUint8(i, bytes.get(i));
		}
		return buffer;
	}
	#end
}
