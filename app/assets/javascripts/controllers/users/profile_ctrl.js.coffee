@app.controller 'ProfileCtrl', ($scope, $location, $http, Auth) ->
  $scope.data = {}

  Auth.currentUser().then (user) ->
    $scope.data.dailyHours = user.daily_hours

  $scope.save = ->
    $http
      method: 'PUT'
      url: '/api/users/profile'
      data:
        user:
          daily_hours: $scope.data.dailyHours
    .then (response) ->
      Auth._currentUser = response.data
      if $scope.currentPath is 'profile/ask'
        location.href = '/'
