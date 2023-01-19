defmodule Derivative do
#{:add, {:mul, {:num, 2}, {:var, x}}, {:num, 3}}; #2x + 3
#{:add, {{:mul, {:pow, {:var, x}, {:num, 4}}, {:num 2}}}, {:mul, {:num, 5}, {var:, x}}} #2x^4+5x (?)
#{:add, {:mul, {:num, 3}, {var: x}}, {:mul, {:num, 1}, {:var, x}}} #3x+x
#f(x) = C, d(f(x))/dx = 0

@type literal() :: {:num, number()} | {:var, atom()}
@type expr() :: literal() |
{:add, expr(), expr()} |
{:mul, expr(), expr()} |
{:ln, expr()} |
{:div, expr(), expr()} |
{:powr, expr(), expr()} |
{:div, expr(), expr()}

def test() do
  #expression = {:add, {:mul, {:num, -2}, {:var, :x}}, {:mul, {:var, :x}, {:num, 5}}}
  #expression2 = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 4}}
  #deriv(expression2, :x)
  expression3 = {:add, {:powr, {:var, :x}, {:num, 3}}, {:num, 4}}
  expressionLN = {:ln, {:mul, {:var, :x}, {:num, 2}}}
  d = deriv(expression3, :x)
  ln = deriv(expressionLN, :x)
  #deriv(expression, :x)
  IO.write("expression: #{pprint(expression3)}\n")
  IO.write("Derivative: #{pprint(d)}\n")
  IO.write("Simplified: #{pprint(simplify(d))}\n")
  IO.write("expression: #{pprint(expressionLN)}\n")
  IO.write("Derivative: #{pprint(ln)}\n")
  IO.write("simplified: #{pprint(simplify(ln))}\n" )
end

def deriv({:num, _}, _) do {:num, 0} end
#f(x) = x, d(f(x))/dx = 1
def deriv({:var, v}, v) do {:num, 1} end
#f(x) = y, d(f(x))/dx = 0
def deriv({:var, _}, _) do {:num, 0} end
#f(x) = 2x + 3x, d(f(x))/dx = 2+3 = 5
def deriv({:add, expr1, expr2}, v) do {:add, deriv(expr1, v), deriv(expr2, v)} end
#f(x) = 2x * 3x, d(f(x))/dx = 2*3x + 2x*3 = 12x
def deriv({:mul, expr1, expr2}, v) do {:add, {:mul, deriv(expr1, v), expr2}, {:mul, expr1, deriv(expr2, v)}} end
#f(x) = ln(x), d(f(x))/dx = 1/x
def deriv({:ln, x}, x) do {:div, {:num, 1}, {:var, x}} end
#f(x) = x^n, d(f(x))/dx = nx^(n-1)
def deriv({:powr, expr1, {:num, n}}, x) do {:mul, {:mul, {:num, n}, {:powr, expr1, {:num, n-1}}}, deriv(expr1, x)} end
#f(x) = ln(x), d(f(x))/dx = 1/x
def deriv({:ln, expr1}, x) do {:mul, {:div, {:num, 1}, expr1}, deriv(expr1, x)} end


#The following 4 functions simplifies expressions based on the operator used recursively
def simplify({:add, expr1, expr2}) do simplify_add(simplify(expr1), simplify(expr2)) end
def simplify({:mul, expr1, expr2}) do simplify_mul(simplify(expr1), simplify(expr2)) end
def simplify({:powr, expr1, expr2}) do simplify_powr(simplify(expr1), simplify(expr2)) end
def simplify({:div, expr1, expr2}) do simplify_div(simplify(expr1), simplify(expr2)) end
def simplify(e) do e end

def simplify_add(expr2, {:num, 0}) do expr2 end #x+0 = x
def simplify_add({:num, 0}, expr1) do expr1 end #0+x = x
def simplify_add({:num, expr1}, {:num, expr2}) do {:num, expr1 + expr2} end #1+1 = 2
def simplify_add(expr1, expr2) do {:add, expr1, expr2} end #x+1 = x+1

def simplify_mul({:num, 1}, expr1) do expr1 end #1*x = x
def simplify_mul(expr2, {:num, 1}) do expr2 end #x*1 = x
def simplify_mul({:num, 0}, _) do {:num, 0} end #x*0 = 0
def simplify_mul(_, {:num, 0}) do {:num, 0} end #0*x = 0
def simplify_mul({:num, expr1}, {:num, expr2}) do {:num, expr1*expr2} end #3*2 = 6
def simplify_mul(expr1, expr2) do {:mul, expr1, expr2} end #x*e = x*e

def simplify_powr(_, {:num, 0}) do {:num, 1} end #x^0 = 1
def simplify_powr(expr1, {:num, 1}) do expr1 end #x^1 = x
def simplify_powr(expr1, expr2) do {:powr, expr1, expr2} end #e^x = e^x

def simplify_div(expr1, {:num, 0}) do "Error: Div by zero" end
def simplify_div(expr1, {:num, 1}) do expr1 end
def simplify_div(expr1, expr2) do {:div, expr1, expr2} end

def pprint({:num, n}) do "#{n}" end #Prints a number
def pprint({:var, v}) do "#{v}" end #Prints variable
def pprint({:add, expr1, expr2}) do "#{pprint(expr1)} + #{pprint(expr2)}" end #Prints addition
def pprint({:mul, expr1, expr2}) do "(#{pprint(expr1)} * #{pprint(expr2)})" end #Prints multiplication
def pprint({:powr, expr1, expr2}) do "#{pprint(expr1)} ^(#{pprint(expr2)})" end #Prints exponents
def pprint({:div, expr1, expr2}) do "(#{pprint(expr1)}) / (#{pprint(expr2)})" end
def pprint({:ln, expr1}) do "ln#{pprint(expr1)}" end

end
