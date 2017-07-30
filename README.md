GIF (OpenFL version)
---

**A GIF format encoder.**
This only deals with the encoding (writing) and not reading of GIF files (see [format](https://github.com/haxefoundation/format)).

Haxe port by [KeyMaster-](https://github.com/KeyMaster-) and [underscorediscovery](https://github.com/underscorediscovery)
from [Chman/Moments](https://github.com/Chman/Moments)

**LICENSE**: The individual files are licensed accordingly.
**REQUIREMENTS**: Haxe 3.2+, no dependencies

---

### Install

`haxelib git gif https://github.com/RblSb/gif.git`

Then, add `openfl-gif` as a library dependency to your project.

### Simple usage

```
var gif = new Gif(
	width:Int,
	height:Int,
	delay:Float = 0.03, //delay in seconds
	repeat:Int = -1, //Infinite = -1, None = 0
	quality:Int = 10, //Worst = 100, Best = 1
	skip:Int = 1 //1 - noskip, 2 - skip every second frame, 3 - every third
);

gif.addFrame(bmd1:BitmapData);
gif.addFrame(bmd2:BitmapData);

gif.save();
```

### Helpers

See https://github.com/snowkit/gifcapture
