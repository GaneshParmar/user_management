import authService from "../auth";
import organizationUsersTable from "./organiztionUserTable";

export class DepartmentUsersTable {
    supabase;
    constructor() {
        this.supabase = authService.supabase;
    }

    async addUserToDepartment({ organization_user_id, department_id }) {
        try {

            const { data, error } = await this.supabase
                .from('department_users')
                .insert([
                    { organization_user_id, department_id },
                ])
                .select();


            if (error) {
                console.error(error)
                return { success: false, data, error };
            }
            console.log("addUserToDepartment data :: ", data);
            return { success: true, data: data[0] };
        } catch (e) {
            console.log(e)
            console.log("Error in db :: Organizations :: addUserToDepartment :: ", e.message);
            return { success: false, data: null, error: e.message };
        }
    }

    async getUsersOfDepartment({ department_id, from = 0, to = 100 }) {
        try {

            const { data, error } = await this.supabase
                .from('department_users')
                .select("*,organization_users(*,users(*))")
                .eq('department_id', department_id)
                .range(from, to)


            if (error) {
                console.error(error)
                return { success: false, data, error };
            }
            console.log("Users in the department :: data :: ", data);
            return { success: true, data: data };
        } catch (e) {
            console.log(e)
            console.log("Error in db :: Organizations :: addUserToDepartment :: ", e.message);
            return { success: false, data: null, error: e.message };
        }
    }


    async removeUserFromDepartment({ department_id, organization_user_id }) {

        try{
            const { error } = await this.supabase
                .from('department_users')
                .delete()
                .eq('organization_user_id', organization_user_id)
                .eq('department_id', department_id);
    
    
            if(error){
                throw new Error(error)
            }
        }catch(e){
            console.log("Error :: removeUserFromDepartment :: ",e.message);
            throw new Error(e);
        }

    }
}



const departmentUsersTable = new DepartmentUsersTable();

export default departmentUsersTable;