
    require 'erb'
    require 'matrix'

    def degreeToRadian(degrees)
      radians = degrees * Math::PI / 180 
      return radians
    end
    def a_to_s(v)#converts array to string
      Array(v).join(" ")
    end

    class Ball
      attr_accessor :default_xml,:assets_xml,:body_xml,:joints,:name
      def initialize(body_pose=[0,0,0,0,0,0],radius=0.005)
       
        @name = "ball"
        @joints = []

        body_pos = body_pose.take(3)
        body_orn = body_pose.drop(3)
        body_pos[2] += radius
        
        joint = Joint.new(jointType="free")
        joints.push(joint)

        @assets_xml = %{
         
                        }.gsub(/^  /, '')
                       
        @default_xml = %{
          <!-- Ball -->
          <default class="ball">
            <geom   type="sphere"   />
          </default>
        }.gsub(/^  /, '')
        
        @body_xml =%{
          <body pos="#{a_to_s(body_pos)}" euler="#{a_to_s(body_orn)}">
            <joint type="free" />
            <geom class="ball" size="#{radius}"/>
          </body>
        }.gsub(/^  /, '')


      end
    end

  
    