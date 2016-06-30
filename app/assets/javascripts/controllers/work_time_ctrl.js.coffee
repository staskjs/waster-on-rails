@app.controller 'WorkTimeCtrl', ($scope, $location, WorkTime) ->
  date = $location.search().date ? null
  last = 1

  load = ->
    WorkTime.get(date: date, last: last).then (data) ->
      $scope.data = data

  $scope.check = ->
    WorkTime.check().then(load)

  $scope.updateInterval = (interval) ->
    WorkTime.updateInterval(interval).then(load)

  load()
