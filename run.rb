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


markdown = create_md(results, light_cleric)
# puts markdown
File.write('light_cleric.md', markdown)

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
