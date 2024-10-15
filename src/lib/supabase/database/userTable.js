import authService from "../auth";

export class UserTable {
    supabase;
    constructor() {
        this.supabase = authService.supabase;
    }

    async addUser({uuid, email, full_name}) {
        try{

            console.log(full_name)
            const { data, error } = await this.supabase
                .from('users')
                .insert([
                    { id: uuid, email, full_name },
                ])
                .select();

                if(error){
                    console.error(error)
                    throw new Error(error);
                }
                console.log("Add user data :: ",data);
                return { success: true, data, error};
            }catch(e){
                console.log(e)
                console.log("Error in db :: UserTable :: addUser :: ",e.message);
            }
            
            return  { success: false, data : null, error : 'Something went wrong'};;
        
    }

    async updateUser({uuid, email, full_name}) {
        try{

            console.log(full_name)
            const { data, error } = await this.supabase
                .from('users')
                .update([
                    { email, full_name },
                ])
                .eq("id", uuid)
                .select();

                if(error){
                    console.error(error)
                    throw new Error(error);
                }
                console.log("Update user data :: ",data);
                return true;
            }catch(e){
                console.log(e)
                console.log("Error in db :: UserTable :: updateUser :: ",e.message);
            }
            
            return false;
        
    }

    async getUser(uuid) {
        try{
            const { data: user, error } = await this.supabase
                .from('users')
                .select()
                .eq('id', uuid);

                if(error){
                    throw new Error(error);
                }

                return user;
            }catch(e){
                console.log("Error in db :: UserTable :: getUser :: ",e.message);
                console.error(e);
            }
            
            return null;
        
    }
}

const userTable = new UserTable();

export default userTable;