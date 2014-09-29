# bm [![Build Status](https://drone.io/github.com/namuol/bm/status.png)](https://drone.io/github.com/namuol/bm/latest) [![devDependency Status](https://david-dm.org/namuol/bm/dev-status.svg?style=flat-square)](https://david-dm.org/namuol/bm#info=devDependencies)

Create and use bitmasks of arbitrary depth without thinking.

**NOTE:** This is very early in development and has not been tested thoroughly; use at your own risk.

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

moveable.any(bm('velocity', 'position')); // false

moveable.and(bm('texture')) === sprite; // true
sprite.not(bm('texture')) === moveable; // true

// Naturally, order doesn't matter
// Notice how you can actually compare by value; this is because
//  the Bitmasker keeps a sort of cache of all the mask objects
//  under the hood.
sprite === bm('texture', 'velocity', 'position'); // true
```

### API

```js
var createBitmaskGenerator = require('bm');
```

#### `createBitmaskGenerator(size=31)`

## License

MIT

## Install

```bash
npm install bm --save
```

----

[![Analytics](https://ga-beacon.appspot.com/UA-33247419-2/bm/README.md)](https://github.com/igrigorik/ga-beacon)
