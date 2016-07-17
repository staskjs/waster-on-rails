@app.controller 'ProfileCtrl', ($scope, $location, $http, Auth) ->
  $scope.data = {}

  Auth.currentUser().then (user) ->
    $scope.data.dailyHours = user.dailyHours
    $scope.data.daysOff = new Array(7).fill(false)

    if user.daysOff?
      user.daysOff.split(',').forEach (dayOff) ->
        $scope.data.daysOff[dayOff] = true

  $scope.save = ->
    $http
      method: 'PUT'
      url: '/api/users/profile'
      data:
        user:
          dailyHours: $scope.data.dailyHours
          daysOff: formatDaysOff()
    .then (response) ->
      Auth._currentUser = response.data
      if $scope.currentPath is 'profile/ask'
        location.href = '/'

  formatDaysOff = ->
    $scope.data.daysOff.map (dayOff, index) ->
      return null unless dayOff
      index
    .compact().join(',')
