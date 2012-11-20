namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Dariusz Wolek",
                         email: "dariusz.wolek@gmail.com",
                         password: "apollo00",
                         password_confirmation: "apollo00")
    admin.toggle!(:permissions)
    admin.save
    
    sampleStory = admin.stories.create!(full_title: "Bitwa pod Grunwaldem", content: "Bitwa pod Grunwaldem (w literaturze niemieckiej pierwsza bitwa pod Tannenbergiem) ",
                  name: "HEAD", precision: "HOUR", bottom_boundry: 141007140000, top_boundry: 141007150000,long: 20.095919, lat: 53.487407)
    timeMarker = sampleStory.time_markers.create!(singleton: true, name: "xxx", full_title: "Wojska polskie", color: 'FE7569', content: "Tootsie roll oat cake sweet roll ice cream chupa chups wafer caramels tootsie roll. Dragee biscuit halvah cookie. Cake pastry icing sesame snaps sugar plum.")
    timeMarker2 = sampleStory.time_markers.create!(singleton: true, name: "xxx", full_title: "Wojska krzyzackie", color: 'FE3421', content: "Tiramisu toffee bear claw tart brownie candy canes apple pie sugar plum. Caramels carrot cake marshmallow cupcake. Wypas brownie souffle macaroon jelly-o bear claw powder cheesecake. Liquorice chocolate cake powder halvah danish cake jelly liquorice wypas.")
    
    x1 = timeMarker.time_markers_time.create!(name: "xxx", time: 141007140300, content: "Biscuit powder sugar plum oat cake chocolate bar cupcake cookie. Candy canes apple pie sesame snaps marshmallow marzipan sweet cake tiramisu brownie. Chocolate bar biscuit sesame snaps chocolate bar. Icing wafer sweet roll icing cheesecake tootsie roll.")
    x1.time_markers_position.create!(lng: 20.321119, lat: 53.401407)
    x2 = timeMarker.time_markers_time.create!(name: "xxx", time: 141007141000, content: "Gingerbread chocolate cake ice cream tart tiramisu fruitcake. Bonbon tiramisu faworki. Gummi bears bear claw chocolate bar tart pastry jelly-o. Liquorice gummi bears jelly-o pastry pastry.")
    x2.time_markers_position.create!(lng: 20.125919, lat:  53.487407)
    x3 = timeMarker.time_markers_time.create!(name: "xxxx", time: 141007141100,content: "Lemon drops jelly brownie chupa chups. Donut cheesecake wafer tart bear claw souffle cookie. Cheesecake caramels cookie marzipan.")
    x3.time_markers_position.create!(lng: 20.09446, lat: 53.483347)
    x4 = timeMarker.time_markers_time.create!(name: "xxxx", time: 141007150000, content: "Sugar plum chocolate danish chocolate cake. Jelly-o carrot cake icing brownie jelly lemon drops candy. Bear claw cookie croissant wafer jujubes.")
    x4.time_markers_position.create!(lng: 20.19446, lat: 53.423312)
    
    z1 = timeMarker2.time_markers_time.create!(name: "xxx", time: 141007140100, content: "Pudding souffle pastry ice cream. Dragee lemon drops apple pie bonbon sugar plum bonbon ice cream ice cream. Sesame snaps candy icing caramels faworki sugar plum dragee. Applicake tart ice cream tiramisu oat cake halvah caramels.")
    z1.time_markers_position.create!(lng: 20.084421, lat: 53.48211)
    z2 = timeMarker2.time_markers_time.create!(name: "xxx", time: 141007141000, content: "Sweet marshmallow faworki jelly muffin donut lemon drops cake pie. Gingerbread cheesecake croissant gummi bears croissant dragee cookie. Halvah sweet roll macaroon carrot cake chocolate tart ice cream. Dessert ice cream bear claw danish powder jelly gummies toffee croissant.")
    z2.time_markers_position.create!(lng: 20.095421, lat: 53.487111)
    z3 = timeMarker2.time_markers_time.create!(name: "xxxx", time: 141007141200, content: "Sugar plum carrot cake croissant halvah pudding sesame snaps apple pie. Chocolate cake chocolate cupcake. Icing ice cream marzipan candy canes caramels jelly-o brownie toffee halvah. Jelly-o sweet roll jujubes carrot cake cookie topping gummi bears.")
    z3.time_markers_position.create!(lng: 20.02211, lat: 53.483421)
    z4 = timeMarker2.time_markers_time.create!(name: "xxxx", time: 141007150000, content: "Wypas liquorice applicake. Ice cream gummi bears cookie chocolate cake sweet roll. Jelly beans wypas ice cream tiramisu pie pastry cookie jujubes oat cake.")
    z4.time_markers_position.create!(lng: 20.19211, lat: 53.323421)
    
    line = sampleStory.time_markers.create!(full_title: "Granica", linear: true, color: "33dd33", content: "Tiramisu toffee bear claw tart brownie candy canes apple pie sugar plum. Caramels carrot cake marshmallow cupcake. Wypas brownie souffle macaroon jelly-o bear claw powder cheesecake. Liquorice chocolate cake powder halvah danish cake jelly liquorice wypas.")
    t1 = line.time_markers_time.create!(time: 141007140600, content: "Sugar plum carrot cake croissant halvah pudding sesame snaps apple pie. Chocolate cake chocolate cupcake. Icing ice cream marzipan candy canes caramels jelly-o brownie toffee halvah. Jelly-o sweet roll jujubes carrot cake cookie topping gummi bears.")
    t1.time_markers_position.create!(lng:21.2, lat: 53.48)
    t1.time_markers_position.create!(lng:20.1, lat: 52.48)
    t1 = line.time_markers_time.create!(time: 141007150000, content: "Sugar plum carrot cake croissant halvah pudding sesame snaps apple pie. Chocolate cake chocolate cupcake. Icing ice cream marzipan candy canes caramels jelly-o brownie toffee halvah. Jelly-o sweet roll jujubes carrot cake cookie topping gummi bears.")
    t1.time_markers_position.create!(lng:21.2, lat: 53.48)
    t1.time_markers_position.create!(lng:20.1, lat: 52.48)
    
    line = sampleStory.time_markers.create!(full_title: "pole bitwy", polygon: true, color: "bb2020", content: "Tiramisu toffee bear claw tart brownie candy canes apple pie sugar plum. Caramels carrot cake marshmallow cupcake. Wypas brownie souffle macaroon jelly-o bear claw powder cheesecake. Liquorice chocolate cake powder halvah danish cake jelly liquorice wypas.")
    t1 = line.time_markers_time.create!(time: 141007140200, content: "Sugar plum carrot cake croissant halvah pudding sesame snaps apple pie. Chocolate cake chocolate cupcake. Icing ice cream marzipan candy canes caramels jelly-o brownie toffee halvah. Jelly-o sweet roll jujubes carrot cake cookie topping gummi bears.")
    t1.time_markers_position.create!(lng:20.2, lat: 53.48)
    t1.time_markers_position.create!(lng:20.1, lat: 52.48)
    t1.time_markers_position.create!(lng:21.1, lat: 50.48)
    t1 = line.time_markers_time.create!(time: 141007142000, content: "Sugar plum carrot cake croissant halvah pudding sesame snaps apple pie. Chocolate cake chocolate cupcake. Icing ice cream marzipan candy canes caramels jelly-o brownie toffee halvah. Jelly-o sweet roll jujubes carrot cake cookie topping gummi bears.")
    t1.time_markers_position.create!(lng:20.2, lat: 53.48)
    t1.time_markers_position.create!(lng:20.1, lat: 52.48)
    t1.time_markers_position.create!(lng:21.1, lat: 50.48)
    
    sampleStory.time_stops.create!(time: 141007140000, long: 20.321119, lat: 53.401407, full_title: "Poczatek walki", content: "Macaroon marzipan bonbon bear claw chocolate bar candy canes cookie dragee. Tart applicake chocolate cake dessert jelly beans fruitcake oat cake croissant faworki. Powder souffle pie lemon drops marzipan dragee. Icing powder pie bear claw pie tiramisu. Lemon drops sweet roll chocolate cake sweet roll cookie danish tiramisu tootsie roll tootsie roll. Souffle marzipan chocolate marzipan biscuit lemon drops wypas toffee. Cake brownie tart jujubes. Cotton candy gummies wafer tootsie roll chocolate cake jelly beans cotton candy pudding. Cheesecake wypas tart sesame snaps croissant sesame snaps cheesecake topping wypas. Sesame snaps sesame snaps marshmallow croissant cheesecake sugar plum cake. Cookie tiramisu apple pie chocolate. Chocolate bar dragee oat cake chocolate cake powder pastry sesame snaps.")
    sampleStory.time_stops.create!(time: 141007142000, long: 20.321119, lat: 53.401407, full_title: "Agonia", content: "Macaroon marzipan bonbon bear claw chocolate bar candy canes cookie dragee. Tart applicake chocolate cake dessert jelly beans fruitcake oat cake croissant faworki. Powder souffle pie lemon drops marzipan dragee. Icing powder pie bear claw pie tiramisu. Lemon drops sweet roll chocolate cake sweet roll cookie danish tiramisu tootsie roll tootsie roll. Souffle marzipan chocolate marzipan biscuit lemon drops wypas toffee. Cake brownie tart jujubes. Cotton candy gummies wafer tootsie roll chocolate cake jelly beans cotton candy pudding. Cheesecake wypas tart sesame snaps croissant sesame snaps cheesecake topping wypas. Sesame snaps sesame snaps marshmallow croissant cheesecake sugar plum cake. Cookie tiramisu apple pie chocolate. Chocolate bar dragee oat cake chocolate cake powder pastry sesame snaps.")
    
  end
end