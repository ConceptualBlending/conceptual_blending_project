require 'rest-client'
require 'json'
require 'uri'


def execute_request()
  post_params = {action: 'hets', input1: {url: ARGV[0]}.to_json,
input2: {url: ARGV[1]}.to_json}
  response = RestClient::Request.execute({method: :post,url:
"148.251.85.37:8300/cmd/blend",payload: post_params})
    return response
end

x = execute_request()

my_hash = JSON.parse(x)

my_hash.each do |k,v|
  puts k + ':' + v.to_s
end

=begin
success:true
cargo:{
    "svg"=>"http://pollux.informatik.uni-bremen.de:8000/653668491?svg", 
    "blend"=>"spec blend = \nsorts Forces, Int, Object;\nop 0 : Int;\nop anti : Forces -> Forces;\nop centrifugal : Forces;\nop distance : Object * Object -> Int;\nop force : Forces * Object * Object -> Int;\nop gn_distance8 : Object * Object -> Int;\nop gn_pre12 : Int -> Int;\nop gravitation : Forces;\nop mass : Object -> Int;\nop planet : Object;\nop pre : Int -> Int;\nop suc : Int -> Int;\nop sun : Object;\npred __<__ : Int * Int;\npred __<=__ : Int * Int;\npred __>__ : Int * Int;\npred revolve : Object * Object;\n. 0 <= 0 %(Ax1)%;\nforall x : Int . 0 <= x => 0 <= suc(x) %(Ax2)%;\nforall x, y : Int . suc(x) <= y => x <= pre(y) %(Ax3)%;\nforall x, y : Int . pre(x) <= y => x <= suc(y) %(Ax4)%;\nforall x, y : Int . x < y <=> x <= y %(Ax5)%;\nforall x, y : Int . x < y <=> y > x %(Ax6)%;\n. mass(sun) > mass(planet) %(Ax7)%;\n. distance(sun, planet) > 0 %(Ax8)%;\n. anti(gravitation) = centrifugal %(Ax10)%;\nforall x, y : Object; f : Forces;\n. distance(x, y) > 0 /\\ force(f, y, x) > 0;\n     => force(anti(f), x, y) < 0                                               %(Ax11)%;\nforall x, y : Object;\n. force(centrifugal, x, y) < 0 /\\ mass(y) > mass(x);\n     => revolve(x, y)                                                                           %(Ax12)%;\n. not 0 <= gn_pre12(0) %(Ax2_17)%;\nforall x : Int . not 0 <= x => not 0 <= gn_pre12(x);\n                                                                                                                 %(Ax4_19)%;\nforall x, y : Int . suc(x) <= y <=> x <= gn_pre12(y);\n                                                                                                                 %(Ax5_20)%;\nforall x, y : Int . gn_pre12(x) <= y <=> x <= suc(y);\n                                                                                                                 %(Ax6_21)%;\nforall x, y : Int . x < y <=> x <= y /\\ not x = y;\n                                                                                                                 %(Ax7_22)%;\n. gn_distance8(planet, sun) > 0 %(Ax10_15)%;\n. force(gravitation, planet, sun) > 0 %(Ax11_16)%;\nforall G_G2589253 : Int;\n. 0 <= G_G2589253 => 0 <= suc(G_G2589253)             %(Ax2_13)%;\nend", 

    "theoryurl"=>"http://pollux.informatik.uni-bremen.de:8000/653668491?pp.het",

    "theory"=>"library hetsfile14592\n\n
 
               spec Solar =\n     sort  Int\n     op    0 : Int\n     op    suc : Int -> Int\n     op    pre : Int -> Int\n     pred  __<=__ : Int * Int\n     forall x, y : Int\n     . 0 <= 0\n     . 0 <= x => 0 <= suc(x)\n     . suc(x) <= y => x <= pre(y)\n     . pre(x) <= y => x <= suc(y)\n     pred  __<__ : Int * Int\n     forall x, y : Int . x < y <=> x <= y\n     pred  __>__ : Int * Int\n     forall x, y : Int . x < y <=> y > x\n     sorts Object, Forces\n     ops   sun, planet : Object\n     ops   gravitation, centrifugal : Forces\n     op    mass : Object -> Int\n     op    distance : Object * Object -> Int\n     op    force : Forces * Object * Object -> Int\n     op    anti : Forces -> Forces\n     pred  revolve : Object * Object\n     . mass(sun) > mass(planet)\n     . distance(sun, planet) > 0\n     . force(gravitation, planet, sun) > 0\n     . anti(gravitation) = centrifugal\n     forall x, y : Object; f : Forces\n     . distance(x, y) > 0 /\\ force(f, y, x) > 0\n       => force(anti(f), x, y) < 0\n     forall x, y : Object\n     . force(centrifugal, x, y) < 0 /\\ mass(y) > mass(x)\n       => revolve(x, y)\nend\n\n
               
              spec Atom =\n     sort  Int\n     op    0 : Int\n     op    suc : Int -> Int\n     op    pre : Int -> Int\n     pred  __<=__ : Int * Int\n     forall x, y : Int\n     . 0 <= 0\n     . not 0 <= pre(0)\n     . 0 <= x => 0 <= suc(x)\n     . not 0 <= x => not 0 <= pre(x)\n     . suc(x) <= y <=> x <= pre(y)\n     . pre(x) <= y <=> x <= suc(y)\n     pred  __<__ : Int * Int\n     forall x, y : Int . x < y <=> x <= y /\\ not x = y\n     pred  __>__ : Int * Int\n     forall x, y : Int . x < y <=> y > x\n     sorts Object, Forces\n     ops   electron, nucleus : Object\n     op    coulomb : Forces\n     op    mass : Object -> Int\n     op    distance : Object * Object -> Int\n     op    force : Forces * Object * Object -> Int\n     . mass(nucleus) > mass(electron)\n     . distance(electron, nucleus) > 0\n     . force(coulomb, electron, nucleus) > 0\nend\n\n

              spec Generalisation0 =\n     sort  Int\n     op    0 : Int\n     pred  <= : Int * Int\n     pred  < : Int * Int\n     pred  > : Int * Int\n     sort  Forces\n     sort  Object\n     op    force : Forces * Object * Object -> Int\n     op    G_G2587382 : Forces\n     op    mass : Object -> Int\n     op    G_G2587595 : Object\n     op    suc : Int -> Int\n     op    G_G2587746 : Object\n     . <=(0, 0)\n     forall G_G2589253 : Int\n     . <=(0, G_G2589253) => <=(0, suc(G_G2589253))\n     forall G_G2588293 : Int; G_G2588202 : Int\nend\n\n\n

              %Generalisation0 mapping Solar to Atom Cost = 146\n
              view mapping0_1 :\n     Generalisation0 to Solar =\n     0 |-> 0, <= |-> __<=__, < |-> __<__, > |-> __>__, force |-> force,\n     G_G2587382 |-> gravitation, mass |-> mass, G_G2587595 |-> planet,\n     suc |-> suc, G_G2587746 |-> sun\nend\n\n
              view mapping0_2 :\n     Generalisation0 to Atom =\n     0 |-> 0, <= |-> __<=__, < |-> __<__, > |-> __>__, force |-> force,\n     G_G2587382 |-> coulomb, mass |-> mass, G_G2587595 |-> electron,\n     suc |-> suc, G_G2587746 |-> nucleus\nend\n\n
              spec blend =\n     combine mapping0_1, mapping0_2\nend\n"}

=end
