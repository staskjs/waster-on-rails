@app.directive 'activeMenu', ($rootScope) ->
  restrict: 'A'
  link: (scope, element, attrs) ->
    setActive = (currentPath) ->
      if attrs.activeMenu is currentPath
        element.addClass('active')
      else
        element.removeClass('active')

    scope.$on 'currentPathChange', (e, previousPath, currentPath) ->
      setActive(currentPath)

    setActive($rootScope.currentPath)
