Item = (item)->
  @name    = item.name
  @geo     = item.geo
  @id      = item.id
  @picture = item.picture

AppViewModel = (userId, page)->
  self = @

  @updateApp = (page)->
    # when run updating set loading true
    @loading true
    $.getJSON "/user/#{@userId}/feed/#{page}", (data) ->
      # change data
      processData data.items, page, data.lastPage

  # <init>
  @userId  = userId
  @loading = ko.observable true
  @items   = ko.observableArray []
  @pages   = ko.observableArray []
  @updateApp page
  # </init>

  makeItems = (itemsArr) ->
    new Item(obj) for obj in itemsArr

  # create pages depending on current page
  # and last page
  makePages = (page, lastPage)->
    return [] if lastPage == 0
    pages = [1]
    pages.push page-1 if page-1 != 1 and page != 1
    pages.push page   if page != 1 and page != lastPage
    pages.push page+1 if lastPage > page+1
    pages.push lastPage
    pages

  processData = (items, page, lastPage) ->
    page = parseInt page
    self.items makeItems(items)
    self.pages makePages(page, lastPage)
    # add bindings to new created pages
    $('.page').click  ->
      $('.page').unbind "click"
      page = $(this).text()
      setHash page
      self.updateApp page
    # end loading
    self.loading false

  setHash = (page) ->
    hash = location.hash
    # if hash set then replace page
    if hash.match(/page=\d+/)
      location.hash = hash.replace /page=\d+/, "page=#{page}"
    else # if not set then add
      location.hash = hash+"page=#{page}"
  return


$(document).ready ->
  # parse userId from href
  userId = /user\/(\d+)/.exec(location.href)[1]
  # parse page from hash
  match  = /page=(\d+)/.exec(location.hash)
  # if hash is not set then page = 1
  page   = if match != null then match[1] else 1
  ko.applyBindings new AppViewModel(userId, page)




