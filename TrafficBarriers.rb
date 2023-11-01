
require 'erb'
require 'matrix'

def degreeToRadian(degrees)
  radians = degrees * Math::PI / 180 
  return radians
end
def a_to_s(v)#converts array to string
  Array(v).join(" ")
end

class TrafficBarriers
  attr_accessor :default_xml,:assets_xml,:body_xml
  def initialize(body_pose=[0,0,0,0,0,0],width,length,tickness)
    body_pos = body_pose.take(3)
    body_orn = body_pose.drop(3)

    walls_size = [width/2,length,tickness]
    floor_size = [width,length,tickness]
    
    walls_pos = [
      [ 1*(width-tickness),0,width/2],
      [-1*(width-tickness),0,width/2]
    ]

    @assets_xml = %{}.gsub(/^  /, '')
    @default_xml = %{
      <!-- TrafficBarriers -->
      <default class="trafficBarriers_wall">
        <geom   type="box" size="#{a_to_s(walls_size)}" euler="0 90 0"   />
      </default>
    }.gsub(/^  /, '')


    @body_xml = %{}.gsub(/^  /, '')

    walls_pos.each do |w|
      @body_xml +=%{\n\t\t<geom class="trafficBarriers_wall"  pos="#{a_to_s(w)}" />} 
    end

    @body_xml =%{
        <!-- TrafficBarriers -->
        <body pos="#{a_to_s(body_pos)}" euler="#{a_to_s(body_orn)}">
          <!-- TrafficBarriers::floor -->
          <geom type="box" size="#{a_to_s(floor_size)}"  pos="0 0 0"/>
          <!-- TrafficBarriers::walls -->
          #{body_xml}
        </body>
                    }.gsub(/^  /, '')
    
  end
end
