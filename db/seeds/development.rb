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
Procedure.create!(:title => "Rail", :material => "Copper", :category => "Transportation")
Procedure.create!(:title => "Truck",:material => "Copper",  :category => "Transportation")
Procedure.create!(:title => "Boat",:material => "Copper",  :category => "Transportation") 
Procedure.create!(:title => "Plane", :material => "Copper", :category => "Transportation") 

Procedure.create!(:title => "Hot Roll", :category => "Manufacturing", :material => "Steel") 
Procedure.create!(:title => "Cold Roll", :category => "Manufacturing", :material => "Steel") 
Procedure.create!(:title => "Tempering", :category => "Manufacturing", :material => "Glass") 

Procedure.create!(:title => "Product Use",:material => "Copper",  :category => "Use")

Procedure.create!(:title => "Landfill",:material => "Copper",  :category => "EoL")
Procedure.create!(:title => "Recycle", :material => "Copper", :category => "EoL")



# NEW STRUCTURED SEED DATA STARTS HERE
Category.delete_all
Category.create!(:name=>"Material")
Category.create!(:name=>"Process")
Category.create!(:name=>"Transport")
Category.create!(:name=>"Use")
Category.create!(:name=>"End of Life")

# Material activities
Activity.delete_all
Activity.create!(:name=>"chemicals", :parent_type=>"Category", :parent_id=>1)
Activity.create!(:name=>"metals", :parent_type=>"Category", :parent_id=>1)
Activity.create!(:name=>"natural materials", :parent_type=>"Category", :parent_id=>1)

Activity.create!(:name=>"acids", :parent_type=>"Activity", :parent_id=>1)
Activity.create!(:name=>"acetic acid production, product in 98% solution state", :units=>"kg", :parent_type=>"Activity", :parent_id=>4)
Activity.create!(:name=>"acrylic acid production", :units=>"kg", :parent_type=>"Activity", :parent_id=>4)
Activity.create!(:name=>"formic acid production, methyl formate route", :units=>"kg", :parent_type=>"Activity", :parent_id=>4)

Activity.create!(:name=>"coatings, finishings", :parent_type=>"Activity", :parent_id=>1)
Activity.create!(:name=>"acrylic varnish production, product in 87.5% solution state", :units=>"kg", :parent_type=>"Activity", :parent_id=>8)
Activity.create!(:name=>"polyurethane production, flexible foam", :units=>"kg", :parent_type=>"Activity", :parent_id=>8)
Activity.create!(:name=>"polyurethane production, rigid foam", :units=>"kg", :parent_type=>"Activity", :parent_id=>8)

Activity.create!(:name=>"non-ferrous", :parent_type=>"Activity", :parent_id=>2)
Activity.create!(:name=>"aluminium", :parent_type=>"Activity", :parent_id=>12)
Activity.create!(:name=>"aluminium alloy production, AlMg3", :units=>"kg", :parent_type=>"Activity", :parent_id=>13)
Activity.create!(:name=>"aluminium drilling, conventional", :units=>"kg", :parent_type=>"Activity", :parent_id=>13)
Activity.create!(:name=>"copper", :parent_type=>"Activity", :parent_id=>12)
Activity.create!(:name=>"copper carbonate production", :units=>"kg", :parent_type=>"Activity", :parent_id=>16)
Activity.create!(:name=>"brass drilling, conventional", :units=>"kg", :parent_type=>"Activity", :parent_id=>16)
Activity.create!(:name=>"brass production", :units=>"kg", :parent_type=>"Activity", :parent_id=>16)
Activity.create!(:name=>"brass turning, average, conventional", :units=>"kg", :parent_type=>"Activity", :parent_id=>16)
Activity.create!(:name=>"bronze production", :units=>"kg", :parent_type=>"Activity", :parent_id=>16)
Activity.create!(:name=>"casting, bronze", :units=>"kg", :parent_type=>"Activity", :parent_id=>16)

Activity.create!(:name=>"ferrous", :parent_type=>"Activity", :parent_id=>2)
Activity.create!(:name=>"iron alloy", :parent_type=>"Activity", :parent_id=>23)
Activity.create!(:name=>"cast iron milling, average", :units=>"kg", :parent_type=>"Activity", :parent_id=>24)
Activity.create!(:name=>"cast iron milling, large parts", :units=>"kg", :parent_type=>"Activity", :parent_id=>24)
Activity.create!(:name=>"steel", :parent_type=>"Activity", :parent_id=>23)
Activity.create!(:name=>"steel production, chromium steel 18/8", :units=>"kg", :parent_type=>"Activity", :parent_id=>27)

