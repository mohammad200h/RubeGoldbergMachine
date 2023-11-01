
    require 'erb'
    require 'matrix'

    def degreeToRadian(degrees)
      radians = degrees * Math::PI / 180 
      return radians
    end
    def a_to_s(v)#converts array to string
      Array(v).join(" ")
    end

    class Table
      attr_accessor :default_xml,:assets_xml,:body_xml
      def initialize(children=[],body_pose=[0,0,0,0,0,0],leg_hight,leg_thickness,table_w,table_l,table_top_thickness)

        body_pose = body_pose.map { |number| number.round(2) }
        
        body_pos = body_pose.take(3)
        body_orn = body_pose.drop(3)

        leg_size  = [leg_thickness,leg_thickness,leg_hight]
        legs_pos =[
          [-1*(table_l-leg_thickness),-1*(table_w-leg_thickness),leg_hight].map { |number| number.round(2) },
          [1 *(table_l-leg_thickness),-1*(table_w-leg_thickness),leg_hight].map { |number| number.round(2) },
          [-1*(table_l-leg_thickness), 1*(table_w-leg_thickness),leg_hight].map { |number| number.round(2) },
          [1 *(table_l-leg_thickness), 1*(table_w-leg_thickness),leg_hight].map { |number| number.round(2) }
        ]
        table_dim = [table_l,table_w,table_top_thickness]
        table_top_pose = [0, 0 ,leg_hight*2]
        
        @assets_xml = %{
          <!-- wood  -->
          <texture  name="wood" type="2d" file="wood.png"/>
          <material name="wood" texture="wood" specular="0" shininess="0.25"/>
                        }.gsub(/^  /, '')
                       
        @default_xml = %{
          <!-- Table::Leg -->
          <default class="table_leg">
            <geom   type="box" size="#{a_to_s(leg_size)}" material="wood"  />
          </default>
          

                        }.gsub(/^  /, '')
        
        @body_xml =%{}
        children_xml =%{}

        #adding children
         children.each do |child|
          children_xml +=%{
            #{child.body_xml}
          }
        end

        legs_pos.each do |l|
          @body_xml +=%{\n\t\t<geom class="table_leg"  pos="#{a_to_s(l)}"/>} 
        end

        @body_xml =%{
        <body pos="#{a_to_s(body_pos)}" euler="#{a_to_s(body_orn)}">
          #{body_xml}
          \t<!-- Table Top  -->
          \t<geom type="box" pos="#{a_to_s(table_top_pose)}" size="#{a_to_s(table_dim)}" material="wood"  />
          #{children_xml}
        </body>
                    }.gsub(/^  /, '')


       
        




        
        
  
                  

        


      end
    end

  
    