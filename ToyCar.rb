
    require 'erb'
    require 'matrix'

    def degreeToRadian(degrees)
      radians = degrees * Math::PI / 180 
      return radians
    end
    def a_to_s(v)#converts array to string
      Array(v).join(" ")
    end

    class ToyCar
      attr_accessor :default_xml,:assets_xml,:body_xml
      def initialize(body_pose=[0,0,0,0,0,0])
        body_pos = body_pose.take(3)
        body_orn = body_pose.drop(3)
        
        width = 0.008
        thickness = 0.005
        
        
        top_box_length = 0.01
        bot_box_length = 0.02
        
        top_box    = [width,top_box_length,thickness]
        bottom_box = [width,bot_box_length,thickness]

        # cylinder 
        s_radius = 0.005
        s_height = 0.001
        s_size = [s_radius,s_height]
        
        body_pos[2]+=thickness+s_radius
        top_box_pos = [0,0,thickness*2]
        # wheels positions
        wheels_pos = [
          [-1*(width+s_height),-1*(bot_box_length/2),-1*s_radius/2],
          [1 *(width+s_height),-1*(bot_box_length/2),-1*s_radius/2],
          [-1*(width+s_height), 1*(bot_box_length/2),-1*s_radius/2],
          [1 *(width+s_height), 1*(bot_box_length/2),-1*s_radius/2]
        ] 
  
        
        @assets_xml = %{}.gsub(/^  /, '')
                       
        @default_xml = %{
          <!-- ToyCar -->
          <default class="ToyCar_wheel">
            <geom   type="cylinder" size="#{a_to_s(s_size)}" euler="0 90 0"/>
            <joint  axis="0 1 0" />
          </default>
        }.gsub(/^  /, '')
        

        @body_xml =%{}

        wheels_pos.each do |w|
          @body_xml +=%{\n
          <body>
            <joint class="ToyCar_wheel" />
            <geom class="ToyCar_wheel"  pos="#{a_to_s(w)}"/>
          </body>
        } 
        end

        @body_xml =%{
          <body pos="#{a_to_s(body_pos)}" euler="#{a_to_s(body_orn)}">
            <geom   type="box" size="#{a_to_s(top_box)}" pos="#{a_to_s(top_box_pos)}" />
            <geom   type="box" size="#{a_to_s(bottom_box)}" />
            #{body_xml}
          </body>
        }
     
    
        




        
        
  
                  

        


      end
    end

  
    