Activity.create!(:name=>"wood", :parent_type=>"Activity", :parent_id=>3)
Activity.create!(:name=>"door production, inner, glass-wood", :units=>"m2", :parent_type=>"Activity", :parent_id=>29)
Activity.create!(:name=>"fibreboard production, hard, from virgin wood", :units=>"m3", :parent_type=>"Activity", :parent_id=>29)


# Process activities
Activity.create!(:name=>"anodising, aluminium sheet", :units=>"m2", :parent_type=>"Category", :parent_id=>2)
Activity.create!(:name=>"section bar extrusion, aluminium", :units=>"kg", :parent_type=>"Category", :parent_id=>2)
Activity.create!(:name=>"drawing of pipe, steel", :units=>"kg", :parent_type=>"Category", :parent_id=>2)
Activity.create!(:name=>"hot rolling, steel", :units=>"kg", :parent_type=>"Category", :parent_id=>2)
Activity.create!(:name=>"powder coating, steel", :units=>"m2", :parent_type=>"Category", :parent_id=>2)


# Transport activities
Activity.create!(:name=>"market for transport, freight train", :units=>"metric ton*km", :parent_type=>"Category", :parent_id=>3)
Activity.create!(:name=>"market for transport, freight, aircraft", :units=>"metric ton*km", :parent_type=>"Category", :parent_id=>3)
Activity.create!(:name=>"market for transport, freight, light commercial vehicle", :units=>"metric ton*km", :parent_type=>"Category", :parent_id=>3)
Activity.create!(:name=>"market for transport, freight, sea, transoceanic ship", :units=>"metric ton*km", :parent_type=>"Category", :parent_id=>3)


# Use activities
Activity.create!(:name=>"market for water, completely softened, from decarbonised water, at user", :units=>"kg", :parent_type=>"Category", :parent_id=>4)
Activity.create!(:name=>"market for water, deionised, from tap water, at user", :units=>"kg", :parent_type=>"Category", :parent_id=>4)
Activity.create!(:name=>"market for water, ultrapure", :units=>"kg", :parent_type=>"Category", :parent_id=>4)

Activity.create!(:name=>"electricity production, hard coal", :units=>"kWh", :parent_type=>"Category", :parent_id=>4)
Activity.create!(:name=>"electricity production, hydro, pumped storage", :units=>"kWh", :parent_type=>"Category", :parent_id=>4)
Activity.create!(:name=>"electricity production, oil", :units=>"kWh", :parent_type=>"Category", :parent_id=>4)
Activity.create!(:name=>"market for electricity, low voltage", :units=>"kWh", :parent_type=>"Category", :parent_id=>4)


# End of Life activities
Activity.create!(:name=>"market for process-specific burden, sanitary landfill", :units=>"kg", :parent_type=>"Category", :parent_id=>5)
Activity.create!(:name=>"market for process-specific burdens, municipal waste incineration", :units=>"kg", :parent_type=>"Category", :parent_id=>5)
Activity.create!(:name=>"recycling", :units=>"kg", :parent_type=>"Category", :parent_id=>5)


