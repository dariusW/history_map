@TimeUnit = Backbone.Model.extend
  initialize: ()->
    @id = @.get('date')

  toJSON: () ->
    date: @.get('date')
    c: @.get('c')
    minutes: @.get('minutes')
    hours:  @.get('hours')
    days: @.get("days")
    years: @.get("years")
    isLeap: @.get("isLeap")
    decade: @.get("decade")
    age: @.get("age")
    string_date: @.get('string_date')
    
@TimeLine = Backbone.Collection.extend
  model: TimeUnit