
    require 'erb'
    require 'matrix'

    def degreeToRadian(degrees)
      radians = degrees * Math::PI / 180 
      return radians
    end
    def a_to_s(v)#converts array to string
      Array(v).join(" ")
    end

    class GoalPost
      attr_accessor :default_xml,:assets_xml,:body_xml
      def initialize(body_pose=[0,0,0,0,0,0],scale=1)
       
        body_pos = body_pose.take(3)
        body_orn = body_pose.drop(3)
        
        #shaft
        s_radius = 0.005
        h_height = 0.02
        v_height = 0.05
        h_offset=0.15

        

        h_size = [s_radius,v_height]
        v_size = [s_radius,v_height]

        offset_size = [s_radius,h_offset/2]

        offset_pos = [
          [2*h_height,h_offset/2+4*s_radius,v_height*2],
          [-2*h_height,h_offset/2+4*s_radius,0],
          [-2*h_height,h_offset/2+4*s_radius,v_height*2]
        ]

        

    

        @assets_xml = %{}.gsub(/^  /, '')
                       
        @default_xml = %{
          <!-- GoalPost -->
          <default class="goalPost">
            <geom   type="cylinder"   />
          </default>
        }.gsub(/^  /, '')
        
        @body_xml =%{}.gsub(/^  /, '')

        for i in 0..1 do
          
          square_top_bot = [
            [0,i*h_offset+h_height,0],
            [0,i*h_offset+h_height,0.1]
          ]
          square_left_right = [
             [ 1* h_height*2,i*h_offset+(v_height/2-s_radius),v_height],
             [ -1*h_height*2,i*h_offset+(v_height/2-s_radius),v_height]
          ]


          square_left_right.each do |w|
            @body_xml +=%{\n
            <geom class="goalPost" pos="#{a_to_s(w)}" 
                  size="#{a_to_s(h_size)}" euler="0 0 0"/>
          } 
          end

          square_top_bot.each do |h|
            @body_xml +=%{\n
            <geom class="goalPost" pos="#{a_to_s(h)}" 
                  size="#{a_to_s(h_size)}" euler="0 90 0"/>
          } 
          end
        end

        offset_pos.each do |o|
          @body_xml +=%{\n
          <geom class="goalPost" pos="#{a_to_s(o)}" 
                size="#{a_to_s(offset_size)}" euler="90 0 0"/>
        } 
        end

        @body_xml =%{
          <body pos="#{a_to_s(body_pos)}" euler="#{a_to_s(body_orn)}">
            #{body_xml}
          </body>
        }



      end
    end



  
    