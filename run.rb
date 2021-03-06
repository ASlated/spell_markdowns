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

wizard = [
  'Acid Splash',
  'Blade Ward',
  'Chill Touch',
  'Dancing Lights',
  'Fire Bolt',
  'Friends',
  'Light',
  'Mage Hand',
  'Mending',
  'Message',
  'Minor Illusion',
  'Poison Spray',
  'Prestidigitation',
  'Ray of Frost',
  'Shocking Grasp',
  'True Strike',

  'Alarm',
  'Burning Hands',
  'Charm Person',
  'Chromatic Orb',
  'Color Spray',
  'Comprehend Languages',
  'Detect Magic',
  'Disguise Self',
  'Expeditious Retreat',
  'False Life',
  'Feather Fall',
  'Find Familiar',
  'Fog Cloud',
  'Grease',
  'Identify',
  'Illusionary Script',
  'Jump',
  'Longstrider',
  'Mage Armor',
  'Magic Missile',
  'Protection from Evil and Good',
  'Ray of Sickness',
  'Shield',
  'Silent Image',
  'Sleep',
  'Tasha\'s Hideous Laughter',
  'Tenser\'s Floating Disk',
  'Thunderwave',
  'Unseen Servant',
  'Witch Bolt',

  'Alter Self',
  'Arcane Lock',
  'Blindness/Deafness',
  'Blur',
  'Cloud of Daggers',
  'Continual Flame',
  'Crown of Madness',
  'Darkness',
  'Darkvision',
  'Detect Thoughts',
  'Enlarge Reduce',
  'Flaming Sphere',
  'Gentle Repose',
  'Gust of Wind',
  'Hold Person',
  'Invisibility',
  'Knock',
  'Levitate',
  'Locate Object',
  'Magic Mouth',
  'Magic Weapon',
  'Melf\'s Acid Arrow',
  'Mirror Image',
  'Misty Step',
  'Nystul\'s Magic Aura',
  'Phantasmal Force',
  'Ray of Enfeeblement',
  'Rope Trick',
  'Scorching Ray',
  'See Invisibility',
  'Shatter',
  'Spider Climb',
  'Suggestion',
  'Web',

  'Animate Dead',
  'Bestow Curse',
  'Blink',
  'Clairvoyance',
  'Counterspell',
  'Dispel Magic',
  'Fear',
  'Feign Death',
  'Fireball',
  'Fly',
  'Gaseous Form',
  'Glyph of Warding',
  'Haste',
  'Hypnotic Pattern',
  'Leomund\'s Tiny Hut',
  'Lightning Bolt',
  'Magic Circle',
  'Major Image',
  'Nondetection',
  'Phantom Steed',
  'Protection from Energy',
  'Remove Curse',
  'Sending',
  'Sleet Storm',
  'Slow',
  'Stinking Cloud',
  'Tongues',
  'Vampiric Touch',
  'Water Breathing',

  'Arcane Eye',
  'Banishment',
  'Blight',
  'Confusion',
  'Conjure Minor Elementals',
  'Control Water',
  'Dimension Door',
  'Evard\'s Black Tentacles',
  'Fabricate',
  'Fire Shield',
  'Greater Invisibility',
  'Hallucinatory Terrain',
  'Ice Storm',
  'Leomund\'s Secret Chest',
  'Locate Creature',
  'Mordenkainen\'s Faithful Hound',
  'Mordenkainen\'s Private Sanctum',
  'Otiluke\'s Resilient Sphere',
  'Phantasmal Killer',
  'Polymorph',
  'Stone Shape',
  'Stoneskin',
  'Wall of Fire',

  'Animate Objects',
  'Bigby\'s Hand',
  'Cloudkill',
  'Cone of Cold',
  'Conjure Elemental',
  'Contact Other Plane',
  'Creation',
  'Dominate Person',
  'Dream',
  'Geas',
  'Hold Monster',
  'Legend Lore',
  'Mislead',
  'Modify Memory',
  'Passwall',
  'Planar Binding',
  'Rary\'s Telepathic Bond',
  'Scrying',
  'Seeming',
  'Telekinesis',
  'Teleportation Circle',
  'Wall of Force',
  'Wall of Stone',

  'Arcane Gate',
  'Chain Lightning',
  'Circle of Death',
  'Contingency',
  'Create Undead',
  'Disintegrate',
  'Drawmij\'s Instant Summons',
  'Eyebite',
  'Flesh to Stone',
  'Globe of Invulnerability',
  'Guards and Wards',
  'Magic Jar',
  'Mass Suggestion',
  'Move Earth',
  'Otiluke\'s Freezing Sphere',
  'Otto\'s Irresistible Dance',
  'Programmed Illusion',
  'Sunbeam',
  'True Seeing',
  'Wall of Ice',
  'Delayed Blast Fireball',
  'Etherealness',
  'Finger of Death',
  'Forcecage',
  'Mirage Arcane',
  'Mordenkainen\'s Magnificent Mansion',
  'Mordenkainen\'s Sword',
  'Plane Shift',
  'Prismatic Spray',
  'Project Image',
  'Reverse Gravity',
  'Sequester',
  'Simulacrum',
  'Symbol',
  'Teleport',

  'Antimagic Field',
  'Antipathy (Sympathy)',
  'Clone',
  'Control Weather',
  'Demiplane',
  'Dominate Monster',
  'Feeblemind',
  'Incendiary Cloud',
  'Maze',
  'Mind Blank',
  'Power Word Stun',
  'Sunburst',
  'Telepathy',

  'Astral Projection',
  'Foresight',
  'Gate',
  'Imprisonment',
  'Meteor Swarm',
  'Power Word Kill',
  'Prismatic Wall',
  'Shapechange',
  'Time Stop',
  'True Polymorph',
  'Weird',
  'Wish'
]

each_level = {"0" => [], "1" => [], "2" => [], "3" => [], "4" => [], "5" => [], "6" => [], "7" => [], "8" => [], "9" => []}
results.each { |spell| each_level[spell['data']['Level']] << spell['name'] }
each_level.each_value { |l| l.sort_by!{ |e| e.downcase } }
# all.sort! do |a,b|
#   spellA = results.detect { |spell| spell['name'] == a }
#   spellB = results.detect { |spell| spell['name'] == b }
#   spellA['data']['Level'] <=> spellB['data']['Level']
# end
all = []
each_level.each_value { |l| all.concat(l) }


File.write('all.md', create_md(results, all))
cleric_markdown = create_md(results, light_cleric)
# puts cleric_markdown
File.write('light_cleric.md', cleric_markdown)
File.write('ranger.md', create_md(results, ranger))
File.write('devotion_paladin.md', create_md(results, devotion_paladin))
File.write('wizard.md', create_md(results, wizard))

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
