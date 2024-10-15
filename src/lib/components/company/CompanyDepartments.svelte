<script>
  // @ts-nocheck

  import { stringify } from "uuid";
  import Button from "../form/Button.svelte";
  import Input from "../form/Input.svelte";
  import MultiSelectTable from "../form/MultiSelectTable.svelte";
  import Modal from "../modal/Modal.svelte";
  import toast from "svelte-french-toast";
  import organizationUsersTable from "../../supabase/database/organiztionUserTable";
  import { callWhenDependencyChange } from "../../utils/depenecy";
  import departmentUsersTable from "../../supabase/database/departmentUsersTable";
  import showToastLoadingWhileFunctionRun from "../../toast/Loading";
  import UsersListModal from "../users/UsersListModal.svelte";
  import ConfirmModal from "../utils/ConfirmModal.svelte";
  import departmentTable from "../../supabase/database/departmentTable";

  export let departments;
  export let organization_id;
  export let openAddDepartment;

  let open_add_department_user = false;
  let departmentSelected = {};

  let selected_users = [];

  const addOrganizationUserToDepartment = async ({
    organization_user_id,
    department_id,
  }) => {
    const { success, data, error } =
      await departmentUsersTable.addUserToDepartment({
        organization_user_id,
        department_id,
      });
    if (error) {
      throw new Error(error);
    }
  };

  let department_table_btns = {
    "Add to department": {
      onClick: async () => {
        if (selected_users.length == 0) {
          toast.error("Please select users to add");
          return;
        }
        if (!departmentSelected?.id) {
          toast.error(
            "Please select the valid department or add it under your organization"
          );
          return;
        }

        const addUsers = async () => {
          for (const selected_user of selected_users) {
            let organization_user_id = selected_user.user_id;
            await addOrganizationUserToDepartment({
              organization_user_id,
              department_id: departmentSelected?.id,
            });
          }

          // resetting the ui so it loads
          open_add_department_user = false;
          departmentSelected = { id: -1 };
          departmentSelected = departmentSelected;
          selected_users = [];
        };

        showToastLoadingWhileFunctionRun(
          addUsers,
          toast,
          "Please wait while we add users to department"
        );
      },
    },
  };

  let user_data = [];
  let departmentUsers = [];

  async function getOrganizationUsers(departmentSelectedId) {
    if (!departmentSelected?.id) {
      return;
    }

    const { success, data } =
      await organizationUsersTable.getAllOrganizationUsers(organization_id);

    user_data = data;

    const departmentUsersResult =
      await departmentUsersTable.getUsersOfDepartment({
        department_id: departmentSelected?.id,
      });

    if (departmentUsersResult.success) {
      departmentUsers = departmentUsersResult.data;
    } else {
      toast.error(departmentUsersResult.error);
    }

    console.log("Selected Department Users are ", departmentUsers);

    const department_user_ids = departmentUsers.map(
      (user) => user.organization_user_id
    );

    // Filter out users which are already present in the department
    user_data = user_data.filter(
      (user) => !department_user_ids?.includes(user.user_id)
    );
  }
  const getUsersList = callWhenDependencyChange(
    getOrganizationUsers,
    departmentSelected?.id
  );

  $: {
    getUsersList(departmentSelected?.id);
  }

  $: department_modal = {
    error: false,
    icon: false,
    heading: `Add user to ${departmentSelected?.name} (department)`,
    successTxt: "Add User",
    cancelTxt: "Close",
    successCallback: () => {},
    cancelCallback: () => {
      open_add_department_user = false;
    },
    hidefooter: true,
    theme: "info", // success | warning | info | error
    dialogSize: false,
  };

  let view_users_modal_open = false;

  let confirmCallback = () => {};
  let confirm_open = false;
  const deleteDepartment = async(department, confirm = false) => {
    if (!confirm) {
      confirm_open = true;
      confirmCallback = () => {
        const callback = async()=>{ await deleteDepartment(department, true)};

        showToastLoadingWhileFunctionRun(callback, toast, "Please wait deleting the department", "Deleted Sucessfully");
      };
    } else {
      confirm_open = false;

      const deleteDepartment = await departmentTable.removeDepartmentFromOrganization({organization_id, department_id: department.id});

      try{
        departments = departments.filter((department)=> !(department.id == department.id))
      }catch(e){
        console.error(e)
      }
    }
  };
</script>

<!-- delete confirm -->
<ConfirmModal bind:confirm_open successCallback={confirmCallback}
>
Please note deleting the department will also remove the users from it.
</ConfirmModal>

<div class="grid grid-cols-1 md:grid-cols-3 gap-2 p-2">
  {#each departments as department}
    <div
      class="min-w-12 min-h-12 border rounded hover:scale-105 grid grid-cols-1 shadow-lg p-2 bg-white group"
    >
      <h4 class="text-center flex justify-center items-center">
        {department.name}
        <button
          class="text-red-500 mx-2 invisible group-hover:visible"
          on:click={() => {
            deleteDepartment(department);
          }}
        >
          <i class="fa-solid fa-trash"></i>
        </button>
      </h4>
      <div class="text-center mt-2">
        <!-- <a href={`${$authStore.status ? buy_link : "/login"}`}>
        </a> -->
        <Button
          variant={"warning"}
          handleClick={() => {
            departmentSelected = { ...department };
            view_users_modal_open = true;
          }}
          >View Users <i class="fa-regular fa-eye"></i>
        </Button>
      </div>
      <div class="text-center mt-2">
        <!-- <a href={`${$authStore.status ? buy_link : "/login"}`}>
        </a> -->
        <Button
          handleClick={() => {
            departmentSelected = { ...department };
            open_add_department_user = true;
          }}>Add User <i class="fa-solid fa-user-plus"></i></Button
        >
      </div>
    </div>
  {/each}
  <button
    class={`min-w-12 min-h-12 rounded hover:scale-105 grid grid-cols-1 p-2 flex justify-center items-center mx-auto ${departments.length > 0? '':'col-span-full'}`}
    on:click={openAddDepartment}
  >
    Add department
    <div
      class="h-16 w-16 rounded-full shadow mx-auto flex justify-center items-center"
    >
      <i class="fa-regular fa-address-book"></i>
      <i class="fa-solid fa-plus"></i>
    </div>
  </button>
</div>

<Modal bind:isOpen={open_add_department_user} modal={department_modal}>
  <div class="grid grid-cols-1">
    <MultiSelectTable
      bind:selected={selected_users}
      table_data={user_data}
      footerBtns={department_table_btns}
      table_headings={["Name:user.full_name", "Email:user.email"]}
    />
  </div>
</Modal>

<UsersListModal
  bind:open={view_users_modal_open}
  users_data={departmentUsers}
  bind:departmentSelected
/>

<style>
</style>
