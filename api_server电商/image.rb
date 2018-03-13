
Imagery::Transformations.register :z_1_2 do |image|
  image.crop_resized(image.columns/2, image.rows/2, Magick::CenterGravity)
end

Imagery::Transformations.register :thumb do |image|
  image.crop_resized(40,40, Magick::CenterGravity)
end

Imagery::Transformations.register :small do |image|
  image.change_geometry("180x180>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :large do |image|
  image.change_geometry("1000x750>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :middle do |image|
  image.change_geometry("400x300>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :promote do |image|
  image.change_geometry("350x350>") { |x, y, image| image.thumbnail!(x,y) }
end


Imagery::Transformations.register :feed do |image|
  image.crop_resized(180,135, Magick::CenterGravity)
end

Imagery::Transformations.register :square do |image|
  image.crop_resized(180,180, Magick::CenterGravity)
end


Imagery::Transformations.register :csquare do |image|
  image.crop_resized(200,350, Magick::CenterGravity)
end

Imagery::Transformations.register :livefeed do |image|
  image.crop_resized(100,100, Magick::CenterGravity)
end

Imagery::Transformations.register :livefeed_s do |image|
  image.crop_resized(80,80, Magick::CenterGravity)
end

#----------------------------------for mobile--------------------------------

Imagery::Transformations.register :m110 do |image|
  image.change_geometry("110x110>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m220 do |image|
  image.change_geometry("220x220>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m80 do |image|
  image.change_geometry("80x80>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m290 do |image|
  image.change_geometry("290x290>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m320x175 do |image|
  image.change_geometry("320x175>") { |x, y, image| image.thumbnail!(x,y) }
end


Imagery::Transformations.register :m145 do |image|
  image.change_geometry("145x145>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :thumb145 do |image|
  image.change_geometry("145x145>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m640 do |image|
  image.change_geometry("640x640>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m320 do |image|
  image.change_geometry("320x320>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m225 do |image|
  image.change_geometry("225x225>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m160 do |image|
  image.change_geometry("160x160>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m90 do |image|
  image.change_geometry("90x90>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m375 do |image|
  image.change_geometry("375x375>") { |x, y, image| image.thumbnail!(x,y) }
end


Imagery::Transformations.register :m76x45 do |image|
  image.change_geometry("76x45>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m210 do |image|
  image.change_geometry("210x210>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m300 do |image|
  image.change_geometry("300x300>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m600 do |image|
  image.change_geometry("600x600>") { |x, y, image| image.thumbnail!(x,y) }
end


Imagery::Transformations.register :moderate do |image|
  image.change_geometry("450x450>") { |x, y, image| image.thumbnail!(x,y) }
end

#--------------------------------author : yanky------------------------------

#--------------------------------for out source------------------------------
Imagery::Transformations.register :m130 do |image|
  image.change_geometry("130x130>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m420 do |image|
  image.change_geometry("420x420>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m580 do |image|
  image.change_geometry("580x580>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m152x90 do |image|
  image.change_geometry("152x90>") { |x, y, image| image.thumbnail!(x,y) }
end


#----------------------------------------------------------------------------

# For list images.-----------------------------------------------------------
Imagery::Transformations.register :l200 do |image|
  image.change_geometry("200x200>") { |x, y, image| image.thumbnail!(x,y) }
end
#----------------------------------------------------------------------------

# For mobile touch-----------------------------------------------------------
Imagery::Transformations.register :t240 do |image|
  image.change_geometry("240x240>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :t320 do |image|
  image.change_geometry("320x320>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :t360 do |image|
  image.change_geometry("360x360>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :t460 do |image|
  image.change_geometry("460x460>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :t480 do |image|
  image.change_geometry("480x480>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :t540 do |image|
  image.change_geometry("540x540>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :t640 do |image|
  image.change_geometry("640x640>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :t720 do |image|
  image.change_geometry("720x720>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :t800 do |image|
  image.change_geometry("800x800>") { |x, y, image| image.thumbnail!(x,y) }
end

#----------------------------------------------------------------------------
#For ipad include livefeed and l200------------------------------------------

Imagery::Transformations.register :p500 do |image|
  image.change_geometry("500x500>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :p140 do |image|
  image.change_geometry("140x140>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :p280 do |image|
  image.change_geometry("280x280>") { |x, y, image| image.thumbnail!(x,y) }
end
#----------------------------------------------------------------------------
#For treasure new version---------------------------------------------------
Imagery::Transformations.register :s400 do |image|
  image.change_geometry("400x400>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :s50 do |image|
  image.change_geometry("50x50>") { |x, y, image| image.thumbnail!(x,y) }
end
#----------------------------------------------------------------------------
#2013.5.24 add by chuzhuo----------------------------------------------------
Imagery::Transformations.register :t150 do |image|
  image.change_geometry("150x150>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :t75 do |image|
  image.change_geometry("75x75>") { |x, y, image| image.thumbnail!(x,y) }
end
#-----------------------------------------------------------------------------
#2013.8.12 add by chuzhuo----------------------------------------------------
Imagery::Transformations.register :m550 do |image|
  image.change_geometry("550x550>") { |x, y, image| image.thumbnail!(x,y) }
end
Imagery::Transformations.register :r550 do |image|
      image.change_geometry("550x550>") { |x, y, image| image.resize!(x,y) }
end
#-----------------------------------------------------------------------------
#2013.9.9 add by yanky----------------------------------------------------
Imagery::Transformations.register :s700 do |image|
  image.change_geometry("1000x700>") { |x, y, image| image.thumbnail!(x,y) }
end
#-----------------------------------------------------------------------------
#2014.5.14 add by chuzhuo----------------------------------------------------
Imagery::Transformations.register :t60 do |image|
  image.change_geometry("60x60>") { |x, y, image| image.thumbnail!(x,y) }
end
#-----------------------------------------------------------------------------
#2014.5.26 add by chuzhuo----------------------------------------------------
Imagery::Transformations.register :t335 do |image|
  image.change_geometry("335x335>") { |x, y, image| image.thumbnail!(x,y) }
end
Imagery::Transformations.register :t155 do |image|
  image.change_geometry("155x155>") { |x, y, image| image.thumbnail!(x,y) }
end
#-----------------------------------------------------------------------------
#2014.5.30 add by chuzhuo----------------------------------------------------
Imagery::Transformations.register :cp706x374 do |image|
  image.change_geometry("706x374>") { |x, y, image| image.thumbnail!(x,y) }
end
Imagery::Transformations.register :cp164x50 do |image|
  image.change_geometry("164x50>") { |x, y, image| image.thumbnail!(x,y) }
end
Imagery::Transformations.register :cp300x100 do |image|
  image.change_geometry("300x100>") { |x, y, image| image.thumbnail!(x,y) }
end
Imagery::Transformations.register :cp145x150 do |image|
  image.change_geometry("145x150>") { |x, y, image| image.thumbnail!(x,y) }
end
Imagery::Transformations.register :cp145x70 do |image|
  image.change_geometry("145x70>") { |x, y, image| image.thumbnail!(x,y) }
end
Imagery::Transformations.register :cp275x162 do |image|
  image.change_geometry("275x162>") { |x, y, image| image.thumbnail!(x,y) }
end
Imagery::Transformations.register :cp828x414 do |image|
  image.change_geometry("828x414>") { |x, y, image| image.thumbnail!(x,y) }
end
#-----------------------------------------------------------------------------
#2014.7.16 add by chuzhuo----------------------------------------------------
Imagery::Transformations.register :m960 do |image|
  image.change_geometry("960x960>") { |x, y, image| image.thumbnail!(x,y) }
end
#-----------------------------------------------------------------------------
#2014.7.17 add by chuzhuo----------------------------------------------------
Imagery::Transformations.register :m270 do |image|
  image.change_geometry("270x270>") { |x, y, image| image.thumbnail!(x,y) }
end
#-----------------------------------------------------------------------------
# ¶¨¿í´¦Àí
%w(48 100 120 150 240 320 360 480 600 640 720 768 870 1080).each do |sz|
  Imagery::Transformations.register "fw#{sz}".to_sym do |image|
    image.change_geometry("#{sz}x") { |x, y, image| image.thumbnail!(x,y) }
  end
end
#2015.5.6 add by chuzhuo----------------------------------------------------
Imagery::Transformations.register :m1000 do |image|
  image.change_geometry("1000x1000>") { |x, y, image| image.thumbnail!(x,y) }
end
#-----------------------------------------------------------------------------
#2015.11.18 add by chuzhuo----------------------------------------------------
Imagery::Transformations.register :m48 do |image|
  image.change_geometry("48x48>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m60 do |image|
  image.change_geometry("60x60>") { |x, y, image| image.thumbnail!(x,y) }
end
#2016.1.5 add by chuzhuo----------------------------------------------------
Imagery::Transformations.register :m870 do |image|
  image.change_geometry("870x870>") { |x, y, image| image.thumbnail!(x,y) }
end

Imagery::Transformations.register :m78 do |image|
  image.change_geometry("78x78>") { |x, y, image| image.thumbnail!(x,y) }
end
