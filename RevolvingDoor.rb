
    require 'erb'
    require 'matrix'

    def degreeToRadian(degrees)
      radians = degrees * Math::PI / 180 
      return radians
    end
    def a_to_s(v)#converts array to string
      Array(v).join(" ")
    end

    class RevolvingDoor
      attr_accessor :default_xml,:assets_xml,:body_xml
      def initialize(body_pose=[0,0,0,0,0,0],scale=1)
       
        #box
        height = 0.02 * scale
        width = 0.04 * scale
        thickness = 0.001 * scale

        #shaft
        s_radius = 0.005
        s_height = 0.03

        body_pos = body_pose.take(3)
        body_orn = body_pose.drop(3)
        body_pos[2] +=height

        size = [thickness,width,height]

        s_size = [s_radius,s_height]

        @assets_xml = %{
         
                        }.gsub(/^  /, '')
                       
        @default_xml = %{
          <!-- RevolvingDoor -->
          <default class="revolvingDoor">
            <geom   type="box" size="#{a_to_s(size)}"  />
          </default>
        }.gsub(/^  /, '')
        
        @body_xml =%{
          <body pos="#{a_to_s(body_pos)}" euler="#{a_to_s(body_orn)}">
            <joint type="hinge" axis="0 0 1"/>
            <geom class="revolvingDoor" />
            <geom type="cylinder" size="#{a_to_s(s_size)}"/>

          </body>
        }.gsub(/^  /, '')


      end
    end

  
    