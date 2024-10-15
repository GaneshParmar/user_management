<script>
  // @ts-nocheck

  import { onMount } from "svelte";
  import rolesTable from "../../supabase/database/roleTable";
  import FormBackground from "../FormBackground.svelte";
  import Button from "../form/Button.svelte";
  import NextSvg from "../../svg/NextSvg.svelte";
  import organizationTable from "../../supabase/database/organizationTable";
  import { authStore } from "../../store";
  import { navigate } from "svelte-routing";
  import url_path from "../../config/pathConfigs";
  import organizationUsersTable from "../../supabase/database/organiztionUserTable";
  import showToastLoadingWhileFunctionRun from "../../toast/Loading";
  import toast from "svelte-french-toast";

  let roles = [];
  let roles_error = "";
  onMount(async () => {
    const { success, data, error } = await rolesTable.getAllRoles();

    if (success) {
      roles = data;
    } else {
      roles_error = error;
    }
  });

  let user_role = 1;
  let organization_name = "";
  let create_company_loading = false;

  let error_ = "";
  const handleCreateCompany = async () => {
    try{

      if (!$authStore.status) {
        navigate(url_path.login);
      }
  
  
      create_company_loading = true;
      let { success, data : company_data , error } = await organizationTable.createOrganization(
        { organization_name, uuid : $authStore?.userData?.id }
      );
      create_company_loading = false;
  
      if (success) {
        // create organization user with admin true
        let { success, data, error } =
          await organizationUsersTable.addOrganizationUser({uuid : $authStore.userData.id, organization_id : company_data.id, role_id : user_role , is_admin : true});
      
        if(success){
          navigate(url_path.company_page);
        }
        } else {
          console.error("Error :: handleCreateCompany :: ", error);
          error_ = error;
          throw new Error(error)
      }
      error_ = error;

    }catch(e){
      console.log("Error while creating company :: ",e.message);
      throw new Error(e);
    }
};

</script>

<FormBackground error={error_}>
  <form on:submit={(e)=>{e.preventDefault();
    showToastLoadingWhileFunctionRun(handleCreateCompany, toast, `Creating company ${organization_name}`, "Done")}}>
    <div class="p-4">
      <h1 class="text-3xl text-center">Company Registration</h1>
      <div class="w-full max-w-4xl mx-auto p-4 m-4 flex flex-col gap-y-2">
        <div class="flex items-center gap-2">
          <i class="fa-solid fa-building absolute ml-2"></i>
          <input
            class="w-full px-8 py-4 rounded-lg font-medium bg-gray-100 border border-gray-200 placeholder-gray-500 text-sm focus:outline-none focus:border-gray-400 focus:bg-white"
            type="text"
            placeholder="Company Name"
            required
            bind:value={organization_name}
          />
        </div>

        <!-- Select role -->
        <div class="flex gap-2 flex-col">
          <label> Select Role </label>
          <select
            class="w-full px-8 py-4 rounded-lg font-medium bg-gray-100 border border-gray-200 placeholder-gray-500 text-sm focus:outline-none focus:border-gray-400 focus:bg-white disabled:bg-gray-300 disabled:text-gray-500 disabled:cursor-not-allowed"
            bind:value={user_role}
          >
            {#each roles as role, i}
              <option value={role.id}>
                {role.name}
              </option>
            {/each}
          </select>
          {#if roles_error}
            <p class="text-red-400">
              {roles_error}
            </p>
          {/if}
        </div>

        <div class="flex items-center gap-2">
          <Button type={"submit"} loading={create_company_loading}>
            <div class="flex items-center justify-center">
              Create Company <NextSvg />
            </div>
          </Button>
        </div>
      </div>
    </div>
  </form>
</FormBackground>

<style>
</style>
