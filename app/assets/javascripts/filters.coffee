@app
.filter 'weekDay', ->
  (date) ->
    moment(date).format('d')

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
