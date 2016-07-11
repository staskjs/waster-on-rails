@app.directive 'includeReplace', ->
  require: 'ngInclude'
  restrict: 'A'
  link: (scope, element, attrs) ->
    element.replaceWith(element.children())
