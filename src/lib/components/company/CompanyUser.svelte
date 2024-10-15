<script>
  import Input from "../form/Input.svelte";

  export let company_profile;

  $: company_profile = Array.isArray(company_profile) ? company_profile : [company_profile];
</script>

{#if company_profile}
    {#each company_profile as profile}
        <Input label={"Name"} value={profile?.user?.full_name} disabled/>
        <Input label={"Role"} value={profile?.role?.name} disabled/>
        <Input label={"Is Admin"} value={profile?.is_admin? "Yes" : "No"} disabled/>
    {/each}
{/if}

<style>
</style>
