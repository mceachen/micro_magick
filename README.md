# Simplest possible ruby wrapper for [ImageMagick](http://www.imagemagick.org/) and [GraphicsMagick](http://www.graphicsmagick.org/)

### OMG, SRSLY?

Yes. Seriously.

### The other five libraries didn't make you happy?

No.

### OK, Sunshine, cry me a river.

All I wanted was something that

* didn't create temporary files unnecessarily (like mini_magick)
* didn't fail with valid geometry specifications, like ```640x480>``` (like mini_magick and quick_magick)
* didn't assume you only needed to resize your images (like imagery)
* didn't think you're going to run a public image caching service (like magickly)

## Usage

```micro_magick``` is an exec wrapper for the ```convert``` command, which reads from an image
source, performs operations on it, and saves the result to a different file.

```ruby
img = MicroMagick::Convert.new("/path/to/image.jpg")
img.strip
img.quality(85)
img.resize("640x480>")
img.write("/different/path/image-640x480.jpg")
```

This results in the following system call:

```gm convert -size 640x480 /path/to/image.jpg -strip -quality 85 -resize "640x480>" /different/path/image-640x480.jpg```

Note that all of ```convert```'s options are supported, but ```micro_magick``` does no validations.
A ```MicroMagick::ArgumentError``` will be raised on ```.write``` if
convert writes anything to stderr or the return value is not 0.

Note also that GraphicsMagick will be used automatically, if it's in ruby's PATH, and then will fall back to ImageMagick,
but you can force the library MicroMagick uses by calling ```MicroMagick.use(:graphicsmagick)``` or ```MicroMagick.use(:imagemagick)```.

In-place image edits through ```mogrify``` are not supported (yet).

### GraphicsMagick versus ImageMagick

In resizing a 2248x4000 image to 640x480:
* GraphicsMagick takes 141 milliseconds. ImageMagick takes over 550 millis.
* GraphicsMagick outputs a 37K JPG, ImageMagick outputs a 94K JPG, with no detectable visual differences.

At least in my testing, GraphicsMagick blows ImageMagick out of the water.

Not only is it 4 times faster, it produces 2.5x smaller output with the same quality--WIN WIN.

## Installation

You'll want to [install GraphicsMagick](http://www.graphicsmagick.org/README.html), then

```
gem install micro_magick
```

or add to your Gemfile:

```
gem 'micro_magick'
```

and run ```bundle```.

## Change history

### 0.0.1

Let's get this party started.
