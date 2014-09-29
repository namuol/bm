# bm [![Build Status](https://drone.io/github.com/gitsubio/bm/status.png)](https://drone.io/github.com/gitsubio/bm/latest) [![devDependency Status](https://david-dm.org/gitsubio/bm/dev-status.svg?style=flat-square)](https://david-dm.org/gitsubio/bm#info=devDependencies)

Create and use bitmasks of arbitrary depth without thinking.

**NOTE:** This has not been battle tested yet; use at your own risk. (And please [report issues](http://github.com/gitsubio/bm/issues))

```js
var createBitmaskGenerator = require('bm');

// Up to 1000 unique values (actually a multiple of 32 under the hood)
var bm = createBitmaskGenerator(1000);

var positionable = bm('position');
var moveable = bm('position', 'velocity');
var sprite = bm('position', 'velocity', 'texture');

moveable.has(bm('position')); // true
moveable.has(positionable); // true
positionable.has(bm('velocity')); // false

moveable.any(bm('velocity', 'position', 'texture')); // true
moveable.all(bm('velocity', 'position', 'texture')); // false

moveable.and(bm('texture')) === sprite; // true
sprite.not(bm('texture')) === moveable; // true

// Notice how you can actually compare by value; this is because
//  the generator keeps a cache of all the mask objects
//  under the hood.
sprite === bm('texture', 'velocity', 'position'); // true
```

## License

MIT

## Install

```bash
npm install bm --save
```

----

[![Analytics](https://ga-beacon.appspot.com/UA-33247419-2/bm/README.md)](https://github.com/igrigorik/ga-beacon)
