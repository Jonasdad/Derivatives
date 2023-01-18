defmodule Derivative do
#{:add, {:mul, {:num, 2}, {:var, x}}, {:num, 3}}; #2x + 3
#{:add, {{:mul, {:pow, {:var, x}, {:num, 4}}, {:num 2}}}, {:mul, {:num, 5}, {var:, x}}} #2x^4+5x (?)
#{:add, {:mul, {:num, 3}, {var: x}}, {:mul, {:num, 1}, {:var, x}}} #3x+x
#f(x) = C, d(f(x))/dx = 0

@type literal() :: {:num, number()} | {:var, atom()}
@type expr() :: literal() | {:add, expr(), expr()} | {:mul, expr(), expr()} | {:ln, :var} | {:div, expr(), expr()} | {:powr, expr(), expr()}

def test() do
  #expression = {:add, {:mul, {:num, -2}, {:var, :x}}, {:num, 4}}
  #expression2 = {:ln, :x}
  #deriv(expression2, :x)
  expression3 = {:powr, :x, 3}
  deriv(expression3, :x)
  #deriv(expression, :x)

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
def deriv({:powr, expr1, expr2}, x) do {:mul, expr2, {:pow, expr1, {:add, expr2, {:num, -1}}}} end

def pprint({:num, n}) do "#{n}" end
def pprint({:var, v}) do "#{v}" end
def pprint({:add, expr1, expr2}) do "(#{pprint(expr1)} + #{pprint(expr2)})" end
def pprint({:mul, expr1, expr2}) do "(#{pprint(expr1)} * #{pprint(expr2)})" end
#def pprint({:pow, expr1, expr2}) do "(#{pprint(expr1, expr2)} ^ #{pprint()})" end
#def pprint(:ln, x) do "1/x" end

end
