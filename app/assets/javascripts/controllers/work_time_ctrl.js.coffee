@app.controller 'WorkTimeCtrl', ($scope, $location, WorkTime) ->
  date = $location.search().date ? null
  date = if date? then moment(date) else moment()

  last = $location.search().last ? 1
  timeFrame = $location.search().time_frame ? 'week'

  unless timeFrame in ['week', 'month']
    timeFrame = 'week'

  load = ->
    WorkTime.get(date: date.format('YYYY-MM-DD'), last: last, time_frame: timeFrame).then (data) ->
      $scope.data = data

  $scope.check = ->
    WorkTime.check().then(load)

  $scope.updateInterval = (interval) ->
    WorkTime.updateInterval(interval).then(load)

  $scope.back = ->
    date = date.clone().subtract(1, timeFrame)
    load()

  $scope.forward = ->
    date = date.clone().add(1, timeFrame)
    load()

  load()
