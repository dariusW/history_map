namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Dariusz Wolek",
                         email: "dariusz.wolek@gmail.com",
                         password: "apollo00",
                         password_confirmation: "apollo00")
    admin.toggle!(:permissions)
    admin.save
    
    2.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
      
    end
    
    sampleStory = admin.stories.create!(full_title: "Bitwa pod Grunwaldem", content: "Bitwa pod Grunwaldem (w literaturze niemieckiej pierwsza bitwa pod Tannenbergiem) ",
                  name: "HEAD", precision: "HOUR", bottom_boundry: 141007140000, top_boundry: 141007150000,long: 20.095919, lat: 53.487407)
    timeMarker = sampleStory.time_markers.create!(name: "xxx", full_title: "Wojska polskie", color: 'FE7569', content: "Tootsie roll oat cake sweet roll ice cream chupa chups wafer caramels tootsie roll. Dragee biscuit halvah cookie. Cake pastry icing sesame snaps sugar plum.")
    timeMarker2 = sampleStory.time_markers.create!(name: "xxx", full_title: "Wojska krzyzackie", color: 'FE3421', content: "Tiramisu toffee bear claw tart brownie candy canes apple pie sugar plum. Caramels carrot cake marshmallow cupcake. Wypas brownie souffle macaroon jelly-o bear claw powder cheesecake. Liquorice chocolate cake powder halvah danish cake jelly liquorice wypas.")
    
    timeMarker.time_markers_time.create!(name: "xxx", time: 141007140300, longitude: 20.321119, latitude: 53.401407, content: "Biscuit powder sugar plum oat cake chocolate bar cupcake cookie. Candy canes apple pie sesame snaps marshmallow marzipan sweet cake tiramisu brownie. Chocolate bar biscuit sesame snaps chocolate bar. Icing wafer sweet roll icing cheesecake tootsie roll.")
    timeMarker.time_markers_time.create!(name: "xxx", time: 141007141000, longitude: 20.125919, latitude: 53.487407, content: "Gingerbread chocolate cake ice cream tart tiramisu fruitcake. Bonbon tiramisu faworki. Gummi bears bear claw chocolate bar tart pastry jelly-o. Liquorice gummi bears jelly-o pastry pastry.")
    timeMarker.time_markers_time.create!(name: "xxxx", time: 141007141100, longitude: 20.09446, latitude: 53.483347, content: "Lemon drops jelly brownie chupa chups. Donut cheesecake wafer tart bear claw souffle cookie. Cheesecake caramels cookie marzipan.")
    timeMarker.time_markers_time.create!(name: "xxxx", time: 141007150000, longitude: 20.19446, latitude: 53.123312, content: "Sugar plum chocolate danish chocolate cake. Jelly-o carrot cake icing brownie jelly lemon drops candy. Bear claw cookie croissant wafer jujubes.")
    
    timeMarker2.time_markers_time.create!(name: "xxx", time: 141007140100, longitude: 20.084421, latitude: 53.48211, content: "Pudding souffle pastry ice cream. Dragee lemon drops apple pie bonbon sugar plum bonbon ice cream ice cream. Sesame snaps candy icing caramels faworki sugar plum dragee. Applicake tart ice cream tiramisu oat cake halvah caramels.")
    timeMarker2.time_markers_time.create!(name: "xxx", time: 141007141000, longitude: 20.095421, latitude: 53.487111, content: "Sweet marshmallow faworki jelly muffin donut lemon drops cake pie. Gingerbread cheesecake croissant gummi bears croissant dragee cookie. Halvah sweet roll macaroon carrot cake chocolate tart ice cream. Dessert ice cream bear claw danish powder jelly gummies toffee croissant.")
    timeMarker2.time_markers_time.create!(name: "xxxx", time: 141007141200, longitude: 20.02211, latitude: 53.483421, content: "Sugar plum carrot cake croissant halvah pudding sesame snaps apple pie. Chocolate cake chocolate cupcake. Icing ice cream marzipan candy canes caramels jelly-o brownie toffee halvah. Jelly-o sweet roll jujubes carrot cake cookie topping gummi bears.")
    timeMarker2.time_markers_time.create!(name: "xxxx", time: 141007150000, longitude: 20.19211, latitude: 53.123421, content: "Wypas liquorice applicake. Ice cream gummi bears cookie chocolate cake sweet roll. Jelly beans wypas ice cream tiramisu pie pastry cookie jujubes oat cake.")
    
    
  end
end