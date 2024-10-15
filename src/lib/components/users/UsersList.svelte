<script>
  // @ts-nocheck

  import { stringify } from "uuid";
  import MultiSelectTable from "../form/MultiSelectTable.svelte";

  export let users_data;
  export let selected_users;
  export let footerBtns;
</script>

<MultiSelectTable
  table_data={users_data}
  bind:selected={selected_users}
  table_headings={[
    "Name:organization_users.users.full_name",
    "Email:organization_users.users.email",
  ]}
  {footerBtns}
/>

<style>
</style>
