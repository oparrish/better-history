window.apiHost = '$API_HOST$'
window.siteHost = '$SITE_HOST$'
window.env = '$ENV$'

window.errorTracker = new BH.Trackers.ErrorTracker(Honeybadger)
window.analyticsTracker = new BH.Trackers.AnalyticsTracker(_gaq)

load = ->
  analyticsTracker.historyOpen()

  window.syncStore = new BH.Lib.SyncStore
    chrome: chrome
    tracker: analyticsTracker

  syncStore.get 'authId', (data = {}) ->
    $('body').addClass 'logged_in' if data.authId?

  new BH.Lib.DateI18n().configure()

  window.tagState = new Backbone.Model
    readOnly: false
    syncing: false

  # crazy fast feedback
  tagState.on 'change:syncing', ->
    if tagState.get('syncing') == true
      $('body').addClass('syncing')
    else
      $('body').removeClass('syncing')

  window.user = new BH.Models.User({})
  window.user.fetch()

  window.user.on 'change', ->
    @trigger('login') if @get('authId')

  window.user.on 'logout', ->
    googleUserInfo = new BH.Lib.GoogleUserInfo()
    googleUserInfo.revoke()

  window.user.on 'login', ->
    syncer = new BH.Lib.Syncer()
    syncer.updateIfNeeded ->
      tagState.trigger('synced')

  window.settings = new BH.Models.Settings({})
  window.state = new BH.Models.State({}, settings: settings)

  window.persistence = new BH.Init.Persistence
    localStore: new BH.Lib.LocalStore
      chrome: chrome
      tracker: analyticsTracker
    syncStore: new BH.Lib.SyncStore
      chrome: chrome
      tracker: analyticsTracker
    ajax: $.ajax
    state: state

  settings.fetch
    success: =>
      state.fetch
        success: =>
          state.updateRoute()

          window.router = new BH.Router
            settings: settings
            state: state
            tracker: analyticsTracker

          Backbone.history.start()

  mailingList = new BH.Init.MailingList(syncStore: syncStore)
  mailingList.prompt ->
    new BH.Views.MailingListView().open()
    analyticsTracker.mailingListPrompt()

  tagFeature = new BH.Init.TagFeature(syncStore: syncStore)
  tagFeature.announce ->
    $('body').addClass('new_tags')

if env == 'prod'
  try
    load()
  catch e
    errorTracker.report e
else
  load()

