Material.delete_all
Material.create!(:title => "Steel", :category => "Metal")
Material.create!(:title => "Copper", :category => "Metal")
Material.create!(:title => "Aluminum", :category => "Metal")
Material.create!(:title => "Concrete", :category => "Ceramic")
Material.create!(:title => "Glass", :category => "Ceramic")
Material.create!(:title => "Clay", :category => "Ceramic")
Material.create!(:title => "Wood", :category => "Wood")
Material.create!(:title => "Acids", :category => "Chemicals")
Material.create!(:title => "Epoxy", :category => "Polymers")

Procedure.delete_all
Procedure.create!(:title => "Rail", :category => "Transportation")
Procedure.create!(:title => "Truck", :category => "Transportation")
Procedure.create!(:title => "Boat", :category => "Transportation") 
Procedure.create!(:title => "Plane", :category => "Transportation") 

Procedure.create!(:title => "Hot Roll", :category => "Manufacturing", :material => "Steel") 
Procedure.create!(:title => "Cold Roll", :category => "Manufacturing", :material => "Steel") 
Procedure.create!(:title => "Tempering", :category => "Manufacturing", :material => "Glass") 

Procedure.create!(:title => "Landfill", :category => "EoL")
Procedure.create!(:title => "Recycle", :category => "EoL")