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
{:div, expr(), expr()} |
{:sqrt, expr()} |
{:cos, expr()} |
{:sin, expr()}

def test() do
  #expression = {:add, {:mul, {:num, -2}, {:var, :x}}, {:mul, {:var, :x}, {:num, 5}}}
  #expression2 = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 4}}
  #deriv(expression2, :x)
  expressionLI = {:num, 5}
  li = deriv(expressionLI, :x)
  IO.write("\nexpression: #{pprint(expressionLI)}\n")
  IO.write("Derivative: #{pprint(li)}\n")
  IO.write("Simplified: #{pprint(simplify(li))}\n")

  expressionVAR = {:var, :x}
  var = deriv(expressionVAR, :x)
  IO.write("\nexpression: #{pprint(expressionVAR)}\n")
  IO.write("Derivative: #{pprint(var)}\n")
  IO.write("Simplified: #{pprint(simplify(var))}\n")

  expressionY = {:var, :y}
  y = deriv(expressionY, :x)
  IO.write("\nexpression: #{pprint(expressionY)}\n")
  IO.write("Derivative: #{pprint(y)}\n")
  IO.write("Simplified: #{pprint(simplify(y))}\n")

  expressionADD = {:add, {:mul, {:var, :x}, {:num, 3}}, {:mul, {:var, :x}, {:num, 4}}}
  add = deriv(expressionADD, :x)
  IO.write("\nexpression: #{pprint(expressionADD)}\n")
  IO.write("Derivative: #{pprint(add)}\n")
  IO.write("Simplified: #{pprint(simplify(add))}\n")

  expressionMUL = {:mul, {:mul, {:var, :x}, {:num, 11}}, {:add, {:var, :x}, {:num, 1}}}
  mul = deriv(expressionMUL, :x)
  IO.write("\nexpression: #{pprint(expressionMUL)}\n")
  IO.write("Derivative: #{pprint(mul)}\n")
  IO.write("Simplified: #{pprint(simplify(mul))}\n")

  expressionPOWR = {:add, {:powr, {:var, :x}, {:num, 3}}, {:num, 4}}
  powr = deriv(expressionPOWR, :x)
  IO.write("\nexpression: #{pprint(expressionPOWR)}\n")
  IO.write("Derivative: #{pprint(powr)}\n")
  IO.write("Simplified: #{pprint(simplify(powr))}\n")

  expressionLN = {:ln, {:mul, {:var, :x}, {:num, 2}}}
  ln = deriv(expressionLN, :x)
  IO.write("\nexpression: #{pprint(expressionLN)}\n")
  IO.write("Derivative: #{pprint(ln)}\n")
  IO.write("simplified: #{pprint(simplify(ln))}\n")

  expressionSQRT = {:sqrt, {:mul, {:var, :x}, {:num, 3}}}
  sqrt = deriv(expressionSQRT, :x)
  IO.write("\nexpression: #{pprint(expressionSQRT)}\n")
  IO.write("Derivative: #{pprint(sqrt)}\n")
  IO.write("simplified: #{pprint(simplify(sqrt))}\n")

  expressionCOS = {:cos, {:mul, {:var, :x}, {:num, 6}}}
  cos = deriv(expressionCOS, :x)
  IO.write("\nexpression: #{pprint(expressionCOS)}\n")
  IO.write("Derivative: #{pprint(cos)}\n")
  IO.write("simplified: #{pprint(simplify(cos))}\n")

  expressionSIN = {:sin, {:mul, {:var, :x}, {:num, 3}}}
  sin = deriv(expressionSIN, :x)
  IO.write("\nexpression: #{pprint(expressionSIN)}\n")
  IO.write("Derivative: #{pprint(sin)}\n")
  IO.write("simplified: #{pprint(simplify(sin))}\n")

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
#f(x) = x^n, d(f(x))/dx = nx^(n-1)
def deriv({:powr, expr1, {:num, n}}, x) do {:mul, {:mul, {:num, n}, {:powr, expr1, {:num, n-1}}}, deriv(expr1, x)} end
#f(x) = ln(x), d(f(x))/dx = 1/x
def deriv({:ln, expr1}, x) do {:mul, {:div, {:num, 1}, expr1}, deriv(expr1, x)} end
#f(x) = sqrt(x), d(f(x))/dx = (f'(x))/(2(sqrt(x))
def deriv({:sqrt, expr}, x) do {:mul, deriv(expr, x), {:div, {:num, 1}, {:mul, {:sqrt, expr}, {:num, 2}}}} end
#f(x) = cos(x), d(f(x))/dx = x'*-sin(x)
def deriv({:cos, expr}, x) do {:mul, deriv(expr, x), {:mul, {:sin, expr}, {:num, -1}}} end
#f(x) = sin(x), d(f(x))/dx = x'*cos(x)
def deriv({:sin, expr}, x) do {:mul, deriv(expr, x), {:cos, expr}} end

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

def simplify_sqrt({:num, 0}) do {:num, 0} end
def simplify_sqrt({:num, 1}) do {:num, 1} end
def simplify_sqrt(expr) do {:sqrt, expr} end

def pprint({:num, n}) do "#{n}" end #Prints a number
def pprint({:var, v}) do "#{v}" end #Prints variable
def pprint({:add, expr1, expr2}) do "(#{pprint(expr1)} + #{pprint(expr2)})" end #Prints addition
def pprint({:mul, expr1, expr2}) do "(#{pprint(expr1)} * #{pprint(expr2)})" end #Prints multiplication
def pprint({:powr, expr1, expr2}) do "#{pprint(expr1)} ^(#{pprint(expr2)})" end #Prints exponents
def pprint({:div, expr1, expr2}) do "(#{pprint(expr1)}) / (#{pprint(expr2)})" end #Prints division of two expressions
def pprint({:ln, expr1}) do "ln#{pprint(expr1)}" end #Prints ln(expression)
def pprint({:sqrt, expr}) do "sqrt#{pprint(expr)}" end
def pprint({:cos, expr}) do "cos(#{pprint(expr)}" end
def pprint({:sin, expr}) do ("sin(#{pprint(expr)}") end
end
