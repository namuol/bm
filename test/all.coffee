tape = require 'tape'
create = require '../index'

describe = (item, cb) ->
  it = (capability, test) ->
    tape.test item + ' ' + capability, (t) ->
      test(t)

  cb it

describe 'a bitmask', (it) ->
  it 'should return an equal bitmask value for the same tag', (t) ->
    bm = create()
    t.equal bm('a'), bm('a')
    t.end()

  it 'should return an equal bitmask value for the same tag, when having more than 32 bits of depth', (t) ->
    bm = create(200)
    t.equal bm('a'), bm('a')
    t.end()

  it 'should return an equal bitmask value for the same set of tags regardless of order', (t) ->
    bm = create()
    abc = bm('a', 'b', 'c')
    t.equal abc, bm('a', 'b', 'c')
    t.equal abc, bm('a', 'c', 'b')
    t.equal abc, bm('b', 'a', 'c')
    t.equal abc, bm('b', 'c', 'a')
    t.equal abc, bm('c', 'a', 'b')
    t.equal abc, bm('c', 'b', 'a')
    t.end()

  it 'should return an equal bitmask value for the same set of tags regardless of order, when having more than 32 bits of depth', (t) ->
    bm = create(200)
    abc = bm('a', 'b', 'c')
    t.equal abc, bm('a', 'b', 'c')
    t.equal abc, bm('a', 'c', 'b')
    t.equal abc, bm('b', 'a', 'c')
    t.equal abc, bm('b', 'c', 'a')
    t.equal abc, bm('c', 'a', 'b')
    t.equal abc, bm('c', 'b', 'a')
    t.end()

  it 'should be able to tell when a mask has a specific tag', (t) ->
    bm = create()
    a = bm('a')
    b = bm('b')
    c = bm('c')
    d = bm('d')
    abc = bm('a', 'b', 'c')
    t.true abc.has a
    t.true abc.has b
    t.true abc.has c
    t.false abc.has d
    t.end()

  it 'should be able to tell when a mask has a specific tag, when having more than 32 bits of depth', (t) ->
    bm = create(200)
    a = bm('a')
    b = bm('b')
    c = bm('c')
    d = bm('d')
    abc = bm('a', 'b', 'c')
    t.true abc.has a
    t.true abc.has b
    t.true abc.has c
    t.false abc.has d
    t.end()

  it 'should be able to tell when a mask has all specific tags', (t) ->
    bm = create()
    a = bm('a')
    b = bm('b')
    c = bm('c')
    d = bm('d')
    ab = bm('a', 'b')
    bc = bm('b', 'c')
    cd = bm('c', 'd')
    abc = bm('a', 'b', 'c')
    t.true abc.has ab
    t.true abc.has bc
    t.false abc.has cd
    t.end()

  it 'should be able to tell when a mask has all specific tags, when having more than 32 bits of depth', (t) ->
    bm = create(200)
    a = bm('a')
    b = bm('b')
    c = bm('c')
    d = bm('d')
    ab = bm('a', 'b')
    bc = bm('b', 'c')
    cd = bm('c', 'd')
    abc = bm('a', 'b', 'c')
    t.true abc.has ab
    t.true abc.has bc
    t.false abc.has cd
    t.end()

  it 'should be able to tell when a mask has any of the specified tags', (t) ->
    bm = create()
    a = bm('a')
    b = bm('b')
    c = bm('c')
    d = bm('d')
    ab = bm('a', 'b')
    bc = bm('b', 'c')
    cd = bm('c', 'd')
    abc = bm('a', 'b', 'c')
    abcd = bm('a', 'b', 'c', 'd')
    t.true abc.any a
    t.true abc.any b
    t.true abc.any c
    t.false abc.any d
    t.true abc.any ab
    t.true abc.any bc
    t.true abc.any cd
    t.true abc.any abc
    t.true abc.any abcd
    t.end()

  it 'should be able to tell when a mask has any of the specified tags, when having more than 32 bits of depth', (t) ->
    bm = create(200)
    a = bm('a')
    b = bm('b')
    c = bm('c')
    d = bm('d')
    ab = bm('a', 'b')
    bc = bm('b', 'c')
    cd = bm('c', 'd')
    abc = bm('a', 'b', 'c')
    abcd = bm('a', 'b', 'c', 'd')
    t.true abc.any a
    t.true abc.any b
    t.true abc.any c
    t.false abc.any d
    t.true abc.any ab
    t.true abc.any bc
    t.true abc.any cd
    t.true abc.any abc
    t.true abc.any abcd
    t.end()

  it 'should be able to differentiate between 31 different tags', (t) ->
    bm = create 31
    tags = [null]
    for i in [0..31]
      tags.push 'tag' + i

    error = ""
    for tag, i in tags
      a = bm(tag)
      for otherTag, j in tags
        continue  if i == j
        b = bm(otherTag)
        if (a == b) or (a.toString() == b.toString())
          error = "bm('tag#{i}') and bm('tag#{j}') should not be equal!"
          break
    t.equal error, ""
    t.end()

  it 'should be able to differentiate between more than 32 different tags', (t) ->
    bm = create 256
    tags = [null] # This is for checking "empty" masks
    for i in [0..256]
      tags.push 'tag' + i

    error = ""
    for tag, i in tags
      a = bm(tag)
      for otherTag, j in tags
        continue  if i == j
        b = bm(otherTag)
        if (a == b) or (a.toString() == b.toString())
          t.fail "bm('tag#{i}') and bm('tag#{j}') should not be equal!"
          t.end()
          return
    t.end()

  it ', when created using "and()", should still return an equal bitmask value for specific tags', (t) ->
    bm = create()

    a = bm 'a'
    b = bm 'b'
    c = bm 'c'
    abc = bm 'a', 'b', 'c'
    abc2 = a.and(b).and(c)
    abc3 = a.and(bm('b')).and(bm('c'))

    t.equal abc, abc2
    t.equal abc, abc3
    t.equal abc2, abc3
    t.end()

  it ', when created using "and()" and with more than 32 bits of depth, should still return an equal bitmask value for specific tags', (t) ->
    bm = create 200

    a = bm 'a'
    b = bm 'b'
    c = bm 'c'
    abc = bm 'a', 'b', 'c'
    abc2 = a.and(b).and(c)
    abc3 = a.and(bm('b')).and(bm('c'))

    t.equal abc, abc2
    t.equal abc, abc3
    t.equal abc2, abc3
    t.end()

  it ', when created using "not()", should still return an equal bitmask value for specific tags', (t) ->
    bm = create()

    a = bm 'a'
    b = bm 'b'
    c = bm 'c'
    abc = bm 'a', 'b', 'c'
    t.equal abc.not(bm('b','c')), a
    t.equal abc.not(bm('a','c')), b
    t.equal abc.not(bm('a','b')), c
    t.equal abc.not(bm('c')), bm('a','b')
    t.equal abc.not(bm('b')), bm('a','c')
    t.equal abc.not(bm('a')), bm('b','c')
    t.end()

  it ', when created using "not()", should still return an equal bitmask value for specific tags', (t) ->
    bm = create 200

    a = bm 'a'
    b = bm 'b'
    c = bm 'c'
    abc = bm 'a', 'b', 'c'
    t.equal abc.not(bm('b','c')), a
    t.equal abc.not(bm('a','c')), b
    t.equal abc.not(bm('a','b')), c
    t.equal abc.not(bm('c')), bm('a','b')
    t.equal abc.not(bm('b')), bm('a','c')
    t.equal abc.not(bm('a')), bm('b','c')
    t.end()
