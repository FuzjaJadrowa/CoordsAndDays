#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#
#  This function has been created by FuzjaJadrowa.
#               https://fuzjajadrowa.pl
#
#               COPYING IS PROHIBITED!
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

execute store result score @s cc_x run data get entity @s Pos[0]
execute store result score @s cc_y run data get entity @s Pos[1]
execute store result score @s cc_z run data get entity @s Pos[2]

execute store result score @s cc_day run time query time
scoreboard players set #24000 cc_day 24000
scoreboard players operation @s cc_day /= #24000 cc_day

scoreboard players set @s cc_len 0

execute if score @s cc_x matches 0..9 run scoreboard players add @s cc_len 1
execute if score @s cc_x matches 10..99 run scoreboard players add @s cc_len 2
execute if score @s cc_x matches 100..999 run scoreboard players add @s cc_len 3
execute if score @s cc_x matches 1000..9999 run scoreboard players add @s cc_len 4
execute if score @s cc_x matches 10000..99999 run scoreboard players add @s cc_len 5
execute if score @s cc_x matches 100000..999999 run scoreboard players add @s cc_len 6
execute if score @s cc_x matches 1000000..9999999 run scoreboard players add @s cc_len 7
execute if score @s cc_x matches 10000000.. run scoreboard players add @s cc_len 8
execute if score @s cc_x matches -9..-1 run scoreboard players add @s cc_len 2
execute if score @s cc_x matches -99..-10 run scoreboard players add @s cc_len 3
execute if score @s cc_x matches -999..-100 run scoreboard players add @s cc_len 4
execute if score @s cc_x matches -9999..-1000 run scoreboard players add @s cc_len 5
execute if score @s cc_x matches -99999..-10000 run scoreboard players add @s cc_len 6
execute if score @s cc_x matches -999999..-100000 run scoreboard players add @s cc_len 7
execute if score @s cc_x matches -9999999..-1000000 run scoreboard players add @s cc_len 8
execute if score @s cc_x matches ..-10000000 run scoreboard players add @s cc_len 9

execute if score @s cc_y matches 0..9 run scoreboard players add @s cc_len 1
execute if score @s cc_y matches 10..99 run scoreboard players add @s cc_len 2
execute if score @s cc_y matches 100..999 run scoreboard players add @s cc_len 3
execute if score @s cc_y matches 1000.. run scoreboard players add @s cc_len 4
execute if score @s cc_y matches -9..-1 run scoreboard players add @s cc_len 2
execute if score @s cc_y matches -99..-10 run scoreboard players add @s cc_len 3
execute if score @s cc_y matches -999..-100 run scoreboard players add @s cc_len 4
execute if score @s cc_y matches ..-1000 run scoreboard players add @s cc_len 5

execute if score @s cc_z matches 0..9 run scoreboard players add @s cc_len 1
execute if score @s cc_z matches 10..99 run scoreboard players add @s cc_len 2
execute if score @s cc_z matches 100..999 run scoreboard players add @s cc_len 3
execute if score @s cc_z matches 1000..9999 run scoreboard players add @s cc_len 4
execute if score @s cc_z matches 10000..99999 run scoreboard players add @s cc_len 5
execute if score @s cc_z matches 100000..999999 run scoreboard players add @s cc_len 6
execute if score @s cc_z matches 1000000..9999999 run scoreboard players add @s cc_len 7
execute if score @s cc_z matches 10000000.. run scoreboard players add @s cc_len 8
execute if score @s cc_z matches -9..-1 run scoreboard players add @s cc_len 2
execute if score @s cc_z matches -99..-10 run scoreboard players add @s cc_len 3
execute if score @s cc_z matches -999..-100 run scoreboard players add @s cc_len 4
execute if score @s cc_z matches -9999..-1000 run scoreboard players add @s cc_len 5
execute if score @s cc_z matches -99999..-10000 run scoreboard players add @s cc_len 6
execute if score @s cc_z matches -999999..-100000 run scoreboard players add @s cc_len 7
execute if score @s cc_z matches -9999999..-1000000 run scoreboard players add @s cc_len 8
execute if score @s cc_z matches ..-10000000 run scoreboard players add @s cc_len 9

scoreboard players set @s cc_day_len 1
execute if score @s cc_day matches 10..99 run scoreboard players set @s cc_day_len 2
execute if score @s cc_day matches 100..999 run scoreboard players set @s cc_day_len 3
execute if score @s cc_day matches 1000..9999 run scoreboard players set @s cc_day_len 4
execute if score @s cc_day matches 10000..99999 run scoreboard players set @s cc_day_len 5
execute if score @s cc_day matches 100000.. run scoreboard players set @s cc_day_len 6

