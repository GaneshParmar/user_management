import authService from "../auth";

export class OrganizationUsersTable {
    supabase;
    constructor() {
        this.supabase = authService.supabase;
    }

    async addOrganizationUser({uuid, organization_id, role_id, is_admin}) {
        try{

            // let organization_user = await this.getOrganizationUser(uuid);
            // if(organization_user){

            //     // already exist

            //     return {success: false, error: 'Organization user already exist!', data : organization_user};
            // }

            const { data, error } = await this.supabase
                .from('organization_users')
                .insert([
                    { user_id: uuid, organization_id, role_id, is_admin },
                ])
                .select();

                if(error){
                    console.error(error);
                    return {success: false, data, error};
                }
                console.log("Add organization_user data :: ",data);
                return {success: true, data};
            }catch(e){
                console.log(e)
                console.log("Error in db :: OrganizationUsers :: addOrganizationUser :: ",e.message);
                return {success: false, error : e};
            }
            
            return false;
        
    }

    async getOrganizationUser(uuid) {
        try{
            const { data: user, error } = await this.supabase
                .from('organization_users')
                .select('*,organization:organizations(*),role:roles(name),user:users(*)')
                .eq('user_id', uuid);

                if(error){
                    return {success : false, data : null, error: error};
                }

                return {success: true , data : user, error : null};
            }catch(e){
                console.error(e);
                console.log("Error in db :: OrganizationUsers :: getOrganizationUser :: ",e);
                return {success : false, data : null, error: e.message};
            }   
    }

    async getAllOrganizationUsers(uuid){
        try{
            const { data: user, error } = await this.supabase
                .from('organization_users')
                .select('*,organization:organizations(*),role:roles(name),user:users(*)')
                .eq('organization_id', uuid);

                if(error){
                    return {success : false, data : null, error: error};
                }

                return {success: true , data : user, error : null};
            }catch(e){
                console.error(e);
                console.log("Error in db :: OrganizationUsers :: getAllOrganizationUsers :: ",e);
                return {success : false, data : null, error: e.message};
            }  
    }
}

const organizationUsersTable = new OrganizationUsersTable();

export default organizationUsersTable;