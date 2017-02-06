###!
# google-analytics-embedded 1.0.5 | https://github.com/yivo/google-analytics-embedded | MIT License
###

initialize = (trackingID) ->
  unless trackingID
    throw new TypeError('[Google Analytics Embedded] Tracking ID is required')

  window.GoogleAnalyticsObject         = 'ga'
  window[window.GoogleAnalyticsObject] = ->
    args = []
    len  = arguments.length
    idx  = -1
    args.push(arguments[idx]) while ++idx < len
    (ga.q ?= []).push(args)

  ga.l = Date.now?() ? +new Date()

  ga('create', trackingID, 'auto')

  pageset  = -> ga('set', 'page', location.href.split('#')[0])
  pageview = -> ga('send', 'pageview')

  # https://developers.google.com/analytics/devguides/collection/analyticsjs/single-page-applications
  if Turbolinks?.supported
    $document = $(document)
    $document.one 'page:change', ->
      $document.on 'page:change', ->
        pageset()
        pageview()

  pageview()

  analyticsJS()

analyticsJS = ->
  try ```
    /* analytics.js */
  ```
  return # Explicit return statement
    
if (head = document.getElementsByTagName('head')[0])?
  for el in head.getElementsByTagName('meta')
    if el.getAttribute('name') is 'ga:tracking_id'
      initialize(trackingID) if trackingID = el.getAttribute('content')
      break