data modify storage cc:main pad set value {coords:"",day:""}

execute if score @s cc_len matches 3 run data modify storage cc:main pad.coords set value "\uF827\uF826\uF825\uF824\uF821"
execute if score @s cc_len matches 4 run data modify storage cc:main pad.coords set value "\uF827\uF826\uF825\uF822\uF821"
execute if score @s cc_len matches 5 run data modify storage cc:main pad.coords set value "\uF827\uF826\uF824\uF823\uF821"
execute if score @s cc_len matches 6 run data modify storage cc:main pad.coords set value "\uF827\uF826\uF823\uF822\uF821"
execute if score @s cc_len matches 7 run data modify storage cc:main pad.coords set value "\uF827\uF826\uF821"
execute if score @s cc_len matches 8 run data modify storage cc:main pad.coords set value "\uF827\uF825\uF824\uF822\uF821"
execute if score @s cc_len matches 9 run data modify storage cc:main pad.coords set value "\uF827\uF825\uF823\uF821"
execute if score @s cc_len matches 10 run data modify storage cc:main pad.coords set value "\uF827\uF824\uF823\uF822\uF821"
execute if score @s cc_len matches 11 run data modify storage cc:main pad.coords set value "\uF827\uF824\uF821"
execute if score @s cc_len matches 12 run data modify storage cc:main pad.coords set value "\uF827\uF822\uF821"
execute if score @s cc_len matches 13 run data modify storage cc:main pad.coords set value "\uF826\uF825\uF824\uF823\uF821"
execute if score @s cc_len matches 14 run data modify storage cc:main pad.coords set value "\uF826\uF825\uF823\uF822\uF821"
execute if score @s cc_len matches 15 run data modify storage cc:main pad.coords set value "\uF826\uF825\uF821"
execute if score @s cc_len matches 16 run data modify storage cc:main pad.coords set value "\uF826\uF824\uF822\uF821"
execute if score @s cc_len matches 17 run data modify storage cc:main pad.coords set value "\uF826\uF823\uF821"
execute if score @s cc_len matches 18 run data modify storage cc:main pad.coords set value "\uF825\uF824\uF823\uF822\uF821"
execute if score @s cc_len matches 19 run data modify storage cc:main pad.coords set value "\uF825\uF824\uF821"
execute if score @s cc_len matches 20 run data modify storage cc:main pad.coords set value "\uF825\uF822\uF821"
execute if score @s cc_len matches 21 run data modify storage cc:main pad.coords set value "\uF824\uF823\uF821"
execute if score @s cc_len matches 22 run data modify storage cc:main pad.coords set value "\uF823\uF822\uF821"
execute if score @s cc_len matches 23 run data modify storage cc:main pad.coords set value "\uF821"

execute if score @s cc_day_len matches 1 run data modify storage cc:main pad.day set value "\uF828\uF825\uF822"
execute if score @s cc_day_len matches 2 run data modify storage cc:main pad.day set value "\uF828\uF824\uF823"
execute if score @s cc_day_len matches 3 run data modify storage cc:main pad.day set value "\uF828\uF823\uF822"
execute if score @s cc_day_len matches 4 run data modify storage cc:main pad.day set value "\uF828"
execute if score @s cc_day_len matches 5 run data modify storage cc:main pad.day set value "\uF827\uF826\uF825\uF824\uF822"
execute if score @s cc_day_len matches 6 run data modify storage cc:main pad.day set value "\uF827\uF826\uF825\uF823"

title @s actionbar [{"text":"Block: ","color":"#ff0022"},{"score":{"name":"@s","objective":"cc_x"},"color":"#ff0022"},{"text":" ","color":"#ff0022"},{"score":{"name":"@s","objective":"cc_y"},"color":"#ff0022"},{"text":" ","color":"#ff0022"},{"score":{"name":"@s","objective":"cc_z"},"color":"#ff0022"},{"nbt":"pad.coords","storage":"cc:main","color":"#ff0022","interpret":true},{"text":"\uF81B"},{"text":"Day #","color":"#ff0011"},{"score":{"name":"@s","objective":"cc_day"},"color":"#ff0011"},{"nbt":"pad.day","storage":"cc:main","color":"#ff0011","interpret":true}]