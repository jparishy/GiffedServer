#!/usr/bin/env ruby

require 'tmpdir'

# Get the frames
out_filename_base = "/tmp/" + Dir::Tmpname.make_tmpname('converted', nil)
`ffmpeg -i '#{ARGV[0]}' -s 240x320 -vf "transpose=1" #{out_filename_base}_%05d.gif`

# Make the frames a GIF and optimize it, reducing number of colors until <2MB
output_filename = "/tmp/" + Dir::Tmpname.make_tmpname('output', nil) + ".gif"

num_colors = 128
while true do
  `gifsicle -O3 --colors #{num_colors} --loop #{out_filename_base}* > #{output_filename}`
  num_colors = num_colors == 128 ? 64 : num_colors - 8
  if File.stat(output_filename).size <= 2 * 10 ** 6 || num_colors < 24
      break
  end
end

puts output_filename
