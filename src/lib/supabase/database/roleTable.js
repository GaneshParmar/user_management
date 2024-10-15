import authService from "../auth";

export class RolesTable {
    supabase;
    constructor() {
        this.supabase = authService.supabase;
    }

    getAllRoles = async () => {

        try{
            let { data: roles, error } = await this.supabase
                .from('roles')
                .select('*,organization_users(*)')

            return {
                success: !error ? true : false,
                data : roles,
                error
            }
        } catch(e){
            console.log("Error RolesTable :: getAllRoles :: ",e.message);
        }

        return false;
    }
}

const rolesTable = new RolesTable();

export default rolesTable;