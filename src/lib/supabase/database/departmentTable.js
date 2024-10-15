import authService from "../auth";
import organizationUsersTable from "./organiztionUserTable";

export class DepartmentTable {
    supabase;
    constructor() {
        this.supabase = authService.supabase;
    }

    async addDepartment({ organization_id, department_name }) {
        try {

            const { data, error } = await this.supabase
                .from('department')
                .insert([
                    { organization_id, name: department_name },
                ])
                .select();


            if (error) {
                console.error(error)
                return { success: false, data, error };
            }
            console.log("Create department data :: ", data);
            return { success: true, data: data[0] };
        } catch (e) {
            console.log(e)
            console.log("Error in db :: Organizations :: add department :: ", e.message);
            return { success: false, data: null, error: e.message };
        }
    }

    async getOrganizationDepartments({ organization_id }) {
        try {

            const { data, error } = await this.supabase
                .from('department')
                .select("*")
                .eq('organization_id', organization_id)


            if (error) {
                console.error(error)
                return { success: false, data, error };
            }
            console.log("getOrganizationDepartments data :: ", data);
            return { success: true, data: data };
        } catch (e) {
            console.log(e)
            console.log("Error in db :: Organizations :: addUserToDepartment :: ", e.message);
            return { success: false, data: null, error: e.message };
        }
    }

    async removeDepartmentFromOrganization({ department_id, organization_id }) {

        try {
            const { error } = await this.supabase
                .from('department')
                .delete()
                .eq('organization_id', organization_id)
                .eq('id', department_id);


            if (error) {
                throw new Error(error)
            }
        } catch (e) {
            console.log("Error :: removeDepartmentFromOrganization :: ", e.message);
            throw new Error(e);
        }

    }


}

const departmentTable = new DepartmentTable();

export default departmentTable;