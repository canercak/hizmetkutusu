 
 Fabricator(:quote) do 
    user {Fabricate(:user) } 
    providers(count: 3) { Fabricate(:price, variation_id: Fabricate(:variation)._id).workdone.provider } 
    share_on_facebook_timeline {false} 
    customer_address {"Bostanlı Mh., 6352. Sokak No:15, 35480 İzmir, Türkiye"}
    description {"dasdsadasdsad sadadsssssdsadsasdas"}
    location {[27.094637499999976,38.4621336 ] }
    variation_id {[Fabricate(:variation)._id]}
end