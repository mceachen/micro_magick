# Simple and efficient [ImageMagick](http://www.imagemagick.org/)/[GraphicsMagick](http://www.graphicsmagick.org/) ruby wrapper

[![Build Status](https://secure.travis-ci.org/mceachen/micro_magick.png)](http://travis-ci.org/mceachen/micro_magick)
[![Code Climate](https://codeclimate.com/github/mceachen/micro_magick.png)](https://codeclimate.com/github/mceachen/micro_magick)

## MicroMagick versus the competition

MicroMagick:

* supports valid geometry specifications, like ```640x480>``` (this fails with ```mini_magick``` and ```quick_magick```)
* doesn't create unnecessary tempfiles (like ```mini_magick```)
* doesn't assume you only needed to resize your images (like ```imagery```)
* supports identification of corrupt images (this is unique)
* has [good test coverage](http://travis-ci.org/mceachen/micro_magick) and [code quality](https://codeclimate.com/github/mceachen/micro_magick)

## Usage

```micro_magick``` is an exec wrapper for the ```identify```, ```convert```, and ```mogrify``` commands from GraphicsMagick or ImageMagic.

```ruby
img = MicroMagick::Image.new("/path/to/image.jpg")
img.strip.quality(85).resize("640x480>").write("640x480.jpg")
```

This results in the following system call:

```gm convert -size 640x480 /path/to/image.jpg +profile \* -quality 85 -resize "640x480>" /new/path/image-640x480.jpg```

To get metadata about the image:

```ruby
img.width
# => 3264
img.height
# => 2448
img[:colorspace]
# => "sRGB"
img[:gamma]
# => "0.454545"
```

To get more complete EXIF metadata information, including proper value typecasting,
see the [exiftool](https://github.com/mceachen/exiftool) gem.

### Installation

Add ```gem 'micro_magick'``` to your ```Gemfile``` and run ```bundle```.

You'll also need to [install GraphicsMagick](http://www.graphicsmagick.org/README.html).

If you're on a Mac with [homebrew](http://brew.sh/), ```brew install graphicsmagick```.

### "Plus" options

To add an output option that has a "plus" prefix, like, ```+matte```, use ```.add_output_option("+matte")```.

### Goodies

There are a couple additional methods that have been added to address common image tasks:

* ```img.strip``` removes all comments and EXIF headers
* ```img.square_crop``` crops the image to a square (so a 640x480 image would crop down to a 480x480 image, cropped in the middle).

Note that all of ```convert```'s options are supported, but ```micro_magick``` does no validations.
A ```MicroMagick::ArgumentError``` will be raised on ```.write``` if
convert writes anything to stderr or the return value is not 0.

Note also that GraphicsMagick will be used automatically, if it's in ruby's PATH, and then will fall back to ImageMagick,
but you can force the library MicroMagick uses by calling ```MicroMagick.use_graphicsmagick``` or ```MicroMagick.use_imagemagick```.

## GraphicsMagick versus ImageMagick

*At least in my testing, GraphicsMagick blows ImageMagick out of the water.*

In resizing a 2248x4000 image to 640x480:

* GraphicsMagick takes ~140 milliseconds. ImageMagick takes ~550 millis.
* GraphicsMagick outputs a 37K JPG, ImageMagick outputs a 94K JPG, with no detectable visual differences.

Not only is GraphicsMagick 4 times faster, it produces 2.5x smaller output with the same quality--WIN WIN.

## Changelog

### 0.0.7

* There's only one common Image class now
* Added ```identify -verbose``` parsing
* Added support for mogrify with new ```.overwrite``` method

### 0.0.6

Cleaned up some packaging/mode bit issues

### 0.0.5

Fixed gemspec metadata

### 0.0.4

Input file -size render hint is now only used with simple dimension specifications

### 0.0.3

Added square_crop, image dimensions, and support for ```+option```s.

### 0.0.1

Let's get this party started.

