// Generated by CoffeeScript 1.8.0
(function() {
  var Mask, create,
    __slice = [].slice;

  Mask = (function() {
    function Mask(_val) {
      this._val = _val;
      this._str = this._val.toString();
    }

    Mask.prototype.toString = function() {
      return this._str;
    };

    Mask.prototype.has = function(other) {
      return (this._val & other._val) === other._val;
    };

    Mask.prototype.any = function(other) {
      return !!(this._val & other._val);
    };

    return Mask;

  })();

  create = function(size) {
    var Multimask, bm, count, maskData, masks, stringArray, tags, uint32ArrayToString, uint32count, zeroMaskData;
    if (size == null) {
      size = 31;
    }
    tags = {};
    count = 0;
    masks = {};
    uint32count = Math.ceil(size / 31);
    if (uint32count <= 1) {
      masks = {};
      bm = function() {
        var arg, args, val, _i, _len, _ref;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        val = 0;
        for (_i = 0, _len = args.length; _i < _len; _i++) {
          arg = args[_i];
          if (tags[arg] == null) {
            tags[arg] = count;
            count += 1;
          }
          val |= Math.pow(2, tags[arg]);
        }
        return (_ref = masks[val]) != null ? _ref : (masks[val] = new Mask(val));
      };
    } else {
      stringArray = new Array(uint32count);
      uint32ArrayToString = function(arr) {
        var i, num, _i, _len;
        for (i = _i = 0, _len = arr.length; _i < _len; i = ++_i) {
          num = arr[i];
          stringArray[i] = num.toString(36);
        }
        return stringArray.join('.');
      };
      Multimask = (function() {
        function Multimask(_val, _str) {
          this._val = _val;
          this._str = _str;
        }

        Multimask.prototype.toString = function() {
          return this._str;
        };

        Multimask.prototype.has = function(other) {
          var idx, otherVal;
          idx = 0;
          while (idx < this._val.length) {
            otherVal = other._val[idx];
            if (!(this._val[idx] & otherVal) === otherVal) {
              return false;
            }
            idx += 1;
          }
          return true;
        };

        return Multimask;

      })();
      zeroMaskData = new Uint32Array(uint32count);
      maskData = new Uint32Array(uint32count);
      bm = function() {
        var arg, args, bitidx, key, _i, _len, _ref;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        maskData.set(zeroMaskData);
        for (_i = 0, _len = args.length; _i < _len; _i++) {
          arg = args[_i];
          if (tags[arg] == null) {
            tags[arg] = count;
            count += 1;
          }
          bitidx = tags[arg];
          maskData[Math.ceil(bitidx / 31) - 1] |= Math.pow(2, bitidx % 32);
        }
        key = uint32ArrayToString(maskData);
        return (_ref = masks[key]) != null ? _ref : (masks[key] = new Multimask(new Uint32Array(maskData), key));
      };
    }
    return bm;
  };

  module.exports = create;

}).call(this);
