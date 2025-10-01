# This script moves a file from the private directory system into the public directory system.

# At first, this file will always be assumed to be a map file,
# and will be pulled from private/resources/zones/maps/ into public/resources/zones/maps/

# Any chunks image file referenced in the map file will be pulled from
# private/resources/zones/chunks/ into public/resources/zones/chunks/

# Example: ruby move.rb ghz1Map
# moves ghz1Map.lua       from (private)/resources/zones/maps/   to (public)/resources/zones/maps/
# and   ghzChunks_IMG.png from (private)/resources/zones/chunks/ to (public)/resources/zones/chunks/
# (due to the name of the chunk file being embedded inside the map data file.)

require 'fileutils'

appSupportDirName = "Application\ Support"

src_zones_dir = "/Users/mhopk5/Library/#{appSupportDirName}/LOVE/sonicDestination/resources/zones/"
dst_zones_dir = "/Users/mhopk5/Development/games/love2d/sonicDestination/resources/zones/"

src_map_file = "#{src_zones_dir}/maps/#{ARGV[0]}.lua"

chunkImgName = ""

File.open(src_map_file, "r") do |f|
  f.each_line do |line|
    if line.strip.include?("chunksImageName") then
    	elements = line.strip.split("\"")
    	chunkImgName = elements[1]
    end
  end
end

src_chk_file = "#{src_zones_dir}/chunks/#{chunkImgName}.png"

dst_map_dir = "#{dst_zones_dir}/maps"
dst_chk_dir = "#{dst_zones_dir}/chunks"

FileUtils.mv(src_map_file, dst_map_dir)
FileUtils.mv(src_chk_file, dst_chk_dir)
