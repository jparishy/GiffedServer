require 'sinatra'
require 'rmagick'

def delay(fps)
  (100.0 / fps) 
end

post '/gifify' do
  content_type "image/gif"

  temp_files = params.values.map { |value| value[:tempfile] }
  filenames = temp_files.map { |file| file.path }

  puts filenames

  animation = Magick::ImageList.new

  filenames.each do |filename|
    converted = Magick::Image.read filename
    animation.from_blob converted[0].to_blob { |attributes| attributes.format = 'GIF' }
  end

  animation.delay = delay(24)
  animation.iterations = 0

  animation.to_blob
end
