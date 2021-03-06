class BH.Lib.WeekHistory
  constructor: (date) ->
    date.setHours(0,0,0,0)
    @startTime = date.getTime()

    date = new Date(date.getTime() + (6 * 86400000))
    date.setHours(23,59,59,999)
    @endTime = date.getTime()

    @worker = BH.Modules.Worker.worker
    @history = new BH.Chrome.History()

  fetch: (callback = ->) ->
    options =
      startTime: @startTime
      endTime: @endTime
      text: ''
      maxResults: 5000

    @history.query options, (results) =>
      options =
        options: options
        results: results

      @worker 'rangeSanitizer', options, (sanitizedResults) =>
        @worker 'dayGrouper', visits: sanitizedResults, (history) =>
          callback history

  destroy: (callback = ->) ->
    options =
      startTime: @startTime
      endTime: @endTime

    @history.deleteRange options, =>
      callback()
