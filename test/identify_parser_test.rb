require 'test_helper'

describe MicroMagick::IdentifyParser do
  describe 'simple parsing functions' do
    let(:ip) { MicroMagick::IdentifyParser.new('') }
    it 'converts keys to expected symbols' do
      ip.key_to_sym('Image').must_equal :image
      ip.key_to_sym('Channel Depths').must_equal :channel_depths
      ip.key_to_sym('JPEG-Quality').must_equal :jpeg_quality
      ip.key_to_sym('Y Cb Cr Positioning').must_equal :y_cb_cr_positioning
      ip.key_to_sym('Profile-EXIF').must_equal :profile_exif
    end

    it 'determines line indent properly' do
      ip.indent('Image: out.jpeg').must_equal 0
      ip.indent('  Channel Depths:').must_equal 2
      ip.indent('    Blue:').must_equal 4
    end
  end

  describe 'with expected output' do
    let(:ip) do
      MicroMagick::IdentifyParser.new(<<-OUT)
Image: /tmp/input.jpg
  Format: JPEG (Joint Photographic Experts Group JFIF format)
  Mime type: image/jpeg
  Class: DirectClass
  Geometry: 1152x2048+0+0
  Resolution: 72x72
  Print size: 16x28.4444
  Units: PixelsPerInch
  Type: TrueColor
  Endianess: Undefined
  Colorspace: sRGB
  Depth: 8-bit
  Channel depth:
    red: 8-bit
    green: 8-bit
    blue: 8-bit
  Channel statistics:
    Red:
      min: 0 (0)
      max: 255 (1)
      mean: 133.986 (0.525437)
      standard deviation: 54.1069 (0.212184)
      kurtosis: -0.874804
      skewness: -0.488666
    Green:
      min: 0 (0)
      max: 255 (1)
      mean: 119.681 (0.469337)
      standard deviation: 64.5707 (0.253218)
      kurtosis: -1.43104
      skewness: -0.207503
    Blue:
      min: 0 (0)
      max: 255 (1)
      mean: 102.697 (0.402734)
      standard deviation: 75.4283 (0.295797)
      kurtosis: -1.69738
      skewness: 0.0278036
  Image statistics:
    Overall:
      min: 0 (0)
      max: 255 (1)
      mean: 118.788 (0.465836)
      standard deviation: 65.2849 (0.256019)
      kurtosis: -1.25648
      skewness: -0.301872
  Rendering intent: Perceptual
  Gamma: 0.454545
  Chromaticity:
    red primary: (0.64,0.33)
    green primary: (0.3,0.6)
    blue primary: (0.15,0.06)
    white point: (0.3127,0.329)
  Background color: white
  Border color: srgb(223,223,223)
  Matte color: grey74
  Transparent color: black
  Interlace: None
  Intensity: Undefined
  Compose: Over
  Page geometry: 1152x2048+0+0
  Dispose: Undefined
  Iterations: 0
  Compression: JPEG
  Quality: 94
  Orientation: TopLeft
  Properties:
    date:create: 2014-02-09T08:59:26-08:00
    date:modify: 2014-02-09T08:59:25-08:00
    exif:ApertureValue: 228/100
    exif:BrightnessValue: 105984/65536
    exif:ColorSpace: 1
    exif:ComponentsConfiguration: 1, 2, 3, 0
    exif:Compression: 6
    exif:DateTime: 2014:02:07 08:38:21
    exif:DateTimeDigitized: 2014:02:07 08:38:21
    exif:DateTimeOriginal: 2014:02:07 08:38:21
    exif:ExifImageLength: 2048
    exif:ExifImageWidth: 1152
    exif:ExifOffset: 230
    exif:ExifVersion: 48, 50, 50, 48
    exif:ExposureBiasValue: 0/10
    exif:ExposureMode: 0
    exif:ExposureProgram: 2
    exif:ExposureTime: 1/25
    exif:Flash: 0
    exif:FlashPixVersion: 48, 49, 48, 48
    exif:FNumber: 220/100
    exif:FocalLength: 420/100
    exif:FocalLengthIn35mmFilm: 31
    exif:GPSAltitude: 0/1000
    exif:GPSAltitudeRef: 0
    exif:GPSDateStamp: 2014:02:07
    exif:GPSInfo: 722
    exif:GPSLatitude: 37/1, 46/1, 341802/10000
    exif:GPSLatitudeRef: N
    exif:GPSLongitude: 122/1, 25/1, 6225/10000
    exif:GPSLongitudeRef: W
    exif:GPSProcessingMethod: ASCII
    exif:GPSTimeStamp: 16/1, 38/1, 11/1
    exif:GPSVersionID: 2, 2, 0, 0
    exif:ImageLength: 1152
    exif:ImageUniqueID: 9e6076155a3bd1ce0000000000000000
    exif:ImageWidth: 2048
    exif:InteroperabilityIndex: R98
    exif:InteroperabilityOffset: 948
    exif:InteroperabilityVersion: 48, 49, 48, 48
    exif:ISOSpeedRatings: 125
    exif:JPEGInterchangeFormat: 1072
    exif:JPEGInterchangeFormatLength: 4729
    exif:LightSource: 0
    exif:Make: SAMSUNG
    exif:MaxApertureValue: 228/100
    exif:MeteringMode: 1
    exif:Model: SCH-I545
    exif:Orientation: 1
    exif:ResolutionUnit: 2
    exif:SceneCaptureType: 0
    exif:SceneType: 1
    exif:SensingMethod: 2
    exif:ShutterSpeedValue: 304394/65536
    exif:Software: Google
    exif:thumbnail:ResolutionUnit: 2
    exif:thumbnail:XResolution: 72/1
    exif:thumbnail:YResolution: 72/1
    exif:WhiteBalance: 0
    exif:XResolution: 72/1
    exif:YCbCrPositioning: 1
    exif:YResolution: 72/1
    jpeg:colorspace: 2
    jpeg:sampling-factor: 2x2,1x1,1x1
    signature: 2e969ff76481f84c85031e191ee902825bf6c2a12fb6083da57633326cde2bef
  Profiles:
    Profile-exif: 5808 bytes
    Profile-xmp: 325 bytes
  Artifacts:
    filename: /Users/mrm/Downloads/20140207_083822.jpg
    verbose: true
  Tainted: False
  Filesize: 227KB
  Number pixels: 2.359M
  Pixels per second: 29.49MB
  User time: 0.070u
  Elapsed time: 0:01.080
  Version: ImageMagick 6.8.7-7 Q16 x86_64 2013-11-27 http://www.imagemagick.org
      OUT
    end

    it 'extracts width and depth from geometry' do
      ip[:width].must_equal 1152
      ip[:height].must_equal 2048
    end

    it 'extracts sub-sections properly' do
      ip[:channel_depth][:red].must_equal '8-bit'
      ip[:channel_depth][:green].must_equal '8-bit'
      ip[:channel_depth][:blue].must_equal '8-bit'
      ip[:artifacts][:verbose].must_equal 'true'
    end
  end

end
