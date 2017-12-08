# Simple, efficient \*Magick rubygem

[![Gem Version](https://badge.fury.io/rb/micro_magick.svg)](http://rubygems.org/gems/micro_magick)
[![Build Status](https://secure.travis-ci.org/mceachen/micro_magick.svg)](http://travis-ci.org/mceachen/micro_magick)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/5addbc91244e496ab959aa80492c545d)](https://www.codacy.com/app/matthew-github/micro_magick)
[![Dependency Status](https://gemnasium.com/mceachen/micro_magick.svg)](https://gemnasium.com/mceachen/micro_magick)

## Features

MicroMagick lets you use [ImageMagick](http://www.imagemagick.org/) or
[GraphicsMagick](http://www.graphicsmagick.org/) from ruby.

Using MicroMagick:

* doesn't bloat your ruby process when you process large images (like `rmagick`)
* supports valid geometry specifications, like `640x480>` (which doesn't work
  with `mini_magick` and `quick_magick`)
* doesn't create unnecessary tempfiles (like `mini_magick`)
* doesn't assume you only needed to resize your images (like `imagery`)
* supports identification of corrupt images (which is unique to MicroMagick).
  (Note that this support wasn't added to ImageMagick until version 6.7.0, but
  has been present in GraphicsMagick for several years).

MicroMagick has excellent
[test coverage](http://travis-ci.org/mceachen/micro_magick) and
[code quality](https://codeclimate.com/github/mceachen/micro_magick).

## Usage

```ruby
img = MicroMagick::Image.new("/path/to/image.jpg")
img.strip.quality(85).resize("640x480>").write("640x480.jpg") unless img.corrupt?
```

This will

1. Read `/path/to/image.jpg`
1. Verify the image is not corrupt, using `identify`
1. Set up a `convert` command to

   * remove EXIF headers (`strip`),
   * use 85% JPEG quality,
   * resize to 640x480 only if the source image is bigger than those dimensions
     (hence the '>' suffix)
   * write the results to '640x480.jpg'

This results in the following system call:

`gm convert -size 640x480 /path/to/image.jpg +profile \* -quality 85 -resize
"640x480>" /new/path/image-640x480.jpg`

To get image dimensions:

```ruby
img.width
# => 3264
img.height
# => 2448
```

### What about EXIF information?

To access EXIF metadata information, including properly typed values, see the
[exiftool](https://github.com/mceachen/exiftool) and
[exiftool_vendored](https://github.com/mceachen/exiftool_vendored) gems.

### Installation

Add `gem 'micro_magick'` to your `Gemfile` and run `bundle`.

You'll also need to
[install GraphicsMagick](http://www.graphicsmagick.org/README.html).

If you're on a Mac with [homebrew](http://brew.sh/), `brew install
graphicsmagick`.

### "Plus" options

To add an output option that has a "plus" prefix, like, `+matte`, use
`.add_output_option("+matte")`.

### Goodies

There are a couple additional methods that have been added to address common
image tasks:

* `img.strip` removes all comments and EXIF headers
* `img.square_crop` crops the image to a square (so a 640x480 image would crop
  down to a 480x480 image, cropped in the middle).

Note that `micro_magick` delegates all parameter validation to the underlying
library. A `MicroMagick::ArgumentError` will be raised on `.write` or
`.overwrite` if ImageMagick or GraphicsMagick writes anything to stderr.

## GraphicsMagick versus ImageMagick

_At least in my testing, GraphicsMagick blows ImageMagick out of the water._

In resizing a 2248x4000 image to 640x480:

* GraphicsMagick takes ~140 milliseconds. ImageMagick takes ~550 millis.
* GraphicsMagick outputs a 37K JPG, ImageMagick outputs a 94K JPG, with no
  detectable visual differences.

Not only is GraphicsMagick 4 times faster, it produces 2.5x smaller output with
the same quality--WIN WIN.

Because of this, if you have GraphicsMagick installed, MicroMagick will use it
by default. You can force which library to use with the
`MicroMagick.use_graphicsmagick!` and `MicroMagick.use_imagemagick!` methods.

To see which external library and version you're using:

```ruby
MicroMagick.version
=> #<Gem::Version "1.3.21">
MicroMagick.imagemagick?
=> false
MicroMagick.graphicsmagick?
=> true
```

## Changelog

### 1.1.0

* Allow supplying input file options. Thanks,
  [whitequark](https://twitter.com/whitequark/)!

### 1.0.1

Added explicit MIT licensing.

### 1.0.0

Please note that the attributes hash associated to images has been removed in
this version, in the interests of correctness. If you need EXIF metadata, use
the [exiftool](https://github.com/mceachen/exiftool) gem.

* Updated identity parsing to only dimensions. Addresses
  [Issue 3](https://github.com/mceachen/micro_magick/issues/3) (multi-value),
  and [Issue 5](https://github.com/mceachen/micro_magick/issues/5) (NULL
  bytestreams)
* Updated Travis configuration

### 0.0.7

* There's only one common Image class now
* Added `identify -verbose` parsing
* Added support for mogrify with new `.overwrite` method

### 0.0.6

Cleaned up some packaging/mode bit issues

### 0.0.5

Fixed gemspec metadata

### 0.0.4

Input file -size render hint is now only used with simple dimension
specifications

### 0.0.3

Added square_crop, image dimensions, and support for `+option`s.

### 0.0.1

Let's get this party started.
