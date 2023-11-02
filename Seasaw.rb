
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

    class Seasaw
      attr_accessor :default_xml,:assets_xml,:body_xml,:name,:joints 
      def initialize(body_pose=[0,0,0,0,0,0],flat_bed_mass=0.1,color)
        
        @name = "seasaw"
        @joints = []
        body_pos = body_pose.take(3)
        body_orn = body_pose.drop(3)
        
        #shaft
        s_radius = 0.005
        s_height = 0.05
        shaft_pos = [0,0,0.02]
        shaft_size =[s_radius,s_height]

        mounts_pos = [
          [0, 1*s_height,0],
          [0,-1*s_height,0]

        ]
        mount_size = [0.01,0.01,0.03]

        flat_board_pos  = [0,0,0.03]
        flat_board_size = [0.1,0.02,0.005] 
        
        joint = Joint.new(jointType="hinge",name="",axis=[0,1,0],pos=shaft_pos)
        joints.push(joint)

        @assets_xml = %{}.gsub(/^  /, '')
                       
        @default_xml = %{
          <!-- Ball -->
          <default class="seasaw_mount">
            <geom  type="box" size="#{a_to_s(mount_size)}"/>
          </default>
        }.gsub(/^  /, '')


        @mount_body_xml = %{}
        
        mounts_pos.each do |m|
          @mount_body_xml +=%{\n\t\t<geom class="seasaw_mount" pos="#{a_to_s(m)}" rgba="#{a_to_s(color[1])}"/>} 
        end

        
        @swing_body_xml =%{
          <body>
            #{joint.xml}
            <geom type="cylinder" size="#{a_to_s(shaft_size)}" pos="#{a_to_s(shaft_pos)}" euler="90 0 0" rgba="#{a_to_s(color[0])}"/>
            <geom type="box" size="#{a_to_s(flat_board_size)}" pos="#{a_to_s(flat_board_pos)}" friction="1" mass="#{flat_bed_mass}" rgba="#{a_to_s(color[0])}"/>
          </body>
        }.gsub(/^  /, '')

        @mount_body_xml += %{#{@swing_body_xml}}

        @body_xml=%{
          <body name="#{@name}" pos="#{a_to_s(body_pos)}" euler="#{a_to_s(body_orn)}">
            #{@mount_body_xml}
          </body>
        }.gsub(/^  /, '')

      end
    end

  
    