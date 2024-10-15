<script>
  import toast from "svelte-french-toast";
  import Button from "../form/Button.svelte";
  import Heading from "../form/Heading.svelte";
  import Input from "../form/Input.svelte";
  import Modal from "../modal/Modal.svelte";
  import showToastLoadingWhileFunctionRun from "../../toast/Loading";
  import departmentTable from "../../supabase/database/departmentTable";
  import { callWhenDependencyChange } from "../../utils/depenecy";
  import CompanyDepartments from "./CompanyDepartments.svelte";

  export let company_profile;

  let open_add_group_modal = false;

  let group_modal = {
    error: false,
    icon: false,
    heading: "Add department",
    successTxt: "Add User",
    cancelTxt: "Close",
    successCallback: () => {},
    cancelCallback: () => {
      open_add_group_modal = false;
    },
    hidefooter: true,
    theme: "info", // success | warning | info | error
  };

  let department_name = "";
  $: organization_id = company_profile?.profile?.[0]?.organization_id;
  let organization_department = [];
  
  async function getDepartments(params) {
    const { success, data, error } =
      await departmentTable.getOrganizationDepartments({ organization_id });

    organization_department = data;
    if (success) {
    }
  }
  const callback = callWhenDependencyChange(getDepartments, organization_id);
  $: {
    callback(organization_id);
  }

  const addDepartmentToOrganization = async ({
    department_name,
    organization_id,
  }) => {
    const { success, data, error } = await departmentTable.addDepartment({
      department_name,
      organization_id,
    });
    if (error) {
      throw new Error(error);
    }
  };

  const AddDepartment = (e) => {
    e.preventDefault();
    if (!organization_id) {
      toast.error("Invalid organization id");
      return;
    }
    const callback = async () => {
      await addDepartmentToOrganization({ department_name, organization_id });
      getDepartments();
      closeAddDepartment();
      // location.reload();
    };
    showToastLoadingWhileFunctionRun(
      callback,
      toast,
      "Adding department...",
      "Added"
    );
   
  };

  const openAddDepartment = () => {
    open_add_group_modal = true;
  };

  const closeAddDepartment = () => {
    open_add_group_modal = false;
  };
</script>

<!-- Group add modal -->

<Modal modal={group_modal} bind:isOpen={open_add_group_modal}>
  <form on:submit={AddDepartment}>
    <div class="grid grid-cols-1">
      <Input bind:value={department_name} label={"Name"} placeholder="HR" />
      <Button type={"submit"} variant={"success"}>Add</Button>
    </div>
  </form>
</Modal>
<div class="grid grid-cols-1 py-4 my-4 bg-slate-100">
  <Heading>Organization Departments</Heading>
  {#if organization_department.length > 0}
    <CompanyDepartments
      departments={organization_department}
      {organization_id}
      {openAddDepartment}
    />
  {:else}
    <div class="grid grid-cols-1 gap-2 my-2">
      <Heading heading_size={"4"}>No department found!</Heading>
      <div>
        <Button handleClick={openAddDepartment}>
          <div class="flex items-center">
            Add <Heading heading_size={"4"}>+</Heading>
          </div>
        </Button>
      </div>
    </div>
  {/if}
</div>

<style>
</style>
