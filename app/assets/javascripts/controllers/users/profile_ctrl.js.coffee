@app.controller 'ProfileCtrl', ($scope, $location, $http, Auth) ->
  $scope.data = {}

  Auth.currentUser().then (user) ->
    $scope.data.dailyHours = user.daily_hours
    $scope.data.daysOff = new Array(7).fill(false)

    if user.days_off?
      user.days_off.split(',').forEach (dayOff) ->
        $scope.data.daysOff[dayOff] = true

  $scope.save = ->
    $http
      method: 'PUT'
      url: '/api/users/profile'
      data:
        user:
          daily_hours: $scope.data.dailyHours
          days_off: formatDaysOff()
    .then (response) ->
      Auth._currentUser = response.data
      if $scope.currentPath is 'profile/ask'
        location.href = '/'

  formatDaysOff = ->
    $scope.data.daysOff.map (dayOff, index) ->
      return null unless dayOff
      index
    .compact().join(',')
