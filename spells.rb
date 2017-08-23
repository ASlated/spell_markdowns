require 'json'
require 'formatador'
require 'pry'

class String
  def titleize
    lowercase_words = %w{a an the and but or for nor of}
    split.each_with_index.map{|x, index| lowercase_words.include?(x) && index > 0 ? x : x.capitalize }.join(" ")
  end
end

def puts_spell(spell)
  puts
  puts "----------------------------------------------------------------"
  puts
  Formatador.display_line("[white][_black_] #{spell["name"]} [/]")
  Formatador.display_line("[red]Level #{spell["data"]["Level"]} #{spell["data"]["School"]}[/]")
  puts
  Formatador.display_line("[green]Casting Time[/] #{spell["data"]["Casting Time"]}")
  Formatador.display_line("[green]Range[/] #{spell["data"]["Range"]}")
  if spell["data"].key?("Material")
    Formatador.display_line("[green]Components[/] #{spell["data"]["Components"]} (#{spell["data"]["Material"]})")
  else
    Formatador.display_line("[green]Components[/] #{spell["data"]["Components"]}")
  end
  Formatador.display_line("[green]Duration[/] #{spell["data"]["Duration"]}")
  Formatador.display_line("#{spell["content"].gsub("\n\n", "\n  ")}")
  puts
  puts "----------------------------------------------------------------"
end

def create_md(spells, list)
  str = ''
  level = -1;
  list.each do |element|
    spell = spells.detect { |spell| spell['name'] == element }
    if level != spell['data']['Level']
      if spell['data']['Level'] == "0"
        str += "# Cantrips\n"
      else
        str += "# Level #{spell['data']['Level']} Spells\n"
      end
    end
    level = spell['data']['Level']
    str += "## #{spell['name']}\n\n"
    str += "_#{spell['data']['School']}_\n\n"
    str += "__Range__ #{spell['data']['Range']}\n\n"
    if spell['data'].key?('Material')
      str += "__Components__ #{spell['data']['Components']} (#{spell['data']['Material']})\n\n"
    else
      str += "__Components__ #{spell['data']['Components']}\n\n"
    end
    str += "__Duration__ #{spell['data']['Duration']}\n\n"
    str += "#{spell['content'].gsub("\n\n", "\n\n  ")}\n\n"
  end
  return str
end

file = File.read('spells.json')
spells = JSON.parse(file)

# while true
#   Formatador.display_line("[red]Enter the name of a spell:[/]")
#   input = gets.chomp.titleize
#   spell = spells.detect { |spell| spell["name"] == input }
#   if spell
#     puts_spell(spell)
#   else
#     Formatador.display_line("[red]No such spell.[/]")
#   end
#   puts
# end
