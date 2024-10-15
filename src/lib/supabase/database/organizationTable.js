import authService from "../auth";
import organizationUsersTable from "./organiztionUserTable";

export class OrganizationTable {
    supabase;
    constructor() {
        this.supabase = authService.supabase;
    }

    async createOrganization({ organization_name, uuid }) {
        try {

            let result = await organizationUsersTable.getOrganizationUser(uuid);
            let organization_user = result.data;
            if (organization_user && organization_user.length > 0) {
                // already exist
                return { success: false, error: 'Organization user already exist!', data: organization_user };
            }

            const { data, error } = await this.supabase
                .from('organizations')
                .insert([
                    { name: organization_name },
                ])
                .select();

            if (error) {
                console.error(error)
                return { success: false, data, error };
            }
            console.log("Create organization data :: ", data);
            return { success: true, data: data[0] };
        } catch (e) {
            console.log(e)
            console.log("Error in db :: Organizations :: addOrganization :: ", e.message);
            return { success: false, data: null, error: e.message };
        }


    }

    async getOrganization(uuid) {
        try {
            const { data, error } = await this.supabase
                .from('organizations')
                .select()
                .eq('id', uuid);

            if (error) {
                return { success: true, data, error };
            }

            return { success: true, data, error };
        } catch (e) {
            console.log("Error in db :: Organizations :: getOrganization :: ", e);
        }

        return null;

    }
}

const organizationTable = new OrganizationTable();

export default organizationTable;