# IMPACTS FOR LEAF NODES
Impact.create(:impact_per_unit=>281.0, :uncertainty_lower=>11.0, :uncertainty_upper=>15.0, :activity_id=>5)
Impact.create(:impact_per_unit=>165.0, :uncertainty_lower=>17.0, :uncertainty_upper=>18.0, :activity_id=>6)
Impact.create(:impact_per_unit=>152.0, :uncertainty_lower=>25.0, :uncertainty_upper=>29.0, :activity_id=>7)
Impact.create(:impact_per_unit=>347.0, :uncertainty_lower=>22.0, :uncertainty_upper=>12.0, :activity_id=>9)
Impact.create(:impact_per_unit=>187.0, :uncertainty_lower=>28.0, :uncertainty_upper=>5.0, :activity_id=>10)
Impact.create(:impact_per_unit=>480.0, :uncertainty_lower=>6.0, :uncertainty_upper=>24.0, :activity_id=>11)
Impact.create(:impact_per_unit=>217.0, :uncertainty_lower=>6.0, :uncertainty_upper=>11.0, :activity_id=>14)
Impact.create(:impact_per_unit=>373.0, :uncertainty_lower=>12.0, :uncertainty_upper=>22.0, :activity_id=>15)
Impact.create(:impact_per_unit=>13.0, :uncertainty_lower=>2.0, :uncertainty_upper=>28.0, :activity_id=>17)
Impact.create(:impact_per_unit=>467.0, :uncertainty_lower=>6.0, :uncertainty_upper=>19.0, :activity_id=>18)
Impact.create(:impact_per_unit=>110.0, :uncertainty_lower=>14.0, :uncertainty_upper=>42.0, :activity_id=>19)
Impact.create(:impact_per_unit=>100.0, :uncertainty_lower=>40.0, :uncertainty_upper=>15.0, :activity_id=>20)
Impact.create(:impact_per_unit=>389.0, :uncertainty_lower=>26.0, :uncertainty_upper=>12.0, :activity_id=>21)				
Impact.create(:impact_per_unit=>218.0, :uncertainty_lower=>31.0, :uncertainty_upper=>27.0, :activity_id=>22)
Impact.create(:impact_per_unit=>462.0, :uncertainty_lower=>11.0, :uncertainty_upper=>48.0, :activity_id=>25)
Impact.create(:impact_per_unit=>162.0, :uncertainty_lower=>18.0, :uncertainty_upper=>42.0, :activity_id=>26)
Impact.create(:impact_per_unit=>481.0, :uncertainty_lower=>35.0, :uncertainty_upper=>44.0, :activity_id=>28)
Impact.create(:impact_per_unit=>221.0, :uncertainty_lower=>34.0, :uncertainty_upper=>10.0, :activity_id=>32)
Impact.create(:impact_per_unit=>20.0, :uncertainty_lower=>12.0, :uncertainty_upper=>8.0, :activity_id=>33)
Impact.create(:impact_per_unit=>366.0, :uncertainty_lower=>33.0, :uncertainty_upper=>40.0, :activity_id=>34)
Impact.create(:impact_per_unit=>70.0, :uncertainty_lower=>38.0, :uncertainty_upper=>35.0, :activity_id=>35)
Impact.create(:impact_per_unit=>231.0, :uncertainty_lower=>49.0, :uncertainty_upper=>12.0, :activity_id=>36)
Impact.create(:impact_per_unit=>169.0, :uncertainty_lower=>34.0, :uncertainty_upper=>22.0, :activity_id=>37)
Impact.create(:impact_per_unit=>454.0, :uncertainty_lower=>4.0, :uncertainty_upper=>42.0, :activity_id=>38)
Impact.create(:impact_per_unit=>324.0, :uncertainty_lower=>17.0, :uncertainty_upper=>28.0, :activity_id=>39)
Impact.create(:impact_per_unit=>135.0, :uncertainty_lower=>20.0, :uncertainty_upper=>28.0, :activity_id=>40)
Impact.create(:impact_per_unit=>256.0, :uncertainty_lower=>35.0, :uncertainty_upper=>12.0, :activity_id=>41)
Impact.create(:impact_per_unit=>366.0, :uncertainty_lower=>50.0, :uncertainty_upper=>46.0, :activity_id=>42)
Impact.create(:impact_per_unit=>236.0, :uncertainty_lower=>10.0, :uncertainty_upper=>7.0, :activity_id=>43)
Impact.create(:impact_per_unit=>402.0, :uncertainty_lower=>18.0, :uncertainty_upper=>48.0, :activity_id=>44)
Impact.create(:impact_per_unit=>112.0, :uncertainty_lower=>31.0, :uncertainty_upper=>46.0, :activity_id=>45)
Impact.create(:impact_per_unit=>231.0, :uncertainty_lower=>42.0, :uncertainty_upper=>11.0, :activity_id=>46)
Impact.create(:impact_per_unit=>400.0, :uncertainty_lower=>27.0, :uncertainty_upper=>39.0, :activity_id=>47)
Impact.create(:impact_per_unit=>138.0, :uncertainty_lower=>17.0, :uncertainty_upper=>3.0, :activity_id=>48)
Impact.create(:impact_per_unit=>159.0, :uncertainty_lower=>48.0, :uncertainty_upper=>18.0, :activity_id=>49)
Impact.create(:impact_per_unit=>61.0, :uncertainty_lower=>44.0, :uncertainty_upper=>30.0, :activity_id=>50)