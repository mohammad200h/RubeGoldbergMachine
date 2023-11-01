
    require 'erb'
    require 'matrix'
    require_relative "Domino"

    def degreeToRadian(degrees)
      radians = degrees * Math::PI / 180 
      return radians
    end
    def a_to_s(v)#converts array to string
      Array(v).join(" ")
    end

    
    def getAngleOfRotationAroudZCircle(center,position)

      slopeOfCircle = (position[0]-center[0])/(position[1]-center[1])
    
      angle_in_radians = Math.atan(slopeOfCircle)

      angle_in_degrees = angle_in_radians * 180 / Math::PI

      return angle_in_degrees
    
    end
    
    def getPositionOnSin(total_length = 0.5,amplitude = 0.02 ,number_of_objects = 5)
    
      # Calculate the equal distance along the sine wave
      equal_distance = total_length / (number_of_objects - 1)

      # Create an array to store the positions of the objects as [x, y] pairs
      object_positions = []

      # Place the objects along the sine wave
      (0..number_of_objects - 1).each do |i|
        # Calculate the x-coordinate based on the equal distance
        x = (i.to_f / (number_of_objects - 1)) * total_length

        # Calculate the y-coordinate based on the sine wave
        y = amplitude * Math.sin(2 * Math::PI * x / total_length)

        # Store the position as [x, y] and rotation around z axis
        object_positions.push([x, y,0])
      end

        return object_positions
    end


    def getPositionsOnLine(total_length=0.5, number_of_objects = 5)
      equal_distance = total_length.to_f / (number_of_objects - 1)

      # Create an array to store the positions of the objects
      object_positions = []

      # Start with the first object at the beginning
      object_positions.push(0)

      # Place the remaining objects at equal distances
      1.upto(number_of_objects - 1) do |i|
        position = equal_distance * i
        object_positions.push([position,0,0])
      end

      return object_positions

    end




    def getPoseCircle(center=[0,0],radius=0.05,number_of_objects = 8)
   
      center_x = center[0]  # X-coordinate of the circle's center
      center_y = center[1]  # Y-coordinate of the circle's center

      # Calculate the angle between each object
      angle_increment = (2 * Math::PI) / number_of_objects

      # Create an array to store the positions of the objects as [x, y] pairs
      object_positions = []


      # Place the objects around the circle
      (0..number_of_objects - 1).each do |i|
        # Calculate the angle for the current object
        angle = i * angle_increment

        # Calculate the x and y coordinates based on the angle and radius
        x = center_x + radius * Math.cos(angle)
        y = center_y + radius * Math.sin(angle)

        rz = getAngleOfRotationAroudZCircle(center,[x,y])
    

        # Store the position as [x, y]
        object_positions.push([x, y,rz])
       

      end

      return object_positions


    end


    class Dominos
      attr_accessor :default_xml,:assets_xml,:body_xml,:children
      def initialize(body_pose=[0,0,0,0,0,0],scale=1,scaleFactor=0,dominos_pose)
       
        #dummy domino
        dummy_domino = Domino.new()
        @children =[]
       
        @assets_xml = %{
         
                        }.gsub(/^  /, '')
                       
        @default_xml = dummy_domino.default_xml
        
        @body_xml =%{}
        
        current_scale = scale
        dominos_pose.each do |d|
          # puts d 
          # puts "\n"
          domino_pose    = [0,0,body_pose[2],0,0,0]
          domino_pose[0] = d[0] + body_pose[0]
          domino_pose[1] = d[1] + body_pose[1]
          domino_pose[5] = -1*d[2]

          current_scale +=scaleFactor
          domino = Domino.new(domino_pose,current_scale,scaleFactor)
          @body_xml +=%{\n\t\t #{domino.body_xml}} 
          @children.push(domino)
        end


      end
    end

  
    