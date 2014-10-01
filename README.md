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
moveable.has(bm('velocity', 'position', 'texture')); // false

moveable.and(bm('texture')) === sprite; // true
sprite.not(bm('texture')) === moveable; // true

// Notice how you can actually compare by value; this is because
//  the generator keeps a cache of all the mask objects
//  under the hood.
sprite === bm('texture', 'velocity', 'position'); // true
```

## API

```js
var createBitmaskGenerator = require('bm');
```

#### Create a new bitmask generator
```js
var bm = createBitmaskGenerator(maxUniqueValues);
```
> **`maxUniqueValues`** ***Number*** *default=31* The number of unique tags supported.


#### Create a new bitmask from any number of tags
```js
var mask = bm(tag1, tag2, tagN);
```
> **`tag1, tag2, tagN...`** ***Strings*** The tags that are marked in this mask.

**Note**: Masks returned by this function can be compared by value, and order of arguments does not matter.

In other words, `bm('a','b','c') === bm('c','b','a')`.

#### Check if one mask contains **all** values from another
```js
mask.has(otherMask);
```

Example:

```js
bm('a','b','c').has(bm('a')); // true!
bm('a','b','c').has(bm('x')); // false!
```

#### Check if one mask contains *any* values from another
```js
mask.any(otherMask);
```

Example:

```js
bm('a','b','c').any(bm('a', 'x')); // true!
bm('a','b','c').any(bm('x', 'y', 'z')); // false!
```

#### Combine two groups of tags
```js
var combined = mask.and(otherMask);
```

Example:

```js
bm('a').and(bm('b')).and(bm('c')) === bm('a', 'b', 'c'); // true!
```

#### Remove certain tags from a mask

```js
var without = mask.not(otherMask);
```

Example:

```js
bm('a','b','c').not(bm('b')) === bm('a','c'); // true!
```

## License

MIT

## Install

```bash
npm install bm --save
```

----

[![Analytics](https://ga-beacon.appspot.com/UA-33247419-2/bm/README.md)](https://github.com/igrigorik/ga-beacon)
