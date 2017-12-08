###global Handlebars:false, I18n:false###

'use strict'

Handlebars.registerHelper 'toLowerCase', (string) ->
  return '' unless string
  new Handlebars.SafeString string.toLowerCase()

Handlebars.registerHelper 'translate', (key) ->
  new Handlebars.SafeString I18n.t(key)

Handlebars.registerHelper 'localize', (scope, key) ->
  new Handlebars.SafeString I18n.l(scope, key)

Handlebars.registerHelper "ifCond", (v1, v2, options) ->
  return options.fn(this)  if v1 is v2
  options.inverse this
 
Handlebars.registerHelper "unlessCond", (v1, v2, options) ->
  return options.fn(this)  if v1 != v2
  options.inverse this
  
Handlebars.registerHelper "times", (n, block) ->
  (block.fn(i) for i in [0...n]).join("")

Handlebars.registerHelper "compare", (lvalue, rvalue, options) ->
  throw new Error("Handlerbars Helper 'compare' needs 2 parameters")  if arguments_.length < 3
  operator = options.hash.operator or "=="
  operators =
    "==": (l, r) ->
      l is r

    "===": (l, r) ->
      l is r

    "!=": (l, r) ->
      l isnt r

    "<": (l, r) ->
      l < r

    ">": (l, r) ->
      l > r

    "<=": (l, r) ->
      l <= r

    ">=": (l, r) ->
      l >= r

    typeof: (l, r) ->
      typeof l is r

  throw new Error("Handlerbars Helper 'compare' doesn't know the operator " + operator)  unless operators[operator]
  result = operators[operator](lvalue, rvalue)
  if result
    options.fn this
  else
    options.inverse this

