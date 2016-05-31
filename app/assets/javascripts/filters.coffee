@app.filter 'weekDay', ->
  (date) ->
    moment(date).format('d')
