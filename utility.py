class Dimention:
    def __init__(self):
        self.dim_qpos = 0
        self.dim_qvel = 0

class Utility:
    """
    Notes: qvel has dynamic size
    """

    def __init__(self,model,data):
        self.model = model
        self.data  = data 
        self.jTypeMapping = {
            0:"free",
            1:"ball",
            2:"slide",
            3:"hinge"
        }

    def get_dim_given_jType(self,jType):
        dim = Dimention()
        if self.jTypeMapping[jType]  =="free":
            #6DOF 3T3R 
            dim.dim_qpos = 3+4 
            dim.dim_qvel = 6
        elif self.jTypeMapping[jType]=="ball":
            #3DOF 3R
            dim.dim_qpos = 3
            dim.dim_qvel = 3
        elif self.jTypeMapping[jType]=="slide":
            #1DOF 1T
            dim.dim_qpos = 1
            dim.dim_qvel = 1
        elif self.jTypeMapping[jType]=="hinge":
            #1DOF 1T
            dim.dim_qpos = 1
            dim.dim_qvel = 1  

        return dim 

    def get_jointsId_for_body(self,bodyid):
        body = self.model.body(bodyid)
        joint_address = body.jntadr[0]
        joint_num = body.jntnum[0]
        
        if joint_address == -1: # No joint
            return []
        
        joints_addr = [ joint_address+i for i in range(0,joint_num)]

        return joints_addr

    def get_joints_for_body(self,bodyid):
        body = self.model.body(bodyid)
        joint_address = body.jntadr[0]
        joint_num = body.jntnum[0]

        if joint_address == -1: # No joint
            return []
        
        joints = []
        for i in range(0,joint_num):
            joint_index =  joint_address+i
            j = self.model.jnt(joint_index)
            joints.append(j)

        return joints  
         
    def get_qvel_for_body(self,bodyid):
        #Note :qvel is dynamic
        body_joints = self.get_joints_for_body(bodyid)
        # model.h -> int*      jnt_dofadr;           // start addr in 'qvel' for joint's data    (njnt x 1) 
        qvel_addr_list   =  [j.dofadr[0] for j in body_joints] 
        joints_type_list =  [j.type[0]  for j in body_joints] 
        # print("Utility::get_qvel_for_body::self.data.qvel::type ",type(self.data.qvel))
        # print("Utility::get_qvel_for_body::self.data.qvel::shape ",self.data.qvel.shape)
        # print("Utility::get_qvel_for_body::self.data.qvel ",self.data.qvel)
        stacked_qvel = []
        for addr,jType in zip(qvel_addr_list,joints_type_list):
            # print("Utility::get_qvel_for_body::addr:: ",addr)
            # print("Utility::get_qvel_for_body::jType:: ",jType)
            joint_qvel_dim = self.get_dim_given_jType(jType).dim_qvel
            # print("Utility::get_qvel_for_body::joint_qvel_dim:: ",joint_qvel_dim)
            # print("Utility::get_qvel_for_body::joint_qvel_dim:: ",joint_qvel_dim)
            # print("Utility::get_qvel_for_body::addr+joint_qvel_dim:: ",addr+joint_qvel_dim)
            joint_qvel = self.data.qvel[addr:addr+joint_qvel_dim] 
            stacked_qvel.append(joint_qvel)

        return stacked_qvel

   

    



     
            
