@app.service 'WorkTime', class
  constructor: (@$http, @$filter) ->

  get: (params = {}) ->
    @$http
      method: 'GET'
      url: '/api/work_time'
      params: params
    .then (response) =>

      # Remove all days after last checked in day
      # (that is a last non-missing day)
      missings = response.data.days.map('isMissing')

      response.data.days = response.data.days[0..(missings.lastIndexOf(false))]
      response.data.days.forEach (day) =>
        day.editableIntervals = angular.copy(day.intervals).map (interval) =>
          interval.dateIn = moment(interval.timeIn)
          if interval.timeOut
            interval.dateOut = moment(interval.timeOut)

          interval.timeIn = @$filter('time')(interval.timeIn)
          if interval.timeOut
            interval.timeOut = @$filter('time')(interval.timeOut)
          interval

      response.data

  check: (date, timeIn, timeOut) ->
    @$http
      method: 'GET'
      url: '/api/work_time/check'
      params:
        date: date
        timeIn: @_timeToUtc(timeIn)
        timeOut: @_timeToUtc(timeOut)

  updateInterval: (interval) ->
    id = interval.id

    # Get times in utc
    if timeIn = interval.timeIn
      timeIn = @_timeToUtc(timeIn)

    if timeOut = interval.timeOut
      timeOut = @_timeToUtc(timeOut)

    if dateOut = interval.dateOut
      dateOut = interval.dateOut.format('YYYY-MM-DD')

    interval = {id, timeIn, timeOut, dateOut}
    @$http.put('/api/work_time/update', interval: interval)

  _timeToUtc: (time) ->
    if time
      moment(time, 'HH:mm').utc().format('HH:mm')
    else
      null
