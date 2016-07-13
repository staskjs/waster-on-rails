@app
.filter 'weekDay', ->
  (date) ->
    moment(date).format('d')

.filter 'shortDate', ($filter) ->
  (date) ->
    return '' unless date?
    month = $filter('translate')("date.month_names.#{moment(date).format('M')}")
    day = moment(date).format('D')
    $filter('translate')('date.work_time', {month: month, day: day})

.filter 'minutesToHuman', ($filter) ->
  (minutes) ->
    return 0 unless minutes?
    minutes = minutes.abs()
    hours = (minutes / 60).floor()
    hoursMinutes = (minutes % 60).floor()
    $filter('translate')('minutes_to_human', {hours: hours, minutes: hoursMinutes})

.filter 'time', ->
  (date) ->
    moment(date).format('HH:mm')
