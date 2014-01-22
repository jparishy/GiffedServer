#!/usr/bin/env ruby

require 'tmpdir'

# Get the frames
out_filename_base = "/tmp/" + Dir::Tmpname.make_tmpname('converted', nil)
`ffmpeg -i '#{ARGV[0]}' -s 240x320 -vf "transpose=1" #{out_filename_base}_%05d.gif`

# Make the frames a GIF
output_filename = "/tmp/" + Dir::Tmpname.make_tmpname('output', nil) + ".gif"
`gifsicle --loop #{out_filename_base}* > #{output_filename}`

# Optimize the GIF
`convert #{output_filename} -coalesce -layers optimize #{output_filename}`

puts output_filename
