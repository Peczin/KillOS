# 


def clear_screen
  system("clear") || system("cls")
end 

def help
  puts "Comandos disponiveis: help, clear, echo, exit"
end 

def echo(args)
  puts args.join("")
end 
def up
  letter = gets.chomp.upcase
  puts letter
end
def repet
  3.times do 
    print("\nKillOS ")
  end 
end

def tab
  t = "\t*"
  n = "\n*"
  print(t, n)
end

def mathh
  print "Digite o primeiro número: "
  x = gets.chomp.to_f 
  print "Digite o operador (+, -, *, /): "
  operador = gets.chomp
  print "Digite o segundo número: "
  y = gets.chomp.to_f

  case operador
  when "+"
    result = x + y
    puts result
  when "-"
    result = x - y
    puts result
  when "*"
    result = x * y
    puts result
  when "/"
    if y == 0
      return "Erro. Divisão por zero"
    else
      result = x / y
      puts result
    end
  else
    return "Operador inválido"
  end
end
def process_command(line)
  parts = line.strip.split
  cmd = parts[0]
  args = parts[1..-1] || []
case cmd 
when "help"
  help 
when "echo"
  echo(args)
when "clear"
  clear 
when "repet"
  repet
when "mathh"
  mathh
when "up"
  up
when "tab"
  tab
when "exit"
  puts "saindo.."
  exit
  else
  puts "Comando não encontrado #{cmd}"
  end 
end
puts ">> KillOS "
puts "Digite comandos help para ajuda"
loop do 
  print '>  '
  line = gets 
  break if line.nil?
  process_command(line)
end

