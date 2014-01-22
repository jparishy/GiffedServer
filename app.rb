require 'sinatra'
require 'RMagick'

puts "lol"

def delay(fps)
  (100.0 / fps) 
end

post '/gifify' do
  content_type "image/gif"

  temp_files = params.values.map { |value| value[:tempfile] }
  filenames = temp_files.map { |file| file.path }

  puts filenames

  filename = filenames[0]
  output_filename = `./convert.rb '#{filename}'`
  output_filename.strip!

  send_file(output_filename, :filename => "converted.gif", :type => "image/gif")
end
