@app.controller 'WorkTimeCtrl', ($scope, $location, WorkTime) ->
  date = $location.search().date ? null
  date = if date? then moment(date) else moment()

  last = $location.search().last ? 1
  timeFrame = $location.search().time_frame ? 'week'

  unless timeFrame in ['week', 'month']
    timeFrame = 'week'

  load = ->
    formattedDate = date.format('YYYY-MM-DD')
    WorkTime.get(date: formattedDate, last: last, time_frame: timeFrame).then (data) ->
      $scope.data = data
      $location.search(date: formattedDate, last: last, time_frame: timeFrame)

  $scope.check = ->
    WorkTime.check(date).then(load)

  $scope.checkMissing = (day) ->
    day.editableIntervals.push(time_in: '', time_out: '')

  $scope.updateInterval = (interval, date) ->
    if interval.id?
      WorkTime.updateInterval(interval).then(load)
    else
      WorkTime.check(date, interval.time_in, interval.time_out).then(load)

  $scope.back = ->
    date = date.clone().subtract(1, timeFrame)
    load()

  $scope.forward = ->
    date = date.clone().add(1, timeFrame)
    load()

  $scope.selectPrevDate = (interval, prevDate) ->
    interval.dateOut = prevDate
    $scope.updateInterval(interval)

  load()
