@app.directive 'activeMenu', ($rootScope) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    scope.$on 'currentPathChange', (e, previousPath, currentPath) ->
      if attrs.activeMenu is currentPath
        element.addClass('active')
      else
        element.removeClass('active')
