<script>
  import { onMount } from "svelte";
  import FormBackground from "../lib/components/FormBackground.svelte";
  import RootLayout from "../lib/components/layout/RootLayout.svelte";
  import organizationTable from "../lib/supabase/database/organizationTable";
  import authService from "../lib/supabase/auth";
  import organizationUsersTable from "../lib/supabase/database/organiztionUserTable";
  import { authStore } from "../lib/store";
  import { callWhenDependencyChange } from "../lib/utils/depenecy";
  import Heading from "../lib/components/form/Heading.svelte";
  import Button from "../lib/components/form/Button.svelte";
  import { Link } from "svelte-routing";
  import url_path from "../lib/config/pathConfigs";
  import CompanyProfile from "../lib/components/company/CompanyProfile.svelte";
  import Company from "../lib/components/register/Company.svelte";
  import CompanyUser from "../lib/components/company/CompanyUser.svelte";
  import OrganizationUsers from "../lib/components/company/OrganizationUsers.svelte";
  import OrganizationGroups from "../lib/components/company/OrganizationGroups.svelte";

  onMount(() => {});

  let company_loading = false;
  let company_error = "";

  let company_data = {
    profile: null,
    organizationUsers: [],
    organizations: [],
  };

  const getUserCompanies = async () => {
    try {
      if (!$authStore?.userData?.id) {
        return;
      }
      company_loading = true;
      const result = await organizationUsersTable.getOrganizationUser(
        $authStore?.userData?.id
      );


      if (result.success && result.data.length > 0) {
        company_data.profile = result.data;
        company_data.organizations = result?.data?.[0]?.organization;
        const org_users_result = await organizationUsersTable.getAllOrganizationUsers(company_data?.organizations?.id);
        if (org_users_result.success){
          company_data.organizationUsers = org_users_result.data;
        }else{
        company_error = org_users_result.error;
        }

      } else {
        company_error = "";
      }

      //   get Companey

      // if (company_data.profile) {
      //   const { success, data, error } =
      //     await organizationTable.getOrganization(
      //       company_data?.profile?.[0]?.organization_id
      //     );

      //     if(success){
      //         company_data.organizations = data;
      //     }else{
      //         // @ts-ignore
      //         company_error = error;
      //     }
      // }

      company_loading = false;
    } catch (e) {
      company_error = e.message;
    }
  };

  $: callWhenDependencyChange(() => {
    getUserCompanies();
  }, $authStore.profile);
</script>

<RootLayout pageHeading={"/Company"}>
  <FormBackground error={company_error} loading={company_loading} widthIncrease>
    {#if company_data.profile && company_data.profile.length > 0}
      <div class=" max-w-3xl mx-auto w-full">
        <CompanyProfile company_data={company_data.organizations}/>
        <CompanyUser company_profile={company_data.profile}/>
        <hr />
        <OrganizationUsers company_profile={company_data} />
        <OrganizationGroups company_profile={company_data}/>
      </div>
    {:else}
      <div class="grid grid-cols-1">
        <Heading>No company found!</Heading>
        <div>
          <Link to={url_path.company_registration}>
            <Button>Register Company</Button>
          </Link>
        </div>
      </div>
    {/if}
  </FormBackground>
</RootLayout>

<style>
</style>
