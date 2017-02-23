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

Material.create!(:title => "Landfill", :category => "EoL")
Material.create!(:title => "Recycle", :category => "EoL")

#Material.create!(:title => "Product Use", :material => "Copper", :category => "Use")

Procedure.delete_all
Procedure.create!(:title => "Rail", :material => "Copper", :category => "Transportation")
Procedure.create!(:title => "Truck",:material => "Copper",  :category => "Transportation")
Procedure.create!(:title => "Boat",:material => "Copper",  :category => "Transportation") 
Procedure.create!(:title => "Plane", :material => "Copper", :category => "Transportation") 

Procedure.create!(:title => "Hot Roll", :category => "Manufacturing", :material => "Steel") 
Procedure.create!(:title => "Cold Roll", :category => "Manufacturing", :material => "Steel") 
Procedure.create!(:title => "Tempering", :category => "Manufacturing", :material => "Glass") 

#Procedure.create!(:title => "Landfill",:material => "Copper",  :category => "EoL")
#Procedure.create!(:title => "Recycle", :material => "Copper", :category => "EoL")