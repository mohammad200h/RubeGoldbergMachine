
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

    class Box
      attr_accessor :default_xml,:assets_xml,:body_xml,:name,:joints
      def initialize(body_pose=[0,0,0,0,0,0],size=0.01,mass=0.1,color=[1,1,1,1])
       
        @name = "box"
        @joints =[]
        

        body_pos = body_pose.take(3)
        body_orn = body_pose.drop(3)
        body_pos[2] += size
       
        b_size = [size,size,size]

        joint = Joint.new(jointType="free")
        joints.push(joint)

        @assets_xml = %{
         
                        }.gsub(/^  /, '')
                       
        @default_xml = %{
          <!-- Box -->
          <default class="Box">
            <geom   type="box"  friction="1" />
          </default>
        }.gsub(/^  /, '')
        
        @body_xml =%{
          <body pos="#{a_to_s(body_pos)}" euler="#{a_to_s(body_orn)}" >
           
            <joint type="free" />
            <geom class="Box" size="#{a_to_s(b_size)}" mass="#{mass}" rgba="#{a_to_s(color)}"/>
          </body>
        }.gsub(/^  /, '')


      end
    end

  
    