# This script moves a file from the private directory system into the public directory system.

# At first, this file will always be assumed to be a map file,
# and will be pulled from private/resources/zones/maps/ into public/resources/zones/maps/

# Any chunks image file referenced in the map file will be pulled from
# private/resources/zones/chunks/ into public/resources/zones/chunks/

# Any chunk data file referenced in the map file will be pulled from
# private/resources/zones/chunks/ into public/resources/zones/chunks/

# Any tiles image file referenced in the chunk data file will be pulled from
# private/resources/zones/tiles/  into public/resources/zones/tiles/

# Example: ruby move.rb ghz1Map
# moves ghz1Map.lua       from (private)/resources/zones/maps/   to (public)/resources/zones/maps/
# and   ghzChunks_IMG.png from (private)/resources/zones/chunks/ to (public)/resources/zones/chunks/
# (due to the name of the chunk file being embedded inside the map data file.)
# and   ghzChunks.lua     from (private)/resources/zones/chunks/ to (public)/resources/zones/chunks/
# (due to the name of the chunk data file being embedded inside the map data file.)
# and   ghzTiles_IMG.png  from (private)/resources/zones/tiles/  to (publiv)/resources/zones/tiles/
# (due to the name of the tiles image file being embedded inside the chunk data file.)

require 'fileutils'

appSupportDirName = "Application\ Support"

src_zones_dir = "/Users/mhopk5/Library/#{appSupportDirName}/LOVE/sonicDestination/resources/zones"
dst_zones_dir = "/Users/mhopk5/Development/games/love2d/sonicDestination/resources/zones"

src_map_file = "#{src_zones_dir}/maps/#{ARGV[0]}.lua"

chunkImgName   = nil
chunksDataName = nil

File.open(src_map_file, "r") do |f|
  f.each_line do |line|
    if line.strip.include?("chunksImageName") then
    	elements = line.strip.split("\"")
    	chunkImgName = elements[1]
    elsif line.strip.include?("chunksDataName") then
      elements = line.strip.split("\"")
      chunksDataName = elements[1]
    end
  end
end

src_chk_img_file = "#{src_zones_dir}/chunks/#{chunkImgName}.png"   unless chunkImgName.nil?
src_chk_dat_file = "#{src_zones_dir}/chunks/#{chunksDataName}.lua" unless chunksDataName.nil?

tilesImgName = nil

unless src_chk_dat_file.nil? or not File.exist?(src_chk_dat_file)
  File.open(src_chk_dat_file, "r") do |f|
    f.each_line do |line|
      if line.strip.include?("tilesImageName") then
        elements = line.strip.split("\"")
        tilesImgName = elements[1]
      end
    end
  end
end

src_til_img_file = "#{src_zones_dir}/tiles/#{tilesImgName}.png"   unless tilesImgName.nil?

dst_map_dir = "#{dst_zones_dir}/maps"
dst_chk_dir = "#{dst_zones_dir}/chunks"
dst_til_dir = "#{dst_zones_dir}/tiles"

def moveFile(src, dst)
  puts("Moving #{src} to #{dst}")
  FileUtils.mv(src, dst)
end

moveFile(src_map_file, dst_map_dir)
moveFile(src_chk_img_file, dst_chk_dir) unless src_chk_img_file.nil? or not File.exist?(src_chk_img_file)
moveFile(src_chk_dat_file, dst_chk_dir) unless src_chk_dat_file.nil? or not File.exist?(src_chk_dat_file)
moveFile(src_til_img_file, dst_til_dir) unless src_til_img_file.nil? or not File.exist?(src_til_img_file)

