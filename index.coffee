create = (size=31) ->
  tags = {}
  count = 0
  masks = {}
  
  uint32count = Math.ceil size / 31

  if uint32count <= 1
    class Mask
      constructor: (@_val) -> @_str = @_val.toString()
      toString: -> @_str
      has: (other) -> (@_val & other._val) is other._val
      any: (other) -> !!(@_val & other._val)
      and: (other) ->
        val = @_val | other._val
        return masks[val] ? (masks[val] = new Mask val)
      not: (other) ->
        val = @_val & ~ other._val
        return masks[val] ? (masks[val] = new Mask val)
    bm = (args...) ->
      val = 0
      for arg in args
        if not tags[arg]?
          tags[arg] = count
          count += 1
        val |= Math.pow 2, tags[arg]
      return masks[val] ? (masks[val] = new Mask val)
  else
    stringArray = new Array uint32count
    uint32ArrayToString = (arr) ->
      for num,i in arr
        stringArray[i] = num.toString(36)
      return stringArray.join '.'

    zeroMaskData = new Uint32Array uint32count
    maskData = new Uint32Array uint32count

    class Multimask
      constructor: (@_val, @_str) ->
      toString: -> @_str
      has: (other) ->
        idx = 0
        while idx < @_val.length
          otherVal = other._val[idx]
          if not ((@_val[idx] & otherVal) is otherVal)
            return false
          idx += 1
        return true
      any: (other) ->
        idx = 0
        while idx < @_val.length
          otherVal = other._val[idx]
          if @_val[idx] & otherVal
            return true
          idx += 1
        return false
      and: (other) ->
        maskData.set @_val
        idx = 0
        while idx < @_val.length
          maskData[idx] |= other._val[idx]
          idx += 1
        key = uint32ArrayToString maskData
        return masks[key] ? (masks[key] = new Multimask(new Uint32Array(maskData), key))
      not: (other) ->
        maskData.set @_val
        idx = 0
        while idx < @_val.length
          maskData[idx] &= ~ other._val[idx]
          idx += 1
        key = uint32ArrayToString maskData
        return masks[key] ? (masks[key] = new Multimask(new Uint32Array(maskData), key))

    bm = (args...) ->
      maskData.set zeroMaskData

      for arg in args
        if not tags[arg]?
          tags[arg] = count
          count += 1
        bitidx = tags[arg]
        maskData[Math.ceil((bitidx+1)/32) - 1] |= Math.pow 2, bitidx%32
      key = uint32ArrayToString maskData
      return masks[key] ? (masks[key] = new Multimask(new Uint32Array(maskData), key))

  return bm

module.exports = create
