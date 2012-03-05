# [ImageMagick](http://www.imagemagick.org/)/[GraphicsMagick](http://www.graphicsmagick.org/) Ruby wrapper

[![Build Status](https://secure.travis-ci.org/mceachen/micro_magick.png)](http://travis-ci.org/mceachen/micro_magick)

## Usage

```micro_magick``` is an exec wrapper for the ```convert``` command in either GraphicsMagick or ImageMagic.
```convert``` reads an image from a given input file, performs operations on it, then saves the result to a different file.

```ruby
img = MicroMagick::Convert.new("/path/to/image.jpg")
img.width
# => 3264
img.height
# => 2448
img.strip
img.quality(85)
img.resize("640x480>")
img.write("/new/path/image-640x480.jpg")
```

This results in the following system call:

```gm convert -size 640x480 /path/to/image.jpg +profile \* -quality 85 -resize "640x480>" /new/path/image-640x480.jpg```


### Installation

You'll want to [install GraphicsMagick](http://www.graphicsmagick.org/README.html), then

```
gem install micro_magick
```

or add to your Gemfile:

```
gem 'micro_magick'
```

and run ```bundle```.

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
but you can force the library MicroMagick uses by calling ```MicroMagick.use(:graphicsmagick)``` or ```MicroMagick.use(:imagemagick)```.

In-place image edits through ```mogrify``` are not supported (yet).

## GraphicsMagick versus ImageMagick

*At least in my testing, GraphicsMagick blows ImageMagick out of the water.*

In resizing a 2248x4000 image to 640x480:

* GraphicsMagick takes ~140 milliseconds. ImageMagick takes ~550 millis.
* GraphicsMagick outputs a 37K JPG, ImageMagick outputs a 94K JPG, with no detectable visual differences.

Not only is GraphicsMagick 4 times faster, it produces 2.5x smaller output with the same quality--WIN WIN.

## MicroMagick versus the competition

Why does the world need another *Magick wrapper? Because I needed a library that:

* didn't create temporary files unnecessarily (like mini_magick)
* didn't fail with valid geometry specifications, like ```640x480>``` (like mini_magick and quick_magick)
* didn't assume you only needed to resize your images (like imagery)
* didn't think you're going to run a public image caching service (like magickly)

## Change history

### 0.0.1

Let's get this party started.

### 0.0.3

Added square_crop, image dimensions, and support for ```+option```s.
