class StoryModule
  constructor: () ->
    new StoryListView()
    new StoryOpenedView()
    new StoryListEditPanelView()

@StoryModule = StoryModule