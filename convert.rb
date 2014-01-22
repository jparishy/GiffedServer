#!/usr/bin/env ruby

require 'tmpdir'

# Get the frames
out_filename_base = "/tmp/" + Dir::Tmpname.make_tmpname('converted', nil)
`ffmpeg -i '#{ARGV[0]}' -s 240x320 -vf "transpose=1" #{out_filename_base}_%05d.gif`

# Make the frames a GIF and optimize it, reducing number of colors until <2MB
output_filename = "/tmp/" + Dir::Tmpname.make_tmpname('output', nil) + ".gif"

num_colors = 128
while true do
  # Make the GIF, using num_colors colors
  `gifsicle -O3 --colors #{num_colors} --loop #{out_filename_base}* > #{output_filename}`
  # Kill every other frame from it.
  `gifsicle #{out_filename_base} \`seq -f "#%g" 0 2 $(identify #{out_filename_base} | tail -1 | cut -d "[" -f2 - | cut -d "]" -f1 -)\` --unoptimize -o #{out_filename_base}`
  if File.stat(output_filename).size <= 2 * 10 ** 6 || num_colors < 32
      num_colors = num_colors == 128 ? 64 : num_colors - 8
      break
  end
end

puts output_filename
