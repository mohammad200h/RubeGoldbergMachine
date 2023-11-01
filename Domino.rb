
    require 'erb'
    require 'matrix'
    require_relative "Utility"

    def degreeToRadian(degrees)
      radians = degrees * Math::PI / 180 
      return radians
    end
    def a_to_s(v)#converts array to string
      Array(v).join(" ")
    end

    class Domino
      attr_accessor :default_xml,:assets_xml,:body_xml,:joints,:name
      def initialize(body_pose=[0,0,0,0,0,0],scale=1,scaleFactor=0)

        @name = "domino"
        @joints = []
        body_pose = body_pose.map { |number| number.round(2) }
       
        height = 0.02 * scale
        width = 0.01 * scale
        thickness = 0.001 * scale

        body_pos = body_pose.take(3)
        body_orn = body_pose.drop(3)
        body_pos[2] +=height
        body_pos[2] = body_pos[2].round(2)

        joint = Joint.new(jointType="free")
        joints.push(joint)


        if scaleFactor>0
          body_pose[0]+= thickness
        end

        size = [thickness,width,height]
        size = size.map { |number| number.round(5) }

        @assets_xml = %{
         
                        }.gsub(/^  /, '')
                       
        @default_xml = %{
          <!-- Domino -->
          <default class="domino">
            <geom   type="box"  friction="1" />
          </default>
        }.gsub(/^  /, '')
        
        @body_xml =%{
          <body pos="#{a_to_s(body_pos)}" euler="#{a_to_s(body_orn)}">
         
            #{joint.xml}
            <geom class="domino" size="#{a_to_s(size)}"/>
          </body>
        }.gsub(/^  /, '')


      end
    end

  
    