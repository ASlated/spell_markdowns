require 'net/http'
require 'json'
require 'pry'
require 'formatador'
require './spells.rb'

if gets.chomp == 'load'
  results = []

  lines = File.readlines("list.txt").map { |spell| spell.gsub(' ', '_').chomp}
  errors = 0
  missing_spells = []
  lines.each.with_index do |spell, index|
    begin
      puts "#{(index.to_f / lines.count * 100).round(2)}%"
      response = Net::HTTP.get_response(URI("https://roll20.net/compendium/dnd5e/Spells:#{spell}.json"))
      if response.is_a?(Net::HTTPSuccess)
        results << JSON.parse(response.body)
      else
        puts "Error: could not find #{spell}."
        errors += 1
        missing_spells << spell
      end
      sleep(rand(3))
    rescue => exception
      puts "Exception!!!"
      puts exception
      puts "Spell: " + spell
    end
  end

  puts "Errors: #{errors}"
  puts "Missing spells: #{missing_spells.each { |spell| "#{spell}, " }}"

  File.write("spells.json", results.to_json)
else
  results = JSON.load(File.new('spells.json'))
end

supplement = JSON.load(File.new('supplement.json'))
results.concat supplement

light_cleric = [
  'Guidance',
  'Light',
  'Mending',
  'Resistance',
  'Sacred Flame',
  'Spare the Dying',
  'Thaumaturgy',

  'Bane',
  'Bless',
  'Burning Hands',
  'Command',
  'Create or Destroy Water',
  'Cure Wounds',
  'Detect Evil and Good',
  'Detect Magic',
  'Detect Poison and Disease',
  'Faerie Fire',
  'Guiding Bolt',
  'Healing Word',
  'Inflict Wounds',
  'Protection from Evil and Good',
  'Purify Food and Drink',
  'Sanctuary',
  'Shield of Faith',

  'Aid',
  'Augury',
  'Blindness/Deafness',
  'Calm Emotions',
  'Continual Flame',
  'Enhance Ability',
  'Find Traps',
  'Flaming Sphere',
  'Gentle Repose',
  'Hold Person',
  'Lesser Restoration',
  'Locate Object',
  'Prayer of Healing',
  'Protection from Poison',
  'Scorching Ray',
  'Silence',
  'Spiritual Weapon',
  'Warding Bond',
  'Zone of Truth',

  'Animate Dead',
  'Beacon of Hope',
  'Bestow Curse',
  'Clairvoyance',
  'Create Food and Water',
  'Daylight',
  'Dispel Magic',
  'Feign Death',
  'Fireball',
  'Glyph of Warding',
  'Magic Circle',
  'Mass Healing Word',
  'Meld into Stone',
  'Protection from Energy',
  'Remove Curse',
  'Revivify',
  'Sending',
  'Speak with Dead',
  'Spirit Guardians',
  'Tongues',
  'Water Walk',

  'Banishment',
  'Control Water',
  'Death Ward',
  'Divination',
  'Freedom of Movement',
  'Guardian of Faith',
  'Locate Creature',
  'Stone Shape',
  'Wall of Fire',

  'Commune',
  'Contagion',
  'Dispel Evil and Good',
  'Flame Strike',
  'Geas',
  'Greater Restoration',
  'Hallow',
  'Insect Plague',
  'Legend Lore',
  'Mass Cure Wounds',
  'Planar Binding',
  'Raise Dead',
  'Scrying',

  'Blade Barrier',
  'Create Undead',
  'Find the Path',
  'Forbiddance',
  'Harm',
  'Heal',
  'Heroes\' Feast',
  'Planar Ally',
  'True Seeing',
  'Word of Recall',

  'Conjure Celestial',
  'Divine Word',
  'Etherealness',
  'Fire Storm',
  'Plane Shift',
  'Regenerate',
  'Resurrection',
  'Symbol',

  'Antimagic Field',
  'Control Weather',
  'Earthquake',
  'Holy Aura',

  'Astral Projection',
  'Gate',
  'Mass Heal',
  'True Resurrection'
]

ranger = [
  'Alarm',
  'Animal Friendship',
  'Cure Wounds',
  'Detect Magic',
  'Detect Poison and Disease',
  'Ensnaring Strike',
  'Fog Cloud',
  'Goodberry',
  'Hail of Thorns',
  'Hunter\'s Mark',
  'Jump',
  'Longstrider',
  'Speak with Animals',

  'Animal Messenger',
  'Barskin',
  'Beast Sense',
  'Cordon of Arrows',
  'Darkvision',
  'Find Traps',
  'Lesser Restoration',
  'Locate Animals or Plants',
  'Locate Object',
  'Pass without Trace',
  'Protection from Poison',
  'Silence',
  'Spike Growth',

  'Conjure Animals',
  'Conjure Barrage',
  'Daylight',
  'Lightning Arrow',
  'Nondetection',
  'Plant Growth',
  'Protection from Energy',
  'Speak with Plants',
  'Water Breathing',
  'Water Walk',
  'Wind Wall',

  'Conjure Woodland Beings',
  'Freedom of Movement',
  'Grasping Vine',
  'Locate Creature',
  'Stoneskin',

  'Commune with Nature',
  'Conjure Volley',
  'Swift Quiver',
  'Tree Stride'
]

devotion_paladin = [
  'Bless',
  'Command',
  'Compelled Duel',
  'Cure Wounds',
  'Detect Evil and Good',
  'Detect Magic',
  'Detect Poison and Disease',
  'Divine Favor',
  'Heroism',
  'Protection from Evil and Good',
  'Purify Food and Drink',
  'Sanctuary',
  'Searing Smite',
  'Shield of Faith',
  'Thunderous Smite',
  'Wraithful Smite',

  'Aid',
  'Branding Smite',
  'Find Steed',
  'Lesser Restoration',
  'Locate Object',
  'Magic Weapon',
  'Protection from Poison',
  'Zone of Truth',

  'Aura of Vitality',
  'Beacon of Hope',
  'Blinding Smite',
  'Create Food and Water',
  'Crusader\'s Mantle',
  'Daylight',
  'Dispel Magic',
  'Elemental Weapon',
  'Magic Circle',
  'Remove Curse',
  'Revivify',

  'Aura of Life',
  'Aura of Purity',
  'Banishment',
  'Death Ward',
  'Freedom of Movement',
  'Guardian of Faith',
  'Locate Creature',
  'Staggering Smite',

  'Banishing Smite',
  'Circle of Power',
  'Commune',
  'Destructive Wave',
  'Dispel Evil and Good',
  'Flame Strike',
  'Geas',
  'Raise Dead'
]


cleric_markdown = create_md(results, light_cleric)
# puts cleric_markdown
File.write('light_cleric.md', cleric_markdown)
File.write('ranger.md', create_md(results, ranger))
File.write('devotion_paladin.md', create_md(results, devotion_paladin))

while true
  Formatador.display_line("[red]Enter the name of a spell:[/]")
  input = gets.chomp.titleize
  spell = results.detect { |spell| spell["name"] == input }
  if spell
    puts_spell(spell)
  else
    Formatador.display_line("[red]No such spell.[/]")
  end
end
