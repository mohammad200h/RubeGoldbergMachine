
    require 'erb'
    require 'matrix'


  def rgb256ToDecimal(rgba)
      r = rgba[0]/256.0
      g = rgba[1]/256.0
      b = rgba[2]/256.0
      #  a stand for opacity 
      a = rgba[3]/256

      return [r,g,b,a]
  end

    def degreeToRadian(degrees)
      radians = degrees * Math::PI / 180 
      return radians
    end
    def a_to_s(v)#converts array to string
      Array(v).join(" ")
    end


    def produceKey(objs=[])
      qpos = []
      qvel  = []
      comment_xml = %{}

      for obj in objs do  
        for joint in obj.joints do 
          obj_comment = "#{obj.name}::#{joint.name}::#{joint.dof}"
          qpos += joint.qpos
          qvel += joint.qvel
          #TODO:: add obj comment to comment_xml 
        end
      end

      return qpos,qvel
    end
  

    class Joint
      attr_accessor :xml,:qvel,:qpos,:name,:dof
      def initialize(jointType="free",name="",axis=nil, pos=nil, euler=nil)
        
        @name = name 
        @dof = 0
        
        if jointType=="free"
          #6DOF 3T3R 
          @dof = 6
          # rotation is in quaternion 
          @qpos = [0]*3 + [0]*4
        elsif jointType=="ball"
          #3DOF 3R
          @dof = 3
          @qpos = [0]*4
        elsif jointType=="slide"
          #1DOF 1T
          @dof = 1
          @qpos = [0]*1
        elsif jointType=="hinge"
          #1DOF 1R
          @dof = 1
          @qpos = [0]*1

        end
        
        
        @qvel = [0]*@dof

        axis_xml  = axis.nil?  ?    nil  :  %{ axis="#{a_to_s(axis)}" }.gsub(/^  /, '')
        pos_xml   = pos.nil?   ?    nil  :  %{pos= "#{a_to_s(pos)}"   }.gsub(/^  /, '')
        euler_xml = euler.nil? ?    nil  :  %{euler="#{a_to_s(euler)}"}.gsub(/^  /, '')

        @xml = %{
          <joint type="#{jointType}" #{axis_xml} #{pos_xml} #{euler_xml}/>
        }.gsub(/^  /, '')


      end
    end

  
    